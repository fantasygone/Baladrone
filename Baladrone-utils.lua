local cs_utils = {}

-- BASIC UTILITY
do
    function cs_utils.contains(table, element)
        for _, value in ipairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end
end

-- GAME UTILITY
do
    function cs_utils.flip_cards(cards, trigger, delay)
        if not cards[1] then
            cards = {cards}
        end

        for i=1, #cards do
            local percent = 1.15 - (i-0.999)/(#cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = trigger,delay = delay,func = function() cards[i]:flip();play_sound('card1', percent);cards[i]:juice_up(0.3, 0.3);return true end }))
        end
    end

    function cs_utils.flip_cards_noevent(cards)
        if not cards[1] then
            cards = {cards}
        end

        for i=1, #cards do
            local percent = 1.15 - (i-0.999)/(#cards-0.998)*0.3

            cards[i]:flip()
            play_sound('card1', percent)
            cards[i]:juice_up(0.3, 0.3)
        end
    end

    function cs_utils.unflip_cards(cards, trigger, delay)
        if not cards[1] then
            cards = {cards}
        end

        for i=1, #cards do
            local percent = 0.85 + (i-0.999)/(#cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = trigger,delay = delay,func = function() cards[i]:flip();play_sound('tarot2', percent, 0.6);cards[i]:juice_up(0.3, 0.3);return true end }))
        end
    end

    function cs_utils.unflip_cards_noevent(cards, trigger, delay)
        if not cards[1] then
            cards = {cards}
        end

        for i=1, #cards do
            local percent = 0.85 + (i-0.999)/(#cards-0.998)*0.3

            cards[i]:flip()
            play_sound('tarot2', percent, 0.6)
            cards[i]:juice_up(0.3, 0.3)
        end
    end

    function cs_utils.get_prev_rank_value(current)
        local prev
        if current.base.value == 'Ace' then
            prev = 'King'
        elseif current.base.value == 'King' then
            prev = 'Queen'
        elseif current.base.value == 'Queen' then
            prev = 'Jack'
        elseif current.base.value == '2' then
            prev = 'Ace'
        else
            prev = tostring(current.base.id - 1)
        end
        return prev
    end

    function cs_utils.get_next_rank_value(current)
        local prev
        if current.base.value == 'Ace' then
            prev = '2'
        elseif current.base.value == 'King' then
            prev = 'Ace'
        elseif current.base.value == 'Queen' then
            prev = 'King'
        elseif current.base.value == 'Jack' then
            prev = 'Queen'
        elseif current.base.value == '10' then
            prev = 'Jack'
        else
            prev = tostring(current.base.id + 1)
        end
        return prev
    end

    function cs_utils.decrease_rank(card)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
            local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
            local rank_suffix = card.base.id == 2 and 14 or math.max(card.base.id - 1, 2)
            if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
            elseif rank_suffix == 10 then rank_suffix = 'T'
            elseif rank_suffix == 11 then rank_suffix = 'J'
            elseif rank_suffix == 12 then rank_suffix = 'Q'
            elseif rank_suffix == 13 then rank_suffix = 'K'
            elseif rank_suffix == 14 then rank_suffix = 'A'
            end
            card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true
        end}))
    end

    function cs_utils.increase_rank(card)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
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
    end

    function cs_utils.decrease_suit(card)
        local suit_order = Baladrone.SUIT_ORDER
        local target_suit

        -- Get the current suit
        local current_index = suit_order[card.base.suit]

        -- Find the next suit (wrap around if needed)
        if current_index and current_index < #SMODS.Suit.obj_buffer then
            target_suit = SMODS.Suit.obj_buffer[current_index + 1]
        else
            target_suit = SMODS.Suit.obj_buffer[1] -- Wrap to first suit
        end

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() card:change_suit(target_suit);return true end }))
    end

    function cs_utils.increase_suit(card)
        local suit_order = Baladrone.SUIT_ORDER
        local target_suit

        -- Get the current suit
        local current_index = suit_order[card.base.suit]

        -- Find the previous suit (wrap around if needed)
        if current_index and current_index > 1 then
            target_suit = SMODS.Suit.obj_buffer[current_index - 1]
        else
            target_suit = SMODS.Suit.obj_buffer[#SMODS.Suit.obj_buffer] -- Wrap to last suit
        end

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() card:change_suit(target_suit);return true end }))
    end

    function cs_utils.remove_from_playing_cards(card)
        for i = #G.playing_cards, 1, -1 do
            if G.playing_cards[i] == card then
                table.remove(G.playing_cards, i)
                break
            end
        end
    end

    function cs_utils.is_most_played(hand)
        local triggered = true
        local play_more_than = (G.GAME.hands[hand].played or 0)

        for k, v in pairs(G.GAME.hands) do
            if k ~= hand and v.played >= play_more_than and v.visible then
                triggered = false
            end
        end

        return triggered
    end

    function cs_utils.move_cards(from, to, cards)
        for i = 1, #cards do    
            from:remove_card(cards[i])
            to:emplace(cards[i])
        end
    end
