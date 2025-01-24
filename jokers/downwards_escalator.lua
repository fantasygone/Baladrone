SMODS.Joker {
    key = "downwards_escalator",
    config = {
        h_plays = 1
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 9 },
    soul_pos = nil,
    -- Card info
    rarity = 3, --Rare, possibly Uncommon tho
    cost = 8,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = false,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_hacker_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.h_plays
            },
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.h_plays
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.h_plays
    end,

    calculate = function (self, card, context)
    end
}