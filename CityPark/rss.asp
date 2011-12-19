
<!--#include file="config.asp"-->


<%
header
select case request.querystring("Feed")
case 1
rssParser "http://www.alljobs.co.il/SearchResultsGuestRSS.aspx?page=1&position=262&region=-1&type=-1"
case 2
rssParser "http://www.ynet.co.il/Integration/StoryRss6.xml"
case 3
rssParser "http://www.ynet.co.il/Integration/StoryRss1208.xml"
case 4
rssParser "http://www.ynet.co.il/Integration/StoryRss546.xml"
case 5
rssParser "http://www.ynet.co.il/Integration/StoryRss3.xml"
case 6
rssParser "http://myway.co.il/rss/weather.xml"
case 7
rssParser "http://www.calcalist.co.il/integration/StoryRss3674.xml"


end select
rssParser "http://www.alljobs.co.il/SearchResultsGuestRSS.aspx?page=1&position=262&region=-1&type=-1"

%>

<%
Sub rssParser(rssFile)

Dim objXML, objRoot, objItems, c
c = 0
Set objXML = Server.CreateObject("Microsoft.XMLDOM")
objXML.Async = False
objXML.SetProperty "ServerHTTPRequest", True
objXML.ResolveExternals = True
objXML.ValidateOnParse = True
objXML.Load(rssFile)

If (objXML.parseError.errorCode = 0) Then
Set objRoot = objXML.documentElement
If IsObject(objRoot) = False Then
response.Write "<h2>מקור המידע לא זמין כעת</h2>"
End If

Set objItems = objRoot.getElementsByTagName("item")
If IsObject(objItems) = True Then
Dim objItem
For Each objItem in objItems
strTitle = objItem.selectSingleNode("title").Text
On Error Resume Next 
strDesc = objItem.selectSingleNode("description").Text
On Error Resume Next
strLink = objItem.selectSingleNode("link").Text
On Error Resume Next
strDate = objItem.selectSingleNode("pubDate").Text
On Error Resume Next


response.Write("<right><table width=""90%"" cellspacing=""1"" celpading=""0"" bgcolor=""#111111"">" & vbnewline)

response.Write("<tr><td bgcolor=""#ffffff"" wrap style=""padding:8px; font:13px Arial, Helvetica, sans-serif"">" & vbnewline )
response.Write("<b> " & strTitle & "<br>" & vbnewline  & "</b>" )
response.Write("<b></b> <a target=""_blank"" href="""& strLink & """>"& "לכתבה המלאה" &"</a><br>" & vbnewline )
response.Write("<b></b>" & strDate & "<br>" & vbnewline ) 
response.Write( strDesc & "<br>" & vbnewline )
response.Write("</td></tr>" & vbnewline )
response.Write("</table></center><br/>")

Next
else
response.Write "<h2>מקור המידע לא נמצא </h2>"
exit sub 
End If
Set objRoot = Nothing
Set objItems = Nothing
End If

Set objXML = Nothing 
end sub 
bottom
%>