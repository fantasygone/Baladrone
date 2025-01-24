SMODS.Joker {
    key = "damage",
    config = {
        mult = 3,
        odds = 3,
        cards = {},
        active = false
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 2, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,  -- FALSE for passive Jokers
    perishable_compat = true,  -- FALSE for scaling Jokers
    eternal_compat = true,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.mult,
                ''..(G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.odds,
            }
        }
    end,

    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            local playcard

            for i = 1, #context.scoring_hand do
                if i % 2 == 0 and context.other_card == context.scoring_hand[i] then
                    playcard = context.scoring_hand[i]
                    break
                end
            end

            if playcard then
                table.insert(card.ability.cards, playcard)
                return {
                    mult = card.ability.mult,
                    card = card
                }
            end
        end

        if context.destroying_card and not context.destroying_card.debuff and not context.blueprint then
            if cs_utils.contains(card.ability.cards, context.destroying_card) and pseudorandom('cs_damage'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/card.ability.odds then
                if not card.ability.active then
                    card.ability.active = true
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                        play_sound('cs_damage')
                    return true end }))

                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_damaged')})
                end

                return true
            end
        end

        if context.scoring_hand and context.after then
            card.ability.active = false
            card.ability.cards = {}
        end
    end
}