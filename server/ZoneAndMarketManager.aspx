<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ZoneAndMarketManager.aspx.cs" Inherits="server_ZoneAndMarketManager" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div style="width: 40%; margin-left: 5%; float: left">

                <fieldset>
                    <legend>区域列表</legend>
                    <div id="tbz"></div>
                </fieldset>
                <fieldset>
                    <legend>超市列表</legend>
                    <div id="tb_m"></div>
                </fieldset>
            </div>

            <div style="float: right; width: 30%">
                <fieldset style="width: 80%">
                    <legend>添加区域</legend>

                    <input type="text" id="z" runat="server" placeholder="请输入地址名称" class="text-success" />
                    <p></p>

                    <p>
                        <asp:Button ID="z_add" runat="server" Text="添加" CssClass="btn-success" Height="35" OnClick="z_add_Click" />
                    </p>
                </fieldset>
                <!---->
                 <fieldset style="width: 80%">
                    <legend>添加用户</legend>

                    <input type="text" id="usereg"  placeholder="请输入用户名" class="text-success" />
                    <p></p>
                     <input type="text" id="pwd2"  placeholder="请输入密码" class="text-success" />
                    <p></p>
                    <p>
                        <!--分析下来,如果button被firefox,chrome视为submit,导致不能提交Ajax的POST请求.
                        <button id="regServer"   class="btn-success"  >添加</button>-->
                        <input type="button" id="regServer"   class="btn-success"  value="添加" />
                    </p>
                </fieldset>
                <!---->


                <fieldset style="width: 80%">
                    <legend>添加超市</legend>

                    <input type="text" id="m" runat="server" placeholder="请输入超市名称" class="text-success" />
                    <p></p>

                    <asp:DropDownList ID="zone_d" runat="server"></asp:DropDownList>
                    <p></p>
                    <p>
                        <asp:Button ID="m_add" runat="server" Text="添加" CssClass="btn-success" Height="35" OnClick="m_add_Click" />
                    </p>
                </fieldset>
                <fieldset style="width: 80%">
                    <legend>导入用户数据</legend>
                    <asp:FileUpload ID="file" runat="server" />
                    
                    <p></p>
                    <p>
                        <asp:Button ID="import" runat="server" Text="导入" CssClass="btn-success" Height="35" OnClick="import_Click" />
                    </p>
                </fieldset>
                <fieldset style="width: 80%">
                    <legend>导入超市数据</legend>
                    <asp:FileUpload ID="file2" runat="server" />
                    
                    <p></p>
                    <p>
                        <asp:Button ID="btnMarket" runat="server" Text="导入" CssClass="btn-success" Height="35" OnClick="btnMarket_Click" />
                    </p>
                </fieldset>
                 <fieldset style="width: 80%">
                    <legend>相关链接</legend>
                                        
                    <p>

                    </p>
                    <p> 
                       <%--<a href="../Registration.html">回到报名页面</a><br />
                        <a href="LoginHandler.ashx">回到登录页面</a><br />--%>
                        <a href="ShowData.aspx">查看数据页面</a>
                    </p>
                </fieldset>
            </div>
        </div>
    </form>
    <div class="div-a">
        <div class="div-b">
            <p></p>
        </div>
    </div>
    <script src="../js/jquery-1.8.3.min.js"></script>
    <script src="../js/JavaScript.js"></script>
</body>
</html>
