SMODS.Booster {
    -- Booster info
    key = 'morph_normal_2',
    group_key = 'k_cs_morph_pack',
    kind = "Alignment",
    -- Shop
    cost = 2,
    config = {
        extra = 2,
        choose = 1
    },
    weight = 0.1,
    -- Sprite
	atlas = "CrazyStairsBoosters_atlas",
    pos = { x = 1, y = 1 },
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
        return cs_utils.random_alignment(true, false)
    end,
}