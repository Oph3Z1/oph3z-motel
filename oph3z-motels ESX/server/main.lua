motelacanlar = {}
motelacanlar2 = {}

RegisterNetEvent("oph3z-motels:server:BossMenuAcildi", function (id, acildi)
    if acildi then
        local src = source
        local kayitVar = false
        for _, value in ipairs(motelacanlar) do
            if value.source == src and value.Motelno == id then
                kayitVar = true
                break
            end
        end

        if not kayitVar then
            motelacanlar[#motelacanlar+1] = {
                source = src,
                Motelno = id,
            }
        end
    else
 
        for index, value in ipairs(motelacanlar) do
            if value.source == source then
                table.remove(motelacanlar, index)
                break  -- Döngüyü sonlandır
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:RentMotelAcildi", function(id, acildi)
    local src = source
    local kayitVarMotel = false
    for _, value in ipairs(motelacanlar2) do
        if value.source == src and value.Motelno == id then
            kayitVarMotel = true
            break
        end
    end

    if acildi then
        if not kayitVarMotel then
            motelacanlar2[#motelacanlar2+1] = {
                source = src,
                Motelno = id,
            }
        end
    else
        for index, value in ipairs(motelacanlar2) do
            if value.source == src then
                table.remove(motelacanlar2, index)
                break 
            end
        end
    end
end)

local KisilerinVerileri = {}
ScriptLoaded = false

function StartScript()
    Wait(200)
    local existingMotels = {}
    for motelKey, motelValue in pairs(Config.Motels) do
        Wait(100)
        local info = {
            Name = motelValue.Name,
            Owner = "",
            CompanyMoney = motelValue.CompanyMoney,
            Motelid = motelValue.Motelid,
            TotalRooms = motelValue.TotalRooms,--silinebilir
            ActiveRooms = motelValue.ActiveRooms,--silinebilir
            DamagedRooms = motelValue.DamagedRooms, --silinebilir
        }
        local bucketCache = {}
        local employees = {}
        local history = {}
        local allRooms = {}

        if Config.Data.Database == "ghmattimysql" then
            motelData = exports.ghmattimysql:executeSync('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = motelKey})
        else
            motelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = motelKey})
        end

        if #motelData == 0 and not existingMotels[motelKey] then

            for roomKey, roomValue in pairs(motelValue.Rooms) do
                table.insert(allRooms, roomValue)
            end

            if Config.Data.Database == "ghmattimysql" then
                exports.ghmattimysql:execute('INSERT INTO `oph3z_motel` (id, info, rooms, employees, names, history, bucketcache) VALUES (@id, @info, @rooms, @employees, @names, @history, @bucketcache)', {
                    ["@id"] = motelKey,
                    ["@info"] = json.encode(info),
                    ["@rooms"] = json.encode(allRooms),
                    ["@employees"] = json.encode(employees),
                    ["@bucketcache"] = json.encode(bucketCache),
                    ["@history"] = json.encode(history),
                    ["@names"] = json.encode(info.Name)
                })
            else
                MySQL.Async.execute('INSERT INTO `oph3z_motel` (id, info, rooms, employees, names, history, bucketcache) VALUES (@id, @info, @rooms, @employees, @names, @history, @bucketcache)', {
                    ["@id"] = motelKey,
                    ["@info"] = json.encode(info),
                    ["@rooms"] = json.encode(allRooms),
                    ["@employees"] = json.encode(employees),
                    ["@bucketcache"] = json.encode(bucketCache),
                    ["@history"] = json.encode(history),
                    ["@names"] = json.encode(info.Name)
                })
            end

            existingMotels[motelKey] = true
        end
        LoadData()
    end
end

function RequestNewData()
    local source = source
    LoadData()
    TriggerClientEvent("oph3z-motels:Update", source, Config.Motels, ScriptLoaded)
end

RegisterNetEvent("oph3z-motels:ReqData", RequestNewData)

