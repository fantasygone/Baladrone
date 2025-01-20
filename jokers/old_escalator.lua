SMODS.Joker {
    key = "escalator",
    config = {
        mult = 0,
        extra = 1,
        extra_incr = 1,
        direction = 'up'
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 9 },
    soul_pos = nil,
    -- Card info
    rarity = 3, --Rare
    cost = 8,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = false,  -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_hacker_aligned', set = 'Other'}

        if center.ability.direction == 'up' then
            return {
                vars = {
                    center.ability.mult >= 0 and '+' .. center.ability.mult or center.ability.mult,
                    center.ability.extra,
                    center.ability.extra_incr,
                },
                key = 'j_cs_upwards_escalator'
            }
        else
            return {
                vars = {
                    center.ability.mult >= 0 and '+' .. center.ability.mult or center.ability.mult,
                    center.ability.extra,
                    center.ability.extra_incr,
                },
                key = 'j_cs_downwards_escalator'
            }
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        if self.discovered or card.bypass_discovery_center then
            if card.ability.direction == 'up' then
                card.config.center.pos = {x = 0, y = 9}
                card:set_sprites(card.config.center)
            elseif card.ability.direction == 'down' then
                card.config.center.pos = {x = 1, y = 9}
                card:set_sprites(card.config.center)
            end
        end
    end,

    load = function(self, card, card_table, other_card)
        return self.set_ability(self, card)
    end,

    calculate = function (self, card, context)
        if context.joker_main and card.ability.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult}},
                mult_mod = card.ability.mult
            }
        end

        if context.end_of_round and not context.game_over and context.cardarea ~= G.hand then
            if card.ability.direction == 'up' then
                card.ability.mult = card.ability.mult + card.ability.extra
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra}}, colour = G.C.MULT})

                card.ability.extra = card.ability.extra + card.ability.extra_incr
            else
                card.ability.mult = card.ability.mult - card.ability.extra
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra}}, colour = G.C.MULT})
                
                card.ability.extra = card.ability.extra - card.ability.extra_incr

                if card.ability.extra - card.ability.extra_incr < 1 then
                    card.ability.extra = 1
                end
            end

            -- cs_utils.flip_cards({card}, "before", 0)

            -- G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
            --     card.ability.direction = card.ability.direction == 'up' and 'down' or 'up'
            --     if card.ability.direction == 'up' then
            --         card.children.center:set_sprite_pos({x = 0, y = 9})
            --     else
            --         card.children.center:set_sprite_pos({x = 1, y = 9})
            --     end
            -- return true end }))

            -- cs_utils.unflip_cards({card}, "after", 0.15)
        end
    end
}