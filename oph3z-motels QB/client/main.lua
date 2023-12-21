if Config.Data.Framework == "OLDQBCore"then
    QBCore = nil 

    Citizen.CreateThread(function()
       while QBCore == nil do
           TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
           Citizen.Wait(30) -- Saniye Bekletme
       end
    end)
else
    QBCore = exports['qb-core']:GetCoreObject()
end
CurrentMotel = 0
local motelodasinda = false
local Motelid = nil
local Odano = nil
local OdaType = nil
local Odatasarimi = nil
local OwnerMode = false
local odatipi = nil
local targetmotelid = nil

local function OpenMotel(id)
    TriggerServerEvent("oph3z-motels:ReqData")
    CurrentMotel = id
    local ActiveMotelRooms = 0
    for k, v in pairs(Config.Motels[id].Rooms) do
        if v.Rent == false and v.Active == true then
            ActiveMotelRooms = ActiveMotelRooms + 1
        end
    end

    local data = {
        motel = Config.Motels[id],
        location = Config.Motels[id].Location,
        name = Config.Motels[id].Name,
        description = Config.Motels[id].Description,
        Active = Config.Motels[id].Active,
        activeRooms = ActiveMotelRooms,
        totalRooms = #Config.Motels[id].Rooms,
        rooms = Config.Motels[id].Rooms,

    }
    SendNUIMessage({
        type = "OpenMotel",
        data = data,
        motelid = CurrentMotel,
        translate = Config.Lang
    })

    SetNuiFocus(true, true)
    TriggerServerEvent("oph3z-motels:server:RentMotelAcildi", id, true)
end

function OpenBossMenu(id)
    TriggerServerEvent("oph3z-motels:ReqData")
    local player, distance = QBCore.Functions.GetClosestPlayer()
    local ActiveMotelRooms = 0

    local yarrakcss = {}

    for i=1, #Config.Motels[id].Rooms do 
        yarrakcss[Config.Motels[id].Rooms[i].motelno] = Config.Motels[id].Rooms[i].StyleMenu
    end

    for k, v in pairs(Config.Motels[id].Rooms) do
        if v.Rent == false and v.Active == true then
            ActiveMotelRooms = ActiveMotelRooms + 1
        end
    end

    QBCore.Functions.TriggerCallback("oph3z-motels:server:RequestMotel", function(RequestData)
        if distance ~= -1 and distance <= 3.0 then
            QBCore.Functions.TriggerCallback("oph3z-motels:server:PlayerName", function(name)
                local data = {
                    motel = Config.Motels[id],
                    rooms = Config.Motels[id].Rooms,
                    ActiveTotalRooms = ActiveMotelRooms,
                    employees = Config.Motels[id].Employes,
                    players = name,
                    name = Config.Motels[id].Name,
                    requestdata = RequestData,
            
                }
                SendNUIMessage({
                    type = "OpenBossMenu",
                    data = data,
                    yarrak = yarrakcss,
                    motelid = id,
                    translate = Config.Lang
                })
    
            end, GetPlayerServerId(player))
        else
            local data = {
                motel = Config.Motels[id],
                rooms = Config.Motels[id].Rooms,
                ActiveTotalRooms = ActiveMotelRooms,
                employees = Config.Motels[id].Employes,
                vipmotelupgradeprice = Config.Motels[id].VIPUpgradeMoney,
                middleupgradeprice = Config.Motels[id].MiddleUpgradeMoney,
                name = Config.Motels[id].Name,
                requestdata = RequestData,
            }
            SendNUIMessage({
                type = "OpenBossMenu",
                data = data,
                yarrak = yarrakcss,
                motelid = id,
                translate = Config.Lang
            })
        end
    end, id)
    SetNuiFocus(true, true)
    TriggerServerEvent("oph3z-motels:server:BossMenuAcildi", id, true)
end

local motelZones = {}

function UseTargetClient(coords, eventname, eventneresi, eventlabel)
    if motelZones[eventneresi] then
        exports['qb-target']:RemoveZone(eventneresi)
        motelZones[eventneresi] = false
    end
    if not motelZones[eventneresi] then
        exports["qb-target"]:AddBoxZone("oph3z-motel:UseTarget:OpenMotel", vector3(coords.x, coords.y, coords.z), 1, 2.4, {
            name = eventneresi,
            heading=270,
            minZ= coords.z-5,
            maxZ= coords.z +5
        }, {
            options = {
                {
                    event = eventname,
                    icon = "fas fa-circle",
                    calisacakyer = eventneresi,
                    label = eventlabel
                },
            },
            job = {"all"},
            distance = 1
        })
        motelZones[eventneresi] = true
    end
end

