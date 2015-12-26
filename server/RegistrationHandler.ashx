<%@ WebHandler Language="C#" Class="RegistrationHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
public class RegistrationHandler : IHttpHandler , System.Web.SessionState.IRequiresSessionState{

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string username = context.Request.Form["users"];
        string pwd = context.Request.Form["pwd1"];
        SqlParameter[] paras = {
            new SqlParameter("@username",System.Data.SqlDbType.NVarChar),
            new SqlParameter("@pwd",System.Data.SqlDbType.NVarChar)

        };
        paras[0].Value = username;
        paras[1].Value = pwd;

        //string ss = context.Session["user"].ToString();

        int m=SQL.ExcuteProcedureNonquery("sp_Register","@isExist",paras);
        context.Response.Write(m);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }


}