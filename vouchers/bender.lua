SMODS.Voucher {
    key = "bender",
    config = {
        extra = 4
    },
    -- Sprite settings
    atlas = "CrazyStairsVouchers_atlas",
    pos = { x = 1, y = 0 },
    soul_pos = nil,
    -- Voucher info
    cost = 10,
    -- Player data
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_wicked_aligned', set = 'Other'}
        return {
            vars = {
                center.ability.extra,
            }
        }
    end,

    calculate = function (self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.GAME.blind.chips = G.GAME.blind.chips * (1 - (card.ability.extra) / 100)

                play_sound('cs_bend')
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true end }))
        end
    end
}