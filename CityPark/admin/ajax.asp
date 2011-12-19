<!--#include file="../config.asp"-->
<!--#include file="../JSON.asp"-->

<%
m_Table = Request.QueryString("table")

CheckSecuirty m_Table

m_ValueField = Request.QueryString("valuefield")
m_NameField = Request.QueryString("namefield")

m_WhereCount = Int(Request.QueryString("wherecount"))

SQL = "SELECT " & m_NameField & " AS text, " & m_ValueField & " AS value FROM " & m_Table & " WHERE"

If m_WhereCount > 0 Then
	For Index = 0 To m_WhereCount - 1
		SQL = SQL & " " & Request.QueryString("where" & Index) & " = '" & UrlDecode2(Request.QueryString("where" & Index & "value")) & "' AND"
	Next	
End If

SQL = SQL & " SiteID = " & SiteID
print sql
SET dbconn = SetConn()

QueryToJSON(dbconn, SQL).Flush

%>