function LoadData()
    if Config.Data.Database == "ghmattimysql" then
        MotelData = exports.ghmattimysql:execute('SELECT * FROM `oph3z_motel`')
    else
        MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel`')
    end

    for k, v in ipairs(MotelData) do
        local info = json.decode(v.info)
        local rooms = json.decode(v.rooms)
        Config.Motels[k].Owner = info.Owner
        Config.Motels[k].Name = info.Name
        Config.Motels[k].CompanyMoney = info.CompanyMoney
        Config.Motels[k].TotalRooms = info.TotalRooms
        Config.Motels[k].ActiveRooms = info.ActiveRooms
        Config.Motels[k].DamagedRooms = info.DamagedRooms
        Config.Motels[k].Employes = json.decode(v.employees)
        Config.Motels[k].Rooms = json.decode(v.rooms)
        Config.Motels[k].History = json.decode(v.history)
    end 
    ScriptLoaded = true
end

Citizen.CreateThread(StartScript)

ESX.RegisterServerCallback("oph3z-motels:server:RentRoom", function (source, cb, data)
    local current_time = os.time()
    local hours_to_add = data.time
    local future_time = current_time + (hours_to_add * 3600)
    local future_hour = tonumber(os.date("%H", future_time))
    if future_hour >= 24 then
        future_time = future_time + (24 * 3600)
    end

    local NewDate = os.date("%Y-%m-%d %H:%M:%S", future_time)
    local id = data.motelid
    local Player = ESX.GetPlayerFromId(source)
    local identifer = Player.getIdentifier()
    local para =  math.ceil(data.price)
    if Player then
        if Player.getAccount(Config.Data.Moneytype).money >= tonumber(para) then

            if Config.Data.Database == "ghmattimysql" then
                MotelData = exports.ghmattimysql:executeSync('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
            else
                MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
            end

            if MotelData and #MotelData > 0 then
                local v = MotelData[1]
                local rooms = json.decode(v.rooms)
                local Info = json.decode(v.info)
                local room = rooms[tonumber(data.motelno)]
                
                local ownedRooms = 0
                for _, r in pairs(rooms) do
                    if r.Owner.RoomsOwner == identifer then
                        ownedRooms = ownedRooms + 1
                    end
                end

                if ownedRooms >= Config.Data.NoOwnedRentMotelAmount then
                    Config.ServerNotify(Player.source, Config.Langue["MaxMotelRoomLimit"](Config.Data.NoOwnedRentMotelAmount)[1], Config.Langue["MaxMotelRoomLimit"](Config.Data.NoOwnedRentMotelAmount)[2], Config.Langue["MaxMotelRoomLimit"](Config.Data.NoOwnedRentMotelAmount)[3])
                    cb(false)
                    return
                end

                Playerdetayls = Config.GetPlayer(identifer)

                Info.CompanyMoney = Info.CompanyMoney + tonumber(para)
                room.Rent = true
                room.Owner.RoomsOwner = identifer
                room.Owner.Name = Playerdetayls.firstname
                room.Owner.Lastname = Playerdetayls.lastname
                room.Owner.PhoneNumber = Playerdetayls.phone
                room.Owner.MyMoney =  tonumber(para)
                room.Owner.Date = tostring(NewDate)
                room.Owner.Friends = {}
                Config.Motels[id].Rooms = rooms
                Config.Motels[id].CompanyMoney = Info.CompanyMoney
                if Config.Data.Database == "ghmattimysql" then
                    exports.ghmattimysql:execute('UPDATE `oph3z_motel` SET rooms = @rooms, info = @info WHERE id = @id', {
                        ["@id"] = id,
                        ["@rooms"] = json.encode(Config.Motels[id].Rooms),
                        ["@info"] = json.encode(Info),
                    })
                else
                    MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms, info = @info WHERE id = @id', {
                        ["@id"] = id,
                        ["@rooms"] = json.encode(Config.Motels[id].Rooms),
                        ["@info"] = json.encode(Info),
                    })
                end

                TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                
                local mnewveri = motelacanlar2
                for i = 1, #mnewveri, 1 do
                    local motel = mnewveri[i]
                    local motelno = motel.Motelno
                    if id == motelno then
                        local source = motel.source
                        TriggerClientEvent("oph3z-motels:RentMotel", source, motelno)
                    end
                end
                cb(true)
                Config.ServerNotify(Player.source, Config.Langue["RentMotel"](data.motelno)[1], Config.Langue["RentMotel"](data.motelno)[2], Config.Langue["RentMotel"](data.motelno)[3])
            end
            Player.removeAccountMoney(Config.Data.Moneytype, tonumber(para))
        else
            Config.ServerNotify(Player.source, Config.Langue["NotEnoughMoney"][1], Config.Langue["NotEnoughMoney"][2], Config.Langue["NotEnoughMoney"][3])
            return
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:UpHours", function(data)
    local id = tonumber(data.motelno)
    local roomno = tonumber(data.odano)
    local ekhours = tonumber(data.time)
    local price = tonumber(data.price)
    local src = source

    if Config.Data.Database == "ghmattimysql" then
        MotelData = exports.ghmattimysql:executeSync('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    else
        MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    end

    local v = MotelData[1]
    local rooms = json.decode(v.rooms)
    local Info = json.decode(v.info)
    local room = rooms[tonumber(roomno)]
    local Player = ESX.GetPlayerFromId(src)
    local SonMaasTarihi = room.Owner.Date
    local hours_to_add = ekhours
    local future_time1 = os.time{year=tonumber(SonMaasTarihi:sub(1,4)), month=tonumber(SonMaasTarihi:sub(6,7)), day=tonumber(SonMaasTarihi:sub(9,10)), hour=tonumber(SonMaasTarihi:sub(12,13)), min=tonumber(SonMaasTarihi:sub(15,16)), sec=tonumber(SonMaasTarihi:sub(18,19))}
    future_time1 = future_time1 + (hours_to_add * 3600)
    local future_hour = tonumber(os.date("%H", future_time1))
    if future_hour >= 24 then
        future_time1 = future_time1 + (24 * 3600)
    end

    kesilecekprice = tonumber(price) / (1 + tonumber(#room.Owner.Friends))
    local YeniRentTime = os.date("%Y-%m-%d %H:%M:%S", future_time1)
    if Player.getAccount(Config.Data.Moneytype).money >= tonumber(price) then
        Info.CompanyMoney = Info.CompanyMoney + tonumber(data.price)
        room.Owner.Date = tostring(YeniRentTime)
        local totalFriendCount = #room.Owner.Friends
        if #room.Owner.Friends == 0 then
            Player.removeAccountMoney(Config.Data.Moneytype, tonumber(kesilecekprice))
        else
            totalFriendCount = totalFriendCount+1
            local friendCut = tonumber(price) / tonumber(totalFriendCount)
            for _, friend in pairs(room.Owner.Friends) do
                local friendPlayer = ESX.GetPlayerFromIdentifier(friend.Citizenid)
                if friendPlayer.Offline == false then
                    friendPlayer.removeAccountMoney(Config.Data.Moneytype, tonumber(friendCut))
                else
                    local PlayerData = GetOfflinePlayer(friend.Citizenid)
                    if PlayerData then
                        if Config.Data.Moneytype == "bank" then
                            para = PlayerData.accounts.bank
                            PlayerData.accounts.bank = PlayerData.accounts.bank + 1000000
                        else
                            PlayerData.accounts.money = PlayerData.accounts.money + 9000000
                        end
                        SaveOffline(PlayerData)
                    end
                end
                Player.removeAccountMoney(Config.Data.Moneytype, tonumber(friendCut))
            end
        end
    else
        Config.ServerNotify(Player.source, Config.Langue["NotEnoughMoney"][1], Config.Langue["NotEnoughMoney"][2], Config.Langue["NotEnoughMoney"][3])
        return
    end
    Config.Motels[id].Rooms = rooms
    Config.Motels[id].CompanyMoney = Info.CompanyMoney
    if Config.Data.Database == "ghmattimysql" then
        exports.ghmattimysql:execute('UPDATE `oph3z_motel` SET rooms = @rooms, info = @info WHERE id = @id', {
            ["@id"] = id,
            ["@rooms"] = json.encode(Config.Motels[id].Rooms),
            ["@info"] = json.encode(Info),
        })
    else
        MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms, info = @info WHERE id = @id', {
            ["@id"] = id,
            ["@rooms"] = json.encode(Config.Motels[id].Rooms),
            ["@info"] = json.encode(Info),
        })
    end


    Config.ServerNotify(Player.source, Config.Langue["RoomTimeUp"][1], Config.Langue["RoomTimeUp"][2], Config.Langue["RoomTimeUp"][3])
    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
    TriggerClientEvent("oph3z-motels:OpenManagement", src)
end)

function GetOfflinePlayer(citizenid)
    if citizenid then
        local PlayerData = MySQL.Sync.prepare('SELECT * FROM users where identifier = ?', {citizenid})
        if PlayerData then
            PlayerData.identifier = PlayerData.identifier
            PlayerData.accounts = json.decode(PlayerData.accounts)
        end
        tablo = {
            identifier = PlayerData.identifier,
            accounts = PlayerData.accounts
        }
    return tablo
    end
end

function SaveOffline(PlayerData)
    if PlayerData then
        MySQL.Async.insert('INSERT INTO users (identifier, accounts) VALUES (:identifier, :accounts) ON DUPLICATE KEY UPDATE accounts = :accounts', {
            identifier = PlayerData.identifier,
            accounts = json.encode(PlayerData.accounts),
        })
    end
end

RegisterNetEvent("oph3z-motels:server:UpgradeRoom", function(data)
    local id = tonumber(data.motelid)
    local motelroom = tonumber(data.motelroom)
    local motelprice = tonumber(string.match(data.motelprice, "%d+"))
    local newmotelprice = tonumber(motelprice * 1000)
    local src = source
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    local InfoData = json.decode(MotelData[1].info)
    if MotelData and #MotelData > 0 then
        local v = MotelData[1]
        local rooms = json.decode(v.rooms)
        local room = rooms[motelroom]
        if InfoData.CompanyMoney >= newmotelprice then
            room.theme = data.motelstylename
            if room.type == "Squatter" then
                if data.isupgraded then
                    room.type = "Middle"
                    local roomType = "Middle"
                    Config.Motels[id].Rooms = rooms
                    Config.ServerNotify(src, Config.Langue["UpgradeRoom"](motelroom, roomType)[1], Config.Langue["UpgradeRoom"](motelroom, roomType)[2], Config.Langue["UpgradeRoom"](motelroom, roomType)[3])
                elseif data.isupgradedvip then
                    room.type = "VIP"
                    local roomType = "VIP"
                    Config.Motels[id].Rooms = rooms
                    Config.ServerNotify(src, Config.Langue["UpgradeRoom"](motelroom, roomType)[1], Config.Langue["UpgradeRoom"](motelroom, roomType)[2], Config.Langue["UpgradeRoom"](motelroom, roomType)[3])
                end
            elseif room.type == "Middle" then
                if data.isupgradedvip then
                    local roomType = "VIP"
                    Config.ServerNotify(src, Config.Langue["UpgradeRoom"](motelroom, roomType)[1], Config.Langue["UpgradeRoom"](motelroom, roomType)[2], Config.Langue["UpgradeRoom"](motelroom, roomType)[3])
                    room.type = "VIP"
                    Config.Motels[id].Rooms = rooms
                end
            end
            
            if data.motelstylename ~= nil then
                for index, value in ipairs(room.StyleMenu) do
                    if value.type == "style" then
                        if value.name == data.motelstylename then
                            value.durum = true
                        else
                            value.durum = false
                        end
                    end
                end
            end
            
            if data.motelstyleoynadi then
                if data.motelstylenameextra ~= ""  and data.motelstylenameextra ~= nil then
                    for _, style in ipairs(room.StyleMenu) do
                        if style.type == "extra" then
                            style.durum = false -- Varsayılan olarak durumu false olarak ayarla
                            for i = 1, #data.motelstylenameextra do
                                local veri = data.motelstylenameextra[i]
                                if style.name == veri then
                                    style.durum = true -- Eşleşme varsa durumu true olarak ayarla
                                end
                            end
                        end
                    end
                elseif data.motelstylenameextra == "[]" then
                    for _, style in ipairs(room.StyleMenu) do
                        if style.type == "extra" then
                            style.durum = false
                        end
                    end
                end
            end
            
            Config.Motels[id].Rooms = rooms
            Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney - tonumber(newmotelprice)
            InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
            MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms, info = @info WHERE id = @id', {
                ["@id"] = id,
                ["@rooms"] = json.encode(Config.Motels[id].Rooms),
                ["@info"] = json.encode(InfoData),
            })
            TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
            for i = 1, #motelacanlar, 1 do
                local motel = motelacanlar[i]
                local motelno = motel.Motelno
                if id == motelno then
                    local source = motel.source
                    TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
                end
            end
        else
            Config.ServerNotify(src, Config.Langue["NotEnoughMoney"][1], Config.Langue["NotEnoughMoney"][2], Config.Langue["NotEnoughMoney"][3])
            return
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:AcceptRequste", function(data)
    local id = tonumber(data.motelid)
    local src = source
    local price = tonumber(data.price)
    local newprice = price * (Config.Data.AcceptYuzdelik / 100)
    local motelno = tonumber(data.roomno)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    local InfoData = json.decode(MotelData[1].info)

    if MotelData and #MotelData > 0 then
        local v = MotelData[1]
        local rooms = json.decode(v.rooms)
        local room = rooms[motelno]
        local motelrequest = json.decode(v.request)
        room.type = data.roomtype
        room.theme = data.roomtheme
        if data.roomextra ~= nil then
            local roomExtras = {}
            if type(data.roomextra) == "string" then
                roomExtras = splitString(data.roomextra, ",")
            elseif type(data.roomextra) == "table" then
                roomExtras = data.roomextra
            end
            
            room.strip = false
            room.booze = false
            
            if roomExtras ~= nil and #roomExtras > 0 then
                for index, value in ipairs(roomExtras) do
                    if value == "strip" then
                        room.strip = true
                    elseif value == "booze" then
                        room.booze = true
                    end
                end
            end

            if data.motelstyleoynadi then
                if data.roomextra and data.roomextra ~= "" then
                    for _, style in ipairs(room.StyleMenu) do
                        if style.type == "extra" then
                            local extraFound = false
                            for veri in string.gmatch(data.roomextra, "([^,]+)") do
                                veri = veri:match("^%s*(.-)%s*$") 
                                if style.name == veri then
                                    extraFound = true
                                    break
                                end
                            end
                            style.durum = extraFound
                        end
                    end
                end
            end

            Config.Motels[id].Rooms = rooms
            Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney + tonumber(newprice)
            InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
            motelrequest[motelno] = nil
            MySQL.Async.execute('UPDATE `oph3z_motel` SET `request` = @request, `info` = @info, `rooms` = @rooms WHERE `id` = @id', {
                ["@id"] = id,
                ["@request"] = json.encode(motelrequest),
                ["@info"] = json.encode(InfoData),
                ["@rooms"] = json.encode(Config.Motels[id].Rooms),
            })
            TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
            for i = 1, #motelacanlar, 1 do
                local motel = motelacanlar[i]
                local motelno = motel.Motelno
                if id == motelno then
                    local source = motel.source
                    TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
                end
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:CancelRequest", function(data)
    local id = tonumber(data.motelid)
    local src = source
    local motelno = tonumber(data.roomno)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    local InfoData = json.decode(MotelData[1].info)
    if MotelData and #MotelData > 0 then
        local v = MotelData[1]
        local rooms = json.decode(v.rooms)
        local room = rooms[motelno]
        local motelrequest = json.decode(v.request)
        motelrequest[motelno] = nil

        local Player = ESX.GetPlayerFromIdentifier(data.owner)
        if Player then
            Player.addAccountMoney(Config.Data.Moneytype, tonumber(data.price))
        else
            local citizenid = data.owner
            local PlayerData = GetOfflinePlayer(citizenid)
            if PlayerData then
                if Config.Data.Moneytype == "bank" then
                    para = PlayerData.accounts.bank
                    PlayerData.accounts.bank = PlayerData.accounts.bank + tonumber(data.price)
                else
                    PlayerData.accounts.money = PlayerData.accounts.money + tonumber(data.price)
                end
                SaveOffline(PlayerData)
            end
        end

        MySQL.Async.execute('UPDATE `oph3z_motel` SET request = @request WHERE id = @id', {
            ["@id"] = id,
            ["@request"] = json.encode(motelrequest)
        })
        Config.Motels[id].Rooms = rooms
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        for i = 1, #motelacanlar, 1 do
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
        Config.ServerNotify(src, Config.Langue["CancelRequest"](motelno)[1], Config.Langue["CancelRequest"](motelno)[2], Config.Langue["CancelRequest"](motelno)[3])
    end
end)

function splitString(inputString, separator)
    local result = {}
    local separatorPattern = string.format("([^%s]+)", separator)
    inputString:gsub(separatorPattern, function(value) table.insert(result, value) end)
    return result
end

RegisterNetEvent("oph3z-motels:server:UpgradeRoomRequest", function(data)
    local id = tonumber(data.motelid)
    local motelroom = tonumber(data.motelroom)
    local motelprice = tonumber(string.match(data.motelprice, "%d+"))
    local newmotelprice = motelprice
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    local InfoData = json.decode(MotelData[1].info)
    if MotelData and #MotelData > 0 then
        if Player.getAccount(Config.Data.Moneytype).money >= tonumber(newmotelprice) then
            Player.removeAccountMoney(Config.Data.Moneytype, tonumber(newmotelprice))
            local v = MotelData[1]
            local rooms = json.decode(v.rooms)
            local room = rooms[motelroom]
            local motelrequest = json.decode(v.request)
            if motelrequest[motelroom] ~= nil then
                motelrequest[motelroom] = nil
            end
            if InfoData.CompanyMoney >= newmotelprice then
                if room.type == "Squatter" then
                    if data.isupgraded then
                        asd = "Middle"
                        -- Config.Motels[id].Rooms = rooms
                        local roomType = "Middle"
                        Config.ServerNotify(src, Config.Langue["UpgradeRoomRequest"](motelroom, roomType)[1], Config.Langue["UpgradeRoom"](motelroom, roomType)[2], Config.Langue["UpgradeRoom"](motelroom, roomType)[3])
                    elseif data.isupgradedvip then
                        asd = "VIP"
                        -- Config.Motels[id].Rooms = rooms
                        local roomType = "VIP"
                        Config.ServerNotify(src, Config.Langue["UpgradeRoomRequest"](motelroom, roomType)[1], Config.Langue["UpgradeRoom"](motelroom, roomType)[2], Config.Langue["UpgradeRoom"](motelroom, roomType)[3])
                    end
                elseif room.type == "Middle" then
                    if data.isupgradedvip then
                        asd = "VIP"
                        -- Config.Motels[id].Rooms = rooms
                        local roomType = "VIP"
                        Config.ServerNotify(src, Config.Langue["UpgradeRoomRequest"](motelroom, roomType)[1], Config.Langue["UpgradeRoom"](motelroom, roomType)[2], Config.Langue["UpgradeRoom"](motelroom, roomType)[3])
                    end
                end
                room.fixmoney = newmotelprice
                
                if data.motelstylename ~= nil then
                    for index, value in ipairs(room.StyleMenu) do
                        if value.type == "style" then
                            if value.name == data.motelstylename then
                                value.durum = true
                                room.theme = value.name
                            else
                                value.durum = false
                            end
                        end
                    end
                end

            if data.motelstyleoynadi then
                if data.motelstylenameextra ~= nil and #data.motelstylenameextra > 0 then
                    for _, style in ipairs(room.StyleMenu) do
                        if style.type == "extra" then
                            for i = 1, #data.motelstylenameextra do
                                local veri = data.motelstylenameextra[i]
                                
                                if style.name == veri then
                                    if style.durum == false then
                                        style.durum = true
                                    end
                                else
                                    style.durum = false
                                end
                            end
                        end
                    end
                end 
            end

                local roomveri = {
                    motelno = motelroom,
                    theme = data.motelstylename,
                    extra = data.motelstylenameextra,
                    motelstyleoynadi = data.motelstyleoynadi,
                    type = asd,
                    roomoowner = room.Owner.RoomsOwner,
                    roomprice = room.fixmoney,
    
                }
                motelrequest[motelroom] = roomveri
                MySQL.Async.execute('UPDATE `oph3z_motel` SET request = @request WHERE id = @id', {
                    ["@id"] = id,
                    ["@request"] = json.encode(motelrequest)
                })
            else
                Config.ServerNotify(src, Config.Langue["NotEnoughMoney"][1], Config.Langue["NotEnoughMoney"][2], Config.Langue["NotEnoughMoney"][3])
                return
            end
        end
    end
end)


function tableContainsValue(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do 
        local current_time = os.time()
        local NewDate = os.date("%Y-%m-%d %H:%M:%S", current_time)
        for k,v in pairs(Config.Motels) do
            for i, room in ipairs(v.Rooms) do
                date = room.Owner.Date
                if date ~= "" then
                    if tostring(date) <= tostring(NewDate) then
                        room.Rent = false
                        room.Owner.RoomsOwner = ""
                        room.Owner.Name = ""
                        room.Owner.Lastname = ""
                        room.Owner.MyMoney = 0
                        room.Owner.Date = ""
                        room.Owner.Friends = {}
                        Config.Motels[k].Rooms[i] = room
                        MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms WHERE id = @id', {
                            ["@id"] = k,
                            ["@rooms"] = json.encode(Config.Motels[k].Rooms)
                        })
                        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                    end
                end

            end
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local current_time = os.time()
        local makinesaati = os.date("%Y-%m-%d %H:%M:%S", current_time)
        if ScriptLoaded then
            for k, v in pairs(Config.Motels) do
                for i, Employes in ipairs(v.Employes) do
                    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = k})
                    local InfoData = json.decode(MotelData[1].info)
                    local KasaPara = InfoData.CompanyMoney
                    local PlayerOwner = InfoData.Owner
                    local SonMaasTarihi = Employes.Date
                    local hours_to_add = Config.Data.EmployesSalaryTime
                    local future_time1 = os.time{year=tonumber(SonMaasTarihi:sub(1,4)), month=tonumber(SonMaasTarihi:sub(6,7)), day=tonumber(SonMaasTarihi:sub(9,10)), hour=tonumber(SonMaasTarihi:sub(12,13)), min=tonumber(SonMaasTarihi:sub(15,16)), sec=tonumber(SonMaasTarihi:sub(18,19))}
                    future_time1 = future_time1 + (hours_to_add * 3600)
                    local future_hour = tonumber(os.date("%H", future_time1))
                    
                    if future_hour >= 24 then
                        future_time1 = future_time1 + (24 * 3600)
                    end
                    local SonMaasTarihi1 = os.date("%Y-%m-%d %H:%M:%S", future_time1)

                    if SonMaasTarihi1 ~= "" and tostring(SonMaasTarihi1) <= tostring(makinesaati) then
                        if KasaPara >= tonumber(Employes.Salary) then
                            local Player = ESX.GetPlayerFromIdentifier(Employes.Citizenid)
                            if Player then
                                SendMail(Player.source, InfoData.Name.."", "Maaş Ödemesi", "Maaşınız ödendi. İyi günler dileriz.")
                                Config.ServerNotify(Player.source, Config.Langue["EmployesSalary"](tonumber(Employes.Salary))[1], Config.Langue["EmployesSalary"](tonumber(Employes.Salary))[2], Config.Langue["EmployesSalary"](tonumber(Employes.Salary))[3])
                                Player.addAccountMoney(Config.Data.Moneytype, tonumber(Employes.Salary))
                            else
                                if Config.Data.EmployesOfflinePayment then
                                    local citizenid = Employes.Citizenid
                                    local PlayerData = GetOfflinePlayer(citizenid)
                                    if PlayerData then
                                        if Config.Data.Moneytype == "bank" then
                                            para = PlayerData.accounts.bank
                                            PlayerData.accounts.bank = PlayerData.accounts.bank + tonumber(Employes.Salary)
                                        else
                                            PlayerData.accounts.money = PlayerData.accounts.money + tonumber(Employes.Salary)
                                        end
                                        SaveOffline(PlayerData)
                                    end
                                end
                            end
                            Employes.Date = tostring(makinesaati)
                            Config.Motels[k].Employes[i] = Employes

                            InfoData.CompanyMoney = InfoData.CompanyMoney - tonumber(Employes.Salary)
                            MySQL.Async.execute('UPDATE `oph3z_motel` SET employees = @employees, info = @info WHERE id = @id', {
                                ["@id"] = k,
                                ["@employees"] = json.encode(Config.Motels[k].Employes),
                                ["@info"] = json.encode(InfoData),
                            })
                            TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                        else
                            local Player = ESX.GetPlayerFromIdentifier(Employes.Citizenid)
                            local Owner = ESX.GetPlayerFromIdentifier(PlayerOwner)
    
                            SendMail(Player.source, InfoData.Name.."", "Maaş Ödemesi", "Maaşınız ödenemedi. Kasa yetersiz..")
                            Config.ServerNotify(Player.source, Config.Langue["NotEnoughMoneySalary"][1], Config.Langue["NotEnoughMoneySalary"][2], Config.Langue["NotEnoughMoneySalary"][3])
                            if Owner then
                                Config.ServerNotify(Owner.source, Config.Langue["NotEnoughMoneySalaryOwner"](InfoData.Name)[1], Config.Langue["NotEnoughMoneySalaryOwner"](InfoData.Name)[2], Config.Langue["NotEnoughMoneySalaryOwner"](InfoData.Name)[3])
                                SendMail(Owner.source, InfoData.Name.."", "İşciler Ayaklanıyor", "Başta Erkan Baş ve Osman Ağa ile işciler ayaklanıyor Kasaya para eklemeliyiz. Şunu diyorlar AYAKLANIN KARDEŞLERİM HEPİMİZİ BİRDEN ASAMAZLAR")
                            end
                            Wait(10000)
                        end
                    end
    
                end
            end
        end
        Wait(1000)
    end
end)

RegisterNetEvent("oph3z-motels:server:KickCustomer", function (data)
    local source = source
    id = data.motelno
    MotelNumber = tonumber(data.motelroomnumber)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then
        local rooms = json.decode(MotelData[1].rooms)
        local room = rooms[MotelNumber]
        room.Rent = false
        room.Owner.RoomsOwner = ""
        room.Owner.Name = ""
        room.Owner.Lastname = ""
        room.Owner.MyMoney = 0
        room.Owner.Date = ""
        room.Owner.Friends = {}
        Config.Motels[id].Rooms = rooms
        MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms WHERE id = @id', {
            ["@id"] = id,
            ["@rooms"] = json.encode(Config.Motels[id].Rooms)
        })
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        for i = 1, #motelacanlar, 1 do
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:KickEmployee", function (data)
    local source = source
    id = data.motelno
    EmployeName = tostring(data.employeName)
    local Player = ESX.GetPlayerFromId(source)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then

        local info = json.decode(MotelData[1].info)
        local employes = json.decode(MotelData[1].employees)
        if info.Owner ~= Player.getIdentifier() then
            return
        end
        for k,v in pairs(employes) do
            if v.Name == EmployeName then
                table.remove(employes, k)
            end
        end
        Config.Motels[id].Employes = employes
        MySQL.Async.execute('UPDATE `oph3z_motel` SET employees = @employees WHERE id = @id', {
            ["@id"] = id,
            ["@employees"] = json.encode(Config.Motels[id].Employes)
        })
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        for i = 1, #motelacanlar, 1 do
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:RankUp", function (data)
    local source = source
    id = data.motelno
    EmployeName = tostring(data.employeName)
    local Player = ESX.GetPlayerFromId(source)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then
        local info = json.decode(MotelData[1].info)
        local employes = json.decode(MotelData[1].employees)
        if info.Owner ~= Player.getIdentifier() then
            return
        end

        for k,v in pairs(employes) do
            if v.Name == EmployeName then
                if employes[k].Rank < 2 then 
                    employes[k].Rank = employes[k].Rank + 1
                    Config.ServerNotify(source, Config.Langue["RankUpSuccess"](EmployeName)[1], Config.Langue["RankUpSuccess"](EmployeName)[2], Config.Langue["RankUpSuccess"](EmployeName)[3])
                end
            end
        end
        Config.Motels[id].Employes = employes
        MySQL.Async.execute('UPDATE `oph3z_motel` SET employees = @employees WHERE id = @id', {
            ["@id"] = id,
            ["@employees"] = json.encode(Config.Motels[id].Employes)
        })
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        for i = 1, #motelacanlar, 1 do
            
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:BuyMotel", function(MotelData)
    local Player = ESX.GetPlayerFromId(source)
    local id = MotelData.motel
    local price = MotelData.price
    local src = source
    if Player then
        local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
        local InfoData = json.decode(MotelData[1].info)
        local ownedMotelCount = 0
        
        for _, motel in pairs(Config.Motels) do
            if motel.Owner == Player.getIdentifier() then
                ownedMotelCount = ownedMotelCount + 1
            end
        end

        if InfoData.Owner == "" then
            if ownedMotelCount < Config.Data.MaxMotelBossAmount then
                if Config.Data.Moneytype == "bank" then
                    if Player.getAccount("bank").money >= price then
                        Config.Motels[id].Owner = Player.getIdentifier()
                        InfoData.Owner = Player.getIdentifier()
                        Player.removeAccountMoney(Config.Data.Moneytype, tonumber(price))
                        MySQL.Async.execute('UPDATE `oph3z_motel` SET info = @info WHERE id = @id', {["@info"] = json.encode(InfoData), ["@id"] = id})
                    else
                        Config.ServerNotify(Player, Config.Langue["InsufficientBankFunds"][1], Config.Langue["InsufficientBankFunds"][2], Config.Langue["InsufficientBankFunds"][3])
                    end
                else
                    if Player.getAccount("cash").money >= price then
                        InfoData.Owner = Player.getIdentifier()
                        Config.Motels[id].Owner = Player.getIdentifier()
                        MySQL.Async.execute('UPDATE `oph3z_motel` SET info = @info WHERE id = @id', {["@info"] = json.encode(InfoData), ["@id"] = id})
                        Player.removeAccountMoney(Config.Data.Moneytype, tonumber(price))
                    else
                        Config.ServerNotify(Player, Config.Langue["InsufficientCashFunds"][1], Config.Langue["InsufficientCashFunds"][2], Config.Langue["InsufficientCashFunds"][3])
                    end
                end
                TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                SendMail(src, "Motel İşletmesi", "Motel Satın Alımı", "Motel satın aldınız. Motel numaranız: "..id.." Motel ismi: "..InfoData.Name.." Motel sahibi: "..Player.getName().."")
                Config.ServerNotify(Player, Config.Langue["PurchaseMotelSuccess"](InfoData.Name)[1], Config.Langue["PurchaseMotelSuccess"](InfoData.Name)[2], Config.Langue["PurchaseMotelSuccess"](InfoData.Name)[3])
            else
                Config.ServerNotify(Player, Config.Langue["MaxMotelBuznizLimit"](Config.Data.MaxMotelBossAmount)[1], Config.Langue["MaxMotelBuznizLimit"](Config.Data.MaxMotelBossAmount)[2], Config.Langue["MaxMotelBuznizLimit"](Config.Data.MaxMotelBossAmount)[3])
            end
        end
    end
end)

function SendMail(source ,sender, subject,messege,button)
    if Config.Data.Mail then
        TriggerClientEvent("oph3z-motels:client:SendMail", source, sender, subject,messege,button)
    end
   
end

RegisterNetEvent("oph3z-motels:server:SaveDashboard", function (data)
    local id = data.motelid
    local Player = ESX.GetPlayerFromId(source)
    if Player then
        local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
        local InfoData = json.decode(MotelData[1].info)
        Config.Motels[id].Name = data.MotelName
        InfoData.Name = data.MotelName
        MySQL.Async.execute('UPDATE `oph3z_motel` SET info = @info WHERE id = @id', {["@info"] = json.encode(InfoData), ["@id"] = id})
        MySQL.Async.execute('UPDATE `oph3z_motel` SET names = @names WHERE id = @id', {["@names"] = json.encode(data.MotelName), ["@id"] = id})
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        TriggerClientEvent("oph3z-motels:client:MotelNameBlip", -1)
        for i = 1, #motelacanlar, 1 do
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
        Config.ServerNotify(Player.source, Config.Langue["SaveDashboard"](data.MotelName)[1], Config.Langue["SaveDashboard"](data.MotelName)[2], Config.Langue["SaveDashboard"](data.MotelName)[3])
    end
end)

RegisterNetEvent("oph3z-motels:server:SellMotel", function (data)
    local id = tonumber(data.motelid)
    src = source
    local Player = ESX.GetPlayerFromId(source)
    if Player then
        local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
        local InfoData = json.decode(MotelData[1].info)
        local Price = InfoData.CompanyMoney 
        if Price == 0 then
            SellPrice = Config.Data.SellPriceDeafult
        else
            SellPrice = math.ceil(Price / Config.Data.SellMotelPrice)
            Tax = math.ceil(SellPrice * Config.Data.SellMotelTax)
            AddPrice = SellPrice - Tax
        end
        Player.addAccountMoney(Config.Data.Moneytype, tonumber(AddPrice))
        Config.Motels[id].Owner = ""
        InfoData.Owner = ""
        SendMail(src, "Motel Business", "Motel Sale", "Motel Sold Without Tax Money: " ..SellPrice.. " Tax: "..Tax.."".. " Total Money: "..AddPrice.."", "Sale")
        Config.ServerNotify(Player.source, Config.Langue["MotelSellSuccess"](InfoData.Name,SellPrice,Tax,AddPrice)[1], Config.Langue["MotelSellSuccess"](InfoData.Name,SellPrice,Tax,AddPrice)[2], Config.Langue["MotelSellSuccess"](InfoData.Name,SellPrice,Tax,AddPrice)[3])
        MySQL.Async.execute('UPDATE `oph3z_motel` SET info = @info WHERE id = @id', {["@info"] = json.encode(InfoData), ["@id"] = id})
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
    end
end)

RegisterNetEvent("oph3z-motels:server:MotelTransferRequest", function(data)
    source = source
    local Player = ESX.GetPlayerFromId(source)
    Playerdetayls = Config.GetPlayer(Player.getIdentifier())
    local SenderName =  {
        firstname = Playerdetayls.firstname,
        lastname = Playerdetayls.lastname,
        source = Player.source
    }
    TriggerClientEvent("oph3z-motels:client:TransferMotelRequest", data.playerid, data, SenderName)
end)


RegisterNetEvent("oph3z-motels:server:TransferMotel", function (data)
    local id = tonumber(data.motelid)
    local PlayerNewOwner = tonumber(data.newid)
    local Player = ESX.GetPlayerFromId(tonumber(data.exowner))
    local Player2 = ESX.GetPlayerFromId(PlayerNewOwner)
    if PlayerNewOwner ~= nil and PlayerNewOwner ~= 0 then
        if Player then
            local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
            local InfoData = json.decode(MotelData[1].info)
            if Player2 then
                Config.Motels[id].Owner = Player2.getIdentifier()
                InfoData.Owner = Player2.getIdentifier()
                Playerdetayls = Config.GetPlayer(Player2.getIdentifier())
                MySQL.Async.execute('UPDATE `oph3z_motel` SET info = @info WHERE id = @id', {["@info"] = json.encode(InfoData), ["@id"] = id})
                TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                Config.ServerNotify(Player.source, Config.Langue["MotelTransferSuccess"](InfoData.Name,Playerdetayls.firstname,Playerdetayls.lastname)[1], Config.Langue["MotelTransferSuccess"](InfoData.Name,Playerdetayls.firstname,Playerdetayls.lastname)[2], Config.Langue["MotelTransferSuccess"](InfoData.Name,Playerdetayls.firstname,Playerdetayls.lastname)[3])
                Config.ServerNotify(Player2.source, Config.Langue["MotelTransferSuccess2"](InfoData.Name)[1], Config.Langue["MotelTransferSuccess2"](InfoData.Name)[2], Config.Langue["MotelTransferSuccess2"](InfoData.Name)[3])
            end
        end
    else
        Config.ServerNotify(Player.source, Config.Langue["PlayerNotFound"][1], Config.Langue["PlayerNotFound"][2], Config.Langue["PlayerNotFound"][3])
    end
end)

RegisterNetEvent("oph3z-motels:server:CompanyMoney", function (data)
    local source = source
    local id = data.motelno
    local Player = ESX.GetPlayerFromId(source)
    if tonumber(data.Money) == 0 or tonumber(data.Money) == nil then
        return
    else
        local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
        local InfoData = json.decode(MotelData[1].info)
        if data.Parayatirma then
            if  Player.getAccount(Config.Data.Moneytype).money >= tonumber(data.Money) then
                Player.removeAccountMoney(Config.Data.Moneytype, tonumber(data.Money))
                AddHistory(id, "deposit", tonumber(data.Money))
                Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney + tonumber(data.Money)
                InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
                MySQL.Async.execute('UPDATE `oph3z_motel` SET info = @info WHERE id = @id', {["@info"] = json.encode(InfoData), ["@id"] = id})
                TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                for i = 1, #motelacanlar, 1 do
                    local motel = motelacanlar[i]
                    local motelno = motel.Motelno
                    if id == motelno then
                        local source = motel.source
                        TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
                    end
                end
            else
                if Config.Data.Moneytype == "bank" then
                    Config.ServerNotify(Player.source, Config.Langue["InsufficientBankFunds"][1], Config.Langue["InsufficientBankFunds"][2], Config.Langue["InsufficientBankFunds"][3])
                else
                    Config.ServerNotify(Player.source, Config.Langue["InsufficientCashFunds"][1], Config.Langue["InsufficientCashFunds"][2], Config.Langue["InsufficientCashFunds"][3])
                end
            end
        else
            if tonumber(data.Money) > InfoData.CompanyMoney then
                Config.ServerNotify(Player.source, Config.Langue["NotEnoughMoney"][1], Config.Langue["NotEnoughMoney"][2], Config.Langue["NotEnoughMoney"][3])
            else
                AddHistory(id, "withdraw", tonumber(data.Money))
                Player.addAccountMoney(Config.Data.Moneytype, tonumber(data.Money))
                Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney - tonumber(data.Money)
                InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
                MySQL.Async.execute('UPDATE `oph3z_motel` SET info = @info WHERE id = @id', {["@info"] = json.encode(InfoData), ["@id"] = id})
                TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                for i = 1, #motelacanlar, 1 do
                    local motel = motelacanlar[i]
                    local motelno = motel.Motelno
                    if id == motelno then
                        local source = motel.source
                        TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:NearbyAccept", function(data)
    local patronid = tonumber(data.senderid)
    local id = tonumber(data.motelid)
    local current_time = os.time()
    local hours_to_add = data.time
    local future_time = current_time + (hours_to_add * 3600)
    local future_hour = tonumber(os.date("%H", future_time))

    if future_hour >= 24 then
        future_time = future_time + (24 * 3600)
    end
    local PatronPlayer = ESX.GetPlayerFromId(patronid)
    local NewDate = os.date("%Y-%m-%d %H:%M:%S", future_time)
    local Player = ESX.GetPlayerFromId(source)
    if Player then
        local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})

        if Player.getAccount(Config.Data.Moneytype).money >= tonumber(data.price) then
            if MotelData and #MotelData > 0 then
                local v = MotelData[1]
                local rooms = json.decode(v.rooms)
                local InfoData = json.decode(MotelData[1].info)
                local room = rooms[tonumber(data.room)]
                local ownedRooms = 0
                
                for _, r in pairs(rooms) do
                    if r.Rent and r.Owner.RoomsOwner == Player.getIdentifier() then
                        ownedRooms = ownedRooms + 1
                    end
                end
     
                if ownedRooms < Config.Data.OwneRentMotelAmount then
                    Playerdetayls = Config.GetPlayer(Player.getIdentifier())
                    room.Rent = true
                    room.Owner.RoomsOwner = Player.getIdentifier()
                    room.Owner.Name = Playerdetayls.firstname
                    room.Owner.Lastname = Playerdetayls.lastname
                    room.Owner.PhoneNumber = Playerdetayls.phone
                    room.Owner.MyMoney = data.price
                    room.Owner.Date = tostring(NewDate)
                    room.Owner.Friends = {}
                    Config.Motels[id].Rooms = rooms

                    if Config.Data.EmployesTax then
                        if InfoData.Owner == PatronPlayer.getIdentifier() then
                            Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney + tonumber(data.price)
                            InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
                        else
                            local tax = tonumber(data.price) * Config.Data.EmployesTaxAmount / 100
                            Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney + tonumber(data.price) - tax
                            InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
                            Player.addAccountMoney(Config.Data.Moneytype, tonumber(tax))
                        end
                    else
                        Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney + tonumber(data.price)
                        InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
                    end

                    MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms, info = @info WHERE id = @id', {
                        ["@id"] = id,
                        ["@rooms"] = json.encode(Config.Motels[id].Rooms),
                        ["@info"] = json.encode(InfoData),
                    })

                    Player.removeAccountMoney(Config.Data.Moneytype, tonumber(data.price))
                    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                    for i = 1, #motelacanlar, 1 do
                        local motel = motelacanlar[i]
                        local motelno = motel.Motelno
                        if id == motelno then
                            local source = motel.source
                            TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
                        end
                    end
                    Config.ServerNotify(Player.source, Config.Langue["AcceptRoomOffer"](InfoData.Name,tonumber(data.room),tonumber(data.price))[1], Config.Langue["AcceptRoomOffer"](InfoData.Name,tonumber(data.room),tonumber(data.price))[2], Config.Langue["AcceptRoomOffer"](InfoData.Name,tonumber(data.room),tonumber(data.price))[3])
                else
                    Config.ServerNotify(Player.source, Config.Langue["MaxMotelRoomLimit"](Config.Data.OwneRentMotelAmount)[1], Config.Langue["MaxMotelRoomLimit"](Config.Data.OwneRentMotelAmount)[2], Config.Langue["MaxMotelRoomLimit"](Config.Data.OwneRentMotelAmount)[3])
                end
            end
        else
            if Config.Data.Moneytype == "bank" then
                Config.ServerNotify(Player.source, Config.Langue["InsufficientBankFunds"][1], Config.Langue["InsufficientBankFunds"][2], Config.Langue["InsufficientBankFunds"][3])
            else
                Config.ServerNotify(Player.source, Config.Langue["InsufficientCashFunds"][1], Config.Langue["InsufficientCashFunds"][2], Config.Langue["InsufficientCashFunds"][3])
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:AddFriend", function(data)
    local id = tonumber(data.motelid)
    local arkid = tonumber(data.id)
    local evsahibi = tonumber(data.evsahhibi)
    local roomno = tonumber(data.odano)
    local Player = ESX.GetPlayerFromId(evsahibi)
    local PlayerArk = ESX.GetPlayerFromId(arkid)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then
        local v = MotelData[1]
        local rooms = json.decode(v.rooms)
        local InfoData = json.decode(MotelData[1].info)
        local room = rooms[tonumber(roomno)]
        if room.type == "VIP" then
            MaxFriends = Config.Data.FriendLimitV
        elseif room.type == "Middle" then
            MaxFriends = Config.Data.FriendLimitM
        elseif room.type == "Squatter" then
            MaxFriends = Config.Data.FriendLimitS
        end
            

        if Player.getIdentifier() == room.Owner.RoomsOwner then
            if not Config.Data.FriendSystem then
                return
            end

            Playerdetayls = Config.GetPlayer(PlayerArk.getIdentifier())
            insertveri = {
                Citizenid = tostring(PlayerArk.getIdentifier()),
                Name = tostring(Playerdetayls.firstname),
                Lastname = tostring(Playerdetayls.lastname),
            }

            local roomOwnerFriends = room.Owner.Friends or {}
            local isAlreadyFriend = false
            friendname = insertveri.Name
            friendlastname = insertveri.Lastname
            for _, friend in ipairs(roomOwnerFriends) do
                if friend.Citizenid == insertveri.Citizenid then
                    isAlreadyFriend = true
                    break
                end
            end
            if isAlreadyFriend then
                Config.ServerNotify(Player.source, Config.Langue["AlreadyFriend"](friendname,friendlastname)[1], Config.Langue["AlreadyFriend"](friendname,friendlastname)[2], Config.Langue["AlreadyFriend"](friendname,friendlastname)[3])
            else
                if #roomOwnerFriends >= MaxFriends then
                    Config.ServerNotify(Player.source, Config.Langue["MaxMotelRoomFriendsimit"](MaxFriends)[1], Config.Langue["MaxMotelRoomFriendsimit"](MaxFriends)[2], Config.Langue["MaxMotelRoomFriendsimit"](MaxFriends)[3])
                else
                    Config.ServerNotify(Player.source, Config.Langue["AddFriendsSuccess"](friendname,friendlastname)[1], Config.Langue["AddFriendsSuccess"](friendname,friendlastname)[2], Config.Langue["AddFriendsSuccess"](friendname,friendlastname)[3])
                    table.insert(roomOwnerFriends, insertveri)
                    room.Owner.Friends = roomOwnerFriends
                    Config.Motels[id].Rooms = rooms
                    MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms WHERE id = @id', {
                        ["@id"] = id,
                        ["@rooms"] = json.encode(Config.Motels[id].Rooms),
                    })
                    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                    TriggerClientEvent("oph3z-motels:OpenManagement", evsahibi)
                end
            end
        end
    end
end)


RegisterNetEvent("oph3z-motels:server:KickFriends", function (data)
    id = tonumber(data.motelid)
    local src = source
    local roomno = tonumber(data.odano)
    Citizenid = data.citizenId
    local Player = ESX.GetPlayerFromId(src)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then
        local v = MotelData[1]
        local rooms = json.decode(v.rooms)
        local room = rooms[tonumber(roomno)]
        if Player.getIdentifier() == room.Owner.RoomsOwner then
            if not Config.Data.FriendSystem then
                return
            end
            local roomOwnerFriends = room.Owner.Friends or {}
            local isAlreadyFriend = false
            for _, friend in ipairs(roomOwnerFriends) do
                if friend.Citizenid == Citizenid then
                    isAlreadyFriend = true
                    break
                end
            end
            if isAlreadyFriend then
                for i = 1, #roomOwnerFriends do
                    if roomOwnerFriends[i].Citizenid == Citizenid then
                        friendname = roomOwnerFriends[i].Name
                        friendlastname = roomOwnerFriends[i].Lastname
                        Config.ServerNotify(Player.source, Config.Langue["KickFriendSuccess"](friendname,friendlastname)[1], Config.Langue["KickFriendSuccess"](friendname,friendlastname)[2], Config.Langue["KickFriendSuccess"](friendname,friendlastname)[3])
                        table.remove(roomOwnerFriends, i)
                        break
                    end
                end
                room.Owner.Friends = roomOwnerFriends
                Config.Motels[id].Rooms = rooms
                MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms WHERE id = @id', {
                    ["@id"] = id,
                    ["@rooms"] = json.encode(Config.Motels[id].Rooms),
                })
                TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
                TriggerClientEvent("oph3z-motels:OpenManagement", src)
            else
                return
            end
        end
    end
end)


RegisterNetEvent("oph3z-motels:server:InviteEmployee", function(data)
    source = source
    local Player = ESX.GetPlayerFromId(source)
    Playerdetayls = Config.GetPlayer(Player.getIdentifier())
    local SenderName =  {
        firstname = Playerdetayls.firstname,
        lastname = Playerdetayls.lastname,
        source = source
    }
    TriggerClientEvent("oph3z-motels:client:InviteEmployee", data.playersource, data, SenderName)
end)


RegisterNetEvent("oph3z-motels:server:RankDown", function (data)
    local source = source
    id = data.motelno
    EmployeName = tostring(data.employeName)
    local Player = ESX.GetPlayerFromId(source)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then

        local info = json.decode(MotelData[1].info)
        local employes = json.decode(MotelData[1].employees)
        if info.Owner ~= Player.getIdentifier() then
            return  
        end
        for k,v in pairs(employes) do
            if v.Name == EmployeName then
                if employes[k].Rank >= 2 then 
                    employes[k].Rank = employes[k].Rank - 1
                    Config.ServerNotify(Player.source, Config.Langue["RankDownSuccess"](EmployeName)[1], Config.Langue["RankDownSuccess"](EmployeName)[2], Config.Langue["RankDownSuccess"](EmployeName)[3])
                end
            end
        end
        Config.Motels[id].Employes = employes
        MySQL.Async.execute('UPDATE `oph3z_motel` SET employees = @employees WHERE id = @id', {
            ["@id"] = id,
            ["@employees"] = json.encode(Config.Motels[id].Employes)
        })
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        for i = 1, #motelacanlar, 1 do
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:ChangeSalary", function (data)
    local src = source
    id = tonumber(data.motelno)
    EmployeName = tostring(data.employeName)
    local Player = ESX.GetPlayerFromId(src)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then

        local info = json.decode(MotelData[1].info)
        local employes = json.decode(MotelData[1].employees)
        if info.Owner ~= Player.getIdentifier() then
            return  
        end
        for k,v in pairs(employes) do

            if v.Name == EmployeName then
                employes[k].Salary = tonumber(data.salary)
                Config.ServerNotify(Player.source, Config.Langue["SalaryChangeSuccess"](EmployeName,tonumber(data.salary))[1], Config.Langue["SalaryChangeSuccess"](EmployeName,tonumber(data.salary))[2], Config.Langue["SalaryChangeSuccess"](EmployeName,tonumber(data.salary))[3])
            end
        end
        Config.Motels[id].Employes = employes
        MySQL.Async.execute('UPDATE `oph3z_motel` SET employees = @employees WHERE id = @id', {
            ["@id"] = id,
            ["@employees"] = json.encode(Config.Motels[id].Employes)
        })
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        for i = 1, #motelacanlar, 1 do
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:JobOfferAccepted", function(data)
    local id = tonumber(data.motelid)
    local Player = ESX.GetPlayerFromId(tonumber(data.playerid))
    local current_time = os.time()
    local NewDate = os.date("%Y-%m-%d %H:%M:%S", current_time)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then
        local employees = json.decode(MotelData[1].employees)
        local InfoData = json.decode(MotelData[1].info)
        if InfoData.Owner == Player.getIdentifier() then
            Config.ServerNotify(Player.source, Config.Langue["AlreadyOwnerEmployess"][1], Config.Langue["AlreadyOwnerEmployess"][2], Config.Langue["AlreadyOwnerEmployess"][3])
        else
            if employees ~= nil then
                local playerExists = false
                for k,v in pairs(employees) do
                    if v.Citizenid == Player.getIdentifier() then
                        playerExists = true
                        employeesname = v.Name
                        Config.ServerNotify(Player.source, Config.Langue["AlreadyEmployess"](employeesname)[1], Config.Langue["AlreadyEmployess"](employeesname)[2], Config.Langue["AlreadyEmployess"](employeesname)[3])
                        break
                    end
                end
                if not playerExists then
                    table.insert(employees, {
                        Name = tostring(Player.getName()),
                        Salary = tostring(1000),
                        Rank = tonumber(1),
                        Date = tostring(NewDate),
                        Citizenid = tostring(Player.getIdentifier()),
                    })
                end
            else
                employees = {
                    {
                        Name = tostring(Player.getName()),
                        Salary = tostring(1000),
                        Rank = tonumber(1),
                        Date = tostring(NewDate),
                        Citizenid = tostring(Player.getIdentifier()),
                    }
                }
            end
        end
        Config.Motels[id].Employes = employees
        MySQL.Async.execute('UPDATE `oph3z_motel` SET employees = @employees WHERE id = @id', {
            ["@id"] = id,
            ["@employees"] = json.encode(employees)
        })
        TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
        for i = 1, #motelacanlar, 1 do
            local motel = motelacanlar[i]
            local motelno = motel.Motelno
            if id == motelno then
                local source = motel.source
                TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
            end
        end
        SendMail(data.playerid, InfoData.Name.."", "İşe Alındın", "İşe aldındın adamım. Motel numaranız: "..id.." Motel ismi: "..InfoData.Name.."")
        Config.ServerNotify(Player.source, Config.Langue["JobOfferAccepted"](InfoData.Name)[1], Config.Langue["JobOfferAccepted"](InfoData.Name)[2], Config.Langue["JobOfferAccepted"](InfoData.Name)[3])
    end
end)


RegisterNetEvent("oph3z-motels:server:RepairRoom", function(data)
    src = source
    local Player = ESX.GetPlayerFromId(src)
    local id = tonumber(data.motelid)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    local InfoData = json.decode(MotelData[1].info)
    local motelfixprice = tonumber(string.match(data.motelfixprice, "%d+"))
    local newmotelfixprice = tonumber(motelfixprice * 1000)
    if InfoData.CompanyMoney >= newmotelfixprice then
        Config.Motels[id].CompanyMoney = Config.Motels[id].CompanyMoney - tonumber(newmotelfixprice)
        InfoData.CompanyMoney = Config.Motels[id].CompanyMoney
        local rooms = json.decode(MotelData[1].rooms)
        local room = rooms[tonumber(data.motelroomnumber)]
        room.Active = true
        Config.Motels[id].Rooms = rooms
        MySQL.Async.execute('UPDATE `oph3z_motel` SET rooms = @rooms, info = @info WHERE id = @id', {
            ["@id"] = id,
            ["@rooms"] = json.encode(Config.Motels[id].Rooms),
            ["@info"] = json.encode(InfoData),
        })
    else
        Config.ServerNotify(Player.source, Config.Langue["NotEnoughMoney"][1], Config.Langue["NotEnoughMoney"][2], Config.Langue["NotEnoughMoney"][3])
    end
    Config.ServerNotify(Player.source, Config.Langue["RoomRepaired"](tonumber(data.motelroomnumber))[1], Config.Langue["RoomRepaired"](tonumber(data.motelroomnumber))[2], Config.Langue["RoomRepaired"](tonumber(data.motelroomnumber))[3])
    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
    for i = 1, #motelacanlar, 1 do
        local motel = motelacanlar[i]
        local motelno = motel.Motelno
        if id == motelno then
            local source = motel.source
            TriggerClientEvent("oph3z-motels:OpenBossMenu", source, motelno)
        end
    end
end)

function AddHistory(id, type, money)
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    local History = json.decode(MotelData[1].history)
    table.insert(History, {
        type = type,
        money = money
    })
    MySQL.Async.execute('UPDATE `oph3z_motel` SET history = @history WHERE id = @id', {["@history"] = json.encode(History), ["@id"] = id})
    Config.Motels[id].History = History
    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
end



ESX.RegisterServerCallback("oph3z-motels:server:PlayerName", function(source, cb, target)
    local Player = ESX.GetPlayerFromId(target)
    if Player then
        Playerdetayls = Config.GetPlayer(Player.getIdentifier())
        local NerabyPlayers = {
            {
                Name = Playerdetayls.firstname,
                Lastname = Playerdetayls.lastname,
                Citizenid = Player.getIdentifier(),
                id = target
            }
        }
        cb(NerabyPlayers)
    else
        cb(nil)
    end
end)

ESX.RegisterServerCallback("oph3z-motels:server:RequestMotel", function(source, cb, motelid)
    local id = motelid
    local MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = id})
    if MotelData and #MotelData > 0 then
        local v = MotelData[1]
        local RequestData =  json.decode(v.request)

        if RequestData ~= nil then
            cb(RequestData)
        end
    end
end)

ESX.RegisterServerCallback("oph3z-motels:server:RoomInvite", function(source, cb, coords)
    local players = ESX.GetPlayers()
    local src = source
    for i = 1, #players do
        local ped = GetPlayerPed(players[i])
        local pos = GetEntityCoords(ped)
        local dist = #(pos - coords)
        if dist < 2.0 then
            local Player = ESX.GetPlayerFromId(players[i])
            Playerdetayls = Config.GetPlayer(Player.getIdentifier())
            local RoomInviteTablo = {
                {
                    sender = src,
                    Name = Playerdetayls.firstname,
                    Lastname = Playerdetayls.lastname,
                    target = players[i]
                }
            }
            cb(RoomInviteTablo)
        end
    end
end)


 
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        if Config.Data.Database == "ghmattimysql" then
            MotelData = exports.ghmattimysql:execute('SELECT * FROM `oph3z_motel`')
        else
            MotelData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_motel`')
        end
    
        for k, v in ipairs(MotelData) do
            local rooms = json.decode(v.rooms)
            if Config.Data.Inventory == "ox" then
                Wait(1000)
                for i = 1, #rooms, 1 do
                    local motelno = Config.Motels[k].Motelid
                    local odano = rooms[i].motelno
                    OdaType = rooms[i].type
                    StashSlots = tostring(OdaType.."s")
                    exports.ox_inventory:RegisterStash("Motel_"..motelno..'_'..odano, "Motel_"..odano, Config.Data[StashSlots],  Config.Data[OdaType], nil)
                end
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:OpenRoom", function (motelno, odano, odatipi, OdaType, OdaTheme, OdaStrip, OdaBooze)
    local src = source 
    local user = ESX.GetPlayerFromId(src)
    local cid = user.getIdentifier()
    if not Config.Motels[motelno].Rooms[odano].Bucketid then
        local  bucketroomnumber = tonumber(string.format("%d%d", motelno, odano))
        Config.Motels[motelno].Rooms[odano].Bucketid = bucketroomnumber
    end

    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
    KisilerinVerileri[src] = {
        Motelno = motelno,
        Odano = odano,
        OdaTipi = odatipi,
        OdaType = OdaType,
        Odatasarimi = OdaTheme,
        OdaStrip = OdaStrip,
        OdaBooze = OdaBooze,
        citizenid = cid
    }
    StashSlots = tostring(OdaType.."s")

    SetPlayerRoutingBucket(src, Config.Motels[motelno].Rooms[odano].Bucketid)
    TriggerClientEvent("oph3z-motels:client:OpenRoom", src, motelno, odano, odatipi, OdaType,OdaTheme, OdaStrip, OdaBooze)
