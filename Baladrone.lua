-- Import utility functions
cs_utils = NFS.load(SMODS.current_mod.path .. "/Baladrone-utils.lua")()
assert(SMODS.load_file('hooks.lua'))()
assert(SMODS.load_file('functions.lua'))()
Baladrone = SMODS.current_mod

Baladrone.SUIT_ORDER = {}
Baladrone.BUTTONS_CREATED = false

-- Retrigger Jokers are somehow an optional feature whyy ç_ç
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

-- Build suit order mapping
for i = #SMODS.Suit.obj_buffer, 1, -1 do
    Baladrone.SUIT_ORDER[SMODS.Suit.obj_buffer[i]] = i
end

Baladrone.Alignment = SMODS.Center:extend {
    class_prefix = "ali",
    discovered = false,
    unlocked = true,
    set = "Alignment",
    atlas = "BaladroneAlignments_atlas",
    config = {},
    required_params = { "key", "atlas", "pos", "undisc_pos" },
    params = {
        bypass_discovery_center = false,
        bypass_discovery_ui = false,
        discover = false
    },
    perishable_compat = true,
    pre_inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
    end,
    get_obj = function(self, key)
        if key == nil then
            return nil
        end
        return self.obj_table[key] or SMODS.Center:get_obj(key)
    end,
}

function set_alignment_win()
    local alignment_type
    for k, v in pairs(G.cs_alignments.cards) do
        alignment_type = tostring(v.config.center.key):gsub("ali_cs_", "")
        if alignment_type and v.ability.set == 'Alignment' then
            G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type] = G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type] or {count = 1, order = v.config.center.order, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}, victories = 0}
            if G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type] then
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].victories = (G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].victories or 0) + 1
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].wins = G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].wins or {}
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].wins[G.GAME.stake] = (G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].wins[G.GAME.stake] or 0) + 1
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] = (G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
            end

            check_for_unlock({type = 'cs_alignment_victory', alignment = alignment_type, count = G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].victories})
        end
    end
    G:save_settings()
end

function set_alignment_loss()
    local alignment_type
    for k, v in pairs(G.cs_alignments.cards) do
        alignment_type = tostring(v.config.center.key):gsub("ali_cs_", "")
        if alignment_type and v.ability.set == 'Alignment' then
            if G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type] then
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].losses = G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].losses or {}
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].losses[G.GAME.stake] = (G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].losses[G.GAME.stake] or 0) + 1
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].losses_by_key[SMODS.stake_from_index(G.GAME.stake)] = (G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].losses_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
            end
        end
    end
    G:save_settings()
end

function set_alignment_usage()
    local alignment_type
    for k, v in pairs(G.cs_alignments.cards) do
        alignment_type = tostring(v.config.center.key):gsub("ali_cs_", "")
        if alignment_type and v.ability.set == 'Alignment' then
            if G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type] then
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].count = G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type].count + 1
            else
                G.PROFILES[G.SETTINGS.profile].alignment_usage[alignment_type] = {count = 1, order = v.config.center.order, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}}
            end
        end
    end
    G:save_settings()
end


function Baladrone.Alignment:is_discovered()
    return self.discovered or G.PROFILES[G.SETTINGS.profile].all_unlocked
end

