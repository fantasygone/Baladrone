SMODS.Joker {
    key = "bend_down",
    config = {
        extra = 1,
        removed = 0,
        original_size = 0
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,  -- FALSE for passive Jokers ...I know
    perishable_compat = true,  -- FALSE for scaling Jokers
    eternal_compat = true,     -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,      -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.extra,
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        if from_debuff then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,func = function()
                G.GAME.blind.chips = G.GAME.blind.chips - card.ability.removed
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true end }))
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            G.GAME.blind.chips = G.GAME.blind.chips + card.ability.removed
            G.GAME.blind.chip_text = G.GAME.blind.chips
        return true end }))
    end,

    calculate = function (self, card, context)
        if context.setting_blind and not self.getting_sliced and not context.blueprint then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                card.ability.original_size = G.GAME.blind.chips
                G.GAME.blind.chips = G.GAME.blind.chips * (1 - (G.GAME.current_round.discards_left) / 100)
                card.ability.removed = card.ability.original_size - G.GAME.blind.chips

                play_sound('cs_bend')
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true end }))

            return {
                message = '-' .. G.GAME.current_round.discards_left .. '% ' .. localize('cs_blind_size'),
                card = card,
                colour = G.C.ALIGNMENT['cs_wicked']
            }
        end

        if context.pre_discard and not context.blueprint then            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.GAME.blind.chips = G.GAME.blind.chips + (card.ability.removed / G.GAME.current_round.discards_left)
                card.ability.removed = card.ability.removed - (card.ability.removed / G.GAME.current_round.discards_left)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true end }))

            return {
                message = '+' .. card.ability.extra .. '% '.. localize('cs_blind_size'),
                card = card,
                colour = G.C.ALIGNMENT['cs_wicked']
            }
        end
    end
}