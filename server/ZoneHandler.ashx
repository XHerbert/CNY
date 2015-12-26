<%@ WebHandler Language="C#" Class="ZoneHandler" %>

using System;
using System.Web;
using System.Data;
using System.Text;
public class ZoneHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        DataTable z = new DataTable();
        DataTable m = new DataTable();
        
        z = SQL.ExcuteProcedureQuery("sp_ZoneList");
        string z_str = BuildZoneTable(z);
        context.Response.Write(z_str);
    }
 


    private  string BuildZoneTable(DataTable records)
    {

        StringBuilder table = new StringBuilder();
        table.Append("<table class=\'table table-condensed table-hover\'>");
        table.Append("<thead><td>区域编号</td><td>区域名称</td><td>操作</td></thead>");
        foreach (DataRow row in records.Rows)
        {
            string btn = string.Format("<button id=\'btn_{0}\' class=\'btn-sm btn-danger\' type=\'button\'>删除</button>",row[0]);
            table.Append(string.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>",row[0],row[1],btn));
        }
        table.Append("</table>");
        return table.ToString();
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}