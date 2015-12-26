<%@ WebHandler Language="C#" Class="InitButtonHandler" %>

using System;
using System.Web;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

public class InitButtonHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
        DataTable dt = null;
        using (SqlConnection conn = new SqlConnection(connStr))
        {

            using (SqlCommand cmd = new SqlCommand())
            {
                conn.Open();
                cmd.CommandText = "select * from tb_Button";
                SqlDataAdapter sda = new SqlDataAdapter(cmd.CommandText, conn);
                dt = new DataTable();
                sda.Fill(dt);
            }
        }
        StringBuilder btn = new StringBuilder();
        if (dt.Rows.Count > 0 && dt!=null)
        {
            int i = 0;
            foreach (DataRow item in dt.Rows)
            {
                i++;
                btn.Append(string.Format("<p><button id='b{0}' class='btn btn-large btn{2} btn-block' value='{3}' type='button' onclick='SubmitActive(this)'>{1}</button></p>", i, item["buttonContent"].ToString(),i+1,item["buttonContent"].ToString()));
            }
        }

        context.Response.Write(btn.ToString());
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}