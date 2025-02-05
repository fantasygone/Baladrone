local config = SMODS.current_mod.config

-- Game hooks
local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)

    ret.first_shop_alignment = false
    ret.first_shop_chameleon = not config.start_with_chameleon

    ret.current_round.cs_cards_are_blocked = false
    ret.current_alignment = 'none'

    ret.shop.voucher_max = 1
    ret.shop.booster_max = 2
    return ret
end

local original_start_run = Game.start_run
Game.start_run = function(self, args)
    original_start_run(self, args)

    if not args.savetext then
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
            G.GAME.shop.booster_max = G.GAME.shop.booster_max + 1

            SMODS.add_card({set = 'Alignment', area = G.cs_alignments, key = 'ali_cs_none'})
        return true end }))
    end
end

-- local original_update_shop = Game.update_shop
-- Game.update_shop = function(self, dt)
--     if not G.STATE_COMPLETE then
--         for i = 1, #G.jokers.cards do
--             if cs_utils.contains(startingshop_context, G.jokers.cards[i].ability.name) then
--                 G.jokers.cards[i]:calculate_joker({cs_entering_shop = true})
--             end
--         end
--     end
--     original_update_shop(self, dt)
-- end
--

local original_use_and_sell_buttons = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if card.area and card.area == G.pack_cards and card.ability.set == 'Alignment' then
        return {
            n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_card'}, nodes={
            {n=G.UIT.T, config={text = localize('b_morph'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
            }},
        }}
    end

    return original_use_and_sell_buttons(card)
end

local original_get_badge_colour = get_badge_colour
function get_badge_colour(self, key)
    if key == "cs_temporary" then return G.C.ALIGNMENT["cs_spectre"] end

    return original_get_badge_colour(self, key)
end

local original_get_pack = get_pack
function get_pack(self, _key, _type)
    if not G.GAME.first_shop_alignment and not G.GAME.banned_keys['p_cs_morph_normal_1'] then
        G.GAME.first_shop_alignment = true
        G.GAME.shop.booster_max = G.GAME.shop.booster_max - 1
        return G.P_CENTERS['p_cs_morph_normal_1']
    end

    return original_get_pack(self, _key, _type)
end

local original_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    if self.config.center.set == 'Alignment' then
        self.params.discover = false
    end

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

    if self == G.cs_alignments and #G.cs_alignments.cards >= 1 then
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            for i = 1, #G.jokers.cards do
                local joker_card = G.jokers.cards[i]

                if joker_card.ability.alignment and not cs_utils.is_alignment(joker_card.ability.alignment) then
                    joker_card:remove_from_deck()
                    joker_card:start_dissolve()
                end
            end
        return true end }))
    end
end

-- ALIGNMENT CARD AREA HOOKS
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
    G.FUNCS.move_consumeable = function(e) 
        local c1 = e.config.ref_table
        c1.area:remove_from_highlighted(c1)
        c1.area:remove_card(c1)
        if c1.ability.set=='Alignment' then
            G.cs_alignment:emplace(c1)
        end
    end

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