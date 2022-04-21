# esx_backpack
FiveM Script - Usable Backpack Item

**Forum:** https://forum.cfx.re/t/release-esx-usable-backpack-item/4805469

**Discord Support:** https://discord.gg/5hHSBRHvJE

**Preview 1:** https://streamable.com/iog8fy
**Preview 2:** https://streamable.com/61a8ur

## Description
* You can use the `bag` Item, then you get `nobag` Item and a Bag will be added to your Ped.
* If you use `nobag` Item then then the Bag will be removed from your Ped an you get the `bag` Item.
* Open own Bag with Command
* Steal Bag from closest Player with Command
* Works with Character Names not FiveM Names

## Config
```lua
Config = {}
----------------------------------------------------------------
Config.Locale = 'de'
Config.VersionChecker = true
Config.Debug = false
----------------------------------------------------------------
-- If you use the Plugin for Chezza Inventory, make sure this is the same ID
-- as in Config.Bags = {82} in the config.lua from chezza inventory
Config.Bags = {
    male = {bagID_1 = 82, bagID_2 = 0},
    female = {bagID_1 = 82, bagID_2 = 0}
}
Config.ItemsInBag = true -- Set true if you want that players cant use 'nobag' Item if there are Items in the Bag
----------------------------------------------------------------
-- Config.BagInventory = true // Expand the Inventory Space of the Player
-- Config.BagInventory = false // Secondary Inventory by typing /openbag Command
-- If Config.BagInventory = true then change this to the same value in config.lua of Chezza Inventory !!!
Config.BagInventory = true
Config.BagWeight = 60 -- Set the Value what added to the Inventory Space if 'Config.BagInventory = true'
----------------------------------------------------------------
-- If set to true go to client.lua and change the IDs to what you set in esx_parachute
Config.useParachute = false -- Set true if you use my esx_parchute Script
----------------------------------------------------------------
-- Experimental // Can cause performance problems
Config.CarryLongWeapon = false -- Set 'true' if you want that Players can only carry a Weapon if they have a Bag
Config.WeaponBags = {82} -- Backpack IDs // {ID, ID, ID} | Only for 'Config.CarryLongWeapon' function!!
Config.Weapons = {
    'WEAPON_CARBINERIFLE',
    'WEAPON_GUSENBERG',
    'WEAPON_PUMPSHOTGUN',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_ASSAULTRIFLE',
}
```

## Requirements
* esx_skin
* skinchanger
* ESX 1.2 *(v1-final)* / Legacy
* Chezza Inventory (https://forum.cfx.re/t/paid-release-chezzas-inventory-esx/2040417)

Should work with ESX Legacy too but I didn't test it.

### Chezza Inventory Plugin

Add the following in the `config.lua` from chezza inventory.
```lua
Config.Bags = {82} -- Set you Bag IDs here
Config.BagWeight = 60 -- Secondary Inventory
-- If Config.BagInventory = true you cant use the Commands /openbag and /stealbag !!!
-- Config.BagInventory = true // Expand the Inventory Space of the Player
-- Config.BagInventory = false // Secondary Inventory by typing /openbag Command
Config.BagInventory = true
```

Create a new folder in `inventory/plugins/` f.e. `backpack` and put the files `cl_backpack.lua` and `sv_backpack.lua` in the `backpack` folder.

#### Events / Commands
* `/openbag` - Open your own Bag
* `/stealbag` - Open the Bag from Player next to you

**Added Client Events to add the Commands f.e. in a Menu**
* TriggerEvent('inventory:openBagViaMenu')
* TriggerEvent('inventory:openStealBagViaMenu')

## License
**GNU General Public License v3.0**
