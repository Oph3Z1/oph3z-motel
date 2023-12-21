var CurrentMenu = "pwodalar"
var yarraminbasi = []
var Test = "pwodalar"
var middlesectin = false
var vipsectin = false
var CurrentMenu2 = null
var LoadSquatter = null
var Money = null
var LoadCustomerMenu = null
var LoadMiddle = null
var RoomInvitedata = null
var LoadNearby = null
var MotelRoomPrice = 0
var CurrentMotel = null
var CurrentNO = null
var CurrentTime = null
var CurrentPrice = null
var CurrentMotelID = 0
var MotelNameVar = null
var BuyMotelMenuActive = false
var BossMenuActive = false
var ChanceMotelName1 = null
var search = null
var depositnumber = 0
var withdrawnumber = 0
var CurrentMotel2 = 0
var MotelCount = 0
var nearbplayersyprice = 0
var customersmotelno = null
var EmployesInvite = false
var NearbyInvite = false
var MotelRoomUpHourse = 0
var FixmenuActive = false
var UpgradeMenuActive = false
var hisyoryfalan = []
var motelstwo = []
let motels = []
var GiveMotelSource = 0
var GiveMotelRoom = 0
var newprice = 0
var GiveMotelName = "OrospuÇocuğuAKP"
var GiveMotelType = "OÇAKP"
var NearbyPlayersF = 0
var LoadTwo = null
var motelfixnumber = null
var moteltype = null
var motelupgradenumber = null
var motelintypiabe = null
var SuanMiddleOluyorAbe = null
var SuanVIPOluyorAbe = null
var middleClickable = false;
var vipClickable = false;
var CheckAnan = false
var MotelManagementFlex = false
var ChanceStyleRequest = false
var ManagetmentOdaNo =  null
var ManagetmentMotelNO = null
var TransferMotelID = null
var motelupgradeprice = 0
var SelectedMenu = "management-nearby"
var ananknkbenimanam = 0
var regalurl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644076247388231/regal.png"
var modernurl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644075303669810/modern.png"
var seductiveurl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644076520030218/seductive.png"
var moodyurl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644075978969108/moody.png"
var vibranturl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644074599039027/vibrant.png"
var sharpurl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644076872355973/sharp.png"
var monochromeurl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644075555340441/monochrome.png"
var aquaurl = "https://cdn.discordapp.com/attachments/1095505976725078167/1106644074989113344/aqua.png"
var translate = []

$(function() {
    window.addEventListener('message', function(event) {
        var type = event.data.type
        var data = event.data
        if (type === "OpenMotel") {
            CurrentMotelID = data.motelid
            MotelNameVar = data.name
            translate = data.translate
            OpenMotel(data.data)
        } else if (type === "OpenBuyMenu") {
            motels = data.data.motel
            CurrentMotel2 = 0
            MotelCount = data.data.motelcount
            translate = data.translate
            UpdateMotel()
            OpenBuyMenu(data.data)
        } else if (type === "OpenBossMenu") {
            CurrentMotelID = data.motelid
            hisyoryfalan = data.data.motel.History
            GiveMotelName = data.data.motel.Name
            LoadTwo = data.data
            translate = data.translate
            LoadHistory(data.data.motel.History)
            UpdateBossMenu(data.data)
            OpenBossMenu(data.data)
            LoadCustomerMenu(data.data)
            LoadMotelCare(data.data, data.yarrak)
            LoadEmployeesMenu(data.data)
        } else if (type === "LoadPlayers") {
            LoadEmployeesNearby(data.players)
            LoadNearbyPlayers(data.players)
            NearbyFriends(data.players)
        } else if (type === "SendNearbyRequest") {
            SendReq(data.data, data.sendername)
        } else if (type === "SendInviteEmployee") {
            $(".send-request").css("display", "flex");
            $(".send-request").html("");
            $(".send-request").html(`
            <span>You received a job offer from motel, do you want to accept it?</span>
            <div class="accept-offer" id="${data.data.playersource}" motelid="${data.data.motelid}" sender="${data.sendername.source}"> <span>Accept</span> </div>
            <div class="decline-offer"> <span>Decline</span> </div>
            `);
        } else if (type === "MotelManagement") {
            translate = data.translate
            MotelManagement(data)
            data = requestdata
        } else if (type === "LoadPlayers1") {
            RoomInvitedata = data.RoomInvite
            NearbyFriends(data.RoomInvite)
        } else if (type === "SendRoomInviteRequest") {
            translate = data.translate
            SendRoomInviteReq(data, data.sendernameRoom)
        } else if (type === "SendRoomFriendsRequest") {
            translate = data.translate
            SendRoomFriendsReq(data, data.sendernameRoom)
        } else if (type === "SendTransferMotelUI") {
            translate = data.translate
            SendTransferMotelUI(data, data.sendernameRoom)
        }
    })

    $("#motel-time-input").on("input", function() {
        var time = parseInt($(this).val());
        var days = Math.floor(time / 24);
        var hours = time % 24;
        var price = MotelRoomPrice / 24;
        $("#motel-price-soru").text(Math.floor(price * time) + "$");
        CurrentPrice = price * time;
        CurrentTime = $(this).val();
        if (days > 0 && hours > 0) {
            $("#motel-time-input-text").text(days + " D " + hours + "H");
        } else if (days > 0) {
            $("#motel-time-input-text").text(days + "D");
        } else if (hours > 0) {
            $("#motel-time-input-text").text(hours + "H");
        } else {
            $("#motel-time-input-text").text("0");
        }
    });
    
    
    


    $("#nearby-players-settings-price").on("input", function() {
        nearbplayersyprice = $(this).val();
    });

    $(".new-time").on("input", function(){
        ekmotelhours = $(this).val();
        var price = Math.floor(MotelRoomUpHourse / 24)
        ananknkbenimanam = price * ekmotelhours
        $(".tu-price").text("$" + PE3D(price * ekmotelhours) )

    })

    $("#nearby-players-settings-time").on("input", function() {
        var time = $(this).val();
        var days = Math.floor(time / 24);
        var hours = time % 24;
        NearbyCurrentTime = $(this).val()

    });

    $("#w-amount").on("input", function() {
        withdrawnumber = $(this).val();
    });

    $("#d-amount").on("input", function() {
        depositnumber = $(this).val();
    });

    $("#chancemotelname").on("input", function() {
        ChanceMotelName1 = $(this).val()
    });

    $("#transfermotelid").on("input", function() {
        TransferMotelID = $(this).val()
    });

    $(".motel-satinalma-solbtn").click(function() {
        if (CurrentMotel2 > 0) {
            CurrentMotel2--;
            UpdateMotel();
        }
        $.post('https://oph3z-motels/MotelNoCekme', JSON.stringify({
            motelno: CurrentMotel2 + 1,
        }))
    })

    $("#w-submit").click(function() {
        $.post('https://oph3z-motels/CompanyMoney', JSON.stringify({
            Money: withdrawnumber,
            motelno: CurrentMotel2 + 1,
            Parayatirma: false
        }))
        withdrawnumber = null
        $("#w-amount").val("")
    })

    $("#d-submit").click(function() {
        $.post('https://oph3z-motels/CompanyMoney', JSON.stringify({
            Money: depositnumber,
            motelno: CurrentMotel2 + 1,
            Parayatirma: true
        }))
        $("#d-amount").val("")
        depositnumber = null
    })


    $(".motel-satinalma-sagbtn").click(function() {
        if (CurrentMotel2 < motels.length - 1) {
            CurrentMotel2++;
            UpdateMotel();
        }
        $.post('https://oph3z-motels/MotelNoCekme', JSON.stringify({
            motelno: CurrentMotel2 + 1,
        }))
    })

    function UpdateMotel() {
        if (motels[CurrentMotel2].Owner == "") {
            $("#motel-satinalma-buybtn-txt").css("cursor", "pointer");
            $("#motel-satinalma-buybtn-txt").html(translate["buy"])

        } else {
            $(".motel-satinalma-buybtn").css("background", "linear-gradient(90.43deg, rgba(230, 230, 230, 0.3) 0.28%, rgba(170, 170, 170, 0.3) 103.35%)")
            $(".motel-satinalma-buybtn").css("border-color", "rgba(255, 255, 255, 0.45)")
            $("#motel-satinalma-buybtn-txt").css("cursor", "not-allowed");
            $("#motel-satinalma-buybtn-txt").html(translate["sold"])
        }
        $("#motel-satinalma-bakilannumber").html(CurrentMotel2 + 1)
        $("#motel-satinalma-totalnumber").html("/" + MotelCount)
        $("#isletme-motelname").html(motels[CurrentMotel2].Name)
        $("#isletme-motelkonum").html(motels[CurrentMotel2].Location)
        $("#isletme-motelaciklama").html(motels[CurrentMotel2].Description)
        $("#active-motelrooms-number").html(motels[CurrentMotel2].ActiveRooms)
        $("#active-motelrooms").html(translate["activetotalroomstext"])
        $("#total-motelrooms-number").html(motels[CurrentMotel2].TotalRooms)
        $("#active-motelrooms").html(translate["totaltotalroomstext"])
        $("#damaged-motelrooms-number").html(motels[CurrentMotel2].DamagedRooms)
        $("#active-motelrooms").html(translate["damagedtotalroomstext"])
        $("#isletme-price-txt").html(translate["pricetxt"])
        $("#isletme-price").html("$ " + PE3D(motels[CurrentMotel2].Price))
       
    }

    function UpdateBossMenu(data) {
        $("#motelkonumbosmenmu").html(data.motel.Location)
        $("#moteisim").html(data.motel.Name)
        $(".aciklama > span").html(data.motel.Description)
        $(".d-total-rooms > p").html(data.motel.Rooms.length + " " + translate["rooms"])
        $(".d-active-rooms > p").html(data.motel.ActiveRooms + " " + translate["rooms"])
        $(".total-customers > p ").html(data.motel.Employes.length + " " + translate["employee_second"])
        $(".c-dashboard > p").html("$" + data.motel.CompanyMoney)
    }

    $(".motel-satinalma-buybtn").click(function() {
        $.post('https://oph3z-motels/CurrentMotelBuy', JSON.stringify({
            motel: CurrentMotel2 + 1,
            price: motels[CurrentMotel2].Price
        }))
        $(".motel-satinalma-buybtn").css("background", "linear-gradient(90.43deg, rgba(230, 230, 230, 0.3) 0.28%, rgba(170, 170, 170, 0.3) 103.35%)")
        $(".motel-satinalma-buybtn").css("border-color", "rgba(255, 255, 255, 0.45)")
        $("#motel-satinalma-buybtn-txt").css("cursor", "not-allowed");
        $("#motel-satinalma-buybtn-txt").html("Sold")
    })

    $("#search-customers").on('keyup', function() {
        var search = $(this).val().toLowerCase()
        if (search != '') {
            $('.c-list-body > div').hide();
            $('.c-list-body > div').each(function(){
              var nameValue = $(this).find('#c-c-l-name').text().toLowerCase()
              if(nameValue.indexOf(search) !== -1){
                $(this).show();
              }
            });
        } else {
            $('.c-list-body > div').show();
        }
    })

})

OpenBuyMenu = function(data) {
    $(".motel-isletme-satin-alma-ekrani").css("display", "flex");
    BuyMotelMenuActive = true
    $.post('https://oph3z-motels/MotelNoCekme', JSON.stringify({
        motelno: CurrentMotel2 + 1,
    }))
}

