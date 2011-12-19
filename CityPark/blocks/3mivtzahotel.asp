<!--#include file="../config.asp"-->
    
<%  
	
	TemplateURL = templatelocation  & "3mivtzahotel.html"
     SQL="SELECT TOP 3 * FROM News WHERE other5 >0 AND SiteID = " & SiteID
     'print SQL
	Set objRs = OpenDB(SQL)

	If objRs.RecordCount = 0 Then
	print("<p align='center'>אין מלונות במבצע <a href='javascript:history.go(-1)'> לחזרה לחץ כאן</a>!</p>")
	Else
	
		Do until objRs.EOF 
	SQLCategory = "SELECT CategoryName FROM category WHERE CategoryID = " & objRs("CategoryID") & " And SiteID=" & SiteID

			Set objRsCategory = OpenDB(SQLCategory)
                sCategoryName =  objRsCategory("CategoryName")
			objRsCategory.Close

    
    
    	
			Template = GetURL(TemplateURL)
			
			For Each Field In objRs.Fields
				value = objRs(Field.Name)
				
				If Len(value) > 0 Then
					Template = Replace(Template, "[" & Field.Name & "]", value)
                    Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
					Template = Replace(Template, "[categoryname]", sCategoryName)

				End If
			Next
			
			Response.Write Template
			
			
			HowMany = HowMany + 1
			objRs.MoveNext
		Loop

	End If	

	objRs.Close  
%>