-- Ty JoyousSpring for this function!
Baladrone.create_overlay_stack = function()
    Baladrone.stack_area = {}

    Baladrone.stack_area[1] = CardArea(
        G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
        G.ROOM.T.h,
        6.5 * G.CARD_W,
        0.6 * G.CARD_H,
        {
            card_limit = G.cs_stack.config.card_limit,
            type = 'title',
            highlight_limit = 0,
            card_w = G.CARD_W * 0.7,
            draw_layers = { 'card' },
        }
    )

    for i = 1, #G.cs_stack.cards do
        local added_card = copy_card(G.cs_stack.cards[i])
        Baladrone.stack_area[1]:emplace(added_card)
    end

    G.FUNCS.overlay_menu({
        definition = create_UIBox_generic_options({
            contents = {
                {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        padding = 0.05,
                        minw = 7
                    },
                    nodes = {
                        {
                            n = G.UIT.O,
                            config = {
                                object = DynaText({
                                    string = { localize('b_cs_stack') },
                                    colours = { G.C.UI.TEXT_LIGHT },
                                    bump = true,
                                    silent = true,
                                    pop_in = 0,
                                    pop_in_rate = 4,
                                    minw = 10,
                                    shadow = true,
                                    y_offset = -0.6,
                                    scale = 0.9
                                })
                            }
                        }
                    }
                },
                {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        padding = 0.2,
                        minw = 7
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                r = 0.1,
                                minw = 7,
                                minh = 5,
                                align = "cm",
                                padding = 1,
                                colour = G.C.BLACK
                            },
                            nodes = {
                                {
                                    n = G.UIT.C,
                                    config = {
                                        align = "cm",
                                        padding = 0.07,
                                        no_fill = true,
                                        scale = 1
                                    },
                                    nodes = {
                                        {
                                            n = G.UIT.R,
                                            config = {
                                                align = "cm",
                                                padding = 0.07,
                                                no_fill = true,
                                                scale = 1
                                            },
                                            nodes = {
                                                {
                                                    n = G.UIT.O,
                                                    config = {
                                                        object = Baladrone.stack_area[1]
                                                    }
                                                },
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    })
end

Baladrone.create_thief_buttons = function()
    Baladrone.BUTTONS_CREATED = true

    G.GAME.alignment_buttons = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                minw = 1,
                minh = 0.3,
                padding = 0.15,
                r = 0.1,
                colour = G.C.CLEAR
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = "tm",
                        minw = 2,
                        padding = 0.1,
                        r = 0.1,
                        hover = true,
                        colour = G.C.ALIGNMENT['cs_thief'],
                        shadow = true,
                        button = "cs_access_stack"
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = "bcm", padding = 0 },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = localize('b_cs_stack'),
                                        scale = 0.35,
                                        colour = G.C.UI.TEXT_LIGHT
                                    }
                                }
                            }
                        },
                    }
                },
            }
        },
        config = {
            align = "tr",
            offset = { x = -11, y = 0 },
            major = G.consumeables,
            bond = 'Weak'
        }
    }
end

function Card:cs_undebuff_this()
    if self.debuff then
        self:add_to_deck(true)
        self:juice_up(0.3, 0.3)
        self.debuff = false

        if self.ability and self.ability.perishable then
            self.ability.perish_tally = 3
        end
    end
end

function Card:cs_is_scaling()
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

function Card:cs_can_interact()
    if (G.play and #G.play.cards > 0) or
        (G.CONTROLLER.locked) or 
        (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) or
        (self.debuff)
        then return false end
    return true
end

function CardArea:cs_forcefully_add_to_highlighted(card, silent)
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

function create_call_UIBox_buttons()
    local text_scale = 0.45
    local call_button = {n=G.UIT.C, config={id = 'call_button', align = "tm", minw = 2.5, padding = 0.3, r = 0.1, hover = true, colour = G.C.GREEN, button = "cs_call_cards_from_highlighted", one_press = true, shadow = true, func = 'cs_can_call'}, nodes={
      {n=G.UIT.R, config={align = "bcm", padding = 0}, nodes={
        {n=G.UIT.T, config={text = localize('b_call_hand'), scale = text_scale, colour = G.C.UI.TEXT_LIGHT, focus_args = {button = 'x', orientation = 'bm'}, func = 'set_button_pip'}}
      }},
    }}

    local t = {
      n=G.UIT.ROOT, config = {align = "cm", minw = 1, minh = 0.3,padding = 0.15, r = 0.1, colour = G.C.CLEAR}, nodes={
          call_button,

          {n=G.UIT.C, config={align = "cm", padding = 0.1, r = 0.1, colour =G.C.UI.TRANSPARENT_DARK, outline = 1.5, outline_colour = mix_colours(G.C.WHITE,G.C.JOKER_GREY, 0.7), line_emboss = 1}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
              {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = localize('b_sort_hand'), scale = text_scale*0.8, colour = G.C.UI.TEXT_LIGHT}}
              }},
              {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.C, config={align = "cm", minh = 0.7, minw = 0.9, padding = 0.1, r = 0.1, hover = true, colour =G.C.ORANGE, button = "sort_hand_value", shadow = true}, nodes={
                  {n=G.UIT.T, config={text = localize('k_rank'), scale = text_scale*0.7, colour = G.C.UI.TEXT_LIGHT}}
                }},
                {n=G.UIT.C, config={align = "cm", minh = 0.7, minw = 0.9, padding = 0.1, r = 0.1, hover = true, colour =G.C.ORANGE, button = "sort_hand_suit", shadow = true}, nodes={
                  {n=G.UIT.T, config={text = localize('k_suit'), scale = text_scale*0.7, colour = G.C.UI.TEXT_LIGHT}}
                }}
              }}
            }}
          }},
        }
      }
    return t
  end

