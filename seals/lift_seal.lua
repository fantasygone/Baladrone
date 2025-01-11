SMODS.Seal {
    key = "lift",
    badge_colour = HEX("6c9648"),
    config = {},
    atlas = "CrazyStairsSeals_atlas",
    pos = {x= 3, y= 5},
    sound = { sound = 'cs_lift_seal_obtained', per = 1.2, vol = 0.4 },

    loc_txt = {
        name = "Lift Seal",
        label = "Lift Seal",
        text = {
            "Yes",
        },
    },

    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,

    -- self - this seal prototype
    -- card - card this seal is applied to
    calculate = function(self, card, context)
        -- repetition_only context is used for red seal retriggers
        if context.repetition and context.repetition_only and context.cardarea == G.play then
            return {
                message = localize('cs_lift'),
                repetitions = 2,
                card = card
            }
        end
    end,
}