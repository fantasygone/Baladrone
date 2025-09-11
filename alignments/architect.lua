CrazyStairs.Alignment {
    key = "architect",
    config = {
        type = 'architect',
    },
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 13, y = 0 },
    undisc_pos = { x = 13, y = 1 },
    overlay_undisc_pos = { x = 13, y = 2 },
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
        G.GAME.current_alignment = 'architect'
    end,

    calculate = function (self, card, context)
    end,

    in_pool = function(self, args)
        return false
    end
}