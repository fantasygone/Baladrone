-- Import utility functions
cs_utils = NFS.load(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")()

local original_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    original_set_ability(self, center, initial, delay_sprites)

    self.ability.cs_fake = self.ability and self.ability.cs_fake or false
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

function SMODS.current_mod.reset_game_globals(run_start)
    if run_start then
        for i = 1, #SMODS.find_card('j_cs_destroyer') do
            cs_utils.reset_destroyer_card(SMODS.find_card('j_cs_destroyer')[i])
        end
    end
end

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

-- Adding new custom contexts messes up all other Jokers. had to make specific checks
beforeall_context = {
    "j_cs_flipper",
    "j_cs_strider",
    "j_cs_move_up",
    "Brainstorm",
    "Blueprint",
}

-- List all Joker files here
local audio_files = {
    "flip",
    "destroy",
    "create",
    "trap_set",
    "trap_triggered",
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
    "splicer"
}

JOKER_FILES = {
    neutral = {
        "broken_drone",
    },
    patron = {
        "creator",
    },
    joker = {
        "trap",
        "flipper",
        "bugged_trap",
    },
    wicked = {
        "destroyer",
    },
    keeper = {
        "restoration",
        "move_up"
    },
    splicer = {
        "strider",
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



for i = 1, #seal_files do
    NFS.load(SMODS.current_mod.path .. "/seals/" .. seal_files[i] .. ".lua")()
end

for i = 1, #enchamcnemnt_files do
    NFS.load(SMODS.current_mod.path .. "/enhancements/" .. enchamcnemnt_files[i] .. ".lua")()
end

-- Load and register Sounds
for _, filename in ipairs(audio_files) do
    SMODS.Sound({
        key = filename,
        path = filename .. '.wav',
        vol = 0.5,
    })
end

local music_nums = {
	balatro = 1,
	crazystairs = 2
}

local music_strings = {
	"balatro",
	"crazystairs",
}

G.FUNCS.change_music = function(args)
	G.ARGS.music_vals = G.ARGS.music_vals or music_strings
	G.SETTINGS.QUEUED_CHANGE.music_change = G.ARGS.music_vals[args.to_key]
	G.SETTINGS.music_selection = G.ARGS.music_vals[args.to_key]
end

setting_tabRef = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
	local setting_tab = setting_tabRef(tab)
	if tab == 'Audio' then
		local musicSelector = {n=G.UIT.R, config = {align = 'cm', r = 0}, nodes= {
			create_option_cycle({ w = 6, scale = 0.8, label = localize('b_music_selector'), options = localize('ml_music_selector_opt'), opt_callback = 'change_music', current_option = ((music_nums)[G.SETTINGS.music_selection] or 1) })
		}}
		setting_tab.nodes[#setting_tab.nodes + 1] = musicSelector
	end
	return setting_tab
end

SMODS.Sound({
	vol = 0.6,
	pitch = 1,
	key = "cs_main_music",
	path = "cs_main_music.wav",
	select_music_track = function()
		return (G.SETTINGS.music_selection == "crazystairs") and 10 or false
	end,
})

if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end
