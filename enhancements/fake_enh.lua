SMODS.Enhancement({
    key = "fake",
    config = {
        alignment = 'joker'
    },
    atlas = "CrazyStairsSeals_atlas",
    pos = {x = 0, y = 1},
    weight = 0,
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)

    end,

    in_pool = function(self, args)
        return not cs_utils.is_alignment(self.config.alignment)
    end
})