end)


RegisterNetEvent("oph3z-motels:server:InvitePlayerRequest", function(data)
    local src = source
    local misafir = tonumber(data.misafir)
    local evsahibi = tonumber(data.evsahibi)
    local PlayerE = ESX.GetPlayerFromId(evsahibi)
    Playerdetayls = Config.GetPlayer(PlayerE.getIdentifier())
    local SenderName =  {
        firstname = Playerdetayls.firstname,
        lastname = Playerdetayls.lastname,
        source = PlayerE.source,
    }

    TriggerClientEvent("oph3z-motels:client:InvitePlayerRequest", misafir, data, SenderName)
end)

RegisterNetEvent("oph3z-motels:server:InvitePlayerRequestFriends", function (data)
    local src = source
    local misafir = tonumber(data.misafir)
    local evsahibi = tonumber(data.evsahibi)
    local PlayerE = ESX.GetPlayerFromId(evsahibi)
    Playerdetayls = Config.GetPlayer(PlayerE.getIdentifier())
    local SenderName =  {
        firstname = Playerdetayls.firstname,
        lastname = Playerdetayls.lastname,
        source = PlayerE.source,
    }

    TriggerClientEvent("oph3z-motels:client:InvitePlayerRequestFriends", misafir, data, SenderName)
end)

