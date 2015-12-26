<%@ WebHandler Language="C#" Class="ShowChancesHandler" %>

using System;
using System.Web;

public class ShowChancesHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
        string d_s = context.Request.Form["date-s"];
        string m_s = context.Request.Form["mar-s"];
        if (string.IsNullOrEmpty(d_s) || string.IsNullOrEmpty(m_s)) return;
        int all;
        int ocupiedChance=SQL.QueryChances(out all, Convert.ToInt32(m_s), d_s);
        int useful = all - ocupiedChance;

        string result = useful.ToString() + "###" + all.ToString();
        context.Response.Write(result);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}