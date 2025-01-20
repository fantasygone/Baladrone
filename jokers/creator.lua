SMODS.Joker {
    key = "creator",
    config = {
        extra = 1,
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 5 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_patron_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_basic', set = 'Other'}
        return {
            vars = {
                center.ability.extra,
            }
        }
    end,

    calculate = function (self, card, context)
        if context.first_hand_drawn then
            local evalJoker = function(joker) return (G.GAME.current_round.hands_played == 0) end
            juice_card_until(card, evalJoker, true)
        end

        if context.scoring_hand and not context.scoring_hand[1].debuff and context.after and G.GAME.current_round.hands_played == 0 then
            local copycard = context.scoring_hand[1]

            G.E_MANAGER:add_event(Event({
                func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(copycard, nil, nil, G.playing_card, true)
                    assert(SMODS.change_base(_card, nil, cs_utils.get_next_rank_value(_card)))
                    _card:set_ability(G.P_CENTERS.c_base)
                    _card:set_seal(nil, nil, true)
                    _card:add_to_deck()
        
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.hand:emplace(_card)
                    _card.states.visible = nil
                    _card:start_materialize()
                    return true
                end
            }))
            return {
                message = localize('cs_created'),
                colour = G.C.GREEN,
                card = card,
                playing_cards_created = {true},
                sound = 'cs_create'
            }
        end
    end
}