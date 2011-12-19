<!--#include file="../../config.asp"-->
<head>

<link rel="stylesheet" href='/blocks/gallery7/css/hoverbox.css' type="text/css" media="screen, projection" />
<!--[if lte IE 7]>
<link rel="stylesheet" href='/blocks/gallery7/css/ie_fixes.css' type="text/css" media="screen, projection" />
<![endif]-->

</head>

<ul class="hoverbox">

<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
If objRsGallery("galleryfromdatabase") = 1 Then

Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoorder ASC")
%>

<%	i=0
	Do While Not objRs.EOF
	imagelink = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\" & objRS("image")
%>

<li>
<a href="#"><img src="resize.asp?path=<% =imagelink %>&width=200" alt="<% = objRS("photodesc") %>" title="<% = objRS("photodesc") %>" width="200" height="150" /><img src="resize.asp?path=<% =imagelink %>&width=300" alt="<% = objRS("photodesc") %>" class="preview" width="300" height="200" /></a>
</li>
<%
 	objRs.MoveNext
	i=i+1
		Loop
objRs.close
%>

<% Else	
Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\")
Set d=Server.CreateObject("Scripting.Dictionary")

Path = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\photo_info.txt"

If MyFileObject.FileExists(Path) Then
PhotoInfoFile = MyFileObject.GetFile(Path).OpenAsTextStream(1,0).ReadAll() 
End If		
				
	SplittedInfoFile = Split(PhotoInfoFile, vbCrLf)

For Each f In SplittedInfoFile 
Splitted2 = Split(f, ",")
					
PictureName = Splitted2(0)
PictureDescription = Splitted2(1)
					
d.Add PictureName , PictureDescription 
	Next
%>
<%	i=0
FOR EACH thing in MyFolder.Files
FileName=thing.Name
imagelink=MyFolder & "\" & FileName
If MyFileObject.GetExtensionName(imagelink) <> "txt" Then
%>
<li>
<a href="#"><img src="resize.asp?path=<% =imagelink %>&width=200" alt="<% = FileName %>" title="<% = FileName %>" width="200" height="150" /><img src="resize.asp?path=<% =imagelink %>&width=300" alt="<% = FileName %>" class="preview" width="300" height="200" /></a>
</li>
<%  
	end if 
	NEXT 
End If 
%>
</ul>
