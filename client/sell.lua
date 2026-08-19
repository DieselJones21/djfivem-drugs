Sell = {}
Trap = {
    active = false,
    buyer = nil,
    blip = nil,
    offer = nil,
    dealing = false,
}

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

local function deleteBuyer()
    if Trap.buyer and DoesEntityExist(Trap.buyer) then
        exports.ox_target:removeLocalEntity(Trap.buyer)
        local ped = Trap.buyer
        Trap.buyer = nil
        SetBlockingOfNonTemporaryEvents(ped, false)
        TaskWanderStandard(ped, 10.0, 10)
        SetTimeout(8000, function()
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end)
    end
    Trap.offer = nil
    Trap.dealing = false
end

function Trap.Stop(silent)
    Trap.active = false
    deleteBuyer()
    if Trap.blip and DoesBlipExist(Trap.blip) then
        RemoveBlip(Trap.blip)
        Trap.blip = nil
    end
    if not silent then
        Client.Notify('Trap mode stopped', 'inform')
    end
end

local function createTrapBlip()
    if not Config.Trap.blip.enabled then return end
    if Trap.blip and DoesBlipExist(Trap.blip) then
        RemoveBlip(Trap.blip)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, Config.Trap.blip.sprite)
    SetBlipColour(blip, Config.Trap.blip.color)
    SetBlipScale(blip, Config.Trap.blip.scale)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Trap.blip.label)
    EndTextCommandSetBlipName(blip)
    Trap.blip = blip
end

local function randomSpawnCoords(origin)
    local dist = Utils.RandomFloat(Config.Trap.spawnDistance.min, Config.Trap.spawnDistance.max)
    local angle = Utils.RandomFloat(0.0, math.pi * 2)
    local x = origin.x + math.cos(angle) * dist
    local y = origin.y + math.sin(angle) * dist
    local z = origin.z
    local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 50.0, false)
    if found then z = groundZ end
    return vec3(x, y, z)
end

local function playDealAnim()
    local anim = Config.Trap.dealAnim
    if not anim or not Trap.buyer or not DoesEntityExist(Trap.buyer) then return end
    if loadAnimDict(anim.dict) then
        TaskPlayAnim(PlayerPedId(), anim.dict, anim.clip, 8.0, -8.0, anim.duration or 2500, anim.flag or 49, 0, false, false, false)
        TaskPlayAnim(Trap.buyer, anim.dict, anim.clip, 8.0, -8.0, anim.duration or 2500, anim.flag or 49, 0, false, false, false)
        Wait(anim.duration or 2500)
        ClearPedTasks(PlayerPedId())
    end
end

local function finishSale()
    local offer = Trap.offer
    if not offer then return end

    playDealAnim()

    local ok, message = lib.callback.await('djdrugs:server:completeSale', false, offer.token)
    if ok then
        Client.Notify(message or 'Sale complete', 'success')
    else
        Client.Notify(message or 'Sale failed', 'error')
    end

    deleteBuyer()
end

local function openDealMenu()
    local offer = Trap.offer
    if not offer or not Trap.buyer or not DoesEntityExist(Trap.buyer) then return end

    local haggle = Config.Trap.haggle or {}
    local canHaggle = offer.haggleEnabled
        and (offer.attempts or 0) < (offer.maxAttempts or 0)
        and offer.priceEach < offer.maxPrice

    local options = {
        {
            title = ('Accept $%s total'):format(offer.total),
            description = ('%sx %s @ $%s each (range $%s–$%s)%s'):format(
                offer.quantity,
                offer.label,
                offer.priceEach,
                offer.minPrice,
                offer.maxPrice,
                (offer.boostMultiplier and offer.boostMultiplier > 1)
                    and (' — %sx SELL BOOST'):format(offer.boostMultiplier)
                    or ''
            ),
            icon = 'fa-solid fa-handshake',
            onSelect = function()
                finishSale()
            end,
        },
    }

    if canHaggle and haggle.asks then
        for i = 1, #haggle.asks do
            local ask = haggle.asks[i]
            options[#options + 1] = {
                title = ask.label,
                description = ('Chance varies — attempts left: %s'):format(
                    (offer.maxAttempts or 0) - (offer.attempts or 0)
                ),
                icon = 'fa-solid fa-arrow-trend-up',
                onSelect = function()
                    local result = lib.callback.await('djdrugs:server:haggleOffer', false, offer.token, ask.id)
                    if not result then
                        Client.Notify('No response', 'error')
                        deleteBuyer()
                        return
                    end

                    if result.outcome == 'walk' or result.outcome == 'expired' then
                        Client.Notify(result.message or 'Buyer left', 'error')
                        deleteBuyer()
                        return
                    end

                    if result.offer then
                        Trap.offer = result.offer
                    end

                    Client.Notify(result.message or 'Buyer responded', result.outcome == 'success' and 'success' or 'inform')

                    if Trap.offer and Trap.buyer and DoesEntityExist(Trap.buyer) then
                        openDealMenu()
                    end
                end,
            }
        end
    end

    options[#options + 1] = {
        title = 'Decline / walk away',
        description = 'Send the buyer off',
        icon = 'fa-solid fa-xmark',
        onSelect = function()
            Client.Notify('You waved the buyer off', 'inform')
            deleteBuyer()
        end,
    }

    lib.registerContext({
        id = 'djdrugs_deal_menu',
        title = 'Street Buyer',
        options = options,
    })
    lib.showContext('djdrugs_deal_menu')
