<!--#include file="../config.asp"-->
<%
	
			TemplateURL = templatelocation  & "allnews.html"
        SQL = "SELECT * FROM RunNews Where SiteID = " & SiteID & " AND LangID = " &  Session("SiteLang") & " ORDER BY RunNewsOrder DESC"
	Set objRs = OpenDB(SQL)
	
	objRs.PageSize = 10
	If objRs.PageCount <> 1 Then
	%>
		      	<table width=100% cellspacing="0" cellpadding="4">
		  		<% If Not objRs.PageCount = 0 Then
				If Len(Request.QueryString("page")) > 0 Then
				objRs.AbsolutePage = Request.QueryString("page")
				Else
				objRs.AbsolutePage = 1
				End If %>
				<% 	End If%>
					<div align="center">
					<table border="0" width="250" cellspacing="0" cellpadding="0">
						<tr>
							<td width="166">
							<img border="0" src="../images/right.png" width="16" height="16" align="left"></td>
							<td width="177"><font size="2" face="Arial">
							<div align="center">
	<% If objRs.AbsolutePage > 1 Then %>
					<a href="<% = Replace(Request.querystring("p"),"-"," ") %>&page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					<font color="#808080">דף קודם</font></a>
	
				
					</td>
					<td width="25">
					<font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					</td>
					<td width="155">
					<font size="2" face="Arial">
					<div align="center">
	<% If objRs.AbsolutePage < objRs.PageCount Then %>
					<a href="<% = Replace(Request.querystring("p"),"-"," ") %>&page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
					<font color="#808080">דף הבא</font></a>
	
					</font></td>
							<td width="167"><font size="2" face="Arial">
							<img border="0" src="../images/left.png" width="16" height="16" align="right"></font></td>
						</tr>
					</table>
	
<%End If
	
	If objRs.RecordCount = 0 Then
	print("<p align='center'>אין מוצרים בקטגוריה זאת <a href='javascript:history.go(-1)'> לחזרה לחץ כאן</a>!</p>")
	Else
		HowMany = 0
		Do While Not objRs.EOF And HowMany < objRs.PageSize
			Template = GetURL(TemplateURL)
			
			For Each Field In objRs.Fields
				value = objRs(Field.Name)
				
				If Len(value) > 0 Then
					Template = Replace(Template, "[" & Field.Name & "]", value)
				End If
			Next
			
			Response.Write Template
			
			
			HowMany = HowMany + 1
			objRs.MoveNext
		Loop
	End If	
	If objRs.PageCount <> 1 Then
	%>
		      	<table width=100% cellspacing="0" cellpadding="4">
		  		<% If Not objRs.PageCount = 0 Then
				If Len(Request.QueryString("page")) > 0 Then
				objRs.AbsolutePage = Request.QueryString("page")
				Else
				objRs.AbsolutePage = 1
				End If %>
				<% 	End If%>
					<div align="center">
					<table border="0" width="250" cellspacing="0" cellpadding="0">
						<tr>
							<td width="166">
							<img border="0" src="../images/right.png" width="16" height="16" align="left"></td>
							<td width="177"><font size="2" face="Arial">
							<div align="center">
	<% If objRs.AbsolutePage > 1 Then %>
					<a href="<% = Replace(Request.querystring("p"),"-"," ") %>&page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					<font color="#808080">דף קודם</font></a>
	
				
					</td>
					<td width="25">
					<font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					</td>
					<td width="155">
					<font size="2" face="Arial">
					<div align="center">
	<% If objRs.AbsolutePage < objRs.PageCount Then %>
					<a href="<% = Replace(Request.querystring("p"),"-"," ") %>&page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
					<font color="#808080">דף הבא</font></a>
	
					</font></td>
							<td width="167"><font size="2" face="Arial">
							<img border="0" src="../images/left.png" width="16" height="16" align="right"></font></td>
						</tr>
					</table>
	
<%End If

	objRs.Close  
'Bottom
%>