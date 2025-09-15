SMODS.Joker {
    key = "bugged_trap",
    config = {
        alignment = 'joker',
        repeats = 3,
        odds = 5
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 2, y = 3 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = false,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    check_for_unlock = function(self, args)
        if args.type == 'repeated' then
            unlock_card(self)
        end
    end,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_joker_aligned', set = 'Other'}
        return {vars = {
            ''..(G.GAME and G.GAME.probabilities.normal or 1),
            center.ability.odds,
            center.ability.repeats,
        }}
    end,

    calculate = function (self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker then
            if #G.jokers.cards > 1 then
                local self_index
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then self_index = i end
                end

                local current_repeats = 0

                for i = 1, card.ability.repeats do
                    if pseudorandom('bugged_trap') < (current_repeats == 0 and G.GAME.probabilities.normal/card.ability.odds or 1/card.ability.odds) then
                        current_repeats = current_repeats + 1
                    else
                        break
                    end
                end

                check_for_unlock({target = 'j_cs_bugged_trap', type = 'repeat', count = current_repeats})

                if G.jokers.cards[self_index - 1] and current_repeats > 0 then
                    for i = 1, #G.jokers.cards do
                        if context.other_card == G.jokers.cards[self_index - 1] then
                            return {
                                message = localize("cs_fall_again"),
                                repetitions = current_repeats,
                                card = card,
                                colour = G.C.YELLOW
                            }
                        end
                    end
                end
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}