OpenMotel = function(data) {
    $("#motelinformation").html(translate["motel_information"])
    $("#mi-description").html(translate["motel_information_text"])
    $("#motel-rooms-header").html(translate["motel_rooms_header"])
    $(".anan3").html(translate["vip_rooms_text"])
    $(".anan2").html(translate["middle_rooms_text"])
    $("#ananlar").html(translate["squatter_rooms_text"])
    $("#total-motel-rooms").html(translate["total_rooms_text"])
    $("#availablemotelrooms").html(translate["available_motel_rooms"])
    $("#exit-text-openmenu").html(translate["exit_text_openmotel"])

    $(".rent-motel-rooms").css("display", "flex");
    $("#motelname").html(data.name)
    $("#motelkonum").html(data.location)
    $(".aciklama > span").html(data.description)
    $("#activeroomsnumberfalan").html(data.activeRooms + " Rooms")
    $("#totalroomsnumberfalan").html(data.totalRooms + " Rooms")
    LoadSquatter = data.motel.Rooms
    LoadMiddle = data.motel.Rooms
    LoadVIP = data.motel.Rooms
    MotelNameVar = data.name
    if (Test === "pwodalar") {
        $(".pwodalari").addClass("badroomclick")
        $(".pwodalar").find(".anan").addClass("badroomclick2")
        $("#squatterimg").attr("src", "./img/black-squatter.png")
        LoadSquatterRooms(data.motel.Rooms, data.name);
    } else if (Test === "middle") {
        $(".middlerooms").addClass("middleroomclick")
        $(".middlerooms-img-text").find(".anan2").addClass("middleroomclick2")
        $("#middleimg").attr("src", "./img/black-door.png")
        LoadMiddleRooms(LoadMiddle, MotelNameVar)
    } else if (Test === "vip") {
        $(".viprooms").addClass("viproomclick")
        $(".viprooms-img-text").find(".anan3").addClass("viproomclick2")
        $("#vipimg").attr("src", "./img/vip.svg")
        LoadVIPRooms(LoadVIP, MotelNameVar)
    }
}

SendReq = function(data, seconddata) {
    var time = data.time;
    var days = Math.floor(time / 24);
    var hours = time % 24;
    if (days > 0 && hours > 0) {
        $("#motel-time").html(days + " D " + hours + " H");
    } else if (days > 0) {
        $("#motel-time").html(days + " D");
    } else if (hours > 0) {
        $("#motel-time").html(hours + " H");
    } else {
        $("#motel-time").html("0");
    }

    $(".send-room-invite").css("display", "flex")
    $(".sri-text").html(` ${seconddata.firstname + " " + seconddata.lastname} <span>invites you to rent a motel room</span> `)
    $("#motel-name").html(data.motelname)
    $("#motel-room").html(data.room + " " + " (" + data.roomtype + ")")
    $("#motel-price").html("$" + PE3D(data.price))
    GiveMotelRoom = data.room
    nearbplayersyprice = data.price
    NearbyCurrentTime = data.time
    CurrentMotelID = data.motelid
    senderId = seconddata.source
}
var davetmotelid = null
var davetmotelroom = null 


$(document).on("click", "#acceptreqq", function() {
    $.post('https://oph3z-motels/NearbyAccept', JSON.stringify({
        room: GiveMotelRoom,
        price: nearbplayersyprice,
        time: NearbyCurrentTime,
        motelid: CurrentMotelID,
        senderid: senderId
    }));
    $(".send-room-invite").css("display", "none")
    $(".sri-text").html("")
    $("#motel-name").html("")
    $("#motel-room").html("")
    $("#motel-time").html("")
    $("#motel-price").html("")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})

$(document).on("click", "#closereq", function() {
    $(".send-room-invite").css("display", "none")
    $(".sri-text").html("")
    $("#motel-name").html("")
    $("#motel-room").html("")
    $("#motel-time").html("")
    $("#motel-price").html("")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})

var requesttable = null
var motelinidsiknkistebu = null

