<!--#include file="config.asp"-->
<%

If Request.QueryString("Email") <> "" Then
			 Set objRs = OpenDB("SELECT COUNT(*) As ValueCount FROM users WHERE email = '" & Request.QueryString("Email") & "' and siteid = "&siteid)
	        Response.Write(LCase((objRs("ValueCount") = 0)))
	        CloseDB(objRs)
End If
		
	
%>