RegisterNetEvent("oph3z-motels:server:FriendsPlayerRequest", function(data)
    local src = source
    local misafir = tonumber(data.misafir)
    local evsahibi = tonumber(data.evsahibi)
    local PlayerE = ESX.GetPlayerFromId(evsahibi)
    Playerdetayls = Config.GetPlayer(PlayerE.getIdentifier())
    
    local SenderName =  {
        firstname = Playerdetayls.firstname,
        lastname = Playerdetayls.lastname,
        source = PlayerE.source,
    }
    TriggerClientEvent("oph3z-motels:client:FriendsPlayerRequest", misafir, data, SenderName)
end)

RegisterNetEvent("oph3z-motels:server:NearbyRequest", function(data)
    source = source
    local Player = ESX.GetPlayerFromId(source)
    Playerdetayls = Config.GetPlayer(Player.getIdentifier())
    local SenderName =  {
        source = Player.source,
        firstname = Playerdetayls.firstname,
        lastname = Playerdetayls.lastname,
    }
    TriggerClientEvent("oph3z-motels:client:NearbyRequest", data.playersource, data, SenderName)
end)

RegisterNetEvent("oph3z-motels:server:RoomInviteAccept", function (data)
    motelno = data.davetmotelid
    odano = data.davetodano
    odatipi = tostring(data.davetodatipi..motelno)
    OdaType = data.davetodatipi
    OdaTheme = data.davetodatheme
    OdaStrip = data.davetodastrip
    OdaBooze = data.davetodabooze
    local src = source 
    local user = ESX.GetPlayerFromId(src)
    local cid = user.getIdentifier()
    if not Config.Motels[motelno].Rooms[odano].Bucketid then
        local  bucketroomnumber = tonumber(string.format("%d%d", motelno, odano))
        Config.Motels[motelno].Rooms[odano].Bucketid = bucketroomnumber
    end

    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
    KisilerinVerileri[src] = {
        Motelno = motelno,
        Odano = odano,
        OdaTipi = odatipi,
        OdaType = OdaType,
        Odatasarimi = OdaTheme,
        OdaStrip = OdaStrip,
        OdaBooze = OdaBooze,
        citizenid = cid
    }
    SetPlayerRoutingBucket(src, Config.Motels[motelno].Rooms[odano].Bucketid)
    TriggerClientEvent("oph3z-motels:client:OpenRoom", src, motelno, odano, odatipi, OdaType, OdaTheme, OdaStrip, OdaBooze)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local tablo = KisilerinVerileri[src]
    if tablo then
        local MotelData = MySQL.query.await('SELECT * FROM `oph3z_motel` WHERE id = @id', {["@id"] = tablo.Motelno})
        local BucketCache = json.decode(MotelData[1].bucketcache)
        SetPlayerRoutingBucket(src, 0)
        table.insert(BucketCache, {
            citizenid = tablo.citizenid,
            Motelno = tablo.Motelno,
            OdaTipi = tablo.OdaTipi,
            Odatasarimi = tablo.Odatasarimi,
            OdaType = tablo.OdaType,
            Odano =  tablo.Odano,
            OdaStrip = tablo.OdaStrip,
            OdaBooze = tablo.OdaBooze
        })
        MySQL.Async.execute('UPDATE `oph3z_motel` SET bucketcache = @bucketcache WHERE id = @id', {["@bucketcache"] = json.encode(BucketCache), ["@id"] = tablo.Motelno})
    end
end) 

