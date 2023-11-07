if not lib then return end

lib.callback.register('ox_inventory:equip', function(source, slot, eupData)

    eupData.metadata.eup = true

    ox_inventory:SetMetadata(source, slot, eupData.metadata)

end)

lib.callback.register('ox_inventory:unEquip', function(source, slot, eupData)

    eupData.metadata.eup = false

    ox_inventory:SetMetadata(source, slot, eupData.metadata)

end)