SMODS.Seal {
    key = "rank",
    badge_colour = G.C.ALIGNMENT['cs_keeper'],
    config = {
        alignment = 'keeper'
    },
    atlas = "CrazyStairsSeals_atlas",
    pos = {x= 0, y= 2},
    sound = { sound = 'cs_seal_rank_obtained', per = 1.06, vol = 0.4 },

    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,

    -- self - this seal prototype
    -- card - card this seal is applied to
    calculate = function(self, card, context)
        -- repetition_only context is used for red seal retriggers
        if context.cardarea == G.play and context.scoring_hand and context.after and card.base.id ~= 14 and not card.getting_sliced and not card.destroyed then
            cs_utils.flip_cards({card})

            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))

            delay(0.5)

            cs_utils.unflip_cards({card})

            delay(0.2)
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}