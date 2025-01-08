-- Import utility functions
cs_utils = dofile(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")
inspect = dofile(SMODS.current_mod.path .. "/inspect.lua")

-- Create an atlas for cards to use
SMODS.Atlas {
    key = "CrazyStairs_atlas",
    path = "CsJokers.png",
    px = 71,
    py = 95
}

-- List all Joker files here
local joker_files = {
    "broken_drone",
    "flipper",
    "destroyer",
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

-- List all Joker files here
local audio_files = {
    "flip",
    "destroy",
}

-- Load and register Jokers using the utility function
for _, filename in ipairs(joker_files) do
    local joker = cs_utils.load_joker(filename)
    SMODS.Joker(joker)
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
            imy_utils.reset_destroyer_card(SMODS.find_card('j_cs_destroyer')[i])
        end
    end
end

if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end
