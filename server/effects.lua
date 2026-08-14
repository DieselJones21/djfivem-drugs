local useCooldown = {}

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

    local now = os.time()
    local cd = Config.EffectCooldown or 10
    if useCooldown[source] and useCooldown[source] > now then
        local left = useCooldown[source] - now
        Server.Notify(source, ('Wait %ss before using again'):format(left), 'error')
        return false
    end

    if Server.ItemCount(source, itemName) < 1 then
        Server.Notify(source, 'You do not have that item', 'error')
        return false
    end

    return true
end)

RegisterNetEvent('djdrugs:server:usedDrug', function(itemName)
    local src = source
    local _, drug = Utils.GetDrugByItem(itemName)
    if not drug then return end

    useCooldown[src] = os.time() + (Config.EffectCooldown or 10)
    Utils.Debug('player used drug', src, itemName)
end)

AddEventHandler('playerDropped', function()
    useCooldown[source] = nil
end)