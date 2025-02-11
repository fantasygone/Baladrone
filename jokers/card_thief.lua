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
    blueprint_compat = false,   -- FALSE for passive Jokers
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
        if context.scoring_hand and context.after then
            local triggered = true
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)

            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    triggered = false
                end
            end

            if triggered then
                local stolen_buffer = 1
                for i = 1, #context.scoring_hand do
                    if (#G.cs_stack.cards + stolen_buffer) <= G.cs_stack.config.card_limit then
                        context.scoring_hand[i].cs_stolen = true
                        stolen_buffer = stolen_buffer + 1
                    end
                end

                if #G.cs_stack.cards < G.cs_stack.config.card_limit then
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
            card.ability.stolen_chips = 0
            for i = 1, #G.cs_stack.cards do
                card.ability.stolen_chips = card.ability.stolen_chips + G.cs_stack.cards[i].base.nominal
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}