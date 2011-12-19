<!--#include file="../config.asp"-->
    
<%  

	
	TemplateURL = templatelocation  & "last10nativ.html"
     SQL="SELECT * FROM job where hp = 1 AND SiteID = " & SiteID & " ORDER BY jobID DESC"
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