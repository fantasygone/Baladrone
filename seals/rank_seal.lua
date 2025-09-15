SMODS.Seal {
    key = "rank",
    badge_colour = G.C.ALIGNMENT['cs_keeper'],
    config = {
        alignment = 'keeper'
    },
    -- Seal Info
    atlas = "BaladroneSeals_atlas",
    pos = {x= 0, y= 2},
    sound = { sound = 'cs_seal_rank_obtained', per = 1.06, vol = 0.4 },
    -- Player Data
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,

    -- self - this seal prototype
    -- card - card this seal is applied to
    calculate = function(self, card, context)
        -- repetition_only context is used for red seal retriggers
        if context.cardarea == G.play and context.scoring_hand and context.after and card.base.id ~= 14 and not card.getting_sliced and not card.destroyed then
            cs_utils.flip_cards({card})
            cs_utils.increase_rank(card)

            delay(0.5)
            cs_utils.unflip_cards({card})

            delay(0.2)
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}