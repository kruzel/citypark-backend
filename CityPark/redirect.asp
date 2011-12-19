<!--#include file="config.asp"-->
<%
If Request.QueryString("ID")<> "" Then
SQL = "SELECT TOP 1 * FROM banners WHERE ID = " & Request.QueryString("ID")
ElseIf Request.QueryString("ref")<> "" Then
SQL = "SELECT TOP 1 * FROM banners WHERE ID = " & Request.QueryString("ref")
End if

Set objRs = OpenDB(Sql)
objRs("Count") = objRs("Count")+ 1
objRs.Update
RedirectURL = objRs("Link")
CloseDb(objRs)
Response.Redirect RedirectURL

 %>		
