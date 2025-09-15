SMODS.Joker {
    key = "call_the_orb",
    config = {
        alignment = 'patron',
        select = 5,
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 2, y = 0 },
    soul_pos = { x = 3, y = 5 },
    -- Card info
    rarity = 4, --LEGENDARY!
    cost = 20,
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
        info_queue[#info_queue + 1] = {key = 'cs_patron_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_goldendiscopig_concept', set = 'Other'}
        return {
            vars = {
                center.ability.select,
                G.hand and (G.hand.config.card_limit * 3) or 24
            }
        }
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand_2:unhighlight_all()
        G.hand_3:unhighlight_all()
        cs_utils.return_extra_hands_to_deck(#G.hand_2.cards > 0, #G.hand_3.cards > 0, true)
    end,

    calculate = function (self, card, context)
        if context.first_hand_drawn and G.GAME.blind:get_type() == 'Small' and not context.blueprint then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('cs_calling'), colour = G.C.ALIGNMENT['cs_patron']})
            G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.1,func = function()
                G.FUNCS.draw_from_deck_to_other_hands()
            return true end }))
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}