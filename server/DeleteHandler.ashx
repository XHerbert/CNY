<%@ WebHandler Language="C#" Class="DeleteHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
public class DeleteHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string delID = context.Request.Form["id"];
        string type = context.Request.Form["type"];
        int i = 0;
        if (string.IsNullOrEmpty(delID)||string.IsNullOrEmpty(type)) return;
        if (type == "market")
        {
            SqlParameter para = new SqlParameter("@mid",System.Data.SqlDbType.Int);
            para.Value = delID;
            i=SQL.ExcuteProcedureNonquery("sp_DeleteMarket", "", para);
        }
        else if (type == "cx")
        {
            SqlParameter para = new SqlParameter("@id", System.Data.SqlDbType.Int);
            para.Value = delID;
            i = SQL.ExcuteProcedureNonquery("sp_DeleteSendnameRecord", "", para);
        }
        else
        {
            SqlParameter para = new SqlParameter("@zid",System.Data.SqlDbType.Int);
            para.Value = delID;
            i=SQL.ExcuteProcedureNonquery("sp_DeleteZone", "@state", para);
        }
        if (i > 0)
        {
            context.Response.Write("success");
        }else if (i == -8)
        {
            context.Response.Write("该区域下有超市，不能删除！");
        }
        else
        {
            context.Response.Write("未知错误！");
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}