-- Keeping for when I need it :P
-- I need it now!!
function SMODS.current_mod.reset_game_globals(run_start)
    if not run_start then
        if #G.GAME.current_round.cs_permanent_undebuff > 0 then
            for i, v in ipairs(G.GAME.current_round.cs_permanent_undebuff) do
                if cs_utils.contains(G.playing_cards, v) or cs_utils.contains(G.jokers.cards, v) then
                    SMODS.debuff_card(v, 'reset', nil)
                end
            end

            G.GAME.current_round.cs_permanent_undebuff = {}
        end
    end
end

SMODS.Atlas {
    key = "Baladrone_atlas",
    path = "CsJokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BaladroneSeals_atlas",
    path = "CsSeals.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BaladroneVouchers_atlas",
    path = "CsVouchers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BaladroneAlignments_atlas",
    path = "CsAlignments.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BaladroneBoosters_atlas",
    path = "CsBoosters.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BaladroneTarots_atlas",
    path = "CsTarots.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "BaladroneAchievements_atlas",
    path = "CsAchievements.png",
    px = 66,
    py = 66
}

SMODS.UndiscoveredSprite{
    key = 'Alignment',
    atlas = "BaladroneAlignments_atlas",
    pos = { x = 0, y = 1 },
    overlay_pos = { x = 0, y = 2 },
    no_overlay = true,
}

SMODS.Gradient {
    key = "multchips",
    colours = {G.C.RED, G.C.BLUE},
    cycle = 4,
    interpolation = 'linear'
}

SMODS.Gradient {
    key = "everyalignment",
    colours = {
        G.C.ALIGNMENT["cs_muggle"],
        G.C.ALIGNMENT["cs_hacker"],
        G.C.ALIGNMENT["cs_wicked"],
        G.C.ALIGNMENT["cs_keeper"],
        G.C.ALIGNMENT["cs_gremlin"],
        G.C.ALIGNMENT["cs_joker"],
        G.C.ALIGNMENT["cs_splicer"],
        G.C.ALIGNMENT["cs_drifter"],
        G.C.ALIGNMENT["cs_patron"],
        G.C.ALIGNMENT["cs_archon"],
        G.C.ALIGNMENT["cs_spectre"],
        G.C.ALIGNMENT["cs_thief"],
        G.C.ALIGNMENT["cs_reaver"],
        G.C.ALIGNMENT["cs_heretic"],
        G.C.ALIGNMENT["cs_necromancer"],
        G.C.ALIGNMENT["cs_chameleon"]
    },
    cycle = 12,
    interpolation = 'trig'
}

SMODS.Rarity {
    key = "Ultimate",
    default_weight = 0.01,
    badge_colour = SMODS.Gradients.cs_everyalignment,
    get_weight = function(self, weight, object_type)
        return weight
    end,
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
    "disco",
    -- Wicked
    "destroy",
    "bend",
    "damage",
    "wall",
    -- Patron
    "create",
    -- Thief
    "steal",
    -- Seals
    "seal_lift_obtained",
    "seal_rank_obtained",
}

ALIGNMENT_CARDS = {
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
    "splicer",
    "necromancer",
    "reaver",
    "gremlin",
}

