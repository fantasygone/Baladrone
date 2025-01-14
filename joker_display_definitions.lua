local jd_def = JokerDisplay.Definitions

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

jd_def["j_cs_destroyer"] = {
    text = {
        { text = "Above " },
        { ref_table = "card.ability.below", ref_value = "value", colour = G.C.IMPORTANT},
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "triggered" },
        { text = ")" },
    },

    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()

        if text ~= 'Unknown' then
            local above_rank = card.ability.below.rank == 14 and 2 or (card.ability.below.rank + 1)
            card.joker_display_values.triggered = localize("jdis_inactive")

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