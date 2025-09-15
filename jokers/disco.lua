SMODS.Joker {
    key = "disco",
    config = {
        alignment = 'joker',
        min = 2
    },
    -- Sprite settings
    atlas = "Baladrone_atlas",
    pos = { x = 3, y = 3 },
    soul_pos = nil,
    -- Card info
    rarity = 2, --Uncommon
    cost = 6,
    -- Player data
    unlocked = true,
    discovered = false,
    -- Compatibility
    blueprint_compat = false,   -- FALSE for passive Jokers
    perishable_compat = true,   -- FALSE for scaling Jokers
    eternal_compat = true,      -- FALSE for Jokers to be sold or that expire by themselves
    rental_compat = true,       -- FALSE for idk??

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = {key = 'cs_joker_aligned', set = 'Other'}
        return {vars = {
            center.ability.min
        }}
    end,

    calculate = function (self, card, context)
        if context.before and context.scoring_hand and #context.scoring_hand >= card.ability.min and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled and not context.blueprint then
            local editions_found = {}

            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].edition and not cs_utils.contains(editions_found, context.scoring_hand[i].edition.type) then
                    table.insert(editions_found, context.scoring_hand[i].edition.type)
                end
            end

            if #editions_found == #context.scoring_hand then
                play_sound('cs_disco')
                G.GAME.blind:disable()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            end
        end
    end,

    in_pool = function(self, args)
        if G.STAGE == G.STAGES.RUN and cs_utils.is_alignment(self.config.alignment) then
            for k, v in pairs(G.playing_cards) do
                if v.edition then return true end
            end
        end
    end
}