SMODS.Joker {
    key = "upwards_escalator",
    config = {
        alignment = 'hacker',
        mult = 0,
        extra = 1,
        extra_2 = 2,
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 9 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 4,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = false,  -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_hacker_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.mult,
                center.ability.extra,
                center.ability.extra_2,
            },
        }
    end,

    calculate = function (self, card, context)
        if context.joker_main and card.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult}},
                mult_mod = card.ability.mult
            }
        end

        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand then
            if pseudorandom('upwards_esc') < 0.75 then
                card.ability.mult = card.ability.mult + card.ability.extra
            else
                card.ability.mult = card.ability.mult + card.ability.extra_2
            end

            return {
                card = card,
                message = localize{type='variable',key='a_mult',vars={card.ability.mult}},
                colour = G.C.ALIGNMENT["cs_hacker"]
            }
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}