SMODS.Joker {
    key = "revival_point",
    config = {
        alignment = 'necromancer',
        stored = {
            hands = 0,
            max_hands = 0,
            hand_size = 0,
            discards = 0,
            max_discards = 0,
            ante = 0,
            round = 0,
            dollars = 0,
            joker_size = 0,
        }
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 1, y = 11 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = false,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_necromancer_aligned', set = 'Other'}
        return {
            vars = {}
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.stored.hands = G.GAME.current_round.hands_left
            card.ability.stored.max_hands = G.GAME.round_resets.hands
            card.ability.stored.hand_size = G.hand.config.card_limit
            card.ability.stored.discards = G.GAME.current_round.discards_left
            card.ability.stored.max_discards = G.GAME.round_resets.discards
            card.ability.stored.dollars = G.GAME.dollars
        end
    end,

    calculate = function (self, card, context)
        if context.selling_self and not context.blueprint then            
            if G.GAME.round_resets.hands < card.ability.stored.max_hands then
                G.GAME.round_resets.hands = card.ability.stored.max_hands
            end

            if G.GAME.current_round.hands_left < card.ability.stored.hands then
                ease_hands_played(card.ability.stored.hands - G.GAME.current_round.hands_left)
            end

            if G.GAME.round_resets.discards < card.ability.stored.max_discards then
                G.GAME.round_resets.discards = card.ability.stored.max_discards
            end

            if G.GAME.current_round.discards_left < card.ability.stored.discards then
                ease_discard(card.ability.stored.discards - G.GAME.current_round.discards_left)
            end

            if G.GAME.dollars < card.ability.stored.dollars then
                ease_dollars(card.ability.stored.dollars - G.GAME.dollars)
            end

            if G.hand.config.card_limit < card.ability.stored.hand_size then
                G.hand:change_size(card.ability.stored.hand_size - G.hand.config.card_limit)
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}