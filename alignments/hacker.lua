CrazyStairs.Alignment {
    key = "hacker",
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 6, y = 0 },
    undisc_pos = { x = 6, y = 1 },
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