local function newToken()
    return ('%s_%s_%s'):format(os.time(), math.random(1000, 9999), math.random(10000, 99999))
end

local function playerSellableStock(src)
    local stock = {}
    for drugId, drug in pairs(Config.Drugs) do
        if drug.sell and drug.sell.enabled ~= false then
            local count = Server.ItemCount(src, drug.item)
            if count > 0 then
                stock[#stock + 1] = {
                    id = drugId,
                    drug = drug,
                    count = count,
                }
            end
        end
    end
    return stock
end

lib.callback.register('djdrugs:server:canTrap', function(source)
    if Config.Police.enabled then
        local cops = Server.GetOnDutyPolice()
        if cops < (Config.Police.minimum or 0) then
            return false, 'Not enough police on duty'
        end
    end

    if Config.Trap.requireOwnedDrug then
        local stock = playerSellableStock(source)
        if #stock == 0 then
            return false, 'You need finished product to trap'
        end
    end

    return true
end)

lib.callback.register('djdrugs:server:createOffer', function(source)
    local stock = playerSellableStock(source)
    local pick

    if Config.Trap.requireOwnedDrug then
        if #stock == 0 then return nil end
        pick = stock[math.random(1, #stock)]
    else
        local ids = Utils.GetSellableDrugs()
        if #ids == 0 then return nil end
        local drugId = ids[math.random(1, #ids)]
        local drug = Utils.GetDrug(drugId)
        pick = {
            id = drugId,
            drug = drug,
            count = Server.ItemCount(source, drug.item),
        }
        if pick.count <= 0 then return nil end
    end

    local sell = pick.drug.sell
    local maxAsk = math.min(sell.maxQty or 5, pick.count)
    local minAsk = math.min(sell.minQty or 1, maxAsk)
    if maxAsk < 1 then return nil end

    local quantity = math.random(minAsk, maxAsk)
    local priceEach = math.random(sell.minPrice, sell.maxPrice)
    local total = priceEach * quantity
    local token = newToken()

    Server.offers[source] = {
        token = token,
        drugId = pick.id,
        item = pick.drug.item,
        label = pick.drug.label,
        quantity = quantity,
        priceEach = priceEach,
        total = total,
        expires = os.time() + 90,
    }

    return {
        token = token,
        drugId = pick.id,
        item = pick.drug.item,
        label = pick.drug.label,
        quantity = quantity,
        priceEach = priceEach,
        total = total,
    }
end)

lib.callback.register('djdrugs:server:completeSale', function(source, token)
    local offer = Server.offers[source]
    if not offer or offer.token ~= token then
        return false, 'Offer expired'
    end

    if offer.expires < os.time() then
        Server.offers[source] = nil
        return false, 'Offer expired'
    end

    local count = Server.ItemCount(source, offer.item)
    if count < offer.quantity then
        Server.offers[source] = nil
        return false, 'Not enough product'
    end

    if not Server.RemoveItem(source, offer.item, offer.quantity) then
        return false, 'Could not remove product'
    end

    if not Server.AddMoney(source, offer.total) then
        Server.AddItem(source, offer.item, offer.quantity)
        return false, 'Payment failed'
    end

    Server.offers[source] = nil

    if Config.Police.enabled and (Config.Police.alertChance or 0) > 0 then
        if math.random(1, 100) <= Config.Police.alertChance then
            -- Hook your dispatch here if desired
            Utils.Debug('police alert rolled for', source)
        end
    end

    return true, ('Sold %sx %s for $%s'):format(offer.quantity, offer.label, offer.total)
end)