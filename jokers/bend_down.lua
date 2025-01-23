SMODS.Joker {
    key = "bend_down",
    config = {
        extra = 1,
        triggered = false
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 1, y = 4 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,   -- FALSE for passive Jokers ...I know
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

    calculate = function (self, card, context)
        if G.GAME.current_round.hands_played == 0 and context.pre_discard and not card.ability.triggered then
            local discarded = #G.hand.highlighted

            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                card.ability.triggered = true
                play_sound('cs_bend')
                G.GAME.blind.chips = G.GAME.blind.chips * (1 - (card.ability.extra * discarded) / 100)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true end }))

            return {
                message = localize('cs_bend'),
                card = card,
                colour = G.C.ALIGNMENT['cs_wicked']
            }
        end

        if context.setting_blind and not card.getting_sliced then
            card.ability.triggered = false
        end
    end
}