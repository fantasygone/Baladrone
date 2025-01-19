local cs_utils = {}

-- how hard is it for lua to give us a contains?
function cs_utils.contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Uses game Flip Cards logic
function cs_utils.flip_cards(table, trigger, delay)
    for i=1, #table do
        local percent = 1.15 - (i-0.999)/(#table-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = trigger,delay = delay,func = function() table[i]:flip();play_sound('card1', percent);table[i]:juice_up(0.3, 0.3);return true end }))
    end
end

-- Does the same but with no event (Used for Flipper which is why they flip instantly)
function cs_utils.flip_cards_noevent(table)
    for i=1, #table do
        local percent = 1.15 - (i-0.999)/(#table-0.998)*0.3

        table[i]:flip()
        play_sound('card1', percent)
        table[i]:juice_up(0.3, 0.3)
    end
end

-- Uses game Unflip Cards logic
function cs_utils.unflip_cards(table, trigger, delay)
    for i=1, #table do
        local percent = 0.85 + (i-0.999)/(#table-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = trigger,delay = delay,func = function() table[i]:flip();play_sound('tarot2', percent, 0.6);table[i]:juice_up(0.3, 0.3);return true end }))
    end
end

-- Uses game Unflip Cards logic
function cs_utils.unflip_cards_noevent(table, trigger, delay)
    for i=1, #table do
        local percent = 0.85 + (i-0.999)/(#table-0.998)*0.3

        table[i]:flip()
        play_sound('tarot2', percent, 0.6)
        table[i]:juice_up(0.3, 0.3)
    end
end

-- Broken Drone messages when triggered
function cs_utils.get_random_warning()
    local index = math.random(#impostor_warnings)
    return impostor_warnings[index]
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

function cs_utils.handle_remove_playcard(table)
    for i = 1, #table do
        table[i]:remove_from_deck(false)
        table[i]:start_dissolve()
    end

    for j = 1, #G.jokers.cards do
        eval_card(G.jokers.cards[j], {
            cardarea = G.jokers,
            remove_playing_cards = true,
            removed = table
        })
    end
end

-- Resets Destroyer card (the name of the function says that)
function cs_utils.reset_destroyer_card(card)
    card.ability.below.value = 'Ace'
    card.ability.below.rank = 14

    local valid_destroyer_ranks = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            valid_destroyer_ranks[#valid_destroyer_ranks+1] = v
        end
    end
    if valid_destroyer_ranks[1] then 
        local destroyer_card = pseudorandom_element(valid_destroyer_ranks, pseudoseed('destroyer'..G.GAME.round_resets.ante))
        card.ability.below.rank = destroyer_card.base.id == 2 and 14 or (destroyer_card.base.id - 1)
        card.ability.below.value = cs_utils.get_prev_rank_value(destroyer_card)
    end
end

-- Broken Drone logic
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
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                            new_card:start_dissolve()
                        return true end }))

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

-- Create random consumable
function cs_utils.random_consumable(card, cons_type, expiry)
    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.0,
            func = (function()
                    local card = create_card(cons_type,G.consumeables, nil, nil, nil, nil, nil, 'hal')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0

                    if expiry then
                        card.ability.cs_temp = {active = true, expiry = expiry}
                    end
                return true
            end)}))

        card_eval_status_text(
            card,
            'extra',
            nil,
            nil,
            nil,
            cons_type == 'Spectral' and {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral} or {message = localize('k_plus_tarot'), colour = G.C.PURPLE}
        )
    end
end

-- Creator logic
-- function cs_utils.handle_creator()
--     local tocopy

--     if count_6 > 0 or count_9 > 0 then
--         play_sound('cs_flip')
--         local target_rank
--         if count_6 > count_9 and count_9 ~= 0 then
--             target_rank = 6
--         elseif count_9 > count_6 and count_6 ~= 0 then
--             target_rank = 9
--         elseif count_9 == count_6 then
--             target_rank = toflip[1]:get_id()
--         else
--             target_rank = toflip[1]:get_id() == 6 and 9 or 6
--         end

--         cs_utils.flip_cards_noevent(toflip)

--         for i = 1, #toflip do
--             local hooked_card = toflip[i]
--             local suit_prefix = string.sub(hooked_card.base.suit, 1, 1)..'_'
--             hooked_card:set_base(G.P_CARDS[suit_prefix..target_rank])
--         end

--         card_eval_status_text(SMODS.find_card('j_cs_flipper')[1], 'extra', nil, nil, nil, {message = localize('cs_flipped'), colour = G.C.YELLOW})
--         delay(0.8)
--         cs_utils.unflip_cards(toflip, 'before', 0.15)
--     end
-- end

return cs_utils