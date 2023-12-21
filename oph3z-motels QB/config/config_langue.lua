Config.Langue = {
    ["NotPermissionsMotelSell"] = {"This motel is not available for sale", "error", 5000},
    ["NotPermissionsMotelTransfer"] = {"This motel is not available for transfer", "error", 5000},
    ["RoomTimeExpired"] = {"This motel is not available for transfer", "error", 5000},
    ["RoomTimeUp"] = {"Your motel room's duration has been extended.", "success", 5000},
    ["InsufficientBankFunds"] = {"You don't have enough money in your bank account.", "error", 5000},
    ["InsufficientCashFunds"] = {"You don't have enough cash on hand.", "error", 5000},
    ["AlreadyOwnerEmployess"] = {"The person you are trying to hire is already the owner.", "error", 5000},
    ["PlayerNotFound"] = {"Player not found", "error", 5000},
    ["NotEnoughMoneySalary"] = {"Your salary could not be paid. There is not enough money in the motel cash register.", "error", 5000},
    ["NotEnoughMoney"] = {"We don't have enough money in our motel business for this transaction.", "error", 5000},
    ["RoomExitExpired"] = "Your motel room has been removed because your stay expired and your last location was in the room.",
    ["UpgradeRoom"] = function(roomNumber, roomType)
        return {"The type of motel room "..roomNumber.." has been changed to "..roomType.."", "success", 5000}
    end,
    ["RoomRepaired"] = function(roomNumber)
        return {"Room Repaired: Room "..roomNumber.." has been successfully reopened for use.", "success", 5000}
    end,
    ["UpgradeRoomRequest"] = function(roomNumber, roomType)
        return {"You have requested a change of type for the motel room "..roomNumber.." to "..roomType.."", "success", 5000}
    end,
    ["CancelRequest"] = function(roomNumber)
        return {"You have rejected the room modification request for room number "..roomNumber..".", "success", 5000}
    end,
    ["EmployesSalary"] = function(salary)
        return {"Your motel business salary has been paid. Received salary: $"..salary..".", "success", 5000}
    end,
    ["NotEnoughMoneySalaryOwner"] = function(motelName)
        return {"Due to insufficient funds in the cash register of "..motelName.." motel, employees' salaries cannot be paid.", "error", 5000}
    end,
    ["MaxMotelBuznizLimit"] = function(motelCount)
        return {"You cannot purchase more motel businesses. You already have a total of "..motelCount.." motel businesses.", "error", 5000}
    end,
    ["MaxMotelRoomLimit"] = function(motelCount)
        return {"You cannot purchase more motel room. You already have a total of "..motelCount.." motel room.", "error", 5000}
    end,
    ["MaxMotelRoomFriendsimit"] = function(motelCount)
        return {"You cannot purchase more motel room. You already have a total of "..motelCount.." motel room.", "error", 5000}
    end,
    ["PurchaseMotelSuccess"] = function(motelName)
        return {"You have successfully purchased the motel business named "..motelName..". Have a great day!", "success", 5000}
    end,
    ["SaveDashboard"] = function(motelName)
        return {"You have successfully changed the motel name to "..motelName..".", "success", 5000}
    end,
    ["MotelSellSuccess"] = function(motelName, sellPrice, tax, addPrice)
        return {"Motel Sale"..motelName.." has been sold. Sales Price: $"..sellPrice.."Tax: $"..tax.."Total Amount: $"..addPrice.."Thank you for your purchase.", "success", 5000}
    end,
    ["MotelTransferSuccess"] = function(motelName, transferFirstName, transferLastName)
        return {"Motel Transfer: You have transferred your motel to "..transferFirstName.." "..transferLastName..".\n\nMotel Name: "..motelName, "success", 5000}
    end,
    ["MotelTransferSuccess2"] = function(motelName)
        return {"Motel Transfer The motel named "..motelName.." has been transferred to you.", "success", 5000}
    end,
    ["AcceptRoomOffer"] = function(motelName, roomNumber, price)
        return {"Motel Room Rental You have rented room number "..roomNumber.." at "..motelName.." for $"..price..".\n\nHave a great day!", "success", 5000}
    end,
    ["AlreadyFriends"] = function(firstName, lastName)
        return {"Already Friends", firstName.." "..lastName.." is already added as a friend to this motel room.", "error", 5000}
    end,
    ["AddFriendsSuccess"] = function(firstName, lastName)
        return {"Friend Added: You have successfully added "..firstName.." "..lastName.." as a friend.", "success", 5000}
    end,
    ["KickFriendSuccess"] = function(firstName, lastName)
        return {"Friend Kicked: You have successfully kicked "..firstName.." "..lastName.." from the room.", "success", 5000}
    end,
    ["RankDownSuccess"] = function(name)
        return {"Rank Down: The rank of "..name.." has been decreased.", "success", 5000}
    end,
    ["RankUpSuccess"] = function(name)
        return {"Rank Up: The rank of "..name.." has been increased.", "success", 5000}
    end,
    ["SalaryChangeSuccess"] = function(name, newsalary)
        return {"Salary Change: The salary of "..name.." has been updated to $"..newsalary..".", "success", 5000}
    end,
    ["AlreadyEmployee"] = function(name)
        return {"The person you are trying to hire, "..name..", is already an employee.", "error", 5000}
      end,
    ["JobOfferAccepted"] = function (motelname)
        return {"Job Offer: You have accepted the job offer from "..motelname.." motel.", "success", 5000}
    end
}