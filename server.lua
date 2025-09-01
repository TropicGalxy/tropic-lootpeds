local QBCore = exports['qb-core']:GetCoreObject()
local activeProps = {}

RegisterNetEvent('tropic-lootpeds:server:HandleDeath', function(pedNetId)
    local ped = NetworkGetEntityFromNetworkId(pedNetId)
    if not DoesEntityExist(ped) then return end

    if math.random(100) <= Config.DropChance then
        local dropCount = math.random(Config.MinDrops, Config.MaxDrops)
        local chosenDrops = {}
        for i=1, dropCount do
            chosenDrops[#chosenDrops+1] = Config.Drops[math.random(#Config.Drops)]
        end
        local coords = GetEntityCoords(ped)
        TriggerClientEvent('tropic-lootpeds:client:SpawnLoot', -1, coords, chosenDrops)
    end
end)

RegisterNetEvent('tropic-lootpeds:server:RegisterProp', function(netId, drop)
    if drop then
        activeProps[netId] = drop
    else
        activeProps[netId] = nil
    end
end)

lib.callback.register('tropic-lootpeds:server:CollectLoot', function(src, netId)
    local drop = activeProps[netId]
    if not drop then return false end

    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end

    local pCoords = GetEntityCoords(ped)
    local obj = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(obj) then return false end

    local oCoords = GetEntityCoords(obj)
    if #(pCoords - oCoords) > 3.0 then return false end

    local valid = false
    for _, d in pairs(Config.Drops) do
        if d.item == drop.item then
            valid = true
            break
        end
    end
    if not valid then return false end

    local amt = math.random(drop.amount.min, drop.amount.max)
    local success = exports.ox_inventory:AddItem(src, drop.item, amt)

    if success then
        activeProps[netId] = nil
        return true
    end

    return false
end)