RegisterNetEvent("oph3z-motel:client:UseTarget", function (eventneresi)
    eventneresi = eventneresi.calisacakyer
    if eventneresi == "RentMotel" then
        OpenMotel(targetmotelid)
    elseif eventneresi == "OpenBossMenu" then
        OpenBossMenu(targetboosmenuid)
    elseif eventneresi == "OpenRoom" then
        TriggerServerEvent("oph3z-motels:server:OpenRoom", targetmoteldata.odadataone, targetmoteldata.odadatawtow, targetmoteldata.OdaTipi, targetmoteldata.OdaType, targetmoteldata.OdaTheme, targetmoteldata.OdaStrip, targetmoteldata.OdaBooze) 
    elseif eventneresi == "ExitRoom" then
        TriggerServerEvent("oph3z-motels:server:ExitRoom", Motelid, Odano)
    elseif eventneresi == "Stash" then
        Config.StashFunction(Motelid, Odano, OdaType)
    elseif eventneresi == "Manage" then
        ManageFunction(Motelid, Odano, OdaType, odatipi, OdaTheme)
    elseif eventneresi == "Wardrobe" then
        Config.WardrobeFunction()
    elseif eventneresi == "BuyMotel" then
        OpenBuyMenu()
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        if ScriptLoaded then
            for k,v in pairs(Config.Motels) do
                if v.Owner == "" then
                    if #(PlayerCoords - v.RentMotel) <= 2.0 then
                        sleep = 0
                        if Config.Data.UseTarget then
                            targetmotelid = k
                            UseTargetClient(v.RentMotel, "oph3z-motel:client:UseTarget", "RentMotel", "Rent Motel")
                        else
                            Config.DrawText3D("~INPUT_PICKUP~ - Open Motel", vector3(v.RentMotel.x, v.RentMotel.y, v.RentMotel.z))
                            if IsControlJustReleased(0, 38) then
                                OpenMotel(k)
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

local MotelNameDeisti = true
local motelBlips = {} 

RegisterNetEvent("oph3z-motels:client:MotelNameBlip", function()
    MotelNameDeisti = true
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if ScriptLoaded then
            if MotelNameDeisti then
                for _, blip in pairs(motelBlips) do
                    RemoveBlip(blip)
                end
                motelBlips = {}

                for key, v in pairs(Config.Motels) do
                    if v.Blip then
                        local blip = AddBlipForCoord(v.RentMotel.x, v.RentMotel.y, v.RentMotel.z)
                        SetBlipSprite(blip, v.BlipSettings.ID)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, v.BlipSettings.Scale)
                        SetBlipColour(blip, v.BlipSettings.Color)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(v.Name)
                        EndTextCommandSetBlipName(blip)
                        table.insert(motelBlips, blip) 
                    end
                end
                MotelNameDeisti = false
            end
        end
        Wait(sleep)
    end
end)


CreateThread(function()
    while true do
        local sleep = 1000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        if ScriptLoaded then
            for k,v in pairs(Config.Motels) do
                local employesExist = false
                if v.Employes ~= nil then
                    for key, value in pairs(v.Employes) do
                        employesExist = true 
                        if v.Owner == tostring(QBCore.Functions.GetPlayerData().citizenid) or value.Citizenid == tostring(QBCore.Functions.GetPlayerData().citizenid)  then
                            if #(PlayerCoords - v.OpenBossMenu) <= 2.0 then
                                sleep = 0
                                if Config.Data.UseTarget then
                                    targetboosmenuid = k
                                    UseTargetClient(v.OpenBossMenu, "oph3z-motel:client:UseTarget", "OpenBossMenu", "Open Boss Menu")
                                else 
                                    Config.DrawText3D("~INPUT_PICKUP~ - Open Boss Menu", vector3(v.OpenBossMenu.x, v.OpenBossMenu.y, v.OpenBossMenu.z))
                                    if IsControlJustReleased(0, 38) then
                                        OpenBossMenu(k)
                                    end
                                end
                            end
                        end
                    end
                end
                if not employesExist then
                    if v.Owner == tostring(QBCore.Functions.GetPlayerData().citizenid) then
                        if #(PlayerCoords - v.OpenBossMenu) <= 2.0 then
                            sleep = 0
                            if Config.Data.UseTarget then
                                targetboosmenuid = k
                                UseTargetClient(v.OpenBossMenu, "oph3z-motel:client:UseTarget", "OpenBossMenu", "Open Boss Menu")
                            else 
                                Config.DrawText3D("~INPUT_PICKUP~ - Open Boss Menu", vector3(v.OpenBossMenu.x, v.OpenBossMenu.y, v.OpenBossMenu.z))
                                if IsControlJustReleased(0, 38) then
                                    OpenBossMenu(k)
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)



RegisterNUICallback("CloseUI", function ()
    SetNuiFocus(false, false)
    RenderScriptCams(0, 0, 750, 1, 0)
    DestroyCam(cam, false)
end)


RegisterNUICallback("CloseUIRent", function ()
    SetNuiFocus(false, false)
    RenderScriptCams(0, 0, 750, 1, 0)
    DestroyCam(cam, false)
    TriggerServerEvent("oph3z-motels:server:RentMotelAcildi", id, false)
end)
RegisterNUICallback("CloseUIBoosmenu", function ()
    SetNuiFocus(false, false)
    RenderScriptCams(0, 0, 750, 1, 0)
    DestroyCam(cam, false)
    TriggerServerEvent("oph3z-motels:server:BossMenuAcildi", id, false)
end)

function AcceptMotelRoom(data)
    QBCore.Functions.TriggerCallback("oph3z-motels:server:RentRoom", function (export)
        if export then
            OpenMotel(CurrentMotel)
        end
    end, data)
end

