SMODS.Joker {
    key = "four_walls",
    config = {
        alignment = 'wicked',
        mult = 0,
        extra = 1
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 3, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 3, --Rare
    cost = 8,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,  -- FALSE for passive Jokers
    perishable_compat = false, -- FALSE for scaling Jokers
    eternal_compat = true,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_blocked', set = 'Other'}
        return {
            vars = {
                center.ability.mult,
                center.ability.extra,
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if from_debuff and G.GAME.blind and G.GAME.blind:get_type() == 'Small' then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_blocked'), colour = G.C.RED})

            for i = 1, #G.hand.cards do
                G.hand.cards[i]:juice_up(0.4, 0.4)
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.blind and G.GAME.blind:get_type() == 'Small' then
            for i = 1, #G.hand.cards do
                G.hand.cards[i]:juice_up(0.4, 0.4)
            end
        end
    end,

    calculate = function (self, card, context)
        if context.first_hand_drawn and G.GAME.blind:get_type() == 'Small' and not context.blueprint and not G.GAME.current_round.cs_cards_are_blocked then
            G.GAME.current_round.cs_cards_are_blocked = true

            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,func = function()
                for i = 1, #G.hand.cards do
                    G.hand.cards[i].cs_blocked = true
                    G.hand.cards[i]:juice_up(0.4, 0.4)
                end

                play_sound('cs_wall')
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_blocked'), colour = G.C.RED})
            return true end }))
        end

        if context.joker_main and card.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult}},
                mult_mod = card.ability.mult
            }
        end

        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand and G.GAME.blind:get_type() == 'Small' and G.GAME.current_round.cs_cards_are_blocked and not context.blueprint then
            G.GAME.current_round.cs_cards_are_blocked = false

            for i = 1, #G.hand.cards do
                G.hand.cards[i].cs_blocked = false
                G.hand.cards[i]:juice_up(0.4, 0.4)
            end

            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_freed'), colour = G.C.RED})
        end

        if context.pre_discard and G.GAME.current_round.cs_cards_are_blocked and not context.blueprint then
            G.GAME.current_round.cs_cards_are_blocked = false
            local discarding = {}

            for i = 1, #G.hand.cards do
                if G.hand.cards[i].highlighted and not G.hand.cards[i].getting_sliced and not G.hand.cards[i].destroyed and not G.hand.cards[i].shattered then
                    table.insert(discarding, G.hand.cards[i])
                end
            end

            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,func = function()
                G.GAME.current_round.cs_cards_are_blocked = true
                if #discarding > 0 then
                    card.ability.mult = card.ability.mult + card.ability.extra
                    local hand_count = #discarding

                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        play_sound('cs_wall')
                    return true end }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_nuh_uh'), colour = G.C.RED})

                    for i = 1, #discarding do
                        draw_card(G.discard, G.hand, i*100/hand_count,'up', true, discarding[i])
                    end
                end
            return true end }))
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}