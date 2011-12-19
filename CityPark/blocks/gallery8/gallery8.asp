<!--#include file="../../config.asp"-->
<head>
<link rel="stylesheet" href='/blocks/gallery8/gallery8.css' type="text/css" media="screen, projection" />
</head>
<div class="gallerycontainer">
<table width="250" align="left">
	<tr>
		<td>		

<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
If objRsGallery("galleryfromdatabase") = 1 Then

Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoorder ASC")
%>

<%	i=0

	Do While Not objRs.EOF
	imagelink = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\" & objRS("image")
	If i mod 2=0 Then response.write  "<tr>" & "</tr>"
%>
<td>
<a class="thumbnail" href="#thumb"><img src="resize.asp?path=<% =imagelink %>&width=100" width="100px" height="66px" border="0" /><span><img src="<% = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory") & "\" & objRS("image")%>" /><br /><% = objRS("photodesc") %></span></a>
</td>
<%
 	objRs.MoveNext
 		i=i+1

		Loop
objRs.close
%>
<% End if	%>
</td></tr></table>

</div>
