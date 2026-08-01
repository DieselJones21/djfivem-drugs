RegisterNetEvent('djdrugs:server:harvest', function(spotId, entityKey)
    local src = source
    local spot = Server.FindHarvest(spotId)
    if not spot then return end

    if not Server.IsNearCoords(src, spot.coords, (spot.radius or 8.0) + 4.0) then
        Server.Notify(src, 'Too far away', 'error')
        return
    end

    local cdKey = entityKey or spot.id
    local cooling, left = Server.OnCooldown(Server.harvestCooldown, src, cdKey, spot.cooldown or Config.IngredientCooldown or 10)
    if cooling then
        Server.Notify(src, ('Wait %s seconds'):format(left), 'error')
        return
    end

    local amount = Server.AmountFromConfig(spot.amount)
    if not Server.CanCarry(src, spot.item, amount) then
        Server.ClearCooldown(Server.harvestCooldown, src, cdKey)
        Server.Notify(src, 'You cannot carry that', 'error')
        return
    end

    if Server.AddItem(src, spot.item, amount) then
        Server.Notify(src, ('Collected %sx %s'):format(amount, spot.item), 'success')
    else
        Server.ClearCooldown(Server.harvestCooldown, src, cdKey)
        Server.Notify(src, 'Could not add item', 'error')
    end
end)

RegisterNetEvent('djdrugs:server:storeTake', function(storeId, itemName)
    local src = source
    local store = Server.FindStore(storeId)
    if not store then return end

    if not Server.IsNearCoords(src, store.coords, 4.0) then
        Server.Notify(src, 'Too far away', 'error')
        return
    end

    local entry
    for i = 1, #store.items do
        if store.items[i].item == itemName then
            entry = store.items[i]
            break
        end
    end
    if not entry then return end

    local cdKey = store.id .. ':' .. entry.item
    local cooling, left = Server.OnCooldown(Server.storeCooldown, src, cdKey, entry.cooldown or Config.IngredientCooldown or 10)
    if cooling then
        Server.Notify(src, ('Wait %s seconds'):format(left), 'error')
        return
    end

    local amount = Server.AmountFromConfig(entry.amount or Config.IngredientAmount)
    if entry.paid and entry.price and entry.price > 0 then
        if Server.GetMoney(src) < entry.price then
            Server.ClearCooldown(Server.storeCooldown, src, cdKey)
            Server.Notify(src, 'Not enough money', 'error')
            return
        end
        if not Server.RemoveMoney(src, entry.price) then
            Server.ClearCooldown(Server.storeCooldown, src, cdKey)
            Server.Notify(src, 'Payment failed', 'error')
            return
        end
    end

    if not Server.CanCarry(src, entry.item, amount) then
        Server.ClearCooldown(Server.storeCooldown, src, cdKey)
        Server.Notify(src, 'You cannot carry that', 'error')
        return
    end

    if Server.AddItem(src, entry.item, amount) then
        Server.Notify(src, ('Got %sx %s'):format(amount, entry.item), 'success')
    else
        Server.ClearCooldown(Server.storeCooldown, src, cdKey)
        Server.Notify(src, 'Could not add item', 'error')
    end
end)

RegisterNetEvent('djdrugs:server:machine', function(machineId)
    local src = source
    local machine = Server.FindMachine(machineId)
    if not machine then return end

    if not Server.IsNearCoords(src, machine.coords, 4.0) then
        Server.Notify(src, 'Too far away', 'error')
        return
    end

    local cooling, left = Server.OnCooldown(Server.machineCooldown, src, machine.id, machine.cooldown or Config.IngredientCooldown or 10)
    if cooling then
        Server.Notify(src, ('Wait %s seconds'):format(left), 'error')
        return
    end

    local amount = Server.AmountFromConfig(machine.amount)
    if not Server.CanCarry(src, machine.item, amount) then
        Server.ClearCooldown(Server.machineCooldown, src, machine.id)
        Server.Notify(src, 'You cannot carry that', 'error')
        return
    end

    if Server.AddItem(src, machine.item, amount) then
        Server.Notify(src, ('Got %sx %s'):format(amount, machine.item), 'success')
    else
        Server.ClearCooldown(Server.machineCooldown, src, machine.id)
        Server.Notify(src, 'Could not add item', 'error')
    end
end)