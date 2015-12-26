/// <reference path="../" />
/// <reference path="jquery.js" />
//var time1 = new Date().Format("yyyy-MM-dd");


$(document).ready(
    $(".div-a").hide()
);


$(document).ready(
    //$(".btn-sm").css("display", "none")
    $(".btn-sm").addClass("hideBtn")
);

//$(document).ready(function () {
//    var date = $("#pw").val();
//    var curMarket = $("#mar").val();
//    var data = { "date-s": date, "mar-s": curMarket };
//    //alert(date+"###"+curMarket);
//    $.post("../server/ShowChancesHandler.ashx", data, function (msg) {
//        if (msg.indexOf('###') < 0) return;
//        var n = msg.split('###');
//        $("#leftC").html("<b>" + n[0] + "</b>");
//        $("#a_c").html("<b>" + n[1] + "</b>");
//    });
//});

$(document).ready($("#b1").click(function () {
    login();
}));

//报名
$(document).ready(
    $("#bm").click(function () {
        //取值
        var zone = $("#un").val();
        var mar = $("#mar").val();
        var dt = $("#pw").val();
        var user = "s";//从session 获取
        var initPage = "false";//非载入页面，插入数据
        //$.post("../server/GetNameByIDHandler.ashx", { "type": 1 }, function (msg) {
        //    user = msg;
        //});
        //发送数据
        var data = { "uid": user, "zid": zone, "mid": mar, "date": dt, "ipage": initPage };
        $.post("../server/NewRecordHandler.ashx", data, function (msg) {
            if (msg == -1) {
                $(".div-b p").text("报名次数达到上限了哦！");
                noteMsg();
            } else if (msg == -2) {
                $(".div-b p").text("该超市或该日期已经报名了哦！");
                noteMsg();
            } else if (msg == -3) {
                $(".div-b p").text("今天已经报名了哦！");
                noteMsg();
            } else if (msg == -5) {
                $(".div-b p").text("该超市名额已经满了哦！");
                noteMsg();
            }
            else {
                $("#tableContainer").html(msg);
            }
        });
    })
    );

//注册
$(document).ready(function () {
    $("#reg").click(function () {
        var u = ($("#usereg").val());
        var pw = ($("#pwd2").val());
        var pw2 = ($("#pwd3").val());
        if (pw != pw2 || pw == "" || pw2 == "" || pw == undefined || pw2 == undefined) {
            $(".div-b p").text("请正确填写注册信息！");
            noteMsg();
            return;
        }
        var data = { "users": u, "pwd1": pw, "pwd2": pw2 };
        $.post("../server/RegistrationHandler.ashx", data, function (msg) {
            if (msg == -1) {
                $(".div-b p").text("该用户编号已注册！");
                noteMsg();
            } else if (msg == 1) {
                //跳转
                $(".div-b p").text("注册成功！");
                noteMsg();
                document.location.href = "Login.html";
                //setTimeout(document.location.href = "Login.html",3);
            } else {
                $(".div-b p").text("未知错误！");
                noteMsg();
            }
        });
    });
});



$(document).ready(function () {
    $.post("../server/ZoneAndMarketHandler.ashx", { "isInit": true }, function (msg) {
        var html = eval('(' + msg + ')');
        //$("#tbz").html(html.html[0].zone);
        //$("p#CNY").html(CNY);
        $("#tb_m").html(html.html[0].mar);
        //$("#tbz").html(html.html[1].zone);
        //alert(html.html[0].zone);
    });
});
$(document).ready(function () {

    $.post("../server/ZoneHandler.ashx", { "isInit": true }, function (msg) {
        //var html = eval('(' + msg + ')');
        //$("#tbz").html(html.html[0].zone);
        //$("p#CNY").html(CNY);
        //$("#tb_m").html(html.html[0].mar);
        $("#tbz").html(msg);
        //alert(html.html[0].zone);
    });
});



//取超市列表
function InitZoneAndMarket() {

    //$.post("../server/ZoneAndMarketHandler.ashx", { "isInit": true }, function (msg) {
    //    var html =msg;
    //    //var zone = html.html[0].zone;
    //    //var CNY = html.html[0].CNY;
    //    $("tb_m").html(zone);
    //    //$("p#CNY").html(CNY);
    //});
}

function login() {
    $(".div-a").hide();
    var un = $("#un").val();
    var pw = $("#pw").val();
    data = { "username": un, "password": pw };
    $.post("../server/LoginHandler.ashx", data, function (msg) {

        if (msg == "SUCCESS") {
            //$(".div-b p").html("OK！");
            //noteMsg();
            document.location.href = "Registration.html";
        } else if (msg == "FAIL") {
            $(".div-b p").html("员工号或密码错误！");
            noteMsg();
            $("#un").val("");
            $("#pw").val("");
        } else {
            $(".div-b p").html(msg);
            noteMsg();
        }

    });
}


function noteMsg() {
    $(".div-a").show(300).delay(3000).hide(300);
}

function showTb(e, i) {
    $("#con").val(e);
    $("#hideId").val(i);
}

function changeSelect(e) {
    var zoneId = $("#un").val();
    var data = { "isInit": false, "zoneId": zoneId };
    $.post("../server/InitPageDataHandler.ashx", data, function (msg) {
        var html = eval('(' + msg + ')');
        var CNY = html.html[0].CNY;
        $("p#CNY").html(CNY);
    });
}

function dateSelect() {
    var date = $("#pw").val();
    var curMarket = $("#mar").val();
    var data = { "date-s": date, "mar-s": curMarket };
    //alert(date+"###"+curMarket);
    $.post("../server/ShowChancesHandler.ashx", data, function (msg) {
        if (msg.indexOf('###') < 0) return;
        var n = msg.split('###');
        $("#leftC").html("<b>" + n[0] + "</b>");
        $("#a_c").html("<b>" + n[1] + "</b>");
    });
}


$(document).click(function (e) {
    var v_id = $(e.target).attr('id');
    if (v_id == undefined || (v_id.indexOf("_") < 0 && v_id.indexOf("&&&") < 0)) {
        return;
    }

    if (v_id.indexOf("_") > 0) {
        var type = "";
        var id = "";
        var data = v_id.split("_");
        if (data[2] == undefined) {
            type = "zone";
            id = data[1];
        } else {
            type = "market";
            id = data[2];
        }
        var data = { "type": type, "id": id };
        //alert(data[0]+"#"+data[1]+"#"+data[2]);
        $.post('../server/DeleteHandler.ashx', data, function (data) {
            if (data == "success") {
                window.location.reload();
            } else {
                $(".div-b p").html(data);
                $(".div-a").show(300).delay(3000).hide(300);
            }
        });
    }

    if (v_id.indexOf("&&&") > 0) {
        var type = "";
        var id = "";
        var data = v_id.split("&&&");
        if (data[1] == undefined || data[1] == "") {
            return;
        }
        type = "cx";
        id = data[1];

        var datas = { "type": type, "id": id };
        $.post('../server/DeleteHandler.ashx', datas, function (data) {
            if (data == "success") {
                window.location.reload();
            } else {
                $(".div-b p").html(data);
                $(".div-a").show(300).delay(3000).hide(300);
            }
        });
    }
});
