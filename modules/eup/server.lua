if not lib then return end

lib.callback.register('ox_inventory:equip', function(source, slot, eupData)

    eupData.metadata.eup = true

    Inventory.SetMetadata(source, slot, eupData.metadata)

end)

lib.callback.register('ox_inventory:unEquip', function(source, slot, eupData)

    eupData.metadata.eup = false

    Inventory.SetMetadata(source, slot, eupData.metadata)

end)