SMODS.Joker {
    key = "link",
    config = {
        alignment = 'patron',
        score = 0,
        score_times = 0,
        active = false
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 5 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
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
        info_queue[#info_queue + 1] = {key = 'cs_patron_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.score_times > 0 and center.ability.score / center.ability.score_times or center.ability.score
            }
        }
    end,

    calculate = function (self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            card.ability.active = true
            local evalJoker = function(joker) return (card.ability.active) end
            juice_card_until(card, evalJoker, true)
        end

        if context.scoring_hand and context.after and not context.blueprint then
            card.ability.score = card.ability.score + (hand_chips * mult)
            card.ability.score_times = card.ability.score_times + 1
        end

        if context.cs_check_score and card.ability.score_times > 0 and ((hand_chips * mult) < (card.ability.score / card.ability.score_times)) and not context.blueprint then
            if card.ability.active then
                card.ability.active = false
                hand_chips = card.ability.score / card.ability.score_times
                mult = 1
    
                return {
                    message = localize('cs_averaged'),
                    colour = G.C.ALIGNMENT['cs_patron'],
                    card = card
                }
            end
        end

        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand and not context.blueprint then
            card.ability.active = false
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}