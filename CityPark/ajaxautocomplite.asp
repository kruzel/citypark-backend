<!--#include file="config.asp"-->
<%
Response.ContentType = "text/html; charset=utf-8"
buildtree Request.QueryString("CategoryID")

Function buildtree(id)
If Request.QueryString("CategoryID") <> "" then
    SQLw = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype != 3) AND Name LIKE '%" & Request.QueryString("q") & "%' ORDER By LangID ASC,ItemOrder ASC"
Else
    SQLw = "SELECT top 10 * FROM [Content]  WHERE Content.SiteID=" & SiteID & " AND (Contenttype != 3) AND Name LIKE '%" & Request.QueryString("q") & "%' ORDER By LangID ASC,ItemOrder ASC"
End if

	Set objRsw = OpenDB(SQLw)
    
	If objRsW.RecordCount > 0 Then
		Do Until objRsw.EOF
            If Request.QueryString("field")="other1" Then
			    print objRSw("other1") & vbCrLf
            Else
			    print objRSw("Name") & vbCrLf
            End if
			'buildtree objRSw("id")
	
			objRsw.MoveNext
		Loop
	End If
	
	CloseDB(objRsw)		
End Function
%>
