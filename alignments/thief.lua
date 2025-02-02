CrazyStairs.Alignment {
    key = "thief",
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 7, y = 0 },
    undisc_pos = { x = 7, y = 1 },
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
        G.GAME.current_alignment = 'thief'
    end,

    calculate = function (self, card, context)
    end
}