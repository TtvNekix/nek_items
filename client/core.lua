hasItemInHand = false
items = {}
animPlayed = false
n = 0

RegisterNetEvent('sendItem', function(item, posX, posY, posZ, rotX, rotY, rotZ, anim, bone)
    print(item, anim)
    if not HasModelLoaded(item) then
        RequestModel(item)
        while not HasModelLoaded(item) do
            Citizen.Wait(0)
        end
    end

    if anim then
        print(item)
        if not HasAnimDictLoaded(anim) then
            RequestAnimDict(anim) 
            while not HasAnimDictLoaded(anim) do
                Citizen.Wait(0)
            end
        end
    end

    if not hasItemInHand then
        hasItemInHand = true
        createObject(item, posX, posY, posZ, rotX, rotY, rotZ, anim, bone)
    elseif hasItemInHand and item == items[n].itemName then
        DeleteObject(items[n].id)
        ClearPedTasks(PlayerPedId())
        n = n + 1
        hasItemInHand = false
    elseif hasItemInHand and item ~= items[n].itemName then
        DeleteObject(items[n].id)
        n = n + 1
        createObject(item, posX, posY, posZ, rotX, rotY, rotZ, anim, bone)
    end
end)

RegisterNetEvent('clearHandItem', function()
    if hasItemInHand then
        if DoesEntityExist(items[n].id) then
            DeleteObject(items[n].id)
        end
        if IsEntityPlayingAnim(PlayerPedId(), animPlayed, "idle", 3) then
            ClearPedTasks(PlayerPedId())
        end
    end
end)

function checkItem()
    if hasItemInHand then
        if DoesEntityExist(items[n].id) then
            local item = items[n].itemName

            return item
        else

            return false
        end
    end
end

function createObject(item, posX, posY, posZ, rotX, rotY, rotZ, anim, bone)
    n = n + 1
    itemId = CreateObject(item, GetEntityCoords(PlayerPedId()), true, false, false)
    items[n] = {
        id = itemId,
        itemName = item
    }
    AttachEntityToEntity(items[n].id, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), bone), posX, posY, posZ, rotX, rotY, rotZ, true, true, false, true, 1, true)
    animPlayed = anim
    if anim then
        TaskPlayAnim(PlayerPedId(), anim, "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
    end
end 