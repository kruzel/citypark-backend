<!--#include file="../config.asp"-->
<%
	
	Set objRs = OpenDB("SELECT * FROM jobcity WHERE SiteID = " & SiteID & "AND Show9Level=9 Order By Date DESC")
		TemplateURL = templatelocation  & "lastads.html"
		
			If objRs.RecordCount = 0 Then
				Print(SysLang("No_Records_In_This_Category"))
			Else
				HowMany = 0
				Do Until objRs.EOF OR HowMany  = 8
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
		objRs.Close  
	End If	

%>