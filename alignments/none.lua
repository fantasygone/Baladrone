CrazyStairs.Alignment {
    key = "none",
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 12, y = 0 },
    undisc_pos = { x = 12, y = 1 },
    no_collection = true,
    -- Player data
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_tdthetv_artist', set = 'Other'}
        return {
            vars = {}
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.current_alignment = 'none'
    end,

    calculate = function (self, card, context)
    end
}