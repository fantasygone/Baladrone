for i, alignment in ipairs(ACH_ALIGNMENT_ORDER) do
    SMODS.Achievement {
        key = "find_" .. alignment,
        atlas = 'BaladroneAchievements_atlas',
        hidden_pos = { x = 0, y = i - 1 },
        pos = { x = 1, y = i - 1 },
        order = i,
        reset_on_startup = false,

        unlock_condition = function(self, args)
            if args.type == 'cs_morph' then
                return G.GAME.current_alignment == alignment
            end
        end
    }
end

for i, alignment in ipairs(ACH_ALIGNMENT_ORDER) do
    SMODS.Achievement {
        key = "win_with_" .. alignment,
        atlas = 'BaladroneAchievements_atlas',
        hidden_pos = { x = 0, y = i - 1 },
        pos = { x = 1, y = i - 1 },
        order = 0.1 + i,
        reset_on_startup = false,

        unlock_condition = function(self, args)
            if args.type == 'cs_win_alignment' and args.count <= 1 then
                return G.GAME.current_alignment == alignment
            end
        end
    }
end

-- Special 
SMODS.Achievement {
    key = "well_aligned",
    atlas = 'BaladroneAchievements_atlas',
    hidden_text = true,
    hidden_pos = { x = 0, y = 17 },
    pos = { x = 1, y = 17 },
    order = 0,
    reset_on_startup = false,

    unlock_condition = function(self, args)
        if args.type == 'cs_morph' then
            local tally = 0
            for _, v in pairs(G.P_CENTER_POOLS['Alignment']) do
                if v:is_discovered() then
                    tally = tally + 1
                end
            end

            -- Architect does not count
            if tally >= (#G.P_CENTER_POOLS['Alignment'] - 1) then
                return true
            end
        end
    end
}
-- SMODS.Achievement {
--     key = "full_circle",
--     atlas = 'BaladroneAchievements_atlas',
--     hidden_text = true,
--     hidden_pos = { x = 0, y = 17 },
--     pos = { x = 1, y = 17 },
--     order = 0.1,
--     reset_on_startup = false,

--     unlock_condition = function(self, args)
--         if args.type == 'cs_alignment_victory' then
--             for _, v in pairs(G.P_CENTER_POOLS['Alignment']) do
--                 if v.config.type and v.config.type ~= 'architect' and v.config.type ~= 'none' then
--                     if not (G.PROFILES[G.SETTINGS.profile].alignment_usage[v.config.type] and G.PROFILES[G.SETTINGS.profile].alignment_usage[v.config.type].victories and G.PROFILES[G.SETTINGS.profile].alignment_usage[v.config.type].victories > 0) then
--                         return false
--                     end
--                 end
--             end

--             return true
--         end
--     end
-- }
-- SMODS.Achievement {
--     key = "perfect_circle",
--     atlas = 'BaladroneAchievements_atlas',
--     hidden_text = true,
--     hidden_pos = { x = 0, y = 17 },
--     pos = { x = 1, y = 17 },
--     order = 0.2,
--     reset_on_startup = false,

--     unlock_condition = function(self, args)
--         if args.type == 'cs_alignment_victory' then
--             for _, v in pairs(G.P_CENTER_POOLS['Alignment']) do
--                 if v.config.type and v.config.type ~= 'architect' and v.config.type ~= 'none' then
--                     if not (G.PROFILES[G.SETTINGS.profile].alignment_usage[v.config.type] and G.PROFILES[G.SETTINGS.profile].alignment_usage[v.config.type].wins_by_key['stake_gold'] and G.PROFILES[G.SETTINGS.profile].alignment_usage[v.config.type].wins_by_key['stake_gold'] > 0) then
--                         return false
--                     end
--                 end
--             end

--             return true
--         end
--     end
-- }

-- Joker
SMODS.Achievement {
    key = "continuous_falling",
    atlas = 'BaladroneAchievements_atlas',
    hidden_pos = { x = 0, y = 2 },
    pos = { x = 1, y = 2 },
    order = 3.1,
    reset_on_startup = false,

    unlock_condition = function(self, args)
        if args.target == 'j_cs_bugged_trap' and args.type == 'repeat' and args.count >= 3 then
            return true
        end
    end
}

-- Keeper
SMODS.Achievement {
    key = "top_promotion",
    atlas = 'BaladroneAchievements_atlas',
    hidden_pos = { x = 0, y = 3 },
    pos = { x = 1, y = 3 },
    order = 4.1,
    reset_on_startup = false,

    unlock_condition = function(self, args)
        if G.STAGE == G.STAGES.RUN then
            for k, v in pairs(G.playing_cards) do
                if v.seal == 'cs_rank' and v:get_id() == 14 then return true end
            end

            return false
        end
    end
}