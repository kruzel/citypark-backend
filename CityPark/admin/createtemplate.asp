<!--#include file="../config.asp"-->

<html>
<head>
	
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<style type="text/css">
	body
	{
		font-family: Arial;
		direction: rtl;
	}
</style>
</head>
<body>

<%
Function RemoveBOM(filePath)
        
	Set writer = CreateObject("Adodb.Stream")
    Set reader = CreateObject("Adodb.Stream")
    
    reader.Open
    reader.CharSet = "UTF-8"
              
    reader.LoadFromFile filePath
        
    writer.Type = 1
    writer.Mode = 3
    writer.Open
    reader.Position = 5 
    reader.CopyTo writer, -1 

    writer.SaveToFile filePath, 2
    
    RemoveBOM = filePath

    Set writer = Nothing 
    Set reader = Nothing

End Function 

If Request.QueryString("m") = "submit" Then
	Set fs = CreateObject("Scripting.FileSystemObject")
	
	If fs.FileExists(Server.MapPath(TemplateLocation & Request.Form("fileName"))) Then
		Response.Redirect("createtemplate.asp?m=error_exists&fileName=" & Request.Form("fileName"))
	Else
 		Set objStream = server.CreateObject("ADODB.Stream")
     
	    objStream.Open
	    objStream.CharSet = "UTF-8"
     
	    objStream.WriteText Request.Form("fileText") 
     
     	objStream.SaveToFile Server.MapPath(TemplateLocation & Request.Form("fileName")), 2
	    objStream.Close
    	
    	RemoveBOM(Server.MapPath(TemplateLocation & Request.Form("fileName")))
	End If
	
	Set fs = Nothing
	%>
	<script type="text/javascript">
		window.opener.document.getElementById('xFileName').value = '<% = Request.Form("fileName") %>';
		window.close();
	</script>
	<%
Else
%>
<script type="text/javascript" src="/js/edit_area/edit_area_full.js"></script>
<script type="text/javascript" type="text/javascript">
	editAreaLoader.init({
		id: "fileText"	// id of the textarea to transform		
		, start_highlight: true	// if start with highlight
		, allow_resize: "both"
		, allow_toggle: true
		, word_wrap: true
		, language: "en"
		, syntax: "html"
	});
</script>
		
<form action="createtemplate.asp?m=submit" method="post">
		שם הקובץ: <input type="text" name="fileName" 
            value="<% If Request.QueryString("fileName") = "" Then %>.html<% else %><%=Request.QueryString("fileName")%><%end if %>" 
            style="direction:ltr;margin-bottom: 20px;margin-top:5px; width: 300px;" /><% If request.querystring("m") = "error_exists" Then %> <span style="color:red;text-weigth:bold;">
		קובץ בשם הזה כבר קיים</span><% End If %>

	<textarea id="fileText" name="fileText" style="height: 400px; width: 100%;direction:ltr;">

	</textarea>
	<input type="submit" value="אישור"  style="float: left;"/>
</form>
<% End If %>

</body>	
</html>