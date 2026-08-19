--[[
    Thin QBX + ox_inventory bridge.
    Inventory always goes through ox_inventory.
    Framework money/jobs go through qbx_core.
]]

Bridge = {}

function Bridge.GetPlayer(src)
    return exports.qbx_core:GetPlayer(src)
end

function Bridge.GetPlayers()
    return exports.qbx_core:GetQBPlayers()
end

function Bridge.AddMoney(src, moneyType, amount, reason)
    return exports.qbx_core:AddMoney(src, moneyType, amount, reason or 'djdrugs')
end

function Bridge.RemoveMoney(src, moneyType, amount, reason)
    return exports.qbx_core:RemoveMoney(src, moneyType, amount, reason or 'djdrugs')
end

function Bridge.GetMoney(src, moneyType)
    return exports.qbx_core:GetMoney(src, moneyType) or 0
end

function Bridge.ItemCount(src, item)
    return exports.ox_inventory:Search(src, 'count', item) or 0
end

function Bridge.CanCarry(src, item, amount)
    return exports.ox_inventory:CanCarryItem(src, item, amount)
end

function Bridge.AddItem(src, item, amount, metadata)
    return exports.ox_inventory:AddItem(src, item, amount, metadata)
end

function Bridge.HasPermission(src, permission)
    local ok, result = pcall(function()
        return exports.qbx_core:HasPermission(src, permission)
    end)
    return ok and result == true
end

function Bridge.IsBoostAdmin(src)
    local ace = Config.Boost and Config.Boost.ace
    if ace and IsPlayerAceAllowed(src, ace) then
        return true
    end

    local perms = Config.Boost and Config.Boost.permissions or { 'admin', 'god' }
    for i = 1, #perms do
        if Bridge.HasPermission(src, perms[i]) then
            return true
        end
    end

    return false
end