OpenBossMenu = function(data) {
    $(".bossmenu").css("display", "flex");
    BossMenuActive = true
    $(".dashboardmenu").css("display", "flex");
    $("#openbossmenuactiverooms").html(data.ActiveTotalRooms + " ROOMS")
    $(".employeesmenu").css("display", "none")
    $(".companymenu").css("display", "none")
    $(".customersmenu").css("display", "none")
    $(".nearby-players-cat").css("display", "none")
    $(".motel-care-menu").css("display", "none")
    $(".motel-care-menu-request").css("display", "none")
    $(".dashboard ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
    $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
    $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
    $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
    $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
    $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
    $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
    motelstwo = data.rooms
    requesttable = data.requestdata
    motelinidsiknkistebu = data.name
    LoadHistory(data.motel.History)
    $(".employee-invite").css("display", "none");

    $("#bossmenu-motel-information").html(translate["motel_information_bossmenu"])
    $("#bossmenu-motel-information-text").html(translate["motel_information_bossmenu_text"])
    $("#exit-text").html(translate["exit"])
    $("#dashboard-text").html(translate["dashboard"])
    $("#employee-text").html(translate["employee"])
    $("#company-text").html(translate["company"])
    $("#customer-text").html(translate["customer"])
    $("#nb-text").html(translate["nearby_players"])
    $("#mc-text").html(translate["motel_care"])
    $("#request-text").html(translate["request"])
    $("#d-title").html(translate["dashboard_second"])
    $("#total-motel-rooms-text").html(translate["total_rooms"])
    $("#available-motel-rooms-text").html(translate["available_rooms"])
    $("#employee-text").html(translate["total_employee"])
    $("#employee-textleft").html(translate["total_employeeleft"])
    $("#save-text").html(translate["save"])
    $("#motel-sell-text").html(translate["motel_sell"])
    $("#transfer-motel-text").html(translate["transfer_motel"])
    $("#e-title").html(translate["employee_second"])
    $("#invite-text").html(translate["invite"])
    $("#e-name").html(translate["name"])
    $("#e-rank").html(translate["rank"])
    $("#e-salary").html(translate["salary"])
    $("#e-rankud").html(translate["rankup"])
    $("#e-action").html(translate["action"])
    $("#employees_invite").html(translate["employees_invite"])
    $(".companyfalanbarisoropsu").html(translate["company_second"])
    $("#company-balance-text").html(translate["company_balance"])
    $("#w-text").html(translate["withdraw"])
    $("#w-submit").html(translate["withdraw_second"])
    $("#d-text").html(translate["deposit"])
    $("#d-submit").html(translate["deposit_second"])
    $("#c-text").html(translate["company_history"])
    $("#c-title").html(translate["customer_header"])
    $("#c-name").html(translate["name"])
    $("#c-rank").html(translate["rented_time"])
    $("#c-salary").html(translate["room_number"])
    $("#c-rankud").html(translate["money_to_pay"])
    $("#c-phonenumber").html(translate["phone_number"])
    $("#c-action").html(translate["action"])
    $("#n-title").html(translate["nearby_players_header"])
    $("#n-name").html(translate["name"])
    $("#n-action").html(translate["action"])
    $(".nis-name-text").html(translate["name"])
    $(".nis-chooseroom").html(translate["choose_room"])
    $(".nis-select").html(translate["select"])
    $(".enterprice").html(translate["enter_price"])
    $(".enterday").html(translate["enter_day"])
    $("#accept-text").html(translate["accept"])
    $("#cancel-text").html(translate["cancel"])
    $("#motel-care-header2").html(translate["motel_care_header"])
    $("#motel-request-text2").html(translate["motel_req"])

    if (CurrentMenu == "dashboard") {
        $(".dashboard ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "block")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $("#openbossmenuactiverooms").html(data.ActiveTotalRooms + " ROOMS")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".motel-care-menu-request").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
    } else if (CurrentMenu == "employees") {
        $(".employees ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "block")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".motel-care-menu-request").css("display", "none")
    } else if (CurrentMenu == "company") {
        $(".company ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "block")

        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".motel-care-menu-request").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
        LoadHistory(data.motel.History);
    } else if (CurrentMenu == "customer") {
        $(".customer ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "block")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".motel-care-menu-request").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
        LoadCustomerMenu(LoadTwo)
    } else if (CurrentMenu == "nearby-players") {
        $(".nearby-players ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "block")
        $(".motel-care-menu").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".motel-care-menu-request").css("display", "none")
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
        // $.post('https://oph3z-motels/NerabyPlayers', JSON.stringify({}));
    } else if (CurrentMenu == "motelcare") {
        $(".motelcare ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "block")
        $(".motel-care-menu-request").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
    } else if (CurrentMenu == "motelcare2") {
        $(".motelcare2 ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".motel-care-menu-request").css("display", "flex")
        $(".employee-invite").css("display", "none");
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none"); 
        LoadRequest(requesttable)
    }
}

LoadRequest = function (data) {
    $(".request-list").html("");
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        if (element !== null) {
            let html = "";
            let backgroundImage = "";
            
            if (element.theme == "regal") {
                backgroundImage = regalurl;
            }
            if (element.theme == "modern") {
                backgroundImage = modernurl;
            } 
            if (element.theme == "seductive") {
                backgroundImage = seductiveurl;
            } 
            if (element.theme == "moody") {
                backgroundImage = moodyurl;
            }
            if (element.theme == "vibrant") {
                backgroundImage = vibranturl;
            }
            if (element.theme == "sharp") {
                backgroundImage = sharpurl;
            } 
            if (element.theme == "monochrome") {
                backgroundImage = monochromeurl;
            }
            if (element.theme == "aqua") {
                backgroundImage = aquaurl;
            }        

            html = `
        
            <div class="requests">
                <img src="${backgroundImage}" class="barisinbiip">
                <span class="r-header">${translate["request"]} -  ${translate["no2"]} ${element.motelno}  </span>
                <span class="requests-text">${translate["type"]} ${element.type} -- ${translate["pricetext"]} $${element.roomprice} -- ${translate["theme"]} ${element.theme} -- ${translate["extras"]}  `;
            
            if (element.extra !== undefined && element.extra.length > 0) {
                for (let i = 0; i < element.extra.length; i++) {
                    html += element.extra[i];
                    if (i !== element.extra.length - 1) {
                        html += ", ";
                    }
                }
            } else {
                html += `${translate["none"]}`;
            }
            
            html += `</span>
                <div class="r-accept" motelno="${element.motelno}" roomtheme="${element.theme}" roomtype="${element.type}" roomextra="${element.extra}" roomprice="${element.roomprice}" roomowner="${element.roomoowner}"> <span>${translate["accept"]}</span> </div>
                <div class="r-decline" motelno="${element.motelno}" roomprice="${element.roomprice}" roomowner="${element.roomoowner}"> <span>${translate["decline"]}</span> </div>
            </div>
            `;
            $(".request-list").append(html);
        }
    }
}

$(document).on("click", ".r-accept", function() {
    $.post('https://oph3z-motels/AcceptRequste', JSON.stringify({
        motelid: CurrentMotelID,
        roomno: $(this).attr("motelno"),
        roomtheme: $(this).attr("roomtheme"),
        roomextra: $(this).attr("roomextra"),
        roomtype: $(this).attr("roomtype"),
        price: $(this).attr("roomprice"),
        owner: $(this).attr("roomowner")
    }))
})

$(document).on("click", ".r-decline", function () {
    $.post('https://oph3z-motels/CancelRequest', JSON.stringify({
        motelid: CurrentMotelID,
        roomno: $(this).attr("motelno"),
        price: $(this).attr("roomprice"),
        owner: $(this).attr("roomowner")
    }))
})

$(document).on("click", "#dashboardsavesel", function() {
 
    $.post('https://oph3z-motels/SellMotel', JSON.stringify({
        motelid: CurrentMotelID,
    }))
    BossMenuActive = false
    $(".bossmenu").css("display", "none");
    $(".employee-invite").css("display", "none");
    $("#player-salary").css("z-index", "999999999")
    $(".nearby-players-employee").html("");
    $(".nearby-players-employee").css("display", "none");
    $.post('https://oph3z-motels/CloseUIBoosmenu', JSON.stringify({}))
})

$(document).on("click", "#dashboardsavetransfer", function() {
    if (TransferMotelID == null) {
        return;
    } else {
    $.post('https://oph3z-motels/MotelTransferRequest', JSON.stringify({
        motelid: CurrentMotelID,
        playerid: TransferMotelID,
        motelname : motelinidsiknkistebu
    }))
    BossMenuActive = false
    $(".bossmenu").css("display", "none");
    $(".employee-invite").css("display", "none");
    $("#player-salary").css("z-index", "999999999")

    $.post('https://oph3z-motels/CloseUIBoosmenu', JSON.stringify({}))
}
})

var RankLabel = "";

LoadEmployeesMenu = function(data) {
    $(".e-list-body").html("");
    for (let index = 0; index < data.employees.length; index++) {
        const element = data.employees[index];
        if (element.Rank == 2) {
            RankLabel = "Sale Manager";
        } else if (element.Rank == 1) {
            RankLabel = "Employee";
        }
        
        let html = "";
    
        if (element.Name == "") {} else {
            html = `
                <div class="e-employees-list">
                    <h2 id="e-e-l-name">${element.Name}</h2>
                    <h2 id="e-e-l-rank">${RankLabel + - +element.Rank}</h2>
            
                    <input type="number" id="player-salary" class="player-salaryinput" placeholder="${"$" +  PE3D(element.Salary)}">
                    <i class="fa-solid fa-check" id="accept-salary"></i>
                    <div class="rankdown-icon">
                        <img src="img/rankdown.svg" alt="" id="rankdown">
                    </div>
                    <div class="rankup-icon">
                        <img src="img/rankup.svg" alt="" id="rankup">
                    </div>
                    <div class="action-icon">
                        <img src="img/kick.svg" alt="">
                    </div>
                </div>
                `;
        }
        $(".e-list-body").append(html);
    }

    
    $(".e-employees-list:nth-child(odd)").css("background", "rgba(255, 255, 255, 0.04)")
    $(".e-employees-list:nth-child(even)").css("background", "rgba(255, 255, 255, 0.02)")

    $(".player-salaryinput").on("input", function() {
        newprice = $(this).val();
    });

    $("#accept-salary").click(function() {
        let EplayerName = $(this).parent().find("#e-e-l-name").text();
        $.post('https://oph3z-motels/ChangeSalary', JSON.stringify({
            salary: newprice,
            employeName: EplayerName,
            motelno: CurrentMotelID,
        }));
    });
}


LoadNearby = function(data) {
    $(".n-list-body").html("");
    for (let index = 0; index < data.players.length; index++) {
        const element = data.players[index];
        let html = "";
        if (element.Name == "") {} else {
            html = `
            <div class="n-nearby-list">
                <h2 id="n-n-l-name">${element.Name}</h2>
                <h2 id="n-n-l-distance">${element.Distance}</h2>
                <h2 id="n-n-l-action">Invite</h2>
            </div>
            `;
        }
        $(".n-list-body").append(html);
    }
}

LoadCustomerMenu = function(owner) {
    $(".c-list-body").html("");
    for (let index = 0; index < owner.rooms.length; index++) {
        const element = owner.rooms[index];

        let html = "";
        if (element.Owner.Name == "") {} else {
            html = `
            <div class="c-customers-list">
                <h2 id="c-c-l-name">${element.Owner.Name + " " + element.Owner.Lastname} </h2>
                <h2 id="c-c-l-date">${element.Owner.Date}</h2>
                <h2 id="c-c-l-room">${element.motelno + " " + "(" + element.type + ")"}</h2>
                <h2 id="c-c-l-money">${"$" +element.Owner.MyMoney}</h2>
                <h2 id="c-c-l-phone">${element.Owner.PhoneNumber}</h2>
                <div class="c-action-icon">
                    <img src="img/kick.svg" alt="">
                </div>
            </div>`
        }
        $(".c-list-body").append(html);
    }

    $(".c-customers-list:nth-child(odd)").css("background", "rgba(255, 255, 255, 0.04)")
    $(".c-customers-list:nth-child(even)").css("background", "rgba(255, 255, 255, 0.02)")
}

$(document).on("click", ".c-action-icon", function() {
    $.post('https://oph3z-motels/KickCustomer', JSON.stringify({
        motelno: CurrentMotelID,
        motelroomnumber: $(this).parent().find("#c-c-l-room").html().split(" ")[0],

    }))
})

$(document).on("click", ".action-icon", function() {
    $.post('https://oph3z-motels/KickEmployee', JSON.stringify({
        motelno: CurrentMotelID,
        employeName: $(this).parent().find("#e-e-l-name").html(),
    }))
})

$(document).on("click", ".rankup-icon", function() {
    $.post('https://oph3z-motels/RankUp', JSON.stringify({
        motelno: CurrentMotelID,
        employeName: $(this).parent().find("#e-e-l-name").html(),
    }))
})

$(document).on("click", ".rankdown-icon", function() {
    $.post('https://oph3z-motels/RankDown', JSON.stringify({
        motelno: CurrentMotelID,
        employeName: $(this).parent().find("#e-e-l-name").html(),

    }))
})

$(document).on("click", ".e-invitebtn", function() {
    $.post('https://oph3z-motels/NerabyPlayers', JSON.stringify({
        employees: true,
    }));
    $(".employee-invite").css("display", "flex")
    $("#player-salary").css("z-index", "1")
    EmployesInvite = true
    BossMenuActive = false
})

$(document).on("click", ".motel-care-fixit-button", function() {
    moteltype = $(this).parent().find(".motel-care-room-header").html().split(" ")[0]
    motelfixnumber = $(this).parent().find(".motel-core-fixit-no").html().split(" ")[0]
    if (moteltype == translate["vip"]) {
        $("#fixmenu-motel-price").html("$5.000")
    } else if (moteltype == translate["middle"]) {
        $("#fixmenu-motel-price").html("$3.000")
    } else if (moteltype == translate["squatter"]) {
        $("#fixmenu-motel-price").html("$2.000")
    }
    $(".fix-room-menu").css("display", "flex")
    $(".fixmenu-sri-text").html(translate["fix_motel_descrip"])
    $(".fixmenu-motelroom").html(translate["motel_room"])
    $(".fixmenu-motelprice").html(translate["fix_motel_room_price"])
    $("#fixmenu-motel-room").html(motelfixnumber)
    $(".sri-accept > span").html(translate["accept"])
    $(".sri-decline > span").html(translate["cancel"])
    FixmenuActive = true
    BossMenuActive = false
})

$(document).on("click", ".sri-accept", function() {
    $.post('https://oph3z-motels/RepairRoom', JSON.stringify({
        motelid: CurrentMotelID,
        motelroomnumber: $("#fixmenu-motel-room").html(),
        motelfixprice: $("#fixmenu-motel-price").html(),
    }))
    $(".fix-room-menu").css("display", "none")
    FixmenuActive = false
    BossMenuActive = true
})

$(document).on("click", ".sri-decline", function() {
    $(".fix-room-menu").css("display", "none")
    FixmenuActive = false
    BossMenuActive = true
})

var motelroomupgradepricevip = 0
var motelroomupgradepricemiddle = 0

$(document).on("click", ".motel-care-upgrade-button", function() {
    motelroomupgradepricevip = $(this).attr("vipupgradeprice")
    motelroomupgradepricemiddle = $(this).attr("middleupgradeprice")
    motelintypiabe = $(this).attr("moteltype")
    motelupgradenumber = $(this).parent().find(".motel-core-oda-no").html().split(" ")[0]
    abc = yarraminbasi[motelupgradenumber]
    JSStyle(abc)
    $(".chancestyle-motelrooms").css("display", "flex")
    $("#squattertextiste").html(translate["squatter_rooms_text"])
    $("#falanlarhehe2").html(translate["middle_rooms_text"])
    $("#falanlarhehe1").html(translate["vip_rooms_text"])
    $("#upgrademenu-no-text").html(translate["no"])
    $("#upgrademenu-motelname").html(translate["vip_motel_room"])
    $("#upgrademenu-title").html(translate["room_upgrade"])
    $("#upgrademenu-title2").html(translate["choose_style"])
    $("#upgrademenu-title3").html(translate["choose_wall"])
    $("#up-menu-cancel-txt").html(translate["cancel"])
    $("#upgrademenu-motelname").html(motelintypiabe.toUpperCase() + " " + translate["motel_roomU"])


    $("#upgrademenu-no-number").html(motelupgradenumber)
    if (motelintypiabe === translate["vip"]) {
        $("#squatterimgupgrade").attr("src", "./img/black-squatter.png")
        $(".badrooms-upgrade").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".badrooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".badrooms-upgrade").css("cursor", "not-allowed")
        $("#middleimgprade").attr("src", "./img/black-door.png")
        $(".middlerooms-upgrade").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".middlerooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".middlerooms-upgrade").css("cursor", "not-allowed")
        $("#vipimgupgrade").attr("src", "./img/gray-vip.png");
        $(".viprooms-upgrade").css("background", "linear-gradient(158.74deg, #FFB800 14.01%, #FF8A00 108.88%)")
        $(".viprooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".viprooms-upgrade").css("cursor", "not-allowed")
        BadUpClick(false);
        MiddleUpClick(false);
        VIPUpClick(false);
    } else if (motelintypiabe === translate["middle"]) {
        $("#squatterimgupgrade").attr("src", "./img/black-squatter.png")
        $(".badrooms-upgrade").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".badrooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".badrooms-upgrade").css("cursor", "not-allowed")
        $("#middleimgprade").attr("src", "./img/black-door.png")
        $(".middlerooms-upgrade").css("background", "linear-gradient(158.74deg, #FFB800 14.01%, #FF8A00 108.88%)")
        $(".middlerooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".middlerooms-upgrade").css("cursor", "not-allowed")
        BadUpClick(false);
        MiddleUpClick(false);
        VIPUpClick(true);
    } else if (motelintypiabe === translate["squatter"]) {
        $("#squatterimgupgrade").attr("src", "./img/black-squatter.png")
        $(".badrooms-upgrade").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".badrooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".badrooms-upgrade").css("cursor", "not-allowed")
        BadUpClick(false);
        MiddleUpClick(true);
        VIPUpClick(true);
    }
    UpgradeMenuActive = true
    $("#up-menu-save-txt").html("$0");
    motelupgradeprice = 0
    BossMenuActive = false
})



LoadSquatterRooms = function(data, motelname) {
    $(".roomsbar").css("display", "block")
    $(".roomsbar").html("");
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        let html = "";
        if (element.Rent == false && element.Active == true && element.type === translate["squatter"]) {
            html = `
            <div class="rooms">
                <img src="./img/roomsback.png">
                <span class="no-text">${translate["no"]}</span>
                <div class="odanocontainer">
                    <span class="oda-no">${element.motelno}</span>
                </div>
                <span class="room-header">${element.type + " " + translate["room"]}</span>
                <span class="room-descript">${translate["squatter_rooms_descrip"]}</span> 
                <div class="rent-button-vip" motelname="${motelname}" motelno="${element.motelno}" motelroomprice="${element.money}" moteltype="${element.type}">
                    <span>${translate["rent"]}</span>
                </div>
            </div>
            `
        } else if (element.Rent == true && element.Active == true && element.type === translate["squatter"]) {
            html = `
            <div class="rooms">
                <img src="./img/roomsbackdolu.png">
                <span class="no-text">${translate["no"]}</span>
                <div class="odanocontainer">
                    <span class="oda-no">${element.motelno}</span>
                </div>
                <span class="room-header">${element.type + " " + translate["room"]}</span>
                <span class="room-descript">${translate["squatter_rooms_descrip"]}</span>
                <div class="rent-button-vip-rented">
                    <span>${translate["rented"]}</span>
                </div>
            </div>
            `
        } else if (element.Active == false && element.Rent == false && element.type === translate["squatter"]) {
            html = `
            <div class="rooms">
                <img src="./img/moteldeactive.png">
                <span class="no-text">${translate["no"]}</span>
                <div class="odanocontainer">
                    <span class="oda-no">${element.motelno}</span>
                </div>
                <span class="room-header">${element.type + " " + translate["room"]}</span>
                <span class="room-descript">${translate["squatter_rooms_descrip"]}</span>
                <div class="rent-button-vip-rented">
                    <span>${translate["disabled"]}</span>
                </div>
            </div>
            `
        }
        $(".roomsbar").append(html);
    }
}

LoadMiddleRooms = function(data, motelname) {
    $(".roomsbar2").css("display", "block")
    $(".roomsbar2").html("");
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        let html = "";
        if (element.Rent == false && element.Active == true && element.type === translate["middle"]) {
            html = `
            <div class="rooms2">
                <img src="./img/roomsback.png">
                <span class="no-text2">${translate["no"]}</span>
                <div class="odanocontainer">
                    <span class="oda-no2">${element.motelno}</span>
                </div>
                <span class="room-header2">${element.type + " " + translate["room"]}</span>
                <span class="room-descript2">${translate["middle_rooms_descrip"]}</span>
                <div class="rent-button-vip" motelname="${motelname}" motelno="${element.motelno}" motelroomprice="${element.money}" moteltype="${element.type}">
                    <span>${translate["rent"]}</span>
                </div>
            </div>
            `
        } else if (element.Rent == true && element.Active == true && element.type === translate["middle"]) {
            html = `
            <div class="rooms2">
                <img src="./img/roomsbackdolu.png">
                <span class="no-text2">${translate["no"]}</span>
                <div class="odanocontainer">
                    <span class="oda-no2">${element.motelno}</span>
                </div>
                <span class="room-header2">${element.type + " " + translate["room"]}</span>
                <span class="room-descript2">${translate["middle_rooms_descrip"]}</span>
                <div class="rent-button-vip-rented">
                    <span>${translate["rented"]}</span>
                </div>
            </div>
            `
        } else if (element.Active == false && element.Rent == false && element.type === translate["middle"]) {
            html = `
            <div class="rooms2">
                <img src="./img/motel-care-fixit.png">
                <span class="no-text-d">${translate["no"]}</span>
                <span class="oda-no-d">${element.motelno}</span>
                <span class="room-header2">${element.type + " " + translate["room"]}</span>
                <span class="room-descript2">${translate["middle_rooms_descrip"]}</span>
                <div class="rent-button-vip-rented">
                    <span>${translate["disabled"]}</span>
                </div>
            </div>
            `
        }
        $(".roomsbar2").append(html);
    }
}

LoadMotelCare = function(data, yarrak) { 
    $(".motel-care-room-list").html("");
    for (let index = 0; index < data.motel.Rooms.length; index++) {
        const element = data.motel.Rooms[index];
        let html = "";
        let oph3z = "";
        var motellevel = 0;
        if (element.type === translate["squatter"]) {
            motellevel = 1;
            oph3z = translate["squatter_rooms_descrip"]
        } else if (element.type === translate["middle"]) {
            motellevel = 2;
            oph3z = translate["middle_rooms_descrip"]
        } else if (element.type === translate["vip"]) {
            motellevel = 3;
            oph3z = translate["vip_rooms_descrip"]
        }
        yarraminbasi[element.motelno] = yarrak[element.motelno-1]
        if (element.Active == true) {
            html = ` 
            <div class="motel-care-rooms">
            <img src="./img/motelcare-backrooms.png">
            <span class="motel-care-room-header">${element.type + " " + translate["motel_roomU"]} </span>
            <span class="motel-care-room-descript">${oph3z}</span>
            <span class="motel-core-no-text">${translate["no"]}</span>
            <span class="motel-core-oda-no">${element.motelno}</span>
            <span class="motel-core-level-text">${translate["lvl"]}</span>
            <span class="motel-core-oda-level">${motellevel}</span>
            <div class="motel-care-upgrade-button" moteltype="${element.type}" vipupgradeprice="${data.vipmotelupgradeprice}" middleupgradeprice="${data.middleupgradeprice}">
                <span>${translate["upgrade"]}</span>
            </div>
        </div>
            `
        } else if (element.Active == false) {
            html = `
            <div class="motel-care-rooms">
            <img src="./img/motel-care-fixit.png">
            <span class="motel-care-room-header">${element.type + " " + translate["motel_roomU"]} </span>
            <span class="motel-care-room-descript">${oph3z}</span>
            <span class="motel-core-fixit-no-text">${translate["no"]}</span>
            <span class="motel-core-fixit-no">${element.motelno}</span>
            <div class="motel-care-fixit-button">
                <span>${translate["fix_it"]}</span>
            </div>
        </div>
        
            `
        }
        $(".motel-care-room-list").append(html);
    }
}

LoadVIPRooms = function(data, motelname) {
    $(".roomsbar3").css("display", "block")
    $(".roomsbar3").html("");
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        let html = "";
        if (element.Rent == false && element.Active == true && element.type === translate["vip"]) {
            html = `
            <div class="rooms3">
                <img src="./img/roomsback.png">
                <span class="no-text3">${translate["no"]}</span>
                <div class="odanocontainer">
                    <span class="oda-no3">${element.motelno}</span>
                </div>
                <span class="room-header3">${element.type +  " " + translate["room"]}</span>
                <span class="room-descript3">${translate["vip_rooms_descrip"]}</span>
                <div class="rent-button-vip" motelname="${motelname}" motelno="${element.motelno}" motelroomprice="${element.money}" moteltype="${element.type}">
                    <span>${translate["rent"]}</span>
                </div>
            </div>
            `
        } else if (element.Rent == true && element.Active == true && element.type === translate["vip"]) {
            html = `
            <div class="rooms3">
                <img src="./img/roomsbackdolu.png">
                <span class="no-text3">${translate["no"]}</span>
                <div class="odanocontainer">
                    <span class="oda-no3">${element.motelno}</span>
                </div>
                <span class="room-header3">${element.type + " " + translate["room"]}</span>
                <span class="room-descript3">${translate["vip_rooms_descrip"]}</span>
                <div class="rent-button-vip-rented">
                    <span>${translate["rented"]}</span>
                </div>
            </div>
            `
        } else if (element.Active == false && element.Rent == false && element.type === translate["vip"]) {
            html = `
            <div class="rooms3">
                <img src="./img/motel-care-fixit.png">
                <span class="no-text-d">${translate["no"]}</span>
                <span class="oda-no-d">${element.motelno}</span>
                <span class="room-header3">${element.type + " " + translate["room"]}</span>
                <span class="room-descript3">${translate["vip_rooms_descrip"]}</span>
                <div class="rent-button-vip-rented">
                    <span>${translate["disabled"]}</span>
                </div>
            </div>
            `
        }
        $(".roomsbar3").append(html);
    }
}

$(document).on("click", "#left-menu-item", function() {

    CurrentMenu = $(this).attr("class")
    if (CurrentMenu == "dashboard") {
        $(".dashboard ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "block")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".employee-invite").css("display", "none");
        $("#player-salary").css("z-index", "999999999")
        $(".motel-care-menu-request").css("display", "none")
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
    } else if (CurrentMenu == "employees") {
        $(".employees ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "block")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".motel-care-menu-request").css("display", "none")
        $(".employee-invite").css("display", "none");
        $("#player-salary").css("z-index", "999999999")
        // $.post('https://oph3z-motels/NerabyPlayersE', JSON.stringify({}));
    } else if (CurrentMenu == "company") {
        $(".company ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "block")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".motel-care-menu-request").css("display", "none")
        $("#player-salary").css("z-index", "999999999")
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
        LoadHistory(hisyoryfalan)
    } else if (CurrentMenu == "customer") {
        $(".customer ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "block")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".motel-care-menu-request").css("display", "none")
        $("#player-salary").css("z-index", "999999999")
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
        LoadCustomerMenu(LoadTwo)
    } else if (CurrentMenu == "nearby-players") {
        $(".nearby-players ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "block")
        $(".motel-care-menu").css("display", "none")
        $(".employee-invite").css("display", "none");
        $(".motel-care-menu-request").css("display", "none")
        $("#player-salary").css("z-index", "999999999")
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
        $.post('https://oph3z-motels/NerabyPlayers', JSON.stringify({}));
    } else if (CurrentMenu == "motelcare") {
        $(".motelcare ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".motelcare2 ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "block")
        $(".employee-invite").css("display", "none");
        $(".motel-care-menu-request").css("display", "none")
        $("#player-salary").css("z-index", "999999999")
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none");
    } else if (CurrentMenu == "motelcare2") {
        $(".motelcare2 ").css("background", "linear-gradient(90deg, #0190FF 0.38%, rgba(1, 144, 255, 0) 100%)")
        $(".motelcare ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboard ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".employees ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".company ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".customer ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".nearby-players ").css("background", "linear-gradient(90deg, rgba(255, 255, 255, 0.18) 0.38%, rgba(255, 255, 255, 0) 100%)")
        $(".dashboardmenu").css("display", "none")
        $(".employeesmenu").css("display", "none")
        $(".companymenu").css("display", "none")
        $(".customersmenu").css("display", "none")
        $(".nearby-players-cat").css("display", "none")
        $(".motel-care-menu").css("display", "none")
        $(".motel-care-menu-request").css("display", "flex")
        $(".employee-invite").css("display", "none");
        $(".nearby-players-employee").html("");
        $(".nearby-players-employee").css("display", "none"); 
        LoadRequest(requesttable)
    }
})

$(document).on("click", ".nis-rooms-list", function() {
    var test = $(this).attr("checkquality")
    var test2 = $(this).attr("chechRent")
    if (test == "false" || test2 == "true") {
        $(".nis-rooms-list").removeClass("nis-active")
        $(".nis-rooms-list > span").css("color", "rgba(255, 255, 255, 0.6)")
        $(this).addClass("nis-active")
        $(this).children("span").css("color", "black")
        GiveMotelRoom = $(this).attr("currentroom")
        GiveMotelType = $(this).attr("currentroomtype")
    }
})

$(document).on("click", ".npc-accept", function() {
    $.post('https://oph3z-motels/NearbyRequest', JSON.stringify({
        room: GiveMotelRoom,
        playersource: GiveMotelSource,
        price: nearbplayersyprice,
        time: NearbyCurrentTime,
        motelid: CurrentMotelID,
        motelname: GiveMotelName,
        roomtype: GiveMotelType
    }))
    $("#nearby-players-settings-price").val("")
    $("#nearby-players-settings-time").val("")
    $(".np-invite-settings").css("display", "none")
    $(".nearby-players-cat").css("display", "block")

    NearbyInvite = false
    BossMenuActive = true
    $(".np-invite-settings").css("display", "none")
    $(".n-list-title").css("display", "block")
    $(".n-list-body").css("display", "block")
    $(".nearby-players-cat").css("display", "block")
})

$(document).on("click", ".npc-cancel", function() {
    $("#nearby-players-settings-price").val("")
    $("#nearby-players-settings-time").val("")
    $(".np-invite-settings").css("display", "none")
    $(".nearby-players-cat").css("display", "block")

    NearbyInvite = false
    BossMenuActive = true
    $(".np-invite-settings").css("display", "none")
    $(".n-list-title").css("display", "block")
    $(".n-list-body").css("display", "block")
    $(".nearby-players-cat").css("display", "block")
})

function BadUpClick(isClickable) {
    if (isClickable) {
        $(document).on("click", ".badrooms-upgrade", function() {
        })
    }
}

function BadUpClick2(isClickable) {
    if (isClickable) {
        $(document).on("click", ".badrooms-upgraderequest", function() {
        })
    }
}

function MiddleUpClick(isClickable) {
    if (isClickable && !vipsectin) {
        $(document).off("click", ".middlerooms-upgrade"); 

        $(document).on("click", ".middlerooms-upgrade", function() {
            if (middleClickable) {
                $(".middlerooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)");
                $(".middlerooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)");
                $(".middlerooms-upgrade").css("cursor", "pointer");
                $("#middleimgprade").attr("src", "./img/middle.svg");
                middleClickable = false;
                middlesectin = false;
                CheckAnan = false

                sonmotelprice = motelupgradeprice;
                eklenecekpara = motelroomupgradepricemiddle;
                otuziki = parseInt(sonmotelprice) - parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txt").html("$" + PE3D(otuziki));   


            } else if (!middleClickable && motelintypiabe == translate["squatter"] && CheckAnan !== true) {
                middlesectin = true;
                $(".middlerooms-upgrade").css("background", "linear-gradient(124.39deg, #0085FF 20.58%, #00B2FF 90.19%)");
                $(".middlerooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)");
                $("#middleimgprade").attr("src", "./img/black-door.png");
                middleClickable = true;
                sonmotelprice = motelupgradeprice;
                eklenecekpara = motelroomupgradepricemiddle;
                otuziki = parseInt(sonmotelprice) + parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txt").html("$" + PE3D(otuziki));
                CheckAnan = true
            }
        });
    }
}

function MiddleUpClick2(isClickable) {
    if (isClickable && !vipsectin) {
        $(document).off("click", ".middlerooms-upgraderequest"); 
        
        $(document).on("click", ".middlerooms-upgraderequest", function() {
            if (middleClickable) {
                $(".middlerooms-upgraderequest").css("background", "rgba(255, 255, 255, 0.09)");
                $(".middlerooms-upgraderequest > span").css("color", "rgba(255, 255, 255, 0.3)");
                $(".middlerooms-upgraderequest").css("cursor", "pointer");
                $("#middleimgpraderequest").attr("src", "./img/middle.svg");
                middleClickable = false;
                middlesectin = false;
                CheckAnan = false
                sonmotelprice = motelupgradeprice;
                eklenecekpara = motelroomupgradepricemiddle;
                otuziki = parseInt(sonmotelprice) - parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txtrequest").html("$" + PE3D(otuziki));

            } else if (!middleClickable && motelintypiabe == translate["squatter"] && CheckAnan !== true) {
                middlesectin = true;
                $(".middlerooms-upgraderequest").css("background", "linear-gradient(124.39deg, #0085FF 20.58%, #00B2FF 90.19%)");
                $(".middlerooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)");
                $("#middleimgpraderequest").attr("src", "./img/black-door.png");
                middleClickable = true;
                sonmotelprice = motelupgradeprice;
                // eklenecekpara = motelroomupgradepricevip;
                eklenecekpara = motelroomupgradepricemiddle
                otuziki = parseInt(sonmotelprice) + parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txtrequest").html("$" + PE3D(otuziki));
                CheckAnan = true
            }
        });
    }
}

function VIPUpClick(isClickable) {
    if (isClickable && !middlesectin) {
        $(document).off("click", ".viprooms-upgrade");
        $(document).on("click", ".viprooms-upgrade", function() {
            if (vipClickable) {
                $(".viprooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)");
                $(".viprooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)");
                $(".viprooms-upgrade").css("cursor", "pointer");
                $("#vipimgupgrade").attr("src", "./img/gray-vip.png");
                vipClickable = false;
                vipsectin = false;
                CheckAnan = false
                sonmotelprice = motelupgradeprice;
                eklenecekpara = motelroomupgradepricevip;
                otuziki = parseInt(sonmotelprice) - parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txt").html("$" + PE3D(otuziki));
            } else if (!vipClickable && motelintypiabe !== translate["vip"] && CheckAnan !== true) {
                vipsectin = true;
                $(".viprooms-upgrade").css("background", "linear-gradient(124.39deg, #0085FF 20.58%, #00B2FF 90.19%)");
                $(".viprooms-upgrade > span").css("color", "rgba(0, 0, 0, 0.73)");
                $("#vipimgupgrade").attr("src", "./img/vip.svg");
                vipClickable = true;
                sonmotelprice = motelupgradeprice;
                eklenecekpara = motelroomupgradepricevip;
                otuziki = parseInt(sonmotelprice) + parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txt").html("$" + PE3D(otuziki));
                CheckAnan = true
            }
        });
    }
}

function VIPUpClick2(isClickable) {
    if (isClickable && !middlesectin) {
        $(document).off("click", ".viprooms-upgraderequest");
        $(document).on("click", ".viprooms-upgraderequest", function() {
            if (vipClickable) {
                $(".viprooms-upgraderequest").css("background", "rgba(255, 255, 255, 0.09)");
                $(".viprooms-upgraderequest > span").css("color", "rgba(255, 255, 255, 0.3)");
                $(".viprooms-upgraderequest").css("cursor", "pointer");
                $("#vipimgupgraderequest").attr("src", "./img/gray-vip.png");
                vipClickable = false;
                vipsectin = false;
                CheckAnan = false
                sonmotelprice = motelupgradeprice;
                eklenecekpara = motelroomupgradepricevip;
                otuziki = parseInt(sonmotelprice) - parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txtrequest").html("$" + PE3D(otuziki));
            } else if (!vipClickable && motelintypiabe !== translate["vip"] && CheckAnan !== true) {
                vipsectin = true;
                $(".viprooms-upgraderequest").css("background", "linear-gradient(124.39deg, #0085FF 20.58%, #00B2FF 90.19%)");
                $(".viprooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)");
                $("#vipimgupgraderequest").attr("src", "./img/vip.svg");
                vipClickable = true;
                sonmotelprice = motelupgradeprice;
                eklenecekpara = motelroomupgradepricevip;
                otuziki = parseInt(sonmotelprice) + parseInt(eklenecekpara);
                motelupgradeprice = otuziki;
                $("#up-menu-save-txtrequest").html("$" + PE3D(otuziki));
                CheckAnan = true
            }
        });
    }
}

$(document).on("click", "#category-item", function() {
    CurrentMenu = $(this).attr("class")

    if (CurrentMenu !== "pwodalar") {
        $(".roomsbar").css("display", "none")
        $(".pwodalari").removeClass("badroomclick")
        $(".pwodalar").find(".anan").removeClass("badroomclick2")
        $("#squatterimg").attr("src", "./img/pwev.svg")
    } else if (CurrentMenu == "pwodalar") {
        $(".pwodalari").addClass("badroomclick")
        $(".pwodalar").find(".anan").addClass("badroomclick2")
        $("#squatterimg").attr("src", "./img/black-squatter.png")
        LoadSquatterRooms(LoadSquatter, MotelNameVar)
        Test = "pwodalar"
    }

    if (CurrentMenu !== "middlerooms-img-text") {
        $(".roomsbar2").css("display", "none")
        $(".middlerooms").removeClass("middleroomclick")
        $(".middlerooms-img-text").find(".anan2").removeClass("middleroomclick2")
        $("#middleimg").attr("src", "./img/middle.svg")
    } else if (CurrentMenu == "middlerooms-img-text") {
        $(".middlerooms").addClass("middleroomclick")
        $(".middlerooms-img-text").find(".anan2").addClass("middleroomclick2")
        $("#middleimg").attr("src", "./img/black-door.png")
        LoadMiddleRooms(LoadMiddle, MotelNameVar)
        Test = "middle"
    }

    if (CurrentMenu !== "viprooms-img-text") {
        $(".roomsbar3").css("display", "none")
        $(".viprooms").removeClass("viproomclick")
        $(".viprooms-img-text").find(".anan3").removeClass("viproomclick2")
        $("#vipimg").attr("src", "./img/gray-vip.png")
    } else if (CurrentMenu == "viprooms-img-text") {
        $(".viprooms").addClass("viproomclick")
        $(".viprooms-img-text").find(".anan3").addClass("viproomclick2")
        $("#vipimg").attr("src", "./img/vip.svg")
        LoadVIPRooms(LoadVIP, MotelNameVar)
        Test = "vip"
    }

    if (CurrentMenu !== "sigtir") {
        CurrentScreen = $(this).attr("name")
        $("." + CurrentScreen).css("display", "block")
    }
})

$(document).on("click", ".rent-button-vip", function() {
    MotelRoomPrice = $(this).attr("motelroomprice")
    $(".send-room-soru").css("display", "flex")
    $(".motelname").html(translate["motel_name"])
    $(".motelroom").html(translate["motel_room_number"])
    $(".moteltime").html(translate["motel_room_time"])
    $(".motelprice").html(translate["motel_room_price"])
    $(".sri-accept-soru > span").html(translate["accept"])
    $(".sri-decline-soru > span").html(translate["cancel"])
    $("#motel-name2").html($(this).attr("motelname"))
    $("#motel-room2").html($(this).attr("motelno") + " " + `( ${$(this).attr("moteltype")} )`)
    $("#motel-price-soru").html("$" + PE3D($(this).attr("motelroomprice")))

    CurrentMotel = $(this).attr("motelname")
    CurrentNO = $(this).attr("motelno")
})

$(document).on("click", ".sri-accept-soru", function() {
    $(".send-room-soru").css("display", "none")
    $(".motelname").html("")
    $(".motelroom").html("")
    $(".moteltime").html("")
    $(".motelprice").html("")
    $(".sri-accept-soru > span").html("")
    $(".sri-decline-soru > span").html("")
    $("#motel-name2").html("")
    $("#motel-room2").html("")
    $("#motel-time-input").val("")
    $.post('https://oph3z-motels/AcceptMotelRoom', JSON.stringify({
        motel: CurrentMotel,
        motelid: CurrentMotelID,
        motelno: CurrentNO,
        time: CurrentTime,
        price: CurrentPrice
    }))
})


$(document).on("click", "#dashboardsave", function() {
    $.post('https://oph3z-motels/SaveDashboard', JSON.stringify({
        motelid: CurrentMotelID,
        MotelName: ChanceMotelName1
    }))
    $("#moteisim").html(ChanceMotelName1)
    $("#chancemotelname").val("")
})



$(document).on("click", ".sri-decline-soru", function() {
    $(".send-room-soru").css("display", "none")
    $("#motel-name2").html("")
    $("#motel-room2").html("")
    $("#motel-time-input").val("")
})

function PE3D(s) {
    s = parseInt(s)
    return s.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
}

LoadHistory = function(data) {
    let html = "";
    $(".history").html("")
    data.reverse()
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        if (element.type == "deposit") {
            html = `
            <div class="h-list">
                <img src="./img/money-green.png">
                <span>${translate["deposit_text_description"]}</span>
                <p>+ $${element.money}</p>
            </div>
            `
        } else if (element.type == "withdraw") {
            html = `
            <div class="h-list">
                <img src="./img/money-red.png">
                <span>${translate["withdraw_text_description"]}</span>
                <p style="color: red;">- $${PE3D(element.money)}</p>
            </div>
            `
        }
        $(".history").append(html)
    }
}

LoadNearbyPlayers = function(data) {
    $(".n-list-body").html("");
    let html = "";
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        html = `
        <div class="n-np-list">
            <h2 id="n-n-l-name">${element.Name + " " + element.Lastname}</h2>
            <div class="invite-button-np" id="${element.id}" name="${element.Name}" lastname="${element.Lastname}"> <span>${translate["invite"]}</span> </div>
        </div>
        `
        $(".n-list-body").append(html)
    }
}

LoadEmployeesNearby = function(data) {
    $(".employee-invite").css("display", "flex");
    $("#player-salary").css("z-index", "1")
    $(".nearby-players-employee").css("display", "block");
    $(".nearby-players-employee").html("");
    let html = "";
    for (let index = 0; index < data.length; index++) {
        const element = data[index];

        html = `
        <div class="npe-list">
            <span>${element.Name + " " + element.Lastname} - ${element.id}</span>
            <div class="invite-button-npe" playerid="${element.id}" name="${element.Name}" lastname="${element.Lastname}"> <span>${translate["invite"]}</span> </div>
        </div>
        `
        $(".nearby-players-employee").append(html)
    }

    $(".npe-list:nth-child(odd)").css("background", "rgba(255, 255, 255, 0.04)")
    $(".npe-list:nth-child(even)").css("background", "rgba(255, 255, 255, 0.02)")
}

LoadAllRooms = function(data) {
    $(".nis-rooms").html("");
    let html = "";
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        if (element.Active == false) {
            html = `
            <div style="cursor:not-allowed; background: rgba(51, 50, 50, 0.733)" class="nis-rooms-list" chechRent="${element.Rent}" currentroom="${element.motelno}" currentroomtype="${element.type}">
                <span class="nrl-text">${translate["no"] + " " + element.motelno + " " + " (" + element.type + ")"}</span>
            </div> 
            
            `
        } else if (element.Rent == false) {
            html = `
            <div class="nis-rooms-list" checkquality="${element.Rent}" currentroom="${element.motelno}" currentroomtype="${element.type}">
                <span class="nrl-text">${translate["no"] + " " + element.motelno + " " + " (" + element.type + ")"}</span>
            </div>
            `
        } else if (element.Rent == true) {
            html = `
            <div style="cursor:not-allowed; background: linear-gradient(0deg, rgba(200, 70, 70, 0.46), rgba(200, 70, 70, 0.46)), rgba(255, 255, 255, 0.13);" class="nis-rooms-list" checkquality="${element.Rent}" currentroom="${element.motelno}" currentroomtype="${element.type}">
                <span class="nrl-text">${translate["no"] + " " + element.motelno + " " + " (" + element.type + ")"}</span>
            </div> 
            `
        }
        $(".nis-rooms").append(html);
    }
}

var aktifknkdokunmaamk = false
var aktifknkdokunmaamk2 = false

JSStyle = function(data) {
    $(".upgrademenu-styleedit").html("");
    $(".upgrademenu-walledit").html("");    
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        const elementType = element.type;
        let html = "";
        let html2 = "";

        const elementDurum = element.durum;
        
        if (elementDurum === true) {
            aktifknkdokunmaamk = true
            aktifknkdokunmaamk2 = true
            yazacak = `${translate["active"]}`
        } else {
            aktifknkdokunmaamk = false
            aktifknkdokunmaamk2 = false
            yazacak = `${translate["select"]}`
        } 

        if (elementType === "style") {
            html = `
            <div class="upgrademenu-stylebar">
                <img src="${element.png}" id="upstyle1" alt="">
                <div class="selectbtn" motelstylename="${element.name}" styleprice="${element.price}" durum="${aktifknkdokunmaamk2}">
                    <h5 id="yourmotherstexttome">${yazacak}</h5>
                </div>
            </div>
            `;

            if (elementDurum === true) {
                aktifknkdokunmaamk2 = true
                html = $(html).find(".selectbtn").addClass("anan-activeknk").end().prop("outerHTML");
                html = $(html).find("#yourmotherstexttome").addClass("selectbtn-active").end().prop("outerHTML");
            } else {
                aktifknkdokunmaamk2 = false
                html = $(html).find(".selectbtn").removeClass("anan-activeknk").end().prop("outerHTML");
                html = $(html).find("#yourmotherstexttome").removeClass("selectbtn-active").end().prop("outerHTML");
            }

        } else if (elementType === "extra") {
            html2 = `
            <div class="upgrademenu-wallbar">
                <img src="${element.png}" id="upwalls1" alt="">
                <div class="selectbtnwall" motelstylename="${element.name}" styleprice="${element.price}" durum="${aktifknkdokunmaamk}">
                   <h5 id="selectbtnwalltext">${yazacak}</h5>
                </div>
            </div>
            `;

            if (elementDurum === true) {
                aktifknkdokunmaamk = true
                html2 = $(html2).find(".selectbtnwall").addClass("bacin-activeknk").end().prop("outerHTML");
                html2 = $(html2).find("#selectbtnwalltext").addClass("selectbtnwall-active").end().prop("outerHTML");
            } else {
                aktifknkdokunmaamk = false
                html2 = $(html2).find(".selectbtnwall").removeClass("bacin-activeknk").end().prop("outerHTML");
                html2 = $(html2).find("#selectbtnwalltext").removeClass("selectbtnwall-active").end().prop("outerHTML");
            }
        }

        $(".upgrademenu-styleedit").append(html);
        $(".upgrademenu-walledit").append(html2);
    }
};


var aktifknkdokunmaamkrequest = false
var aktifknkdokunmaamk2request = false

JSStyle2 = function(data) {
    $(".upgrademenu-styleeditrequest").html("");
    $(".upgrademenu-walleditrequest").html("");    
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        const elementType = element.type;
        let html = "";
        let html2 = "";
        const elementDurum = element.durum;

        if (elementDurum === true) {
            aktifknkdokunmaamkrequest = true
            aktifknkdokunmaamk2request = true
            yazacak = "Aktif"
        } else {
            aktifknkdokunmaamkrequest = false
            aktifknkdokunmaamk2request = false
            yazacak = "Select"
        } 

        if (elementType === "style") {
            html = `
            <div class="upgrademenu-stylebarrequest">
                <img src="${element.png}" id="upstyle1request" alt="">
                <div class="selectbtnrequest" motelstylename="${element.name}" styleprice="${element.price}" durum="${aktifknkdokunmaamk2request}">
                    <h5 id="yourmotherstexttome">${yazacak}</h5>
                </div>
            </div>
            `;

            if (elementDurum === true) {
                aktifknkdokunmaamk2request = true
                html = $(html).find(".selectbtnrequest").addClass("anan-activeknkrequest").end().prop("outerHTML");
                html = $(html).find("#yourmotherstexttome").addClass("selectbtn-active").end().prop("outerHTML");
            } else {
                aktifknkdokunmaamk2request = false
                html = $(html).find(".selectbtnrequest").removeClass("anan-activeknkrequest").end().prop("outerHTML");
                html = $(html).find("#yourmotherstexttome").removeClass("selectbtn-active").end().prop("outerHTML");
            }

        } else if (elementType === "extra") {
            html2 = `
            <div class="upgrademenu-wallbarrequest"> 
                <img src="${element.png}" id="upwalls1request" alt="">
                <div class="selectbtnwallrequest" motelstylename="${element.name}" styleprice="${element.price}" durum="${aktifknkdokunmaamkrequest}">
                   <h5 id="selectbtnwalltextreq">${yazacak}</h5>
                </div>
            </div>
            `;

            if (elementDurum === true) {
                aktifknkdokunmaamkrequest = true
                html2 = $(html2).find(".selectbtnwallrequest").addClass("bacin-activeknkrequest").end().prop("outerHTML");
                html2 = $(html2).find("#selectbtnwalltextreq").addClass("selectbtnwall-active").end().prop("outerHTML");
            } else {
                aktifknkdokunmaamkrequest = false
                html2 = $(html2).find(".selectbtnwallrequest").removeClass("bacin-activeknkrequest").end().prop("outerHTML");
                html2 = $(html2).find("#selectbtnwalltextreq").removeClass("selectbtnwall-active").end().prop("outerHTML");
            }
        }

        $(".upgrademenu-styleeditrequest").append(html);
        $(".upgrademenu-walleditrequest").append(html2);
    }
};

var selectbtntiklandi = false;
var motelstylenameistesananekahpe = null

$(document).on("click", ".selectbtn", function() {
    var element = $(this).hasClass("anan-activeknk");
    var denemefalan = $(this).attr("durum")
    if (element == false && denemefalan == "false" && selectbtntiklandi == false) {
        $(this).addClass("anan-activeknk")
        $(this).find("#yourmotherstexttome").addClass("selectbtn-active")
        selectbtntiklandi = true;
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) + parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txt").html("$" + PE3D(otuzbir));
        motelstylenameistesananekahpe = $(this).attr("motelstylename")
    } else if (element && denemefalan == "true") {

    } else if (element && denemefalan == "false" && selectbtntiklandi == true) {
        $(this).removeClass("anan-activeknk")
        $(this).find("#yourmotherstexttome").removeClass("selectbtn-active")
        selectbtntiklandi = false;
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) - parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txt").html("$" + PE3D(otuzbir));
        motelstylenameistesananekahpe = null
    }
})


var selectbtnrequesttiklandi = false;
var motelstylenameistesananekahpe2 = null

$(document).on("click", ".selectbtnrequest", function() {
    var element = $(this).hasClass("anan-activeknkrequest");
    var denemefalanrequest = $(this).attr("durum")
    if (element == false && denemefalanrequest == "false" && selectbtnrequesttiklandi == false) {
        $(this).addClass("anan-activeknkrequest")
        $(this).find("#yourmotherstexttome").addClass("selectbtn-active")

        selectbtnrequesttiklandi = true;
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) + parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txtrequest").html("$" + PE3D(otuzbir));
        motelstylenameistesananekahpe2 = $(this).attr("motelstylename")
    } else if (element && denemefalanrequest == "true") {

    } else if (element && denemefalanrequest == "false" && selectbtnrequesttiklandi == true) {
        $(this).removeClass("anan-activeknkrequest")
        $(this).find("#yourmotherstexttome").removeClass("selectbtn-active")
        selectbtnrequesttiklandi = false;
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) - parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txtrequest").html("$" + PE3D(otuzbir));
        motelstylenameistesananekahpe2 = null
    }
})

