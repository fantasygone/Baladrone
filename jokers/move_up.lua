SMODS.Joker {
    key = "move_up",
    config = {},
    rarity = 4,
    pos = { x = 1, y = 6 },
    soul_pos = { x = 2, y = 6 },
    atlas = "CrazyStairs_atlas",
    cost = 20,
    unlocked = false,
    unlock_condition = {type = '', extra = '', hidden = true},
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rental_compat = true,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_keeper_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_rank_seal', set = 'Other'}
        return {
            vars = {}
        }
    end,

    calculate = function (self, card, context)
        if context.scoring_hand and context.cs_beforeall then
            local highest = 2

            for i = 1, #context.scoring_hand do
                local current = context.scoring_hand[i]

                if current.base.id > highest then
                    highest = current.base.id
                end
            end

            if highest < 14 then
                for i = 1, #context.scoring_hand do
                    local current = context.scoring_hand[i]

                    if current.base.id == highest and not current.debuff then
                        if not current.seal then
                            current:juice_up(0.6, 0.6)
                            current:set_seal('cs_rank', nil, true)

                            card_eval_status_text(
                                card,
                                'extra',
                                nil,
                                nil,
                                nil,
                                {
                                    message = localize('cs_promoted'),
                                    colour = G.C.ORANGE
                                }
                            )
                        end
                    end
                end
            end
        end

        -- if context.joker_main then
        --     for i = 1, #context.scoring_hand do
        --         local current = context.scoring_hand[i]

        --         if current.base.id == 14 and current.seal == 'cs_rank' then
        --             card.ability.count = card.ability.count + 1
        --         end
        --     end

        --     if card.ability.count > 0 then
        --         return { mult = card.ability.mult * card.ability.count}
        --     end
        -- end
    end
}