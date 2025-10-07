SMODS.Joker {
    key = "restoration",
    config = {
        alignment = 'keeper',
        to_play = 23,
        played = 0,
        spell = {
            mana = -1,
            mana_cost = -1,
            mana_per_card = 1,
        },
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 0, y = 7 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,      -- FALSE for passive Jokers
    perishable_compat = true,      -- FALSE for scaling Jokers
    eternal_compat = true,         -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,          -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_keeper_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.to_play,
                center.ability.played,
                center.ability.spell.mana < 0 and G.GAME.cs_mana_max or center.ability.spell.mana,
                G.GAME.cs_mana_max,
                center.ability.spell.mana_per_card
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.spell.mana = G.GAME.cs_mana_max
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local cardsToRestore = {}

            cardsToRestore = cs_utils.save_debuffed_cards(G.hand.cards, cardsToRestore)
            cardsToRestore = cs_utils.save_debuffed_cards(G.jokers.cards, cardsToRestore)

            local new_cost = #cardsToRestore * card.ability.spell.mana_per_card
            local old_cost = card.ability.spell.mana_cost
            card.ability.spell.mana_cost = new_cost

            if new_cost ~= old_cost and card.highlighted then
                card:highlight(false)
                card:highlight(true)
            end
        end
    end,

    calculate = function (self, card, context)
        if context.after and context.scoring_hand and not context.blueprint then
            for _, c in ipairs(context.full_hand) do
                if not c.debuff then
                    card.ability.played = card.ability.played + 1
                end
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}