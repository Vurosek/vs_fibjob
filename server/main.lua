ESX = exports["es_extended"]:getSharedObject()
RegisterServerEvent('ox_inventory:addItem')
AddEventHandler('ox_inventory:addItem', function(item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        exports.ox_inventory:AddItem(source, item, amount)
    end
end)

local GetCurrentResourceName = GetCurrentResourceName()
local ox_inventory = exports.ox_inventory

local stashes = {
    {
        id = 'szafkafib',
        label = Config.SzafkaPrivLabel,
        slots = Config.SzafkaPrivSlots,
        weight = Config.SzafkaPrivWeight,
        owner = true,
    },
}

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
        for i=1, #stashes do
            local stash = stashes[i]
            ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner, stash.jobs)
        end
    end
end)