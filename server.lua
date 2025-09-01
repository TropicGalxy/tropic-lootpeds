local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('tropic-lootpeds:server:HandleDeath', function(coords)
    if math.random(100) <= Config.DropChance then
        local dropCount = math.random(Config.MinDrops, Config.MaxDrops)
        local chosenDrops = {}

        for i=1, dropCount do
            chosenDrops[#chosenDrops+1] = Config.Drops[math.random(#Config.Drops)]
        end

        TriggerClientEvent('tropic-lootpeds:client:SpawnLoot', -1, coords, chosenDrops)
    end
end)

RegisterNetEvent('tropic-lootpeds:server:CollectLoot', function(drop)
    local src = source
    if not drop or not drop.item then return end

    local valid = false
    for _, d in pairs(Config.Drops) do
        if d.item == drop.item then
            valid = true
            break
        end
    end
    if not valid then return end

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local amt = math.random(drop.amount.min, drop.amount.max)

    local success = exports.ox_inventory:AddItem(src, drop.item, amt)

    if success then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success',
            description = ('You looted %sx %s'):format(amt, drop.item)
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'Inventory full!'
        })
    end
end)
