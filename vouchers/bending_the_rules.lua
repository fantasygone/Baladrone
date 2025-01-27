SMODS.Voucher {
    key = "bending_the_rules",
    config = {
        extra = 6
    },
    -- Sprite settings
    atlas = "CrazyStairsVouchers_atlas",
    pos = { x = 1, y = 1 },
    soul_pos = nil,
    -- Voucher info
    cost = 10,
    -- Player data
    unlocked = false,
    discovered = false,
    check_for_unlock = function(self, args)
        if args.type == 'cs_blind_beaten' and args.score <= args.blind_size * 1.04 then
            unlock_card(self)
        end
    end,

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
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true end }))
        end
    end
}