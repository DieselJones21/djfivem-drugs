--[[
    Add new drugs here. Everything else (process bench, sell prices, recipes)
    is driven from this table — no client/server code changes needed.

    Required fields:
      label, item, ingredients, process, sell

    ingredients = {
        { item = 'item_name', amount = 1 },
    }

    process = {
        coords, heading, label, duration,
        output = { item = '...', amount = 1 },
        optional: prop, anim, size, rotation, blip
    }

    sell = {
        enabled = true,
        minPrice / maxPrice  -- per unit
        minQty / maxQty      -- buyer request range
    }
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
            { item = 'pink_crystal_shards', amount = 2 },
            { item = 'pink_energy_solvent', amount = 1 },
            { item = 'chug_jars', amount = 1 },
            { item = 'caffeine_powder', amount = 2 },
        },
        process = {
            label = 'Mix Pink Energy',
            coords = vec3(1391.92, 3605.94, 38.94), -- Sandy motel / lab-ish
            heading = 200.0,
            size = vec3(1.6, 1.6, 2.0),
            rotation = 200.0,
            duration = 14000,
            prop = {
                model = `prop_tool_bench02`,
                offset = vec3(0.0, 0.0, 0.0),
                heading = 200.0,
            },
            anim = {
                dict = 'anim@amb@business@coc@coc_unpack_cut@',
                clip = 'fullcut_cycle_v6_cokecutter',
            },
            output = { item = 'pink_energy', amount = 1 },
            blip = { enabled = false, sprite = 499, color = 8, label = 'Pink Energy Lab' },
        },
        sell = {
            enabled = true,
            minPrice = 550,
            maxPrice = 900,
            minQty = 1,
            maxQty = 4,
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
            { item = 'weed_bud', amount = 3 },
            { item = 'baggies', amount = 1 },
        },
        process = {
            label = 'Bag Weed',
            coords = vec3(2329.12, 2571.45, 46.68),
            heading = 0.0,
            size = vec3(1.6, 1.6, 2.0),
            rotation = 0.0,
            duration = 9000,
            prop = {
                model = `bkr_prop_weed_table_01a`,
                offset = vec3(0.0, 0.0, 0.0),
                heading = 0.0,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'weed_bag', amount = 1 },
            blip = { enabled = false, sprite = 469, color = 2, label = 'Weed Bench' },
        },
        sell = {
            enabled = true,
            minPrice = 80,
            maxPrice = 160,
            minQty = 1,
            maxQty = 8,
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
            { item = 'coca_leaves', amount = 4 },
            { item = 'acetone', amount = 1 },
            { item = 'baggies', amount = 1 },
        },
        process = {
            label = 'Cook Cocaine',
            coords = vec3(2433.58, 4969.12, 42.35),
            heading = 45.0,
            size = vec3(1.6, 1.6, 2.0),
            rotation = 45.0,
            duration = 12000,
            prop = {
                model = `bkr_prop_coke_table01a`,
                offset = vec3(0.0, 0.0, 0.0),
                heading = 45.0,
            },
            anim = {
                dict = 'anim@amb@business@coc@coc_unpack_cut@',
                clip = 'fullcut_cycle_v6_cokecutter',
            },
            output = { item = 'cocaine_bag', amount = 1 },
            blip = { enabled = false, sprite = 501, color = 0, label = 'Cocaine Table' },
        },
        sell = {
            enabled = true,
            minPrice = 250,
            maxPrice = 420,
            minQty = 1,
            maxQty = 6,
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
            { item = 'codeine', amount = 1 },
            { item = 'ice', amount = 1 },
            { item = 'cups', amount = 1 },
            { item = 'sprite', amount = 1 },
        },
        process = {
            label = 'Mix Lean',
            coords = vec3(1975.45, 3818.62, 33.44),
            heading = 300.0,
            size = vec3(1.6, 1.6, 2.0),
            rotation = 300.0,
            duration = 10000,
            prop = {
                model = `prop_tool_bench02_ld`,
                offset = vec3(0.0, 0.0, 0.0),
                heading = 300.0,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
            },
            output = { item = 'lean_cup', amount = 1 },
            blip = { enabled = false, sprite = 499, color = 27, label = 'Lean Bench' },
        },
        sell = {
            enabled = true,
            minPrice = 140,
            maxPrice = 260,
            minQty = 1,
            maxQty = 5,
        },
    },
}

--[[
    EXAMPLE — copy this block to add another drug later:

    meth = {
        label = 'Meth Bag',
        item = 'meth_bag',
        ingredients = {
            { item = 'pseudo', amount = 2 },
            { item = 'baggies', amount = 1 },
        },
        process = {
            label = 'Cook Meth',
            coords = vec3(0.0, 0.0, 0.0),
            heading = 0.0,
            size = vec3(1.6, 1.6, 2.0),
            rotation = 0.0,
            duration = 15000,
            output = { item = 'meth_bag', amount = 1 },
        },
        sell = {
            enabled = true,
            minPrice = 300,
            maxPrice = 500,
            minQty = 1,
            maxQty = 5,
        },
    },
]]