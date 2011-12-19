<!--#include file="config.asp"-->
<%
if request("mode") = "fbc" then
sql = "EXEC [dbo].[addfbuser] @fbid = "&request.form("fbid")&",@fname = N'"&request.form("fname")&"',@lname = N'"&request.form("lname")&"',@name = N'"&request.form("name")&"',@email = N'"&request("email")&"',@pic = N'"&request.form("pic")&"',@siteid = "&siteid
print sql
Set objRsPages = OpenDB(sql)
end if
if request("mode") = "lmi" then
	sql = "select * from users where fbid = "&request.form("fbid") & " AND SiteID=" & SiteID
	Set userRs = OpenDB(SQL)
	Response.Cookies(SiteID & "UserID") = userRs("ID")
	Response.Cookies(SiteID & "UserID").Expires=#May 10,2025#
	Response.Cookies(SiteID & "LoginName") = userRs("usersname")
	Response.Cookies(SiteID & "LoginName").Expires=#May 10,2025#
	Response.Cookies(SiteID & "UserLevel") = userRs("Users9Level")
	Response.Cookies(SiteID & "UserLevel").Expires=#May 10,2025#
	Response.Cookies(SiteID & "Type") = "User"
	Response.Cookies(SiteID & "Type").Expires=#May 10,2025#
	Response.Cookies(SiteID & "FB") = request.form("fbid")
	Response.Cookies(SiteID & "FB").Expires=#May 10,2025#
	response.write "in"
end if		
if request("mode") = "lmo" then
	Response.Cookies(SiteID & "UserID").Expires = Now()-1 'למחוק את העוגייה
	Response.Cookies(SiteID & "LoginName").Expires = Now()-1 'למחוק את העוגייה
	Response.Cookies(SiteID & "Password").Expires = Now()-1 'למחוק את העוגייה
	Response.Cookies(SiteID & "UserLevel").Expires = Now()-1 'למחוק את העוגייה
	Response.Cookies(SiteID & "Type").Expires = Now()-1 'למחוק את העוגייה
	Response.Cookies(SiteID & "FB").Expires = Now()-1 'למחוק את העוגייה
	SetSession UserID,""
	print Request.ServerVariables("server_name")
end if
%>