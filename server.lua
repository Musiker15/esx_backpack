local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_bag:delBackpack')
AddEventHandler('esx_bag:delBackpack', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasBag = xPlayer.getInventoryItem('nobag').count

    if hasBag > 0 then
        TriggerClientEvent('esx_bag:setdelBag', source)
        xPlayer.removeInventoryItem('nobag', 1)
        xPlayer.addInventoryItem("bag", 1)
    end
end)

if Config.Debug and Config.BagInventory:match('expand') then
    Citizen.CreateThread(function()
        while true do
            for k,players in pairs(GetPlayers()) do
                local xPlayer = ESX.GetPlayerFromId(players)

                if (xPlayer ~= nil) then
                    print('DEBUG playerMaxWeight:', players, xPlayer.getMaxWeight())
                end
            end

            Citizen.Wait(5000)
        end
    end)
end

-- Bag
ESX.RegisterUsableItem('bag', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local hasBag = xPlayer.getInventoryItem('nobag').count
    
    if hasBag == 0 then
        TriggerClientEvent('esx_bag:setBag', source)
        xPlayer.removeInventoryItem('bag', 1)
        xPlayer.addInventoryItem("nobag", 1)

        if Config.BagInventory:match('expand') then
            debug('playerMaxWeight before add bag:', xPlayer.source, xPlayer.getMaxWeight())
            setPlayerBag(xPlayer, ESX.GetConfig().MaxWeight + Config.BagWeight)
        end

        TriggerClientEvent('esx:showNotification', source, _U('used_bag'))
    else
        TriggerClientEvent('esx:showNotification', source, _U('has_bag'))
    end
end)

-- No Bag
ESX.RegisterUsableItem('nobag', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local hasBag = xPlayer.getInventoryItem('bag').count

    if Config.ItemsInBag then
        if Config.BagInventory:match('expand') then
            local playerWeight = xPlayer.getWeight()
            debug('NOBAG playerWeight:', xPlayer.source, playerWeight)

            if playerWeight > ESX.GetConfig().MaxWeight then
                TriggerClientEvent('esx:showNotification', source, _U('itemsInBag'))
            else
                if hasBag == 0 then
                    TriggerClientEvent('esx_bag:setdelBag', source)
                    xPlayer.removeInventoryItem('nobag', 1)
                    xPlayer.addInventoryItem("bag", 1)
            
                    if Config.BagInventory:match('expand') then
                        debug('playerMaxWeight before remove bag:', xPlayer.source, xPlayer.getMaxWeight())
                        setPlayerBag(xPlayer, ESX.GetConfig().MaxWeight)
                    end
                    
                    TriggerClientEvent('esx:showNotification', source, _U('used_nobag'))
                else
                    TriggerClientEvent('esx:showNotification', source, _U('had_bag'))
                end
            end
        else
            if itemsInBag(xPlayer) then
                debug('Trigger Event itemsInBag(xPlayer)')
                
                if hasBag == 0 then
                    TriggerClientEvent('esx_bag:setdelBag', source)
                    xPlayer.removeInventoryItem('nobag', 1)
                    xPlayer.addInventoryItem("bag", 1)
                    TriggerClientEvent('esx:showNotification', source, _U('used_nobag'))
                else
                    TriggerClientEvent('esx:showNotification', source, _U('had_bag'))
                end
            else
                debug('Trigger Notification itemsInBag')
                TriggerClientEvent('esx:showNotification', source, _U('itemsInBag'))
            end
        end
    else
        if hasBag == 0 then
            TriggerClientEvent('esx_bag:setdelBag', source)
            xPlayer.removeInventoryItem('nobag', 1)
            xPlayer.addInventoryItem("bag", 1)
    
            if Config.BagInventory:match('expand') then
                debug('playerMaxWeight before remove bag:', xPlayer.source, xPlayer.getMaxWeight())
                setPlayerBag(xPlayer, ESX.GetConfig().MaxWeight)
            end
            
            TriggerClientEvent('esx:showNotification', source, _U('used_nobag'))
        else
            TriggerClientEvent('esx:showNotification', source, _U('had_bag'))
        end
    end
end)

function setPlayerBag(xPlayer, weight)
    if xPlayer then
        if weight > ESX.GetConfig().MaxWeight then
            CreateThread(function()
                while true do
                    Wait(0)
                    xPlayer.setMaxWeight(ESX.GetConfig().MaxWeight + Config.BagWeight)
                end
            end)
        elseif weight == ESX.GetConfig().MaxWeight then
            CreateThread(function()
                while true do
                    Wait(0)
                    xPlayer.setMaxWeight(ESX.GetConfig().MaxWeight)
                end
            end)
        end
    end
end

function itemsInBag(xPlayer)
    local result = MySQL.Sync.fetchAll("SELECT * FROM inventories WHERE identifier = @identifier AND type = @type", { 
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = 'bag'
    })

    if result[1] then
        debug('identifier: ' .. result[1].identifier)
        debug('type: ' .. result[1].type)
        debug('data: ' .. result[1].data)

        if result[1].data == '[]' then
            debug('Bag is empty')
            return true
        else
            debug('Items in Bag')
            return false
        end
    else 
        debug('result not found')
        return false
    end
end

function debug(msg, msg2, msg3)
	if Config.Debug then
        if msg3 then
            print(msg, msg2, msg3)
        elseif not msg3 and msg2 then
            print(msg, msg2)
        else
		    print(msg)
        end
	end
end

---- GitHub Updater ----
function GetCurrentVersion()
	return GetResourceMetadata( GetCurrentResourceName(), "version" )
end

local CurrentVersion = GetCurrentVersion()
local resourceName = "^4["..GetCurrentResourceName().."]^0"

if Config.VersionChecker then
	PerformHttpRequest('https://raw.githubusercontent.com/Musiker15/esx_backpack/main/VERSION', function(Error, NewestVersion, Header)
		print("###############################")
    	if CurrentVersion == NewestVersion then
	    	print(resourceName .. '^2 ??? Resource is Up to Date^0 - ^5Current Version: ^2' .. CurrentVersion .. '^0')
    	elseif CurrentVersion ~= NewestVersion then
        	print(resourceName .. '^1 ??? Resource Outdated. Please Update!^0 - ^5Current Version: ^1' .. CurrentVersion .. '^0')
	    	print('^5Newest Version: ^2' .. NewestVersion .. '^0 - ^6Download here: ^9https://github.com/Musiker15/esx_backpack/releases/tag/v'.. NewestVersion .. '^0')
    	end
		print("###############################")
	end)
else
	print("###############################")
	print(resourceName .. '^2 ??? Resource loaded^0')
	print("###############################")
end