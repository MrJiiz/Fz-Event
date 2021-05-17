FZ                              = nil
local HasAlreadyEnteredMarker   = false
local GUI                       = {}
local LastPart                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local Fz                        = {}
local DakheleEvent              = false
GUI.Time                        = 0

Citizen.CreateThread(function()
    while FZ == nil do
        TriggerEvent('esx:getSharedObject', function(obj) FZ = obj end)
        Citizen.Wait(0)
    end
end)


RegisterNetEvent('br_events:sync')
AddEventHandler('br_events:sync', function()
    FZ.TriggerServerCallback('br_events:getData', function(data)
        if data ~= nil then
            Fz.tp            = json.decode(data.tp)
            Fz.status        = json.decode(data.status)
            Fz.vest          = data.vest
            Fz.car1          = data.car1
            Fz.car1_plate    = data.car1_plate
            Fz.car1_fuel     = data.car1_fuel
            Fz.car1_marker   = json.decode(data.car1_marker)
            Fz.car2          = data.car2
            Fz.car2_plate    = data.car2_plate
            Fz.car2_fuel     = data.car2_fuel
            Fz.car2_marker   = json.decode(data.car2_marker)
            Fz.car_spawn     = json.decode(data.car_spawn)
            Fz.gun1          = data.gun1
            Fz.gun1_ammo     = data.gun1_ammo
            Fz.gun1_marker   = json.decode(data.gun1_marker)
            Fz.gun2          = data.gun2
            Fz.gun2_ammo     = data.gun2_ammo
            Fz.gun2_marker   = json.decode(data.gun2_marker)
            Fz.skin1_male    = json.decode(data.skin1_male)
            Fz.skin1_female  = json.decode(data.skin1_female)
            Fz.skin1_marker  = json.decode(data.skin1_marker)
            Fz.skin2_male    = json.decode(data.skin2_male)
            Fz.skin2_female  = json.decode(data.skin2_female)
            Fz.skin2_marker  = json.decode(data.skin2_marker)
        end
    end)
end)

RegisterCommand('event', function(source, args)
    local playerPed = GetPlayerPed(-1)
    local coords   = GetEntityCoords(playerPed)
    local inParking  = GetDistanceBetweenCoords(coords, 225.55, -786.38, 30.73, true) < 50
    TriggerEvent('br_events:sync')
    if Fz.status == 1 then
        if inParking then
            DakheleEvent = true

            SetCanPedEquipAllWeapons(playerPed, false)
            if Fz.gun1 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(Fz.gun1), true)
            end
            if Fz.gun2 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(Fz.gun2), true)
            end
            SetCanPedSelectWeapon(playerPed, 0xA2719263, true)

            RequestCollisionAtCoord(Fz.tp.x, Fz.tp.y, Fz.tp.z)
            while not HasCollisionLoadedAroundEntity(playerPed) do
                RequestCollisionAtCoord(Fz.tp.x, Fz.tp.y, Fz.tp.z)
                Citizen.Wait(1)
            end
            SetEntityCoords(playerPed, Fz.tp.x, Fz.tp.y, Fz.tp.z)
                    
            TriggerEvent('esx_basicneeds:healPlayer', source)
            SetPedArmour(playerPed, Fz.vest)

            TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Vared Event Shodid, Heal Shoma Poor Va Armor Shoma Bar Asas Event Set Shod Ke Dar Makan Haye Moshakhash Shode Mitonid Mashin, Aslahe Va Lebas Khod Ra Taghir Dahid")
        else
            TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Baraye Voroud Be Event Bayad Dakhele Mohavate Parking Markazi Bashid")
        end
    else
        TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Event Baste Shode Ya Sakhte Nashode Ast")
    end
end, false)

RegisterCommand('exitevent', function(source, args, user)
    local playerPed = GetPlayerPed(-1)
    local coords   = GetEntityCoords(playerPed)
    
    DakheleEvent = false

    if HasPedGotWeapon(playerPed, GetHashKey(Fz.gun1), false) then
        RemoveWeaponFromPed(playerPed, GetHashKey(Fz.gun1))
    end
    if HasPedGotWeapon(playerPed, GetHashKey(Fz.gun2), false) then
        RemoveWeaponFromPed(playerPed, GetHashKey(Fz.gun2))
    end

    TriggerEvent("esx_ambulancejob:reviveJLkiramdahansoheil", source)

    Wait(2000)
    RequestCollisionAtCoord(225.55, -786.38, 30.73)
    while not HasCollisionLoadedAroundEntity(playerPed) do
        RequestCollisionAtCoord(225.55, -786.38, 30.73)
        Citizen.Wait(1)
    end
    SetEntityCoords(playerPed, 225.55, -786.38, 30.73)
	FZ.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
        TriggerEvent("skinchanger:loadSkin", skin)
    end)
