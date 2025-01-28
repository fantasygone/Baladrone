CrazyStairs.Alignment {
    key = "joker",
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 0, y = 2 },
    -- Player data
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {}
        }
    end,

    calculate = function (self, card, context)
    end
}