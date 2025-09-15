SMODS.Consumable {
    -- Card info
    key = "annihilator",
    set = "Tarot",
    config = {
        alignment = 'wicked',
        max = 1,
    },
    cost = 3,
    -- Sprite
    atlas = "BaladroneTarots_atlas",
    pos = { x = 1, y = 0 },
    -- Player data
    discovered = false,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.max,
            }
        }
    end,

    can_use = function(self, card)
        return (#G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.max)
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.4,func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            G.jokers.highlighted[1]:start_dissolve()
        return true end }))

        delay(0.3)

        ease_dollars(G.jokers.highlighted[1].config.center.cost)
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
        return true end }))
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}