<!--#include file="../config.asp"-->
<%
               SQL = "SELECT * FROM [Content]  WHERE  Content.SiteID=" & SiteID & " AND (Contenttype = 4)"  
               
                Set objRs = openDB(SQL)
                If objRs.recordcount > 0 then
                    objRs.PageSize = 9
                    SetSession "PageCount", objRs.PageCount
				    nPage = Int(Request.QueryString("Page"))
					    If nPage <= 0 Then
						    nPage = 1
					    End If
			       objRs.AbsolutePage = nPage
                     Do While NOT objRs.eof
                    Template = GetURL(Templatelocation & "allgallerys.html")
                            For Each Field In objRs.Fields
					             value = objRs(Field.Name)
						        If Len(value) > 0 Then
							        Template = Replace(Template, "[" & Field.Name & "]", value)
							        Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
                                Else
							        Template = Replace(Template, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(Template) 
                    objRs.MoveNext
                        loop
                        Newpager
                 End if
                CloseDB(objRs)
	%>