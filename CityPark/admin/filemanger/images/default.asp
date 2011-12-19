<!--#include file="../config.asp"-->

<script type="text/javascript" src="../js/prototype.js"></script>
<script type="text/javascript" src="../js/scriptaculous.js?load=effects"></script>
<script type="text/javascript" src="../js/lightbox.js"></script>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1255">
<link rel="stylesheet" href="../css/lightbox.css" type="text/css" media="screen" />

<style type="text/css">
ul { list-style-image: url("images/folder.png") }
</style>
</head>

<%
AllowedFolders = "images,flash,file,media"
AllowedFolders = Split(AllowedFolders, ",")

%>
<% PrinterFriendly = "yes" %>


<% 

If Request.QueryString("m") = "upload" Then
Set Upload = Server.CreateObject("Persits.Upload")
Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & Replace(Request.QueryString("subfolder"), "/", "\"))
Set fold=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\Content")

If fold.size > 1048576 * 50 Then
%>
<script type="text/javascript">
	alert("עברת את גודל הסיפרייה המוקצה, ניתן למחוק קבצים כדי לפנות מקום או פנה לתמיכה להוספת נפח.");
	document.location.href='?subfolder=<% = Request.QueryString("subfolder") %>&object=<% = Request.QueryString("object") %>'
</script>
<%
Response.End
Response.Redirect "?subfolder=" & Request.QueryString("subfolder") & "&object=" & Request.QueryString("object")
End If


Upload.OverwriteFiles = False

Path = MyFolder
Count = Upload.Save(Path)

If Count = 0 Then
  Response.Write "No images selected."
  Response.End
Else
  Set File = Upload.Files(1)
 
  ' Is this a valid image file?
  If File.ImageType <> "UNKNOWN" Then

    ' Create instance of AspJpeg object
    Set jpeg = Server.CreateObject("Persits.Jpeg")

    ' Open uploaded file
	    jpeg.Open( File.Path )

    ' Resize image according to "scale" option.
    ' We cannot use Request.Form, so we use Upload.Form instead.
   	
   	If jpeg.OriginalWidth > 400 Then
	   	X = jpeg.OriginalWidth / 400

		jpeg.Width = jpeg.OriginalWidth / X
		jpeg.Height = jpeg.OriginalHeight / X
	End If
   	
'	jpeg.Width = jpeg.OriginalWidth * Upload.Form("scale") / 100
 '   jpeg.Height = jpeg.OriginalHeight * Upload.Form("scale") / 100
	
	SavePath = Path & "\" & File.ExtractFileName

'	Do While NOT Upload.FileExists(SavePath) = False
'																					
'		SavePath = Path & File.ExtractFileName & I
'		I = I + 1
'						
'	Loop		
	
				
    ' AspJpeg always generates thumbnails in JPEG format.
    ' If the original file was not a JPEG, append .JPG ext.
    If UCase(Right(SavePath, 3)) <> "JPG" Then
      SavePath = SavePath & ".jpg"
    End If

    jpeg.Save SavePath
	'Upload.DeleteFile Path
    Response.Write "Success!"
  Else
    Response.Write "This is not a valid image."
    Response.End
  End If
End If

'Set MyFile=MyFileObject.GetFile(phisicalpath &  Application(ScriptName & "ScriptPath") & Replace(Request.QueryString("subfolder"), "/", "\") & "\" & File.ExtractFileName)
'MyFile.Delete
Response.Redirect Upload.Form("BACKURL")

ElseIf Request.QueryString("m") = "delete" Then
	response.write("aa")
	Set Upload = Server.CreateObject("Persits.Upload")
	Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
		Set Path=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & Replace(Request.QueryString("subfolder"), "/", "\"))
	
	response.write(Path & "\" & Request.Querystring("Filename"))
	Upload.DeleteFile(Path & "\" & Request.Querystring("Filename"))
	
	Response.Redirect "default.asp?object=" & Request.QueryString("object") & "&subfolder=" & Request.QueryString("subfolder")

End IF

MainFolderPath = Server.MapPath("\") & "/" & Application(ScriptName & "ScriptPath")
RequestedFolderPath = MainFolderPath & Request.QueryString("subfolder")

Function GetURL(FileName)
	Splitted = Split(FileName, ".")
	
	If lcase(splitted(1)) = "jpg" Then
		GetURL = "	/app/resize.asp?path=" & Server.MapPath("../../" & Application(ScriptName & "ScriptPath") & Request.QueryString("subfolder") & "/" & f2.name) & "&width=100&height=100" 
	Else
		GetURL = "../../" & Application(ScriptName & "ScriptPath") & Request.QueryString("subfolder") & "/" & f2.name
	End If
	
End Function

Set fs = CreateObject("Scripting.FileSystemObject") 

Set MainFolderF = fs.GetFolder(RequestedFolderPath) 
Set MainFolder = MainFolderF.SubFolders
			
Set Files = MainFolderF.Files
%>

<script language="javascript">
	function ChangeBorderColor(objectName)
	{
		if (document.getElementById(objectName).style.borderColor == "red")
			document.getElementById(objectName).style.borderColor = "black";
		else
			document.getElementById(objectName).style.borderColor = "red";
	}
	
	function SetInfo(Size, Type)
	{
		document.getElementById("Info").innerHTML = "Size: " + Size + "<BR>Type: " + Type;
	}
	
	function SetImagePath(objectName, v)
	{
		window.opener.document.getElementById('<% = Request.QueryString("object") %>').value= "../"+v; 
		window.close();
	}
</script>

<table align="center" width="450" bgcolor=#FFFFFF>
	<tr>

		<td colspan="2">
			<div id="MyDiv">
				<span id="Info">Click on an item to see it info.</span>
			</div>
			<FORM ENCTYPE="multipart/form-data" ACTION="default.asp?m=upload&subfolder=<% = Request.QueryString("subfolder") %>&object=<% = Request.QueryString("object") %>" METHOD="POST">
 			  <INPUT TYPE="FILE" NAME="FILE1">
			  <INPUT TYPE="SUBMIT" VALUE="Upload!">
			   <INPUT TYPE="HIDDEN" name="BACKURL" VALUE="?<% = Request.QueryString %>">
			</FORM>

		</td>
	</tr>
	
	<tr>
		<td valign="top">
<%
Set fs = CreateObject("Scripting.FileSystemObject")
a = fs.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "/Content/")

LFOlder(a)

    function ConvertBytes(ByRef anBytes)
    	Dim lnSize			' File Size To be returned
    	Dim lsType			' Type of measurement (Bytes, KB, MB, GB, TB)
    	
    	Const lnBYTE = 1
    	Const lnKILO = 1024						' 2^10
    	Const lnMEGA = 1048576					' 2^20
    	Const lnGIGA = 1073741824				' 2^30
    	Const lnTERA = 1099511627776			' 2^40
    	'	Const lnPETA = 1.12589990684262E+15		' 2^50
    	'	Const lnEXA = 1.15292150460685E+18		' 2^60
    	'	Const lnZETTA = 1.18059162071741E+21	' 2^70
    	'	Const lnYOTTA = 1.20892581961463E+24	' 2^80
    	
    	if anBytes = "" Or Not IsNumeric(anBytes) Then Exit function
    	
    	if anBytes < 0 Then Exit function	
    '	If anBytes < lnKILO Then
    '		' ByteConversion
    '		lnSize = anBytes
    '		lsType = "bytes"
    '	Else		
    		if anBytes < lnMEGA Then
    			' KiloByte Conversion
    			lnSize = (anBytes / lnKILO)
    			lsType = "KB"
    		ElseIf anBytes < lnGIGA Then
    			' MegaByte Conversion
    			lnSize = (anBytes / lnMEGA)
    			lsType = "<small>MB</small>"
    		ElseIf anBytes < lnTERA Then
    			' GigaByte Conversion
    			lnSize = (anBytes / lnGIGA)
    			lsType = "GB"
    		Else
    			' TeraByte Conversion
    			lnSize = (anBytes / lnTERA)
    			lsType = "TB"
    		End if
    '	End If
    	' Remove fraction
    	'lnSize = CLng(lnSize)
    	lnSize = FormatNumber(lnSize, 2, True, False, True)
    	
    	' Return the results
    	ConvertBytes = lnSize & "<small>" & lsType & "</small>"
    End function



Sub LFolder(MainPath)

	
	Set FOLDER = fs.GetFolder(MainPath)
	FF = MainPath & "/" & FolderName
	FolderName = Folder.Name
	Allow = False
	For Each AlloewdFolder In AllowedFolders 
		If LCase(FolderName) = Lcase(AlloewdFolder) Then
			Allow=True
			Exit For
		End If
	Next
	IF Allow = False then
		Pa = Split(Replace(MainPath,"\","/") , "/")
		I = 0
		For Each P In Pa
			If LCASE(P) = LCASE(FolderName) Then
				If (NOT LCASE(Pa(I-1)) = "content") Then
					
					'Response.Write(P & "/")
					Allow = True
				End IF
			End If
			I= I +1
		Next
	End IF
	If Allow = True Then
	Response.Write("<li>" & FolderName & " <small>" & ConvertBytes(Folder.Size) & "</small><BR>")
	Response.Write("<ul>" & vbCrLf)

	If Folder.SubFolders.Count > 0 Then
	For Each SubFolder In Folder.SubFolders
		
		PP = Replace(MainPath, "\", "/")
		X = 0
		For I = 1 To 1000
			If LCASE(Mid(PP, I, 8)) = "/content" Then
				X = I
				exit for	
			End If
		Next
		
		Link = Mid(PP,X) & "/" & SubFolder.Name

			Response.Write("<a href=""default.asp?object=" & Request.QueryString("object") & "&subfolder=" & Link & """>")
			LFolder(SubFolder.Path)
			response.write("</a>")
		next
	End If
	Response.Write("</ul>" & vbCrLf)
	Response.Write("</li>" & vbCrLf)
end if

End Sub
%>
		</td>
		
		<td>
			<table align=center>
				<tr>
					<% 
					For Each f2 in Files 
						If I =3 Then
						I=0
						%>
						</tr><tr>
						<%
						End If
					%>
						  <td>
					<div align="center">
					<table height="150" name="ta<% = Replace(f2.name, ".", "") %>" id="ta<% = Replace(f2.name, ".", "") %>" onmouseout="javascript:ChangeBorderColor(this.id);" onmouseover="javascript:ChangeBorderColor(this.id);" border="2" bordercolor="#000000" width="100" cellspacing="5">
						<tr>
							<td colspan="3" align="center">
								<%
								sf = Split(f2.name, ".")
								 
								Select Case lcase(sf(1))
								
									Case "jpg"
										B = a
										B = B & Replace(Replace(Request.QueryString("subfolder") , "\Content", ""), "/Content", "")
										B = B & "\" & f2.name 
										B = Replace(B, "/", "\")
										%>
											<img border="1" alt="<% = f2.name & "-"&ConvertBytes(f2.size)%>" name="<% = Replace(f2.name, ".", "") %>" id="<% = Replace(f2.name, ".", "") %>" src="../resize.asp?path=<% = B %>&width=100"  width="100" <% If Request.QueryString("object") <> "" Then %> onclick="SetImagePath('<% = Request.QueryString("object") %>','<% = Application(ScriptName & "ScriptPath") & Request.QueryString("subfolder") & "/" & f2.name %>')"<% End If %> ></td>
									<% Case "gif" %>
											<img border="1" alt="<% = f2.name & "-"&ConvertBytes(f2.size)%>" name="<% = Replace(f2.name, ".", "") %>" id="<% = Replace(f2.name, ".", "") %>" src="<% = GetURL(f2.name) %>" <% If Request.QueryString("object") <> "" Then %> width="100" onclick="SetImagePath('<% = Request.QueryString("object") %>','<% = Application(ScriptName & "ScriptPath") & Request.QueryString("subfolder") & "/" & f2.name %>')"<% End If %>  ></td>
									
									<% Case Else %>
											<img border="1" alt="<% = f2.name & "-"&ConvertBytes(f2.size)%>" name="<% = Replace(f2.name, ".", "") %>" id="<% = Replace(f2.name, ".", "") %>" src="images/icons/<% = sf(1)%>.gif" <% If Request.QueryString("object") <> "" Then %> width="100" onclick="SetImagePath('<% = Request.QueryString("object") %>','<% = Application(ScriptName & "ScriptPath") & Request.QueryString("subfolder") & "/" & f2.name %>')"<% End If %> ></td>
								
								<% End Select %>
					
						</tr>
												<tr>
							<td width="33"><a onclick = "if (! confirm('?למחוק')) { return false; }" href="default.asp?<% = Request.QueryString %>&m=delete&filename=<% = f2.name %>">מחיקה</a></td>
							<td width="33"><span  onclick="javascript:SetInfo(<% = f2.Size %>,'<% = f2.Type %>')">מידע</span></td>
						</tr>
					</table>	  
					</div>
					<% 
					I = I + 1
					Next %>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--#include file="../inc_bottom.asp"-->