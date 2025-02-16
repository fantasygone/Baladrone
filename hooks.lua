local config = SMODS.current_mod.config

-- Game hooks
do
    local igo = Game.init_game_object
    Game.init_game_object = function(self)
        local ret = igo(self)

        ret.current_alignment = 'none'
        ret.first_shop_alignment = false
        ret.first_shop_chameleon = not config.start_with_chameleon

        ret.current_round.cs_cards_are_blocked = false
        ret.current_round.orb_card = {called = false, cards = {}}

        ret.shop.voucher_max = 1
        ret.shop.booster_max = 2
        return ret
    end

    local original_update_selecting_hand = Game.update_selecting_hand
    Game.update_selecting_hand = function(self, dt)
        if #G.hand.cards < 1 and #G.deck.cards < 1 and #G.play.cards < 1 and #G.cs_stack.cards > 0 then
            local thief_ali = G.cs_alignments.cards[1]
            cs_utils.move_cards(G.cs_alignments, G.hand, {thief_ali})

            delay(0.3)

            card_eval_status_text(thief_ali, 'extra', nil, nil, nil, {message = localize('cs_borrowed'), colour = G.C.ALIGNMENT['cs_thief']})

            cs_utils.return_stolen_cards(G.hand)

            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                draw_card(G.hand,G.cs_alignments, 90,'up', nil, thief_ali)
                cs_utils.stop_stealing()
            return true end }))
        else
            original_update_selecting_hand(self, dt)
        end
    end

    local original_start_run = Game.start_run
    Game.start_run = function(self, args)
        original_start_run(self, args)

        if not args.savetext then
            CrazyStairs.BUTTONS_CREATED = false
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0,func = function()
                G.GAME.shop.booster_max = G.GAME.shop.booster_max + 1

                SMODS.add_card({set = 'Alignment', area = G.cs_alignments, key = 'ali_cs_none'})
            return true end }))
        else
            if cs_utils.is_alignment('thief') then
                CrazyStairs.create_thief_buttons()
            end
        end
    end
end

--UIDEF hooks
do
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
end

--General hooks
do
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
            return G.P_CENTERS['p_cs_morph_normal_'..(math.random(1, 3))]
        end

        return original_get_pack(self, _key, _type)
    end

    local original_draw_card = draw_card
    function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
        if card and card.cs_stolen then
            return original_draw_card(from, G.cs_stack, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
        end

        return original_draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    end

    local original_level_up_hand = level_up_hand
    function level_up_hand(card, hand, instant, amount)
        cs_level_by = amount or 1

        SMODS.calculate_context( {cs_upgrade_hand = (cs_level_by > 0)} )

        original_level_up_hand(card, hand, instant, cs_level_by)
    end

    local original_create_UIBox_buttons = create_UIBox_buttons
    function create_UIBox_buttons()
        if #SMODS.find_card('j_cs_call_the_orb') > 0 and not G.GAME.current_round.orb_card.called and G.GAME.blind:get_type() == 'Small' then
            return create_call_UIBox_buttons()
        else
            return original_create_UIBox_buttons()
        end
    end
end

--Card hooks
do
    local original_set_ability = Card.set_ability
    function Card:set_ability(center, initial, delay_sprites)
        if self.config.center.set == 'Alignment' then
            self.params.discover = false
        end

        original_set_ability(self, center, initial, delay_sprites)

        self.ability.cs_fake = self.ability and self.ability.cs_fake or false
        self.ability.cs_stolen = self.ability and self.ability.cs_stolen or false
        self.ability.cs_temp = self.ability and self.ability.cs_temp or {active = false, expiry = nil}
    end
end

--CardArea hooks
do
    local original_emplace = CardArea.emplace
    function CardArea:emplace(card, location, stay_flipped)
        original_emplace(self, card, location, stay_flipped)

        if self == G.cs_alignments and #G.cs_alignments.cards > G.cs_alignments.config.card_limit then
            G.cs_alignments.cards[1]:start_dissolve()
        end
    end

    local original_change_size = CardArea.change_size
    function CardArea:change_size(delta)
        original_change_size(self, delta)

        if self == G.hand then
            G.hand_2:change_size(delta)
            G.hand_3:change_size(delta)
        end
    end
end

--FUNCS hooks
do
    local original_discard_cards_from_highlighted = G.FUNCS.discard_cards_from_highlighted
    G.FUNCS.discard_cards_from_highlighted = function(e, hook)
        SMODS.calculate_context({cs_click_discard = true})

        original_discard_cards_from_highlighted(e, hook)
    end

    local original_play_cards_from_highlighted = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e)
        SMODS.calculate_context({cs_click_play = true})

        original_play_cards_from_highlighted(e)
    end
