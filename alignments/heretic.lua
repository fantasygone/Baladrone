CrazyStairs.Alignment {
    key = "heretic",
    config = {
        type = 'heretic',
    },
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 9, y = 0 },
    undisc_pos = { x = 9, y = 1 },
    overlay_undisc_pos = { x = 9, y = 2 },
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
        G.GAME.current_alignment = 'heretic'
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            cs_utils.random_aligned_joker()
        return true end }))
    end,

    calculate = function (self, card, context)
    end
}