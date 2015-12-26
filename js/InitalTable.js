/// <reference path="jquery.js" />

function Init() {
    $(".div-a").hide();
    $.post("../server/InitPageDataHandler.ashx", { "isInit": true }, function (msg) {
        var html = eval('(' + msg + ')');
        var zone = html.html[0].zone;
        var CNY = html.html[0].CNY;
        $("p#zone").html(zone);
        $("p#CNY").html(CNY);
        k();
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
    });
}