<!--#include file="config.asp"-->
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/validate.asp" ></script>

<script type="text/javascript" src="/js/ajax.js"></script>

  

<%
Set fso = Server.CreateObject("Scripting.FileSystemObject")

If Request.QueryString("upload") = "true" Then
'	Set Upload = CreateObject("Persits.Upload")
'	Upload.OverwriteFiles = False'
'	print Server.MapPath(SiteFiles & "content/" & Request.QueryString("folder"))
'	Upload.Save(Server.MapPath(SiteFiles & "content/" & Request.QueryString("folder")))
	
	T = Request.QueryString("typeAllowed")

		Path = Request.QueryString("kk")
		Extension = Mid(path, len(Path) - 2)

	    If (T = "image" And Not (Extension = "jpg" Or Extension = "png" Or Extension = "gif" Or Extension = "jpeg" Or Extension = "ico")) _
	        Or (T = "file" And Not (Extension = "doc" Or Extension = "docx" Or Extension = "xls" Or Extension = "xlsx" Or Extension = "pdf" Or Extension = "ppt" Or Extension = "pptx" Or Extension = "txt")) _
	            Or (T <> "image" And T <> "file") Then
	        
	        Print  " לא חוקי."	 + Extension + "   הקובץ בעל סיומת  "
			cont = false
			
	        fso.DeleteFile(Server.MapPAth(Path))
		Else
	
		%>
		<script type="text/javascript">
			opener.SetFile('<% = Request.QueryString("object") %>', '<% = Path %>', '<% = Extension %>' );
			window.close();
		</script>
	<%
	End If
else
%>

<html>
	<head>
	
	</head>
	
	<body>
		<form id="myform"  action="Upload.ashx?sitename=&return=upload.asp?upload=true" method="post" enctype="multipart/form-data">
            <input type="hidden" name="sitename" value="<% = GetConfig("SiteName") %>"/>
			<input type="hidden" name="return" value="<% = Server.urlencode("upload.asp?upload=true&object=" & Request.QueryString("object") & "&typeAllowed=" & Request.QueryString("typeAllowed")  & "&folder=" & Request.QueryString("Folder") & "&type=" & Request.QueryString("Type")) %>"/>
			<input type="file" id="field" name="myFile" class="required"  />
			<input type="submit" value="Upload" />
		</form>
	</body>
</html>

<% end if %>