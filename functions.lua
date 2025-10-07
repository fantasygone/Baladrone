do -- FLIP button for Flip Right
    G.FUNCS.cs_flip_card = function(e)
        local card = e.config.ref_table
        if not card and not card.ability.target then return end
        local card_index
        local target

        for index, c in ipairs(G.jokers.cards) do
            if c == card then
                card_index = index
                break
            end
        end

        if card_index and G.jokers.cards[card_index + 1] then
            target = G.jokers.cards[card_index + 1]

            cs_utils.add_mana(card, -card.ability.spell.mana_cost)

            cs_utils.flip_cards(target, 'before', 0.1)
            SMODS.calculate_effect({message = localize('cs_flipped'), colour =  G.C.ALIGNMENT['cs_joker']}, card)
            play_sound('cs_flip')
        end
    end

    G.FUNCS.cs_can_flip_card = function(e)
        local card = e.config.ref_table

        if card and card:cs_can_interact() and card.ability.spell.mana >= card.ability.spell.mana_cost and #G.jokers.cards > 1 and not G.GAME.blind:get_type() then
            local card_index

            for index, c in ipairs(G.jokers.cards) do
                if c == card then
                    card_index = index
                    break
                end
            end

            if card_index and G.jokers.cards[card_index + 1] then
                e.config.colour = G.C.ALIGNMENT['cs_joker']
                e.config.button = 'cs_flip_card'
                return
            end
        end

        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

do -- RESTORE button for Restoration
    G.FUNCS.cs_restore_card = function(e)
        local card = e.config.ref_table
        if not card then return end

        local cardsToRestore = {}

        cardsToRestore = cs_utils.save_debuffed_cards(G.hand.cards, cardsToRestore)
        cardsToRestore = cs_utils.save_debuffed_cards(G.jokers.cards, cardsToRestore)

        if #cardsToRestore > 0 then
            cs_utils.add_mana(card, -card.ability.spell.mana_cost)

            for _, c in ipairs(cardsToRestore) do
                table.insert(G.GAME.current_round.cs_permanent_undebuff, c)

                if c.ability and c.ability.perishable then
                    c.ability.perish_tally = 3
                end

                SMODS.debuff_card(c, 'prevent_debuff', 'restoration')
                c:juice_up(0.3, 0.3)
            end

            card.ability.played = 0

            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_restored'), colour = G.C.ALIGNMENT['cs_keeper']})
            play_sound('cs_create')
        end
    end

    G.FUNCS.cs_can_restore_card = function(e)
        local card = e.config.ref_table

        if card and card:cs_can_interact() and card.ability.spell.mana >= card.ability.spell.mana_cost and card.ability.spell.mana_cost > 0 and card.ability.played >= card.ability.to_play then
            e.config.colour = G.C.ALIGNMENT['cs_keeper']
            e.config.button = 'cs_restore_card'
            return
        end

        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.cs_access_stack = function(e)
    Baladrone.create_overlay_stack()
end

do -- Logic for Call the Orb
    G.FUNCS.cs_draw_from_deck_to_other_hands = function(e)
        if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and
            G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then 
            G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
            return true
        end

        local hand_space_2 = e or math.min(#G.deck.cards, G.hand_2.config.card_limit - #G.hand_2.cards)
        local hand_space_3 = e or math.min(#G.deck.cards, G.hand_3.config.card_limit - #G.hand_3.cards)

        delay(0.3)
        for i=1, hand_space_2 do
            draw_card(G.deck,G.hand_2, i*100/hand_space_2,'up', true)
        end

        delay(0.3)
        for i=1, hand_space_3 do
            draw_card(G.deck,G.hand_3, i*100/hand_space_3,'up', true)
        end

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            G.GAME.cs_show_call_button = true
        return true end }))
    end

    G.FUNCS.cs_can_call = function(e)
        if #G.hand.highlighted + #G.hand_2.highlighted + #G.hand_3.highlighted <= 0 or not G.GAME.cs_show_call_button then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.GREEN
            e.config.button = 'cs_call_cards_from_highlighted'
        end
    end

    G.FUNCS.cs_call_cards_from_highlighted = function(e, hook)
        G.GAME.cs_show_call_button = false

        stop_use()
        card_eval_status_text(SMODS.find_card('j_cs_call_the_orb')[1], 'extra', nil, nil, nil, {message = localize('cs_called'), colour = G.C.ALIGNMENT['cs_patron']})
        G.GAME.current_round.cs_orb_card.cards = {}

        local hand_high = {}
        for _, card in ipairs(G.hand.highlighted) do
            table.insert(hand_high, card)
        end
        for i = 1, #hand_high do
            table.insert(G.GAME.current_round.cs_orb_card.cards, hand_high[i])
        end

        local hand2_high = {}
        for _, card in ipairs(G.hand_2.highlighted) do
            table.insert(hand2_high, card)
        end
        for i = 1, #hand2_high do
            table.insert(G.GAME.current_round.cs_orb_card.cards, hand2_high[i])
        end

        local hand3_high = {}
        for _, card in ipairs(G.hand_3.highlighted) do
            table.insert(hand3_high, card)
        end
        local hand3_high = G.hand_3.highlighted
        for i = 1, #hand3_high do
            table.insert(G.GAME.current_round.cs_orb_card.cards, hand3_high[i])
        end

        G.hand:unhighlight_all()
        G.hand_2:unhighlight_all()
        G.hand_3:unhighlight_all()
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            cs_utils.return_extra_hands_to_deck(#G.hand_2.cards > 0, #G.hand_3.cards > 0, false)
        return true end }))
    end
end

