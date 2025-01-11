SMODS.Enhancement({
    key = "fake",
    atlas = "CrazyStairsSeals_atlas",
    pos = {x = 0, y = 0},
    config = {},
    weight = 0,
    
    loc_vars = function(self, info_queue, card)
        -- info_queue[#info_queue+1] = {key = 'cs_fake_card', set = 'Other'}

        return {
            vars = {}
        }
    end,
    calculate = function(self, card, context)

    end,

    in_pool = function(self, args)
        return false, false
    end
})