end, false)

TriggerEvent('chat:addSuggestion', '/event', 'Vared Shodan Be Event', {})
TriggerEvent('chat:addSuggestion', '/exitevent', 'Khoroj Az Event', {})

function OpenCarMenu(station)
    local elements = {}

    if Fz.car1 ~= nil then
        local aheadVehName1 = GetDisplayNameFromVehicleModel(Fz.car1)
        local vehicleName1  = GetLabelText(aheadVehName1) 
		table.insert(elements, {label = 'Daryaft ' .. vehicleName1 , value = 'get_veh1'})
	end
    if Fz.car2 ~= nil then
        local aheadVehName2 = GetDisplayNameFromVehicleModel(Fz.car2)
        local vehicleName2  = GetLabelText(aheadVehName2) 
		table.insert(elements, {label = 'Daryaft ' .. vehicleName2 , value = 'get_veh2'})
	end
  
    FZ.UI.Menu.CloseAll()

    FZ.UI.Menu.Open('default', GetCurrentResourceName(), 'veh', {
        title    = _U('get_car'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)

    if data.current.value == "get_veh1" then
        menu.close()
        if Fz.car1 ~= nil then
            if Fz.car_spawn ~= nil then
                SpawnVasileNaghlie(Fz.car1, Fz.car1_plate, Fz.car1_fuel)
            else
                FZ.ShowJLNotification('Mahali Baraye Spawn VasileNaghlie Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            FZ.ShowJLNotification('VasileNaghlie Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
	elseif data.current.value == "get_veh2" then
        menu.close()
        if Fz.car2 ~= nil then
            if Fz.car_spawn ~= nil then
                SpawnVasileNaghlie(Fz.car2, Fz.car2_plate, Fz.car2_fuel)
            else
                FZ.ShowJLNotification('Mahali Baraye Spawn VasileNaghlie Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            FZ.ShowJLNotification('VasileNaghlie Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
	end

    end, function(data, menu)

    menu.close()

    CurrentAction     = 'menu_car'
    CurrentActionMsg  = _U('open_car')
    end)
end

function SetVehicleMaxMods(vehicle, plate, window, colors)
    local plate = string.gsub(plate, "-", "")
    local props

    if colors then
        props = {
            modEngine = 3,
            modFzakes = 2,
            windowTint = window,
            modArmor = 4,
            modTransmission = 2,
            modSuspension = -1,
            modTurbo = true,
            plate = plate,
            color1 = colors.a,
            color2 = colors.b
        }
    else
        props = {
            modEngine = 3,
            modFzakes = 2,
            windowTint = window,
            modArmor = 4,
            modTransmission = 2,
            modSuspension = -1,
            modTurbo = true,
            plate = plate
        }
    end

    FZ.Game.SetVehicleProperties(vehicle, props)
    SetVehicleDirtLevel(vehicle, 0.0)
end

function SpawnVasileNaghlie(vehicle, plate, fuel)
    local nazdik = GetClosestVehicle(Fz.car_spawn.x,  Fz.car_spawn.y,  Fz.car_spawn.z,  3.0,  0,  71)
    if not DoesEntityExist(nazdik) then
        FZ.Game.SpawnVehicle(vehicle, {
            x = Fz.car_spawn.x+math.random(-10.0, 20.0),
            y = Fz.car_spawn.y+math.random(10.0, 20.0),
            z = Fz.car_spawn.z + 1
        }, Fz.car_spawn.h, function(callback_vehicle)
        SetVehicleMaxMods(callback_vehicle, plate, 1)
        SetVehRadioStation(callback_vehicle, "OFF")
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        Wait(2800)
        SetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()), tonumber(fuel)+0.0)
        end)
    else
        FZ.ShowJLNotification('Sabr Konid Ta Mahale Spawn Khali Shavad')
    end
end

function OpenGunMenu(type)
	local elements = {}

    if Fz.gun1 ~= nil then
		table.insert(elements, {label = 'Daryaft ' .. FZ.GetWeaponLabel(Fz.gun1), value = 'get_gun1'})
	end
    if Fz.gun2 ~= nil then
		table.insert(elements, {label = 'Daryaft ' .. FZ.GetWeaponLabel(Fz.gun2), value = 'get_gun2'})
	end

    FZ.UI.Menu.CloseAll()

    FZ.UI.Menu.Open('default', GetCurrentResourceName(), 'get_gun', {
        title    = _U('get_gun'),
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
  
    if data.current.value == "get_gun1" then
        menu.close()
        if Fz.gun1 ~= nil then
            if Fz.gun1_ammo ~= nil then
                GiveWeaponToPed(PlayerPedId(), GetHashKey(Fz.gun1), Fz.gun1_ammo, false, true)
            else
                FZ.ShowJLNotification('Tedad Tir Aslahe Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            FZ.ShowJLNotification('Aslaheii Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
    elseif data.current.value == "get_gun2" then
        menu.close()
        if Fz.gun2 ~= nil then
            if Fz.gun2_ammo ~= nil then
                GiveWeaponToPed(PlayerPedId(), GetHashKey(Fz.gun2), Fz.gun2_ammo, false, true)
            else
                FZ.ShowJLNotification('Tedad Tir Aslahe Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            FZ.ShowJLNotification('Aslaheii Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
    end

    end, function(data, menu)

    menu.close()

    CurrentAction     = 'menu_gun'
    CurrentActionMsg  = _U('open_gun')
    end)
end


function OpenSkinMenu()

    local elements = {
        {label = _U('citizen_wear'), value = 'citizen_wear'},
    }

    if Fz.skin1_marker ~= nil then
		table.insert(elements, {label = 'Daryaft Lebas Team Aval' , value = 'get_skin1'})
	end
    if Fz.skin2_marker ~= nil then
		table.insert(elements, {label = 'Daryaft Lebas Team Dovom', value = 'get_skin2'})
	end
  
    FZ.UI.Menu.CloseAll()
  
    FZ.UI.Menu.Open('default', GetCurrentResourceName(), 'get_skin', {
        title    = _U('get_skin'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)
    
        menu.close()

        if data.current.value == 'citizen_wear' then
            FZ.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
        elseif data.current.value == 'get_skin1' then
            TriggerEvent("skinchanger:getSkin", function(skin)
                if skin.sex == 0 then
                    if Fz.skin1_male ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Fz.skin1_male)
                    else
                        FZ.ShowJLNotification(_U("no_outfit"))
                    end
                else
                    if Fz.skin1_female ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Fz.skin1_female)
                    else
                        FZ.ShowJLNotification(_U("no_outfit"))
                    end
                end
            end)
        elseif data.current.value == 'get_skin2' then
            TriggerEvent("skinchanger:getSkin", function(skin)
                if skin.sex == 0 then
                    if Fz.skin2_male ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Fz.skin2_male)
                    else
                        FZ.ShowJLNotification(_U("no_outfit"))
                    end
                else
                    if Fz.skin2_female ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, Fz.skin2_female)
                    else
                        FZ.ShowJLNotification(_U("no_outfit"))
                    end
                end
            end)
        end
  
        end, function(data, menu)
  
        menu.close()
  
        CurrentAction     = 'menu_skin'
        CurrentActionMsg  = _U('open_skin')
    end)
end

-- Sakht Marker
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)
        if Fz.status == 1 then
            if Fz.car1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.car1_marker.x,  Fz.car1_marker.y,  Fz.car1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.CarMarkerType, Fz.car1_marker.x,  Fz.car1_marker.y,  Fz.car1_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CarMarkerSize.x, Config.CarMarkerSize.y, Config.CarMarkerSize.z, Config.CarMarkerColor.r, Config.CarMarkerColor.g, Config.CarMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            if Fz.car2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.car2_marker.x,  Fz.car2_marker.y,  Fz.car2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.CarMarkerType, Fz.car2_marker.x,  Fz.car2_marker.y,  Fz.car2_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CarMarkerSize.x, Config.CarMarkerSize.y, Config.CarMarkerSize.z, Config.CarMarkerColor.r, Config.CarMarkerColor.g, Config.CarMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            
            if Fz.gun1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.gun1_marker.x,  Fz.gun1_marker.y,  Fz.gun1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.GunMarkerType, Fz.gun1_marker.x,  Fz.gun1_marker.y,  Fz.gun1_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.GunMarkerSize.x, Config.GunMarkerSize.y, Config.GunMarkerSize.z, Config.GunMarkerColor.r, Config.GunMarkerColor.g, Config.GunMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            if Fz.gun2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.gun2_marker.x,  Fz.gun2_marker.y,  Fz.gun2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.GunMarkerType, Fz.gun2_marker.x,  Fz.gun2_marker.y,  Fz.gun2_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.GunMarkerSize.x, Config.GunMarkerSize.y, Config.GunMarkerSize.z, Config.GunMarkerColor.r, Config.GunMarkerColor.g, Config.GunMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            
            if Fz.skin1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.skin1_marker.x,  Fz.skin1_marker.y,  Fz.skin1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.SkinMarkerType, Fz.skin1_marker.x,  Fz.skin1_marker.y,  Fz.skin1_marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.SkinMarkerSize.x, Config.SkinMarkerSize.y, Config.SkinMarkerSize.z, Config.SkinMarkerColor.r, Config.SkinMarkerColor.g, Config.SkinMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            if Fz.skin2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.skin2_marker.x,  Fz.skin2_marker.y,  Fz.skin2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.SkinMarkerType, Fz.skin2_marker.x,  Fz.skin2_marker.y,  Fz.skin2_marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.SkinMarkerSize.x, Config.SkinMarkerSize.y, Config.SkinMarkerSize.z, Config.SkinMarkerColor.r, Config.SkinMarkerColor.g, Config.SkinMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
        end
    end
