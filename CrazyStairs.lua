-- Import utility functions
cs_utils = NFS.load(SMODS.current_mod.path .. "/CrazyStairs-utils.lua")()
CrazyStairs = SMODS.current_mod

-- Retrigger Jokers are somehow an optional feature whyy ç_ç
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

local original_get_badge_colour = get_badge_colour
function get_badge_colour(key)
    if key == "cs_temporary" then return G.C.ALIGNMENT["cs_spectre"] end

    return original_get_badge_colour(key)
end

local original_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    original_set_ability(self, center, initial, delay_sprites)

    self.ability.cs_fake = self.ability and self.ability.cs_fake or false
    self.ability.cs_temp = self.ability and self.ability.cs_temp or {active = false, expiry = nil}
end

local original_emplace = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    if self == G.cs_alignments and #G.cs_alignments.cards >= 1 then
        G.cs_alignments.cards[1]:start_dissolve()
    end
    original_emplace(self, card, location, stay_flipped)
end

local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)

    ret.current_round.cs_cards_are_blocked = false
    ret.current_alignment = 'none'
    return ret
end

local original_start_run = Game.start_run
Game.start_run = function(args)
    original_start_run(args)

    SMODS.add_card({set = 'Alignment', area = G.cs_alignments, key = 'ali_cs_none'})
end

-- local original_set_sprites = Card.set_sprites
-- function Card:set_sprites(_center, _front)
--     original_set_sprites(self, _center, _front)

--     if _center and _center.set and not self.children.center then
--         if not self.params.bypass_discovery_center and _center.set == 'Alignment' and not _center.discovered then
--             self.children.center = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS[_center.atlas or _center.set],(_center.set == 'Alignment' and G.j_undiscovered.pos))
--         end
--     end
-- end

