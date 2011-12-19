<!--#include file="../config.asp"-->
<script src="/js/marquee.js" type="text/javascript"></script>

<script type="text/javascript">
var delayb4scroll=2000 //Specify initial delay before marquee starts to scroll on page (2000=2 seconds)
var marqueespeed=1 //Specify marquee scroll speed (larger is faster 1-10)
var pauseit=1 //Pause marquee onMousever (0=no. 1=yes)?
</script>
<div class="newsbox">
	<div id="marqueecontainer"  onmouseover="copyspeed=pausespeed" onmouseout="copyspeed=marqueespeed">

		<div id="vmarquee"  style="position: relative; width: 98%;">
<%	
	select case GetSession("rssID")
case 1
rssParser "http://www.ynet.co.il/Integration/StoryRss2.xml"
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



response.Write("<div id=""newstitle""><a href=""" & strLink & """ target=""_blank"">" & strTitle & "</a></Div>")
response.Write("<div id=""newsdate"">" & strDate & "</Div>") 
response.Write("<div id=""newscontent"">" & strDesc & "</Div>")
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
	
%>	
	
        </div>
	</div>
</div>
