<!--#include file="../../config.asp"--> 
<script type="text/javascript" src="/blocks/gallery14/highslide/highslide-with-gallery.js"></script>

<link rel="stylesheet" type="text/css" href="/blocks/gallery14/highslide/highslide.css" />
<script type="text/javascript">
	hs.graphicsDir = '/blocks/gallery9/highslide/graphics/';
	hs.align = 'center';
	hs.transitions = ['expand', 'crossfade'];
	hs.fadeInOut = true;
	hs.outlineType = 'glossy-dark';
	hs.wrapperClassName = 'dark';
	hs.captionEval = 'this.a.title';
	hs.numberPosition = 'caption';
	hs.useBox = true;
	hs.width = 600;
	hs.height = 400;
	//hs.dimmingOpacity = 0.8;
	hs.allowSizeReduction = false;
	// Add the slideshow providing the controlbar and the thumbstrip
	hs.addSlideshow({
		//slideshowGroup: 'group1',
		interval: 5000,
		repeat: false,
		useControls: true,
		fixedControls: 'fit',
		overlayOptions: {
			position: 'bottom center',
			opacity: .75,
			hideOnMouseOut: true
		},
		thumbstrip: {
			position: 'above',
			mode: 'horizontal',
			relativeTo: 'expander'
		}
	});

	// Make all images animate to the one visible thumbnail
	var miniGalleryOptions1 = {
		thumbnailId: 'thumb1'
	}
</script>
<% Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))%>

<div class="highslide-gallery" >
<%
If objRsGallery("galleryfromdatabase") = 1 Then
Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoorder ASC")
	Do While Not objRs.EOF
	imagelink = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\" & objRS("image")
%>
<div class="photoname"><% print objRS("photoname") %>
<a href="<% = Application(ScriptName & "UploadPath") & "/" & objRsGallery("gallerydirectory") & "/" & objRS("image")%>" class="highslide" onclick="return hs.expand(this)">
	<img src="resize.asp?path=<% =imagelink %>&width=120" alt="Highslide JS"
		title="לחץ להגדלת התמונה" />
</a></div>
<div class="highslide-caption">
	<% = objRS("photodesc") %>
</div>

	

	
	<% 	objRs.MoveNext
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
<a href="<% = Application(ScriptName & "UploadPath") & "/" & objRsGallery("gallerydirectory") & "/" & FileName %>" class="highslide" onclick="return hs.expand(this)">
	<img src="resize.asp?path=<% =imagelink %>&width=120" alt="<% = FileName %> "
		title="לחץ להגדלת התמונה" />
</a>
<div class="highslide-caption"></div>
<%  end if 
NEXT 
End If 
%>
</div>
</body>
</html>