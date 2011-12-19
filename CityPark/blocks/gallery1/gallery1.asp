<!--#include file="../../config.asp"-->
<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
If objRsGallery("GalleryCustomFiles") = 1 Then %>
<link rel="stylesheet" type="text/css" href="<% = SiteLayout %>gallery1/css/jquery.lightbox-0.5.css" media="screen" />
<script type="text/javascript" src="<% = SiteLayout %>gallery1/js/jquery.lightbox-0.5.js"></script>
<% Else %>
<link rel="stylesheet" type="text/css" href="/blocks/gallery1/css/jquery.lightbox-0.5.css" media="screen" />
<script type="text/javascript" src="/blocks/gallery1/js/jquery.lightbox-0.5.js"></script>
<% End If %>

<script type="text/javascript">
    $(function() {
        $('#gallery a').lightBox();
    });
    </script>
    
<%

If objRsGallery("galleryfromdatabase") = 1 Then
	Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoID DESC")
	%>
	<div id="gallery">
        <ul>
    <%	Do While Not objRs.EOF %>
        <li><a href="<% = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory") & "\" & objRS("image") %>" title="<% =  objRS("photoname") %>"><img border=0 src="<% = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory") & "\" & objRS("image") %>" alt="<% =  objRS("image") %>" width="150"></a> </li>	 
    <% 	objRs.MoveNext
		Loop %>
		</ul>
    </div>
    <% ELSE 
		
		
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
	<div id="gallery">
        <ul>
		<%	i=0
			FOR EACH thing in MyFolder.Files
			FileName=thing.Name
			imagelink=MyFolder & "\" & FileName
		%>
<li><a href="<% = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory") & "\" & FileName %>"><img border=0 src="<% = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory") & "\" & FileName %>" alt="<% =  FileName %>" width="150"></a> </li>	 
   	<%  
			
			NEXT 
	    %>
</ul>
</div>
<% END IF %>