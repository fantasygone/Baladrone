SMODS.Joker {
    key = "strider",
    config = {},
    rarity = 3,
    pos = { x = 0, y = 5 },
    atlas = "CrazyStairs_atlas",
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_drifter_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'red_seal', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_lift_seal', set = 'Other'}
        return {
            vars = {}
        }
    end,

    calculate = function (self, card, context)
        if context.first_hand_drawn then
            local evalJoker = function(joker) return (G.GAME.current_round.hands_played == 0) end
            juice_card_until(card, evalJoker, true)
        end

        if #G.play.cards == 1 and context.scoring_hand and not context.scoring_hand[1].debuff and context.cs_beforeall and G.GAME.current_round.hands_played == 0 then
            local target = context.scoring_hand[1]
            local target_seal

            if not target.seal then
                target_seal = 'Red'
            elseif target.seal == "Red" then
                target_seal = 'cs_lift'
            end
            
            target:juice_up(0.6, 0.6)
            target:set_seal(target_seal, nil, true)
            delay(0.3)
            card_eval_status_text(
                context.blueprint and context.blueprint_card or card,
                'extra',
                nil,
                nil,
                nil,
                {
                    message = target_seal == 'Red' and localize('cs_boosted') or localize('cs_boosted_again'),
                    colour = G.C.GREEN
                }
            )
        end
    end
}