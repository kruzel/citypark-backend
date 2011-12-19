<%

Function Authorize(email, password)
	Set http = Createobject("MSXML2.ServerXMLHTTP")
	
	http.Open "POST", "https://www.google.com/accounts/ClientLogin", False
	http.SetRequestHeader "content-type", "application/x-www-form-urlencoded"
	
	http.Send "Email=" & Server.UrlEncode(email) & "&Passwd=" & Server.UrlEncode(password) & "&accountType=GOOGLE&source=curl-dataFeed-v2&service=analytics"
		
	Set RegularExpressionObject = New RegExp
	
	With RegularExpressionObject
		.Pattern = "Auth=.*"
		.IgnoreCase = False
		.Global = True
	End With
	
	Authorize = RegularExpressionObject.Execute(http.ResponseText)(0).Value
End Function

Function GetSites(authorization)
	Set http = Createobject("MSXML2.ServerXMLHTTP")
	
	http.Open "GET", "https://www.google.com/analytics/feeds/accounts/default", False
	
	http.SetRequestHeader "content-type", "application/x-www-form-urlencoded"
	http.SetRequestHeader "Authorization", "GoogleLogin " & authorization

	http.Send
	GetSites = http.ResponseText
End Function

Function GetReportData(authorization, tableId)
	Set http = Createobject("MSXML2.ServerXMLHTTP")
	
	url = "ids=" & tableId
	url = url & "&dimensions=ga:source,ga:medium"
	url = url & "&metrics=ga:visits"	
	url = url & "&sort=-ga:visits"
'	url = url & "&filters=ga:source%3D%3Damberflooring.com"
	'url = url & "&segment=gaid::10 OR dynamic::ga:medium%3D%3Dreferral"
	url = url & "&start-date=" & GetStartDate() 
	url = url & "&end-date=" & GetEndDate() 
	url = url & "&max-results=5"
	url = url & "&v=2"
	url = url & "&prettyprint=true"	

	http.Open "GET", "https://www.google.com/analytics/feeds/data?" & url, False
	
	http.SetRequestHeader "content-type", "application/x-www-form-urlencoded"
	http.SetRequestHeader "Authorization", "GoogleLogin " & authorization

	http.Send 
	GetReportData = http.ResponseText
End Function

Function GetEndDate()
	d = Date()
	GetEndDate = Year(d) & "-0" & Month(d) & "-" & Day(d)
End Function

Function GetStartDate()
	d = Date()
	GetStartDate = Year(d) & "-0" & (Month(d) - 1) & "-" & Day(d)
End Function
'response.write GetSites(Authorize("info@2gether.co.il", "k161281"))
'Response.Write GetReportData(Authorize("info@2gether.co.il", "k161281"), "ga:6394346")

