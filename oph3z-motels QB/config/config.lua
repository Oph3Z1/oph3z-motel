Config = {}

Config.Data = {
    BuyMotelPass = true, -- If it's true, the motel purchase screen will be activated, and players can buy motels from that menu.
    BuyMotel = vector3(313.24, -225.02, 54.22), -- The coordinates of the motel business sale menu can be set.
    OwnerRoomSee = true, -- If it's true, the motel owner sees all the rooms and can enter and exit the rooms.
    EmployesRoomSee = true, -- If it's true, motel employees see all the rooms and can enter and exit the rooms.
    CustomersManage = true,  -- If it's true, the room owner enables individuals to access the room management panel.
    UseTarget = false, -- If it's true, the targeting system comes into play, and adaptation is made according to your own target.
    Moneytype = "bank", -- In places such as purchasing a motel room or acquiring a motel business, the place where the payment will be deducted can be cash, bank, or cryptocurrency.
    ["VIP"] = 300000,  -- The VIP Rooms stash amount! Config.Lang.["vip"] = "VIP" should be the same as rooms.type = "VIP", and they should all be the same.
    ["Middle"] = 200000, -- The Middle Rooms stash amount! Config.Lang.["middle"] = "Middle" should be the same as rooms.type = "Middle", and they should all be the same.
    ["Squatter"] = 50000, -- The Squatter Rooms stash amount! Config.Lang.["squatter"] = "Squatter" should be the same as rooms.type = "Squatter", and they should all be the same.
    ["VIPs"] = 40, -- The number of slots in the inventory of the VIP Room!
    ["Middles"] = 25, -- The number of slots in the inventory of the Middle Room!
    ["Squatters"] = 15, --The number of slots in the inventory of the Squatter Room!
    EmployesSalaryTime = 0.5, -- If you write "1" for the wage interval of motel employees, it means they will receive their salary every hour.
    EmployesOfflinePayment = false, -- You can enable or disable salary payments for motel employees while they are offline.
    NoOwnedRentMotelAmount = 2, -- In the absence of a motel owner, a person can set the maximum number of rooms they can rent.
    OwneRentMotelAmount = 1, -- When there is a motel owner, a person can set the maximum number of rooms they can rent.
    MaxMotelBossAmount = 1, -- It determines the maximum number of motel businesses a person can purchase.
    EmployesTax = true, -- If it's true, motel employees receive a share for each room they sell.
    EmployesTaxAmount = 15, -- The share rate for motel employees per room they sell operates as a percentage.
    FriendSystem = true, -- If it's true, the friend system operates, allowing individuals to add friends to their rooms.
    FriendLimitV = 3, -- The maximum number of friends that can be added to a VIP room is determined.
    FriendLimitM = 3, -- The maximum number of friends that can be added to a middle room is determined.
    FriendLimitS = 3, -- The maximum number of friends that can be added to a squatter room is determined.
    AcceptYuzdelik = 10, -- It sets the percentage of the requested amount from the room management section that needs to go to the cash register after being approved by the motel owner. The recommended percentage is 100.
    SellMotelPass = true, -- If it's true, the motel owner can sell the motel back, and the price will be determined based on the availability of funds in the cash register. If there is no money in the cash register, the price will be set according to the SellPriceDefault settings.
    SellMotelPrice = 0.5, -- If there is money in the cash register, it determines the amount by which the motel will be sold based on the current balance in the cash register.
    SellMotelTax = 0.1, -- If the motel is sold, it sets the amount of tax to be paid, and the tax amount will be deducted accordingly.
    SellPriceDeafult = 2000, -- If there is no money in the cash register when the motel is sold, it will be sold at a price that is half of the recommended selling price for the motel business.
    TransferPass = true, -- If it's true, the motel business can be transferred to another player (ID) in the game.
    Framework = "QBCore", -- OLDQBCore or QBCore
    Inventory = "qb", -- ox or qb
    Appearance = false,
}

Config.StashFunction = function(Motelid, Odano, OdaType)
    if Config.Data.Inventory == "qb" then
        StashSlots = tostring(OdaType.."s")
        TriggerServerEvent("inventory:server:OpenInventory", "stash", Motelid..Odano, {
            maxweight = Config.Data[OdaType], 
            slots = Config.Data[StashSlots], 
        })
        TriggerEvent("inventory:client:SetCurrentStash", Motelid..Odano) 
    end


    if Config.Data.Inventory == "ox" then
        if exports.ox_inventory:openInventory('stash', "Motel_"..Motelid..'_'..Odano) == false then
            TriggerServerEvent('ox:loadStashes')
            exports.ox_inventory:openInventory('stash', "Motel_"..Motelid..'_'..Odano)
        end
    end