RegisterNetEvent("esx:playerLoaded", function (newsource)
    Wait(2000)
    local src = newsource
    local Player = ESX.GetPlayerFromId(src)
    local cid = Player.getIdentifier()
    local MotelData = MySQL.query.await('SELECT * FROM `oph3z_motel`')

    local foundRoom = false
    Wait(2000)
    for i=1, #MotelData, 1 do
        local newbucket = json.decode(MotelData[i].bucketcache)
        local room = json.decode(MotelData[i].rooms)

        for j=1, #room, 1 do
            for k=1, #newbucket, 1 do
                local info = json.decode(MotelData[i].info)    
                if info.Motelid == newbucket[k].Motelno and room[j].motelno == newbucket[k].Odano and newbucket[k].citizenid and newbucket[k].citizenid == cid and room[j].Owner.RoomsOwner == cid then
                    local bucketroomnumber = tonumber(string.format("%d%d", newbucket[k].Motelno, newbucket[k].Odano))
                    SetPlayerRoutingBucket(src, bucketroomnumber)
                    TriggerClientEvent("oph3z-motels:client:AdamYoruyorsunuz", src, newbucket[k].Motelno, newbucket[k].Odano, newbucket[k].OdaType, newbucket[k].OdaTipi, newbucket[k].Odatasarimi, newbucket[k].OdaStrip, newbucket[k].OdaBooze, newbucket[k].citizenid)
                    table.remove(newbucket, k)
                    MySQL.Async.execute('UPDATE `oph3z_motel` SET bucketcache = @bucketcache WHERE id = @id', {["@bucketcache"] = json.encode(newbucket), ["@id"] = MotelData[i].id})
                    foundRoom = true
                    break
                end
            end

            if foundRoom then
                break
            end

        end
    end
    if not foundRoom then
        for i=1, #MotelData, 1 do
            local newbucket = json.decode(MotelData[i].bucketcache)
            local info = json.decode(MotelData[i].info)
            for k=1, #newbucket, 1 do
                if info.Motelid == newbucket[k].Motelno and newbucket[k].citizenid == cid then
                    TriggerClientEvent("oph3z-motels:client:OdaBitti", src, info.Motelid)
                    Config.ServerNotify(src, Config.Langue["RoomExitExpired"][1],Config.Langue["RoomExitExpired"][2],Config.Langue["RoomExitExpired"][3])
                    table.remove(newbucket, k)
                    MySQL.Async.execute('UPDATE `oph3z_motel` SET bucketcache = @bucketcache WHERE id = @id', {["@bucketcache"] = json.encode(newbucket), ["@id"] = MotelData[i].id})
                    break
                end
            end
        end
    end
end)

