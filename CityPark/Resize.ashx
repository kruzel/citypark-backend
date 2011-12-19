<%@ WebHandler Language="C#" Class="Resize" %>

using System;
using System.Web;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

public class Resize : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        var orginalFile = context.Server.MapPath(context.Request.QueryString["path"]);
	
		var width = int.Parse(context.Request.QueryString["width"]);
    
        var maxHeight =
            String.IsNullOrEmpty(context.Request.QueryString["maxHeight"])
            ? 0 : int.Parse(context.Request.QueryString["maxHeight"]);
        
        var onlyResizeIfWider =
            String.IsNullOrEmpty(context.Request.QueryString["onlyResizeIfWider"])
            ? false : bool.Parse(context.Request.QueryString["onlyResizeIfWider"]);

        var image = Image.FromFile(orginalFile);
        ImageFormat format = null;

        switch (Path.GetExtension(orginalFile).ToLower())
        {
            case ".jpg":
                format = ImageFormat.Jpeg;
                context.Response.ContentType = "image/jpeg";               
                break;
				
              case ".jpeg":
                format = ImageFormat.Jpeg;
                context.Response.ContentType = "image/jpeg";               
                break;
				
            case ".png":
                format = ImageFormat.Png;
                context.Response.ContentType = "image/png";
                break;
                
            case ".gif":
                format = ImageFormat.Gif;
                context.Response.ContentType = "image/gif";
                
                break;
        }
        
        image.RotateFlip(RotateFlipType.Rotate180FlipNone);
        image.RotateFlip(RotateFlipType.Rotate180FlipNone);

        if (onlyResizeIfWider)
        {
            if (image.Width <= width)
                width = image.Width;
        }

        int height = image.Height * width / image.Width;

        if (height > maxHeight && maxHeight > 0)
        {
            width = image.Width * maxHeight / image.Height;
            height = maxHeight;
        }
   
        using (var newImage = image.GetThumbnailImage(width, height, null, IntPtr.Zero))
        {
            newImage.Save(context.Response.OutputStream, format);
        }        
    }
 
    public bool IsReusable 
    {
        get 
        {
            return false;
        }
    }
}