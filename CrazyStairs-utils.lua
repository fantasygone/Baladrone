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
    local suit_order = CrazyStairs.SUIT_ORDER
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
    local suit_order = CrazyStairs.SUIT_ORDER
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

-- Resets Destroyer card (the name of the function says that)
function cs_utils.reset_destroyer_card(card)
    card.ability.below.value = 'Ace'
    card.ability.below.rank = 14

    if not G.playing_cards then
        return
    end

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

-- Alignment functions
function cs_utils.random_alignment(chameleonable, architectable)
    local card_type = pseudorandom(pseudoseed('alignment'))

    if not G.GAME.first_shop_chameleon then
        G.GAME.first_shop_chameleon = true

        return SMODS.create_card({
            set = 'Alignment',
            key = 'ali_cs_chameleon',
            no_edition = true
        })
    end

    if card_type > .98 and architectable then
        return SMODS.create_card({
            set = 'Alignment',
            key = 'ali_cs_architect',
            no_edition = true
        })
    elseif card_type > .95 and chameleonable then
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

function cs_utils.is_alignment(alignment)
    if not G.cs_alignments then
        return false
    end


    if G.cs_alignments.cards[1].ability.type == 'chameleon' then
        return true
    else
        return alignment == G.cs_alignments.cards[1].ability.type
    end
end
--

return cs_utils