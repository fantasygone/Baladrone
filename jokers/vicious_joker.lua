SMODS.Joker {
    key = "vicious_joker",
    config = {
        alignment = 'wicked',
        payout = 3
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 1, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_duskilion_concept', set = 'Other'}
        return {
            vars = {
                center.ability.payout,
            }
        }
    end,

    calculate = function (self, card, context)
        -- if context.full_hand and context.destroying_card and not context.destroying_card.debuff and not context.blueprint then
        --     local playcard = context.destroying_card

        --     if playcard.config.center.set == 'Enhanced' then
        --         SMODS.calculate_effect({message = localize('cs_destroyed'), colour = G.C.ALIGNMENT['cs_wicked']}, card)
        --         return {
        --             dollars = card.ability.payout,
        --             card = card,
        --         }
        --     end
        -- end

        if context.destroy_card and not context.blueprint then
            if context.destroy_card.config.center.set == 'Enhanced' then
                SMODS.calculate_effect({message = localize('cs_destroyed'), colour = G.C.ALIGNMENT['cs_wicked']}, card)
                ease_dollars(card.ability.payout)
                delay(0.3)
                return {
                    remove = true
                }
            end
        end
    end,

    in_pool = function(self, args)
        if G.STAGE == G.STAGES.RUN and cs_utils.is_alignment(self.config.alignment) then
            for k, v in pairs(G.playing_cards) do
                if v.config.center.set == 'Enhanced' then return true end
            end
        end
    end
}