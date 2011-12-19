<!--#include file="../config.asp"-->
<%
    Response.Clear
    Response.CodePage = 1255  
    Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=users.csv"
       
       

CheckSecuirty "Users"

		SQL = "SELECT * FROM Users WHERE SiteID=" & SiteID & " ORDER BY FamilyName ASC"
	Set objRs = OpenDB(SQL)
%>


<%
	Do While Not objRs.EOF
%>
<% = objRs("name") %>,<% = objRs("FamilyName") %>,<% = objRs("Phone") %>,<% = objRs("Cellular") %>,<% = objRs("Address") %>,<% = objRs("Email") & vbCrLf %>

<% objRs.MoveNext
		Loop

%>


