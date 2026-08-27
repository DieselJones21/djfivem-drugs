--[[
    Every drug/ingredient item (except black_money) must have a PNG icon.

    lua tests/inventory_images_test.lua
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

local itemsLua = read('install/ox_inventory_items.lua')
local names = {}
for name in itemsLua:gmatch("%['([%w_]+)'%]") do
    names[#names + 1] = name
end

assertTrue(#names >= 33, 'parsed item names, got ' .. tostring(#names))

local iconCount = 0
for i = 1, #names do
    local name = names[i]
    if name ~= 'black_money' then
        local path = 'install/images/' .. name .. '.png'
        local f = io.open(path, 'rb')
        assertTrue(f ~= nil, 'missing icon ' .. path)
        if f then
            local magic = f:read(8)
            f:close()
            assertTrue(magic == '\137PNG\r\n\26\n', name .. '.png is a PNG file')
            iconCount = iconCount + 1
        end
    end
end

assertTrue(iconCount == (#names - 1), 'icon count matches items minus black_money')

local dir = io.popen('ls install/images/*.png | wc -l')
local listed = tonumber((dir:read('*a')))
dir:close()
assertTrue(listed == iconCount, 'no extra/missing PNGs in install/images')

if failed > 0 then
    os.exit(1)
end

print(('inventory_images_test: ok (%s icons)'):format(iconCount))
