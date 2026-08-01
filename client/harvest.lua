Harvest = {}

local cooldowns = {}

local function onCooldown(id, seconds)
    local now = GetGameTimer()
    if cooldowns[id] and cooldowns[id] > now then
        local left = math.ceil((cooldowns[id] - now) / 1000)
        Client.Notify(('Wait %s seconds'):format(left), 'error')
        return true
    end
    cooldowns[id] = now + ((seconds or 10) * 1000)
    return false
end

local function doHarvest(spot, entityKey)
    local key = entityKey or spot.id
    if onCooldown(key, spot.cooldown) then return end

    if not Client.Progress(spot.label, spot.duration or 5000, spot.anim) then
        Client.Notify('Cancelled', 'error')
        cooldowns[key] = nil
        return
    end

    TriggerServerEvent('djdrugs:server:harvest', spot.id, entityKey)
end

--- Spawn a single interactable harvest bench/prop
local function setupBench(spot)
    Client.AddBlip(spot.coords, spot.blip)

    local propData = spot.prop
    if not propData or not propData.model then
        Utils.Debug('harvest bench missing prop', spot.id)
        return
    end

    local heading = propData.heading or spot.heading or spot.rotation or 0.0
    local options = {
        {
            name = 'djdrugs_harvest_' .. spot.id,
            icon = 'fa-solid fa-hand',
            label = spot.label,
            distance = Config.InteractDistance,
            onSelect = function()
                doHarvest(spot)
            end,
        },
    }

    local obj = Client.SpawnTargetProp(propData.model, spot.coords, heading, options, true)
    if not obj then
        -- Fallback zone if prop fails to load
        local zoneId = exports.ox_target:addBoxZone({
            coords = spot.coords,
            size = spot.size or vec3(1.6, 1.6, 2.0),
            rotation = heading,
            debug = Config.Debug,
            options = options,
        })
        Client.harvestZones[#Client.harvestZones + 1] = zoneId
    end
end

--- Plant fields (weed / coca)
local function setupPropField(spot)
    Client.AddBlip(spot.coords, spot.blip)

    local count = spot.count or 5
    local radius = spot.radius or 5.0

    for i = 1, count do
        local angle = (i / count) * math.pi * 2
        local dist = radius * (0.45 + (math.random() * 0.55))
        local x = spot.coords.x + math.cos(angle) * dist
        local y = spot.coords.y + math.sin(angle) * dist
        local z = spot.coords.z
        local heading = (spot.heading or 0.0) + (i * 35.0)

        local entityKey = ('%s_%s'):format(spot.id, i)
        Client.SpawnTargetProp(spot.model, vec3(x, y, z), heading, {
            {
                name = 'djdrugs_prop_' .. entityKey,
                icon = 'fa-solid fa-seedling',
                label = spot.label,
                distance = Config.InteractDistance,
                onSelect = function()
                    doHarvest(spot, entityKey)
                end,
            },
        }, true)
    end
end

local function setupStores()
    for i = 1, #Config.Stores do
        local store = Config.Stores[i]
        local options = {}
        for j = 1, #store.items do
            local entry = store.items[j]
            options[#options + 1] = {
                name = ('djdrugs_store_%s_%s'):format(store.id, entry.item),
                icon = 'fa-solid fa-basket-shopping',
                label = entry.label or ('Take ' .. entry.item),
                distance = Config.InteractDistance,
                onSelect = function()
                    local key = store.id .. ':' .. entry.item
                    if onCooldown(key, entry.cooldown or Config.IngredientCooldown or 10) then return end
                    if not Client.Progress(entry.label or 'Taking supplies', entry.duration or 3500, entry.anim) then
                        Client.Notify('Cancelled', 'error')
                        cooldowns[key] = nil
                        return
                    end
                    TriggerServerEvent('djdrugs:server:storeTake', store.id, entry.item)
                end,
            }
        end

        local zoneId = exports.ox_target:addBoxZone({
            coords = store.coords,
            size = store.size or vec3(1.4, 1.4, 2.0),
            rotation = store.rotation or 0.0,
            debug = Config.Debug,
            options = options,
        })
        Client.storeZones[#Client.storeZones + 1] = zoneId
    end
end

local function setupMachines()
    for i = 1, #Config.Machines do
        local machine = Config.Machines[i]
        local options = {
            {
                name = 'djdrugs_machine_' .. machine.id,
                icon = 'fa-solid fa-snowflake',
                label = machine.label,
                distance = Config.InteractDistance,
                onSelect = function()
                    if onCooldown(machine.id, machine.cooldown or 20) then return end
                    if not Client.Progress(machine.label, machine.duration or 4000, machine.anim) then
                        Client.Notify('Cancelled', 'error')
                        cooldowns[machine.id] = nil
                        return
                    end
                    TriggerServerEvent('djdrugs:server:machine', machine.id)
                end,
            },
        }

        if machine.prop and machine.prop.model then
            local heading = machine.prop.heading or machine.heading or 0.0
            local obj = Client.SpawnTargetProp(machine.prop.model, machine.coords, heading, options, true)
            if not obj then
                local zoneId = exports.ox_target:addBoxZone({
                    coords = machine.coords,
                    size = machine.size or vec3(1.2, 1.2, 2.0),
                    rotation = heading,
                    debug = Config.Debug,
                    options = options,
                })
                Client.machineZones[#Client.machineZones + 1] = zoneId
            end
        else
            local zoneId = exports.ox_target:addBoxZone({
                coords = machine.coords,
                size = machine.size or vec3(1.2, 1.2, 2.0),
                rotation = machine.rotation or machine.heading or 0.0,
                debug = Config.Debug,
                options = options,
            })
            Client.machineZones[#Client.machineZones + 1] = zoneId
        end
    end
end

function Harvest.Init()
    for i = 1, #Config.Harvest do
        local spot = Config.Harvest[i]
        if spot.type == 'prop' then
            setupPropField(spot)
        else
            -- 'bench' (and legacy 'spot')
            setupBench(spot)
        end
    end

    setupStores()
    setupMachines()
end