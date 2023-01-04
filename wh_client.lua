Callbacks = exports['callbacks']:FetchCallbacks()
--! Start Menu Logic
RegisterNetEvent('warehouse:Client:openWhMenu')
AddEventHandler('warehouse:Client:openWhMenu', function(location)
    local ownsWarehouse = nil
    local whName = location
    Callbacks:TriggerCallback('warehouse:ownsWarehouse', function(data)
        if data == true then
            ownsWarehouse = true
        else
            ownsWarehouse = false
        end
    end, location)
    while ownsWarehouse == nil do Wait(5) end
    if ownsWarehouse then
        local WH_MENU = {
            {
                header = "📦 Warehouse",
                isMenuHeader = true, -- Set to true to make a nonclickable title
            },
            {
                header = "Open Warehouse",
                txt = "",
                params = {
                    event = "warehouse:Client:openWarehouse",
                    args = {
                        whLocation = whName,
                    }
                }
            },
            {
                header = "Sell Warehouse - [$30]",
                txt = "",
                params = {
                    event = "warehouse:Client:openWhSell",
                    args = {
                        whLocation = location,
                    }
                }
            },
            {
                header = "Exit",
                txt = "",
                disabled = true,
                -- hidden = true, -- doesnt create this at all if set to true
                params = {
                    event = "qbr-menu:client:closeMenu",
                    args = {
                        number = 1,
                    }
                }
            },
        }
        TriggerEvent('qbr-menu:client:openMenu', WH_MENU)
    elseif not ownsWarehouse then
        local WH_MENU = {
            {
                header = "📦 Warehouse",
                isMenuHeader = true, -- Set to true to make a nonclickable title
            },
            {
                header = "Buy Warehouse - [$30]",
                txt = "",
                params = {
                    event = "warehouse:Client:openWhBuy",
                    args = {
                        whLocation = whName,
                    }
                }
            },
            {
                header = "Exit",
                txt = "",
                disabled = true,
                -- hidden = true, -- doesnt create this at all if set to true
                params = {
                    event = "qbr-menu:client:closeMenu",
                    args = {
                        number = 1,
                    }
                }
            },
        }
        TriggerEvent('qbr-menu:client:openMenu', WH_MENU)
    end

end)
RegisterNetEvent('warehouse:Client:openWhBuy')
AddEventHandler('warehouse:Client:openWhBuy', function(location)
    local whName = location['whLocation']
    local OPEN_WH_BUY= {
        {
            header = "📦 Warehouse - Buy",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Confirm Buy Warehouse - [$30]",
            txt = "",
            params = {
                event = "warehouse:Client:buyWarehouse",
                args = {
                    whLocation = whName,
                }
            }
        },
        {
            header = "Go Back",
            txt = "",
            params = {
                event = "warehouse:Client:openWhMenu",
                args = {
                    item = '',
                }
            }
        },
        {
            header = "Exit",
            txt = "",
            disabled = true,
            -- hidden = true, -- doesnt create this at all if set to true
            params = {
                event = "qbr-menu:client:closeMenu",
                args = {
                    number = 1,
                }
            }
        },

    }
    TriggerEvent('qbr-menu:client:openMenu', OPEN_WH_BUY)
end)
RegisterNetEvent('warehouse:Client:openWhSell')
AddEventHandler('warehouse:Client:openWhSell', function(location)
    local location = location['whLocation']
    local OPEN_WH_SELL= {
        {
            header = "📦 Warehouse - Sell",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "⚠️ All items in warehouse will be lost",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Confirm Sell Warehouse - [$30]",
            txt = "",
            params = {
                event = "warehouse:Client:openWhSellConfirmed",
                args = {
                    whLocation = location,
                }
            }
        },
        {
            header = "Go Back",
            txt = "",
            params = {
                event = "warehouse:Client:openWhMenu",
                args = {
                    item = '',
                }
            }
        },
        {
            header = "Exit",
            txt = "",
            disabled = true,
            -- hidden = true, -- doesnt create this at all if set to true
            params = {
                event = "qbr-menu:client:closeMenu",
                args = {
                    number = 1,
                }
            }
        },

    }
    TriggerEvent('qbr-menu:client:openMenu', OPEN_WH_SELL)
end)
RegisterNetEvent('warehouse:Client:openWhSellConfirmed')
AddEventHandler('warehouse:Client:openWhSellConfirmed', function(location)
    local location = location['whLocation']
    local OPEN_SELL_CONFIRMED = {
        {
            header = "📦 Warehouse - Sell",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "⚠️ All items in warehouse will be lost",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Sell [Final Confirm]",
            txt = "",
            params = {
                event = "warehouse:Client:sellWarehouse",
                args = {
                    whLocation = location,
                }
            }
        },
        {
            header = "Go Back",
            txt = "",
            params = {
                event = "warehouse:Client:openWhSell",
                args = {
                    item = '',
                }
            }
        },
        {
            header = "Exit",
            txt = "",
            disabled = true,
            -- hidden = true, -- doesnt create this at all if set to true
            params = {
                event = "qbr-menu:client:closeMenu",
                args = {
                    number = 1,
                }
            }
        },

    }
    TriggerEvent('qbr-menu:client:openMenu', OPEN_SELL_CONFIRMED )
end)

