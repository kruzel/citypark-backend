<!--#include file="config.asp"-->
<%
sql = "EXEC [dbo].[addfbuser] @fbid = "&request.form("fbid")&",@fname = N'"&request.form("fname")&"',@lname = N'"&request.form("lname")&"',@name = N'"&request.form("name")&"',@email = N'"&request("email")&"',@pic = N'"&request.form("pic")&"',@siteid = "&siteid
print sql
Set objRsPages = OpenDB(sql)
		
%>