SMODS.Joker {
    key = "escalator_fan",
    config = {
        alignment = 'hacker',
        extra = 2,
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 0 },
    soul_pos = { x = 2, y = 9 },
    -- Card info
    rarity = 4, --LEGENDARY!
    cost = 20,
    -- Player data
    unlocked = false,
    unlock_condition = {type = '', extra = '', hidden = true},
    discovered = false,
    -- Compatibility
    blueprint_compat = true,   -- FALSE for passive Jokers
    perishable_compat = true,  -- FALSE for scaling Jokers
    eternal_compat = true,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_hacker_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.extra
            },
        }
    end,

    calculate = function (self, card, context)
        if context.other_joker and context.other_joker:is_scaling() then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
                Xmult_mod = card.ability.extra
            }
        end
    end,

    in_pool = function(self, args)
        if G.STAGE == G.STAGES.RUN then
            for _, v in ipairs(G.jokers.cards) do
                if v:is_scaling() then
                    return cs_utils.is_alignment(self.config.alignment)
                end
            end
        end
    end
}