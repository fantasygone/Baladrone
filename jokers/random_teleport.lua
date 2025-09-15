SMODS.Joker {
    key = "random_teleport",
    config = {
        alignment = 'spectre',
        odds = 2,
        teleports = 1,
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 0, y = 8 },
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
        info_queue[#info_queue + 1] = {key = 'cs_spectre_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_temporary', set = 'Other'}
        return {
            vars = {
                ''..(G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.odds,
                center.ability.teleports,
                center.ability.teleports > 1 and localize('cs_cards') or localize('cs_card'),
            }
        }
    end,

    calculate = function (self, card, context)
        if context.cs_entering_shop then
            if pseudorandom('random_tele'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/card.ability.odds then
                for i = 1, card.ability.teleports do
                    if pseudorandom('random_tele_type'..G.GAME.round_resets.ante) < 0.8 then
                        cs_utils.random_consumable(context.blueprint_card or card, {set = 'Tarot', destination = G.alignments, expiry = 'ending_shop', seed = 'randomteleport', soulable = false})
                    else
                        cs_utils.random_consumable(context.blueprint_card or card, {set = 'Spectral', destination = G.alignments, expiry = 'ending_shop', seed = 'randomteleport', soulable = false})
                    end
                end
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}