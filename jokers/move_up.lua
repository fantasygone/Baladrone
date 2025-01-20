SMODS.Joker {
    key = "move_up",
    config = {},
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 7 },
    -- Card info
    rarity = 4, --LEGENDARY!
    cost = 20,  --Standard Legendary price
    -- Player data
    unlocked = false,
    unlock_condition = {type = '', extra = '', hidden = true},
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

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