var selectbtnwalltiklandi = false;
var selectedStyles = []

$(document).on("click", ".selectbtnwall", function() {
    var elementDurum = $(this).hasClass("bacin-activeknk");
    var deneme = $(this).attr("durum")
    if (elementDurum == false && deneme == "false") {
        $(this).addClass("bacin-activeknk");
        $(this).find("#selectbtnwalltext").addClass("selectbtnwall-active")
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) + parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txt").html("$" + PE3D(otuzbir));
    } else if (elementDurum && deneme == "true") {
        $(this).removeClass("bacin-activeknk");
        $(this).find("#selectbtnwalltext").removeClass("selectbtnwall-active")
        otuzbir = 0 
        motelupgradeprice = otuzbir
        $("#up-menu-save-txt").html("$" + PE3D(otuzbir));
        selectedStyles = []
    } else if (elementDurum && deneme == "false") {
        $(this).removeClass("bacin-activeknk");
        $(this).find("#selectbtnwalltext").removeClass("selectbtnwall-active")
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) - parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txt").html("$" + PE3D(otuzbir));
    }
    $(".selectbtnwall.bacin-activeknk").each(function() {
        var style = $(this).attr("motelstylename");
        if (!selectedStyles.includes(style)) {
          selectedStyles.push(style);
          motelstyleoynadi = true 
        }
    });
});

