<!--#include file="../../config.asp"--> 

<head>
</style>
<!--[if lte IE 6]><link rel="stylesheet" href="/app/css/ie6.css" type="text/css" media="all" />
<![endif]-->
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/blocks/gallery5/JqCar.js"></script>
<script type="text/javascript">
var myMooFlowPage = {

	start: function(){

		var mf = new MooFlow($('MooFlow'), {
	stylePath: '/blocks/gallery5/MooFlow.css',
  onStart: Class.empty,
  onComplete: Class.empty,
  onCancel: Class.empty,
  onClickView: function(callback) {
  		showLightbox2(callback.src);
  }	,
  onAutoPlay: true,
  onAutoStop: Class.empty,
  reflection: 0.9,
  heightRatio: 0.55,
  startIndex: 5,
  interval: 2000,
  factor: 180,
  bgColor: '',
  useCaption: true,
  useResize: false,
  useSlider: false,
  useWindowResize: true,
  useMouseWheel: true
		});	
	}
	
};

window.addEvent('domready', myMooFlowPage.start);
</script>
<div id="demo">
	<div id="MooFlow">

<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
If objRsGallery("galleryfromdatabase") = 1 Then

Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoorder ASC")
%>

<%	Do While Not objRs.EOF
	imagelink = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\" & objRS("image")
%>
<div><img src="<% = Application(ScriptName & "UploadPath") & "/" & objRsGallery("gallerydirectory") & "/" & objRS("image")%>" title="<% = objRS("photodesc") %>" alt="<% = objRS("photodesc") %>" /></div>
<%
 	objRs.MoveNext
		Loop
objRs.close
 Else	
			Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
				Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\")
			Set d=Server.CreateObject("Scripting.Dictionary")
		%>
			<%	i=0
			FOR EACH thing in MyFolder.Files
			FileName=thing.Name
			imagelink=MyFolder & "\" & FileName
%>
<div><img src="<% = Application(ScriptName & "UploadPath") & "/" & objRsGallery("gallerydirectory") & "/" & FileName %>" rel="lightbox" title="" alt="" /></a></div>

<% 
NEXT 
End if
%>
	</div>
</div>