using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class server_Error : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        HttpException error = new HttpException();
        string msg = error.Message;
        Response.Write("<div class=\'text-error text-center\'>"+msg+"</div>");
    }
}