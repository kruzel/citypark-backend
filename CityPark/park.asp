<!--#include file="config.asp"-->
<%	
    SQL = "SELECT * FROM [Parking]"
   SQL = SQL & " WHERE SiteID=" & SiteID
  'SQL = SQL & " AND super_type LIKE '%חניה%'"
        If Request.QueryString("id") <> "" Then
            SQL = SQL & " AND ParkingID=" & Request.QueryString("id")
        End If
If Request.QueryString("mode") = "search" Then
     If  Request.form("freetext") <> "" Then  SQL = SQL & " AND Name LIKE '%" & Request.form("freetext") & "%'"
End If
 ' print SQL
            records = 10
			Set objRs = OpenDB(SQL)
               If objRs.recordcount > 0 then
                    objRs.PageSize = records
                    SetSession "PageCount", objRs.PageCount
				    nPage = Int(Request.QueryString("Page"))
					    If nPage <= 0 Then
						    nPage = 1
					    End If
			       objRs.AbsolutePage = nPage
			
			SetPageTitle ""
			SetPageTitle objRs("name")

			header

			If objRs.BOF And objRs.EOF Then 
							Response.write("<div id=""errormeseage"">")
							Response.write("כנראה נפלה טעות בכתובת חזור לעמוד הבית נסה שנית!")
							Response.write("</div>")
							Response.write("</div>")
			Else


 If Request.QueryString("id") <> "" Then
 		TemplateURL = templatelocation  & "parkpage.html" 

				   Template = GetURL(TemplateURL)
					For Each Field In objRs.Fields
                     
					value = objRs(Field.Name)
						If Len(value) > 0 Then
                            If Field.Name = "Text" then
							    Template = Replace(Template, "[Text]", Autolink(value))
                            Else
							    Template = Replace(Template, "[" & Field.Name & "]", value)
							    Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							    Template = Replace(Template, "[Checked]", checked)
                            End If
						Else
							    Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
					Next
							 ProcessLayout(Template)
' start attraction query


print "<select style='  clear: right;    float: right;    margin: 10px 19px 12px 54px;    padding: 10px 10px 10px 6px;    width: 237px;' onchange='changetype(this,"&Request.QueryString("id")&")' id='ctype'>"
        Set objRsP = OpenDB( "SELECT type  FROM Poi GROUP BY type")
print "<option>הכל</option>"
		 Do While NOT objRsP.Eof
			print "<option>"&objrsp("type")&"</option>"
			objRsP.movenext
			loop
print "</select>"

print "<div id='attraction' style='clear:right;'>"
	SQL = "EXEC	 getAttraction @parkid = "& Request("id")&", @type=N'בית קפה'"
		Set objAtr = OpenDB(SQL)					
		         
             Do While NOT objAtr.EOF 
				    TemplateURL =  Templatelocation & "sons_atrac.html" 
				   Template = GetURL(TemplateURL)
					For Each Field In objAtr.Fields
					value = objAtr(Field.Name)
						If Len(value) > 0 Then
							Template = Replace(Template, "[" & Field.Name & "]", value)
							Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							Template = Replace(Template, "[Adminname]", Adminname)
						Else
							Template = Replace(Template, "[urlfacebook]",urlfacebook)
							Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
					Next
							 ProcessLayout(Template)
                   
                objAtr.Movenext
                    loop	
print "</div>"
print "</div>"
print "</div>"
print "<div class=""bottom""></div>"
 Else
            ProcessLayout GetURL(Templatelocation & "parkheader.html")

              z = 0
             Do While NOT objRs.EOF  AND z < records
				    TemplateURL =  Templatelocation & "park.html" 
				   Template = GetURL(TemplateURL)
					For Each Field In objRs.Fields
					value = objRs(Field.Name)
						If Len(value) > 0 Then
							Template = Replace(Template, "[" & Field.Name & "]", value)
							Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							Template = Replace(Template, "[Adminname]", Adminname)
						Else
							Template = Replace(Template, "[urlfacebook]",urlfacebook)
							Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
					Next
						'	 ProcessLayout(Template)
                     z =z +1
                objRs.Movenext
                    loop	
                      '  idpager
                                              ProcessLayout GetURL(Templatelocation & "parkfooter.html")

 		End If
 		End If

			CloseDB(objRs)

End if

				bottom
	Session(SiteID & "PageTitle") = ""
	
%>
</div>