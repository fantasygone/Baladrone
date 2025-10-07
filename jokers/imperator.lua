SMODS.Joker {
    key = "imperator",
    config = {
        alignment = 'wicked',
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 6, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 'cs_Ultimate', --Ultimate!
    cost = 9,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,   -- TRUE for passive Jokers
    perishable_compat = false, -- TRUE for scaling Jokers
    eternal_compat = false,    -- TRUE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {}
        }
    end,

    calculate = function (self, card, context)
        if context.scoring_hand and context.after then
            local joker_list = {}
            local victim = nil
            for _, value in pairs(G.jokers.cards) do
                if value ~= card and not value.ability.eternal then
                    table.insert(joker_list, value)
                end
            end

            if #joker_list > 0 then
                victim = pseudorandom_element(joker_list, pseudoseed('victim_for_imperator'))
            end

            if victim then            
                if G.GAME.blind.chips >= (hand_chips * mult) then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                        play_sound('cs_bend')
                    return true end }))
                    SMODS.calculate_effect({message = localize('cs_bend'), colour =  G.C.ALIGNMENT['cs_wicked']}, card)

                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips - (hand_chips * mult))
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    return true end }))
                    SMODS.destroy_cards(victim)
                else
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                        play_sound('cs_bend')
                    return true end }))
                    SMODS.calculate_effect({message = localize('cs_bend'), colour =  G.C.ALIGNMENT['cs_wicked']}, card)
    
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                        G.GAME.chips = math.floor(G.GAME.chips + G.GAME.blind.chips)
                    return true end }))
                end


            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}