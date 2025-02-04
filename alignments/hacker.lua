CrazyStairs.Alignment {
    key = "hacker",
    config = {
        type = 'hacker',
    },
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

    add_to_deck = function(self, card, from_debuff)
        G.GAME.current_alignment = 'hacker'
    end,

    calculate = function (self, card, context)
    end
}