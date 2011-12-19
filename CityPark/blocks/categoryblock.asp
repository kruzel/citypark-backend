<!--#include file="../config.asp"-->
<%
	
	Set objRsCategory = OpenDB("SELECT CategoryTemplate, CategoryDesc FROM Category WHERE CategoryID=" & Request.QueryString("CatID"))
	    Set objRs = OpenDB("SELECT * FROM News WHERE CategoryID = " & Request.QueryString("CatID") & " And SiteID = " & SiteID & " And Active = 1 Order By " & objRsCategory("CategoryNewsOrder"))
	TemplateURL = templatelocation  & objRsCategory("CategoryTemplate") 
		
	If objRs.RecordCount = 0 Then
		Print(SysLang("No_Records_In_This_Category"))
	Else
		Do Until objRs.Eof
			Template = GetURL(TemplateURL)
			
			For Each Field In objRs.Fields
				value = objRs(Field.Name)
				
				If Len(value) > 0 Then
					Template = Replace(Template, "[" & Field.Name & "]", value)
				End If
			Next
			
			Response.Write Template
			
			objRs.MoveNext
		Loop
	End If	

	objRsCategory.Close  
	objRs.Close  
%>