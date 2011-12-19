<!--#include file="../config.asp"-->
<%
                        SQLsons1 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE Content.SiteID=" & SiteID & " AND (Contenttype =2)"  
                        'SQLsons1 = SQLsons1 & " Order By " & objRs("Sonsorder") 
                       
                       
                        SQLsons2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE Content.SiteID=" & SiteID & " AND (Contenttype =2)"  
                       ' SQLsons2 = SQLsons2 & " Order By " & objRs("Sonsorder") 
               
                Set objRssons1 = openDB(SQLsons1)
                Set objRssons2 = openDB(SQLsons2)
                If objRssons1.recordcount > 0 then
                    objRssons1.PageSize = 12
                    SetSession "PageCount", objRssons1.PageCount
				    nPage = Int(Request.QueryString("Page"))
					    If nPage <= 0 Then
						    nPage = 1
					    End If
			       objRssons1.AbsolutePage = nPage
                   sonTemplateURL = Templatelocation & "productcategorys.html"
                     '-------------
                     Do While NOT objRssons1.eof 
                    sontemplate = GetURL(sonTemplateURL)
                        SQLson = "Select * From Content Where id=" & objRssons1("id") & " And SiteID=" & SiteID
                        Set objRsson = openDB(SQLson)
                       if z mod 2 = 0 then
                            zebraclass = "odd"
                        else
                            zebraclass = "even"
                        end if

                            For Each Field In objRsson.Fields
					             value = objRsson(Field.Name)
						        If Len(value) > 0 Then
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", value)
							        sontemplate = Replace(sontemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
							        sontemplate = Replace(sontemplate, "[zebraclass]", zebraclass)
                                Else
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(sontemplate) 
                        CloseDB(objRsson)
                    objRssons1.MoveNext
                        loop
                        Newpager
                 End if
                CloseDB(objRssons1)
                If Sonsvipmode = True Then CloseDB(objRssons2)

%>