var selectbtnwallrequesttiklandi = false;
var selectedStyles2 = []

$(document).on("click", ".selectbtnwallrequest", function() {
    var elementDurum = $(this).hasClass("bacin-activeknkrequest");
    var deneme = $(this).attr("durum")
    if (elementDurum == false && deneme == "false") {
        $(this).addClass("bacin-activeknkrequest");
        $(this).find("#selectbtnwalltext").addClass("selectbtnwall-active")
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) + parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txtrequest").html("$" + PE3D(otuzbir));
    } else if (elementDurum && deneme == "true") {
        $(this).removeClass("bacin-activeknkrequest");
        $(this).find("#selectbtnwalltext").removeClass("selectbtnwall-active")
        otuzbir = 0
        motelupgradeprice = otuzbir
        $("#up-menu-save-txtrequest").html("$" + PE3D(otuzbir));
        selectedStyles2 = []
    } else if (elementDurum && deneme == "false") {
        $(this).removeClass("bacin-activeknkrequest");
        $(this).find("#selectbtnwalltext").removeClass("selectbtnwall-active")
        sonmotelprice = motelupgradeprice;
        stylepriceeklendi = $(this).attr("styleprice")
        otuzbir = parseInt(sonmotelprice) - parseInt(stylepriceeklendi);
        motelupgradeprice = otuzbir;
        $("#up-menu-save-txtrequest").html("$" + PE3D(otuzbir));
    }
    $(".selectbtnwallrequest.bacin-activeknkrequest").each(function() {
        var style = $(this).attr("motelstylename");
        if (!selectedStyles2.includes(style)) {
            selectedStyles2.push(style);
            motelstyleoynadi = true
        }
    });
});


