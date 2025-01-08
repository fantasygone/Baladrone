local cs_utils = dofile(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")
return {
    key = "flipper",
    loc_txt = {
        name = "Flipper",
        text = {},
    },
    config = {
    },
    rarity = 3,
    pos = { x = 0, y = 2 },
    atlas = "CrazyStairs_atlas",
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_joker_aligned', set = 'Other'}
        return {vars = {}}
    end,

    calculate = function (self, card, context)

    end
}