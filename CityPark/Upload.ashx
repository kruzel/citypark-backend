<%@ WebHandler Language="C#" Class="Upload" %>

using System;
using System.Web;
using System.IO;
using System.Text;

public class Upload : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {

        var file = context.Request.Files["MyFile"];

        var path = Path.Combine(String.Format("/Sites/{0}/Content/File/", context.Request.Form["sitename"]), String.Format("{0}{1}", Guid.NewGuid().ToString(), Path.GetExtension(file.FileName)));
	
        file.SaveAs(
            context.Server.MapPath(path)
        );


        context.Response.Redirect(context.Server.UrlDecode(context.Request.Form["return"]) + "&kk=" + path);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}