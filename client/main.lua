ESX = exports["es_extended"]:getSharedObject()
local currentVehicle = nil
local handsUp = false 
local previousOutfit = nil 
local isObservingVIP = false

local blips = {
    {title="F.I.B", scale=0.8, colour=39, id=86, x = 74.22, y = -736.61, z = 45.10},
}

for _, info in pairs(blips) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, info.scale)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
end



function IsPlayerFIB()
    local playerData = ESX.GetPlayerData()
    return playerData and playerData.job and playerData.job.name == 'fib'
end


RegisterNetEvent('vs_fibjob:openMissionMenu', function()
    OpenMissionMenu()
end)

function OpenMissionMenu()
    local missionOptions = {
        {
            title = 'Misja',
            description = 'Dostarcz pojazd do garaża',
            event = 'vs_fibjob:startMission',
            args = { missionId = 1 }
        }

    }

    lib.registerContext({
        id = 'mission_main_menu',
        title = 'Misje FIB',
        options = missionOptions
    })

    lib.showContext('mission_main_menu')
end

function StartMission1()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    lib.notify({
        title = 'Sukcess!',
        description = 'Rozpoczęto Misję',
        type = 'success',
        iconAnimation = 'beat',
        position = 'top'
} )


    local spawnPoints = {
        { x = -773.64,y = 372.21,z = 87.88},
        { x = -296.33,y = -2225.83,z = 8.63},
        { x = 1241.17,y = -1924.67,z = 38.54,}
    }

    local randomSpawnPoint = spawnPoints[math.random(1, #spawnPoints)]


    local vehicleModel = GetHashKey("mule")
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(vehicleModel, randomSpawnPoint.x, randomSpawnPoint.y, randomSpawnPoint.z, 0.0, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetModelAsNoLongerNeeded(vehicleModel)


    SetNewWaypoint(randomSpawnPoint.x, randomSpawnPoint.y)
    lib.notify({
        title = 'Sukcess!',
        description = 'Udaj Się w To miejsce i Zbadaj Teren',
        type = 'success',
        iconAnimation = 'beat',
        position = 'top'
} )

    local pedSpawned = false

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = GetDistanceBetweenCoords(playerCoords, randomSpawnPoint.x, randomSpawnPoint.y, randomSpawnPoint.z, true)
            
            if distance < 80.0 and not pedSpawned then

                local aggressivePeds = {}
                local pedModels = { "g_m_y_famfor_01", "g_m_y_famca_01", "g_m_y_ballaorig_01" }

                for i = 1, math.random(4, 7) do
                    local pedModel = GetHashKey(pedModels[math.random(1, #pedModels)])
                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) do
                        Citizen.Wait(0)
                    end

                    local gdsggd = CreatePed(4, pedModel, randomSpawnPoint.x + math.random(-5, 5), randomSpawnPoint.y + math.random(-5, 5), randomSpawnPoint.z, 0.0, true, false)
                    GiveWeaponToPed(gdsggd, GetHashKey("WEAPON_PISTOL"), 100, false, true)
                    TaskCombatPed(gdsggd, playerPed, 0, 16)
                    SetPedSeeingRange(gdsggd, 50.0)
                    SetPedHearingRange(gdsggd, 50.0)
                    table.insert(aggressivePeds, gdsggd)
                end
                pedSpawned = true
            end

            if distance < 10.0 then

                if IsPedInVehicle(playerPed, vehicle, false) then

                    local garages = {
                        { x = 236.73,y = -3316.60,z = 5.79},
                        { x = 767.81,y = -3203.34,z = 5.90,},
                        { x = 953.36,y = -2176.70,z = 30.76}
                    }
                    local selectedGarage = garages[math.random(1, #garages)]
                    SetNewWaypoint(selectedGarage.x, selectedGarage.y)
                    lib.notify({
                        title = 'Sukcess!',
                        description = 'Lokalizacja Garażu Została Ustawiona Kieruj się w tamtą stronę',
                        type = 'success',
                        iconAnimation = 'beat',
                        position = 'top'
                } )


                    Citizen.CreateThread(function()
                        while true do
                            Citizen.Wait(0)
                            local playerCoords = GetEntityCoords(playerPed)
                            if GetDistanceBetweenCoords(playerCoords, selectedGarage.x, selectedGarage.y, selectedGarage.z, true) < 10.0 then
                                lib.notify({
                                    title = 'Sukcess!',
                                    description = 'Pojazd Dostarczony Oto twoja Zapłata',
                                    type = 'success',
                                    iconAnimation = 'beat',
                                    position = 'top'
                            } )
                                DeleteVehicle(vehicle)


                                TriggerServerEvent('ox_inventory:addItem', 'money', Config.Kasa)


                                for _, gdsggd in ipairs(aggressivePeds) do
                                    if DoesEntityExist(gdsggd) then
                                        DeleteEntity(gdsggd)
                                    end
                                end
                                break
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 167) then 
            if IsPlayerFIB() then
                TriggerEvent('vs_fibjob:openMissionMenu')
            else
                ESX.ShowNotification('Nie jesteś członkiem FIB!')
            end
        end
    end
end)





RegisterNetEvent('vs_fibjob:spawnVehicle', function(data)
    local model = data.model
    local playerPed = PlayerPedId()

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local spawnCoords = GenerateRandomVehicleSpawnCoords()
    local vehicle = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    SetModelAsNoLongerNeeded(model)

    currentVehicle = vehicle
    lib.notify({
        title = 'Sukces!',
        description = 'Twój pojazd został przyprowadzony!',
        type = 'success',
        iconAnimation = 'beat',
        position = 'top'
    })
end)

RegisterNetEvent('vs_fibjob:deleteVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(playerPed))

    if DoesEntityExist(vehicle) then
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(playerPed), vehicleCoords, true)

        if distance <= 5.0 then
            DeleteVehicle(vehicle)
            currentVehicle = nil
            lib.notify({
                title = 'Sukces!',
                description = 'Pojazd został zwrócony!',
                type = 'success',
                iconAnimation = 'beat',
                position = 'top'
            })
        end
    end
end)


function DeleteVehicle(vehicle)
    if not vehicle or vehicle == 0 then
        return
    end

    ESX.Game.DeleteVehicle(vehicle)
    currentVehicle = nil
end



function SaveCurrentOutfit()
    local playerPed = PlayerPedId()

    previousOutfit = {
        shirt = {
            componentId = 11,
            drawableId = GetPedDrawableVariation(playerPed, 11),
            textureId = GetPedTextureVariation(playerPed, 11)
        },
        pants = {
            componentId = 4,
            drawableId = GetPedDrawableVariation(playerPed, 4),
            textureId = GetPedTextureVariation(playerPed, 4)
        },
        shoes = {
            componentId = 6,
            drawableId = GetPedDrawableVariation(playerPed, 6),
            textureId = GetPedTextureVariation(playerPed, 6)
        },
        arms = {
            componentId = 3,
            drawableId = GetPedDrawableVariation(playerPed, 3),
            textureId = GetPedTextureVariation(playerPed, 3)
        },
        hat = {
            componentId = 0,
            drawableId = GetPedPropIndex(playerPed, 0),
            textureId = GetPedPropTextureIndex(playerPed, 0)
        },
        glasses = {
            componentId = 1,
            drawableId = GetPedPropIndex(playerPed, 1),
            textureId = GetPedPropTextureIndex(playerPed, 1)
        },
        accessories = {
            componentId = 7,
            drawableId = GetPedDrawableVariation(playerPed, 7),
            textureId = GetPedTextureVariation(playerPed, 7)
        }
    }
end

function ReturnToPreviousOutfit()
    if previousOutfit then
        local playerPed = PlayerPedId()
        local components = previousOutfit


        SetPedComponentVariation(playerPed, components.shirt.componentId, components.shirt.drawableId, components.shirt.textureId, 2)
        SetPedComponentVariation(playerPed, components.pants.componentId, components.pants.drawableId, components.pants.textureId, 2)
        SetPedComponentVariation(playerPed, components.shoes.componentId, components.shoes.drawableId, components.shoes.textureId, 2)
        SetPedComponentVariation(playerPed, components.arms.componentId, components.arms.drawableId, components.arms.textureId, 2)


        if components.hat then
            SetPedPropIndex(playerPed, components.hat.componentId, components.hat.drawableId, components.hat.textureId, true)
        end
        if components.glasses then
            SetPedPropIndex(playerPed, components.glasses.componentId, components.glasses.drawableId, components.glasses.textureId, true)
        end
        if components.accessories then
            SetPedComponentVariation(playerPed, components.accessories.componentId, components.accessories.drawableId, components.accessories.textureId, 2)
        end
    else
        lib.notify({
            title = 'Błąd!',
            description = 'Nie Zapisano Poprzedniego Stroju',
            type = 'error',
            iconAnimation = 'beat',
            position = 'top'
    } )
    
    end
end


for _, przebieralniazone in ipairs(Config.Przeb) do
    exports.ox_target:addSphereZone({
        coords = przebieralniazone.coords,
        radius = przebieralniazone.radius,
        debug = false,
        options = przebieralniazone.options
    })
end

exports.ox_target:addSphereZone({
    coords = vec3(Config.GarazX,Config.GarazY,Config.GarazZ),
    radius = Config.GarazR,
    debug = false,
    options = {
        {
            name = 'Garaz',
            icon = 'fa-solid fa-dove',
            label = 'Otwórz Garaż',
            event = 'vs_fibjob:openMenu',
            groups = {["fib"] = 0,},
            distance = 2,
        },
        {
            name = 'Garaz1',
            icon = 'fa-solid fa-dove',
            label = 'Odholuj Pojazd',
            event = 'vs_fibjob:deleteVehicle',
            groups = {["fib"] = 0,},
            distance = 2,
        },
    }
})


RegisterNetEvent('vs_menuciuchy')
AddEventHandler('vs_menuciuchy', function()
    OpenClothingMenu()
end)


function OpenClothingMenu()
    local outfitOptions = {}

    for _, outfit in ipairs(Config.Outfits) do
        table.insert(outfitOptions, {
            title = outfit.label,
            description = 'Wybierz ten strój',
            event = 'vs_fibjob:setOutfit',
            args = { components = outfit.components }
        })
    end

    lib.registerContext({
        id = 'clothing_main_menu',
        title = 'Przebieralnia',
        options = outfitOptions
    })

    lib.showContext('clothing_main_menu')
end


RegisterNetEvent('vs_fibjob:setOutfit')
AddEventHandler('vs_fibjob:setOutfit', function(data)
    local playerPed = PlayerPedId()
    local components = data.components


    SaveCurrentOutfit()


    SetPedComponentVariation(playerPed, components.shirt.componentId, components.shirt.drawableId, components.shirt.textureId, 2)
    SetPedComponentVariation(playerPed, components.pants.componentId, components.pants.drawableId, components.pants.textureId, 2)
    SetPedComponentVariation(playerPed, components.shoes.componentId, components.shoes.drawableId, components.shoes.textureId, 2)
    SetPedComponentVariation(playerPed, components.arms.componentId, components.arms.drawableId, components.arms.textureId, 2)


    if components.hat then
        SetPedPropIndex(playerPed, components.hat.componentId, components.hat.drawableId, components.hat.textureId, true)
    end
    if components.glasses then
        SetPedPropIndex(playerPed, components.glasses.componentId, components.glasses.drawableId, components.glasses.textureId, true)
    end
    if components.accessories then
        SetPedComponentVariation(playerPed, components.accessories.componentId, components.accessories.drawableId, components.accessories.textureId, 2)
    end
end)


RegisterNetEvent('vs_menuciuchypowrot')
AddEventHandler('vs_menuciuchypowrot', function()
    ReturnToPreviousOutfit()
end)


RegisterNetEvent('vs_fibjob:deleteVehicle')
AddEventHandler('vs_fibjob:deleteVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(playerPed))

    if DoesEntityExist(vehicle) then
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(playerPed), vehicleCoords, true)

        if distance <= 5.0 then
            DeleteVehicle(vehicle)
            lib.notify({
                title = 'Sukces!',
                description = 'Pojazd został zwrócony!',
                type = 'success',
                iconAnimation = 'beat',
                position = 'top'
            })
        end
    end
end)


function DeleteVehicle(vehicle)
    if not vehicle or vehicle == 0 then
        return
    end

    ESX.Game.DeleteVehicle(vehicle)
    currentVehicle = nil
end


RegisterNetEvent('vs_fibjob:openMenu')
AddEventHandler('vs_fibjob:openMenu', function()
    OpenGarageMenu()
end)


function OpenGarageMenu()
    local vehicleOptions = {}

    for _, vehicle in ipairs(Config.Vehicles) do
        table.insert(vehicleOptions, {
            title = vehicle.title,
            description = vehicle.description,
            icon = vehicle.icon,
            event = 'vs_fibjob:garazspawn',
            args = { model = vehicle.model }
        })
    end

    lib.registerContext({
        id = 'fib_garage_menu',
        title = 'Garaż FIB',
        options = vehicleOptions
    })

    lib.showContext('fib_garage_menu')
end


RegisterNetEvent('vs_fibjob:startMission', function(data)
    local missionId = data.missionId

    if missionId == 1 then
        StartMission1()

    end
end)


RegisterNetEvent('vs_fibjob:deleteVehicle')
AddEventHandler('vs_fibjob:deleteVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(playerPed))

    if DoesEntityExist(vehicle) then
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(playerPed), vehicleCoords, true)

        if distance <= 5.0 then
            DeleteVehicle(vehicle)
            lib.notify({
                title = 'Sukces!',
                description = 'Pojazd został zwrócony!',
                type = 'success',
                iconAnimation = 'beat',
                position = 'top'
            })
        end
    end
end)

RegisterNetEvent('vs_fibjob:garazspawn', function(data)
    local model = data.model
    local playerPed = PlayerPedId()

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local spawnPoint = Config.SpawnPoint
    local vehicle = CreateVehicle(model, spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z, spawnPoint.heading, true, false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    SetModelAsNoLongerNeeded(model)

    currentVehicle = vehicle 
end)

AddEventHandler('onResourceStart', function(cs_drugs)
    if GetCurrentResourceName() == cs_drugs then
        TriggerEvent('spawnMultiplePeds')
    end
end)

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

local function spawnPed(pedData)
    loadModel(pedData.model)
    local Garazped = CreatePed(4, pedData.model, pedData.coords.x, pedData.coords.y, pedData.coords.z, pedData.heading, false, true)
    SetEntityAsMissionEntity(Garazped, true, true)
    SetEntityInvincible(Garazped, true)
    FreezeEntityPosition(Garazped, true)

    if pedData.scenario then
        TaskStartScenarioInPlace(Garazped, pedData.scenario, 0, true)
    end
end

local function spawnPeds()
    for _, pedData in ipairs(Config.Peds) do
        spawnPed(pedData)
    end
end

RegisterNetEvent('spawnMultiplePeds')
AddEventHandler('spawnMultiplePeds', spawnPeds)




RegisterNetEvent('vs_fibjob:storagecompany')
AddEventHandler('vs_fibjob:storagecompany', function()
    exports.ox_inventory:openInventory('stash', 'society_fib')
end)

RegisterNetEvent('vs_fibjob:storagepriv')
AddEventHandler('vs_fibjob:storagepriv', function()
    exports.ox_inventory:openInventory('stash', {id='szafkafib'})
end)

Citizen.CreateThread(function()
    for _, szafkaConfig in ipairs(Config.Szafki) do
        exports.ox_target:addSphereZone({
            coords = szafkaConfig.coords,
            radius = szafkaConfig.radius,
            debug = false,
            options = szafkaConfig.options
        })
    end
end)