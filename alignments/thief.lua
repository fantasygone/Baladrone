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
            end
        return true end }))
    end,

    calculate = function (self, card, context)
        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].debuff and G.jokers.cards[i].ability.can_steal then
                    SMODS.debuff_card(G.jokers.cards[i], false, 'stop_stealing')
                    G.jokers.cards[i]:juice_up(0.4, 0,4)
                end
            end
        end
    end,
}