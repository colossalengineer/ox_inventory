if not lib then return end

local Inventory = require 'modules.inventory.server'

lib.callback.register('ox_inventory:equip', function(source, slot, eupData)

    eupData.metadata.equipped = true

    Inventory.SetMetadata(source, slot, eupData.metadata)

    return true
end)

lib.callback.register('ox_inventory:unEquip', function(source, slot, eupData)

    eupData.metadata.equipped = false

    Inventory.SetMetadata(source, slot, eupData.metadata)

    return true
end)