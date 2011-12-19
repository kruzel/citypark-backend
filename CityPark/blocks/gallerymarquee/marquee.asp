<!--#include file="../../config.asp"-->
    
		<%			
			Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
				Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\maraque\" & Request.QueryString("f") & "\")
			if Request.QueryString("p")	="" then	
		%></head><marquee id="myMarquee" onmouseover="document.getElementById('myMarquee').stop();" onmouseout="document.getElementById('myMarquee').start();" width="90%" scrolldelay="90" behavior="alternate">	<%		i=0
				FOR EACH thing in MyFolder.Files
				FileName=thing.Name
				imagelink=MyFolder & "\" & FileName	%><a target=_blank href="<% =  Application(ScriptName & "UploadPath") & "\maraque\" & FileName %>" rel="lightbox"><img border=0 src="resize.asp?path=<% =imagelink %>&width=170"></a><%i=i+1
NEXT 
End If %>
</marquee>

			
		
		
