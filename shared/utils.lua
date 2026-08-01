Utils = {}

function Utils.Debug(...)
    if not Config or not Config.Debug then return end
    print('[djfivem-drugs]', ...)
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