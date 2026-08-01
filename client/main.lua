local QBCore = exports['qb-core']:GetCoreObject()

Client = {
    QBCore = QBCore,
    spawnedProps = {},
    harvestZones = {},
    processZones = {},
    storeZones = {},
    machineZones = {},
    blips = {},
}

function Client.Notify(description, nType)
    lib.notify({
        title = 'Drugs',
        description = description,
        type = nType or 'inform',
    })
end

function Client.Progress(label, duration, anim)
    local opts = {
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = Config.ProgressCancelOnMove,
            car = true,
            combat = true,
        },
    }

    if anim and anim.dict and anim.clip then
        opts.anim = {
            dict = anim.dict,
            clip = anim.clip,
            flag = anim.flag or 49,
        }
    end

    return lib.progressBar(opts)
end

function Client.AddBlip(coords, data)
    if not data or not data.enabled then return end
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, data.sprite or 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scale or 0.7)
    SetBlipColour(blip, data.color or 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(data.label or 'Drug Spot')
    EndTextCommandSetBlipName(blip)
    Client.blips[#Client.blips + 1] = blip
    return blip
end

function Client.LoadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if not IsModelValid(hash) then return false end
    RequestModel(hash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return hash
end

function Client.SpawnProp(model, coords, heading)
    local hash = Client.LoadModel(model)
    if not hash then return nil end
    local obj = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(obj, heading or 0.0)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetModelAsNoLongerNeeded(hash)
    Client.spawnedProps[#Client.spawnedProps + 1] = obj
    return obj
end

local function cleanup()
    for i = 1, #Client.spawnedProps do
        local ent = Client.spawnedProps[i]
        if DoesEntityExist(ent) then
            exports.ox_target:removeLocalEntity(ent)
            DeleteEntity(ent)
        end
    end
    Client.spawnedProps = {}

    for i = 1, #Client.blips do
        if DoesBlipExist(Client.blips[i]) then
            RemoveBlip(Client.blips[i])
        end
    end
    Client.blips = {}
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    cleanup()
    if Trap and Trap.Stop then
        Trap.Stop(true)
    end
end)

CreateThread(function()
    Wait(500)
    Harvest.Init()
    Process.Init()
    Sell.Init()
    Utils.Debug('client ready')
end)