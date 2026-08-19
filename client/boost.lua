BoostUI = {}

local cachedBoost = { sell = nil, harvest = nil }

local function formatLeft(seconds)
    seconds = math.max(0, seconds or 0)
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    if m >= 60 then
        local h = math.floor(m / 60)
        m = m % 60
        return ('%sh %sm'):format(h, m)
    end
    return ('%sm %ss'):format(m, s)
end

local function refreshBoost()
    cachedBoost = lib.callback.await('djdrugs:server:getBoostState', false) or { sell = nil, harvest = nil }
    return cachedBoost
end

RegisterNetEvent('djdrugs:client:boostUpdated', function(state)
    cachedBoost = state or { sell = nil, harvest = nil }
end)

function BoostUI.GetCached()
    return cachedBoost
end

local function openDurationMenu(kind, multiplier)
    local options = {}
    for i = 1, #(Config.Boost.durations or {}) do
        local d = Config.Boost.durations[i]
        options[#options + 1] = {
            title = d.label,
            description = ('Start %sx %s boost'):format(multiplier, kind),
            icon = 'fa-solid fa-clock',
            onSelect = function()
                TriggerServerEvent('djdrugs:server:startBoost', kind, multiplier, d.seconds)
            end,
        }
    end

    lib.registerContext({
        id = 'djdrugs_boost_duration',
        title = ('%sx %s — Duration'):format(multiplier, kind),
        menu = 'djdrugs_boost_multiplier',
        options = options,
    })
    lib.showContext('djdrugs_boost_duration')
end

local function openMultiplierMenu(kind)
    local options = {}
    for i = 1, #(Config.Boost.multipliers or {}) do
        local mult = Config.Boost.multipliers[i]
        options[#options + 1] = {
            title = ('%sx Boost'):format(mult),
            description = kind == 'both'
                and 'Sell prices + harvest yields'
                or (kind == 'sell' and 'Street sale payouts' or 'Ingredient harvest yields'),
            icon = 'fa-solid fa-bolt',
            onSelect = function()
                openDurationMenu(kind, mult)
            end,
        }
    end

    lib.registerContext({
        id = 'djdrugs_boost_multiplier',
        title = 'Select Multiplier',
        menu = 'djdrugs_boost_main',
        options = options,
    })
    lib.showContext('djdrugs_boost_multiplier')
end

local function statusLine(event, label)
    if not event then
        return ('%s: inactive'):format(label)
    end
    return ('%s: %sx — %s left (by %s)'):format(
        label,
        event.multiplier,
        formatLeft(event.remaining),
        event.startedBy or 'Admin'
    )
end

function BoostUI.Open()
    local allowed = lib.callback.await('djdrugs:server:canManageBoost', false)
    if not allowed then
        Client.Notify('No permission for boost events', 'error')
        return
    end

    local state = refreshBoost()

    lib.registerContext({
        id = 'djdrugs_boost_main',
        title = 'Drug Boost Events',
        options = {
            {
                title = 'Active Events',
                description = ('%s\n%s'):format(
                    statusLine(state.sell, 'Sell'),
                    statusLine(state.harvest, 'Harvest')
                ),
                icon = 'fa-solid fa-chart-line',
                disabled = true,
            },
            {
                title = 'Start Sell Boost',
                description = '2x / 3x / 4x street sale prices',
                icon = 'fa-solid fa-dollar-sign',
                arrow = true,
                onSelect = function()
                    openMultiplierMenu('sell')
                end,
            },
            {
                title = 'Start Harvest Boost',
                description = '2x / 3x / 4x ingredient yields',
                icon = 'fa-solid fa-seedling',
                arrow = true,
                onSelect = function()
                    openMultiplierMenu('harvest')
                end,
            },
            {
                title = 'Start Both Boosts',
                description = 'Same multiplier for sell + harvest',
                icon = 'fa-solid fa-fire',
                arrow = true,
                onSelect = function()
                    openMultiplierMenu('both')
                end,
            },
            {
                title = 'Stop Sell Boost',
                description = 'End the active sell event',
                icon = 'fa-solid fa-ban',
                disabled = state.sell == nil,
                onSelect = function()
                    TriggerServerEvent('djdrugs:server:stopBoost', 'sell')
                end,
            },
            {
                title = 'Stop Harvest Boost',
                description = 'End the active harvest event',
                icon = 'fa-solid fa-ban',
                disabled = state.harvest == nil,
                onSelect = function()
                    TriggerServerEvent('djdrugs:server:stopBoost', 'harvest')
                end,
            },
            {
                title = 'Stop All Boosts',
                description = 'End sell and harvest events',
                icon = 'fa-solid fa-power-off',
                disabled = state.sell == nil and state.harvest == nil,
                onSelect = function()
                    TriggerServerEvent('djdrugs:server:stopBoost', 'both')
                end,
            },
        },
    })

    lib.showContext('djdrugs_boost_main')
end

CreateThread(function()
    Wait(500)
    local cmd = (Config.Boost and Config.Boost.command) or 'drugboost'
    RegisterCommand(cmd, function()
        BoostUI.Open()
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. cmd, (Config.Boost and Config.Boost.description) or 'Drug boost admin menu')
    refreshBoost()
end)