end

local function spawnBuyer()
    if not Trap.active or Trap.buyer then return end

    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) or IsEntityDead(playerPed) then return end

    local offer = lib.callback.await('djdrugs:server:createOffer', false)
    if not offer then
        Client.Notify('You have nothing to sell right now', 'error')
        return
    end

    local models = Config.Trap.models
    local model = models[math.random(1, #models)]
    local hash = Client.LoadModel(model)
    if not hash then return end

    local origin = GetEntityCoords(playerPed)
    local spawn = randomSpawnCoords(origin)
    local ped = CreatePed(4, hash, spawn.x, spawn.y, spawn.z, 0.0, true, true)
    SetModelAsNoLongerNeeded(hash)

    if not DoesEntityExist(ped) then return end

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedKeepTask(ped, true)

    TaskGoToEntity(ped, playerPed, -1, 1.6, 2.2, 1073741824, 0)

    Trap.buyer = ped
    Trap.offer = offer

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'djdrugs_sell_buyer',
            icon = 'fa-solid fa-comments-dollar',
            label = ('Deal %s'):format(offer.label),
            distance = 2.2,
            onSelect = function()
                Sell.HandleBuyer()
            end,
        },
    })

    CreateThread(function()
        local arriveDeadline = GetGameTimer() + (Config.Trap.buyerApproachTime * 1000)
        while Trap.active and Trap.buyer == ped and DoesEntityExist(ped) do
            local pCoords = GetEntityCoords(PlayerPedId())
            local bCoords = GetEntityCoords(ped)
            if #(pCoords - bCoords) <= 2.0 then
                ClearPedTasks(ped)
                TaskTurnPedToFaceEntity(ped, PlayerPedId(), 1000)
                break
            end
            if GetGameTimer() > arriveDeadline then
                Client.Notify('Buyer got spooked and left', 'error')
                deleteBuyer()
                return
            end
            Wait(400)
        end

        local waitDeadline = GetGameTimer() + (Config.Trap.buyerWaitTime * 1000)
        while Trap.active and Trap.buyer == ped and DoesEntityExist(ped) do
            if GetGameTimer() > waitDeadline then
                Client.Notify('Buyer got tired of waiting', 'error')
                deleteBuyer()
                return
            end
            Wait(500)
        end
    end)
end

function Sell.HandleBuyer()
    if Trap.dealing then return end
    if not Trap.active or not Trap.buyer or not Trap.offer then return end
    if not DoesEntityExist(Trap.buyer) then
        deleteBuyer()
        return
    end

    Trap.dealing = true
    openDealMenu()
    Trap.dealing = false
end

function Sell.Init()
    RegisterCommand(Config.Trap.command, function()
        if Trap.active then
            Trap.Stop(false)
            return
        end

        local allowed, reason = lib.callback.await('djdrugs:server:canTrap', false)
        if not allowed then
            Client.Notify(reason or 'You cannot trap right now', 'error')
            return
        end

        Trap.active = true
        createTrapBlip()
        Client.Notify('Trap mode on — a buyer is coming. Use 3rd eye on them.', 'success')
        spawnBuyer()
    end, false)

    TriggerEvent('chat:addSuggestion', ('/%s'):format(Config.Trap.command), Config.Trap.description)

    CreateThread(function()
        while true do
            if Trap.active then
                if Trap.blip and DoesBlipExist(Trap.blip) then
                    local coords = GetEntityCoords(PlayerPedId())
                    SetBlipCoords(Trap.blip, coords.x, coords.y, coords.z)
                end

                if not Trap.buyer then
                    Wait((Config.Trap.cooldown or 8) * 1000)
                    if Trap.active and not Trap.buyer then
                        spawnBuyer()
                    end
                else
                    Wait(1000)
                end
            else
                Wait(1000)
            end
        end
    end)
end