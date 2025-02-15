SMODS.Joker {
    key = "disco",
    config = {
        alignment = 'joker',
    },
    -- Sprite settings
    atlas = "CrazyStairs_atlas",
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
        }}
    end,

    calculate = function (self, card, context)
        if context.before and context.scoring_hand and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled and not context.blueprint then
            local editioned = true

            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].edition then editioned = false; break end
            end

            if editioned then
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