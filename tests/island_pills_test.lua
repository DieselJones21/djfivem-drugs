--[[
    Island Pills config checks + existing-coord lock.

    lua tests/island_pills_test.lua
]]

local failed = 0

local function assertTrue(cond, msg)
    if not cond then
        failed = failed + 1
        io.stderr:write('FAIL ' .. msg .. '\n')
    end
end

local function read(path)
    local f = assert(io.open(path, 'r'))
    local text = f:read('*a')
    f:close()
    return text
end

local config = read('config/config.lua')
local drugs = read('config/drugs.lua')
local items = read('install/ox_inventory_items.lua')
local locations = read('install/LOCATIONS.md')

-- Existing harvest + process coords must stay exactly as they were
local locked = {
    -- harvest
    '1243.59, -425.83, 67.92',
    '955.0, -194.81, 78.3',
    '1123.41, -652.92, 55.73',
    '756.17, -672.71, 27.73',
    '99.71, -1978.33, 19.76',
    '994.98, 1007.78, 241.00',
    '-620.23, 323.26, 81.26',
    '-1344.20, -1154.58, 4.49',
    '-1606.26, -1050.48, 6.02',
    '-1278.79, -838.92, 16.15',
    '-433.27, 4041.09, 82.83',
    '91.13, 3749.69, 40.77',
    '358.24, 3398.84, 36.40',
    '57.10, -98.81, 58.20',
    '764.61, -2197.83, 20.78',
    -- process
    '856.71, -943.52, 25.28',
    '284.67, -1773.03, 27.06',
    '-2950.20, 637.03, 23.18',
    '-1784.34, -401.11, 45.47',
    '-1486.62, -909.08, 9.02',
    '384.63, 3554.60, 32.42',
    '1092.77, -154.72, 54.64',
}

for i = 1, #locked do
    local coord = locked[i]
    local found = config:find(coord, 1, true) or drugs:find(coord, 1, true)
    assertTrue(found, 'existing coord still present: ' .. coord)
end

-- Drug is wired like the others
assertTrue(drugs:find('island_pills%s*=%s*{', 1) ~= nil, 'Config.Drugs.island_pills exists')
assertTrue(drugs:find("item = 'island_pills'", 1, true) ~= nil, 'finished item is island_pills')
assertTrue(drugs:find("moneyType = 'black_money'", 1, true) ~= nil, 'hard-drug dirty payout still configured')
assertTrue(drugs:find('minPrice = 1800', 1, true) ~= nil, 'crazy min pay 1800')
assertTrue(drugs:find('maxPrice = 2800', 1, true) ~= nil, 'crazy max pay 2800')
assertTrue(drugs:find('armorPercent = 40', 1, true) ~= nil, 'stronger island stim armor')
assertTrue(drugs:find('duration = 60000', 1, true) ~= nil, '60s island stim')

local ingredients = { 'cayo_leaf', 'coral_powder', 'island_resin', 'perico_capsules' }
for i = 1, #ingredients do
    local name = ingredients[i]
    assertTrue(drugs:find("{ item = '" .. name .. "', amount = 5 }", 1, true) ~= nil,
        name .. ' is a recipe ingredient (5)')
    assertTrue(config:find("item = '" .. name .. "'", 1, true) ~= nil,
        name .. ' has a harvest bench')
    assertTrue(items:find("%['" .. name .. "'%]") ~= nil,
        name .. ' is in ox_inventory items')
end
assertTrue(items:find("%['island_pills'%]") ~= nil, 'island_pills is in ox_inventory items')
assertTrue(items:find("export = 'djfivem-drugs.useDrugServer'", 1, true) ~= nil,
    'usable export still documented')

-- All Island Pills spots are on Cayo Perico (x > 3800, y < -4200)
local cayoSpots = {
    { '5365.07', '-5438.82', '47.83' }, -- crop fields
    { '5609.77', '-5653.08', '8.65' },  -- east shore
    { '4924.14', '-5271.69', '4.35' },  -- main dock
    { '4517.43', '-4531.98', '2.82' },  -- airstrip
    { '5071.07', '-4639.87', '2.11' },  -- north dock process
}

for i = 1, #cayoSpots do
    local x, y, z = cayoSpots[i][1], cayoSpots[i][2], cayoSpots[i][3]
    local needle = x .. ', ' .. y .. ', ' .. z
    local found = config:find(needle, 1, true) or drugs:find(needle, 1, true)
    assertTrue(found, 'Cayo spot present: ' .. needle)
    assertTrue(tonumber(x) > 3800, 'Cayo X is east of LS: ' .. x)
    assertTrue(tonumber(y) < -4200, 'Cayo Y is south of LS: ' .. y)
    assertTrue(locations:find(needle, 1, true) ~= nil, 'LOCATIONS.md lists ' .. needle)
end

-- Recipe is exactly 4 unique island ingredients (no mainland leftovers)
local recipeBlock = drugs:match('island_pills%s*=%s*%b{}')
assertTrue(recipeBlock ~= nil, 'island_pills block parseable')
if recipeBlock then
    local count = 0
    for _ in recipeBlock:gmatch("{ item = '[^']+', amount = 5 }") do
        count = count + 1
    end
    assertTrue(count == 4, 'exactly 4 ingredients, got ' .. tostring(count))
    assertTrue(not recipeBlock:find('honda_', 1, true), 'does not reuse Honda ingredients')
    assertTrue(not recipeBlock:find('weed_', 1, true), 'does not reuse weed ingredients')
end

if failed > 0 then
    os.exit(1)
end

print('island_pills_test: ok')
