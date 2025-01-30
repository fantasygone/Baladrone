CrazyStairs.Alignment {
    key = "wicked",
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 0, y = 2 },
    undisc_pos = { x = 1, y = 0 },
    -- Player data
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_tdthetv_artist', set = 'Other'}
        return {
            vars = {}
        }
    end,

    calculate = function (self, card, context)
    end
}