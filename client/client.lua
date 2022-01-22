ESX = exports["es_extended"]:getSharedObject()

local stormactive = nil 
local timeractive = true

RegisterNetEvent("kimstorm:stoptimestorm")
AddEventHandler("kimstorm:stoptimestorm", function()
    timeractive = false
end)

RegisterNetEvent("kimstorm:cancelstorm")
AddEventHandler("kimstorm:cancelstorm", function()
    stormactive = false
end)

RegisterNetEvent("kimstorm:resumetimestorm")
AddEventHandler("kimstorm:resumetimestorm", function()
    timeractive = true
end)

RegisterNetEvent("kimstorm:runstorm")
AddEventHandler("kimstorm:runstorm", function(x, y, z, size, time)
    stormactive = true
    size = size
    sizefinal = 0
    sizecalc = size
    time = time --0.0001
    if time >= 10 then
        time = "0.00" .. time
    else
        time = "0.000" .. time
    end
    Citizen.CreateThread(function()
        while true do
            if stormactive then
                s = 1000
                if timeractive then
                    sizecalc = sizecalc - sizecalc*time
                    s = 1
                    if sizecalc <= 0.5 then
                        stormactive = false
                        break;
                    end
                end
                Wait(s)
            else
                break;
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            if stormactive then
                s = 1
                if sizecalc <= 0.5 then
                    break;
                end 
                v = coords
                DrawMarker(1, x + 0.1, y + 0.1, z - 100.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, sizecalc, sizecalc, 20000.0, Config.ColorStormRed, Config.ColorStormGreen, Config.ColorStormBlue, Config.ColorStormAlpha, false, true, 2, nil, nil, false)
                Wait(s)
            else    
                break;
            end
        end
    end)

    Citizen.CreateThread(function()
        local outstorm = nil
        local instorm = nil
        while true do
            s = 1000
            if stormactive then
                clcplayer = sizecalc - sizecalc*0.495
                if #(GetEntityCoords(PlayerPedId()) - vec3(x + 0.1, y + 0.1, z + 0.1)) < clcplayer then
                    if instorm ~= true then
                        instorm = true
                        ESX.ShowNotification(_U("storm_leave"))
                    end
                else
                    if instorm ~= false then
                        instorm = false
                        ESX.ShowNotification(_U("storm_inside"))
                    end

                    local Ped = PlayerPedId()
                    local health = GetEntityHealth(Ped)
                    SetEntityHealth(Ped, health - Config.StormDamage)
                end
            else
                break;
            end
            Wait(s)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            s = 1000
            if stormactive then
                clcplayer = sizecalc - sizecalc*0.495
                if #(GetEntityCoords(PlayerPedId()) - vec3(x + 0.1, y + 0.1, z + 0.1)) < clcplayer then

                else
                    s = 1
                    DrawRect(0.5, 0.475, 1.1, 1.1, Config.ColorInsideStormRed, Config.ColorInsideStormGreen, Config.ColorInsideStormBlue, Config.ColorInsideStormAlpha)
                end
            else
                break;
            end
            Wait(s)
        end
    end)
end)

TriggerEvent("chat:addSuggestion", "/runstorm", ("Start an existing storm"), {})
TriggerEvent("chat:addSuggestion", "/resumestorm", ("Resume the storm"), {})
TriggerEvent("chat:addSuggestion", "/stopstorm", ("Stop the storm"), {})
TriggerEvent("chat:addSuggestion", "/cancelstorm", ("Cancel the storm"), {})
TriggerEvent("chat:addSuggestion", "/createstorm", ("Set gang user"), {{name = ("Name"), help = ("Storm Name")}, {name = ("Size"), help = ("Size of the storm")}, {name = ("Time"), help = ("Time of the storm")}})

print("Script started successfully")