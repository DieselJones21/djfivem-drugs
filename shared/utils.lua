Utils = {}

local DEFAULT_FRAMEWORK_MONEY = {
    cash = true,
    bank = true,
    crypto = true,
}

function Utils.Debug(...)
    if not Config or not Config.Debug then return end
    print('[djfivem-drugs]', ...)
end

-- QBX accounts go through qbx_core:AddMoney. Everything else (black_money)
-- is an ox_inventory item — AddMoney('black_money') always fails on stock QBX.
function Utils.IsFrameworkMoney(moneyType)
    if type(moneyType) ~= 'string' or moneyType == '' then
        return false
    end
    local configured = Config and Config.FrameworkMoneyTypes
    if type(configured) == 'table' then
        return configured[moneyType] == true
    end
    return DEFAULT_FRAMEWORK_MONEY[moneyType] == true
end

function Utils.RandomInt(min, max)
    return math.random(min, max)
end

function Utils.RandomFloat(min, max)
    return min + (math.random() * (max - min))
end

function Utils.GetDrug(drugId)
    return Config.Drugs[drugId]
end

function Utils.GetDrugByItem(itemName)
    for id, drug in pairs(Config.Drugs) do
        if drug.item == itemName then
            return id, drug
        end
    end
end

function Utils.GetSellableDrugs()
    local list = {}
    for id, drug in pairs(Config.Drugs) do
        if drug.sell and drug.sell.enabled ~= false then
            list[#list + 1] = id
        end
    end
    table.sort(list)
    return list
end

function Utils.Distance(a, b)
    return #(a - b)
end