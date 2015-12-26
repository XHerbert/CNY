<%@ WebHandler Language="C#" Class="SubmitDataHandler" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public class SubmitDataHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
        string num = context.Request.Form["num"].ToString();
        string btnText = context.Request.Form["btnText"].ToString();
        //string connStr =  @"server = 4RBLIOWUDMHUMSF; database = db_Count; uid = sa; pwd = 123456";
        String connStr = ConfigurationManager.ConnectionStrings["db_CountConnectionString"].ToString();
        DataTable dt = null;
        if (num.StartsWith("051"))
        {
            num = num.Replace("051", "4");
        }
        if (num.StartsWith("51"))
        {
            num = num.Replace("51", "4");
        }
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            //检测历史数据，如果有，提示并返回，否则继续执行
            using (SqlCommand cmd=new SqlCommand())
            {
                conn.Open();
                //string commandText = string.Format("select * from tb_Record where userNum='{0}' and btnContent='{1}'",num,btnText);
                string commandText = string.Format("select * from tb_Record where userNum='{0}' and flag=0",num,btnText);
                cmd.CommandText = commandText;
                cmd.Connection = conn;
                object i=cmd.ExecuteScalar();
                if (i != null)
                {
                    context.Response.Write("exist");
                    return;
                }
            }

            //没有历史数据
            using (SqlCommand cmd = new SqlCommand())
            {
                if (conn.State != ConnectionState.Open)
                {
                    conn.Open();
                }
                string commandText = string.Format("insert into tb_Record (userNum,btnContent,clickDate,flag) values ('{0}','{1}',GETDATE(),0)", num, btnText);
                cmd.CommandText = commandText;
                cmd.Connection = conn;
                int r = cmd.ExecuteNonQuery();
                if (r > 0)
                {
                    context.Response.Write("true");
                }
                else
                {
                    context.Response.Write("false");
                }

            }
        }

        //context.Response.Write(num);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}