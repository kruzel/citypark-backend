<!--#include file="../../config.asp"-->
<script type="text/javascript" src="/blocks/gallery5/js/galleria.js"></script>
<script>
    Galleria.loadTheme('/blocks/gallery5/css/galleria.classic.css');
    $('#demo').galleria({
        height:400
    });
    </script>
<div id="wrap">
<div id="content">
     <div id="demo">

<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
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
image = "/Sites/" &  Application(ScriptName & "ScriptPath") & "/Content/images/" & objRsGallery("gallerydirectory") & "/" & FileName 
%>
<img src="<% = image %>" width="80" />

<%  
	end if 
	NEXT 
%>
</div>
