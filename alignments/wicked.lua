CrazyStairs.Alignment {
    key = "wicked",
    config = {
        type = 'wicked',
    },
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 3, y = 0 },
    undisc_pos = { x = 3, y = 1 },
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
        G.GAME.current_alignment = 'wicked'
    end,

    calculate = function (self, card, context)
    end
}