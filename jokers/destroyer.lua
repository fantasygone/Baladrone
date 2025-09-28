SMODS.Joker {
    key = "new_destroyer",
    config = {
        alignment = 'wicked',
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 4, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 5,
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
            vars = {}
        }
    end,

    calculate = function (self, card, context)
        if context.first_hand_drawn then
            local evalJoker = function(joker) return (G.GAME.current_round.hands_played == 0) end
            juice_card_until(card, evalJoker, true)
        end

        if context.scoring_hand and context.destroying_card and not context.destroying_card.debuff and not context.blueprint and not context.destroying_card.getting_sliced and not context.destroying_card.destroyed and not context.destroying_card.shattered and G.GAME.current_round.hands_played == 0 then
            if not cs_utils.contains(context.scoring_hand, context.destroying_card) then
                return
            elseif G.GAME.hands[context.scoring_name].level ~= G.GAME.round_resets.ante then
                return
            else
                SMODS.calculate_effect({message = localize('cs_destroyed'), colour =  G.C.ALIGNMENT['cs_wicked']}, card)
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0,func = function()
                    play_sound('cs_destroy')
                return true end }))
                return true
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}