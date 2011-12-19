<!--#include file="../config.asp"-->
<%
	
	
	If SiteID=57 Then 'domark
	    SQL = "SELECT  TOP 4 *  FROM News WHERE CategoryID = 191 OR  CategoryID = 197 OR  CategoryID = 194 OR  CategoryID = 196 OR  CategoryID = 198 OR  CategoryID = 200 OR  CategoryID = 201 OR  CategoryID = 190 OR  CategoryID = 192 OR  CategoryID = 193OR  CategoryID = 195 OR  CategoryID = 199 AND SiteID = " & SiteID & " Order By NewsID DESC"
	Else
	    SQL = "SELECT  TOP 4 *  FROM News WHERE  SiteID = " & SiteID & " Order By NewsID DESC"
	End If
	Set objRs = OpenDB(SQL)
		TemplateURL = templatelocation  & "lastnews.html"
		
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