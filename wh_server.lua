local CreatedLockers, whData, data = {}
local identifier, charid, warehouseID, identCharID, fetched, rlFetched = nil
Callbacks = exports['callbacks']:FetchCallbacks()
TriggerEvent("redemrp_inventory:getData",function(call)
	data = call
end)


RegisterNetEvent('warehouse:Server:buyWh')
AddEventHandler('warehouse:Server:buyWh', function(location)
    local _source = source
    local money, rpName = nil
    local paid = false
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        identifier = user.getIdentifier()
        charid = user.getSessionVar("charid")
        money = user.getMoney()
        if money >= 30 then
            user.removeMoney(30)
            paid = true
            rpName = user.getFirstname() ..' '.. user.getLastname()
            --TriggerEvent("logs:Server:CreateLog", "warehouse", "Player Bought Warehouse", "pink", " **RP NAME:** "..rpName.."\n**STEAM:** "..GetPlayerName(_source).."\n** SERVER ID: **"..tostring(_source).."\n** Location: **"  ..location, false)
        end
    end)
    if paid then
        for k,v in pairs(Locations) do
            if location == Locations[k]['Name'] then
                local whX, whY, whZ = Locations[k]["Coords"].x, Locations[k]["Coords"].y, Locations[k]["Coords"].z
            end
        end
        identCharID = identifier.."_"..charid
        warehouseID = identCharID .. "_"..location
        data.updateLockers(-1)
        if identifier and charid and warehouseID and paid then
            if not checkLockerExist(warehouseID) then
                data.createLocker(warehouseID, whX, whY, whZ, nil, 'wh')
                data.updateLockers(-1)
            else
                print('Warehouse Owned', warehouseID)
            end
        end
    else
        --TriggerClientEvent('notify:Notify:showGeneralNotificationError', _source, "Error","You don't have enough money", 2500)
    end
end)
RegisterNetEvent('warehouse:Server:sellWh')
AddEventHandler('warehouse:Server:sellWh', function(location)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        user = user
        identifier = user.getIdentifier()
        charid = user.getSessionVar("charid")
    end)
    identCharID = identifier.."_"..charid
    warehouseID = identCharID .. "_"..location
    data.updateLockers(-1)
    if identifier and charid and warehouseID then
        if checkLockerExist(warehouseID) then
            local rpName = nil
            TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
                user.addMoney(30)
                rpName = user.getFirstname() .. ' '.. user.getLastname()
                --TriggerEvent("logs:Server:CreateLog", "warehouse", "Player Sold Warehouse", "turqois", " **RP NAME:** "..rpName.."\n**STEAM:** "..GetPlayerName(_source).."\n** SERVER ID: **"..tostring(_source).."\n** Location: **"  ..location, false)
            end)
            --TriggerClientEvent('notify:Notify:showGeneralNotificationSuccess', _source, "Success","Warehouse Sold", 2500)
            data.removeLocker(-1 , warehouseID)
            data.updateLockers(-1)
        else
            print('Warehouse Doesnt Exist', warehouseID)
        end
    end
end)
RegisterNetEvent('warehouse:Server:openWh')
AddEventHandler('warehouse:Server:openWh', function(location)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        identifier = user.getIdentifier()
        charid = user.getSessionVar("charid")
    end)
    for k,v in pairs(Locations) do
        if location == Locations[k]['Name'] then
            local whX, whY, whZ = Locations[k]["Coords"].x, Locations[k]["Coords"].y, Locations[k]["Coords"].z
        end
    end
    identCharID = identifier.."_"..charid
    warehouseID = identCharID .. "_"..location
    data.createLocker(warehouseID, whX, whY, whZ, nil, 'wh')
    data.updateLockers(-1)
    Wait(250)

    --! WIP for checking if WH is open, to allow sharing of warehouses and to prevent duping.
    -- for k,v in ipairs(whData) do
        -- if v['identifier'] == warehouseID then
            -- if not v['isOpen'] then
                -- print('whid-open',warehouseID)
                TriggerClientEvent('redemrp_inventory:OpenLocker', _source,  warehouseID)
                -- v['isOpen'] = true
            -- elseif  v['isOpen'] then
                -- print('warehouse open')
            -- else
                -- print('error')
            -- end
        -- end
    -- end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        whData = {}
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        whData = {}
        Wait(250)
        getRegisteredLockers()
        registerCallbacks()
    end
end)

function checkLockerExist(warehouseID)
    local whID = warehouseID
    fetched = nil
    MySQL.Async.fetchAll("SELECT * FROM `user_locker` WHERE `identifier`=@identifier", { ['@identifier'] = whID}, function(result)
        while not result do
            Citizen.Wait(1)
        end
        if result[1] then
            fetched = true
        else
            fetched = false
        end
    end)
    while fetched == nil do Wait(1) end

    return fetched
end

function getRegisteredLockers()
    rlFetched = false
    MySQL.Async.fetchAll("SELECT * FROM `user_locker` WHERE `type`=@type", {["@type"]='wh' }, function(result)
        while not result do
            Citizen.Wait(1)
        end
        while not result[1] do
            Citizen.Wait(1)
        end
        whData = result
        
        for k,v in ipairs(result) do
            whData[k]['isOpen'] = false
        end
        rlFetched = true
    end)
    while not rlFetched do Wait(1) end

    return rlFetched
end


function registerCallbacks()
    Callbacks:RegisterCallback('warehouse:ownsWarehouse', function(data, source, cb)
        local location = data
        local _source = source
        TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
            identifier = user.getIdentifier()
            charid = user.getSessionVar("charid")
        end)
        identCharID = identifier.."_"..charid
        warehouseID = identCharID .. "_"..location
        local ownsWarehouse = checkLockerExist(warehouseID)
        if  ownsWarehouse then
            cb(true)
        else
            cb(false)
        end
    end)
end
