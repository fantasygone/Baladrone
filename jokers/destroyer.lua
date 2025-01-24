SMODS.Joker {
    key = "destroyer",
    config = {
        below = {
            rank = 14,
            value = 'Ace'
        },
        triggered = false
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers ...I know
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.below.value,
                center.ability.extra,
                center.ability.mult,
            }
        }
    end,

    set_ability = function(self, card, initial, delay_sprites)
        cs_utils.reset_destroyer_card(card)
    end,

    calculate = function (self, card, context)
        if context.full_hand and context.destroying_card and not context.destroying_card.debuff and not context.blueprint then
            local playcard = context.destroying_card

            if playcard.base.id == (card.ability.below.rank == 14 and 2 or (card.ability.below.rank + 1)) and not card.ability.triggered then
                card.ability.triggered = true

                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_destroyed')})

                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                    play_sound('cs_destroy')
                return true end }))
                return true
            end
        end

        if context.scoring_hand and context.after then
            card.ability.triggered = false
        end

        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand then
            cs_utils.reset_destroyer_card(card)
        end
    end
}