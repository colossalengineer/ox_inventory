local playerDropped = ...
local Inventory = require 'modules.inventory.server'

AddEventHandler("CR:InventoryBridge:Dropped", playerDropped)

local snailyEnabled = GetConvarInt("crToolkit:SnailyCAD", 0)

local setupInventories = function()
	for _, player in pairs(GlobalState.PlayerLocations) do
        player.identifier = source
        if snailyEnabled then
            local civilian = Player(source).state.civ
            if civilian then
                player.identifier = civilian.id
                player.dateofbirth = civilian.dateOfBirth
                player.name = ("%s %s"):format(civilian.name, civilian.surname)
                --player.sex = Player(source).state.civ.genderId
                goto skip
            end
        end
        player.identifier = GetPlayerIdentifierByType(source, 'license2') or GetPlayerIdentifierByType(source, 'license')
        player.name = GetPlayerName(source)
        server.setPlayerInventory(player)
        --Inventory.SetItem(character.source, "money", character.cash)
        ::skip::
	end
end

SetTimeout(500, function()
	setupInventories()
end)

RegisterNetEvent("CR:InventoryBridge:Spawned", function(source)
    local player = {}
    player.identifier = source
    if snailyEnabled then
        local civilian = Player(source).state.civ
        if civilian then
            player.identifier = civilian.id
            player.dateofbirth = civilian.dateOfBirth
            player.name = ("%s %s"):format(civilian.name, civilian.surname)
            --player.sex = Player(source).state.civ.genderId
            return
        end
    end
    player.identifier = GetPlayerIdentifierByType(source, 'license2') or GetPlayerIdentifierByType(source, 'license')
    player.name = GetPlayerName(source)
    server.setPlayerInventory(player)
    --Inventory.SetItem(character.source, "money", character.cash)
end)

RegisterNetEvent("CR:Bridge:MoneyUpdate", function(player, account, amount, changeType)
    if account ~= "cash" then return end
    local item = Inventory.GetItem(player, "money", nil, true)
    Inventory.SetItem(player, "money", changeType == "set" and amount or changeType == "remove" and item - amount or changeType == "add" and item + amount)
end)