end

-- JOKER UTILITY
do
    function cs_utils.get_random_warning()
        local index = math.random(#impostor_warnings)
        return impostor_warnings[index]
    end

    function cs_utils.broken_drone_interaction(new_card)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            local cs_broken_drone = SMODS.find_card('j_cs_broken_drone')
            if #cs_broken_drone >= 2 then
                for i = 1, #cs_broken_drone - 1 do
                    if not new_card.getting_sliced then
                        cs_broken_drone[i].ability.x_mult = cs_broken_drone[i].ability.x_mult + cs_broken_drone[i].ability.extra
                        card_eval_status_text(cs_broken_drone[i], 'extra', nil, nil, nil, {message = cs_utils.get_random_warning(), colour = G.C.RED})
                        card_eval_status_text(new_card, 'extra', nil, nil, nil, {message = localize('cs_false'), colour = G.C.GREEN})
                        if not new_card.ability.eternal then
                            new_card.getting_sliced = true
                            SMODS.destroy_cards(new_card)

                            card_eval_status_text(cs_broken_drone[i], 'extra', nil, nil, nil, {message = 'X' .. cs_broken_drone[i].ability.x_mult .. ' Mult', colour = G.C.RED})
                        else
                            card_eval_status_text(cs_broken_drone[i], 'extra', nil, nil, nil, {message = 'X' .. cs_broken_drone[i].ability.x_mult .. ' Mult', colour = G.C.RED})
                            delay(0.4)
                            card_eval_status_text(cs_broken_drone[i], 'extra', nil, nil, nil, {message = localize('cs_smh'), colour = G.C.RED})
                        end
                    end
                end
            end
        return true end }))
    end
end

-- UI UTILITY
do
    function cs_utils.refresh_play_discard_UI()
        if G.buttons then
            G.buttons:remove()
            G.buttons = UIBox{
                definition = create_UIBox_buttons(),
                config = {align="bm", offset = {x=0,y=0.3},major = G.hand, bond = 'Weak'}
            }
        end
    end
end

-- RESET CARDS
do
    function cs_utils.reset_above_card(card, seed)
        card.ability.below.value = 'Ace'
        card.ability.below.rank = 14

        if not G.playing_cards then
            return
        end

        local valid_above_ranks = {}
        for k, v in ipairs(G.playing_cards) do
            if v.ability.effect ~= 'Stone Card' then
                valid_above_ranks[#valid_above_ranks+1] = v
            end
        end
        if valid_above_ranks[1] then 
            local above_card = pseudorandom_element(valid_above_ranks, pseudoseed(seed .. G.GAME.round_resets.ante))
            card.ability.below.rank = above_card.base.id == 2 and 14 or (above_card.base.id - 1)
            card.ability.below.value = cs_utils.get_prev_rank_value(above_card)
        end
    end
end

-- Create random consumable
do
    function cs_utils.random_consumable(card, args)
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.0,
                func = (function()
                        local new_card = SMODS.add_card({set = args.set, area = args.destination, key_append = args.seed, soulable = args.soul})
                        G.GAME.consumeable_buffer = 0

                        if args.expiry then
                            new_card.ability.cs_temp = {active = true, expiry = args.expiry}
                        end
                    return true
                end)}))

            card_eval_status_text(
                card,
                'extra',
                nil,
                nil,
                nil,
                args.set == 'Spectral' and {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral} or {message = localize('k_plus_tarot'), colour = G.C.PURPLE}
            )
        end
    end
end

