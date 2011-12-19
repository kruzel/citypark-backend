<!--#include file="config.asp"-->

<%
If SiteID = 999 Or SiteID = 20 Then
Response.ContentType="text/plain"
ProcessLayout(GetURL(templatelocation & "robots.txt"))
Else
Response.Status="404 Not Found"
'Response.AddHeader "Location", "http://www.yourdomain.com/sub/456.asp"
response.end
End If
%> 