local useCooldown = {}

local function setCooldown(src)
    useCooldown[src] = os.time() + (Config.EffectCooldown or 10)
end

local function onCooldown(src)
    local now = os.time()
    if useCooldown[src] and useCooldown[src] > now then
        return true, useCooldown[src] - now
    end
    return false, 0
end

lib.callback.register('djdrugs:server:canUseDrug', function(source, itemName)
    if not Config.UseEffects then
        Server.Notify(source, 'Drug effects are disabled', 'error')
        return false
    end

    local _, drug = Utils.GetDrugByItem(itemName)
    if not drug or not drug.effects or drug.effects.enabled == false then
        Server.Notify(source, 'This item has no effect', 'error')
        return false
    end

    local cooling, left = onCooldown(source)
    if cooling then
        Server.Notify(source, ('Wait %ss before using again'):format(left), 'error')
        return false
    end

    if Server.ItemCount(source, itemName) < 1 then
        Server.Notify(source, 'You do not have that item', 'error')
        return false
    end

    return true
end)

--- Remove 1 item after client progress (QBX usable path)
lib.callback.register('djdrugs:server:consumeDrug', function(source, itemName)
    if not Config.UseEffects then return false end

    local _, drug = Utils.GetDrugByItem(itemName)
    if not drug or not drug.effects or drug.effects.enabled == false then
        return false
    end

    local cooling = onCooldown(source)
    if cooling then return false end

    if Server.ItemCount(source, itemName) < 1 then
        return false
    end

    if not Server.RemoveItem(source, itemName, 1) then
        return false
    end

    setCooldown(source)
    Utils.Debug('consumed drug', source, itemName)
    return true
end)

--- Cooldown marker after ox_inventory useItem path (item already removed by ox)
RegisterNetEvent('djdrugs:server:usedDrug', function(itemName)
    local src = source
    local _, drug = Utils.GetDrugByItem(itemName)
    if not drug then return end
    setCooldown(src)
end)

--- QBX usable fallback — works even if ox items.lua has no client.export
local function registerUseables()
    for _, drug in pairs(Config.Drugs) do
        if drug.item and drug.effects and drug.effects.enabled ~= false then
            local itemName = drug.item
            exports.qbx_core:CreateUseableItem(itemName, function(source, item)
                if not Config.UseEffects then
                    Server.Notify(source, 'Drug effects are disabled', 'error')
                    return
                end
                TriggerClientEvent('djdrugs:client:tryUseDrug', source, itemName)
            end)
            Utils.Debug('registered usable', itemName)
        end
    end
end

CreateThread(function()
    Wait(500)
    registerUseables()
    print(('[djfivem-drugs] Drug effects ready. ox_inventory export: server.export = "%s.useDrugServer" (or client.export = "%s.useDrug")'):format(
        GetCurrentResourceName(),
        GetCurrentResourceName()
    ))
end)

--- ox_inventory server export — makes items usable without client.export
--- items.lua: server = { export = 'djfivem-drugs.useDrugServer' }
exports('useDrugServer', function(event, item, inventory, slot, data)
    if event ~= 'usingItem' then return end

    local src = inventory and inventory.id
    if type(src) ~= 'number' then return false end

    if not Config.UseEffects then
        Server.Notify(src, 'Drug effects are disabled', 'error')
        return false
    end

    local itemName = item and item.name
    if not itemName then return false end

    local _, drug = Utils.GetDrugByItem(itemName)
    if not drug or not drug.effects or drug.effects.enabled == false then
        return -- not ours / no effects
    end

    TriggerClientEvent('djdrugs:client:tryUseDrug', src, itemName)
    return false -- cancel auto-consume; client progress then server consumeDrug
end)

AddEventHandler('playerDropped', function()
    useCooldown[source] = nil
end)