ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("stopstorm", function(source, args, rawCommand)
    TriggerClientEvent("kimstorm:stoptimestorm", -1)
end)

RegisterCommand("cancelstorm", function(source, args, rawCommand)
    TriggerClientEvent("kimstorm:cancelstorm", -1)
end)

RegisterCommand("resumestorm", function(source, args, rawCommand)
    TriggerClientEvent("kimstorm:resumetimestorm", -1)
end)

RegisterCommand("createstorm", function(source, args, rawCommand)
    if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
        local xPlayer = ESX.GetPlayerFromId(source)
        storm = tostring(args[1])
        coords = xPlayer.getCoords(true)
        local x, y, z = table.unpack(coords)
        size = args[2]
        time = args[3]

        MySQL.Async.execute('INSERT INTO kim_storm (storm, x, y, z, size, time) VALUES (@storm, @x, @y, @z, @size, @time)',
        { ['storm'] = storm, ['x'] = x, ['y'] = y, ['z'] = z, ['size'] = size, ['time'] = time },
        function(affectedRows)
            TriggerClientEvent("esx:showNotification", source, "~w~" .. _U("storm_created") .. "~g~ " .. storm)
        end
        )
    else
        TriggerClientEvent("esx:showNotification", source, "~r~" .. _U("storm_notcreated") .. "~g~")
    end

end, false)

RegisterCommand("runstorm", function(source, args, rawCommand)
    storm = tostring(args[1])
    MySQL.Async.fetchAll(
        'SELECT * FROM kim_storm WHERE storm = @storm',{['@storm'] = storm},
        function(result)
        if result[1] then
            data = result[1]
            print(data.x)
            TriggerClientEvent("kimstorm:runstorm", -1, data.x, data.y, data.z, data.size, data.time)
        else
            TriggerClientEvent("esx:showNotification", source, "~r~" .. _U("storm_notfound"))

        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		function VersionCheck(error, latestVersion, headers)
			local currentVersion = Config.Version           
			if tonumber(currentVersion) < tonumber(latestVersion) then
				print("\n" .. GetCurrentResourceName() .. " ^8is outdated.\nCurrent version: ^8" .. currentVersion .. "\nAvailable version: ^2" .. latestVersion .. "\n^3Update^6: https://github.com/quimalborch/kim-storm\n^0")
			elseif tonumber(currentVersion) > tonumber(latestVersion) then
				print(GetCurrentResourceName() .. " is superior to ^2" .. latestVersion .. "Are you in a version above the official one?^0")
			else
				print(GetCurrentResourceName() .. " is updated.^0")
			end
		end
	
		PerformHttpRequest("https://raw.githubusercontent.com/quimalborch/versionsfivem/main/kimstorm", VersionCheck, "GET")
	end
end)

print("Script started successfully")