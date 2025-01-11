SMODS.Joker {
    key = "restoration",
    config = {
        to_play = 10,
        played = 0,
    },
    rarity = 2,
    pos = { x = 0, y = 6 },
    atlas = "CrazyStairs_atlas",
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    soul_pos = nil,

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
                                c.debuff = false
                                if c.ability and c.ability.perishable then 
                                    c.ability.perish_tally = 3
                                end
                                c:juice_up(0.3, 0.3)
                            end

                            card.ability.played = 0
                        return true end }))

                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_restored'), colour = G.C.ORANGE})
                    return true end }))
                end
            end
        end
    end
}