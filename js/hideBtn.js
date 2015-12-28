/// <reference path="jquery-1.8.3.min.js" />

//后端添加
//$(document).ready(function () {
$("#regServer").click(function () {
    var u = ($("#usereg").val());
    var pw = ($("#pwd2").val());

    if (u == "" || pw == "" || pw == undefined || u == undefined) {
        //$(".div-b p").text("请正确填写注册信息！");
        //noteMsg();
        alert("请正确填写用户信息！");
        return;
    }
    var data = { "users": u, "pwd1": pw };
    $.post("../server/RegistrationHandler.ashx", data, function (msg) {
        if (msg == -1) {
            //$(".div-b p").text("该用户编号已注册！");
            //noteMsg();
            alert("该用户编号已存在！");
        } else if (msg == 1) {
            //跳转
            alert("添加成功！！");
            //window.location.reload();
            //$(".div-b p").text("注册成功！");
            //noteMsg();
            //document.location.href = "Login.html";
            //setTimeout(document.location.href = "Login.html",3);
        } else {
            alert("未知错误！");
            //$(".div-b p").text("未知错误！");
            //noteMsg();
        }
    });
});