%><embed height="125" width="100%" flashvars="input=%7B%22Graph%22%3A%7B%22ShowHover%22%3Atrue%2C%22MetricComparison%22%3Afalse%2C%22Format%22%3A%22NORMAL%22%2C%22UseAs3Graph%22%3Atrue%2C%22StateQuery%22%3A%22id%5Cu003d33449111%5Cu0026pdr%5Cu003d20100627-20100727%5Cu0026cmp%5Cu003daverage%5Cu0026rpt%5Cu003dDashboardReport%22%2C%22DateRangeComparison%22%3Afalse%2C%22Compare%22%3Afalse%2C%22XAxisTitle%22%3A%22Day%22%2C%22XAxisLabels%22%3A%5B%5B%2220100628%22%2C%22Jun%2028%22%5D%2C%5B%2220100705%22%2C%22Jul%205%22%5D%2C%5B%2220100712%22%2C%22Jul%2012%22%5D%2C%5B%2220100719%22%2C%22Jul%2019%22%5D%2C%5B%2220100726%22%2C%22Jul%2026%22%5D%5D%2C%22AnnotationsEnabled%22%3Atrue%2C%22HoverType%22%3A%22primary_compare%22%2C%22UrlPath%22%3A%22%2Fanalytics%2Freporting%2F%22%2C%22StateBaseQuery%22%3A%22id%5Cu003d33449111%5Cu0026pdr%5Cu003d20100627-20100727%5Cu0026cmp%5Cu003daverage%22%2C%22SelectedSeries%22%3A%5B%22primary%22%2C%22compare%22%5D%2C%22Series%22%3A%5B%7B%22SelectionStartIndex%22%3A0%2C%22SelectionEndIndex%22%3A30%2C%22Style%22%3A%7B%22Name%22%3A%22primary-blue%22%2C%22PointShape%22%3A%22CIRCLE%22%2C%22PointRadius%22%3A9%2C%22FillColor%22%3A30668%2C%22FillAlpha%22%3A10%2C%22LineThickness%22%3A4%2C%22ActiveColor%22%3A30668%2C%22InactiveColor%22%3A11654895%7D%2C%22Label%22%3A%22Visits%22%2C%22Id%22%3A%22primary%22%2C%22YLabels%22%3A%5B%5B%220%22%2C%220%22%5D%2C%5B%222%22%2C%222%22%5D%2C%5B%225%22%2C%225%22%5D%5D%2C%22ValueCategory%22%3A%22visits%22%2C%22Points%22%3A%5B%7B%22Value%22%3A%5B%222%22%2C%222%22%5D%2C%22Label%22%3A%5B%2220100627%22%2C%22Sunday%2C%20June%2027%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%221%22%2C%221%22%5D%2C%22Label%22%3A%5B%2220100628%22%2C%22Monday%2C%20June%2028%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%221%22%2C%221%22%5D%2C%22Label%22%3A%5B%2220100629%22%2C%22Tuesday%2C%20June%2029%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100630%22%2C%22Wednesday%2C%20June%2030%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%225%22%2C%225%22%5D%2C%22Label%22%3A%5B%2220100701%22%2C%22Thursday%2C%20July%201%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100702%22%2C%22Friday%2C%20July%202%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100703%22%2C%22Saturday%2C%20July%203%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100704%22%2C%22Sunday%2C%20July%204%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100705%22%2C%22Monday%2C%20July%205%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100706%22%2C%22Tuesday%2C%20July%206%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100707%22%2C%22Wednesday%2C%20July%207%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100708%22%2C%22Thursday%2C%20July%208%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100709%22%2C%22Friday%2C%20July%209%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100710%22%2C%22Saturday%2C%20July%2010%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100711%22%2C%22Sunday%2C%20July%2011%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%221%22%2C%221%22%5D%2C%22Label%22%3A%5B%2220100712%22%2C%22Monday%2C%20July%2012%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100713%22%2C%22Tuesday%2C%20July%2013%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100714%22%2C%22Wednesday%2C%20July%2014%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%222%22%2C%222%22%5D%2C%22Label%22%3A%5B%2220100715%22%2C%22Thursday%2C%20July%2015%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100716%22%2C%22Friday%2C%20July%2016%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100717%22%2C%22Saturday%2C%20July%2017%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%221%22%2C%221%22%5D%2C%22Label%22%3A%5B%2220100718%22%2C%22Sunday%2C%20July%2018%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%221%22%2C%221%22%5D%2C%22Label%22%3A%5B%2220100719%22%2C%22Monday%2C%20July%2019%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%222%22%2C%222%22%5D%2C%22Label%22%3A%5B%2220100720%22%2C%22Tuesday%2C%20July%2020%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100721%22%2C%22Wednesday%2C%20July%2021%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%221%22%2C%221%22%5D%2C%22Label%22%3A%5B%2220100722%22%2C%22Thursday%2C%20July%2022%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100723%22%2C%22Friday%2C%20July%2023%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100724%22%2C%22Saturday%2C%20July%2024%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100725%22%2C%22Sunday%2C%20July%2025%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%220%22%2C%220%22%5D%2C%22Label%22%3A%5B%2220100726%22%2C%22Monday%2C%20July%2026%2C%202010%22%5D%7D%2C%7B%22Value%22%3A%5B%223%22%2C%223%22%5D%2C%22Label%22%3A%5B%2220100727%22%2C%22Tuesday%2C%20July%2027%2C%202010%22%5D%7D%5D%7D%5D%2C%22Id%22%3A%22Graph%22%7D%7D&amp;annotationsEnabled=true&amp;handCursorEnabled=true&amp;msgAnnotationSingular=1%20Annotation&amp;msgAnnotationsPlural=%25s%20Annotations&amp;msgCreateAnnotation=Create%20new%20annotation" allowscriptaccess="always" menu="false" wmode="opaque" salign="TL" scale="noScale" quality="high" name="Graph_vis_embed" id="Graph_vis_embed" style="" src="https://www.google.com//analytics/static/flash/OverTimeGraphMain.swf" type="application/x-shockwave-flash">