<!--#include file="../config.asp"-->
    
<%  

	
	TemplateURL = templatelocation  & "last8zuk.html"
     SQL="SELECT TOP 8 * FROM News WHERE CategoryID = 336 or CategoryID = 317 or CategoryID = 318 or CategoryID = 319 AND SiteID = " & SiteID & " ORDER BY NewsID DESC"
	Set objRs = OpenDB(SQL)

	If objRs.RecordCount = 0 Then
	print("<p align='center'>אין מוצרים <a href='javascript:history.go(-1)'> לחזרה לחץ כאן</a>!</p>")
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