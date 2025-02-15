SMODS.Joker {
    key = "restoration",
    config = {
        alignment = 'keeper',
        to_play = 10,
        played = 0,
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
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
            }
        }
    end,

    calculate = function (self, card, context)
        if context.after and context.scoring_hand and not context.blueprint then
            for _, c in ipairs(context.scoring_hand) do
                if not c.debuff then
                    card.ability.played = card.ability.played + 1
                end
            end

            if card.ability.played >= card.ability.to_play then
                local cardsToRestore = {}

                local function save_debuffed_cards(cards)
                    for _, c in ipairs(cards) do
                        if c.debuff then
                            table.insert(cardsToRestore, c)
                        end
                    end
                end

                save_debuffed_cards(G.hand.cards)
                save_debuffed_cards(G.jokers.cards)

                if #cardsToRestore > 0 then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.35,func = function()
                            play_sound('cs_create')
                        return true end }))

                        G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0,func = function()
                            for _, c in ipairs(cardsToRestore) do
                                c:undebuff_this()
                            end

                            card.ability.played = 0
                        return true end }))

                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_restored'), colour = G.C.ORANGE})
                    return true end }))
                end
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}