local playerDropped = ...
local Inventory = require 'modules.inventory.server'

AddEventHandler("CR:InventoryBridge:Dropped", playerDropped)

local snailyEnabled = GetConvarInt("crToolkit:SnailyCAD", 0)

local setupInventories = function()
	for _, player in pairs(GlobalState.PlayerLocations) do
        player.source = player.player
        if snailyEnabled then
            local civilian = Player(player.source).state.civ or false
            if civilian then
                player.identifier = civilian.id
                player.dateofbirth = civilian.dateOfBirth
                player.name = ("%s %s"):format(civilian.name, civilian.surname)
                --player.sex = Player(source).state.civ.genderId
                server.setPlayerInventory(player)
                goto skip
            end
        end
        player.identifier = GetPlayerIdentifierByType(player.source, 'license2') or GetPlayerIdentifierByType(player.source, 'license')
        player.name = GetPlayerName(player.source)
        server.setPlayerInventory(player)
        --Inventory.SetItem(character.source, "money", character.cash)
        ::skip::
	end
end

SetTimeout(500, function()
	setupInventories()
end)

local usingDiscord = GetConvarInt('crToolkit:Discord', 0)
local CheckTableFull = function(table, value)
        for _, v in ipairs(table) do
            if v == value then
                return true
            end
        end
        return false
    end
---@diagnostic disable-next-line: duplicate-set-field
function server.hasGroup(inv, group)
    if usingDiscord then
        local roles = Player(inv.player.source).state.roles or false
		if type(group) == 'table' then
			for name, rank in pairs(group) do
                if roles and CheckTableFull(roles, name) then
                    return name, rank
                end
           	end
        end
        if CheckTableFull(roles, group) then
            return group, 0
        end
	end
	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = inv.player.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = inv.player.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

RegisterNetEvent("CR:InventoryBridge:Spawned", function(source)
    local player = {}
    player.source = source
    if snailyEnabled then
        local civilian = Player(source).state.civ or false
        if civilian then
            player.identifier = civilian.id
            player.dateofbirth = civilian.dateOfBirth
            player.name = ("%s %s"):format(civilian.name, civilian.surname)
            --player.sex = Player(source).state.civ.genderId
            server.setPlayerInventory(player)
            return
        end
    end
    player.identifier = GetPlayerIdentifierByType(source, 'license2') or GetPlayerIdentifierByType(source, 'license')
    player.name = GetPlayerName(source)
    server.setPlayerInventory(player)
    --Inventory.SetItem(character.source, "money", character.cash)
end)

RegisterNetEvent("CR:InventoryBridge:RemoveInv", function(source)
    if Inventory(source) then
	    Inventory.Remove(Inventory(source))
    end
end)

RegisterNetEvent("CR:Bridge:MoneyUpdate", function(player, account, amount, changeType)
    if account ~= "cash" then return end
    local item = Inventory.GetItem(player, "money", nil, true)
    Inventory.SetItem(player, "money", changeType == "set" and amount or changeType == "remove" and item - amount or changeType == "add" and item + amount)
end)