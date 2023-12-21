------------------------------ Oph3z-Motels - Installation Guide -----------------------------------

For Support: https://discord.gg/Pnq5R4HszK

---------------------------------------------------------------------------------------------------------------------------------
REQUIREMENTS (
    bob74_ipl: https://github.com/Bob74/bob74_ipl
)
---------------------------------------------------------------------------------------------------------------------------------
DO NOT FORGET TO READ THE SQL FILE
oph3z-motel.sql
---------------------------------------------------------------------------------------------------------------------------------
The starting order of the scripts should be as follows;
ensure bob74_ipl
ensure oph3z-motels

---------------------------------------------------------------------------------------------------------------------------------
There is a detailed description in the config files
---------------------------------------------------------------------------------------------------------------------------------
config.lua
You can make general settings of the script in the config.lua file
---------------------------------------------------------------------------------------------------------------------------------
config_motels.lua 
In the config_motels file you can add new motels and rooms and change the settings of the rooms, detailed description is at the end of the file
---------------------------------------------------------------------------------------------------------------------------------
config_langue.lua
In the config_langue file you can set and change notifications, to set the notification script you need to edit Config.Notify and Config.ServerNotify in the config.lua file
---------------------------------------------------------------------------------------------------------------------------------
lang.lua
In the lang.lua file, you can edit the text on the UI as you wish or translate it into a different language
---------------------------------------------------------------------------------------------------------------------------------
Detailed explanation for Config.Map in config.lua

The part that says VIP is the room type and the part that says 1 is the motel id. When VIP2 is written, it means the VIP room of motel id number 2.

export name export name of the map in bob74_ipl
    ["VIP1"] = {  
        exportName = "GetExecApartment2Object", https://github.com/Bob74/bob74_ipl/blob/master/dlc_executive/apartment2.lua  export name export name of the map in bob74_ipl
        out = vector3(-779.08, 339.69, 196.69), coordinates for entering and exiting the out room
        manage = vector3(-777.21, 331.06, 196.09), manage is where you make room settings for adding roommates and inviting them to the room
        stash = vector3(-766.01, 330.97, 196.09), stash is the coordinate of the storage inventory
        wardrobe = vector3(-764.74, 329.01, 199.49), wardrobe coordinates
        ThemeData = { themeData is the part where you edit the room styles you want for that motel room in the same file as the file you exportname.
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
---------------------------------------------------------------------------------------------------------------------------------

Name:
defalut motel name

Location:
Location on the street where the motel is located

Description
Detailed description about Description motel

Job:
Job part is currently disabled
Do not confuse this with the order of the motelid motel in the table.

These appear to be from the purchase of the motel business.
TotalRooms:
write the total number of rooms in the motel

ActiveRooms:
Please specify how many active rooms in the motel

DamagedRooms:
Please specify how many damaged rooms in the motel

Price:
selling price of the motel business

VIPUpgradeMoney:
The amount the room has to pay for the VIP upgrade

MiddleUpgradeMoney:
The amount the room has to pay for the Middle upgrade

CompanyMoney:
Startup money when you buy a motel business

RentMotel:
Coordinate where players should go to rent a motel when there is no motel owner

OpenBossMenu:
Bossmenu coordinate for employees and boss to open

MotelCamDashboard:
Aerial view coordinates during the purchase of the motel business

History:
You do not need to touch the part where the withdrawal and deposit process is kept

Blip: you can turn the blips off and on
BlipSettings =  adjust the blip settings  https://docs.fivem.net/docs/game-references/blips/
ID = , -- Blip ID
Scale = , -- Blip Size
Color =  -- Color of the Blip


Rooms.Coords: 
coordinate to enter the room

Room.motelno:
Do not confuse the order of the room in the table, increase order by order

Room.Active:
whether the room will be active at startup

Room.Rent:
whether it was originally leased

Room.type:
initially the type of room VIP-Middle-Squatter

Room.theme:
initially the theme of the walls of the room

Room.wall:
currently disabled

Room.money:
rental price of the room   In the absence of a motel owner, the rental fee for a 24-hour room is determined.

Room.fixmoney
no touching

Room.strip
opens and closes the underwear in the room

Room.booze
opens and closes the liquor bottles in the room


    [1] =  {
        Owner = "",
        Name = "EXAMPLE MOTEL",
        Location = "VINEWOOD",
        Description = "lorem",
        Job = "motel1",
        Motelid = 1,
        TotalRooms = 26,
        ActiveRooms = 16,
        DamagedRooms = 10,
        Price = 20000,
        VIPUpgradeMoney = 50000,
        MiddleUpgradeMoney = 25000,
        CompanyMoney = 1000,
        RentMotel = vector3(961.55, -193.98, 73.21),
        OpenBossMenu = vector3(200.55, -193.98, 73.21),
        MotelCamDashboard = vector4(966.35, -190.22, 79.4, 164.43),
        History = {},
        Employes = {
            Name = "",
            Salary = 0,
            Rank = 0,
            Citizenid = "",
        },
        Blip = true, -- Enable/Disable Blip
        BlipSettings = {
            ID = 475,
            Scale = 1.0,
            Color = 29
        },
        Rooms = {
            {
                Coords = vector4(953.13, -196.52, 73.22, 64.62),
                motelno = 1,
                Active = true, 
                Rent = false, 
                type = "Squatter",
                theme = "modern",
                wall = "black",
                money = 5000, -- In the absence of a motel owner, the rental fee for a 24-hour room is determined.
                fixmoney = "",
                strip = false,
                booze = true,
                Owner = {
                    Name = "",
                    Lastname = "",
                    PhoneNumber = "",
                    Date = "",
                    RoomsOwner = "",
                    MyMoney = "",
                    Friends = {
                        Citizenid = nil,
                        Name = nil,
                        Lastname = nil,
                    },
                },
                StyleMenu = {
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644075303669810/modern.png",
                        name = "modern",
                        durum = true,
                        price = 5000,
                    },
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644076520030218/seductive.png",
                        name = "seductive",
                        durum = false,
                        price = 5000
                    },
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644075978969108/moody.png",
                        name = "moody",
                        durum = false,
                        price = 5000,
                    },
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644074599039027/vibrant.png",
                        name = "vibrant",
                        durum = false,
                        price = 5000,
                    },
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644076872355973/sharp.png",
                        name = "sharp",
                        durum = false,
                        price = 5000,
                    },
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644075555340441/monochrome.png",
                        name = "monochrome",
                        durum = false,
                        price = 5000,
                    },
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644076247388231/regal.png",
                        name = "regal",
                        durum = false,
                        price = 5000,
                    },
                    {
                        type = "style",
                        png = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644074989113344/aqua.png",
                        name = "aqua",
                        durum = false,
                        price = 5000,
                    },
                    {
                        type = "extra",
                        png = "https://cdn.shopify.com/s/files/1/0178/2936/3812/products/1_42_1024x1024.png?v=1617035503",
                        name = "strip",
                        durum = false,
                        price = 5000,
                    },
                    {
                        type = "extra",
                        png = "https://e7.pngegg.com/pngimages/85/460/png-clipart-riga-black-balsam-cocktail-gin-distilled-beverage-alcohol-splash.png",
                        name = "booze",
                        durum = true,
                        price = 5000,
                    },
               }
            },
    },
}



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Add these codes to fivem-appearance client.lua file


