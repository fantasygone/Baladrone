SMODS.Joker {
    key = "random_teleport",
    config = {
        odds = 2,
        teleports = 1,
    },
    rarity = 2,
    pos = { x = 0, y = 8 },
    atlas = "CrazyStairs_atlas",
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    rental_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_spectre_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_temporary', set = 'Other'}
        return {
            vars = {
                ''..(G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.odds,
                center.ability.teleports,
                center.ability.teleports > 1 and localize('cs_consumables') or localize('cs_consumable'),
            }
        }
    end,

    calculate = function (self, card, context)
        if context.cs_entering_shop then
            if pseudorandom('random_tele'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/card.ability.odds then
                for i = 1, card.ability.teleports do
                    if pseudorandom('random_tele_type'..G.GAME.round_resets.ante) < 0.8 then
                        cs_utils.random_consumable(context.blueprint_card or card, 'Tarot', 'ending_shop')
                    else
                        cs_utils.random_consumable(context.blueprint_card or card, 'Spectral', 'ending_shop')
                    end
                end
            end
        end
    end
}