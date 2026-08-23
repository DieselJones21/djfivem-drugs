--[[
    Drug definitions.

    Default craft rule:
      5 of each ingredient → 7 finished product

    Combat stim effect (Pink Energy / Honda Pills / Black Lotus):
      25% armor + 45s infinite stamina — no screen FX
]]

-- Shared combat stim (armor + stamina only)
local COMBAT_STIM = {
    enabled = true,
    duration = 45000,
    armorPercent = 25,
    stamina = true,
    -- intentionally no timecycle / screenEffect / shake / walk
}

Config.Drugs = {
    --------------------------------------------------
    -- Pink Energy
    --------------------------------------------------
    pink_energy = {
        label = 'Pink Energy',
        item = 'pink_energy',
        description = 'High-octane pink stimulant brew',
        ingredients = {
            { item = 'pink_crystal_shards', amount = 5 },
            { item = 'pink_energy_solvent', amount = 5 },
            { item = 'chug_jars', amount = 5 },
            { item = 'caffeine_powder', amount = 5 },
        },
        process = {
            label = 'Mix Pink Energy',
            coords = vec3(856.71, -943.52, 25.28),
            heading = 268.68,
            duration = 14000,
            prop = {
                model = `bkr_prop_meth_table01a`,
                heading = 268.68,
            },
            anim = {
                dict = 'anim@amb@business@coc@coc_unpack_cut@',
                clip = 'fullcut_cycle_v6_cokecutter',
            },
            output = { item = 'pink_energy', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 8, label = 'Pink Energy Lab' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 550,
            maxPrice = 900,
            minQty = 1,
            maxQty = 4,
        },
        effects = {
            enabled = COMBAT_STIM.enabled,
            label = 'Chugging Pink Energy',
            useTime = 3500,
            duration = COMBAT_STIM.duration,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = COMBAT_STIM.armorPercent,
            stamina = COMBAT_STIM.stamina,
        },
    },

    --------------------------------------------------
    -- Weed
    --------------------------------------------------
    weed = {
        label = 'Bagged Weed',
        item = 'weed_bag',
        description = 'Street bag of weed',
        ingredients = {
            { item = 'weed_bud', amount = 5 },
            { item = 'baggies', amount = 5 },
        },
        process = {
            label = 'Bag Weed',
            coords = vec3(284.67, -1773.03, 27.06),
            heading = 53.19,
            duration = 9000,
            prop = {
                model = `bkr_prop_weed_table_01a`,
                heading = 53.19,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'weed_bag', amount = 7 },
            blip = { enabled = false, sprite = 469, color = 2, label = 'Weed Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'cash', -- only weed pays clean cash
            minPrice = 80,
            maxPrice = 160,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            label = 'Smoking Weed',
            useTime = 5000,
            duration = 45000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            stress = -30,
            -- no screen FX
        },
    },

    --------------------------------------------------
    -- Cocaine
    --------------------------------------------------
    cocaine = {
        label = 'Cocaine Brick Bag',
        item = 'cocaine_bag',
        description = 'Processed cocaine ready to move',
        ingredients = {
            { item = 'coca_leaves', amount = 5 },
            { item = 'acetone', amount = 5 },
            { item = 'baggies', amount = 5 },
        },
        process = {
            label = 'Cook Cocaine',
            coords = vec3(-2950.20, 637.03, 23.18),
            heading = 108.26,
            duration = 12000,
            prop = {
                model = `bkr_prop_coke_table01a`,
                heading = 108.26,
            },
            anim = {
                dict = 'anim@amb@business@coc@coc_unpack_cut@',
                clip = 'fullcut_cycle_v6_cokecutter',
            },
            output = { item = 'cocaine_bag', amount = 7 },
            blip = { enabled = false, sprite = 501, color = 0, label = 'Cocaine Table' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 250,
            maxPrice = 420,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            label = 'Snorting Cocaine',
            useTime = 4000,
            duration = 45000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            armorPercent = 15,
            stamina = true,
            -- no screen FX
        },
    },

    --------------------------------------------------
    -- Lean
    --------------------------------------------------
    lean = {
        label = 'Lean Cup',
        item = 'lean_cup',
        description = 'Mixed lean ready to sell',
        ingredients = {
            { item = 'codeine', amount = 5 },
            { item = 'ice', amount = 5 },
            { item = 'cups', amount = 5 },
            { item = 'sprite', amount = 5 },
            { item = 'hard_candies', amount = 5 },
        },
        process = {
            label = 'Mix Lean',
            coords = vec3(-1784.34, -401.11, 45.47),
            heading = 187.96,
            duration = 10000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 187.96,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'lean_cup', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 27, label = 'Lean Bench' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 140,
            maxPrice = 260,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            label = 'Sipping Lean',
            useTime = 4500,
            duration = 45000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            stress = -40,
            -- no screen FX
        },
    },

    --------------------------------------------------
    -- Honda Pills
    --------------------------------------------------
    honda_pills = {
        label = 'Honda Pills',
        item = 'honda_pills',
        description = 'Pressed Honda pills ready to move',
        ingredients = {
            { item = 'honda_pill_capsules', amount = 5 },
            { item = 'honda_formula', amount = 5 },
            { item = 'honda_extract', amount = 5 },
        },
        process = {
            label = 'Press Honda Pills',
            coords = vec3(-1486.62, -909.08, 9.02),
            heading = 48.52,
            duration = 11000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 48.52,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'honda_pills', amount = 7 },
            blip = { enabled = false, sprite = 51, color = 46, label = 'Honda Press' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 500,
            maxPrice = 850,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = COMBAT_STIM.enabled,
            label = 'Popping Honda Pills',
            useTime = 3000,
            duration = COMBAT_STIM.duration,
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger', flag = 49 },
            armorPercent = COMBAT_STIM.armorPercent,
            stamina = COMBAT_STIM.stamina,
        },
    },

    --------------------------------------------------
    -- Stab Juice
    --------------------------------------------------
    stab_juice = {
        label = 'Stab Juice',
        item = 'stab_juice',
        description = 'Mixed Stab Juice ready to move',
        ingredients = {
            { item = 'stab_powder', amount = 5 },
            { item = 'stab_candy', amount = 5 },
            { item = 'concentrated_juice', amount = 5 },
        },
        process = {
            label = 'Mix Stab Juice',
            coords = vec3(384.63, 3554.60, 32.42),
            heading = 172.92,
            duration = 11000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 172.92,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'stab_juice', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 1, label = 'Stab Juice Lab' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 500,
            maxPrice = 850,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            label = 'Drinking Stab Juice',
            useTime = 4000,
            duration = 45000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = 15,
            stamina = true,
            -- no screen FX
        },
    },

    --------------------------------------------------
    -- Black Lotus
    --------------------------------------------------
    black_lotus = {
        label = 'Black Lotus',
        item = 'black_lotus',
        description = 'Refined Black Lotus ready to move',
        ingredients = {
            { item = 'lotus_powder', amount = 5 },
            { item = 'black_liquid_extract', amount = 5 },
        },
        process = {
            label = 'Brew Black Lotus',
            coords = vec3(1092.77, -154.72, 54.64),
            heading = 66.12,
            duration = 12000,
            prop = {
                model = `bkr_prop_meth_table01a`,
                heading = 66.12,
            },
            anim = {
                dict = 'anim@amb@business@coc@coc_unpack_cut@',
                clip = 'fullcut_cycle_v6_cokecutter',
            },
            output = { item = 'black_lotus', amount = 7 },
            blip = { enabled = false, sprite = 499, color = 40, label = 'Black Lotus Lab' },
        },
        sell = {
            enabled = true,
            moneyType = 'black_money',
            minPrice = 500,
            maxPrice = 850,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = COMBAT_STIM.enabled,
            label = 'Using Black Lotus',
            useTime = 3500,
            duration = COMBAT_STIM.duration,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            armorPercent = COMBAT_STIM.armorPercent,
            stamina = COMBAT_STIM.stamina,
        },
    },
}