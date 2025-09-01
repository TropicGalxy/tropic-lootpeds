local QBCore = exports['qb-core']:GetCoreObject()
local checkedPeds = {}

local function IsPedBlacklisted(ped)
    local model = GetEntityModel(ped)
    for _, name in ipairs(Config.PedBlacklist) do
        if type(name) == "string" then
            if model == joaat(name) then return true end
        elseif type(name) == "number" then
            if model == name then return true end
        end
    end
    return false
end

CreateThread(function()
    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local pCoords = GetEntityCoords(playerPed)
        local handle, ped = FindFirstPed()
        local success
        repeat
            if not IsPedAPlayer(ped) and DoesEntityExist(ped) then
                if not checkedPeds[ped] and #(GetEntityCoords(ped) - pCoords) < 50.0 then
                    if IsPedDeadOrDying(ped, true) and not IsPedBlacklisted(ped) then
                        checkedPeds[ped] = true
                        local netId = NetworkGetNetworkIdFromEntity(ped)
                        TriggerServerEvent('tropic-lootpeds:server:HandleDeath', netId)
                        sleep = 500
                    end
                end
            end
            success, ped = FindNextPed(handle)
        until not success
        EndFindPed(handle)
        Wait(sleep)
    end
end)

RegisterNetEvent('tropic-lootpeds:client:SpawnLoot', function(coords, dropList)
    local angleStep = (2 * math.pi) / #dropList
    for i, drop in ipairs(dropList) do
        local angle = i * angleStep
        local offset = vector3(math.cos(angle) * Config.DropRadius, math.sin(angle) * Config.DropRadius, 0.0)
        local dropCoords = coords + offset
        local model = joaat(drop.prop)

        lib.requestModel(model)
        local obj = CreateObject(model, dropCoords.x, dropCoords.y, dropCoords.z, true, true, false)
        SetEntityAsMissionEntity(obj, true, true)
        PlaceObjectOnGroundProperly(obj)

        local netId = NetworkGetNetworkIdFromEntity(obj)
        TriggerServerEvent('tropic-lootpeds:server:RegisterProp', netId, drop)

        SetEntityDrawOutline(obj, true)
        SetEntityDrawOutlineColor(0, 255, 0, 255)
        SetEntityDrawOutlineShader(1)

        exports.ox_target:addLocalEntity(obj, {
            {
                name = drop.prop .. ':' .. i,
                label = drop.label,
                icon = 'fas fa-box',
                distance = 3.0,
                onSelect = function()
                    local ped = PlayerPedId()
                    local pCoords = GetEntityCoords(ped)
                    local oCoords = GetEntityCoords(obj)
                    if #(pCoords - oCoords) > 3.0 then return end

                    lib.requestAnimDict("pickup_object")
                    TaskPlayAnim(ped, "pickup_object", "pickup_low", 1.0, -1.0, 1000, 49, 0, false, false, false)
                    Wait(900)

                    local success = lib.callback.await('tropic-lootpeds:server:CollectLoot', false, netId)
                    if success then
                        SetEntityDrawOutline(obj, false)
                        DeleteEntity(obj)
                    end
                end
            }
        })

        if Config.PropDespawnTime and Config.PropDespawnTime > 0 then
            SetTimeout(Config.PropDespawnTime, function()
                if DoesEntityExist(obj) then
                    SetEntityDrawOutline(obj, false)
                    DeleteEntity(obj)
                    TriggerServerEvent('tropic-lootpeds:server:RegisterProp', netId, nil)
                end
            end)
        end
    end
end)
