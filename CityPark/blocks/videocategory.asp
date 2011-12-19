<!--#include file="../config.asp"-->
    
<%  

	If GetSession("videocategoryID") = "" Then
		videocategoryID = Request.QueryString("Id")
	Else
		videocategoryID = GetSession("videocategoryID")
	End If
	 
    SQLCATEGORY="SELECT * FROM videoCategory WHERE videoCategoryID= " & videocategoryID & " And SiteID = " & SiteID
	Set objRsCategory = OpenDB(SQLCATEGORY)

	TemplateURL = templatelocation  & "videocategory.html"
     SQL="SELECT * FROM video WHERE videoCategoryID= " & videocategoryID & " And SiteID = " & SiteID & " Order By " & objRsCategory("VideoCategoryOrder")

    Set objRs = OpenDB(SQL)
    
'	objRs.PageSize = objRsCategory("videocategoryperpage")
	objRsCategory.Close  
	'If objRs.PageCount <> 1 Then
	%>

		      	
		  		<% 'If Not objRs.PageCount = 0 Then
			'	If Len(Request.QueryString("page")) > 0 Then
			'	objRs.AbsolutePage = Request.QueryString("page")
		'		Else
		'		objRs.AbsolutePage = 1
		'		End If %><%'End If
	
	If objRs.RecordCount = 0 Then
	print("<p align='center'>אין סרטים בקטגוריה זאת <a href='javascript:history.go(-1)'> לחזרה לחץ כאן</a>!</p>")
	Else
	
		Do until objRs.EOF 
		
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

	objRs.Close  
%>