ACH_ALIGNMENT_ORDER = {
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
    "splicer",
    "necromancer",
    "reaver",
    "gremlin",
    "spectre",
    "chameleon",
    "architect",
}

-- List all Joker files here
ALIGNMENT_JOKERS = {
    "neutral",
    "patron",
    "joker",
    "wicked",
    "keeper",
    "hacker",
    "thief",
    "drifter",
    "spectre",
    "necromancer",
    "reaver",
}

JOKER_FILES = {
    neutral = {
        "broken_drone",
    },
    patron = {
        "creator",
        "link",
        "portal",
        "call_the_orb",
    },
    joker = {
        "trap",
        "flip_right",
        "bugged_trap",
        "disco",
        "flipper",
    },
    wicked = {
        "destroy_above",
        "vicious_joker",
        "damage",
        "destroyer",
        "four_walls",
        "bend_up",
        "imperator",
    },
    keeper = {
        "restoration",
        "random_move",
        "move_up",
    },
    hacker = {
        "upwards_escalator",
        "downwards_escalator",
        "escalator_fan",
    },
    thief = {
        "card_thief",
        "steal_above",
    },
    drifter = {
        "strider",
    },
    spectre = {
        "random_teleport",
    },
    necromancer = {
        "dual_hands",
        "revival_point",
    },
    reaver = {
        "reaver_merge",
    },
}

for _, alignment in ipairs(ALIGNMENT_JOKERS) do
    local cards = {}
    for _, jkr in ipairs(JOKER_FILES[alignment]) do
        cards["j_cs_" .. jkr] = true
    end

    SMODS.ObjectType({
        key = alignment .. "_aligned",
        cards = cards,
        rarities = {
            {key = 'Common'},
            {key = 'Uncommon'},
            {key = 'Rare'},
            {key = 'cs_Ultimate'},
            {key = 'Legendary'},
        }
    })

    for _, jkr in ipairs(JOKER_FILES[alignment]) do
        if jkr then assert(SMODS.load_file('jokers/'.. jkr ..'.lua'))() end
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
    "morph_pack_1",
    "morph_pack_2",
    "morph_pack_3",
}

-- List all tarots files here
local tarot_files = {
    "annihilator",
}

-- List all spectral files here
local spectral_files = {
    "duality",
}

-- List all type files here
-- local type_files = {
--     "alignment_type",
-- }


for i = 1, #seal_files do
    if seal_files[i] then assert(SMODS.load_file('seals/'.. seal_files[i] ..'.lua'))() end
end

for i = 1, #enchamcnemnt_files do
    if enchamcnemnt_files[i] then assert(SMODS.load_file('enhancements/'.. enchamcnemnt_files[i] ..'.lua'))() end
end

for i = 1, #voucher_files do
    if voucher_files[i] then assert(SMODS.load_file('vouchers/'.. voucher_files[i] ..'.lua'))() end
end

for i = 1, #booster_files do
    if booster_files[i] then assert(SMODS.load_file('boosters/'.. booster_files[i] ..'.lua'))() end
end

for i = 1, #tarot_files do
    if tarot_files[i] then assert(SMODS.load_file('tarots/'.. tarot_files[i] ..'.lua'))() end
end

for i = 1, #spectral_files do
    if spectral_files[i] then assert(SMODS.load_file('spectrals/'.. spectral_files[i] ..'.lua'))() end
end

assert(SMODS.load_file('achievements.lua'))()

-- for i = 1, #type_files do
--     SMODS.load_file(SMODS.current_mod.path .. "/types/" .. type_files[i] .. ".lua")()
-- end

for i = 1, #ALIGNMENT_CARDS do
    if ALIGNMENT_CARDS[i] then assert(SMODS.load_file('alignments/'.. ALIGNMENT_CARDS[i] ..'.lua'))() end
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
-- 	Baladrone = 2
-- }

-- local music_strings = {
-- 	"balatro",
-- 	"Baladrone",
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
            create_toggle{ label = localize("start_with_chameleon"), info = localize("start_with_chameleon_desc"), active_colour = Baladrone.badge_colour, ref_table = Baladrone.config, ref_value = "start_with_chameleon" },
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
