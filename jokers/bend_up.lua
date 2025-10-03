SMODS.Joker {
    key = "bend_up",
    config = {
        alignment = 'wicked',
        extra = {
            hand = nil,
            level = nil,
            best_level = nil,
            remove_level = 1
        }
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 5, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 3, --Rare
    cost = 8,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,  -- FALSE for passive Jokers
    perishable_compat = true,  -- FALSE for scaling Jokers
    eternal_compat = true,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.extra.remove_level or 1
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.hands) do
            if v.visible then
                G.GAME.hands[k].level = G.GAME.hands[k].level - 1
                G.GAME.hands[k].mult = math.max(G.GAME.hands[k].s_mult + G.GAME.hands[k].l_mult*(G.GAME.hands[k].level - 1), 1)
                G.GAME.hands[k].chips = math.max(G.GAME.hands[k].s_chips + G.GAME.hands[k].l_chips*(G.GAME.hands[k].level - 1), 0)
                -- level_up_hand(nil, k, true, -1)
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.level and card.ability.extra.hand then
            level_up_hand(card, card.ability.extra.hand, true, card.ability.extra.level - G.GAME.hands[card.ability.extra.hand].level)
        end

        for k, v in pairs(G.GAME.hands) do
            if v.visible then
                G.GAME.hands[k].level = G.GAME.hands[k].level + 1
                G.GAME.hands[k].mult = math.max(G.GAME.hands[k].s_mult + G.GAME.hands[k].l_mult*(G.GAME.hands[k].level - 1), 1)
                G.GAME.hands[k].chips = math.max(G.GAME.hands[k].s_chips + G.GAME.hands[k].l_chips*(G.GAME.hands[k].level - 1), 0)
            end
        end
    end,

    calculate = function (self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                local best_hand_level = G.GAME.hands[pseudorandom_element(cs_utils.get_most_upgraded_hands(), pseudoseed('bend_up_best_hand'))].level

                local hand_name = pseudorandom_element(cs_utils.get_least_upgraded_hands(), pseudoseed('bend_up_random_hand'))
                local hand_data = G.GAME.hands[hand_name]

                if hand_data and hand_data.level < best_hand_level then
                    card.ability.extra.hand = hand_name
                    card.ability.extra.level = hand_data.level
                    card.ability.extra.best_level = best_hand_level

                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                        play_sound('cs_bend')
                    return true end }))
                    SMODS.calculate_effect({message = localize('cs_bend_up'), colour =  G.C.ALIGNMENT['cs_wicked']}, card)
                    level_up_hand(card, hand_name, nil, best_hand_level - hand_data.level)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                end
            return true end }))
        end

        if context.scoring_hand and context.after and not context.blueprint then
            if card.ability.extra.hand and G.GAME.hands[card.ability.extra.hand].level > card.ability.extra.level then
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0,func = function()
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                        play_sound('cs_bend')
                    return true end }))
                    SMODS.calculate_effect({message = localize('k_reset'), colour =  G.C.ALIGNMENT['cs_wicked']}, card)
                    level_up_hand(card, card.ability.extra.hand, nil, card.ability.extra.level - G.GAME.hands[card.ability.extra.hand].level)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})

                    card.ability.extra.hand = nil
                    card.ability.extra.level = nil
                    card.ability.extra.best_level = nil
                return true end }))
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}