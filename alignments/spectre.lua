CrazyStairs.Alignment {
    key = "spectre",
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 10, y = 0 },
    undisc_pos = { x = 10, y = 1 },
    -- Player data
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {}
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.current_alignment = 'spectre'
    end,

    calculate = function (self, card, context)
    end
}