end)
    
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        local playerPed      = GetPlayerPed(-1)
        local coords         = GetEntityCoords(playerPed)
        local isInMarker     = false
        local currentPart    = nil
        
        if Fz.status == 1 then
            if Fz.car1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.car1_marker.x,  Fz.car1_marker.y,  Fz.car1_marker.z,  true) < Config.CarMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Car'
                end
            end
            if Fz.car2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.car2_marker.x,  Fz.car2_marker.y,  Fz.car2_marker.z,  true) < Config.CarMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Car'
                end
            end
            
            if Fz.gun1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.gun1_marker.x,  Fz.gun1_marker.y,  Fz.gun1_marker.z,  true) < Config.GunMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Gun'
                end
            end
            if Fz.gun2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.gun2_marker.x,  Fz.gun2_marker.y,  Fz.gun2_marker.z,  true) < Config.GunMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Gun'
                end
            end
            
            if Fz.skin1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.skin1_marker.x,  Fz.skin1_marker.y,  Fz.skin1_marker.z,  true) < Config.SkinMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Skin'
                end
            end
            if Fz.skin2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  Fz.skin2_marker.x,  Fz.skin2_marker.y,  Fz.skin2_marker.z,  true) < Config.SkinMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Skin'
                end
            end
            
            local hasExited = false
                
            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastPart ~= currentPart)) then
                if (LastPart ~= nil) and (LastPart ~= currentPart) then
                    TriggerEvent('br_events:hasExitedMarker', LastPart)
                    hasExited = true
                end
                HasAlreadyEnteredMarker = true
                LastPart                = currentPart
            
                TriggerEvent('br_events:hasEnteredMarker', currentPart)
            end
            
            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
            
                HasAlreadyEnteredMarker = false
            
                TriggerEvent('br_events:hasExitedMarker', LastPart)
            end
        end
    end