$(document).on("click", ".up-menu-save-btnrequest", function() {
    $.post('https://oph3z-motels/UpgradeRoomRequest', JSON.stringify({
        motelid: requestdata.MotelNo,
        isupgraded: middleClickable,
        isupgradedvip: vipClickable,
        motelroom : requestdata.OdanoR,
        motelstylename : motelstylenameistesananekahpe2,
        motelstylenameextra: selectedStyles2,
        motelstyleoynadi : motelstyleoynadi,
        motelprice : $(this).parent().find("#up-menu-save-txtrequest").html(),
    }))
    motelstyleoynadi = false
    motelupgradeprice = 0
    otuzbir = 0
    selectedStyles2 = []
    selectedStyles2 = ""
    UpgradeMenuActive = false
    BossMenuActive = true
    selectbtnrequesttiklandi = false
    $(".chancestyle-motelrooms").css("display", "none")
    $("#squatterimgupgraderequest").attr("src", "./img/pwev.svg")
    $(".badrooms-upgraderequest").css("background", "rgba(255, 255, 255, 0.09)")
    $(".badrooms-upgraderequest > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".badrooms-upgraderequest").css("cursor", "pointer")
    $("#middleimgpraderequest").attr("src", "./img/middle.svg")
    $(".middlerooms-upgraderequest").css("background", "rgba(255, 255, 255, 0.09)")
    $(".middlerooms-upgraderequest > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".middlerooms-upgraderequest").css("cursor", "pointer")
    $("#vipimgupgraderequest").attr("src", "./img/gray-vip.png");
    $(".viprooms-upgraderequest").css("background", "rgba(255, 255, 255, 0.09)")
    $(".viprooms-upgraderequest > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".viprooms-upgraderequest").css("cursor", "pointer")
    vipClickable = false
    middleClickable = false
    motelintypiabe = null
    motelintypiabeClickable = false
    CheckAnan = false
    selectbtnwalltiklandi = false

    $("#up-menu-save-txtrequest").html("$0");
    ChanceStyleRequest = false
    $(".chancestyle-motelroomsrequest").css("display", "none")
    MotelManagementFlex = false
    $(".motel-management").css("display", "none")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}))
})

