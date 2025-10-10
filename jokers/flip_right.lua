SMODS.Joker {
    key = "flip_right",
    config = {
        alignment = 'joker',
        target = nil,
        spell = {
            mana = -1,
            mana_cost = 2,
        },
        extra = {
            xmult = 3
        },
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 4, y = 3 },
    soul_pos = nil,
    -- Card info
    rarity = 1, --Common
    cost = 5,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = true,    -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_joker_aligned', set = 'Other'}
        return {vars = {
            center.ability.spell.mana < 0 and G.GAME.cs_mana_max or center.ability.spell.mana,
            center.ability.spell.mana_cost,
            G.GAME.cs_mana_max,
            center.ability.extra.xmult
        }}
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card.ability.spell.mana = G.GAME.cs_mana_max
        end
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            local flipped = 0
            for _, jok in pairs(G.jokers.cards) do
                if jok ~= card and jok.facing == 'back' then
                    flipped = flipped + 1
                end
            end

            if #G.jokers.cards > 1 and flipped == (#G.jokers.cards - 1) then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end,

    in_pool = function(self, args)
        return cs_utils.is_alignment(self.config.alignment)
    end
}