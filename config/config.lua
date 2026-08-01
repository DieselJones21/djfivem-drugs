Config = {}

--[[
    Framework stack (default):
      - qb-core
      - ox_lib
      - ox_target (3rd eye)
      - ox_inventory

    To add a new drug later:
      1) Add an entry under Config.Drugs in config/drugs.lua
      2) Add harvest / store / machine spots that grant its ingredients
      3) Add the items to ox_inventory (see install/ox_inventory_items.lua)
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
}

-- Convenience / supply store pickups (baggies, cups, sprite, acetone, etc.)
-- Set paid = true + price to charge cash; otherwise free grab.
Config.Stores = {
    {
        id = 'store_grove',
        label = 'Convenience Supplies',
        coords = vec3(-47.52, -1758.87, 29.42),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 50.0,
        items = {
            { item = 'baggies', label = 'Grab Baggies', amount = 2, duration = 3500 },
            { item = 'cups', label = 'Grab Cups', amount = 2, duration = 3500 },
            { item = 'sprite', label = 'Grab Sprite', amount = 1, duration = 3500 },
        },
    },
    {
        id = 'store_strawberry',
        label = 'Convenience Supplies',
        coords = vec3(25.74, -1346.72, 29.50),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 0.0,
        items = {
            { item = 'baggies', label = 'Grab Baggies', amount = 2, duration = 3500 },
            { item = 'cups', label = 'Grab Cups', amount = 2, duration = 3500 },
            { item = 'sprite', label = 'Grab Sprite', amount = 1, duration = 3500 },
        },
    },
    {
        id = 'store_sandyshores',
        label = 'Convenience Supplies',
        coords = vec3(1960.54, 3741.01, 32.34),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 300.0,
        items = {
            { item = 'baggies', label = 'Grab Baggies', amount = 2, duration = 3500 },
            { item = 'cups', label = 'Grab Cups', amount = 2, duration = 3500 },
            { item = 'sprite', label = 'Grab Sprite', amount = 1, duration = 3500 },
            { item = 'acetone', label = 'Grab Acetone', amount = 1, duration = 4000 },
        },
    },
    {
        id = 'hardware_city',
        label = 'Hardware Supplies',
        coords = vec3(46.66, -1749.72, 29.63),
        size = vec3(1.4, 1.4, 2.0),
        rotation = 50.0,
        items = {
            { item = 'acetone', label = 'Grab Acetone', amount = 1, duration = 4000 },
        },
    },
}

-- Ice machines (lean)
Config.Machines = {
    {
        id = 'ice_machine_1',
        label = 'Take Ice',
        item = 'ice',
        amount = { min = 1, max = 2 },
        duration = 4000,
        cooldown = 20,
        coords = vec3(-53.12, -1756.90, 29.44),
        size = vec3(1.2, 1.2, 2.0),
        rotation = 50.0,
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
    },
    {
        id = 'ice_machine_2',
        label = 'Take Ice',
        item = 'ice',
        amount = { min = 1, max = 2 },
        duration = 4000,
        cooldown = 20,
        coords = vec3(28.40, -1349.20, 29.50),
        size = vec3(1.2, 1.2, 2.0),
        rotation = 0.0,
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
    },
}

-- World harvest spots (plants, crystals, leaves, codeine, solvents, etc.)
-- type = 'spot' uses a zone; type = 'prop' spawns harvestable props
Config.Harvest = {
    -- Pink Energy ingredients
    {
        id = 'pink_crystal_field',
        type = 'spot',
        item = 'pink_crystal_shards',
        label = 'Harvest Pink Crystal Shards',
        amount = { min = 1, max = 2 },
        duration = 7000,
        cooldown = 30,
        coords = vec3(2954.12, 2787.45, 41.48), -- quarry / rocky area
        size = vec3(2.0, 2.0, 2.0),
        rotation = 0.0,
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 501, color = 8, label = 'Pink Crystals' },
    },
    {
        id = 'pink_solvent_lab',
        type = 'spot',
        item = 'pink_energy_solvent',
        label = 'Siphon Pink Energy Solvent',
        amount = { min = 1, max = 1 },
        duration = 8000,
        cooldown = 35,
        coords = vec3(3536.85, 3661.97, 28.12), -- Humane Labs vicinity
        size = vec3(1.8, 1.8, 2.0),
        rotation = 170.0,
        anim = { dict = 'anim@amb@business@coc@coc_unpack_cut@', clip = 'fullcut_cycle_v6_cokecutter' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Pink Solvent' },
    },
    {
        id = 'chug_jars_warehouse',
        type = 'spot',
        item = 'chug_jars',
        label = 'Collect Chug Jars',
        amount = { min = 1, max = 2 },
        duration = 6000,
        cooldown = 25,
        coords = vec3(1210.45, -3102.88, 5.85), -- docks / warehouse
        size = vec3(1.8, 1.8, 2.0),
        rotation = 0.0,
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        blip = { enabled = false, sprite = 478, color = 8, label = 'Chug Jars' },
    },
    {
        id = 'caffeine_powder_plant',
        type = 'spot',
        item = 'caffeine_powder',
        label = 'Scoop Caffeine Powder',
        amount = { min = 1, max = 2 },
        duration = 6500,
        cooldown = 25,
        coords = vec3(2748.21, 1510.94, 24.50), -- power plant / industrial
        size = vec3(1.8, 1.8, 2.0),
        rotation = 70.0,
        anim = { dict = 'amb@prop_human_parking_meter@male@idle_a', clip = 'idle_a' },
        blip = { enabled = false, sprite = 499, color = 8, label = 'Caffeine Powder' },
    },

    -- Weed plants (GTA weed props)
    {
        id = 'weed_grove',
        type = 'prop',
        item = 'weed_bud',
        label = 'Harvest Weed Buds',
        amount = { min = 1, max = 3 },
        duration = 6500,
        cooldown = 40,
        model = `prop_weed_01`,
        -- Center of the grow area; props spawn around it
        coords = vec3(2223.65, 5577.18, 53.84),
        heading = 0.0,
        count = 8,
        radius = 6.0,
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 469, color = 2, label = 'Weed Field' },
    },

    -- Cocaine leaves
    {
        id = 'coca_field',
        type = 'prop',
        item = 'coca_leaves',
        label = 'Pick Coca Leaves',
        amount = { min = 1, max = 3 },
        duration = 6000,
        cooldown = 35,
        model = `prop_plant_01a`,
        coords = vec3(2218.12, 5614.45, 54.72),
        heading = 90.0,
        count = 7,
        radius = 5.5,
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
        blip = { enabled = false, sprite = 501, color = 0, label = 'Coca Field' },
    },

    -- Lean codeine harvest
    {
        id = 'codeine_pharmacy',
        type = 'spot',
        item = 'codeine',
        label = 'Steal Codeine',
        amount = { min = 1, max = 2 },
        duration = 7500,
        cooldown = 40,
        coords = vec3(95.21, -230.84, 54.66), -- clinic / medical area
        size = vec3(1.6, 1.6, 2.0),
        rotation = 340.0,
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
        blip = { enabled = false, sprite = 403, color = 27, label = 'Codeine' },
    },
}