var motelstyleoynadi = false

$(document).on("click", ".up-menu-save-btn", function() {
    $.post('https://oph3z-motels/UpgradeRoom', JSON.stringify({
        motelid: CurrentMotelID,
        isupgraded: middleClickable,
        isupgradedvip: vipClickable,
        motelroom : motelupgradenumber,
        motelstylename : motelstylenameistesananekahpe,
        motelstylenameextra: selectedStyles,
        motelstyleoynadi : motelstyleoynadi,
        motelprice : $(this).parent().find("#up-menu-save-txt").html(),
    }))
    motelstyleoynadi = false
    motelupgradeprice = 0
    otuzbir = 0
    selectedStyles = ""
    UpgradeMenuActive = false
    selectedStyles = []
    BossMenuActive = true
    $(".chancestyle-motelrooms").css("display", "none")
    $("#squatterimgupgrade").attr("src", "./img/pwev.svg")
    $(".badrooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
    $(".badrooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".badrooms-upgrade").css("cursor", "pointer")
    $("#middleimgprade").attr("src", "./img/middle.svg")
    $(".middlerooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
    $(".middlerooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".middlerooms-upgrade").css("cursor", "pointer")
    $("#vipimgupgrade").attr("src", "./img/gray-vip.png");
    $(".viprooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
    $(".viprooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".viprooms-upgrade").css("cursor", "pointer")
    vipClickable = false
    middleClickable = false
    motelintypiabe = null
    motelintypiabeClickable = false
    CheckAnan = false
    selectbtnwalltiklandi = false
    selectbtntiklandi = false
    $("#up-menu-save-txt").html("$0");
})

$(document).on("click", ".invite-button-npe", function() {
    $.post('https://oph3z-motels/InviteEmployee', JSON.stringify({
        playersource: $(this).attr("playerid"),
        motelid: CurrentMotelID
    }))
    $(".employee-invite").css("display", "none");
    $("#player-salary").css("z-index", "999999999")
    $(".nearby-players-employee").html("");
    $(".nearby-players-employee").css("display", "none");
})

$(document).on("click", ".accept-offer", function() {
    $.post('https://oph3z-motels/JobOfferAccepted', JSON.stringify({
        playerid: $(this).attr("id"),
        motelid: $(this).attr("motelid"),
        sender: $(this).attr("sender")
    }))
    $(".send-request").css("display", "none");
    $(".send-request").html("");
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}))
})

$(document).on("click", ".decline-offer", function() {
    $(".send-request").css("display", "none");
    $(".send-request").html("");
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}))
})

$(document).on("click", ".invite-button-np", function() {
    $(".np-invite-settings").css("display", "flex")
    $(".n-list-title").css("display", "none")
    $(".n-list-body").css("display", "none")
    $(".nis-name").html($(this).attr("name") + " " + $(this).attr("lastname"))
    $(".nis-id").html($(this).attr("id"))
    GiveMotelSource = $(this).attr("id")
    NearbyInvite = true
    BossMenuActive = false
    LoadAllRooms(motelstwo)
})

$(document).on("click", ".management-requests", function() {
    data = requestdata
    JSStyle2(data.stylemenu)
    OdaTypeRequest = data.OdaTypeR
    ChanceStyleRequest = true
    MotelManagementFlex = false
    motelintypiabe = data.OdaTypeR
    motelroomupgradepricevip = data.VIPUpgradeMoney
    motelroomupgradepricemiddle = data.MiddleUpgradeMoney
    $(".motel-management").css("display", "none");
    $(".chancestyle-motelroomsrequest").css("display", "flex");
    $("#squattertextisterequst").html(translate["squatter_rooms_text"])
    $("#middleroomslowertext").html(translate["middle_rooms_text"])
    $("#viproomslowertext").html(translate["vip_rooms_text"])
    $("#upgrademenu-no-textrequest").html(translate["no"])
    $("#upgrademenu-motelnamerequest").html(translate["vip_motel_room"])
    $("#upgrademenu-titlerequest").html(translate["room_upgrade"])
    $("#upgrademenu-title2request").html(translate["choose_style"])
    $("#upgrademenu-title3request").html(translate["choose_wall"])
    $("#up-menu-cancel-txtrequest").html(translate["cancel"])
    $("#upgrademenu-no-numberrequest").html(data.OdanoR)
    $("#upgrademenu-motelnamerequest").html(OdaTypeRequest.toUpperCase() + " " + translate["motel_roomU"])


    if (OdaTypeRequest === translate["vip"]) {
        $("#squatterimgupgraderequest").attr("src", "./img/black-squatter.png")
        $(".badrooms-upgraderequest").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".badrooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".badrooms-upgraderequest").css("cursor", "not-allowed")
        $("#middleimgpraderequest").attr("src", "./img/black-door.png")
        $(".middlerooms-upgraderequest").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".middlerooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".middlerooms-upgraderequest").css("cursor", "not-allowed")
        $("#vipimgupgraderequest").attr("src", "./img/gray-vip.png");
        $(".viprooms-upgraderequest").css("background", "linear-gradient(158.74deg, #FFB800 14.01%, #FF8A00 108.88%)")
        $(".viprooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".viprooms-upgraderequest").css("cursor", "not-allowed")
        BadUpClick2(false);
        MiddleUpClick2(false);
        VIPUpClick2(false);
    } else if (OdaTypeRequest === translate["middle"]) {
        $("#squatterimgupgraderequest").attr("src", "./img/black-squatter.png")
        $(".badrooms-upgraderequest").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".badrooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".badrooms-upgraderequest").css("cursor", "not-allowed")
        $("#middleimgpraderequest").attr("src", "./img/black-door.png")
        $(".middlerooms-upgraderequest").css("background", "linear-gradient(158.74deg, #FFB800 14.01%, #FF8A00 108.88%)")
        $(".middlerooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".middlerooms-upgraderequest").css("cursor", "not-allowed")
        BadUpClick2(false);
        MiddleUpClick2(false);
        VIPUpClick2(true);
    } else if (OdaTypeRequest === translate["squatter"]) {
        $("#squatterimgupgraderequest").attr("src", "./img/black-squatter.png")
        $(".badrooms-upgraderequest").css("background", "linear-gradient(0deg, rgba(205, 76, 76, 0.473), rgba(205, 76, 76, 0.2)), rgba(255, 255, 255, 0.08)")
        $(".badrooms-upgraderequest > span").css("color", "rgba(0, 0, 0, 0.73)")
        $(".badrooms-upgraderequest").css("cursor", "not-allowed")
        BadUpClick2(false);
        MiddleUpClick2(true);
        VIPUpClick2(true);
    }
})

var motelmanagementacildi = false

MotelManagement = function(data) {
    if(motelmanagementacildi === false) {
        motelmanagementacildi = true
        requestdata = data
        $(".motel-management").css("display", "flex");
        $("#managementheader").html(translate["managamentheader"])
        $("#nearbyplayersh").html(translate["nearbyplayersh"])
        $("#friendsheader").html(translate["friendsheader"])
        $("#requestheader").html(translate["requestheader"])

        sonveri = data.Date
        sonveri2 = sonveri.slice(0,16);
        $(".time-left").html(translate["managementtimeleft"] + sonveri2)
        $(".mm-save > span").html(translate["managementsave"])
        MotelRoomUpHourse = data.SaatlikPrice
        MotelManagementFlex = true
        NearbyFriends(requestdata)
        $(".management-nearby").addClass("emrelutfisagolsun")
    } else if (motelmanagementacildi == true) {
        requestdata = data
        $(".motel-management").css("display", "flex");
        sonveri = data.Date
        sonveri2 = sonveri.slice(0,16);
        $(".time-left").html(translate["managementtimeleft"] + sonveri2)
        MotelRoomUpHourse = data.SaatlikPrice
        MotelManagementFlex = true
    }
    if (testlerbillah === true ) {
        LoadFriends(requestdata)
    }
}

NearbyFriends = function(data) {
    $.post('https://oph3z-motels/NerabyPlayers', JSON.stringify({
        managementDoor: true,
        Coords: data.Coords
        }));
    $(".mm-nearby-players").css("display", "flex");
    $(".pi-add").html(translate["friendstextlower"])
    $(".pi-invite").html(translate["invitetexylower"])
    $(".mnp-players").html("");
    let html = "";
    for (let index = 0; index < data.length; index++) {
        const element = data[index];
        html = `
        <div class="playersiste">
        <span>${element.Name + " " + element.Lastname}</span>
            <div class="pi-add" afplayerid="${element.target}" senderinveiteid="${element.sender}"> <span>Add Friend</span> </div>
            <div class="pi-invite" targetinviteid="${element.target}" senderinveiteid="${element.sender}"> <span>Invite</span> </div>
        </div>
        `
        $(".mnp-players").append(html)
    }
};

$(document).on("click", ".pi-invite", function() {
    const misafir = $(this).attr("targetinviteid")
    const evsahibi = $(this).attr("senderinveiteid")
    data = requestdata

    $.post('https://oph3z-motels/InvitePlayerRequest', JSON.stringify({
        misafir: misafir,
        evsahibi: evsahibi,
        motelid : data.MotelNo,
        odano : data.OdanoR,
        odatipi : data.OdaTypeR,
        odaTheme : data.odaTheme,
        motelname : data.MotelName,
        strip : data.Strip,
        booze : data.Booze,
    }));
});

$(document).on("click", ".pi-add", function() {
    const misafir = $(this).attr("afplayerid")
    const evsahibi = $(this).attr("senderinveiteid")
    data = requestdata
    $.post('https://oph3z-motels/InvitePlayerRequestFriends', JSON.stringify({
        misafir: misafir,
        evsahibi: evsahibi,
        motelid : data.MotelNo,
        odano : data.OdanoR,
        odatipi : data.OdaTypeR,
        odaTheme : data.odaTheme,
    }));
});

$(document).on("click", "#acceptreqq-door", function() {
    $(".send-room-invite-door").css("display", "none")
    $("#motel-room-door").html("")
    $("#motel-name-door").html("")
    $(".motelname").html("")
    $(".motelroom").html("")
    $("#acceptreqq-door > span").html("")
    $("#closereq-door > span").html("")
    $(".sri-text").html("")
    $.post('https://oph3z-motels/RoomInviteAccept', JSON.stringify({
        davetmotelid: davetmotelid,
        davetodano: davetodano,
        davetodatipi: davetodatipi,
        davetodatheme: davetodatheme,
        davetodastrip : davetodastrip,
        davetodabooze : davetodabooze,

    }));
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})


SendTransferMotelUI = function(data, seccondta) {
    davetmotelname = data.data.motelname
    newowner = data.data.playerid
    motelsahibieski = seccondta.source
    davetmotelid = data.data.motelid
    $(".send-motel-transfer").css("display", "flex")
    $("#motel-name-transfer").html(davetmotelname)
    $(".motelname").html(translate["motel_name"])
    $(".acceptreqq-transfer > span").html(translate["accept"])
    $(".closereq-transfer > span").html(translate["cancel"])
    $(".sri-text").html(` ${seccondta.firstname + " " + seccondta.lastname} <span>${translate["room_invite_text"]}</span> `)
}
$(document).on("click", "#acceptreqq-transfer", function() {
    $.post('https://oph3z-motels/MotelTransferAccept', JSON.stringify({
        newid: newowner,
        motelid : davetmotelid,
        exowner : motelsahibieski,
    }));
    $(".send-motel-transfer").css("display", "none")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})


$(document).on("click", "#closereq-transfer", function(){
    $(".send-motel-transfer").css("display", "none")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})

SendRoomFriendsReq = function(data, seccondta) {
    davetmotelid = data.data.motelid
    davetodano = data.data.odano
    davetodatipi = data.data.odatipi
    davetodatheme = data.data.odaTheme
    davetmotelname = data.data
    datamotelmisafir = data.data.misafir
    evsahibi = data.sendernameRoom.source
    $(".send-room-invite-friends").css("display", "flex")
    $("#motel-room-friends").html("(" + davetodatipi + ")")
    $(".motelname").html(translate["motel_name"])
    $(".motelroom").html(translate["motel_room_number"])
    $(".acceptreqq-friends > span").html(translate["accept"])
    $(".closereq-friends > span").html(translate["cancel"])
    $("#motel-name-friends").html(davetodano)
    $(".sri-text").html(` ${seccondta.firstname + " " + seccondta.lastname} <span>${translate["room_invite_text"]}</span> `)
}

$(document).on("click", "#acceptreqq-friends", function() {
    $.post('https://oph3z-motels/AddFriend', JSON.stringify({
        id: datamotelmisafir,
        motelid : davetmotelid,
        odano : davetodano,
        evsahhibi : evsahibi,
    }));
    $(".send-room-invite-friends").css("display", "none")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})


$(document).on("click", "#closereq-friends", function(){
    $(".send-room-invite-friends").css("display", "none")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})


SendRoomInviteReq = function(data, seccondta) {
    davetmotelid = data.data.motelid
    davetodano = data.data.odano
    davetodatipi = data.data.odatipi
    davetodatheme = data.data.odaTheme
    davetodastrip = data.data.strip
    davetodabooze = data.data.booze
    davetmotelname = data.data
    $(".send-room-invite-door").css("display", "flex")
    $("#motel-room-door").html("(" + davetodatipi + ")")
    $("#motel-name-door").html(davetodano)
    $(".motelname").html(translate["motel_room_number"])
    $(".motelroom").html(translate["motel_room_type"])
    $("#acceptreqq-door > span").html(translate["accept"])
    $("#closereq-door > span").html(translate["cancel"])
    $(".sri-text").html(` ${seccondta.firstname + " " + seccondta.lastname} <span>${translate["motel_room_req"]}</span> `)
}


$(document).on("click", "#closereq-door", function(){
    $(".send-room-invite-door").css("display", "none")
    $("#motel-room-door").html("")
    $("#motel-name-door").html("")
    $(".motelname").html("")
    $(".motelroom").html("")
    $("#acceptreqq-door > span").html("")
    $("#closereq-door > span").html("")
    $(".sri-text").html("")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}));
})

