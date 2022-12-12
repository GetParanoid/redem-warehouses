# redem-warehouses

Warning: this is not a drag and drop script, some development work is needed along side some SQL table edits.

## About
redem-warehouses adds storage warehouses around the map of RDR2. These warehouses have independent storages bound to the player's character, and are not linked together. What you place in Rhodes won't be in St. Denis. You're able to buy and even sell back your warehouses.

## 1.Requirements
[redemrp](https://github.com/RedEM-RP/redem_roleplay)

[qbr-menu](https://github.com/qbcore-redm-framework/qbr-menu)

[NextGen Callbacks](https://github.com/itsxScrubz/callbacks)

[PolyZone](https://github.com/mkafrin/PolyZone)

## 2. Installation
1. Using HeidiSQL or similar program, edit your SQL database - editing table 'user_locker'
   1. Add a Column named: 'type'
   2. Datatype: VARCHAR
   3. Length/Set: 75
   4. Allow NULL
   5. Default NULL

    In the end, your table should look like this.
    ![table-image](https://i.imgur.com/Ppdxqgl.png)

2. Edit Script redemrp_inventory
   1. Find and Change (redemrp_inventory/server/sv_main.lua Line: 913)
        ```
        function SharedInventoryFunctions.createLocker(type, x , y , z , job)
        ```
        To
        ```
        function SharedInventoryFunctions.createLocker(type, x , y , z , job, wh)
        ```
   2. Find And Change (redemrp_inventory/server/sv_main.lua Line: 934)
        ```
            MySQL.Async.execute('INSERT INTO user_locker (`identifier`, `charid`, `items`) VALUES (@identifier, @charid, @items);',
                                {
                                    identifier = _type,
                                    charid = 0,
                                    items = json.encode({})
                                }, function(rowsChanged)
                                    Locker[_type], _ , _ =  CreateInventory({})
                                end)
        ```
        To
        ```
        local _wh = wh
            if _wh == 'wh' then
                MySQL.Async.execute('INSERT INTO user_locker (`identifier`, `charid`, `items`,`type`) VALUES (@identifier, @charid, @items, @wh);',
                    {
                        identifier = _type,
                        charid = 0,
                        items = json.encode({}),
                        wh = _wh
                    }, function(rowsChanged)
                        Locker[_type], _ , _ =  CreateInventory({})
                    end)
            else
                MySQL.Async.execute('INSERT INTO user_locker (`identifier`, `charid`, `items`) VALUES (@identifier, @charid, @items);',
                    {
                        identifier = _type,
                        charid = 0,
                        items = json.encode({})
                    }, function(rowsChanged)
                        Locker[_type], _ , _ =  CreateInventory({})
                    end)
            end

        ```
3. Install qbr-menu and NextGen Callbacks

   Start callbacks script before qbr-menu & redem-warehouses
   ```
    ensure PolyZone
    ensure callbacks
    ensure qbr-menu
    ensure redem-warehouses
   ```
4. Enjoy

## Developing with NextGen Callbacks
1. If you wish to live restart redem-warehouses, you must restart callbacks before restarting redem-warehouses

    In F8 Console
    ```
    ensure callbacks
    ensure redem-warehouses
    ```

# Known Issues
Probably A lot. It worked in limited testing, never pushed to a live server. ¯\\_(ツ)_/¯

You'll need to edit anywhere you see the event 'notify:Notify:showGeneralNotificationSuccess' with your own notification system.

You'll also need to edit the event 'logs:Server:CreateLog' event to your logging system.

# Support.
No Support, sorry. Don't make an issue. I no longer develop for RedM, I worked this up in an afternoon for a WIP RedM server that never saw the light.
