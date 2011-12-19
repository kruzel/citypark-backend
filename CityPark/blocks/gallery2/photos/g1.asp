<!--#include file="../../config.asp"-->

<head>
<link rel="stylesheet" href="/blocks/gallery2/style.css" />


		<%  	
			Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
				Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & Request.QueryString("f") & "\")
			Set d=Server.CreateObject("Scripting.Dictionary")

				Path = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & Request.QueryString("f") & "\photo_info.txt"

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


	</head>


	<ul id="slideshow">
			<%	i=0
			FOR EACH thing in MyFolder.Files
			FileName=thing.Name
			imagelink=MyFolder & "\" & FileName
			 If MyFileObject.GetExtensionName(imagelink) <> "txt" Then
  	 			If i mod 4=0 Then response.write  "<tr>" & "</tr>"  Else
		%>

		<li>
			<h3><% = FileName %></h3>
			<span><% = Application(ScriptName & "UploadPath") & "\" & Request.QueryString("f") & "\" & FileName %></span>
			<p><% = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & Request.QueryString("f") & "\" & FileName %></p>
			<a href="#">
			<img src="resize.asp?path=<% =imagelink %>&width=120" alt="<% = FileName %>" /></a>
		</li>
		  	   	<%  
			i=i+1
			
			end if 
			NEXT 
	    %>

	</ul>
	<div id="wrapper1">
		<div id="fullsize">
			<div id="imgprev" class="imgnav" title="Previous Image"></div>
			<div id="imglink"></div>
			<div id="imgnext" class="imgnav" title="Next Image"></div>
			<div id="image"></div>
			<div id="information">
				<h3></h3>
				<p></p>
			</div>
		</div>
		<div id="thumbnails1">
			<div id="slideleft" title="Slide Left"></div>
			<div id="slidearea">
				<div id="slider"></div>
			</div>
			<div id="slideright" title="Slide Right"></div>
		</div>
	</div>
<script type="text/javascript" src="/blocks/gallery2/compressed.js"></script>
<script type="text/javascript">
	$('slideshow').style.display='none';
	$('wrapper').style.display='block';
	var slideshow=new TINY.slideshow("slideshow");
	window.onload=function(){
		slideshow.auto=true;
		slideshow.speed=5;
		slideshow.link="linkhover";
		slideshow.info="information";
		slideshow.thumbs="slider";
		slideshow.left="slideleft";
		slideshow.right="slideright";
		slideshow.scrollSpeed=4;
		slideshow.spacing=5;
		slideshow.active="#fff";
		slideshow.init("slideshow","image","imgprev","imgnext","imglink");
	}
</script>
