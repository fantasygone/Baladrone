SMODS.Joker {
    key = "random_move",
    config = {
        alignment = 'keeper',
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 2, y = 7 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_keeper_aligned', set = 'Other'}
        return {
            vars = {}
        }
    end,

    calculate = function (self, card, context)
        if context.scoring_hand and #context.scoring_hand == 1 and not context.scoring_hand[1].debuff and context.after then
            local target = context.scoring_hand[1]
            local final_msg

            cs_utils.flip_cards({target})

            if pseudorandom('randommove'..G.GAME.round_resets.ante) < 0.25 then
                cs_utils.increase_rank(target)
                final_msg = localize('cs_rank_up')
            elseif pseudorandom('randommove'..G.GAME.round_resets.ante) < 0.5 then
                cs_utils.decrease_rank(target)
                final_msg = localize('cs_rank_down')
            elseif pseudorandom('randommove'..G.GAME.round_resets.ante) < 0.75 then
                cs_utils.increase_suit(target)
                final_msg = localize('cs_suit_up')
            else
                cs_utils.decrease_suit(target)
                final_msg = localize('cs_suit_down')
            end

            delay(0.5)
            cs_utils.unflip_cards({target})

            return {
                message = final_msg,
                colour = G.C.ALIGNMENT['cs_keeper'],
                card = card
            }
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}