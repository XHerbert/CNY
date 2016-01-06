<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowData.aspx.cs" Inherits="server_ShowData" %>

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
            <asp:GridView ID="detail" runat="server" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4" EnableModelValidation="True" OnSelectedIndexChanged="detail_SelectedIndexChanged" OnRowDeleting="detail_RowDeleting">
                <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" />
                <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                <RowStyle BackColor="White" ForeColor="#330099" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
               <Columns>
                
                <asp:CommandField ShowDeleteButton="True" />
            </Columns>
            </asp:GridView>
                </div>
            <div style="float:left;margin-left:5px">
            </div>
            <div style="float:left;margin-left:5px">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" DataKeyNames="id" DataSourceID="Users" EnableModelValidation="True" Visible="False">
                <Columns>
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                    <asp:BoundField DataField="id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="id" />
                    <asp:BoundField DataField="userName" HeaderText="用户名" SortExpression="userName" />
                    <asp:BoundField DataField="pass" HeaderText="密码" SortExpression="pass" />
                </Columns>
                <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
                <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
                <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
            </asp:GridView>
            </div>
            
            <asp:SqlDataSource ID="Users" runat="server" ConnectionString="<%$ ConnectionStrings:db_CountConnectionString %>" DeleteCommand="DELETE FROM [tb_User] WHERE [id] = @id" InsertCommand="INSERT INTO [tb_User] ([userName], [pass]) VALUES (@userName, @pass)" SelectCommand="SELECT [id], [userName], [pass] FROM [tb_User]" UpdateCommand="UPDATE [tb_User] SET [userName] = @userName, [pass] = @pass WHERE [id] = @id">
                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="userName" Type="String" />
                    <asp:Parameter Name="pass" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="userName" Type="String" />
                    <asp:Parameter Name="pass" Type="String" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
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
                    <legend>新增报名</legend>
                 <p>用户名：<asp:TextBox ID="TextBox1" runat="server" OnTextChanged="TextBox1_TextChanged"></asp:TextBox></p>
                 <p>日期：
                 <asp:DropDownList ID="DropDownList3" runat="server" Height="30px" Width="175px">
                     <asp:ListItem>2016-1-31</asp:ListItem>
                     <asp:ListItem>2016-1-29</asp:ListItem>
                     <asp:ListItem>2016-2-1</asp:ListItem>
                     <asp:ListItem>2016-2-2</asp:ListItem>
                     <asp:ListItem>2016-2-3</asp:ListItem>
                     <asp:ListItem>2016-2-4</asp:ListItem>
                     <asp:ListItem>2016-2-5</asp:ListItem>
                     <asp:ListItem>2016-2-6</asp:ListItem>
                     <asp:ListItem>2016-2-7</asp:ListItem>
                     </asp:DropDownList></p>

                 <p>
                     <asp:Button ID="Add" runat="server" CssClass="btn-success" Text="新增" OnClick="Add_Click" /></p>
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
