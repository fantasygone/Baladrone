SMODS.Joker {
    key = "damage",
    config = {
        alignment = 'wicked',
        poker_hand = 'Three of a Kind',
        active = false
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 2, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,  -- FALSE for passive Jokers
    perishable_compat = true,  -- FALSE for scaling Jokers
    eternal_compat = true,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.type,
            }
        }
    end,

    calculate = function (self, card, context)
        if context.scoring_name == card.ability.poker_hand and context.destroy_card and not context.destroy_card.debuff and not context.blueprint then
            if context.cardarea == G.hand then
                local playcard
                for i = 1, #G.hand.cards do
                    if i % 2 == 0 and context.destroy_card == G.hand.cards[i] then
                        playcard = G.hand.cards[i]
                        break
                    end
                end
                if playcard then
                    if not card.ability.active then
                        card.ability.active = true
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                            play_sound('cs_damage')
                        return true end }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_damaged')})
                    end
                    return true
                end
            end


        end
        if context.scoring_hand and context.after then
            card.ability.active = false
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}