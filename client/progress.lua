ProgressUI = {}

local function formatMoney(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n)
    local k
    while true do
        s, k = s:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then break end
    end
    return '$' .. s
end

local function formatSold(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n)
    local k
    while true do
        s, k = s:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then break end
    end
    return s
end

function ProgressUI.Open()
    if not Config.Progression or Config.Progression.enabled == false then
        Client.Notify('Sell ranks are disabled', 'error')
        return
    end

    local board = lib.callback.await('djdrugs:server:getProgressBoard', false)
    if not board then
        Client.Notify('Could not load the leaderboard', 'error')
        return
    end

    local options = {}
    local me = board.mine
    if me then
        local place = me.place and ('#' .. me.place) or 'Unranked'
        local progressLine
        if me.maxed then
            progressLine = 'Max rank — Kingpin'
        else
            progressLine = ('%s more units to %s'):format(formatSold(me.remaining), me.nextLabel or 'next rank')
        end
        options[#options + 1] = {
            title = ('You — %s %s'):format(place, me.label),
            description = ('Sold %s  •  Earned %s  •  %sx pay\n%s'):format(
                formatSold(me.sold),
                formatMoney(me.earned),
                me.payoutMultiplier or 1,
                progressLine
            ),
            icon = 'fa-solid fa-user',
        }
    end

    options[#options + 1] = {
        title = 'Top sellers',
        description = board.totalSellers == 0 and 'No sales recorded yet' or ('%s trappers on the board'):format(board.totalSellers),
        icon = 'fa-solid fa-trophy',
    }

    if board.top then
        for i = 1, #board.top do
            local row = board.top[i]
            options[#options + 1] = {
                title = ('#%s  %s'):format(row.place, row.name),
                description = ('%s  •  %s sold  •  %s earned'):format(
                    row.label,
                    formatSold(row.sold),
                    formatMoney(row.earned)
                ),
                icon = i == 1 and 'fa-solid fa-crown' or 'fa-solid fa-medal',
            }
        end
    end

    lib.registerContext({
        id = 'djdrugs_progress_board',
        title = 'Drug Board',
        options = options,
    })
    lib.showContext('djdrugs_progress_board')
end

CreateThread(function()
    Wait(500)
    if not Config.Progression or Config.Progression.enabled == false then
        return
    end
    local cmd = Config.Progression.command or 'drugboard'
    RegisterCommand(cmd, function()
        ProgressUI.Open()
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. cmd, Config.Progression.description or 'Drug sell leaderboard')
end)
