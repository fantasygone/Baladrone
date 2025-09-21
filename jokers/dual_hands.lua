SMODS.Joker {
    key = "dual_hands",
    config = {
        alignment = 'necromancer',
        repeats = 1,
        odds = 3,
        active = false,
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 0, y = 11 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,    -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_necromancer_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_levthelion_concept', set = 'Other'}
        return {
            vars = {
                ''..(G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.odds,
                center.ability.repeats,
                center.ability.repeats > 1 and localize('cs_times') or localize('cs_time'),
            }
        }
    end,

    calculate = function (self, card, context)
        if context.cs_before_final_scoring and pseudorandom('dual_hands') < G.GAME.probabilities.normal/card.ability.odds and not card.ability.active and not context.blueprint then
            card.ability.active = true

            for i = 1, card.ability.repeats do
                SMODS.calculate_effect({message = localize('k_again_ex'), colour =  G.C.ALIGNMENT['cs_necromancer']}, card)
                for _, v in ipairs(SMODS.get_card_areas('playing_cards')) do
                    SMODS.calculate_main_scoring({cardarea = v, full_hand = G.play.cards, scoring_hand = context.cs_scoring_hand, scoring_name = context.cs_scoring_name, poker_hands = context.cs_poker_hands}, v == G.play and context.cs_scoring_hand or nil)
                end
            end
        end

        if context.full_hand and context.after and not context.blueprint then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                card.ability.active = false
            return true end }))
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}