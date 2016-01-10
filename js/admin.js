/// <reference path="jquery.js" />

//$("#admin").click(function () {
//    alert("a");
//});



function a() {
    //alert("a");
    var a=$("#au").val();
    var b=$("#apw").val();
    //alert(a);
    //alert(b);
    if (a == "" || b == "") {
        alert("error!");
        return;
    }

    if (a == "2102349" && b == "sales123") {
        window.location.href = "../server/ZoneAndMarketManager.aspx";
    }
}