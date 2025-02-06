SMODS.Joker {
    key = "link",
    config = {
        alignment = 'patron',
        chips_total = 0,
        mult_total = 0,
        count = 0,
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
                center.ability.count > 0 and (math.floor(center.ability.chips_total / center.ability.count) * math.floor(center.ability.mult_total / center.ability.count)) or 0
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
            card.ability.chips_total = card.ability.chips_total + hand_chips
            card.ability.mult_total = card.ability.mult_total + mult
            card.ability.count = card.ability.count + 1
        end

        if context.final_scoring_step and card.ability.count > 0 and ((hand_chips * mult) < ((card.ability.chips_total / card.ability.count) * (card.ability.mult_total / card.ability.count))) and not context.blueprint then
            if card.ability.active then
                card.ability.active = false

                local h_chips = math.floor((card.ability.chips_total / card.ability.count))
                local h_mult = math.floor((card.ability.mult_total / card.ability.count))
                update_hand_text({delay = 0}, {mult = h_mult, chips = h_chips})
        
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local text = localize('cs_averaged')
                        play_sound('gong', 0.94, 0.3)
                        play_sound('gong', 0.94*1.5, 0.2)
                        play_sound('tarot1', 1.5)
                        ease_colour(G.C.UI_CHIPS, G.C.ALIGNMENT['cs_patron'])
                        ease_colour(G.C.UI_MULT, G.C.ALIGNMENT['cs_patron'])
                        attention_text({
                            scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                        })
                        card:juice_up(0.3, 0.3)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            blockable = false,
                            blocking = false,
                            delay =  4.3,
                            func = (function() 
                                    ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                                    ease_colour(G.C.UI_MULT, G.C.RED, 2)
                                return true
                            end)
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            blockable = false,
                            blocking = false,
                            no_delete = true,
                            delay =  6.3,
                            func = (function() 
                                G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                                G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                                return true
                            end)
                        }))
                        return true
                    end)
                }))
        
                delay(0.6)

                hand_chips = h_chips
                mult = h_mult
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