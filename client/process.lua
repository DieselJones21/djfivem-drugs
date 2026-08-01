Process = {}

local function recipeText(drug)
    local parts = {}
    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        parts[#parts + 1] = ('%sx %s'):format(ing.amount, ing.item)
    end
    return table.concat(parts, ', ')
end

local function processDrug(drugId)
    local drug = Utils.GetDrug(drugId)
    if not drug or not drug.process then return end

    local hasItems = lib.callback.await('djdrugs:server:canProcess', false, drugId)
    if not hasItems then
        Client.Notify(('Missing ingredients: %s'):format(recipeText(drug)), 'error')
        return
    end

    local p = drug.process
    if not Client.Progress(p.label or ('Process ' .. drug.label), p.duration or 10000, p.anim) then
        Client.Notify('Cancelled', 'error')
        return
    end

    TriggerServerEvent('djdrugs:server:process', drugId)
end

function Process.Init()
    for drugId, drug in pairs(Config.Drugs) do
        local p = drug.process
        if p and p.coords then
            if p.prop and p.prop.model then
                local pos = p.coords + (p.prop.offset or vec3(0.0, 0.0, 0.0))
                Client.SpawnProp(p.prop.model, pos, p.prop.heading or p.heading or 0.0)
            end

            local zoneId = exports.ox_target:addBoxZone({
                coords = p.coords,
                size = p.size or vec3(1.6, 1.6, 2.0),
                rotation = p.rotation or p.heading or 0.0,
                debug = Config.Debug,
                options = {
                    {
                        name = 'djdrugs_process_' .. drugId,
                        icon = 'fa-solid fa-flask',
                        label = p.label or ('Process ' .. drug.label),
                        distance = Config.InteractDistance,
                        onSelect = function()
                            processDrug(drugId)
                        end,
                    },
                },
            })
            Client.processZones[#Client.processZones + 1] = zoneId
            Client.AddBlip(p.coords, p.blip)
        end
    end
end