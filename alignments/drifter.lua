CrazyStairs.Alignment {
    key = "drifter",
    config = {
        type = 'drifter',
    },
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 0, y = 0 },
    undisc_pos = { x = 0, y = 1 },
    overlay_undisc_pos = { x = 0, y = 2 },
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
        cs_utils.morph_to_alignment(self.config.type)
    end,
}