end)

AddEventHandler('br_events:hasEnteredMarker', function(part)
    if part == 'Car' then
        CurrentAction     = 'menu_car'
        CurrentActionMsg  = _U('open_car')
    end
        
    if part == 'Gun' then
        CurrentAction     = 'menu_gun'
        CurrentActionMsg  = _U('open_gun')
    end
        
    if part == 'Skin' then
        CurrentAction     = 'menu_skin'
        CurrentActionMsg  = _U('open_skin')
    end  
end)
        
AddEventHandler('br_events:hasExitedMarker', function(part)
    FZ.UI.Menu.CloseAll()
    CurrentAction = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        
            if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 150 then
                if CurrentAction == 'menu_car' then
                    OpenCarMenu()
                elseif CurrentAction == 'menu_gun' then
                    OpenGunMenu()
                elseif CurrentAction == 'menu_skin' then
                    OpenSkinMenu()
                end
                CurrentAction = nil
                GUI.Time      = GetGameTimer()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if DakheleEvent then
            SetCanPedEquipAllWeapons(PlayerPedId(), false)
            if Fz.gun1 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(Fz.gun1), true)
            end
            if Fz.gun2 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(Fz.gun2), true)
            end
            SetCanPedSelectWeapon(PlayerPedId(), 0xA2719263, true)
        else
            SetCanPedEquipAllWeapons(PlayerPedId(), true)
        end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DakheleEvent then
            DisableControlAction(2, 166, true)
            DisableControlAction(2, 167, true)
        else
            Citizen.Wait(5000)
        end
    end
end)