-- ALIGNMENT UTILITY
do
    function cs_utils.random_alignment(chameleonable, architectable, onlyalignmentable)
        local card_type = pseudorandom(pseudoseed('alignment'))

        if onlyalignmentable then
            G.GAME.current_alignment_only = true
        end

        if not G.GAME.first_shop_chameleon then
            G.GAME.first_shop_chameleon = true

            return SMODS.create_card({
                set = 'Alignment',
                key = 'ali_cs_chameleon',
                no_edition = true
            })
        end

        if card_type < 0.002 and architectable then
            return SMODS.create_card({
                set = 'Alignment',
                key = 'ali_cs_architect',
                no_edition = true
            })
        elseif card_type < 0.005 and chameleonable then
            return SMODS.create_card({
                set = 'Alignment',
                key = 'ali_cs_chameleon',
                no_edition = true
            })
        else
            return SMODS.create_card({
                set = 'Alignment',
                no_edition = true
            })
        end
    end

    function cs_utils.random_aligned_joker()
        local card_ali = G.jokers.cards[#G.jokers.cards]

        delay(0.2)
        SMODS.calculate_effect({message = localize('b_free_jokers_' .. G.GAME.current_alignment), colour =  G.C.ALIGNMENT['cs_' .. G.GAME.current_alignment]}, card_ali)
        G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.1,func = function()
            SMODS.add_card({
                set = 'Joker',
                no_edition = true,
                key_append = 'free_aligned_joker',
                legendary = pseudorandom('free_leg_joker'..G.GAME.round_resets.ante) < 0.005
            })

            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                draw_card(G.jokers,G.cs_alignments, 90,'up', nil, card_ali)
            return true end }))
        return true end }))
    end

    function cs_utils.is_alignment(alignment)
        if G.GAME.current_alignment == 'chameleon' then
            return true
        else
            return alignment == G.GAME.current_alignment
        end
    end

    function cs_utils.morph_to_alignment(alignment)
        G.GAME.current_alignment = alignment
        G.GAME.cs_morphed = G.GAME.cs_morphed + 1
        check_for_unlock({type = 'cs_morph'})

        if alignment ~= 'architect' and alignment ~= 'none' then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                cs_utils.random_aligned_joker()
            return true end }))
        end
    end
end

-- THIEF UTILITY
do
    function cs_utils.handle_stealing(card, cardlist, args)
        if not cs_utils.is_first_thief(card) or not cs_utils.is_alignment('thief') then return 0 end
        local remaining_space = G.cs_stack.config.card_limit - #G.cs_stack.cards
        local stolen = 0

        for i = 1, #cardlist do
            if i <= remaining_space and not cardlist[i].cs_stolen and not cardlist[i].cs_blocked and not cardlist[i].getting_sliced and not cardlist[i].destroyed then
                cardlist[i].cs_stolen = true
                stolen = stolen + 1
            end
        end

        return stolen
    end

    function cs_utils.return_stolen_cards(where)
        for i = 1, #G.cs_stack.cards do
            local stocard = G.cs_stack.cards[i]
            stocard.cs_stolen = false

            draw_card(G.cs_stack, where, i*100/#G.cs_stack.cards, 'down', true, stocard)
        end
    end

    function cs_utils.stop_stealing()
        for i = 1, #G.jokers.cards do
            local joker_card = G.jokers.cards[i]

            if cs_utils.is_alignment(joker_card.ability.alignment) and joker_card.ability.can_steal then
                SMODS.debuff_card(joker_card, true, 'stop_stealing')
                joker_card:juice_up(0.4, 0,4)
            end
        end
    end

    function cs_utils.is_first_thief(card)
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.can_steal then
                return card == G.jokers.cards[i]
            end
        end

        return false
    end
end

-- PATRON UTILITY
do
    function cs_utils.return_extra_hands_to_deck(returnhand2, returnhand3, reset)
        if returnhand2 then
            for i = 1, #G.hand_2.cards do
                draw_card(G.hand_2,G.deck, 90,'down', nil, G.hand_2.cards[i])
            end
        end
        if returnhand3 then
            for i = 1, #G.hand_3.cards do
                draw_card(G.hand_3,G.deck, 90,'down', nil, G.hand_3.cards[i])
            end
        end

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            if reset then
                G.GAME.current_round.orb_card = {called = false, cards = {}}
            else
                G.GAME.current_round.orb_card.called = true
            end

            cs_utils.refresh_play_discard_UI()
        return true end }))
    end
end

return cs_utils