CreateThread(function ()
    while true do 
        Citizenid = tostring(QBCore.Functions.GetPlayerData().citizenid)
        local sleep = 1000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        for k,v in pairs (Config.Motels) do
            for i, room in ipairs(v.Rooms) do
                local Friends = json.encode(room.Owner.Friends)
                local EmployesMenu = json.encode(v.Employes)
                if Friends ~= "[]"then
                    for i, data in ipairs(room.Owner.Friends) do
                        friendscitizenid = data.Citizenid
                        if EmployesMenu ~= "[]" then
                            for vf, employees in ipairs(v.Employes) do
                                if Config.Data.EmployesRoomSee then
                                    if employees then
                                        if room.Owner.RoomsOwner == Citizenid or v.Owner == Citizenid or employees.Citizenid == Citizenid or friendscitizenid == Citizenid then
                                            if #(PlayerCoords - vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z)) <= 2.0 then
                                                sleep = 0
                                                if Config.Data.UseTarget then
                                                    OdaTipi = tostring(v.Rooms[i].type..k)
                                                    OdaType = tostring(v.Rooms[i].type)
                                                    if employees.Citizenid == Citizenid and room.Owner.RoomsOwner ~= Citizenid then
                                                        OwnerMode = true
                                                    end
                                                    if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid then
                                                        OwnerMode = true
                                                    end
                                                    if OdaType == "VIP" then
                                                        OdaTheme = v.Rooms[i].theme
                                                        OdaStrip = v.Rooms[i].strip
                                                        OdaBooze = v.Rooms[i].booze

                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                            OdaTheme = OdaTheme,
                                                            OdaStrip = OdaStrip,
                                                            OdaBooze = OdaBooze
                                                        }
                                                    else
                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                        }
                                                    end
                                                    UseTargetClient(vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z), "oph3z-motel:client:UseTarget", "OpenRoom", "Open Room")
                                                else
                                                    if IsControlJustReleased(0, 38) then
                                                        Config.DrawText3D("~INPUT_PICKUP~ - Open Room", vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z))
                                                        if employees.Citizenid == Citizenid and room.Owner.RoomsOwner ~= Citizenid then
                                                            OwnerMode = true
                                                        end
                                                        if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid then
                                                            OwnerMode = true
                                                        end
                                                        local OdaTipi = tostring(v.Rooms[i].type..k)
                                                        local OdaType = tostring(v.Rooms[i].type)
                                                        if OdaType == "VIP" then
                                                            local OdaTheme = v.Rooms[i].theme
                                                            local OdaStrip = v.Rooms[i].strip
                                                            local OdaBooze = v.Rooms[i].booze
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", OdaTipi, OdaType, OdaTheme, OdaStrip, OdaBooze)
                                                        else
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", OdaTipi, OdaType)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if room.Owner.RoomsOwner == Citizenid or v.Owner == Citizenid or friendscitizenid == Citizenid then
                                            if #(PlayerCoords - vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z)) <= 2.0 then
                                                sleep = 0
                                                if Config.Data.UseTarget then
                                                    OdaTipi = tostring(v.Rooms[i].type..k)
                                                    OdaType = tostring(v.Rooms[i].type)
                                                    if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid then
                                                        OwnerMode = true
                                                    end
                                                    if OdaType == "VIP" then
                                                        OdaTheme = v.Rooms[i].theme
                                                        OdaStrip = v.Rooms[i].strip
                                                        OdaBooze = v.Rooms[i].booze

                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                            OdaTheme = OdaTheme,
                                                            OdaStrip = OdaStrip,
                                                            OdaBooze = OdaBooze
                                                        }
                                                    else
                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                        }
                                                    end
                                                    UseTargetClient(vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z), "oph3z-motel:client:UseTarget", "OpenRoom", "Open Room")
                                                else
                                                    Config.DrawText3D("~INPUT_PICKUP~ - Open Room", vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z))
                                                    if IsControlJustReleased(0, 38) then
                                                        if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid then
                                                            OwnerMode = true
                                                        end
                                                        local OdaTipi = tostring(v.Rooms[i].type..k)
                                                        local OdaType = tostring(v.Rooms[i].type)
                                                        if OdaType == "VIP" then
                                                            local OdaTheme = v.Rooms[i].theme
                                                            local OdaStrip = v.Rooms[i].strip
                                                            local OdaBooze = v.Rooms[i].booze
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType, OdaTheme, OdaStrip, OdaBooze) 
                                                        else
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    if Config.Data.OwnerRoomSee then
                                        if room.Owner.RoomsOwner == Citizenid or v.Owner == Citizenid or friendscitizenid == Citizenid then
                                            if #(PlayerCoords - vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z)) <= 2.0 then
                                                sleep = 0
                                                if Config.Data.UseTarget then
                                                    OdaTipi = tostring(v.Rooms[i].type..k)
                                                    OdaType = tostring(v.Rooms[i].type)
                                                    if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid then
                                                        OwnerMode = true
                                                    end
                                                    if OdaType == "VIP" then
                                                        OdaTheme = v.Rooms[i].theme
                                                        OdaStrip = v.Rooms[i].strip
                                                        OdaBooze = v.Rooms[i].booze

                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                            OdaTheme = OdaTheme,
                                                            OdaStrip = OdaStrip,
                                                            OdaBooze = OdaBooze
                                                        }
                                                    else
                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                        }
                                                    end
                                                    UseTargetClient(vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z), "oph3z-motel:client:UseTarget", "OpenRoom", "Open Room")
                                                else
                                                    Config.DrawText3D("~INPUT_PICKUP~ - Open Room", vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z))
                                                    if IsControlJustReleased(0, 38) then
                                                        if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid then
                                                            OwnerMode = true
                                                        end
                                                        local OdaTipi = tostring(v.Rooms[i].type..k)
                                                        local OdaType = tostring(v.Rooms[i].type)
                                                        if OdaType == "VIP" then
                                                            local OdaTheme = v.Rooms[i].theme
                                                            local OdaStrip = v.Rooms[i].strip
                                                            local OdaBooze = v.Rooms[i].booze
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType, OdaTheme, OdaStrip, OdaBooze) 
                                                        else
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if room.Owner.RoomsOwner == Citizenid or friendscitizenid == Citizenid then
                                            if #(PlayerCoords - vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z)) <= 2.0 then
                                                sleep = 0
                                                if Config.Data.UseTarget then
                                                    OdaTipi = tostring(v.Rooms[i].type..k)
                                                    OdaType = tostring(v.Rooms[i].type)
                                                    if OdaType == "VIP" then
                                                        OdaTheme = v.Rooms[i].theme
                                                        OdaStrip = v.Rooms[i].strip
                                                        OdaBooze = v.Rooms[i].booze

                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                            OdaTheme = OdaTheme,
                                                            OdaStrip = OdaStrip,
                                                            OdaBooze = OdaBooze
                                                        }
                                                    else
                                                        targetmoteldata = {
                                                            OdaTipi = OdaTipi,
                                                            OdaType = OdaType,
                                                        }
                                                    end
                                                    UseTargetClient(vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z), "oph3z-motel:client:UseTarget", "OpenRoom", "Open Room")
                                                else
                                                    Config.DrawText3D("~INPUT_PICKUP~ - Open Room", vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z))
                                                    if IsControlJustReleased(0, 38) then
                                                        local OdaTipi = tostring(v.Rooms[i].type..k)
                                                        local OdaType = tostring(v.Rooms[i].type)
                                                        if OdaType == "VIP" then
                                                            local OdaTheme = v.Rooms[i].theme
                                                            local OdaStrip = v.Rooms[i].strip
                                                            local OdaBooze = v.Rooms[i].booze
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType, OdaTheme, OdaStrip, OdaBooze) 
                                                        else
                                                            TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if Config.Data.OwnerRoomSee then
                                if room.Owner.RoomsOwner == Citizenid or v.Owner == Citizenid or friendscitizenid == Citizenid then
                                    if #(PlayerCoords - vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z)) <= 2.0 then
                                        sleep = 0
                                        if Config.Data.UseTarget then
                                            OdaTipi = tostring(v.Rooms[i].type..k)
                                            OdaType = tostring(v.Rooms[i].type)
                                            if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid  then
                                                OwnerMode = true
                                            end
                                            if OdaType == "VIP" then
                                                OdaTheme = v.Rooms[i].theme
                                                OdaStrip = v.Rooms[i].strip
                                                OdaBooze = v.Rooms[i].booze

                                                targetmoteldata = {
                                                    OdaTipi = OdaTipi,
                                                    OdaType = OdaType,
                                                    OdaTheme = OdaTheme,
                                                    OdaStrip = OdaStrip,
                                                    OdaBooze = OdaBooze
                                                }
                                            else
                                                targetmoteldata = {
                                                    OdaTipi = OdaTipi,
                                                    OdaType = OdaType,
                                                }
                                            end
                                            UseTargetClient(vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z), "oph3z-motel:client:UseTarget", "OpenRoom", "Open Room")
                                        else
                                            Config.DrawText3D("~INPUT_PICKUP~ - Open Room", vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z))
                                            if IsControlJustReleased(0, 38) then
                                                if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid and friendscitizenid ~= Citizenid  then
                                                    OwnerMode = true
                                                end
                                                local OdaTipi = tostring(v.Rooms[i].type..k)
                                                local OdaType = tostring(v.Rooms[i].type)
                                                if OdaType == "VIP" then
                                                    local OdaTheme = v.Rooms[i].theme
                                                    local OdaStrip = v.Rooms[i].strip
                                                    local OdaBooze = v.Rooms[i].booze
                                                    TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType, OdaTheme, OdaStrip, OdaBooze) 
                                                else
                                                    TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType)
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                if room.Owner.RoomsOwner == Citizenid or friendscitizenid == Citizenid then
                                    if #(PlayerCoords - vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z)) <= 2.0 then
                                        sleep = 0
                                        if Config.Data.UseTarget then
                                            OdaTipi = tostring(v.Rooms[i].type..k)
                                            OdaType = tostring(v.Rooms[i].type)
                                            if OdaType == "VIP" then
                                                OdaTheme = v.Rooms[i].theme
                                                OdaStrip = v.Rooms[i].strip
                                                OdaBooze = v.Rooms[i].booze

                                                targetmoteldata = {
                                                    OdaTipi = OdaTipi,
                                                    OdaType = OdaType,
                                                    OdaTheme = OdaTheme,
                                                    OdaStrip = OdaStrip,
                                                    OdaBooze = OdaBooze
                                                }
                                            else
                                                targetmoteldata = {
                                                    OdaTipi = OdaTipi,
                                                    OdaType = OdaType,
                                                }
                                            end
                                            UseTargetClient(vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z), "oph3z-motel:client:UseTarget", "OpenRoom", "Open Room")
                                        else
                                            Config.DrawText3D("~INPUT_PICKUP~ - Open Room", vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z))
                                            if IsControlJustReleased(0, 38) then
                                                local OdaTipi = tostring(v.Rooms[i].type..k)
                                                local OdaType = tostring(v.Rooms[i].type)
                                                if OdaType == "VIP" then
                                                    local OdaTheme = v.Rooms[i].theme
                                                    local OdaStrip = v.Rooms[i].strip
                                                    local OdaBooze = v.Rooms[i].booze
                                                    TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType, OdaTheme, OdaStrip, OdaBooze) 
                                                else
                                                    TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if room.Owner.RoomsOwner == Citizenid or v.Owner == Citizenid then
                        if #(PlayerCoords - vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z)) <= 2.0 then
                            sleep = 0
                                if Config.Data.UseTarget then
                                    OdaTipi = tostring(v.Rooms[i].type..k)
                                    OdaType = tostring(v.Rooms[i].type)
                                    if OdaType == "VIP" then
                                        OdaTheme = v.Rooms[i].theme
                                        OdaStrip = v.Rooms[i].strip
                                        OdaBooze = v.Rooms[i].booze
                                        targetmoteldata = {
                                            odadataone = k,
                                            odadatawtow = i,
                                            OdaTipi = OdaTipi,
                                            OdaType = OdaType,
                                            OdaTheme = OdaTheme,
                                            OdaStrip = OdaStrip,
                                            OdaBooze = OdaBooze
                                        }
                                    else
                                        targetmoteldata = {
                                            odadataone = k,
                                            odadatawtow = i,
                                            OdaTipi = OdaTipi,
                                            OdaType = OdaType,
                                        }
                                    end
                                    if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid then
                                        OwnerMode = true
                                    end
                                    UseTargetClient(vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z), "oph3z-motel:client:UseTarget", "OpenRoom", "Open Room")
                                else
                                    
                                    Config.DrawText3D("~INPUT_PICKUP~ - Open Room", vector3(v.Rooms[i].Coords.x, v.Rooms[i].Coords.y, v.Rooms[i].Coords.z))
                                if IsControlJustReleased(0, 38) then
                                    if v.Owner == Citizenid and room.Owner.RoomsOwner ~= Citizenid then
                                        OwnerMode = true
                                    end
                                    local OdaTipi = tostring(v.Rooms[i].type..k)
                                    local OdaType = tostring(v.Rooms[i].type)
                                    if OdaType == "VIP" then
                                        local OdaTheme = v.Rooms[i].theme
                                        local OdaStrip = v.Rooms[i].strip
                                        local OdaBooze = v.Rooms[i].booze
                                        TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType, OdaTheme, OdaStrip, OdaBooze) 
                                    else
                                        TriggerServerEvent("oph3z-motels:server:OpenRoom", k, i, OdaTipi, OdaType)
                                    end
                                end
                            end
                        end
                    end
                end
            end 
        end
        Wait(sleep)
    end
