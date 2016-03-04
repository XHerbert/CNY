<%@ WebHandler Language="C#" Class="NewRecordHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Text;
using System.Data;

public class NewRecordHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string msg = string.Empty;
        int i = -1;
        string initPage = context.Request.Form["ipage"];
        if (initPage == "false")//插入数据，非载入页面
        {
            string uid = context.Session["user"].ToString();
            string zid = context.Request.Form["zid"];
            string mid = context.Request.Form["mid"];
            string date = context.Request.Form["date"];
            string phone = context.Request.Form["phone"];

            SqlParameter[] pars = {
            new SqlParameter("@uid",System.Data.SqlDbType.Int),
            new SqlParameter("@zid",System.Data.SqlDbType.Int),
            new SqlParameter("@mid",System.Data.SqlDbType.Int),
            new SqlParameter("@date",System.Data.SqlDbType.Date),
            new SqlParameter("@phone",System.Data.SqlDbType.VarChar)
            };

            pars[0].Value = uid;
            pars[1].Value = zid;
            pars[2].Value = mid;
            pars[3].Value = date;
            pars[4].Value = phone;
            i = SQL.ExcuteProcedureNonquery("sp_AddSendNameRecord", "@state", pars);
            if (i == -1)
            {
                context.Response.Write(-1);//"报名次数达到上限了哦"
            }else if (i == -2)
            {
                context.Response.Write(-2);//"该地区该超市已经报名了哦"
            }
            else if (i == -3)
            {
                context.Response.Write(-3);//"今天已经报名了哦"
            }
            else if (i == -5)
            {
                context.Response.Write(-5);//"该地区该超市已经报名了哦"
            }
            else
            {
                SqlParameter p = new SqlParameter("@userId", SqlDbType.Int);
                p.Value = Convert.ToInt32(context.Session["user"].ToString());
                DataTable dt = SQL.ExcuteProcedureQuery("sp_SendNameTable", p);

                if (dt.Rows.Count > 0)
                {
                    msg = BuildRecoedTable(dt);
                }
            }

        }

        if (initPage == "true")//载入页面，非插入
        {
            SqlParameter p = new SqlParameter("@userId", SqlDbType.Int);
            p.Value = Convert.ToInt32(context.Session["user"].ToString());
            DataTable dt = SQL.ExcuteProcedureQuery("sp_SendNameTable", p);

            if (dt.Rows.Count > 0)
            {
                msg = BuildRecoedTable(dt);
            }
        }
        context.Response.Write(msg);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


    private string BuildRecoedTable(DataTable records)
    {

        StringBuilder table = new StringBuilder();
        //table.Append("{\"tb\":[{\"table\":");
        table.Append("<table id=\'t\' class=\'table table-condensed t_tb\' style=\'display:none\'>");
        table.Append("<table id=\'t\' class=\'table table-condensed t_tb\'>");
        //table.Append("<thead><td>员工号</td><td>区域</td><td>超市</td><td>时间</td><td>操作</td></thead>");
        foreach (DataRow row in records.Rows)
        {
            string dateValue = row[4].ToString().Replace("/","-").ToString().Split(' ')[0];
            string btn = string.Format("<button id=\'btn&&&{0}\' class=\'btn-sm\' type=\'button\'>撤销</button>",row[0]);
            //table.Append(string.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>", row[1], row[2], row[3], dateValue, btn));
            table.Append(string.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td></tr>", row[1], row[2], row[3], dateValue));
        }
        table.Append("</table>");
        //table.Append("\"state\":");
        //table.Append("" + state + "}]}");
        return table.ToString();
        /*JOSN
        StringBuilder table = new StringBuilder();
        table.Append("{\"tb\":[{\"table\":");
        table.Append("\"<table class=\'table table-condensed table-hover\'>");
        table.Append("<thead><td>员工号</td><td>区域</td><td>超市</td><td>时间</td><td>操作</td></thead>");
        foreach (DataRow row in records.Rows)
        {
            string btn = string.Format("<button id=\'btn_{0}\' class=\'btn-sm\' type=\'button\'>撤销</button>", row[0]);
            table.Append(string.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>", row[1], row[2], row[3], row[4].ToString().Substring(0, 10), btn));
        }
        table.Append("</table>\",");
        table.Append("\"state\":");
        table.Append("" + state + "}]}");
        return table.ToString();
        */



    }

}