--[[
    Rebel Rolls config + Paleto coord checks. Existing spots stay locked.

    lua tests/rebel_rolls_test.lua
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
local effects = read('client/effects.lua')

local locked = {
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
    '5365.07, -5438.82, 47.83',
    '5609.77, -5653.08, 8.65',
    '4924.14, -5271.69, 4.35',
    '4517.43, -4531.98, 2.82',
    '856.71, -943.52, 25.28',
    '284.67, -1773.03, 27.06',
    '-2950.20, 637.03, 23.18',
    '-1784.34, -401.11, 45.47',
    '-1486.62, -909.08, 9.02',
    '384.63, 3554.60, 32.42',
    '1092.77, -154.72, 54.64',
    '5071.07, -4639.87, 2.11',
}

for i = 1, #locked do
    local coord = locked[i]
    local found = config:find(coord, 1, true) or drugs:find(coord, 1, true)
    assertTrue(found, 'existing coord still present: ' .. coord)
end

assertTrue(drugs:find('rebel_rolls%s*=%s*{', 1) ~= nil, 'Config.Drugs.rebel_rolls exists')
assertTrue(drugs:find("item = 'rebel_rolls'", 1, true) ~= nil, 'finished item is rebel_rolls')
assertTrue(drugs:find('sprintMultiplier = 1.35', 1, true) ~= nil, 'speed boost configured')
assertTrue(drugs:find('stamina = true', 1, true) ~= nil, 'stamina configured')
assertTrue(effects:find('SetRunSprintMultiplierForPlayer', 1, true) ~= nil, 'client applies sprint multiplier')

-- Honda-matching pay
local block = drugs:match('rebel_rolls%s*=%s*%b{}')
assertTrue(block ~= nil, 'rebel_rolls block parseable')
if block then
    assertTrue(block:find('minPrice = 500', 1, true) ~= nil, 'same min as Honda Pills')
    assertTrue(block:find('maxPrice = 850', 1, true) ~= nil, 'same max as Honda Pills')
    assertTrue(block:find("moneyType = 'black_money'", 1, true) ~= nil, 'dirty payout')
    assertTrue(not block:find('armorPercent%s*=', 1), 'no armor on Rebel Rolls')
    assertTrue(not block:find('screenEffect%s*=', 1), 'no screen FX')
    assertTrue(not block:find('timecycle%s*=', 1), 'no timecycle')
    local count = 0
    for _ in block:gmatch("{ item = '[^']+', amount = 5 }") do
        count = count + 1
    end
    assertTrue(count == 4, 'exactly 4 ingredients, got ' .. tostring(count))
end

local ingredients = { 'rebel_crystals', 'neon_dye', 'pill_binder', 'dove_stamps' }
for i = 1, #ingredients do
    local name = ingredients[i]
    assertTrue(drugs:find("{ item = '" .. name .. "', amount = 5 }", 1, true) ~= nil, name .. ' in recipe')
    assertTrue(config:find("item = '" .. name .. "'", 1, true) ~= nil, name .. ' harvest bench')
    assertTrue(items:find("%['" .. name .. "'%]") ~= nil, name .. ' inventory item')
end
assertTrue(items:find("%['rebel_rolls'%]") ~= nil, 'rebel_rolls inventory item')

-- Paleto Bay: X between -600 and 100, Y between 5900 and 6700
local paleto = {
    { '-319.55', '6084.12', '31.45' },
    { '-70.41', '6266.04', '31.21' },
    { '-145.38', '6304.51', '31.56' },
    { '-213.47', '6556.18', '10.99' },
    { '-414.89', '6173.55', '31.48' },
}

for i = 1, #paleto do
    local x, y, z = paleto[i][1], paleto[i][2], paleto[i][3]
    local needle = x .. ', ' .. y .. ', ' .. z
    local found = config:find(needle, 1, true) or drugs:find(needle, 1, true)
    assertTrue(found, 'Paleto spot present: ' .. needle)
    local xn, yn = tonumber(x), tonumber(y)
    assertTrue(xn > -600 and xn < 100, 'Paleto X: ' .. x)
    assertTrue(yn > 5900 and yn < 6700, 'Paleto Y: ' .. y)
    assertTrue(locations:find(needle, 1, true) ~= nil, 'LOCATIONS.md lists ' .. needle)
end

assertTrue(config:find("command = 'drugboard'", 1, true) ~= nil, 'leaderboard command')
assertTrue(config:find('sold = 4500', 1, true) ~= nil, 'Kingpin threshold 4500')

if failed > 0 then
    os.exit(1)
end

print('rebel_rolls_test: ok')