RegisterNetEvent('warehouse:Client:buyWarehouse')
AddEventHandler('warehouse:Client:buyWarehouse', function(location)
    local whName = location['whLocation']
    TriggerServerEvent('warehouse:Server:buyWh', whName)
end)
RegisterNetEvent('warehouse:Client:sellWarehouse')
AddEventHandler('warehouse:Client:sellWarehouse', function(location)
    local whName = location['whLocation']
    TriggerServerEvent('warehouse:Server:sellWh', whName)
end)

RegisterNetEvent('warehouse:Client:openWarehouse')
AddEventHandler('warehouse:Client:openWarehouse', function(location)
    local whName = location['whLocation']
    TriggerServerEvent('warehouse:Server:openWh', whName)
end)
local IsInZone = {}
local isNearZone = {}
local keys = { ['G'] = 0x760A9C6F, ["B"] = 0x4CC0E2FE, ['S'] = 0xD27782E3, ['W'] = 0x8FD015D8, ['H'] = 0x24978A28, ['G'] = 0x5415BE48, ["ENTER"] = 0xC7B5340A, ['E'] = 0xDFF812F9, ["J"] = 0xF3830D8E }
local pedRemoved = {}
local pedSpawned = {}
--? ================== Start Location LOGIC ==================
Citizen.CreateThread(function()
    while true do
        for k,v in pairs(Locations) do
            optimalization_fix = 5
            isNearZone[k] = IsPlayerNearCoords(Locations[k]["Coords"].x, Locations[k]["Coords"].y, Locations[k]["Coords"].z, Locations[k]["Coords"].air)
            if isNearZone[k] then
                IsInZone[k] = IsPlayerNearCoords(Locations[k]["Coords"].x, Locations[k]["Coords"].y, Locations[k]["Coords"].z, Locations[k]["Coords"].r)
                if not pedSpawned[k] then
                    spawnPed(Locations[k])
                    pedRemoved[k] = false
                    pedSpawned[k] = true
                end
            else
                IsInZone[k] = false
                if not pedRemoved[k] then
                    removePed(Locations[k]["Name"])
                    pedRemoved[k] = true
                    pedSpawned[k] = false
                end
            end
            if IsInZone[k] then
                    DrawText3D(Locations[k]["Coords"].x, Locations[k]["Coords"].y, Locations[k]["Coords"].z, "Press ~e~[ G ]~q~ to open Warehouse")
                    if IsControlJustPressed(0, keys['G']) then
                            TriggerEvent('warehouse:Client:openWhMenu',Locations[k]["Name"])
                    end
            else
            end
        end
        Citizen.Wait(optimalization_fix)
    end
end)
--? ================== END Location LOGIC ==================
function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
	local px,py,pz=table.unpack(GetGameplayCamCoord())

	SetTextScale(0.35, 0.35)
	SetTextFontForCurrentCommand(6)
	SetTextColor(255, 255, 255, 215)
	local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
	SetTextCentre(1)
	DisplayText(str,_x,_y)
end

function IsPlayerNearCoords(x, y, z, radius)
	local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
	local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)
	if distance < radius then
		return true
	end
end
--? ==================START AI LOGIC ==================
function spawnPed(location)
    local pedHash = GetHashKey(location['Ped'])
    exports["polyzone-api"]:NewPed(pedHash, location['Name'], {
        coords = vector3(location['Coords'].x, location['Coords'].y, location['Coords'].z-1.0),
        radius = location["Coords"].air,
        heading = location['Heading'],
        useZ = false,
        debug = false
    }, {
        invincible = true,
        canMove = true,
        ignorePlayer = true
    })
end
function removePed(name)
    exports["polyzone-api"]:DestroyPed(name)
end
--? ==================END AI LOGIC ==================

Citizen.CreateThread(function ()
    for k,v in pairs(Locations) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Locations[k]["Coords"].x, Locations[k]["Coords"].y, Locations[k]["Coords"].z)
        SetBlipSprite(blip, -426139257, 1)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, Locations[k]['townName'].." Storage Warehouse")
    end
end)
