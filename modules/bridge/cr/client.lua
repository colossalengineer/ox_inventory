--[[diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)

end--]]

-- Temporary, this should be replaced with more effective code

RegisterNetEvent('ProjectHyde:Global:Client:PlayerSpawned')
AddEventHandler('ProjectHyde:Global:Client:PlayerSpawned', function()
    TriggerServerEvent("CR:InventoryBridge:Spawned", GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('PHSpawn:Client:Events:Spawn')
AddEventHandler('PHSpawn:Client:Events:Spawn', function()
  TriggerServerEvent("CR:InventoryBridge:RemoveInv", GetPlayerServerId(PlayerId()))
end)

local usingDiscord = GetConvarInt('crToolkit:Discord', 0)

---@diagnostic disable-next-line: duplicate-set-field
function client.hasGroup(group)
    if not PlayerData.loaded then return end

	if usingDiscord then
		if type(group) == 'table' then
			for name, rank in pairs(group) do
				if exports['crToolkit']:DISCORDCheckMembership(name) then
                	return name, rank
               	end
           	end
        	return false
		else
			return exports['crToolkit']:DISCORDCheckMembership(group) or false
		end
	end

	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = PlayerData.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = PlayerData.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end