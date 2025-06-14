-- Import utility functions
cs_utils = NFS.load(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")()
assert(SMODS.load_file('hooks.lua'))()
CrazyStairs = SMODS.current_mod

CrazyStairs.SUIT_ORDER = {}
CrazyStairs.BUTTONS_CREATED = false

-- Retrigger Jokers are somehow an optional feature whyy ç_ç
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

-- Build suit order mapping
for i = #SMODS.Suit.obj_buffer, 1, -1 do
    CrazyStairs.SUIT_ORDER[SMODS.Suit.obj_buffer[i]] = i
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

-- Ty JoyousSpring for this function!
CrazyStairs.create_overlay_stack = function()
    CrazyStairs.stack_area = {}

    CrazyStairs.stack_area[1] = CardArea(
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
        CrazyStairs.stack_area[1]:emplace(added_card)
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
                                                        object = CrazyStairs.stack_area[1]
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

CrazyStairs.create_thief_buttons = function()
    CrazyStairs.BUTTONS_CREATED = true

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

function create_call_UIBox_buttons()
    local text_scale = 0.45
    local call_button = {n=G.UIT.C, config={id = 'call_button', align = "tm", minw = 2.5, padding = 0.3, r = 0.1, hover = true, colour = G.C.GREEN, button = "call_cards_from_highlighted", one_press = true, shadow = true, func = 'can_call'}, nodes={
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

SMODS.Atlas {
    key = "CrazyStairsTarots_atlas",
    path = "CsTarots.png",
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
        "call_the_orb",
    },
    joker = {
        "trap",
        "bugged_trap",
        "disco",
        "flipper",
    },
    wicked = {
        "destroyer",
        -- "bend_down",
        "damage",
        "vicious_joker",
        "four_walls",
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
    }
}

for _, alignment in ipairs(ALIGNMENT_JOKERS) do
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
    print(tarot_files[i])
    if tarot_files[i] then assert(SMODS.load_file('tarots/'.. tarot_files[i] ..'.lua'))() end
end

-- for i = 1, #type_files do
--     SMODS.load_file(SMODS.current_mod.path .. "/types/" .. type_files[i] .. ".lua")()
-- end

for i = 1, #LESS_ALIGNMENT_JOKERS do
    if LESS_ALIGNMENT_JOKERS[i] then assert(SMODS.load_file('alignments/'.. LESS_ALIGNMENT_JOKERS[i] ..'.lua'))() end
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

G.FUNCS.cs_access_stack = function(e)
    CrazyStairs.create_overlay_stack()
end

G.FUNCS.draw_from_deck_to_other_hands = function(e)
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and
        G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then 
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
        return true
    end

    local hand_space_2 = e or math.min(#G.deck.cards, G.hand_2.config.card_limit - #G.hand_2.cards)
    local hand_space_3 = e or math.min(#G.deck.cards, G.hand_3.config.card_limit - #G.hand_3.cards)

    delay(0.3)
    for i=1, hand_space_2 do
        draw_card(G.deck,G.hand_2, i*100/hand_space_2,'up', true)
    end

    delay(0.3)
    for i=1, hand_space_3 do
        draw_card(G.deck,G.hand_3, i*100/hand_space_3,'up', true)
    end

    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
        G.GAME.show_call_button = true
    return true end }))
end

G.FUNCS.can_call = function(e)
    if #G.hand.highlighted + #G.hand_2.highlighted + #G.hand_3.highlighted <= 0 or not G.GAME.show_call_button then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'call_cards_from_highlighted'
    end
end

G.FUNCS.call_cards_from_highlighted = function(e, hook)
    G.GAME.show_call_button = false

    stop_use()
    card_eval_status_text(SMODS.find_card('j_cs_call_the_orb')[1], 'extra', nil, nil, nil, {message = localize('cs_called'), colour = G.C.ALIGNMENT['cs_patron']})
    G.GAME.current_round.orb_card.cards = {}

    local hand_high = {}
    for _, card in ipairs(G.hand.highlighted) do
        table.insert(hand_high, card)
    end
    for i = 1, #hand_high do
        table.insert(G.GAME.current_round.orb_card.cards, hand_high[i])
    end

    local hand2_high = {}
    for _, card in ipairs(G.hand_2.highlighted) do
        table.insert(hand2_high, card)
    end
    for i = 1, #hand2_high do
        table.insert(G.GAME.current_round.orb_card.cards, hand2_high[i])
    end

    local hand3_high = {}
    for _, card in ipairs(G.hand_3.highlighted) do
        table.insert(hand3_high, card)
    end
    local hand3_high = G.hand_3.highlighted
    for i = 1, #hand3_high do
        table.insert(G.GAME.current_round.orb_card.cards, hand3_high[i])
    end

    G.hand:unhighlight_all()
    G.hand_2:unhighlight_all()
    G.hand_3:unhighlight_all()
    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
        cs_utils.return_extra_hands_to_deck(#G.hand_2.cards > 0, #G.hand_3.cards > 0, false)
    return true end }))
end

if JokerDisplay then
    SMODS.load_file("joker_display_definitions.lua")()
end
