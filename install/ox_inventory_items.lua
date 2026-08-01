--[[
    Copy these entries into ox_inventory/data/items.lua
    (or merge into your items file). Icons are optional — add images
    under ox_inventory/web/images matching each item name.
]]

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

    -- Finished product
    ['pink_energy'] = {
        label = 'Pink Energy',
        weight = 150,
        stack = true,
        close = true,
        description = 'Premium street stimulant — highest demand',
    },
    ['weed_bag'] = {
        label = 'Bagged Weed',
        weight = 40,
        stack = true,
        close = true,
        description = 'A bag of weed ready to sell',
    },
    ['cocaine_bag'] = {
        label = 'Cocaine Bag',
        weight = 45,
        stack = true,
        close = true,
        description = 'Processed cocaine packaged for sale',
    },
    ['lean_cup'] = {
        label = 'Lean Cup',
        weight = 80,
        stack = true,
        close = true,
        description = 'A mixed cup of lean ready to move',
    },
}