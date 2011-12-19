<!--#include file="../../config.asp"-->
<% Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
If objRsGallery("GalleryCustomFiles") = 1 Then %>
<link rel="stylesheet" href="<% = SiteLayout %>gallery13/style.css" />
<script type="text/javascript" src="<% = SiteLayout %>gallery13/compressed.js"></script>
<% Else %>
<link rel="stylesheet" href="/blocks/gallery13/style.css" />
<script type="text/javascript" src="/blocks/gallery13/compressed.js"></script>
<% End If %>
<head>
</head>
<ul id="slideshow_gal1">
<% 
If objRsGallery("galleryfromdatabase") = 1 Then
	Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoID DESC")
	'Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & Request.Querystring("galleryID") & " AND SiteID=" & SiteID & " ORDER BY photoID DESC")
	Do While Not objRs.EOF
		imagelink = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\" & objRS("image")
%>
		<li>
			<h3><% = objRS("photoname") %></h3>
			<span><% = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory")  & "\" & objRS("image")%></span>
			<p><% = objRS("photodesc") %></p>
			<a href="#"><img src="resize.asp?path=<% =imagelink %>&width=125" height="75" alt="<% = objRS("imagename")%>" /></a>
		</li>
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

		<li>
			<h3></h3>
			<span><% = Application(ScriptName & "UploadPath") & "\" & objRsGallery("gallerydirectory") & "\" & FileName %></span>
			<p></p>
			<a href="#"><img src="resize.asp?path=<% =imagelink %>&width=65" height="45" alt="<% = FileName %>" /></a>
		</li>
<%  end if 
		NEXT 
End If 
CloseDB(objRsGallery)
	    %>
	</ul>
	<div id="wrapper">
		<div id="fullsize">
			<div id="imgprev" class="imgnav" title="Previous Image"></div>
			<div id="imglink"></div>
			<div id="imgnext" class="imgnav" title="Next Image"></div>
			<div id="image_gal1"></div>
			<div id="information">
				<h3></h3>
				<p></p>
			</div>
		</div>
		<div id="thumbnails">
			<div id="slideleft" title="Slide Left"></div>
			<div id="slidearea">
				<div id="slider_gal1"></div>
			</div>
			<div id="slideright" title="Slide Right"></div>
		</div>
	</div>
<script type="text/javascript">
	$('slideshow_gal1').style.display='none';
	$('wrapper').style.display='block';
	var slideshow_gal1=new TINY.slideshow("slideshow_gal1");
	window.onload=function(){
		slideshow_gal1.auto=true;
		slideshow_gal1.speed=5;
		slideshow_gal1.link="linkhover";
		slideshow_gal1.info="information";
		slideshow_gal1.thumbs="slider_gal1";
		slideshow_gal1.left="slideleft";
		slideshow_gal1.right="slideright";
		slideshow_gal1.scrollSpeed=4;
		slideshow_gal1.spacing=5;
		slideshow_gal1.active="red";
		slideshow_gal1.init("slideshow_gal1","image_gal1","imgprev","imgnext","imglink");
	}
</script>
</body>
</html>