<!--#include file="../../config.asp"-->



<% Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
If objRsGallery("GalleryCustomFiles") = 1 Then %>
<link rel="stylesheet" href="<% = SiteLayout %>gallery4/css/jqFancyTransitions.css" type="text/css" />
<% Else %>
<link rel="stylesheet" href="/css/jqFancyTransitions.css" type="text/css" />
<script type="text/javascript" src="blocks/gallery4/js/jqFancyTransitions.js"></script>
<% End If %>


<div id="ftHolder">
	<div id="ft">
		

<% 
If objRsGallery("galleryfromdatabase") = 1 Then
Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoorder ASC")
eee = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory") & "\" & objRS("image")
ddd = objRS("photodesc") 
i=1
	Do While Not objRs.EOF
	%>
<img src="<% = objRS("image")%>" alt="<% = objRS("photodesc") %>" />
<% 	objRs.MoveNext
	i=i+1
		Loop
	objRs.close 
Else
Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\")
Set d=Server.CreateObject("Scripting.Dictionary")
Path = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\photo_info.txt"
	If MyFileObject.FileExists(Path) Then
		PhotoInfoFile = MyFileObject.GetFile(Path).OpenAsTextStream(1,0).ReadAll() 
	End If		
			FOR EACH thing in MyFolder.Files
			FileName=thing.Name
			imagelink=MyFolder & "\" & FileName
			NEXT %>

			<%	i=1
			FOR EACH thing in MyFolder.Files
			FileName=thing.Name
			imagelink=MyFolder & "\" & FileName
			%>
<img src="<% = Application(ScriptName & "UploadPath") & "/" & objRsGallery("gallerydirectory") & "/" & FileName %>" 
   alt="<% = PictureDescription %>" />
		  	   	<%  
			
				i=i+1
				NEXT 
			 %>
	

<% End If%>
</div>

<script>

	$('#ft').jqFancyTransitions({ 'navigation' : true, 'links' : true });

</script>


</div>

