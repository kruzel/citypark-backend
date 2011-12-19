<!--#include file="../../config.asp"-->
<link type="text/css" rel="stylesheet" href="/blocks/gallery5/galleryview.css" />
<script type="text/javascript" src="/blocks/gallery5/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="/blocks/gallery5/jquery.galleryview-2.1.1-pack.js"></script>
<script type="text/javascript" src="/blocks/gallery5/jquery.timers-1.2.js"></script>

   <script type="text/javascript">
	$(document).ready(function(){
		$('#photos').galleryView({
			panel_width: 800,
			panel_height: 300,
			frame_width: 100,
			frame_height: 100
		});
	});
</script>


    </head>
<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\")

Path = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\photo_info.txt"


%>
  <div id="photos" class="galleryview">


 <%
 FOR EACH thing in MyFolder.Files
FileName=thing.Name
imagelink=MyFolder & "\" & FileName
If MyFileObject.GetExtensionName(imagelink) <> "txt" Then
image = "/Sites/" &  Application(ScriptName & "ScriptPath") & "/Content/images/" & objRsGallery("gallerydirectory") & "/" & FileName 
 
%>   
  <div class="panel">
	  <img src="<% =image %>" /> 
	<div class="panel-overlay">
      <h2>Eden</h2>
      <p>Photo by <a href="http://www.sxc.hu/profile/emsago" target="_blank">emsago</a>.  View full-size photo <a href="http://www.sxc.hu/photo/152865" target="_blank">here</a>.</p>
    </div>
</div>
<%  
	end if 
	NEXT 
%>
 <ul class="filmstrip">
  <%
 FOR EACH thing in MyFolder.Files
FileName=thing.Name
imagelink=MyFolder & "\" & FileName
If MyFileObject.GetExtensionName(imagelink) <> "txt" Then
image = "/Sites/" &  Application(ScriptName & "ScriptPath") & "/Content/images/" & objRsGallery("gallerydirectory") & "/" & FileName 
 
%>   
    <li><img src="<% =image %>" alt="Effet du soleil" title="Effet du soleil" /></li>
 <% 	end if 
	NEXT 
%>
  </ul>
   
    </div>
   

    