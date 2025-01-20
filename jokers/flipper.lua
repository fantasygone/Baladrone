SMODS.Joker {
    key = "flipper",
    config = {
        rank_to_flip = 6
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
    pos = { x = 0, y = 3 },
    soul_pos = nil,
    -- Card info
    rarity = 3, --Rare
    cost = 8,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers
    perishable_compat = false,  -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

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
                
                card.ability.rank_to_flip = target_rank

                cs_utils.flip_cards(toflip, 'before', 0.1)

                play_sound('cs_flip')

                for i = 1, #toflip do
                    local hooked_card = toflip[i]
                    hooked_card.base.id = target_rank
                    hooked_card.base.nominal = target_rank
                    
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        local suit_prefix = string.sub(hooked_card.base.suit, 1, 1)..'_'
                        hooked_card:set_base(G.P_CARDS[suit_prefix..target_rank])
                    return true end }))
                end

                delay(0.8)
                cs_utils.unflip_cards(toflip, 'before', 0.1)
                return {
                    message = localize('cs_flipped'),
                    colour = G.C.YELLOW,
                    card = card
                }
            end
        end
    end
}