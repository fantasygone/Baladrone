SMODS.Joker {
    key = "portal",
    config = {
        alignment = 'patron',
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 2, y = 5 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 4,
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
            vars = {}
        }
    end,

    calculate = function (self, card, context)
        if context.cs_click_discard or context.cs_click_play and not context.blueprint then
            local first = G.hand.highlighted[1]
            local last = G.hand.highlighted[#G.hand.highlighted]
            local first_hand_index
            local last_hand_index

            local portaled = 0

            for i = 1, #G.hand.cards do
                local curcard = G.hand.cards[i]

                if curcard == first then first_hand_index = i end
                if curcard == last then last_hand_index = i end
            end

            for i = 1, #G.hand.cards do
                local curcard = G.hand.cards[i]

                if not curcard.highlighted and (i ==  first_hand_index - 1 or i ==  first_hand_index + 1 or i ==  last_hand_index - 1 or i ==  last_hand_index + 1) then
                    portaled = portaled + 1

                    G.hand.highlighted[#G.hand.highlighted+1] = curcard
                    G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.1,func = function()
                        G.hand:forcefully_add_to_highlighted(curcard)
                    return true end }))
                end
            end
            delay(0.3)

            if portaled > 0 then
                return {
                    message = localize('cs_together'),
                    card = card,
                    colour = G.C.ALIGNMENT['cs_patron']
                }
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}