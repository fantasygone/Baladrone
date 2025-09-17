SMODS.Consumable {
    -- Card info
    key = "duality",
    set = "Spectral",
    config = {
        alignment = 'necromancer',
        max = 1,
    },
    cost = 5,
    -- Sprite
    atlas = "BaladroneTarots_atlas",
    pos = { x = 1, y = 1 },
    -- Player data
    discovered = false,

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_necromancer_aligned', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_levthelion_concept', set = 'Other'}
        info_queue[#info_queue + 1] = {key = 'cs_perishable_info', set = 'Other'}
        return {
            vars = {
                center.ability.max,
            }
        }
    end,

    can_use = function(self, card)
        return #G.jokers.cards > 0 and #G.jokers.cards < G.jokers.config.card_limit
    end,

    use = function(self, card, area, copier)
        local chosen_joker = pseudorandom_element(G.jokers.cards, 'duality_choice')

        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.4,
            func = function()
                local copied_joker = copy_card(chosen_joker, nil, nil, nil,
                    chosen_joker.edition and chosen_joker.edition.negative)

                copied_joker:start_materialize()
                copied_joker:add_to_deck()

                play_sound('tarot1')
                card:juice_up(0.3, 0.5)

                if copied_joker.edition and copied_joker.edition.negative then
                    copied_joker:set_edition(nil, true)
                end

                if not chosen_joker.ability.perishable then
                    copied_joker:add_sticker('perishable', true)
                else
                    copied_joker:remove_sticker('perishable')
                end

                G.jokers:emplace(copied_joker)
                delay(0.3)
                return true
            end
        }))
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}