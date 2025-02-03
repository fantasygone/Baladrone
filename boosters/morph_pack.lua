SMODS.Booster {
    -- Booster info
    key = 'morph_normal_1',
    group_key = 'k_cs_morph_pack',
    kind = "Alignment",
    -- Shop
    cost = 2,
    config = {
        extra = 2,
        choose = 1
    },
    weight = 10,
    -- Sprite
	atlas = "CrazyStairsBoosters_atlas",
    pos = { x = 0, y = 1 },
    -- Player daya
    discovered = false,

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.choose,
                center.ability.extra
            }
        }
    end,

    create_card = function(self, card, i)
        return SMODS.create_card({
            set = 'Alignment',
            soulable = true,
            no_edition = true
        })
    end,
}