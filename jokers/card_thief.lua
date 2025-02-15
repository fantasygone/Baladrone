SMODS.Joker {
    key = "card_thief",
    config = {
        alignment = 'thief',
        can_steal = true,
        stolen_chips = 0
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 10 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 4,
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
                center.ability.stolen_chips
            },
        }
    end,

    calculate = function (self, card, context)
        if context.scoring_hand and context.after and not context.blueprint then
            if cs_utils.is_most_played(context.scoring_name) then
                local stolen_buffer = cs_utils.handle_stealing(card, context.scoring_hand)

                if stolen_buffer >= 1 then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        play_sound('cs_steal')
                    return true end }))
                    return {
                        card = card,
                        message = localize('cs_stolen'),
                        colour = G.C.ALIGNMENT['cs_thief']
                    }
                end
            end
        end

        if context.joker_main and card.ability.stolen_chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.stolen_chips}},
                chip_mod = card.ability.stolen_chips
            }
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local totalchips = 0

            for i = 1, #G.cs_stack.cards do
                if not G.cs_stack.cards[i].debuff then totalchips = totalchips + (G.cs_stack.cards[i].base.nominal) end
            end

            card.ability.stolen_chips = totalchips
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}