LoadFriends = function(data) {
    $(".mm-friends").css("display", "flex");
    $(".pi-kick").html(translate["firendskicktext"])

    if (data.Friends !== undefined || data.Friends !== "[]" || data.Friends !== []) {
        $(".mf-players").html("");
        friendsdata = data.Friends
    
        for (let index = 0; index < friendsdata.length; index++) {
            const element = friendsdata[index];
            html = `
            <div class="playersiste2">
                <span>${element.Name + " " + element.Lastname}</span>
                <div class="pi-kick" data-citizenid="${element.Citizenid}"> <span>Kick</span> </div>
            </div>
            `
            $(".mf-players").append(html); 
        }
    }else {
        html = `
        `
        $(".mm-friends").css("display", "flex");
        $(".mf-players").html("");
        $(".mf-players").append(html); 
    }
}

$(document).on("click", ".pi-kick", function() {
    data = requestdata
    const citizenId = $(this).data("citizenid");
    $.post('https://oph3z-motels/KickFriends', JSON.stringify({
        citizenId: citizenId,
        motelid : data.MotelNo,
        odano : data.OdanoR
    }));
});

var testlerbillah = false

$(document).on("click", "#management-button", function() {
    SelectedMenu = $(this).attr("class")

    if (SelectedMenu !== "management-nearby") {
        testlerbillah = false
        $(".mm-nearby-players").css("display", "none")
        $(".management-nearby").removeClass("emrelutfisagolsun")
    } else {
        testlerbillah = false
        $(".management-nearby").addClass("emrelutfisagolsun")
        NearbyFriends(requestdata)
    }

    if (SelectedMenu !== "management-friends") {
        testlerbillah = false
        $(".mm-friends").css("display", "none")
        $(".management-friends").removeClass("emrelutfisagolsun")
    } else {
        testlerbillah = true
        $(".management-friends").addClass("emrelutfisagolsun")
        LoadFriends(requestdata)
    }
})

$(document).on("click", ".management-nearby", function() {
    data = requestdata
    $.post('https://oph3z-motels/NerabyPlayers', JSON.stringify({
    managementDoor: true,
    Coords: data.Coords
}));
})

$(document).on("click", ".management-logout", function() {
    MotelManagementFlex = false
    $(".motel-management").css("display", "none")
    $.post('https://oph3z-motels/CloseUI', JSON.stringify({}))
})

$(document).on("click", "#closebro", function() {
    $(".rent-motel-rooms").css("display", "none");
    $(".send-room-soru").css("display", "none")
    $("#motel-name").html("")
    $("#motel-room").html("")
    $("#motel-time-input").val("")
    $.post('https://oph3z-motels/CloseUIRent', JSON.stringify({}))
})

$(document).on("click", "#closebro2", function() {
    $(".bossmenu").css("display", "none");
    $(".employee-invite").css("display", "none");
    $("#player-salary").css("z-index", "999999999")
    $(".nearby-players-employee").html("");
    $(".nearby-players-employee").css("display", "none");
    BossMenuActive = false
    $.post('https://oph3z-motels/CloseUIBoosmenu', JSON.stringify({}))
})

$(document).on("click", ".up-menu-cancel-btn", function () {
    $("#up-menu-save-txt").html("$0");
    UpgradeMenuActive = false
    BossMenuActive = true
    $(".chancestyle-motelrooms").css("display", "none")
    $("#squatterimgupgrade").attr("src", "./img/pwev.svg")
    $(".badrooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
    $(".badrooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".badrooms-upgrade").css("cursor", "pointer")
    $("#middleimgprade").attr("src", "./img/middle.svg")
    $(".middlerooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
    $(".middlerooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".middlerooms-upgrade").css("cursor", "pointer")
    $("#vipimgupgrade").attr("src", "./img/gray-vip.png");
    $(".viprooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
    $(".viprooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
    $(".viprooms-upgrade").css("cursor", "pointer")
    middlesectin = false
    middleClickable = false;
    vipClickable = false;
    vipsectin = null
    motelintypiabe = null
    motelintypiabeClickable = false
    CheckAnan = false
    selectbtnwalltiklandi = false
    selectbtntiklandi = false
})

$(document).on("click", ".mm-save", function () {
    $.post('https://oph3z-motels/UpHours', JSON.stringify({
        time: $(".new-time").val(),
        price: ananknkbenimanam,
        motelno: requestdata.MotelNo,
        odano: requestdata.OdanoR
    }))
    $(".new-time").val("")
    $(".tu-price").html("$0")
})

document.onkeyup = function(data) {
    if (data.which == 27) {
        if (BuyMotelMenuActive === true) {
            BuyMotelMenuActive = false
            $(".motel-isletme-satin-alma-ekrani").css("display", "none");
            $.post('https://oph3z-motels/CloseUIBuy', JSON.stringify({}))
        } else if (BossMenuActive === true) {
            BossMenuActive = false
            $(".bossmenu").css("display", "none");
            $(".employee-invite").css("display", "none");
            $("#player-salary").css("z-index", "999999999")
            $(".nearby-players-employee").html("");
            $(".nearby-players-employee").css("display", "none");
            $.post('https://oph3z-motels/CloseUIBoosmenu', JSON.stringify({}))
        } else if (EmployesInvite === true) {
            BossMenuActive = true
            EmployesInvite = false
            $(".employee-invite").css("display", "none");
            $("#player-salary").css("z-index", "999999999")
        } else if (NearbyInvite == true) {
            NearbyInvite = false
            BossMenuActive = true
            $(".np-invite-settings").css("display", "none")
            $(".n-list-title").css("display", "block")
            $(".n-list-body").css("display", "block")
            $(".nearby-players-cat").css("display", "block")
        } else if (FixmenuActive == true) {
            FixmenuActive = false
            BossMenuActive = true
            $(".fix-room-menu").css("display", "none")
        } else if (UpgradeMenuActive == true) {
            $("#up-menu-save-txt").html("$0");
            UpgradeMenuActive = false
            BossMenuActive = true
            $(".chancestyle-motelrooms").css("display", "none")
            $("#squatterimgupgrade").attr("src", "./img/pwev.svg")
            $(".badrooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
            $(".badrooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
            $(".badrooms-upgrade").css("cursor", "pointer")
            $("#middleimgprade").attr("src", "./img/middle.svg")
            $(".middlerooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
            $(".middlerooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
            $(".middlerooms-upgrade").css("cursor", "pointer")
            $("#vipimgupgrade").attr("src", "./img/gray-vip.png");
            $(".viprooms-upgrade").css("background", "rgba(255, 255, 255, 0.09)")
            $(".viprooms-upgrade > span").css("color", "rgba(255, 255, 255, 0.3)")
            $(".viprooms-upgrade").css("cursor", "pointer")
            middlesectin = false
            middleClickable = false;
            vipClickable = false;
            vipsectin = null
            motelintypiabe = null
            motelintypiabeClickable = false
            CheckAnan = false
            selectbtnwalltiklandi = false
            selectbtntiklandi = false
            selectedStyles = []
        } else if (ChanceStyleRequest == true) {
            MotelManagementFlex = true
            ChanceStyleRequest = false
            selectedStyles2 = []
             $(".chancestyle-motelroomsrequest").css("display", "none")
             $(".motel-management").css("display", "flex");
            //  $.post('https://oph3z-motels/CloseUI', JSON.stringify({}))
        } else if (MotelManagementFlex == true) {
            motelmanagementacildi = false
            MotelManagementFlex = false
            testlerbillah = false
            $(".motel-management").css("display", "none")
            $(".mm-nearby-players").css("display", "none")
            $(".mm-friends").css("display", "none")
            $(".management-friends").removeClass("emrelutfisagolsun")
            $(".management-nearby").removeClass("emrelutfisagolsun")
            $.post('https://oph3z-motels/CloseUI', JSON.stringify({}))
        }
    }
}