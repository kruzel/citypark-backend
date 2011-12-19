<!--#include file="../config.asp"-->

<script type="text/javascript" src="/js/fusioncharts.js"></script> 

<div id="chart">
</div>

<%                
	Dim Data(7)
	
	Set objRsStats = OpenDB("SELECT COUNT(*) AS today FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE(), 103) AND SiteID =" & SiteID)
    Data(0) = objRsStats("today")
    Set objRsStats = OpenDB("SELECT COUNT(*) AS today1 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-1, 103)AND SiteID =" & SiteID)
    Data(1) = objRsStats("today1")
    Set objRsStats = OpenDB("SELECT COUNT(*) AS today2 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-2, 103)AND SiteID =" & SiteID)
    Data(2) = objRsStats("today2")
    Set objRsStats = OpenDB("SELECT COUNT(*) AS today3 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-3, 103)AND SiteID =" & SiteID)
    Data(3) = objRsStats("today3")
    Set objRsStats = OpenDB("SELECT COUNT(*) AS today4 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-4, 103)AND SiteID =" & SiteID)
    Data(4) = objRsStats("today4")
    Set objRsStats = OpenDB("SELECT COUNT(*) AS today5 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-5, 103)AND SiteID =" & SiteID)
    Data(5) = objRsStats("today5")
    Set objRsStats = OpenDB("SELECT COUNT(*) AS today6 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-6, 103)AND SiteID =" & SiteID)
    Data(6) = objRsStats("today6")
    Set objRsStats = OpenDB("SELECT COUNT(*) AS today7 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-7, 103)AND SiteID =" & SiteID)
    Data(7) = objRsStats("today7")
    CloseDB(objRsStats)
%>
				
				


<script type="text/javascript">

var strXml = "<graph numberPrefix='' decimalPrecision='0' animation='1' showValues='1' rotateValues='1'yaxismaxvalue='30'>";
strXml += "<categories>";
<% For I = 0 To 7 %>
strXml += "<category name='<% = day(date - I) & "/" & month(date) %>' />";
<% Next %>
strXml += "</categories>";
strXml += "<dataset seriesName='כניסות' color='26BADE'>";
<% For Each d In Data %>
strXml += "<set value='<% = d %>' />";
<% Next %>
strXml += "</dataset>";
strXml += "</graph>";

var chart1 = new FusionCharts("FCF_MSColumn3D.swf", "chart1Id", "350", "200");

chart1.setDataXML(strXml);
chart1.render("chart");

</script>

