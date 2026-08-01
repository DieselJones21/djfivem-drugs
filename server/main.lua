local QBCore = exports['qb-core']:GetCoreObject()

Server = {
    QBCore = QBCore,
    harvestCooldown = {},
    storeCooldown = {},
    machineCooldown = {},
    processCooldown = {},
    offers = {},
}

function Server.GetPlayer(src)
    return QBCore.Functions.GetPlayer(src)
end

function Server.Notify(src, description, nType)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Drugs',
        description = description,
        type = nType or 'inform',
    })
end

function Server.ItemCount(src, item)
    local count = exports.ox_inventory:Search(src, 'count', item)
    return count or 0
end

function Server.CanCarry(src, item, amount)
    return exports.ox_inventory:CanCarryItem(src, item, amount)
end

function Server.AddItem(src, item, amount, metadata)
    return exports.ox_inventory:AddItem(src, item, amount, metadata)
end

function Server.RemoveItem(src, item, amount)
    return exports.ox_inventory:RemoveItem(src, item, amount)
end

function Server.AddMoney(src, amount)
    local player = Server.GetPlayer(src)
    if not player then return false end
    player.Functions.AddMoney(Config.MoneyType, amount, 'djdrugs-sale')
    return true
end

function Server.OnCooldown(bucket, src, key, seconds)
    bucket[src] = bucket[src] or {}
    local now = os.time()
    local stamp = bucket[src][key]
    if stamp and stamp > now then
        return true, stamp - now
    end
    bucket[src][key] = now + (seconds or 5)
    return false, 0
end

function Server.ClearCooldown(bucket, src, key)
    if bucket[src] then
        bucket[src][key] = nil
    end
end

function Server.GetOnDutyPolice()
    if not Config.Police.enabled then return 999 end
    local count = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, player in pairs(players) do
        local job = player.PlayerData.job
        if job and job.onduty then
            for i = 1, #Config.Police.jobs do
                if job.name == Config.Police.jobs[i] then
                    count = count + 1
                    break
                end
            end
        end
    end
    return count
end

function Server.FindHarvest(id)
    for i = 1, #Config.Harvest do
        if Config.Harvest[i].id == id then
            return Config.Harvest[i]
        end
    end
end

function Server.FindStore(id)
    for i = 1, #Config.Stores do
        if Config.Stores[i].id == id then
            return Config.Stores[i]
        end
    end
end

function Server.FindMachine(id)
    for i = 1, #Config.Machines do
        if Config.Machines[i].id == id then
            return Config.Machines[i]
        end
    end
end

function Server.AmountFromConfig(amount)
    if type(amount) == 'table' then
        local min = amount.min or 1
        local max = amount.max or min
        return math.random(min, max)
    end
    return amount or 1
end

function Server.IsNearCoords(src, coords, maxDist)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local pCoords = GetEntityCoords(ped)
    return #(pCoords - coords) <= (maxDist or 4.0)
end

AddEventHandler('playerDropped', function()
    local src = source
    Server.harvestCooldown[src] = nil
    Server.storeCooldown[src] = nil
    Server.machineCooldown[src] = nil
    Server.processCooldown[src] = nil
    Server.offers[src] = nil
end)

CreateThread(function()
    math.randomseed(os.time())
    Utils.Debug('server ready — drugs loaded:', tostring(#Utils.GetSellableDrugs()))
end)