﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowData.aspx.cs" Inherits="server_ShowData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link href="../assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/datepicker.css" type="text/css" />
    <link rel="stylesheet" media="screen" type="text/css" href="css/layout.css" />
    <title>Manage Active</title>
    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/datepicker.js"></script>
    <script type="text/javascript" src="js/eye.js"></script>
    <script type="text/javascript" src="js/utils.js"></script>
    <script type="text/javascript" src="js/layout.js?ver=1.0.2"></script>
    <style type="text/css">
        div, p {
            margin: 10px auto 10px;
            text-align:left;
        }
        #t{color:#FFF}
        /*#c1,#c2{display:none}*/
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="float: left;margin-left:10px">
            <div style="float:left">
            <asp:GridView ID="detail" runat="server" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4">
                <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" />
                <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                <RowStyle BackColor="White" ForeColor="#330099" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
               
            </asp:GridView>
                </div>
            <div style="float:left;margin-left:5px">
                <asp:GridView ID="user" runat="server" BackColor="White" BorderColor="White" BorderStyle="Ridge" BorderWidth="2px" CellPadding="5" EnableModelValidation="True" GridLines="both" CellSpacing="5">
                <FooterStyle BackColor="#C6C3C6" ForeColor="Black" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#E7E7FF" />
                <PagerStyle BackColor="#C6C3C6" ForeColor="Black" HorizontalAlign="Right" />
                <RowStyle BackColor="#DEDFDE" ForeColor="Black" />
                <SelectedRowStyle BackColor="#9471DE" Font-Bold="True" ForeColor="White" />
               
            </asp:GridView>
            </div>
        </div>
        <div style="float: right; width: 40%; z-index: 12">
            <fieldset>
                <legend>查询条件</legend>
                <p>
                    日期：<input type="text" runat="server" id="inputfromDate" value="" />
                    到&nbsp;
                    <input type="text" runat="server" id="inputtoDate" value="" />
                </p>
                <p>区域：<asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"></asp:DropDownList></p>
                <p>超市：<asp:DropDownList ID="DropDownList2" runat="server"></asp:DropDownList></p>
            </fieldset>
        </div>

        <div style="float: right;margin-right:20px">
            <fieldset>
                <legend>操作</legend>
                 <p>
                    <asp:Button ID="query" runat="server" Text="按条件查询" CssClass="btn-success" OnClick="query_Click" Height="35" />
                </p>
                <p>
                    <asp:Button ID="queryAll" runat="server" Text="按全部查询" CssClass="btn-success" OnClick="queryAll_Click" Height="35" />
                </p>
                <p>
                <asp:Button CssClass="btn-success" ID="export" runat="server" Text="导出全部数据到Excel" OnClick="export_Click" BorderStyle="None" Height="35"/>
                </p>
                <p>
                    <asp:Button ID="dateExport" runat="server" CssClass="btn-success" Text="导出查询数据到Excel" OnClick="dateExport_Click" Height="35"/>
                </p>
            </fieldset>
            <fieldset style="width: 80%">
                    <legend>相关链接</legend>
                                        
                    <p>

                    </p>
                    <p> 
                       <%--<a href="../Registration.html">回到报名页面</a><br />
                        <a href="LoginHandler.ashx">回到登录页面</a><br />--%>
                        <a href="ZoneAndMarketManager.aspx">去控制面板</a>
                    </p>
                </fieldset>
        </div>
        <div id="c1">
        </div>
        <div id="c2">
        </div>
    </form>

    
    <script src="../js/dateLib.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var date = new Date();
            var day = date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate();
            $("#inputfromDate").val(day);
            $("#inputtoDate").val(day);
        })

        var time1 = new Date().Format("yyyy-MM-dd");
        $("#inputfromDate").val(time1);
        $("#inputtoDate").val(time1);

        $('#inputfromDate').DatePicker({
            format: 'Y/m/d',
            date: $('#inputfromDate').val(),
            current: $('#inputfromDate').val(),
            starts: 1,
            position: 'r',
            onBeforeShow: function () {
                $('#inputfromDate').DatePickerSetDate($('#inputfromDate').val(), true);
            },
            onChange: function (formated, dates) {
                $('#inputfromDate').val(formated);
                if ($('#closeOnSelect input').attr('checked')) {
                    $('#inputfromDate').DatePickerHide();
                }
            }
        });


        $('#inputtoDate').DatePicker({
            format: 'Y/m/d',
            date: $('#inputtoDate').val(),
            current: $('#inputtoDate').val(),
            starts: 1,
            position: 'r',
            onBeforeShow: function () {
                $('#inputtoDate').DatePickerSetDate($('#inputtoDate').val(), true);
            },
            onChange: function (formated, dates) {
                $('#inputtoDate').val(formated);
                if ($('#closeOnSelect input').attr('checked')) {
                    $('#inputtoDate').DatePickerHide();
                }
            }
        });


    </script>
</body>
</html>