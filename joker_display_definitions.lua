local jd_def = JokerDisplay.Definitions

-- Neutral

jd_def["j_cs_broken_drone"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
}

-- Patron

jd_def["j_cs_creator"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = (G.GAME and G.GAME.current_round.hands_played == 0 and localize("jdis_active") or localize("jdis_inactive"))
    end
}

jd_def["j_cs_link"] = {
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "average" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.BLUE, scale = 0.3 },

    calc_function = function(card)
        card.joker_display_values.average = card.ability.count > 0 and (math.floor(card.ability.chips_total / card.ability.count) * math.floor(card.ability.mult_total / card.ability.count)) or 0
    end
}

-- Joker

jd_def["j_cs_trap"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability", ref_value = "chips", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability", ref_value = "fake_tally" },
        { text = "/" },
        { ref_table = "card.ability", ref_value = "fakes" },
        { text = ")" },
    },
}

jd_def["j_cs_bugged_trap"] = {
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },

    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.odds } }
    end
}

-- Wicked

jd_def["j_cs_destroyer"] = {
    text = {
        { text = "Above " },
        { ref_table = "card.ability.below", ref_value = "value", colour = G.C.IMPORTANT},
    },
    text_config = { scale = 0.35 },

    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "triggered" },
        { text = ")" },
    },

    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        card.joker_display_values.triggered = localize("jdis_inactive")

        if text ~= 'Unknown' then
            local above_rank = card.ability.below.rank == 14 and 2 or (card.ability.below.rank + 1)

            for i = 1, #scoring_hand do
                local actual = scoring_hand[i]

                if actual.base.id == above_rank then
                    card.joker_display_values.triggered = localize("jdis_active")
                    break
                end
            end
        end
    end,
}

jd_def["j_cs_bend_down"] = {
    reminder_text = {
            { text = "(" },
            { text = "-", colour = G.C.ALIGNMENT['cs_wicked'] },
            { ref_table = "card.joker_display_values", ref_value = "discards", colour = G.C.ALIGNMENT['cs_wicked'] },
            { text = "%", colour = G.C.ALIGNMENT['cs_wicked'] },
            { text = ")" },
    },

    calc_function = function(card)
        card.joker_display_values.discards = G.GAME.current_round.discards_left
    end
}

jd_def["j_cs_damage"] = {
    text = {
        { text = "-", colour = G.C.ALIGNMENT['cs_wicked'] },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ALIGNMENT['cs_wicked'] },
        { text = " " },
        { ref_table = "card.joker_display_values", ref_value = "localized_card" },
    },
    text_config = { scale = 0.35 },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local is_damage_hand = text == card.ability.poker_hand
        card.joker_display_values.count = 0
        card.joker_display_values.localized_text = localize(card.ability.poker_hand, 'poker_hands')
        if is_damage_hand then
            for i = 1, #G.hand.cards do
                if i % 2 == 0 and not G.hand.cards[i].highlighted then
                    card.joker_display_values.count = card.joker_display_values.count + 1
                end
            end
        end
        card.joker_display_values.localized_card = (card.joker_display_values.count == 1) and localize('cs_card') or localize('cs_cards')
    end
}

jd_def["j_cs_four_walls"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

jd_def["j_cs_vicious_joker"] = {
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars"},
    },
    text_config = { colour = G.C.MONEY },

    reminder_text = {
        { text = "(Enhancements)" },
    },

    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        card.joker_display_values.dollars = 0

        for i = 1, #scoring_hand do
            local currentcard = scoring_hand[i]

            if currentcard.highlighted and currentcard.config.center.set == 'Enhanced' then
                card.joker_display_values.dollars = card.joker_display_values.dollars + card.ability.payout
            end
        end
    end,
}

-- Keeper

jd_def["j_cs_restoration"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability", ref_value = "played" },
        { text = "/" },
        { ref_table = "card.ability", ref_value = "to_play" },
        { text = ")" },
    },
}

-- Hacker

jd_def["j_cs_upwards_escalator"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

jd_def["j_cs_escalator_fan"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
        { text = "x" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.GREEN },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card:is_scaling() then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
        card.joker_display_values.localized_text = localize("cs_scaling")
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (card:is_scaling() and mod_joker.ability.extra ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

-- Drifter

jd_def["j_cs_strider"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = (G.GAME and G.GAME.current_round.hands_played == 0 and localize("jdis_active") or localize("jdis_inactive"))
    end
}

-- Spectre

jd_def["j_cs_random_teleport"] = {
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },

    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.odds } }
    end
}
