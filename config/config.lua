Config = {}

--[[
    Framework stack:
      - qbx_core
      - ox_lib
      - ox_target (3rd eye)
      - ox_inventory

    To add a new drug later:
      1) Add an entry under Config.Drugs in config/drugs.lua
      2) Add harvest / machine spots that grant its ingredients
      3) Add the items to ox_inventory (see install/ox_inventory_items.lua)

    Harvest types:
      - 'bench'  = spawn a prop + 3rd eye it (all ingredient stations)

    Store supply grabs are disabled (Config.Stores / Config.Machines empty).
    Re-add entries there if you want convenience/hardware pickups again.
]]

Config.Debug = false
Config.Locale = 'en'

-- Default money account for sales without a per-drug override (weed uses this)
Config.MoneyType = 'cash'
-- Hard drugs pay this account unless sell.moneyType is set on the drug
Config.DirtyMoneyType = 'black_money'

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

--[[
    Admin boost events (ox_lib menu via /drugboost)
    Sell: multiplies street sale prices
    Harvest: multiplies ingredient yields from world harvest benches
]]
Config.Boost = {
    command = 'drugboost',
    description = 'Open drug boost event admin menu',
    -- ACE permission (server.cfg): add_ace group.admin djdrugs.boost allow
    ace = 'djdrugs.boost',
    -- QBX permission names that can also open the menu
    permissions = { 'admin', 'god' },
    announce = true, -- notify all players when events start/stop
    -- Options shown in the ox_lib UI
    multipliers = { 2, 3, 4 },
    durations = {
        { label = '30 minutes', seconds = 30 * 60 },
        { label = '1 hour', seconds = 60 * 60 },
        { label = '2 hours', seconds = 2 * 60 * 60 },
        { label = '4 hours', seconds = 4 * 60 * 60 },
    },
    defaultDuration = 60 * 60, -- 1 hour
}

-- Convenience / hardware store supply grabs — disabled (no store ingredient gathering).
-- Example entry shape if you re-enable later:
-- {
--     id = 'store_grove',
--     label = 'Convenience Supplies',
--     coords = vec3(-47.52, -1758.87, 29.42),
--     size = vec3(1.4, 1.4, 2.0),
--     rotation = 50.0,
--     items = {
--         { item = 'baggies', label = 'Grab Baggies', amount = { min = 5, max = 10 }, cooldown = 10, duration = 3500 },
--     },
-- }
Config.Stores = {}

-- Ice machines at stores — disabled with store gathering.
-- Re-add machine entries (prop + coords) if you want ice pickups again.
Config.Machines = {}

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
        blip = { enabled = true, sprite = 469, color = 2, label = 'Weed Buds' },
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
        coords = vec3(994.98, 1007.78, 241.00),
        heading = 18.95,
        prop = {
            model = `prop_plant_01a`, -- leafy plant
            heading = 18.95,
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
            placeOnGround = false,
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
        coords = vec3(-1344.20, -1154.58, 4.49),
        heading = 92.66,
        prop = {
            model = `prop_barrel_02b`,
            heading = 92.66,
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
        coords = vec3(-1606.26, -1050.48, 6.02),
        heading = 48.87,
        prop = {
            model = `prop_barrel_02b`, -- powder barrel
            heading = 48.87,
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
        coords = vec3(-1278.79, -838.92, 16.15),
        heading = 315.28,
        prop = {
            model = `prop_barrel_exp_01a`, -- chemical extract barrel
            heading = 315.28,
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
        coords = vec3(-433.27, 4041.09, 82.83),
        heading = 16.08,
        prop = {
            model = `prop_feed_sack_01`, -- powder sack
            heading = 16.98,
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
        coords = vec3(91.13, 3749.69, 40.77),
        heading = 345.03,
        prop = {
            model = `prop_candy_pqs`, -- candy box
            heading = 345.03,
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
        coords = vec3(358.24, 3398.84, 36.40),
        heading = 27.90,
        prop = {
            model = `prop_barrel_01a`, -- liquid barrel
            heading = 27.90,
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 1, label = 'Concentrated Juice' },
    },

    --------------------------------------------------
    -- Black Lotus ingredients
    --------------------------------------------------
    {
        id = 'lotus_powder',
        type = 'bench',
        item = 'lotus_powder',
        label = 'Scoop Lotus Powder',
        amount = { min = 5, max = 10 },
        duration = 6500,
        cooldown = 10,
        coords = vec3(57.10, -98.81, 58.20),
        heading = 121.20,
        prop = {
            model = `prop_feed_sack_01`, -- powder sack
            heading = 120.20,
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
        coords = vec3(764.61, -2197.83, 20.78),
        heading = 169.79,
        prop = {
            model = `prop_barrel_exp_01a`, -- dark chemical barrel
            heading = 169.79,
        },
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 40, label = 'Black Liquid Extract' },
    },
}