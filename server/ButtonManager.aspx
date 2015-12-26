<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ButtonManager.aspx.cs" Inherits="server_ButtonManager" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        .新建样式1 {
            font-family: 微软雅黑;
            font-size: large;
            font-weight: bold;
            color: #A0A0A0;
        }
        .新建样式2 {
            font-family: 微软雅黑;
            font-size: large;
            font-weight: bolder;
            color: #A0A0A0;
        }
        .新建样式3 {
            font-family: 微软雅黑;
            color: #A0A0A0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <p><span class="新建样式1">活动管理</span></p>
    </div>
        <div style="float:left">


            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" CellPadding="3" DataKeyNames="id" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical" OnRowUpdated="GridView1_RowUpdated">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowSelectButton="True" />
                    <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" ReadOnly="True" SortExpression="id" />
                    <asp:BoundField DataField="buttonContent" HeaderText="活动内容" SortExpression="buttonContent" />
                </Columns>
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
               
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:db_CountConnectionString %>" DeleteCommand="DELETE FROM [tb_Button] WHERE [id] = @id" InsertCommand="INSERT INTO [tb_Button] ([buttonContent]) VALUES (@buttonContent)" SelectCommand="SELECT * FROM [tb_Button]" UpdateCommand="UPDATE [tb_Button] SET [buttonContent] = @buttonContent WHERE [id] = @id">
                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="buttonContent" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="buttonContent" Type="String" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>


        </div>

        <div style="float:left;margin-left:100px">
            <p><span class="新建样式2">新增活动</span></p>
            <div>
                <span class="新建样式3">活动内容：</span><asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            </div>
            <p>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="Button1" runat="server" Text="提交活动" OnClick="Button1_Click" /></p>
            <p>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label1" runat="server" Text=""></asp:Label></p>

            <p><a href="ShowData.aspx">查看参加活动人员数据</a></p>
            <p><a href="../Account.html">查看活动页面</a></p>
            <p><a href="ChangeText.aspx">修改活动信息</a></p>
            <p><asp:Label ID="Label2" runat="server" Text="Label"></asp:Label></p>
            
        </div>
    </form>
</body>
</html>
