Config = {}

--[[
    Framework stack:
      - qbx_core
      - ox_lib
      - ox_target (3rd eye)
      - ox_inventory

    To add a new drug later:
      1) Add an entry under Config.Drugs in config/drugs.lua
      2) Add harvest / store / machine spots that grant its ingredients
      3) Add the items to ox_inventory (see install/ox_inventory_items.lua)

    Harvest types:
      - 'bench'  = spawn a prop + 3rd eye it (all ingredient stations)
      Stores stay as world zones (no custom bench props).
]]

Config.Debug = false
Config.Locale = 'en'

-- Money account used when selling ("cash" or "bank")
Config.MoneyType = 'cash'

-- Global harvest / process settings
Config.InteractDistance = 2.0
Config.ProgressCancelOnMove = true

-- Police / risk (optional soft check; set enabled = false to disable)
Config.Police = {
    enabled = false,
    jobs = { 'police', 'sheriff' },
    minimum = 0,          -- min on-duty cops required to sell
    alertChance = 0,      -- 0-100 chance to notify police on a sale
}

-- /trap selling
Config.Trap = {
    command = 'trap',
    description = 'Start or stop street trapping',
    cooldown = 8,                 -- seconds between buyer arrivals
    sessionTimeout = 0,           -- 0 = unlimited until /trap again
    buyerApproachTime = 12,       -- seconds buyer has to reach you
    buyerWaitTime = 45,           -- seconds buyer waits after arriving
    spawnDistance = { min = 18.0, max = 28.0 },
    models = {
        `a_m_m_eastsa_01`,
        `a_m_m_eastsa_02`,
        `a_m_y_hipster_01`,
        `a_m_y_stwhi_01`,
        `a_f_y_hipster_01`,
        `a_m_y_soucent_01`,
        `g_m_y_famca_01`,
        `g_m_y_ballasout_01`,
    },
    -- If true, buyer only asks for drugs the player currently carries
    requireOwnedDrug = true,
    -- Animation while dealing
    dealAnim = {
        dict = 'mp_common',
        clip = 'givetake1_a',
        flag = 49,
        duration = 2500,
    },
    blip = {
        enabled = true,
        sprite = 514,
        color = 1,
        scale = 0.7,
        label = 'Trap Mode',
    },
    -- Ask for higher prices: success varies, not always a good sale
    haggle = {
        enabled = true,
        maxAttempts = 2, -- how many times you can push one buyer
        -- Opening offer leans toward the lower end of minPrice-maxPrice (0.0 = min, 1.0 = max)
        openingBias = 0.35,
        -- Ask tiers shown in the deal menu
        asks = {
            {
                id = 'soft',
                label = 'Ask a little more',
                -- Target bump toward maxPrice (percent of the gap from current → max)
                bump = { min = 0.25, max = 0.45 },
                successChance = 50,   -- full asked bump
                counterChance = 30,   -- smaller bump instead
                walkAwayChance = 10,  -- buyer leaves
                -- remaining % = refuse, keep current offer
            },
            {
                id = 'hard',
                label = 'Push for top dollar',
                bump = { min = 0.70, max = 1.00 },
                successChance = 20,
                counterChance = 25,
                walkAwayChance = 35,
            },
        },
    },
}

-- Convenience / supply store pickups (baggies, cups, sprite, acetone, etc.)
-- These use existing store interiors — no spawned bench props.
-- Set paid = true + price to charge cash; otherwise free grab.
-- Global usable drug effects (per-drug effects live under Config.Drugs[].effects)
Config.UseEffects = true
Config.EffectCooldown = 12 -- seconds between uses
-- Optional stress relieve event used by many QB/QBX HUDs (set nil to disable)
Config.StressEvent = 'hud:server:RelieveStress'
-- Optional stress gain event (set if your HUD supports it; cocaine uses this)
Config.StressGainEvent = nil

-- Shared ingredient pickup defaults
Config.IngredientAmount = { min = 5, max = 10 }
Config.IngredientCooldown = 10

