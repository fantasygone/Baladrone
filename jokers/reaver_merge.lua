SMODS.Joker {
    key = "reaver_merge",
    config = {
        alignment = 'reaver',
        extra = {
            xmult = 2
        }
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 0, y = 12 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 4,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_reaver_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.extra.xmult,
            }
        }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}