--[[
    Merge into ox_inventory/data/items.lua

    IMPORTANT for usable effects:
      Replace RESOURCE_NAME below with your resource FOLDER name
      (usually djfivem-drugs). Check F8 on start — the script prints the
      exact export string.

      Example:
        client = { export = 'djfivem-drugs.useDrug' }

    QBX also registers usables automatically, so effects should still work
    even before you add the client.export lines.
]]

local useExport = {
    export = 'djfivem-drugs.useDrug', -- change if your folder name differs
}

return {
    -- Ingredients: Pink Energy
    ['pink_crystal_shards'] = {
        label = 'Pink Crystal Shards',
        weight = 50,
        stack = true,
        close = true,
        description = 'Glassy pink shards used to cook Pink Energy',
    },
    ['pink_energy_solvent'] = {
        label = 'Pink Energy Solvent',
        weight = 100,
        stack = true,
        close = true,
        description = 'Chemical solvent for Pink Energy',
    },
    ['chug_jars'] = {
        label = 'Chug Jars',
        weight = 80,
        stack = true,
        close = true,
        description = 'Empty jars for mixing Pink Energy',
    },
    ['caffeine_powder'] = {
        label = 'Caffeine Powder',
        weight = 40,
        stack = true,
        close = true,
        description = 'Highly concentrated caffeine powder',
    },

    -- Ingredients: Weed
    ['weed_bud'] = {
        label = 'Weed Bud',
        weight = 30,
        stack = true,
        close = true,
        description = 'Freshly harvested weed buds',
    },
    ['baggies'] = {
        label = 'Baggies',
        weight = 10,
        stack = true,
        close = true,
        description = 'Small plastic baggies for packaging',
    },

    -- Ingredients: Cocaine
    ['coca_leaves'] = {
        label = 'Coca Leaves',
        weight = 35,
        stack = true,
        close = true,
        description = 'Raw coca leaves ready for processing',
    },
    ['acetone'] = {
        label = 'Acetone',
        weight = 120,
        stack = true,
        close = true,
        description = 'Industrial solvent used in cocaine processing',
    },

    -- Ingredients: Lean
    ['codeine'] = {
        label = 'Codeine',
        weight = 40,
        stack = true,
        close = true,
        description = 'Prescription cough syrup base',
    },
    ['ice'] = {
        label = 'Ice',
        weight = 20,
        stack = true,
        close = true,
        description = 'Cup of ice from a machine',
    },
    ['cups'] = {
        label = 'Cups',
        weight = 15,
        stack = true,
        close = true,
        description = 'Styrofoam cups for lean',
    },
    ['sprite'] = {
        label = 'Sprite',
        weight = 50,
        stack = true,
        close = true,
        description = 'Soda used to mix lean',
    },
    ['hard_candies'] = {
        label = 'Hard Candies',
        weight = 15,
        stack = true,
        close = true,
        description = 'Jolly-style hard candies for mixing lean',
    },

    -- Ingredients: Honda Pills
    ['honda_pill_capsules'] = {
        label = 'Honda Pill Capsules',
        weight = 20,
        stack = true,
        close = true,
        description = 'Empty capsules for pressing Honda pills',
    },
    ['honda_formula'] = {
        label = 'Honda Formula',
        weight = 40,
        stack = true,
        close = true,
        description = 'Chemical formula powder for Honda pills',
    },
    ['honda_extract'] = {
        label = 'Honda Extract',
        weight = 35,
        stack = true,
        close = true,
        description = 'Concentrated extract used in Honda pills',
    },

    -- Ingredients: Stab Juice
    ['stab_powder'] = {
        label = 'Stab Powder',
        weight = 30,
        stack = true,
        close = true,
        description = 'Raw powder used to mix Stab Juice',
    },
    ['stab_candy'] = {
        label = 'Stab Candy',
        weight = 20,
        stack = true,
        close = true,
        description = 'Sweet candy base for Stab Juice',
    },
    ['concentrated_juice'] = {
        label = 'Concentrated Juice',
        weight = 45,
        stack = true,
        close = true,
        description = 'Thick concentrate for Stab Juice',
    },

    -- Finished products (usable)
    ['pink_energy'] = {
        label = 'Pink Energy',
        weight = 150,
        stack = true,
        close = true,
        description = 'Premium street stimulant — highest demand',
        client = useExport,
    },
    ['weed_bag'] = {
        label = 'Bagged Weed',
        weight = 40,
        stack = true,
        close = true,
        description = 'A bag of weed ready to sell',
        client = useExport,
    },
    ['cocaine_bag'] = {
        label = 'Cocaine Bag',
        weight = 45,
        stack = true,
        close = true,
        description = 'Processed cocaine packaged for sale',
        client = useExport,
    },
    ['lean_cup'] = {
        label = 'Lean Cup',
        weight = 80,
        stack = true,
        close = true,
        description = 'A mixed cup of lean ready to move',
        client = useExport,
    },
    ['honda_pills'] = {
        label = 'Honda Pills',
        weight = 25,
        stack = true,
        close = true,
        description = 'Pressed Honda pills ready to sell or use',
        client = useExport,
    },
    ['stab_juice'] = {
        label = 'Stab Juice',
        weight = 90,
        stack = true,
        close = true,
        description = 'Mixed Stab Juice ready to sell or use',
        client = useExport,
    },
}