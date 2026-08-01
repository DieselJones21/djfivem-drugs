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

local function setupSpot(spot)
    local zoneId = exports.ox_target:addBoxZone({
        coords = spot.coords,
        size = spot.size or vec3(1.5, 1.5, 2.0),
        rotation = spot.rotation or spot.heading or 0.0,
        debug = Config.Debug,
        options = {
            {
                name = 'djdrugs_harvest_' .. spot.id,
                icon = 'fa-solid fa-hand',
                label = spot.label,
                distance = Config.InteractDistance,
                onSelect = function()
                    doHarvest(spot)
                end,
            },
        },
    })
    Client.harvestZones[#Client.harvestZones + 1] = zoneId
    Client.AddBlip(spot.coords, spot.blip)
end

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

        local obj = Client.SpawnProp(spot.model, vec3(x, y, z), heading)
        if obj then
            local entityKey = ('%s_%s'):format(spot.id, i)
            exports.ox_target:addLocalEntity(obj, {
                {
                    name = 'djdrugs_prop_' .. entityKey,
                    icon = 'fa-solid fa-seedling',
                    label = spot.label,
                    distance = Config.InteractDistance,
                    onSelect = function()
                        doHarvest(spot, entityKey)
                    end,
                },
            })
        end
    end
end

function Harvest.Init()
    for i = 1, #Config.Harvest do
        local spot = Config.Harvest[i]
        if spot.type == 'prop' then
            setupPropField(spot)
        else
            setupSpot(spot)
        end
    end

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
                    if onCooldown(key, entry.cooldown or 15) then return end
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

    for i = 1, #Config.Machines do
        local machine = Config.Machines[i]
        local zoneId = exports.ox_target:addBoxZone({
            coords = machine.coords,
            size = machine.size or vec3(1.2, 1.2, 2.0),
            rotation = machine.rotation or 0.0,
            debug = Config.Debug,
            options = {
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
            },
        })
        Client.machineZones[#Client.machineZones + 1] = zoneId
    end
end