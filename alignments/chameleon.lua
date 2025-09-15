CrazyStairs.Alignment {
    key = "chameleon",
    config = {
        type = 'chameleon',
    },
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 11, y = 0 },
    undisc_pos = { x = 11, y = 1 },
    overlay_undisc_pos = { x = 11, y = 2 },
    -- Player data
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {}
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        cs_utils.morph_to_alignment(self.config.type)

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            if not CrazyStairs.BUTTONS_CREATED then
                CrazyStairs.create_thief_buttons()
            end
        return true end }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            -- Temporary check until more alignment-specific areas are added
            if CrazyStairs.BUTTONS_CREATED and not cs_utils.is_alignment(card.ability.type) and not cs_utils.is_alignment('thief') and G.GAME.alignment_buttons then
                G.GAME.alignment_buttons:remove()
                CrazyStairs.BUTTONS_CREATED = false

                cs_utils.return_stolen_cards(G.deck)
            end
        return true end }))
    end,

    calculate = function (self, card, context)
    end,

    in_pool = function(self, args)
        return false
    end
}