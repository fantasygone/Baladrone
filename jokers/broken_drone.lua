SMODS.Joker {
    key = "broken_drone",
    config = {
        extra = 0.75,
        x_mult = 1.5,
    },
    rarity = 2,
    pos = { x = 0, y = 1 },
    atlas = "CrazyStairs_atlas",
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rental_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        return {
            vars = { 
                center.ability.extra,
                center.ability.x_mult,
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        cs_utils.broken_drone_interaction(card)
    end,

    calculate = function (self, card, context)
        if context.after and context.blueprint then
            cs_utils.broken_drone_interaction(context.blueprint_card)
        end

        if context.joker_main and card.ability.x_mult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.x_mult}},
                Xmult_mod = card.ability.x_mult,
            }
        end
    end
}