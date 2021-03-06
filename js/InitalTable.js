﻿/// <reference path="jquery.js" />
/// <reference path="JavaScript.js" />

function Init() {
    dateSelect();
    $(".div-a").hide();
    $.post("../server/InitPageDataHandler.ashx", { "isInit": true }, function (msg) {
        var html = eval('(' + msg + ')');
        var zone = html.html[0].zone;
        var CNY = html.html[0].CNY;
        var date = html.html[0].date;
        var phone = html.html[0].phone;
        $("p#zone").html(zone);
        $("p#CNY").html(CNY);
        $("p#date").html(date);
        //$("p#phone").html(phone);
        k();
        //$(".btn-sm").css("display", "none")
    });//POST执行完成前，K已经执行，导致找不到参数
}
function k(){
    //取值
    var zone = $("#un").val();
    var mar = $("#mar").val();
    var dt = $("#pw").val();
    var user = "s";//从session 获取
    var initPage = "true";
    //$.post("../server/GetNameByIDHandler.ashx", { "type": 1 }, function (msg) {
    //    user = msg;
    //});
    //发送数据
    var data = { "uid": user, "zid": zone, "mid": mar, "date": dt, "ipage": initPage };
    $.post("../server/NewRecordHandler.ashx", data, function (msg) {
        $("#tableContainer").html(msg);
        var date = new Date();
        beginTime = date.Format("yyyy-MM-dd hh:mm:ss");
        endTime = new Date("2016/01/19 01:00:00").Format("yyyy-MM-dd hh:mm:ss");///////在此处修改报名结束时间
        //alert(endate);
        var beginTimes = beginTime.substring(0, 10).split('-');
        var endTimes = endTime.substring(0, 10).split('-');
        beginTime = beginTimes[1] + '-' + beginTimes[2] + '-' + beginTimes[0] + ' ' + beginTime.substring(10, 19);
        endTime = endTimes[1] + '-' + endTimes[2] + '-' + endTimes[0] + ' ' + endTime.substring(10, 19);
        //alert(beginTime);
        //alert(endTime);
        var a = (Date.parse(endTimes) - Date.parse(beginTimes)) / 3600 / 1000;
        //var b = (Date.parse(beginTimes) - Date.parse(endTimes)) / 3600 / 1000;
        //alert(Date.parse(endTimes));
        //alert(Date.parse(beginTimes));
        //alert("a%"+a);//-
        //alert("b%"+b);//+
        if (a < 0) {
            $(".btn-sm").css("display", "none")
        } else if (a > 0) {
            //alert("endTime大!");
            //$(".btn-sm").css("display", "none")
        } else if (a == 0) {
            //alert("时间相等!");
        }

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

Date.prototype.Format = function (fmt) { //author: meizz   
    var o = {
        "M+": this.getMonth() + 1,                 //月份   
        "d+": this.getDate(),                    //日   
        "h+": this.getHours(),                   //小时   
        "m+": this.getMinutes(),                 //分   
        "s+": this.getSeconds(),                 //秒   
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度   
        "S": this.getMilliseconds()             //毫秒   
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}