end)

RegisterCommand("motelodasinda", function ()
    Motelid = 1
    Odano = 3
    OdaType = "Squatter"

    motelodasinda = true
    -- Config.StashFunction(Motelid, Odano, OdaType)
end)

CreateThread(function ()
    while true do
        sleep = 0
        if motelodasinda then
            sleep = 0
            local Player = PlayerPedId()
            local PlayerCoords = GetEntityCoords(Player)
            for k, v in pairs(Config.Maps) do
                Exit = #(PlayerCoords - v.out)
                Stash = #(PlayerCoords - v.stash)
                Manage = #(PlayerCoords - v.manage)
                Wardrobe = #(PlayerCoords - v.wardrobe)
                if Exit <= 2.0 then
                    sleep = 0
                    if Config.Data.UseTarget then
                        UseTargetClient(vector3(v.out.x, v.out.y, v.out.z), "oph3z-motel:client:UseTarget", "ExitRoom", "Exit")
                    else
                        Config.DrawText3D("~INPUT_PICKUP~ - Exit", vector3(v.out.x, v.out.y, v.out.z ))
                        if sleep == 0 and IsControlJustReleased(0, 38) then
                            TriggerServerEvent("oph3z-motels:server:ExitRoom", Motelid, Odano)
                        end
                    end
                end
                if Stash <= 2.0 then
                    if not OwnerMode then
                        sleep = 0
                        if Config.Data.UseTarget then
                            UseTargetClient(vector3(v.stash.x, v.stash.y, v.stash.z), "oph3z-motel:client:UseTarget", "Stash", "Stash")
                        else
                            Config.DrawText3D("~INPUT_PICKUP~ - Stash", vector3(v.stash.x, v.stash.y, v.stash.z))
                            if IsControlJustReleased(0, 38) then
                                Wait(100)
                                print("exit")
                                Config.StashFunction(Motelid, Odano, OdaType)
                            end
                        end

                    end
                end
                if Config.Data.CustomersManage then
                    if Manage <= 2.0 then
                        if not OwnerMode then
                            sleep = 0
                            if Config.Data.UseTarget then
                                UseTargetClient(vector3(v.manage.x, v.manage.y, v.manage.z), "oph3z-motel:client:UseTarget", "Manage", "Manage")
                            else
                                Config.DrawText3D("~INPUT_PICKUP~ - Manage", vector3(v.manage.x, v.manage.y, v.manage.z))
                                if IsControlJustReleased(0, 38) then
                                    ManageFunction(Motelid, Odano, OdaType, odatipi, OdaTheme)
                                end
                            end
                        end
                    end
                end
                if Wardrobe <= 2.0 then
                    if not OwnerMode then
                        sleep = 0
                        if Config.Data.UseTarget then
                            UseTargetClient(vector3(v.wardrobe.x, v.wardrobe.y, v.wardrobe.z), "oph3z-motel:client:UseTarget", "Wardrobe", "Wardrobe")
                        else
                            Config.DrawText3D("~INPUT_PICKUP~ - Wardrobe", vector3(v.wardrobe.x, v.wardrobe.y, v.wardrobe.z))
                            if IsControlJustReleased(0, 38) then
                                Config.WardrobeFunction()
                            end
                        end
                    end
                end
            end
        else
            Wait(sleep)
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("oph3z-motels:client:AdamYoruyorsunuz", function (NewMotelid, NewOdano, NewOdaType, NewOdaTipi, NewOdatasarimi,OdaStrip, OdaBooze)
    local Player = PlayerPedId()
    local PlayerCoords = GetEntityCoords(Player)
    Motelid = NewMotelid
    Odano = NewOdano
    OdaType = NewOdaType
    odatipi = NewOdaTipi
    motelodasinda = true
    Odatasarimi = NewOdatasarimi
    OdaStrip = OdaStrip
    OdaBooze = OdaBooze
    if OdaType == "VIP" then
        Exit = #(PlayerCoords - Config.Maps[odatipi].out)
        if Exit <= 35 then
            if Odatasarimi ~= nil then
                local exportname = Config.Maps[odatipi].exportName
                DoScreenFadeOut(500)
                Wait(400)
                FreezeEntityPosition(Player, true)
                local apartmentObject = exports['bob74_ipl'][exportname]()
                interiorID = GetInteriorAtCoords(GetEntityCoords(PlayerPedId()))
                local selectedTheme = nil
                for themeName, themeData in pairs(Config.Maps[odatipi].ThemeData) do
                    if themeName == Odatasarimi then
                        selectedTheme = themeData
                        break
                    end
                end
                
                if selectedTheme ~= nil then
                    apartmentObject.Style.Set(selectedTheme, true)
                    RefreshInterior(interiorID)
                end
                if odastrip then
                    apartmentObject.Strip.Enable({
                        apartmentObject.Strip.A,
                        apartmentObject.Strip.B,
                        apartmentObject.Strip.C
                    }, true)
                    RefreshInterior(interiorID)
                end
        
                if odabooze then
                    apartmentObject.Booze.Enable({
                        apartmentObject.Booze.A,
                        apartmentObject.Booze.B,
                        apartmentObject.Booze.C
                    }, true)
                    RefreshInterior(interiorID)
                end
                SetEntityCoords(PlayerPedId(), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z-1, 0, 0, 0, false)
                FreezeEntityPosition(Player, false)
                Wait(400)
                DoScreenFadeIn(1000)
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:client:OdaBitti", function (odmid)
    for k,v in pairs(Config.Motels) do
        if v.Motelid == odmid then
            local Player = PlayerPedId()
            Wait(400)
            DoScreenFadeOut(500)
            Wait(400)
            FreezeEntityPosition(Player, true)
            SetEntityCoords(Player, v.RentMotel.x, v.RentMotel.y, v.RentMotel.z-1.0)
            Wait(400)
            FreezeEntityPosition(Player, false)
            DoScreenFadeIn(1000)
        end
    end
end)

RegisterNetEvent("oph3z-motels:client:OpenRoom", function (motelno, odano, odatipi, odatype, odatheme, odastrip, odabooze)
    if odatheme == nil then
        local Player = PlayerPedId()
        DoScreenFadeOut(500)
        Wait(400)
        SetEntityCoords(Player, Config.Maps[odatipi].out.x, Config.Maps[odatipi].out.y, Config.Maps[odatipi].out.z-1.0)
        Wait(400)
        DoScreenFadeIn(1000)
    else
        local exportname = Config.Maps[odatipi].exportName
        local Player = PlayerPedId()
        DoScreenFadeOut(500)
        Wait(400)
        SetEntityCoords(Player, Config.Maps[odatipi].out.x, Config.Maps[odatipi].out.y, Config.Maps[odatipi].out.z-1.0)
        FreezeEntityPosition(Player, true)
        Wait(200)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local apartmentObject = exports['bob74_ipl'][exportname]()
        interiorID = GetInteriorAtCoords(GetEntityCoords(PlayerPedId()))
        local selectedTheme = nil

        for themeName, themeData in pairs(Config.Maps[odatipi].ThemeData) do
            if themeName == odatheme then
                selectedTheme = themeData
                break
            end
        end

        if selectedTheme ~= nil then
            apartmentObject.Style.Set(selectedTheme, true)
            RefreshInterior(interiorID)
        end

        if odastrip then
            apartmentObject.Strip.Enable({
                apartmentObject.Strip.A,
                apartmentObject.Strip.B,
                apartmentObject.Strip.C
            }, true)
            RefreshInterior(interiorID)
        end

        if odabooze then
            apartmentObject.Booze.Enable({
                apartmentObject.Booze.A,
                apartmentObject.Booze.B,
                apartmentObject.Booze.C
            }, true)
            RefreshInterior(interiorID)
        end

        SetEntityCoords(PlayerPedId(), playerCoords.x, playerCoords.y, playerCoords.z-1, 0, 0, 0, false)
        FreezeEntityPosition(Player, false)
        Wait(400)
        DoScreenFadeIn(1000)
    end
    Motelid = motelno
    Odano = odano
    OdaType = odatype
    odatipi = odatipi
    odatheme = odatheme
    motelodasinda = true
end)

RegisterNetEvent("oph3z-motels:client:ExitRoom", function()
    local Player = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(400)
    SetEntityCoords(Player, Config.Motels[Motelid].Rooms[Odano].Coords.x, Config.Motels[Motelid].Rooms[Odano].Coords.y, Config.Motels[Motelid].Rooms[Odano].Coords.z-1.0)
    SetEntityHeading(Player, Config.Motels[Motelid].Rooms[Odano].Coords.w)
    Wait(400)
    Motelid = nil
    Odano = nil
    Odatasarimi = nil
    OdaType = nil
    odatipi = nil
    motelodasinda = false
    OwnerMode = false
    DoScreenFadeIn(1000)
end)

function OpenBuyMenu()
    local data = {
        motel = Config.Motels,
        motelcount = #Config.Motels,
    }
    SendNUIMessage({
        type = "OpenBuyMenu",
        data = data,
        translate = Config.Lang
    })
    SetNuiFocus(true, true)
end
local buymotelcoords = nil
CreateThread(function ()
    while true do
        local sleep = 1000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        if Config.Data.BuyMotelPass then
            if #(PlayerCoords - vector3(Config.Data.BuyMotel.x, Config.Data.BuyMotel.y, Config.Data.BuyMotel.z)) <= 2.0 then
                sleep = 0
                if Config.Data.UseTarget then
                    UseTargetClient(vector3(Config.Data.BuyMotel.x, Config.Data.BuyMotel.y, Config.Data.BuyMotel.z), "oph3z-motel:client:UseTarget", "BuyMotel", "Buy Motel")
                else
                    Config.DrawText3D("~INPUT_PICKUP~ - Buy Motel", vector3(Config.Data.BuyMotel.x, Config.Data.BuyMotel.y, Config.Data.BuyMotel.z))
                    if IsControlJustReleased(0, 38) then
                        buymotelcoords = GetEntityCoords(PlayerPedId())
                        OpenBuyMenu()
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("oph3z-motels:client:InvitePlayerRequest", function(data, sendername) 
    SendNUIMessage({
        type = "SendRoomInviteRequest",
        data = data,
        sendernameRoom = sendername,
        translate = Config.Lang
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("oph3z-motels:client:InvitePlayerRequestFriends", function (data, sendername)
    SendNUIMessage({
        type = "SendRoomFriendsRequest",
        data = data,
        sendernameRoom = sendername,
        translate = Config.Lang
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("oph3z-motels:client:TransferMotelRequest", function(data, sendername)
    SendNUIMessage({
        type = "SendTransferMotelUI",
        data = data,
        sendernameRoom = sendername,
        translate = Config.Lang
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("oph3z-motels:client:NearbyRequest", function(data, sendername)
    SendNUIMessage({
        type = "SendNearbyRequest",
        data = data,
        sendername = sendername,
        translate = Config.Lang
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("oph3z-motels:client:InviteEmployee", function(data, sendername)
    SendNUIMessage({
        type = "SendInviteEmployee",
        data = data,
        sendername = sendername,
        translate = Config.Lang
    })
    SetNuiFocus(true, true)
end)



ManageFunction = function (data1, Odano, OdaType)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local playerCitizenId = tostring(PlayerData.citizenid)
    for k, v in pairs(Config.Motels) do
        if data1 == v.Motelid then
            VIPUpgradeMoney = v.VIPUpgradeMoney
            MiddleUpgradeMoney = v.MiddleUpgradeMoney
            for i, room in ipairs(v.Rooms) do
                if Odano == room.motelno then
                    StyleMenu = room.StyleMenu
                    Coords = room.Coords
                    Friends = room.Owner.Friends
                    Date = room.Owner.Date
                    SaatlikPrice = room.money
                    odaTheme = room.theme
                    Motelname = v.Name
                    Strip = room.strip
                    Booze = room.booze
                end
            end
        end
    end

    SendNUIMessage({
        type = "MotelManagement",
        MotelNo = data1,
        dataR = data,
        OdanoR = Odano,
        OdaTypeR = OdaType,
        Coords = Coords,
        stylemenu = StyleMenu,
        Friends = Friends,
        Date = Date,
        SaatlikPrice = SaatlikPrice,
        odaTheme = odaTheme,
        Motelname = Motelname,
        Strip = Strip,
        Booze = Booze,
        MiddleUpgradeMoney = MiddleUpgradeMoney ,
        VIPUpgradeMoney = VIPUpgradeMoney,
        translate = Config.Lang
    })
    SetNuiFocus(true, true)
end

RegisterNetEvent("oph3z-motels:client:SendMail", function(sender, subject,messege,button)
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
        subject = subject,
        message = messege,
        button = button
    })
end)

function CurrentMotelBuy(data)
    TriggerServerEvent("oph3z-motels:server:BuyMotel", data)
end

function MotelNoCekme(data)
    local MotelData = Config.Motels[data.motelno]
    local PlayerPed = PlayerPedId()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(cam, true)
    RenderScriptCams(1, 1, 750, 1, 0)
    SetEntityCoords(PlayerPed, MotelData.MotelCamDashboard.x, MotelData.MotelCamDashboard.y, MotelData.MotelCamDashboard.z)
    SetEntityHeading(PlayerPed, MotelData.MotelCamDashboard.w)
    FreezeEntityPosition(PlayerPed, true)
    SetEntityVisible(PlayerPed, false)
    SetCamCoord(cam, MotelData.MotelCamDashboard.x, MotelData.MotelCamDashboard.y, MotelData.MotelCamDashboard.z)
    SetCamRot(cam, 0.0, 0.0, MotelData.MotelCamDashboard.w)
    RenderScriptCams(true, false, 0, true, true)
end

RegisterNUICallback("CloseUIBuy", function ()
    SetNuiFocus(false, false)
    RenderScriptCams(0, 0, 750, 1, 0)
    DestroyCam(cam, false)
    SetEntityCoords(PlayerPedId(), buymotelcoords.x, buymotelcoords.y, buymotelcoords.z-1)
    SetEntityVisible(PlayerPedId(), true)
    FreezeEntityPosition(PlayerPedId(), false)
    buymotelcoords = nil
end)

RegisterNetEvent("oph3z-motels:OpenBossMenu", function (id)
    
    OpenBossMenu(id)
end)

RegisterNetEvent("oph3z-motels:RentMotel", function (id)
    OpenMotel(id)
end)

function SaveDashboard(data)
    TriggerServerEvent("oph3z-motels:server:SaveDashboard", data)
end

function CompanyMoney(data)
    TriggerServerEvent("oph3z-motels:server:CompanyMoney", data)
end

RegisterNetEvent("oph3z-motels:OpenManagement", function () 
    ManageFunction(Motelid, Odano, OdaType)
end)

function KickCustomer(data)
    TriggerServerEvent("oph3z-motels:server:KickCustomer", data)
end

function KickEmployee(data)
    TriggerServerEvent("oph3z-motels:server:KickEmployee", data)
end

function RankUp(data)
    TriggerServerEvent("oph3z-motels:server:RankUp", data)
end

function RankDown(data)
    TriggerServerEvent("oph3z-motels:server:RankDown", data)
end

function NerabyPlayers(data)
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if data.employees then
        if distance ~= -1 and distance <= 3.0 then
            QBCore.Functions.TriggerCallback("oph3z-motels:server:PlayerName", function(name)
                SendNUIMessage({
                    type = "LoadPlayers",
                    players = name,
                })
    
            end, GetPlayerServerId(player))
        end
    elseif data.management then
        if distance ~= -1 and distance <= 3.0 then
            QBCore.Functions.TriggerCallback("oph3z-motels:server:PlayerName", function(name)
                SendNUIMessage({
                    type = "LoadPlayers",
                    players = name,
                })
            end, GetPlayerServerId(player))
        end
    elseif data.managementDoor then
        if data.Coords ~= nil then
            Coords = vector3(data.Coords.x, data.Coords.y, data.Coords.z)
            QBCore.Functions.TriggerCallback("oph3z-motels:server:RoomInvite", function(name)
                SendNUIMessage({
                    type = "LoadPlayers1",
                    RoomInvite = name,
                })
            end, Coords)
        end
    else
        if distance ~= -1 and distance <= 3.0 then
            QBCore.Functions.TriggerCallback("oph3z-motels:server:PlayerName", function(name)
                SendNUIMessage({
                    type = "LoadPlayers",
                    players = name,
                })
            end, GetPlayerServerId(player))
        end
    end
end

function NearbyAccept(data)
    TriggerServerEvent("oph3z-motels:server:NearbyAccept", data)
end

function NearbyRequest(data)
    TriggerServerEvent("oph3z-motels:server:NearbyRequest", data)
end

function InviteEmployee(data)
    TriggerServerEvent("oph3z-motels:server:InviteEmployee", data)
end

function JobOfferAccepted(data)
    TriggerServerEvent("oph3z-motels:server:JobOfferAccepted", data)
end

function RepairRoom(data)
    TriggerServerEvent("oph3z-motels:server:RepairRoom", data)
end

function UpgradeRoom(data)
    TriggerServerEvent("oph3z-motels:server:UpgradeRoom", data)
end

function ChangeSalary(data)
    TriggerServerEvent("oph3z-motels:server:ChangeSalary", data)
end

function AddFriend(data)
    TriggerServerEvent("oph3z-motels:server:AddFriend", data)
end

function KickFriends(data)
    TriggerServerEvent("oph3z-motels:server:KickFriends", data)
end

function InvitePlayerRequest(data)
    TriggerServerEvent("oph3z-motels:server:InvitePlayerRequest", data) 
end

function InvitePlayerRequestFriends(data)
    TriggerServerEvent("oph3z-motels:server:InvitePlayerRequestFriends", data)
end

function UpHours(data)
    TriggerServerEvent("oph3z-motels:server:UpHours", data)
end

function RoomInviteAccept(data)
    TriggerServerEvent("oph3z-motels:server:RoomInviteAccept", data)
end

function UpgradeRoomRequest(data)
    TriggerServerEvent("oph3z-motels:server:UpgradeRoomRequest", data)
end

function AcceptRequste(data)
    TriggerServerEvent("oph3z-motels:server:AcceptRequste", data)
end

function CancelRequest(data)
    TriggerServerEvent("oph3z-motels:server:CancelRequest", data)
end

function SellMotel(data)
    if Config.Data.SellMotelPass then
        TriggerServerEvent("oph3z-motels:server:SellMotel", data)
    else
        Config.Notify(Config.Langue["NotPermissionsMotelSell"][1], Config.Langue["NotPermissionsMotelSell"][2], Config.Langue["NotPermissionsMotelSell"][3])
    end
end

function MotelTransferAccept(data)
    if Config.Data.TransferPass then
        TriggerServerEvent("oph3z-motels:server:TransferMotel", data)
    else
        Config.Notify(Config.Langue["NotPermissionsMotelTransfer"][1], Config.Langue["NotPermissionsMotelTransfer"][2], Config.Langue["NotPermissionsMotelTransfer"][3])
    end
end

function MotelTransferRequest(data)
    TriggerServerEvent("oph3z-motels:server:MotelTransferRequest", data)
end

RegisterNUICallback("CurrentMotelBuy", CurrentMotelBuy)
RegisterNUICallback("MotelNoCekme", MotelNoCekme)
RegisterNUICallback("SaveDashboard", SaveDashboard)
RegisterNUICallback("AcceptMotelRoom", AcceptMotelRoom)
RegisterNUICallback("CompanyMoney", CompanyMoney)
RegisterNUICallback("KickCustomer", KickCustomer)
RegisterNUICallback("KickEmployee", KickEmployee)
RegisterNUICallback("RankUp", RankUp)
RegisterNUICallback("RankDown", RankDown)
RegisterNUICallback("NerabyPlayers", NerabyPlayers)
RegisterNUICallback("NearbyRequest", NearbyRequest)
RegisterNUICallback("NearbyAccept", NearbyAccept)
RegisterNUICallback("InviteEmployee", InviteEmployee)
RegisterNUICallback("JobOfferAccepted", JobOfferAccepted)
RegisterNUICallback("RepairRoom", RepairRoom)
RegisterNUICallback("UpgradeRoom", UpgradeRoom)
RegisterNUICallback("ChangeSalary", ChangeSalary)
RegisterNUICallback("AddFriend", AddFriend)
RegisterNUICallback("KickFriends", KickFriends)
RegisterNUICallback("InvitePlayerRequest", InvitePlayerRequest)
RegisterNUICallback("InvitePlayerRequestFriends", InvitePlayerRequestFriends)
RegisterNUICallback("UpHours", UpHours)
RegisterNUICallback("RoomInviteAccept", RoomInviteAccept)
RegisterNUICallback("UpgradeRoomRequest", UpgradeRoomRequest)
RegisterNUICallback("AcceptRequste", AcceptRequste)
RegisterNUICallback("CancelRequest", CancelRequest)
RegisterNUICallback("SellMotel", SellMotel)
RegisterNUICallback("MotelTransferRequest", MotelTransferRequest)
RegisterNUICallback("MotelTransferAccept", MotelTransferAccept)