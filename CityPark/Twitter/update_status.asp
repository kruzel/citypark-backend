<!--#include file="asp_twitter_lib.asp" -->
<%
'*************************************************
'* @ sample of update twitter status with AspTwitterLib
'*************************************************
Dim oTwitterAPI:set oTwitterAPI = new AspTwitterLib
oTwitterAPI.aspTwitterLoginUser = "doobleweb"
oTwitterAPI.aspTwitterLoginPass = "k161281"
oTwitterAPI.aspTwitterShortUrlInit "bitly","username","api key"

Dim intLastID,strTweets		
strTweets = "text here "&oTwitterAPI.aspTwitterShortUrlGet("http://asp.web.id")
intLastID = oTwitterAPI.aspTwitterUpdateStatus(strTweets)

if Len(oTwitterAPI.aspTwitterError) > 0 then
	response.write "Oops error occured: "&oTwitterAPI.aspTwitterError
else
	Response.Write "intLastID = " & intLastID
end if

Set oTwitterAPI = nothing
%>