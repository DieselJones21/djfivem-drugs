--[[
    Drug definitions.

    Default craft rule:
      5 of each ingredient → 7 finished product

    effects = optional usable high when the finished item is used from inventory.
    Tune / disable per drug. Global toggle: Config.UseEffects
]]

Config.Drugs = {
    --------------------------------------------------
    -- Pink Energy (highest value, 4 ingredients)
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
            coords = vec3(880.8, -959.84, 26.86),
            heading = 200.0,
            duration = 14000,
            prop = {
                model = `bkr_prop_meth_table01a`,
                heading = 200.0,
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
            minPrice = 550,
            maxPrice = 900,
            minQty = 1,
            maxQty = 4,
        },
        effects = {
            enabled = true,
            label = 'Chugging Pink Energy',
            useTime = 3500,
            duration = 60000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            health = 10,
            armor = 5,
            stress = -15,
            stamina = true,
            sprintMultiplier = 1.35,
            timecycle = 'drug_flying_01',
            timecycleStrength = 0.45,
            shake = { intensity = 0.15, duration = 4000 },
            screenEffect = 'DrugsMichaelAliensFightIn',
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
            coords = vec3(-417.21, -2176.31, 9.32),
            heading = 0.0,
            duration = 9000,
            prop = {
                model = `bkr_prop_weed_table_01a`,
                heading = 0.0,
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
            minPrice = 80,
            maxPrice = 160,
            minQty = 1,
            maxQty = 8,
        },
        effects = {
            enabled = true,
            label = 'Smoking Weed',
            useTime = 5000,
            duration = 75000,
            anim = { dict = 'amb@world_human_smoking@male@male_a@idle_a', clip = 'idle_b', flag = 49 },
            stress = -30,
            health = 5,
            walk = 'move_m@hipster@a',
            timecycle = 'spectator5',
            timecycleStrength = 0.65,
            shake = { intensity = 0.25, duration = 6000 },
            screenEffect = 'DrugsMichaelAliensFight',
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
            coords = vec3(-1277.08, -1357.38, 3.3),
            heading = 45.0,
            duration = 12000,
            prop = {
                model = `bkr_prop_coke_table01a`,
                heading = 45.0,
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
            minPrice = 250,
            maxPrice = 420,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            label = 'Snorting Cocaine',
            useTime = 4000,
            duration = 50000,
            anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 49 },
            armor = 20,
            stress = 10,
            stamina = true,
            sprintMultiplier = 1.45,
            timecycle = 'drug_wobbly',
            timecycleStrength = 0.55,
            shake = { intensity = 0.4, duration = 5000 },
            screenEffect = 'DrugsTrevorClownsFight',
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
            coords = vec3(-427.11, 292.68, 82.23),
            heading = 300.0,
            duration = 10000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 300.0,
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
            minPrice = 140,
            maxPrice = 260,
            minQty = 1,
            maxQty = 5,
        },
        effects = {
            enabled = true,
            label = 'Sipping Lean',
            useTime = 4500,
            duration = 80000,
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle', flag = 49 },
            health = 8,
            stress = -40,
            walk = 'MOVE_M@DRUNK@MODERATEDRUNK',
            timecycle = 'Drunk',
            timecycleStrength = 0.7,
            shake = { intensity = 0.2, duration = 8000 },
            screenEffect = 'DrugsMichaelAliensFightOut',
            drunkCamera = true,
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
            -- Placeholder coords — move in config if needed
            coords = vec3(1391.55, 3605.20, 38.94),
            heading = 110.0,
            duration = 11000,
            prop = {
                model = `prop_tool_bench02`,
                heading = 110.0,
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
            minPrice = 200,
            maxPrice = 360,
            minQty = 1,
            maxQty = 6,
        },
        effects = {
            enabled = true,
            label = 'Popping Honda Pills',
            useTime = 3000,
            duration = 55000,
            anim = { dict = 'mp_suicide', clip = 'pill', flag = 49 },
            health = 15,
            armor = 15,
            stress = -10,
            stamina = true,
            sprintMultiplier = 1.2,
            timecycle = 'drug_flying_base',
            timecycleStrength = 0.5,
            shake = { intensity = 0.35, duration = 4500 },
            screenEffect = 'DrugsMichaelAliensFightIn',
        },
    },
}