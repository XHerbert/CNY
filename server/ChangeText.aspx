<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangeText.aspx.cs" Inherits="server_ChangeText" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../assets/css/css.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server" method="get">
    <div id="change_t">
        <input type="text" runat="server" class="" id="con"  hidden="" placeholder="编辑后提交即可"/> <asp:Button  ID="alter" runat="server" Text="修改" CssClass="btn-danger" OnClick="alter_Click" />
        <input type="hidden" id="hideId" runat="server"/>
    </div>
    </form>
    <script src="../js/jquery.js"></script>
    <script src="../js/JavaScript.js"></script>
</body>
</html>
