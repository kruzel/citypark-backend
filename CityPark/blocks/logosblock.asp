<!--#include file="../config.asp"-->
<%
Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\logos")
i=0
%>
<div align="center">
	<div id="contentwrapper" style="width:150px">
<%FOR EACH thing in MyFolder.Files
	FileName=thing.Name %>
		<div id="billboard<%=i%>" class="billcontent" align=center>
<img src="resize.asp?path=<% = phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\logos" & "\" & FileName %>&width=140" alt="" class="News">
		</div>
 <% i=i+1
NEXT %>
	</div>
</div>