Baladrone.Alignment {
    key = "thief",
    config = {
        type = 'thief',
    },
    -- Sprite settings
    atlas = "BaladroneAlignments_atlas",
    pos = { x = 7, y = 0 },
    undisc_pos = { x = 7, y = 1 },
    overlay_undisc_pos = { x = 7, y = 2 },
    -- Player data
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_thief_start_ab', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_tdthetv_artist', set = 'Other'}
        return {
            vars = {}
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        cs_utils.morph_to_alignment(self.config.type)

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            if not Baladrone.BUTTONS_CREATED then
                Baladrone.create_thief_buttons()
            end
        return true end }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            if Baladrone.BUTTONS_CREATED and not cs_utils.is_alignment(card.ability.type) then
                G.GAME.alignment_buttons:remove()
                Baladrone.BUTTONS_CREATED = false

                cs_utils.return_stolen_cards(G.deck)
            end
        return true end }))
    end,

    calculate = function (self, card, context)
    end,
}