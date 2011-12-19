<!--#include file="../config.asp"-->
<table id="SiteMap" width="90%" align="right" cellpadding="0" cellspacing="0">
<tr>
	<td align="right">
<%
Set objRsCategory = OpenDB("SELECT * FROM Category Where  SiteID = " & SiteID & "  ORDER BY CategoryPosition")	
	Do While Not objRsCategory.EOF
			Response.Write("<b><h1>")
	If objRsCategory("CategoryName") <> "תוכן האתר" then %>
				<a href="category.asp?ID=<% = objRsCategory("CategoryID") %>&S=<% = SiteID %>"><% End if%><% = objRsCategory("CategoryName") %></a>
<%
				Response.Write("<br>")
			Response.Write("</b></h1>")
Set objRs = OpenDB("SELECT * FROM News WHERE CategoryID = " & objRsCategory("CategoryID"))	
Do While Not objRs.EOF
%>
<a  href="Sc.asp?ID=<% = objRs("NewsID") %>&S=<%=SiteID %>"><img border="0" src="../images/Arrowrl.gif" width="7" height="5">&nbsp;
<% = objRs("NewsHeadline") %></a>
<%	Response.Write("<br>")
		objRs.MoveNext 
			Loop
objRs.Close
Set objRsCategory2 = OpenDB("SELECT * FROM Category Where CategoryFatherName = " & objRsCategory("CategoryID")	)
	Do While Not objRsCategory2.EOF
Response.Write("<h2>") 
Response.Write("<img border=""0"" src=""images/Arrowrl.gif"" width=""7"" height=""5"">&nbsp;")
%>
<a href="category.asp?CategoryID=<% = objRsCategory2("CategoryID") %>&S=<% = SiteID %>"><% = objRsCategory2("CategoryName") %></a>
<%
Response.Write("</h2>")
Set objRs = OpenDB("SELECT * FROM News WHERE CategoryID = " & objRsCategory2("CategoryID"))	
	Do While Not objRs.EOF	%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a  href="Sc.asp?ID=<% = objRs("NewsID") %>&S=<%=SiteID %>"><img border="0" src="../images/Arrowrl.gif" width="7" height="5">&nbsp;
<% = objRs("NewsHeadline") %></a>
<% Response.Write("<br>")
	objRs.MoveNext 
		Loop
 objRs.Close
objRsCategory2.MoveNext 
		Loop
objRsCategory2.Close
	objRsCategory.MoveNext 
		Loop
			objRsCategory.Close
%></td></tr>	</table></div>