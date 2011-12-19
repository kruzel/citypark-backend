<!--#include file="config.asp"-->
	<%  header %>
		

		<head>
		

		<link rel="stylesheet" href="../OLD_FILES/style/img/jd.gallery.css" type="text/css" media="screen" />
		<script src="../js/mootools.namespaced.js" type="text/javascript"></script>
		<script src="../js/jd.gallery.namespaced.js" type="text/javascript"></script>

		</head>

		<h1>
		<script type="text/javascript">
			function startGallery() {
				var myGallery = new gallery(Moo.$('myGallery'), {
					timed: false
				});
			}
			window.onDomReady(startGallery);
		</script>
			<%	Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
					Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & Request.QueryString("f") & "\")
				Set d=Server.CreateObject("Scripting.Dictionary")

				Path = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & Request.QueryString("f") & "\photo_info.txt"
			%>
			
				<div class="content">
				<div id="myGallery">
							<% 			i=0
				FOR EACH thing in MyFolder.Files
					FileName=thing.Name
					imagelink=MyFolder & "\" & FileName
			%>

					<div class="imageElement">
						<h3>Item 1 Title</h3>
						<p>Item 1 Description</p>
						<a href="#" title="open image" class="open"></a>
						<img src="<% = Application(ScriptName & "UploadPath") & "\" & Request.QueryString("f") & "\" & FileName %>" class="full" />
						<img src="resize.asp?path=<% =imagelink %>&width=120" class="thumbnail" />
					</div>
				<%  
			NEXT 
	    %>
				</div>
		</div>
<% bottom %>