<%@ WebHandler Language="C#" Class="GetNameByIDHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
public class GetNameByIDHandler : IHttpHandler ,System.Web.SessionState.IRequiresSessionState{

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string name = context.Session["user"].ToString();
        string type = context.Request.Form["type"];
        SqlParameter[] paras = {
            new SqlParameter("@uname",System.Data.SqlDbType.NVarChar),
            new SqlParameter("@type",System.Data.SqlDbType.Int)
        };
        paras[0].Value = name;
        paras[1].Value = 1;
        int id = SQL.ExcuteProcedureScalar("sp_GetIdsByName", paras);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}