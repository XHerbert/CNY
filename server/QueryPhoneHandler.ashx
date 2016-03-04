<%@ WebHandler Language="C#" Class="QueryPhoneHandler" %>

using System;
using System.Web;

public class QueryPhoneHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
        string uid = context.Request.Form["uid"];
        int id = Convert.ToInt32(uid);
        bool b=SQL.IsInputPhone(id);
        if (b)
        {
            context.Response.Write("none");
        }
        else
        {
            context.Response.Write("block");
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}