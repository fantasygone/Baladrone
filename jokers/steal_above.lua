SMODS.Joker {
    key = "steal_above",
    config = {
        alignment = 'thief',
        can_steal = true,
        below = {
            rank = 14,
            value = 'Ace'
        },
        stolen_chips = 0
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 10 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_thief_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.below.value,
                center.ability.stolen_chips
            },
        }
    end,

    set_ability = function(self, card, initial, delay_sprites)
        cs_utils.reset_above_card(card, 'stealabove')
    end,

    calculate = function (self, card, context)
        if context.scoring_hand and context.after and not context.blueprint then
            local stolen_buffer = 0

            for i = 1, #context.scoring_hand do
                local playcard = context.scoring_hand[i]

                if playcard.base.id == (card.ability.below.rank == 14 and 2 or (card.ability.below.rank + 1)) then
                    stolen_buffer = cs_utils.handle_stealing(card, {playcard})
                    break
                end
            end

            if stolen_buffer >= 1 then
                return {
                    card = card,
                    message = localize('cs_stolen'),
                    colour = G.C.ALIGNMENT['cs_thief']
                }
            end
        end

        if context.joker_main and card.ability.stolen_chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.stolen_chips}},
                chip_mod = card.ability.stolen_chips
            }
        end

        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand and not context.blueprint then
            cs_utils.reset_above_card(card, 'stealabove')

            return {
                message = localize('k_reset')
            }
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local totalchips = 0

            for i = 1, #G.cs_stack.cards do
                if not G.cs_stack.cards[i].debuff then totalchips = totalchips + (G.cs_stack.cards[i].base.nominal * 2) end
            end

            card.ability.stolen_chips = totalchips
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}