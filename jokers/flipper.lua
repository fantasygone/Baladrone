SMODS.Joker {
    key = "flipper",
    config = {},
    rarity = 3,
    pos = { x = 0, y = 2 },
    atlas = "CrazyStairs_atlas",
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rental_compat = true,
    soul_pos = nil,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_joker_aligned', set = 'Other'}
        return {vars = {}}
    end,

    calculate = function (self, card, context)
        if context.cs_beforeall and not context.blueprint then
            local toflip = {}
            local count_6 = 0
            local count_9 = 0
            
            for i = 1, #G.play.cards do
                if not G.play.cards[i].debuff then
                    if G.play.cards[i]:get_id() == 6 then
                        count_6 = count_6 + 1
                        table.insert(toflip, G.play.cards[i])
                    elseif G.play.cards[i]:get_id() == 9 then
                        count_9 = count_9 + 1
                        table.insert(toflip, G.play.cards[i])
                    end
                end
            end
        
            if count_6 > 0 or count_9 > 0 then
                local target_rank
                if count_6 > count_9 and count_9 ~= 0 then
                    target_rank = 6
                elseif count_9 > count_6 and count_6 ~= 0 then
                    target_rank = 9
                elseif count_9 == count_6 then
                    target_rank = toflip[1]:get_id()
                else
                    target_rank = toflip[1]:get_id() == 6 and 9 or 6
                end
        
                cs_utils.flip_cards_noevent(toflip)

                play_sound('cs_flip')

                for i = 1, #toflip do
                    local hooked_card = toflip[i]
                    local suit_prefix = string.sub(hooked_card.base.suit, 1, 1)..'_'
                    hooked_card:set_base(G.P_CARDS[suit_prefix..target_rank])
                end
                -- G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.1,func = function()

                -- return true end }))

                delay(0.8)
                cs_utils.unflip_cards(toflip)
                return {
                    message = localize('cs_flipped'),
                    colour = G.C.YELLOW,
                    card = card
                }
            end
        end
    end
}