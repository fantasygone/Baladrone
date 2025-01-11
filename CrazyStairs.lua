-- Import utility functions
cs_utils = NFS.load(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")()

local original_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    original_set_ability(self, center, initial, delay_sprites)

    if self.ability then
        self.ability.cs_fake = false
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
    "lift_seal_obtained",
}

-- List all Joker files here
local joker_files = {
    "broken_drone",
    "creator",
    "flipper",
    "trap",
    "destroyer",
    "strider",
}

local seal_files = {
    "lift_seal",
}

for i = 1, #joker_files do
    NFS.load(SMODS.current_mod.path .. "/jokers/" .. joker_files[i] .. ".lua")()
end

for i = 1, #seal_files do
    NFS.load(SMODS.current_mod.path .. "/seals/" .. seal_files[i] .. ".lua")()
end

-- Load and register Sounds
for _, filename in ipairs(audio_files) do
    SMODS.Sound({
        key = filename,
        path = filename..'.wav',
    })
end

function SMODS.current_mod.reset_game_globals(run_start)
    if run_start then
        for i = 1, #SMODS.find_card('j_cs_destroyer') do
            cs_utils.reset_destroyer_card(SMODS.find_card('j_cs_destroyer')[i])
        end
    end
end

if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end
