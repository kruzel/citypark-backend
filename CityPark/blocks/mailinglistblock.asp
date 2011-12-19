<!--#include file="../config.asp"-->
<div id="mailinglist">
<form  id="mailform" name="mailform" class="_validate" action="../MailingList.asp" method="get" >
<%
If Request.querystring("GroupID") <> "" then Session("GroupID")= Request.querystring("GroupID")
TemplateURL = templatelocation  & "mailinglist.html"
PrintCustomizedTemplate GetURL(TemplateURL), NULL, "ProcessMaillingListBlock"

Sub ProcessMaillingListBlock(strCommand)
	s = Split(strCommand)
	
	Set s_objRs = OpenDB("SELECT * FROM " & s(1) & " WHERE SiteId = " & SiteID)
			
	Print "<ul class=""autolist"">"
			
	Do Until s_objRs.Eof
		Print "<li><input type=""checkbox"" checked name=""category_" & s_objRs(0) & """ value=""" & s_objRs(0) & """ /><span>" & s_objRs(1) & "</span></li>"
		s_objRs.MoveNext
	Loop
			
	Print "</ul>"
			
	CloseDB(s_objRs)
End Sub
 %>
</form>

</div>