RegisterNetEvent("oph3z-motels:server:ExitRoom", function ()
    local src = source
    SetPlayerRoutingBucket(src, 0)
    TriggerClientEvent("oph3z-motels:client:ExitRoom", src)
    KisilerinVerileri[src] = {}
    TriggerClientEvent("oph3z-motels:Update", -1, Config.Motels, ScriptLoaded)
end)

ESX.RegisterServerCallback('oph3z-motels:Server:GetPlayerClothes', function(source, cb)
	local Player = ESX.GetPlayerFromId(source)
    local cid = Player.getIdentifier()
	TriggerEvent('esx_datastore:getDataStore', 'property', cid, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('oph3z-motels:Server:GetPlayerOutfits', function(source, cb, num)
	local Player = ESX.GetPlayerFromId(source)
    local cid = Player.getIdentifier()
	TriggerEvent('esx_datastore:getDataStore', 'property', cid, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('oph3z-motels:Server:DeleteOutfit', function(label)
	local Player = ESX.GetPlayerFromId(source)
    local cid = Player.getIdentifier()
    TriggerEvent('esx_datastore:getDataStore', 'property', cid, function(store)
        local dressing = store.get('dressing')
        if dressing == nil then
            dressing = {}
        end
        label = label
        table.remove(dressing, label)
        store.set('dressing', dressing)
    end)
end)