<!--#include file="config.asp"-->
<%  header
 TemplateURL = templatelocation  & "gallery.html" 
    Set objRs = OpenDB("SELECT * FROM gallery WHERE  SiteID=" & SiteID & " ORDER BY galleryID DESC")
	If objRs.RecordCount = 0 Then
		Print(SysLang("No_Records_In_This_Category"))
	Else
		Do While Not objRs.EOF
			Template = GetURL(TemplateURL)
			
			For Each Field In objRs.Fields
				value = objRs(Field.Name)
				
				If Len(value) > 0 Then
					Template = Replace(Template, "[" & Field.Name & "]", value)
					Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
				End If
			Next
			
			Response.Write Template
			
			
			objRs.MoveNext
		Loop
	End If	
CloseDB(objrs)
bottom
%>