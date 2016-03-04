<%@ WebHandler Language="C#" Class="LoginHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;

public class LoginHandler : IHttpHandler,System.Web.SessionState.IRequiresSessionState  {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string u = context.Request.Form["username"];
        string p = context.Request.Form["password"];

        if (string.IsNullOrEmpty(u) || string.IsNullOrEmpty(p))
        {
            context.Response.Write( "请输入员工号和密码！");
        }
        else
        {
            ////SqlParameter[] paras = {
            ////    new SqlParameter("@username",System.Data.SqlDbType.NVarChar),
            ////    new SqlParameter("@pass",System.Data.SqlDbType.NVarChar)
            ////   // new SqlParameter("@state",System.Data.SqlDbType.Int)
            ////};
            ////paras[0].Value = u;
            ////paras[1].Value = p;
            //paras[2].Value = 0;
            //int i=SQL.ExcuteProcedureNonquery("sp_UserPass","@state",paras);
            int i = SQL.Login(u, p);
            if (i > 0)
            {
                context.Session["user"] = SQL.GetIDs(u);
                context.Response.Write(SQL.GetIDs(u));
            }
            else
            {
                context.Response.Write("FAIL");
            }

        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}