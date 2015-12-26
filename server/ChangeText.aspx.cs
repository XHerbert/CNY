using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public partial class server_ChangeText : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DatabindList();
        
    }


    private void DatabindList()
    {
        String connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
        StringBuilder tb = new StringBuilder();
        DataTable dt = new DataTable();
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            //检测历史数据，如果有，提示并返回，否则继续执行
            using (SqlCommand cmd = new SqlCommand())
            {
                conn.Open();
                string commandText = "select * from tb_Button";
                cmd.CommandText = commandText;
                cmd.Connection = conn;
                SqlDataAdapter sda = new SqlDataAdapter(commandText, conn);
                sda.Fill(dt);
            }
        }
        if (dt != null)
        {
            tb.Append("<table style='width:50%;border:solid 1px grey;margin:40px auto ;padding:0;spacing:0;background-color:#eee'>");
            tb.Append("<th>ID</th><th>名称</th><th>操作</th>");
            foreach (DataRow item in dt.Rows)
            {
                tb.Append(string.Format("<tr><td>{0}</td><td>{1}</td><td><a href='#' onclick=\"showTb('{1}','{0}')\">修改</a></td></tr>", item["id"], item["buttonContent"]));
            }
            tb.Append("<table>");
        }
        Response.Write(tb.ToString());
    }

    protected void alter_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
        string content = con.Value;
        string id = hideId.Value;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            //检测历史数据，如果有，提示并返回，否则继续执行
            using (SqlCommand cmd = new SqlCommand())
            {
                conn.Open();
                string commandText = string.Format("update tb_Button set buttonContent='{0}' where id={1}", content,id);
                cmd.CommandText = commandText;
                cmd.Connection = conn;
                int i = cmd.ExecuteNonQuery();
            }
        }
        Response.Write("<script language='javascript'>window.location='ChangeText.aspx'</script>");
    }
}