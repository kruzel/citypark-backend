<!--#include file="../config.asp"-->
<%	
Header


        Set objRs = OpenDB("SELECT  * FROM BlogPost WHERE BlogID = " & Request.QueryString("ID") & "  Order By BlogPostID DESC")
	
		TemplateURL = templatelocation  & "blogPosts.html" 
	
	
	If objRs.RecordCount = 0 Then
		Print(SysLang("No_Records_In_This_Category"))
	Else

		Do While Not objRs.EOF
			Set CountComments = OpenDB("SELECT COUNT(BlogCommentsID) AS sTOTAL FROM BlogComments WHERE PostID = " & objRs("BlogPostID") & " And SiteID=" & SiteID)
            TOTAL = CountComments("sTOTAL")
            CloseDB(CountComments)

			Template = GetURL(TemplateURL)
			For Each Field In objRs.Fields
				value = objRs(Field.Name)
				
				If Len(value) > 0 Then
					Template = Replace(Template, "[" & Field.Name & "]", value)
					Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
				Else
					Template = Replace(Template, "[TOTAL]",TOTAL)
				End If
			Next
			
			Response.Write Template
			
			objRs.MoveNext
		Loop
	End If	

	objRs.Close  
Bottom
%>