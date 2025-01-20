SMODS.Joker {
    key = "downwards_escalator",
    config = {
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 9 },
    soul_pos = nil,
    -- Card info
    rarity = 3, --Rare, possibly Uncommon tho
    cost = 7,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers
    perishable_compat = false,  -- FALSE for scaling Jokers
    eternal_compat = false,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_hacker_aligned', set = 'Other'}
        return {
            vars = {
            },
        }
    end,

    calculate = function (self, card, context)
    end
}