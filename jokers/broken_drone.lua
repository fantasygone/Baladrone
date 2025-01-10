SMODS.Joker {
    key = "broken_drone",
    loc_txt = {
        name = "Broken Drone",
        text = {
            "Destroys Jokers that try",
            "to copy this Joker",
            "Gain {X:mult,C:white}X#1#{} Mult per card",
            "destroyed this way",
            "{C:inactive}(Currently {X:mult,C:white}X#2# {C:inactive} Mult)",
        },
    },
    config = {
        extra = 1, 
        Xmult = 1.5,
    },
    rarity = 2,
    pos = { x = 0, y = 1 },
    atlas = "CrazyStairs_atlas",
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        return {
            vars = { 
                center.ability.extra,
                center.ability.Xmult,
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        cs_utils.broken_drone_interaction(card)
    end,

    calculate = function (self, card, context)
        if context.before and context.blueprint then
            cs_utils.broken_drone_interaction(context.blueprint_card)
        end

        if context.joker_main and card.ability.Xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult}},
                Xmult_mod = card.ability.Xmult
            }
        end
    end
}