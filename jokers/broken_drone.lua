SMODS.Joker {
    key = "broken_drone",
    config = {
        extra = 0.75,
        x_mult = 1.5,
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 2 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = false,  -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

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