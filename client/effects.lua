Effects = {
    active = nil,
    token = 0,
}

local function loadAnimDict(dict)
    if not dict then return false end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

local function clearVisuals()
    ClearTimecycleModifier()
    StopGameplayCamShaking(true)
    AnimpostfxStopAll()
    ResetPedMovementClipset(PlayerPedId(), 0.25)
    SetPedIsDrunk(PlayerPedId(), false)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    SetSwimMultiplierForPlayer(PlayerId(), 1.0)
end

function Effects.Clear()
    Effects.token = Effects.token + 1
    Effects.active = nil
    clearVisuals()
end

local function applyStress(amount)
    if not amount or amount == 0 then return end
    -- Negative = relieve stress (common QB/QBX HUD event)
    if amount < 0 and Config.StressEvent then
        TriggerServerEvent(Config.StressEvent, math.abs(amount))
    elseif amount > 0 and Config.StressGainEvent then
        TriggerServerEvent(Config.StressGainEvent, amount)
    end
end

function Effects.Apply(drugId, effect)
    Effects.Clear()
    local token = Effects.token
    Effects.active = drugId

    local ped = PlayerPedId()
    local playerId = PlayerId()

    if effect.health and effect.health ~= 0 then
        local hp = GetEntityHealth(ped) + effect.health
        SetEntityHealth(ped, math.min(hp, GetEntityMaxHealth(ped)))
    end

    if effect.armor and effect.armor > 0 then
        SetPedArmour(ped, math.min(100, GetPedArmour(ped) + effect.armor))
    end

    if effect.stress then
        applyStress(effect.stress)
    end

    if effect.timecycle then
        SetTimecycleModifier(effect.timecycle)
        SetTimecycleModifierStrength(effect.timecycleStrength or 0.5)
    end

    if effect.screenEffect then
        AnimpostfxPlay(effect.screenEffect, 0, true)
    end

    if effect.shake then
        ShakeGameplayCam('DRUNK_SHAKE', effect.shake.intensity or 0.3)
        SetTimeout(effect.shake.duration or 5000, function()
            if Effects.token == token then
                StopGameplayCamShaking(true)
            end
        end)
    end

    if effect.walk then
        RequestAnimSet(effect.walk)
        local timeout = GetGameTimer() + 3000
        while not HasAnimSetLoaded(effect.walk) do
            if GetGameTimer() > timeout then break end
            Wait(10)
        end
        if HasAnimSetLoaded(effect.walk) then
            SetPedMovementClipset(ped, effect.walk, 0.5)
        end
    end

    if effect.drunkCamera then
        SetPedIsDrunk(ped, true)
    end

    if effect.sprintMultiplier and effect.sprintMultiplier > 1.0 then
        SetRunSprintMultiplierForPlayer(playerId, effect.sprintMultiplier)
    end

    CreateThread(function()
        local endsAt = GetGameTimer() + (effect.duration or 30000)
        while Effects.token == token and GetGameTimer() < endsAt do
            if effect.stamina then
                RestorePlayerStamina(playerId, 1.0)
            end
            Wait(1000)
        end

        if Effects.token == token then
            Effects.Clear()
            Client.Notify('The high wore off', 'inform')
        end
    end)
end

--- ox_inventory client export — wire finished drug items to this
exports('useDrug', function(data, slot)
    if not Config.UseEffects then return end
    if not data or not data.name then return end

    local drugId, drug = Utils.GetDrugByItem(data.name)
    if not drug or not drug.effects or drug.effects.enabled == false then
        Client.Notify('This item has no effect configured', 'error')
        return
    end

    local effect = drug.effects
    local canUse = lib.callback.await('djdrugs:server:canUseDrug', false, data.name)
    if not canUse then return end

    local progressOk = true
    if effect.useTime and effect.useTime > 0 then
        progressOk = Client.Progress(effect.label or ('Using ' .. drug.label), effect.useTime, effect.anim)
    elseif effect.anim and effect.anim.dict and loadAnimDict(effect.anim.dict) then
        TaskPlayAnim(PlayerPedId(), effect.anim.dict, effect.anim.clip, 8.0, -8.0, 2500, effect.anim.flag or 49, 0, false, false, false)
        Wait(2500)
        ClearPedTasks(PlayerPedId())
    end

    if not progressOk then
        Client.Notify('Cancelled', 'error')
        return
    end

    -- Consume after successful progress
    exports.ox_inventory:useItem(data, function(used)
        if not used then
            Client.Notify('Could not use item', 'error')
            return
        end
        TriggerServerEvent('djdrugs:server:usedDrug', data.name)
        Effects.Apply(drugId, effect)
        Client.Notify(('You used %s'):format(drug.label), 'success')
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Effects.Clear()
end)