local cs_utils = dofile(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")
return {
    key = "destroyer",
    loc_txt = {
        name = "Destroyer",
        text = {
        },
    },
    config = {
        extra = 2,
        below = {
            rank = 14,
            value = 'Ace'
        },
        mult = 0,
        triggered = false
    },
    rarity = 1,
    pos = { x = 0, y = 3 },
    atlas = "CrazyStairs_atlas",
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = nil,

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

    calculate = function (self, card, context)
        if context.full_hand and context.destroying_card and not context.destroying_card.debuff and not context.blueprint then
            local playcard = context.destroying_card

            if playcard.base.id == (card.ability.below.rank == 14 and 2 or (card.ability.below.rank + 1)) and not card.ability.triggered then
                card.ability.triggered = true
                card.ability.mult = card.ability.mult + card.ability.extra

                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                    play_sound('cs_destroy')
                return true end }))

                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_destroyed'), colour = G.C.RED})
                cs_utils.reset_destroyer_card(card)
                return true
            end
        end

        if context.cardarea == G.jokers and not context.before and not context.after and card.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult}},
                card = self,
                mult_mod = card.ability.mult,
                colour = G.C.RED
            }
        end

        if context.scoring_hand and context.after then
            card.ability.triggered = false
        end
    end
}