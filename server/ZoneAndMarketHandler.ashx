<%@ WebHandler Language="C#" Class="ZoneAndMarketHandler" %>

using System;
using System.Web;
using System.Data;
using System.Text;
public class ZoneAndMarketHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        DataTable z = new DataTable();
        DataTable m = new DataTable();
        m=SQL.ExcuteProcedureQuery("sp_Zone_Mar");
        string m_str = BuildMarketTable(m);
        z = SQL.ExcuteProcedureQuery("sp_ZoneList");
        string z_str = BuildZoneTable(z);
        //string mz =string.Format("{\"ht\":[{\"m\":\"{0}\",\"z\":\"{1}\"}]}",m_str,z_str);
        StringBuilder mz = new StringBuilder();
        mz.Append("{");
        mz.Append("\"html\":");
        mz.Append("[{");
        mz.Append("\"mar\":");
        mz.Append("\"" + m_str + "\"},");
        mz.Append("{\"zone\":");
        mz.Append("\""+z_str+"\"");
        mz.Append("}]");
        mz.Append("}");
        context.Response.Write(mz);
    }


    private  string BuildMarketTable(DataTable records)
    {
        
        //string btn = "<button id=\'btn\' class=\'btn-sm btn-danger\' type=\'button\'>删除</button>";
        StringBuilder table = new StringBuilder();
        table.Append("<table class=\'table table-condensed table-hover\'>");
        table.Append("<thead><td>超市编号</td><td>所在区域</td><td>超市名称</td><td>操作</td></thead>");
        foreach (DataRow row in records.Rows)
        {
            string btn = string.Format("<button id=\'btn_m_{0}\' class=\'btn-sm btn-danger\' type=\'button\'>删除</button>",row[0]);
            table.Append(string.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td></tr>",row[0],row[1],row[2],btn));
        }
        table.Append("</table>");
        return table.ToString();
    }


    private  string BuildZoneTable(DataTable records)
    {

        StringBuilder table = new StringBuilder();
        table.Append("<table class=\'table table-condensed table-hover\'>");
        table.Append("<thead><td>区域编号</td><td>区域名称</td><td>操作</td></thead>");
        foreach (DataRow row in records.Rows)
        {
            string btn = string.Format("<button id=\'btn_z_{0}\' class=\'btn-sm btn-danger\' type=\'button\'>删除</button>",row[0]);
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