RegisterNetEvent('fivem-appearance:Oph3zMotel', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Change Outfit",
            txt = "",
            params = {
                event = "fivem-appearance:pickNewOutfitMotel",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
		{
            id = 2,
            header = "Save New Outfit",
            txt = "",
			params = {
				event = "fivem-appearance:saveOutfit"
			}
        },
		{
			id = 3,
            header = "Delete Outfit",
            txt = "",
            params = {
                event = "fivem-appearance:deleteOutfitMenuMotel",
                args = {
                    number = 1,
                    id = 2
                }
            }
        }
    })
end)

RegisterNetEvent('fivem-appearance:pickNewOutfitMotel', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('fivem-appearance:getOutfits')
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "< Go Back",
            txt = "",
            params = {
                event = "fivem-appearance:Oph3zMotel"
            }
        },
    })
	Citizen.Wait(300)
	for i=1, #allMyOutfits, 1 do
		TriggerEvent('nh-context:sendMenu', {
			{
				id = (1 + i),
				header = allMyOutfits[i].name,
				txt = "",
				params = {
					event = 'fivem-appearance:setOutfit',
					args = {
						ped = allMyOutfits[i].pedModel,
						components = allMyOutfits[i].pedComponents,
						props = allMyOutfits[i].pedProps
					}
				}
			},
		})
	end
end)

RegisterNetEvent('fivem-appearance:saveOutfitMotel', function()
    if Config.UseNewNHKeyboard then
        local keyboard, name = exports["nh-keyboard"]:Keyboard({
            header = "Name Outfit",
            rows = {"Outfit name here"}
        })
        if keyboard then
            if name then
                local playerPed = PlayerPedId()
                local pedModel = exports['fivem-appearance']:getPedModel(playerPed)
                local pedComponents = exports['fivem-appearance']:getPedComponents(playerPed)
                local pedProps = exports['fivem-appearance']:getPedProps(playerPed)
                Citizen.Wait(500)
                TriggerServerEvent('fivem-appearance:saveOutfit', name, pedModel, pedComponents, pedProps)
            end
        end
    else
        local keyboard = exports["nh-keyboard"]:KeyboardInput({
            header = "Name Outfit",
            rows = {
                {
                    id = 0,
                    txt = ""
                }
            }
        })
        if keyboard ~= nil then
            local playerPed = PlayerPedId()
            local pedModel = exports['fivem-appearance']:getPedModel(playerPed)
            local pedComponents = exports['fivem-appearance']:getPedComponents(playerPed)
            local pedProps = exports['fivem-appearance']:getPedProps(playerPed)
            Citizen.Wait(500)
            TriggerServerEvent('fivem-appearance:saveOutfit', keyboard[1].input, pedModel, pedComponents, pedProps)

        end
    end
end)


RegisterNetEvent('fivem-appearance:deleteOutfitMenuMotel', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('fivem-appearance:getOutfits')
	Citizen.Wait(150)
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "< Go Back",
            txt = "",
            params = {
                event = "fivem-appearance:Oph3zMotel"
            }
        },
    })
	for i=1, #allMyOutfits, 1 do
		TriggerEvent('nh-context:sendMenu', {
			{
				id = (1 + i),
				header = allMyOutfits[i].name,
				txt = "",
				params = {
					event = 'fivem-appearance:deleteOutfit',
					args = allMyOutfits[i].id
				}
			},
		})
	end
end)

