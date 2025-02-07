-- Import utility functions
cs_utils = NFS.load(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")()
assert(SMODS.load_file('hooks.lua'))()
CrazyStairs = SMODS.current_mod

-- Retrigger Jokers are somehow an optional feature whyy ç_ç
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

CrazyStairs.Alignment = SMODS.Center:extend {
    class_prefix = "ali",
    discovered = false,
    unlocked = true,
    set = "Alignment",
    atlas = "CrazyStairsAlignments_atlas",
    config = {},
    required_params = { "key", "atlas", "pos" },
    params = {
        bypass_discovery_center = false,
        bypass_discovery_ui = false,
        discover = false
    },
    pre_inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
    end,
    get_obj = function(self, key)
        if key == nil then
            return nil
        end
        return self.obj_table[key] or SMODS.Center:get_obj(key)
    end
}

function CrazyStairs.Alignment:is_discovered()
    return self.discovered or G.PROFILES[G.SETTINGS.profile].all_unlocked
end

function Card:undebuff_this()
    if self.debuff then
        self:add_to_deck(true)
        self:juice_up(0.3, 0.3)
        self.debuff = false

        if self.ability and self.ability.perishable then
            self.ability.perish_tally = 3
        end
    end
end

function Card:is_scaling()
    -- Most scaling Jokers are not perish compat
    if not self.config.center.perishable_compat then
        return true
    end

    -- And those that are...
    if self.config.center.key == 'j_yorick' or self.config.center.key == 'j_caino' or 
    self.config.center.key == 'j_egg' or self.config.center.key == 'j_fortune_teller' or
    self.config.center.key == 'j_campfire' then
        return true
    end

    return false
end

function CardArea:forcefully_add_to_highlighted(card, silent)
    if self.config.type == 'shop' then
        if self.highlighted[1] then
            self:remove_from_highlighted(self.highlighted[1])
        end
        --if not G.FUNCS.check_for_buy_space(card) then return false end
        self.highlighted[#self.highlighted+1] = card
        card:highlight(true)
        if not silent then play_sound('cardSlide1') end
    elseif self.config.type == 'joker' or self.config.type == 'consumeable' then
        if #self.highlighted >= self.config.highlighted_limit then 
            self:remove_from_highlighted(self.highlighted[1])
        end
        self.highlighted[#self.highlighted+1] = card
        card:highlight(true)
        if not silent then play_sound('cardSlide1') end
    else
        -- self.highlighted[#self.highlighted+1] = card
        card:highlight(true)
        if not silent then play_sound('cardSlide1') end

        if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
            self:parse_highlighted()
        end
    end
end

-- Keeping for when I need it :P
-- function SMODS.current_mod.reset_game_globals(run_start)
-- end

SMODS.Atlas {
    key = "CrazyStairs_atlas",
    path = "CsJokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "CrazyStairsSeals_atlas",
    path = "CsSeals.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "CrazyStairsVouchers_atlas",
    path = "CsVouchers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "CrazyStairsAlignments_atlas",
    path = "CsAlignments.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "CrazyStairsBoosters_atlas",
    path = "CsBoosters.png",
    px = 71,
    py = 95
}

SMODS.UndiscoveredSprite{
    key = 'Alignment',
    atlas = "CrazyStairsAlignments_atlas",
    pos = { x = 0, y = 1 },
    overlay_pos = { x = 0, y = 2 },
    no_overlay = true,
}

-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "cs_icon.png",
	px = 32,
	py = 32
})

impostor_warnings = {
    "Cease this tomfoolery at once",
    "Not funny, didn't laugh",
    "Stop impersonating my persona already",
    "You and I will never be the same",
    "We are through here",
    "It's time to stop",
    "You've come a long way, phony me",
    "I put an end to this buffoonery",
    "I do not speak like that",
}

-- List all Joker files here
local audio_files = {
    -- Joker
    "flip",
    "trap_set",
    "trap_triggered",
    -- Wicked
    "destroy",
    "bend",
    "damage",
    "wall",
    -- Patron
    "create",
    -- Seals
    "seal_lift_obtained",
    "seal_rank_obtained",
}

-- List all Joker files here
ALIGNMENT_JOKERS = {
    "neutral",
    "patron",
    "joker",
    "wicked",
    "keeper",
    "hacker",
    "splicer",
    "spectre"
}

LESS_ALIGNMENT_JOKERS = {
    "patron",
    "wicked",
    "joker",
    "keeper",
    "muggle",
    "hacker",
    "thief",
    "archon",
    "drifter",
    "heretic",
    "spectre",
    "chameleon",
    "none",
    "architect",
}

JOKER_FILES = {
    neutral = {
        "broken_drone",
    },
    patron = {
        "creator",
        "link",
        "portal",
    },
    joker = {
        "trap",
        "flipper",
        "bugged_trap",
    },
    wicked = {
        "destroyer",
        -- "bend_down",
        "damage",
        "four_walls",
        "vicious_joker",
    },
    keeper = {
        "restoration",
        "move_up"
    },
    hacker = {
        "upwards_escalator",
        "downwards_escalator",
        "escalator_fan",
    },
    splicer = {
        "strider",
    },
    spectre = {
        "random_teleport",
    }
}

for _, alignment in ipairs(ALIGNMENT_JOKERS) do
    for _, jkr in ipairs(JOKER_FILES[alignment]) do
        NFS.load(SMODS.current_mod.path .. "/jokers/" .. jkr .. ".lua")()
    end
end

-- List all seals files here
local seal_files = {
    "lift_seal",
    "rank_seal",
}

-- List all enchamcnent files here
local enchamcnemnt_files = {
    "fake_enh",
}

-- List all vouchers files here
local voucher_files = {
    "bender",
    "bending_the_rules",
}

-- List all vouchers files here
local booster_files = {
    "morph_pack",
}

-- List all type files here
-- local type_files = {
--     "alignment_type",
-- }


for i = 1, #seal_files do
    NFS.load(SMODS.current_mod.path .. "/seals/" .. seal_files[i] .. ".lua")()
end

for i = 1, #enchamcnemnt_files do
    NFS.load(SMODS.current_mod.path .. "/enhancements/" .. enchamcnemnt_files[i] .. ".lua")()
end

for i = 1, #voucher_files do
    NFS.load(SMODS.current_mod.path .. "/vouchers/" .. voucher_files[i] .. ".lua")()
end

for i = 1, #booster_files do
    NFS.load(SMODS.current_mod.path .. "/boosters/" .. booster_files[i] .. ".lua")()
end

-- for i = 1, #type_files do
--     NFS.load(SMODS.current_mod.path .. "/types/" .. type_files[i] .. ".lua")()
-- end

for i = 1, #LESS_ALIGNMENT_JOKERS do
    NFS.load(SMODS.current_mod.path .. "/alignments/" .. LESS_ALIGNMENT_JOKERS[i] .. ".lua")()
end

-- Load and register Sounds
for _, filename in ipairs(audio_files) do
    SMODS.Sound({
        key = filename,
        path = filename .. '.wav',
        vol = 0.5,
    })
end

-- local music_nums = {
-- 	balatro = 1,
-- 	crazystairs = 2
-- }

-- local music_strings = {
-- 	"balatro",
-- 	"crazystairs",
-- }

-- G.FUNCS.change_music = function(args)
-- 	G.ARGS.music_vals = G.ARGS.music_vals or music_strings
-- 	G.SETTINGS.QUEUED_CHANGE.music_change = G.ARGS.music_vals[args.to_key]
-- 	G.SETTINGS.music_selection = G.ARGS.music_vals[args.to_key]
-- end

-- setting_tabRef = G.UIDEF.settings_tab
-- function G.UIDEF.settings_tab(tab)
-- 	local setting_tab = setting_tabRef(tab)
-- 	if tab == 'Audio' then
-- 		local musicSelector = {n=G.UIT.R, config = {align = 'cm', r = 0}, nodes= {
-- 			create_option_cycle({ w = 6, scale = 0.8, label = localize('b_music_selector'), options = localize('ml_music_selector_opt'), opt_callback = 'change_music', current_option = ((music_nums)[G.SETTINGS.music_selection] or 1) })
-- 		}}
-- 		setting_tab.nodes[#setting_tab.nodes + 1] = musicSelector
-- 	end
-- 	return setting_tab
-- end

SMODS.current_mod.config_tab = function()
    return {n=G.UIT.ROOT, config = {align = "cm", minh = G.ROOM.T.h*0.25, padding = 0.0, r = 0.1, colour = G.C.GREY}, nodes = {
        {n = G.UIT.R, config = { align = "cm", minw = G.ROOM.T.w*0.25 }, nodes = {
            create_toggle{ label = localize("start_with_chameleon"), info = localize("start_with_chameleon_desc"), active_colour = CrazyStairs.badge_colour, ref_table = CrazyStairs.config, ref_value = "start_with_chameleon" },
        }},
    }}
end

SMODS.current_mod.custom_collection_tabs = function()
    local tally = 0
    for _, v in pairs(G.P_CENTER_POOLS['Alignment']) do
        if v:is_discovered() then
            tally = tally + 1
        end
    end
    return { UIBox_button {
        count = {tally = tally, of = #G.P_CENTER_POOLS['Alignment']},
        button = 'your_collection_alignments', label = {localize("k_alignment")}, minw = 5, id = 'your_collection_alignments'
    }}
end

G.FUNCS.your_collection_alignments = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
      definition = create_UIBox_your_collection_alignments(),
    }
end

create_UIBox_your_collection_alignments = function()
    return SMODS.card_collection_UIBox(G.P_CENTER_POOLS['Alignment'], {5,5}, {
        no_materialize = false,
        h_mod = 0.95,
    })
end

if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end
