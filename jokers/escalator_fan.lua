SMODS.Joker {
    key = "escalator_fan",
    config = {
        extra = 2,
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 0 },
    soul_pos = { x = 2, y = 9 },
    -- Card info
    rarity = 4, --LEGENDARY!
    cost = 20,
    -- Player data
    unlocked = false,
    unlock_condition = {type = '', extra = '', hidden = true},
    discovered = false,
    -- Compatibility
    blueprint_compat = true,   -- FALSE for passive Jokers
    perishable_compat = true,  -- FALSE for scaling Jokers
    eternal_compat = true,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_hacker_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.extra
            },
        }
    end,

    calculate = function (self, card, context)
        if context.other_joker then
            if not context.other_joker.config.center.perishable_compat or context.other_joker.config.center.key == 'j_yorick' or context.other_joker.config.center.key == 'j_caino' or context.other_joker.config.center.key == 'j_egg' then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
                    Xmult_mod = card.ability.extra
                }
            end
        end
    end
}