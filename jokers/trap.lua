SMODS.Joker {
    key = "trap",
    config = {
        alignment = 'joker',
        chips = 0,
        extra = 9,
        fakes = 6,
        fake_tally = 0,
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 3 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 4,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = false,  -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_joker_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_fake_card', set = 'Other'}
        return {vars = {
            center.ability.fakes,
            center.ability.extra,
            center.ability.chips,
            center.ability.fake_tally,
        }}
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and not G.SETTINGS.paused and G.jokers then
            local chosen
            -- local available_cards = cs_utils.shallow_copy{G.playing_cards}
            local available_cards = {}
            for i, v in ipairs(G.playing_cards) do
                available_cards[i] = v
            end

            for i = 1, (card.ability.fakes > #available_cards - card.ability.fake_tally) and (#available_cards - card.ability.fake_tally) or card.ability.fakes do
                repeat
                    chosen = pseudorandom_element(available_cards, pseudoseed('cs_trap'))
                until not chosen.ability.cs_fake

                -- Remove from list to avoid duplicates
                for j = 1, #available_cards do
                    if available_cards[j] == chosen then
                        table.remove(available_cards, j)
                        break
                    end
                end

                chosen.ability.cs_fake = true
                -- chosen.ability.bonus = chosen.base.nominal - (chosen.base.nominal*2)
                chosen:juice_up(1, 1)
            end

            delay(0.2)
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                play_sound('cs_trap_set')
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_faking_cards'), colour = G.C.YELLOW})
            return true end }))
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.fake_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v.ability.cs_fake then card.ability.fake_tally = card.ability.fake_tally + 1 end
            end
        end
    end,

    calculate = function (self, card, context)
        if context.scoring_hand and context.before and not context.blueprint then
            local playedFake = false

            for i = 1, #context.scoring_hand do
                local current = context.scoring_hand[i]
                if current.ability.cs_fake and not current.debuff then
                    playedFake = true
                    if current.config.center ~= G.P_CENTERS.m_cs_fake then
                        current:set_ability(G.P_CENTERS['m_cs_fake'])
                        current:juice_up(0.6, 0.6)
                    end
                end
            end

            if playedFake then
                card.ability.chips = math.floor(card.ability.chips / 2)
                if card.ability.chips < 0 then card.ability.chips = 0 end

                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                    play_sound('cs_trap_triggered')
                return true end }))
                return {
                    card = card,
                    message = localize('cs_fake_played'),
                    colour = G.C.YELLOW
                }
            elseif card.ability.fake_tally > 0 then
                card.ability.chips = card.ability.chips + card.ability.extra

                return {
                    card = card,
                    message = localize('cs_lame') .. ' ' .. localize{type='variable',key='a_chips',vars={card.ability.chips}},
                    colour = G.C.YELLOW
                }
            end
        end

        if context.joker_main and card.ability.chips > 0 then
            if context.blueprint then
                check_for_unlock({ type = "repeated" })
            end
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.chips}},
                chip_mod = card.ability.chips,
            }
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}