<!--#include file="../../config.asp"-->
<% Set objRsGallery = OpenDB("SELECT * FROM videocategory WHERE videocategoryID=1")
    If objRsGallery("GalleryCustomFiles") = 1 Then %>
        <link rel="stylesheet" href="<% = SiteLayout %>gallery2/style.css" />
        <script type="text/javascript" src="<% = SiteLayout %>gallery2/compressed.js"></script>
<% Else %>
        <link rel="stylesheet" href="/blocks/gallery2/style.css" />
        <script type="text/javascript" src="/blocks/gallery2/compressed.js"></script>
<% End If %>

<ul id="slideshow_gal1">
<% 
        If objRsGallery("galleryfromdatabase") = 1 Then
	        Set objRs = OpenDB("SELECT * FROM video WHERE videocategoryID=1")
	        Do While Not objRs.EOF
		        imagelink =  objRS("videoimage")
%>
		<li>
			<h3><% = objRS("videoname") %></h3>
			<span><% = objRS("videoimage")%></span>
			<p><% = objRS("videodescription") %></p>
			<a href="#"><img src="<% =imagelink %>" width=125" height="75" alt="<% = objRS("videoimage")%>" /></a>
		</li>
<% 	objRs.MoveNext
		Loop
objRs.close
      End if 
		 
CloseDB(objRsGallery)
	    %>
	</ul>
	<div id="wrapper">
		<div id="fullsize">
			
			<div id="image_gal1"></div>
			
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