CrazyStairs.Alignment = SMODS.Center:extend {
    class_prefix = "ali",
    discovered = false,
    unlocked = true,
    set = "Alignment",
    atlas = "CrazyStairsAlignments_atlas",
    config = {},
    required_params = { "key", "atlas", "pos" },
    params = {bypass_discovery_center = false},
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


-- -----

do
    local CardArea_draw_ref=CardArea.draw
    -- enable Alignments area to draw alignments in it
    function CardArea:draw()
        CardArea_draw_ref(self) -- this should be called before drawing cards inside it otherwise the area will block the cards and you can't hover on them
        if self.config.type == 'cs_alignment' then 
            for i = 1, #self.cards do
                if self.cards[i] ~= G.CONTROLLER.focused.target then
                    if not self.cards[i].highlighted then
                        if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
                    end
                end
            end
            for i = 1, #self.cards do  
                if self.cards[i] ~= G.CONTROLLER.focused.target then
                    if self.cards[i].highlighted then
                        if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
                    end
                end
            end
        end
    end

    local function cardarea_align(self,direction)
        local alignd='x'  -- align dimension
        local alignp='w'  -- align parameter (card.w)
        local alignp2='card_w' -- align parameter2 (self.card_w)
        local otherd='y'
        local otherp='h'
        if direction=='vertical' then
            alignd='y'
            alignp='h'
            alignp2='card_h'
            self.card_h=self.card_h or self.config.card_h or G.CARD_H
            -- self.T[alignp]-self[alignp2] determines the length of range of cards distributed inside. I set shop_ability.config.card_h to 0.1 to increase the range.
            otherd='x'
            otherp='w'
        end
        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then 
                card.T.r = 0.1*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T[alignd])
                local max_cards = math.max(#self.cards, self.config.temp_limit)
                card.T[alignd] = self.T[alignd] + (self.T[alignp]-self[alignp2])*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self[alignp2] - card.T[alignp])
                if #self.cards > 2 or (#self.cards > 1 and self == G.consumeables) or (#self.cards > 1 and self.config.spread) then
                    card.T[alignd] = self.T[alignd] + (self.T[alignp]-self[alignp2])*((k-1)/(#self.cards-1)) + 0.5*(self[alignp2] - card.T[alignp])
                elseif #self.cards > 1 and self ~= G.consumeables then
                    card.T[alignd] = self.T[alignd] + (self.T[alignp]-self[alignp2])*((k - 0.5)/(#self.cards)) + 0.5*(self[alignp2] - card.T[alignp])
                else
                    card.T[alignd] = self.T[alignd] + self.T[alignp]/2 - self[alignp2]/2 + 0.5*(self[alignp2] - card.T[alignp])
                end
                local highlight_height = G.HIGHLIGHT_H/2
                if not card.highlighted then highlight_height = 0 end
                card.T[otherd] = self.T[otherd] + self.T[otherp]/2 - card.T[otherp]/2 - highlight_height+ (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T[alignd])
                card.T[alignd] = card.T[alignd] + card.shadow_parrallax.x/30
            end
        end
        if not G.GAME.modifiers.cry_conveyor then table.sort(self.cards, function (a, b) return a.T[alignd] + a.T[alignp]/2 - 100*(a.pinned and a.sort_id or 0) < b.T[alignd] + b.T[alignp]/2 - 100*(b.pinned and b.sort_id or 0) end) end
    end

    local CardArea_align_cards_ref=CardArea.align_cards
    -- enable Alignment area to align cards in its border.
    function CardArea:align_cards()
        if self.config.type == 'cs_alignment' then
            self.T.y=self.T.y-0.04 -- dunno why abilities are slightly lower than upper border. move them up a bit
            cardarea_align(self)
            self.T.y=self.T.y+0.04
        end
        CardArea_align_cards_ref(self)
    end

    local CardArea_can_highlight_ref=CardArea.can_highlight
    -- enable cards in Alignment area to be highlighted (clicked)
    function CardArea:can_highlight(card)
        if self.config.type == 'cs_alignment' then
            return false
        end
        return CardArea_can_highlight_ref(self,card)
    end

    -- local CardArea_add_to_highlight_ref=CardArea.add_to_highlighted
    -- -- let Alignment area add highlights like jokers and consumables area
    -- function CardArea:add_to_highlighted(card, silent)
    --     if self.config.type == 'cs_alignment' then
    --         if #self.highlighted >= self.config.highlighted_limit then 
    --             self:remove_from_highlighted(self.highlighted[1])
    --         end
    --         self.highlighted[#self.highlighted+1] = card
    --         card:highlight(true)
    --         if not silent then play_sound('cardSlide1') end
    --         return
    --     end
    --     CardArea_add_to_highlight_ref(self,card,silent)
    -- end

    -- local Card_can_sell_card_ref=Card.can_sell_card
    -- -- let Abilities always be sellable
    -- function Card:can_sell_card(context)
    --     if self.ability.set=='Alignment' then
    --         return false
    --     end
    --     return Card_can_sell_card_ref(self,context)
    -- end

    -- G.FUNCS.can_move_consumeable = function(e)
    --     local card=G.consumeables.highlighted[1]
    --     if not (card and (card.ability.set=='Alignment' and G.cs_alignment.config.card_limit>#G.cs_alignment.cards)) then
    --         e.config.colour = G.C.UI.BACKGROUND_INACTIVE
    --         e.config.button = nil
    --     else
    --         e.config.colour = G.C.ORANGE
    --         e.config.button = 'move_consumeable'
    --     end
    -- end
    -- G.FUNCS.move_consumeable = function(e) 
    --     local c1 = e.config.ref_table
    --     c1.area:remove_from_highlighted(c1)
    --     c1.area:remove_card(c1)
    --     if c1.ability.set=='Alignment' then
    --         G.cs_alignment:emplace(c1)
    --     end
    -- end

    -- local G_FUNCS_check_for_buy_space_ref=G.FUNCS.check_for_buy_space
    -- G.FUNCS.check_for_buy_space = function(card)
    --     if card.ability.set=='Alignment' then
    --         if #G.cs_alignment.cards < G.cs_alignment.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0) then
    --             return true
    --         else
    --             return false
    --         end
    --     end
    --     return G_FUNCS_check_for_buy_space_ref(card)
    -- end
end -- Alignment Area and Alignment Cards preparation


-- -----

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

-- Adding new custom contexts messes up all other Jokers. had to make specific checks
beforeall_context = {
    "j_cs_flipper",
    "j_cs_strider",
    "j_cs_move_up",
    -- Jokers that copy
    "j_cs_bugged_trap",
    "Brainstorm",
    "Blueprint",
}
startingshop_context = {
    "j_cs_random_teleport",
    -- Jokers that copy
    "j_cs_bugged_trap",
    "Brainstorm",
    "Blueprint",
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
    "none",
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
        -- "bend_down",
        "damage",
        "four_walls",
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

-- for i = 1, #type_files do
--     NFS.load(SMODS.current_mod.path .. "/types/" .. type_files[i] .. ".lua")()
-- end

for i = 1, #LESS_ALIGNMENT_JOKERS do
    NFS.load(SMODS.current_mod.path .. "/alignments/" .. LESS_ALIGNMENT_JOKERS[i] .. ".lua")()
end



-- SMODS.ObjectType {
--     key = 'Alignment',
--     -- Pool
--     cards = {
--         ["ali_cs_patron"] = true,
--         ["ali_cs_wicked"] = true,
--         ["ali_cs_joker"] = true,
--     },
--     -- Colors
--     primary_colour = HEX('ffffff'),
--     secondary_colour = HEX('ffffff'),
--     -- Settings
--     shop_rate = 0,
-- }

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
