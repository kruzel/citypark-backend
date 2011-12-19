<!--#include file="../config.asp"-->
    
<%  

	
	TemplateURL = templatelocation  & "last3video.html"
     SQL="SELECT TOP 3 * FROM video WHERE  SiteID = " & SiteID & " Order By Position ASC"
	Set objRs = OpenDB(SQL)

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