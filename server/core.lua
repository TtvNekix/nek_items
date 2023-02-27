CreateThread(function()
    local items = {}
    MySQL.query('SELECT * from items', {}, function(result)
        for i=1, #result do
            table.insert(items, result[i].name)
        end
        
        for k, v in pairs(Config['Items']) do
            local exist = false
            for i=1, #items do
                if tostring(items[i]) == tostring(v.itemName) then
                    exist = true
                end
            end
            if not exist then
                MySQL.query('INSERT INTO items (name, label, weight) VALUES (@name, @label, @weight)', 
                    {
                        ['@name'] = v.itemName,
                        ['@label'] = v.itemLabel,
                        ['@weight'] = v.weight
                    }, 
                function(result)
                    if result then
                        print("Object added ^2succesfully^0. Object added: \n[\nName: ^4"..v.itemName.."^0\nLabel: ^4"..v.itemLabel.."^0\nWeight: "..v.weight.."\n^0]")
                    end
                end)
            end
            MySQL.query('SELECT * FROM items', {}, function(result)
                for i=1, #result do
                    ESX.Items[result[i].name] = {label = result[i].label, weight = result[i].weight, rare = result[i].rare, canRemove = result[i].can_remove}
                end
            end)
        end 
    end)
end)

CreateThread(function()
    for k, v in pairs(Config['Items']) do
        ESX.RegisterUsableItem(v.itemName, function(src)
            TriggerClientEvent("sendItem", src, v.objName, v.posX, v.posY, v.posZ, v.rotX, v.rotY, v.rotZ, v.anim, v.bone)
        end)
    end
end)

RegisterNetEvent('deleteItem', function(item, value)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local val = value or 1

    xPlayer.removeInventoryItem(item, val)
end)