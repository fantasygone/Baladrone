SMODS.Joker {
    key = "restoration",
    config = {
        alignment = 'keeper',
        to_play = 23,
        played = 0,
        restored = {},
        spell = {
            mana = -1,
            mana_cost = -1,
            mana_per_card = 1,
        },
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 0, y = 7 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,      -- FALSE for passive Jokers
    perishable_compat = true,      -- FALSE for scaling Jokers
    eternal_compat = true,         -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,          -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_keeper_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.to_play,
                center.ability.played,
                center.ability.spell.mana < 0 and G.GAME.cs_mana_max or center.ability.spell.mana,
                G.GAME.cs_mana_max,
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.spell.mana = G.GAME.cs_mana_max
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local cardsToRestore = {}

            cardsToRestore = cs_utils.save_debuffed_cards(G.hand.cards, cardsToRestore)
            cardsToRestore = cs_utils.save_debuffed_cards(G.jokers.cards, cardsToRestore)

            local new_cost = #cardsToRestore * card.ability.spell.mana_per_card
            local old_cost = card.ability.spell.mana_cost
            card.ability.spell.mana_cost = new_cost

            if new_cost ~= old_cost and card.highlighted then
                card:highlight(false)
                card:highlight(true)
            end
        end
    end,

    calculate = function (self, card, context)
        if context.after and context.scoring_hand and not context.blueprint then
            for _, c in ipairs(context.full_hand) do
                if not c.debuff then
                    card.ability.played = card.ability.played + 1
                end
            end

            -- if card.ability.played >= card.ability.to_play then
                -- local cardsToRestore = {}

                -- cardsToRestore = cs_utils.save_debuffed_cards(G.hand.cards, cardsToRestore)
                -- cardsToRestore = cs_utils.save_debuffed_cards(G.jokers.cards, cardsToRestore)

                -- -- save_debuffed_cards(G.hand.cards)
                -- -- save_debuffed_cards(G.jokers.cards)

                -- if #cardsToRestore > 0 then
                --     G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                --         G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.35,func = function()
                --             play_sound('cs_create')
                --         return true end }))

                --         G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0,func = function()
                --             card.ability.restored = card.ability.restored or {}
                --             for _, c in ipairs(cardsToRestore) do
                --                 table.insert(card.ability.restored, c)
                --                 -- c:cs_undebuff_this()

                --                 if c.ability and c.ability.perishable then
                --                     c.ability.perish_tally = 3
                --                 end

                --                 SMODS.debuff_card(c, 'prevent_debuff', 'restoration')
                --                 c:juice_up(0.3, 0.3)
                --             end

                --             card.ability.played = 0
                --         return true end }))

                --         card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_restored'), colour = G.C.ORANGE})
                --     return true end }))
                -- end
            -- end
        end

        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand and #card.ability.restored > 0 then
            for _, value in ipairs(card.ability.restored) do
                SMODS.debuff_card(value, 'reset', 'restoration')
            end

            card.ability.restored = {}
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}