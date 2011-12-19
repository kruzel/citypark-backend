<!--#include file="../config.asp"-->
    
<%  header
		SQLform = "SELECT * FROM Customform WHERE ID ="  & ID & " And SiteID=" & SiteID
		Set objRsform = OpenDB(SQLform)
		print "<form action=""" & Request.querystring & "&mode=doit"" method=""post"" id=""ContactFormpage"" class=""_validate"" >"
		print "<table id=""contactform"" cellspacing=""0"" cellpadding=""0"">
		print "<tr>"
		print "<td colspan=""2""><input id=""cff"" name=""Name"" style=""float: right""></td>"
		print "<td align=""right"">:שם</td>"
		print "</tr>"
		print "<tr><td colspan=""2""><input id=""cff"" dir=""rtl"" name=""Phone"" style=""float: right""></td></tr>"
		print "</table>"
		print "</form>"
		Closedb(objRsform)
	bottom
%>