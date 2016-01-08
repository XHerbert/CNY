<%@ WebHandler Language="C#" Class="InitPageDataHandler" %>

using System;
using System.Web;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
public class InitPageDataHandler : IHttpHandler,System.Web.SessionState.IRequiresSessionState{

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string isInit = context.Request.Form["isInit"];
        //string ss = context.Session["user"].ToString();
        if (isInit == "true")
        {
            context.Response.Write(BuildPage(1,5));
        }
        else
        {
            string zone = context.Request.Form["zoneId"];
            string mid = context.Request.Form["MId"];
            int zoneId = zone==null?0:Convert.ToInt32(zone);
            int mID = mid == null ? 0 : Convert.ToInt32(mid);
            context.Response.Write(BuildPage(zoneId,mID));
        }

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

    private string BuildPage(int zoneId,int mid)
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

        html_date.Append("\"<span>日期选择</span>");
        html_date.Append("<select id=\'pw\'   onChange=\'dateSelect()\'  class=\'btn-block form-control  date form_date\' data-date-format=\'yyyy-mm-dd\'>");
        html_date.Append(GetDateList(zoneId,mid));
        html_date.Append("</select>\"");


        dropListJson.Append("{\"html\":[");
        dropListJson.Append("{\"zone\":");
        dropListJson.Append(html_zone);
        dropListJson.Append(",\"CNY\":");
        dropListJson.Append(html_CNY);
        dropListJson.Append(",\"date\":");
        dropListJson.Append(html_date);
        dropListJson.Append("}]}");

        return dropListJson.ToString();
    }

    private string GetZoneList()
    {
        StringBuilder zoneBuilder = new StringBuilder();
        SqlParameter para = new SqlParameter("@type",System.Data.SqlDbType.Int);
        para.Value = -1;
        DataTable dt= SQL.ExcuteProcedureQuery("sp_GetList", para);
        if (dt == null || dt.Rows.Count==0)
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
        if (dt == null || dt.Rows.Count==0)
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

    private string GetDateList(int zoneId,int Mid)
    {
        StringBuilder leftDateBuilder = new StringBuilder();
        SqlParameter[] paras =
        {
            new SqlParameter("@zid",System.Data.SqlDbType.Int),
            new SqlParameter("@mid",System.Data.SqlDbType.Int)
        };
        paras[0].Value = zoneId;
        paras[1].Value = Mid;
        DataTable dt= SQL.ExcuteProcedureQuery("LeftDate", paras);
        if (dt == null || dt.Rows.Count==0)
        {
            leftDateBuilder.Append("<option value=\'nullable\'>暂无数据</option>");
        }
        else
        {
            foreach (DataRow item in dt.Rows)
            {
               string dateValue = item[0].ToString().Replace("/","-").ToString().Split(' ')[0];
               //string dateValue = String.Format("yyyy-MM-dd",item[0].ToString());
                //dateValue=DateTime.ParseExact(dateValue, "yyyy-MM-dd", null).ToString("yyyy-M-d");//本地可用
                string dateText = dateValue;
                leftDateBuilder.Append(string.Format("<option value=\'{0}\'>{1}</option>",dateValue,dateValue));
            }
        }

        return leftDateBuilder.ToString();
    }
}