end

-- ALIGNMENT CARD AREA HOOKS
do
    local CardArea_draw_ref=CardArea.draw
    -- enable Alignments area to draw alignments in it
    function CardArea:draw()
        if ((self == G.hand_2 or self == G.hand_3) and (#SMODS.find_card('j_cs_call_the_orb') < 1 or (G.GAME.blind:get_type() and G.GAME.blind:get_type() ~= 'Small') or G.GAME.current_round.orb_card.called)) then
            return
        end

        CardArea_draw_ref(self) -- this should be called before drawing cards inside it otherwise the area will block the cards and you can't hover on them

        if self.config.type == 'cs_alignment' or self.config.type == 'cs_stack' then
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

    local function cardarea_align(self)
        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then 
                if #self.cards > 1 then
                    card.T.x = (self.T.x + (self.T.w-self.card_w)*((k-1)/(#self.cards-1)) + 0.5*(self.card_w - card.T.w)) - 0.09
                else
                    card.T.x = (self.T.x + self.T.w/2 - self.card_w/2 + 0.5*(self.card_w - card.T.w)) - 0.09
                end
                local highlight_height = G.HIGHLIGHT_H
                if not card.highlighted then highlight_height = 0 end
                card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - highlight_height + (not card.highlighted and (G.SETTINGS.reduced_motion and 0 or 1)*0.05*math.sin(1*1.666*G.TIMERS.REAL+card.T.x) or 0)
                card.T.x = card.T.x + card.shadow_parrallax.x/30
            end
        end
        table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
    end

    local CardArea_align_cards_ref=CardArea.align_cards
    -- enable Alignment area to align cards in its border.
    function CardArea:align_cards()
        if self.config.type == 'cs_alignment' or self.config.type == 'cs_stack' then
            -- self.T.y=self.T.y-0.04 -- dunno why abilities are slightly lower than upper border. move them up a bit
            cardarea_align(self)
            -- self.T.y=self.T.y+0.04
        end
        CardArea_align_cards_ref(self)
    end

    local CardArea_can_highlight_ref=CardArea.can_highlight
    -- enable cards in Alignment area to be highlighted (clicked)
    function CardArea:can_highlight(card)
        if self.config.type == 'cs_alignment' or self.config.type == 'cs_stack' then
            return false
        end
        return CardArea_can_highlight_ref(self,card)
    end

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

    local G_FUNCS_check_for_buy_space_ref=G.FUNCS.check_for_buy_space
    G.FUNCS.check_for_buy_space = function(card, forstack)
        if card.ability.set=='Enhanced' or card.ability.set=='Default' and forstack then
            if #G.cs_stack.cards < G.cs_stack.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0) then
                return true
            else
                return false
            end
        end
        return G_FUNCS_check_for_buy_space_ref(card)
    end
end


-- HAND 2 AND HAND 3 CARD AREA HOOKS
do
    local CardArea_add_to_highlight_ref=CardArea.add_to_highlighted
    function CardArea:add_to_highlighted(card, silent)
        if (self.config.type == 'hand' and (#G.hand.highlighted + #G.hand_2.highlighted + #G.hand_3.highlighted) >= G.hand.config.highlighted_limit) then
            return
        end
        CardArea_add_to_highlight_ref(self,card,silent)
    end
end