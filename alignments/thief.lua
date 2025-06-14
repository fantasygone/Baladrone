CrazyStairs.Alignment {
    key = "thief",
    config = {
        type = 'thief',
    },
    -- Sprite settings
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 7, y = 0 },
    undisc_pos = { x = 7, y = 1 },
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
        G.GAME.current_alignment = 'thief'
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            cs_utils.random_aligned_joker()
        return true end }))

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            if not CrazyStairs.BUTTONS_CREATED then
                CrazyStairs.create_thief_buttons()
            end
        return true end }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            if CrazyStairs.BUTTONS_CREATED and not cs_utils.is_alignment(card.ability.type) then
                G.GAME.alignment_buttons:remove()
                CrazyStairs.BUTTONS_CREATED = false

                cs_utils.return_stolen_cards(G.deck)
            end
        return true end }))
    end,

    calculate = function (self, card, context)
    end,
}