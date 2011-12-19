<!--#include file="../config.asp"-->
<!--#include file="../$db.asp"-->
<script src="/js/marquee.js" type="text/javascript"></script>

<script type="text/javascript">
var delayb4scroll=2000 //Specify initial delay before marquee starts to scroll on page (2000=2 seconds)
var marqueespeed=1 //Specify marquee scroll speed (larger is faster 1-10)
var pauseit=1 //Pause marquee onMousever (0=no. 1=yes)?
</script>
<div class="newsbox">
	<div id="marqueecontainer"  onmouseover="copyspeed=pausespeed" onmouseout="copyspeed=marqueespeed">
<%
Set objRs = OpenDB("SELECT * FROM RunNews Where SiteID = " & SiteID & " AND ((floor(convert(real,GetDate())) >= floor(convert(real,RunNewsFromDate)) And RunNewsFromDate IS NOT NULL) OR RunNewsFromDate IS NULL) AND ((floor(convert(real,GetDate())) <= floor(convert(real,RunNewsToDate)) And RunNewsToDate IS NOT NULL) OR RunNewsToDate IS NULL) AND LangID = " &  Session("SiteLang") & " ORDER BY RunNewsOrder DESC")

If objRs.Recordcount = 0 Then
	print "אין חדשות לתצוגה"
	print "</Div></Div>"
Else %>
		<div id="vmarquee"  style="position: relative; width: 98%;">
<% 	Do while NOT objRs. EOF
	 If Not objRs("RunNewsLink")= "" then
		thelink=objRs("RunNewsLink")
	 Elseif Not objRs("RunNewsNewsLink")= "" then
		thelink="Sc.asp?ID=" & objRs("RunNewsNewsLink") & "&Tipe=1&Sr=Yes&Sl=Yes&St=&Sb=Yes&S="& SiteId
	 Else
		thelink=""
	End if	%>
		<div id="newstitle"><% if not thelink="" then%><a href= "<%=thelink%>"><% End If %><% = objRs("RunNewsName") %><% if not thelink="" then%></a><% End If %></div>
<% if getconfig("EnableDateInRunNews") = 1 then %>
		<div id="newsdate"><small><% =left(objRs("RunNewsTime"),10) %></small></div>
<% end if %>
	    <div id="newscontent"><% =objRs("RunNewsContent") %></div>
<%objRs.MoveNext		
	Loop%>
        </div>
	</div>
</div>
<%

CloseDB(objRs)
End If

%>