end 

Config.WardrobeFunction = function ()
    if Config.Data.Appearance then
        TriggerEvent("fivem-appearance:Oph3zMotel")
    else
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Clothes1", 0.4)
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    end

end

Config.DrawText3D = function (msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

Config.Notify = function(text, type, time)
    if text == nil then
        text = "ERROR404"
    end
    if type == nil then
        type = "primary"
    end
    if time == nil then
        time = 5000
    end
    QBCore.Functions.Notify(text, type, time)
end

Config.ServerNotify = function(src, text, type, time)
    if text == nil then
        text = "ERROR404"
    end
    if type == nil then
        type = "primary"
    end
    if time == nil then
        time = 5000
    end
    TriggerClientEvent('QBCore:Notify', src, text, type, time)
end

Config.Maps = {
    ["VIP1"] = {
        exportName = "GetExecApartment2Object",
        out = vector3(-779.08, 339.69, 196.69),
        manage = vector3(-777.21, 331.06, 196.09),
        stash = vector3(-766.01, 330.97, 196.09),
        wardrobe = vector3(-764.74, 329.01, 199.49),
        ThemeData = {
            modern = {interiorId = 227585, ipl = "apa_v_mp_h_01_b"},
            moody = {interiorId = 228353,  ipl = "apa_v_mp_h_02_b"},
            vibrant = {interiorId = 229121, ipl = "apa_v_mp_h_03_b"},
            sharp = {interiorId = 229889, ipl = "apa_v_mp_h_04_b"},
            monochrome = {interiorId = 230657, ipl = "apa_v_mp_h_05_b"},
            seductive = {interiorId = 231425, ipl = "apa_v_mp_h_06_b"},
            regal = {interiorId = 232193, ipl = "apa_v_mp_h_07_b"},
            aqua = {interiorId = 232961, ipl = "apa_v_mp_h_08_b"}
        }
    },

    ["VIP2"] = { --APART3
        exportName = "GetExecApartment3Object",
        out = vector3(-781.8, 318.01, 187.91),
        manage = vector3(-783.82, 326.69, 187.31),
        stash = vector3(-795.0, 326.75, 187.31),
        wardrobe = vector3(-797.53, 328.1, 190.72),
        ThemeData = {
            modern = {interiorId = 227585,  ipl = "apa_v_mp_h_01_b"},
            moody = {interiorId = 228609, ipl = "apa_v_mp_h_02_c"},
            vibrant = {interiorId = 229377, ipl = "apa_v_mp_h_03_c"},
            sharp = {interiorId = 230145, ipl = "apa_v_mp_h_04_c"},
            monochrome = {interiorId = 230913, ipl = "apa_v_mp_h_05_c"},
            seductive = {interiorId = 231681, ipl = "apa_v_mp_h_06_c"},
            regal = {interiorId = 232449, ipl = "apa_v_mp_h_07_c"},
            aqua = {interiorId = 233217, ipl = "apa_v_mp_h_08_c"}
        },
    },
    ["Middle1"] = { --onyle strip and booze
        exportName = "GetGTAOApartmentHi2Object",
        out = vector3(-1457.55, -519.95, 56.93),
        manage = vector3(-1465.47, -533.92, 55.53),
        stash = vector3(-1457.19, -529.63, 56.94),
        wardrobe = vector3(-1468.05, -537.97, 50.73)
    },

    ["Middle2"] = { --onyle strip and booze
    exportName = "GetGTAOHouseMid1Object",
    out = vector3(346.55, -1013.24, -99.2),
    manage = vector3(342.36, -1001.98, -99.2),
    stash = vector3(351.96, -998.81, -99.2),
    wardrobe = vector3(350.79, -993.59, -99.19)
    },
    ["Squatter1"] = {
        out = vector3(265.87, -1007.59, -101.01),
        manage = vector3(265.89, -999.58, -99.01),
        stash = vector3(262.89, -1002.92, -99.01),
        wardrobe = vector3(259.88, -1004.05, -99.01),
    },
    ["Squatter2"] = {
        out = vector3(265.87, -1007.59, -101.01),
        manage = vector3(265.89, -999.58, -99.01),
        stash = vector3(262.89, -1002.92, -99.01),
        wardrobe = vector3(259.88, -1004.05, -99.01),
    },
}