Config.Stores = {
    {
        id = 'store_grove',
        label = 'Convenience Supplies',
        coords = vec3(-47.52, -1758.87, 29.42),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 50.0,
        items = {
            { item = 'baggies', label = 'Grab Baggies', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'cups', label = 'Grab Cups', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'sprite', label = 'Grab Sprite', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'hard_candies', label = 'Grab Hard Candies', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
        },
    },
    {
        id = 'store_strawberry',
        label = 'Convenience Supplies',
        coords = vec3(25.74, -1346.72, 29.50),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 0.0,
        items = {
            { item = 'baggies', label = 'Grab Baggies', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'cups', label = 'Grab Cups', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'sprite', label = 'Grab Sprite', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'hard_candies', label = 'Grab Hard Candies', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
        },
    },
    {
        id = 'store_sandyshores',
        label = 'Convenience Supplies',
        coords = vec3(1960.54, 3741.01, 32.34),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 300.0,
        items = {
            { item = 'baggies', label = 'Grab Baggies', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'cups', label = 'Grab Cups', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'sprite', label = 'Grab Sprite', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'hard_candies', label = 'Grab Hard Candies', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
            { item = 'acetone', label = 'Grab Acetone', amount = { min = 5, max = 10 }, cooldown = 10, duration = 4000 },
        },
    },
    {
        id = 'hardware_city',
        label = 'Hardware Supplies',
        coords = vec3(46.66, -1749.72, 29.63),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 50.0,
        items = {
            { item = 'acetone', label = 'Grab Acetone', amount = { min = 5, max = 10 }, cooldown = 10, duration = 4000 },
        },
    },
}

-- Ice machines (lean) — spawned machine props + 3rd eye
Config.Machines = {
    {
        id = 'ice_machine_1',
        label = 'Take Ice',
        item = 'ice',
        amount = { min = 5, max = 10 },
        duration = 4000,
        cooldown = 10,
        coords = vec3(-53.12, -1756.90, 29.44),
        heading = 50.0,
        prop = {
            model = `prop_bar_cooler_03`,
            heading = 50.0,
        },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
    },
    {
        id = 'ice_machine_2',
        label = 'Take Ice',
        item = 'ice',
        amount = { min = 5, max = 10 },
        duration = 4000,
        cooldown = 10,
        coords = vec3(28.40, -1349.20, 29.50),
        heading = 0.0,
        prop = {
            model = `prop_bar_cooler_03`,
            heading = 0.0,
        },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
    },
    {
        id = 'ice_machine_3',
        label = 'Take Ice',
        item = 'ice',
        amount = { min = 5, max = 10 },
        duration = 4000,
        cooldown = 10,
        coords = vec3(1955.80, 3740.20, 32.34),
        heading = 300.0,
        prop = {
            model = `prop_bar_cooler_03`,
            heading = 300.0,
        },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
    },
}

--[[
    World harvest spots
      type = 'bench' → spawn prop.model and 3rd-eye the bench
]]
Config.Harvest = {
    --------------------------------------------------
    -- Pink Energy ingredient benches
    --------------------------------------------------
    {
        id = 'pink_crystal_field',
        type = 'bench',
        item = 'pink_crystal_shards',
        label = 'Harvest Pink Crystal Shards',
        amount = { min = 5, max = 10 },
        duration = 7000,
        cooldown = 10,
        coords = vec3(1243.59, -425.83, 67.92),
        heading = 0.0,
        prop = {
            model = `prop_rock_4_c`, -- crystal / rock cluster
            heading = 0.0,
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 501, color = 8, label = 'Pink Crystals' },
    },
    {
        id = 'pink_solvent_lab',
        type = 'bench',
        item = 'pink_energy_solvent',
        label = 'Siphon Pink Energy Solvent',
        amount = { min = 5, max = 10 },
        duration = 8000,
        cooldown = 10,
        coords = vec3(955.0, -194.81, 78.3),
        heading = 170.0,
        prop = {
            model = `prop_barrel_01a`, -- chemical liquid barrel
            heading = 170.0,
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Pink Solvent' },
    },
    {
        id = 'chug_jars_warehouse',
        type = 'bench',
        item = 'chug_jars',
        label = 'Collect Chug Jars',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(1123.41, -652.92, 55.73),
        heading = 0.0,
        prop = {
            model = `prop_box_wood05a`, -- crate of jars/bottles
            heading = 0.0,
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 8, label = 'Chug Jars' },
    },
    {
        id = 'caffeine_powder_plant',
        type = 'bench',
        item = 'caffeine_powder',
        label = 'Scoop Caffeine Powder',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(756.17, -672.71, 27.73),
        heading = 70.0,
        prop = {
            model = `prop_feed_sack_01`, -- powder sack
            heading = 70.0,
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Caffeine Powder' },
    },

    --------------------------------------------------
    -- Weed buds
    --------------------------------------------------
    {
        id = 'weed_grove',
        type = 'bench',
        item = 'weed_bud',
        label = 'Harvest Weed Buds',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(99.71, -1978.33, 19.76),
        heading = 0.0,
        prop = {
            model = `prop_weed_01`, -- weed plant
            heading = 0.0,
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 469, color = 2, label = 'Weed Buds' },
    },

    --------------------------------------------------
    -- Coca leaves
    --------------------------------------------------
    {
        id = 'coca_field',
        type = 'bench',
        item = 'coca_leaves',
        label = 'Pick Coca Leaves',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(-1485.49, -909.42, 9.02),
        heading = 90.0,
        prop = {
            model = `prop_plant_01a`, -- leafy plant
            heading = 90.0,
        },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 501, color = 0, label = 'Coca Leaves' },
    },

    --------------------------------------------------
    -- Lean codeine
    --------------------------------------------------
    {
        id = 'codeine_pharmacy',
        type = 'bench',
        item = 'codeine',
        label = 'Steal Codeine',
        amount = { min = 5, max = 10 },
        duration = 7500,
        cooldown = 10,
        coords = vec3(-620.23, 323.26, 81.26),
        heading = 340.0,
        prop = {
            model = `prop_drug_bottle`, -- medicine bottle
            heading = 340.0,
        },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
        blip = { enabled = false, sprite = 403, color = 27, label = 'Codeine' },
    },

    --------------------------------------------------
    -- Honda Pills ingredients
    --------------------------------------------------
    {
        id = 'honda_capsules',
        type = 'bench',
        item = 'honda_pill_capsules',
        label = 'Collect Honda Pill Capsules',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(353.45, -1415.80, 32.50),
        heading = 50.0,
        prop = {
            model = `prop_cs_pills`, -- pill bottle
            heading = 50.0,
            placeOnGround = false,
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 51, color = 46, label = 'Honda Capsules' },
    },
    {
        id = 'honda_formula',
        type = 'bench',
        item = 'honda_formula',
        label = 'Scoop Honda Formula',
        amount = { min = 5, max = 10 },
        duration = 7000,
        cooldown = 10,
        coords = vec3(144.20, -2203.85, 4.70),
        heading = 180.0,
        prop = {
            model = `prop_barrel_02b`, -- powder barrel
            heading = 180.0,
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 51, color = 46, label = 'Honda Formula' },
    },
    {
        id = 'honda_extract',
        type = 'bench',
        item = 'honda_extract',
        label = 'Extract Honda Concentrate',
        amount = { min = 5, max = 10 },
        duration = 7500,
        cooldown = 10,
        coords = vec3(-1164.55, -2036.90, 13.15),
        heading = 315.0,
        prop = {
            model = `prop_barrel_exp_01a`, -- chemical extract barrel
            heading = 315.0,
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 51, color = 46, label = 'Honda Extract' },
    },

    --------------------------------------------------
    -- Stab Juice ingredients
    --------------------------------------------------
    {
        id = 'stab_powder',
        type = 'bench',
        item = 'stab_powder',
        label = 'Scoop Stab Powder',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(892.35, -2172.40, 32.28),
        heading = 175.0,
        prop = {
            model = `prop_feed_sack_01`, -- powder sack
            heading = 175.0,
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 499, color = 1, label = 'Stab Powder' },
    },
    {
        id = 'stab_candy',
        type = 'bench',
        item = 'stab_candy',
        label = 'Grab Stab Candy',
        amount = { min = 5, max = 10 },
        duration = 6000,
        cooldown = 10,
        coords = vec3(46.80, -1749.55, 29.63),
        heading = 50.0,
        prop = {
            model = `prop_candy_pqs`, -- candy box
            heading = 50.0,
        },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 499, color = 1, label = 'Stab Candy' },
    },
    {
        id = 'concentrated_juice',
        type = 'bench',
        item = 'concentrated_juice',
        label = 'Tap Concentrated Juice',
        amount = { min = 5, max = 10 },
        duration = 7000,
        cooldown = 10,
        coords = vec3(1208.55, -3114.80, 5.54),
        heading = 90.0,
        prop = {
            model = `prop_barrel_01a`, -- liquid barrel
            heading = 90.0,
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 1, label = 'Concentrated Juice' },
    },

    --------------------------------------------------
    -- Black Lotus ingredients (placeholder coords)
    --------------------------------------------------
    {
        id = 'lotus_powder',
        type = 'bench',
        item = 'lotus_powder',
        label = 'Scoop Lotus Powder',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(380.55, -1835.20, 28.75),
        heading = 45.0,
        prop = {
            model = `prop_feed_sack_01`, -- powder sack
            heading = 45.0,
        },
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 499, color = 40, label = 'Lotus Powder' },
    },
    {
        id = 'black_liquid_extract',
        type = 'bench',
        item = 'black_liquid_extract',
        label = 'Tap Black Liquid Extract',
        amount = { min = 5, max = 10 },
        duration = 7500,
        cooldown = 10,
        coords = vec3(172.40, -1717.85, 29.35),
        heading = 140.0,
        prop = {
            model = `prop_barrel_exp_01a`, -- dark chemical barrel
            heading = 140.0,
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 40, label = 'Black Liquid Extract' },
    },
}