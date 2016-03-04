<%@ WebHandler Language="C#" Class="QueryHandler" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;

public class QueryHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
        string zone = context.Request.Form["zid"];
        string market = context.Request.Form["mid"];
        string date = context.Request.Form["date"];

        if (string.IsNullOrEmpty(zone) || string.IsNullOrEmpty(market) || string.IsNullOrEmpty(date))
        {
            context.Response.Write("Args Error");
            return;
        }

        SqlParameter[] para =
        {
            new SqlParameter("@zid",SqlDbType.Int),
            new SqlParameter("@mid",SqlDbType.Int),
            new SqlParameter("@date",SqlDbType.Date)
        };
        para[0].Value = zone;
        para[1].Value = market;
        para[2].Value = date;
        DataTable dt = SQL.ExcuteProcedureQuery("CJList", para);
        string result = BuildRecoedTable(dt);
        context.Response.Write(result);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }


    private string BuildRecoedTable(DataTable records)
    {

        StringBuilder table = new StringBuilder();
        table.Append("<table id=\'tList\' class=\'table table-condensed t_tb\'>");
        table.Append("<thead><td>区域</td><td>门店</td><td>冲击人员</td><td>日期</td><td>电话</td></thead>");
        foreach (DataRow row in records.Rows)
        {
            //string btn = string.Format("<button id=\'btn&&&{0}\' class=\'btn-sm\' type=\'button\'>撤销</button>",row[0]);
            table.Append(string.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>", row[0], row[1], row[2], row[3], row[4]));
        }
        table.Append("</table>");
        return table.ToString();
    }

}