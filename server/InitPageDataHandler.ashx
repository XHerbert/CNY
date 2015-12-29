<%@ WebHandler Language="C#" Class="InitPageDataHandler" %>

using System;
using System.Web;
using System.Text;
using System.Data.SqlClient;
using System.Data;
public class InitPageDataHandler : IHttpHandler,System.Web.SessionState.IRequiresSessionState{

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string isInit = context.Request.Form["isInit"];
        //string ss = context.Session["user"].ToString();
        if (isInit == "true")
        {
            context.Response.Write(BuildPage(1));
        }
        else
        {
            string zone = context.Request.Form["zoneId"];
            int zoneId = zone==null?0:Convert.ToInt32(zone);
            context.Response.Write(BuildPage(zoneId));
        }

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

    private string BuildPage(int zoneId)
    {
        StringBuilder dropListJson = new StringBuilder();

        StringBuilder html_zone = new StringBuilder();
        StringBuilder html_CNY = new StringBuilder();
        StringBuilder html_date = new StringBuilder();

        html_zone.Append("\"<span>区域选择</span>");
        html_zone.Append("<select  onChange=\'changeSelect()\' id=\'un\' class=\'btn-block form-control\' size=1>");
        html_zone.Append(GetZoneList());//从数据库取数据循环添加
        html_zone.Append("</select>\"");

        html_CNY.Append("\"<span>超市选择</span>");
        html_CNY.Append("<select id=\'mar\'   onChange=\'dateSelect()\'  class=\'btn-block form-control\' size=1>");
        html_CNY.Append(GetMarketList(zoneId));
        html_CNY.Append("</select>\"");

        dropListJson.Append("{\"html\":[");
        dropListJson.Append("{\"zone\":");
        dropListJson.Append(html_zone);
        dropListJson.Append(",\"CNY\":");
        dropListJson.Append(html_CNY);
        dropListJson.Append("}]}");

        return dropListJson.ToString();
    }

    private string GetZoneList()
    {
        StringBuilder zoneBuilder = new StringBuilder();
        SqlParameter para = new SqlParameter("@type",System.Data.SqlDbType.Int);
        para.Value = -1;
        DataTable dt= SQL.ExcuteProcedureQuery("sp_GetList", para);
        if (dt == null)
        {
            zoneBuilder.Append("<option value=\'nullable\'>暂无数据</option>");
        }
        else
        {
            foreach (DataRow item in dt.Rows)
            {
                zoneBuilder.Append(string.Format("<option value=\'{0}\'>{1}</option>",item[0].ToString(),item[1].ToString()));
            }
        }

        return zoneBuilder.ToString();
    }

    private string GetMarketList(int zoneId)
    {
        StringBuilder marketBuilder = new StringBuilder();
        SqlParameter para = new SqlParameter("@type",System.Data.SqlDbType.Int);
        para.Value = zoneId;
        DataTable dt= SQL.ExcuteProcedureQuery("sp_GetList", para);
        if (dt == null)
        {
            marketBuilder.Append("<option value=\'nullable\'>暂无数据</option>");
        }
        else
        {
            foreach (DataRow item in dt.Rows)
            {
                marketBuilder.Append(string.Format("<option value=\'{0}\'>{1}</option>",item[0].ToString(),item[1].ToString()));
            }
        }

        return marketBuilder.ToString();
    }
}