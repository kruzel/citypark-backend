<!--#include file="config.asp"-->
<%	
SQLid = "Select * From [MiniSite] Where MiniSiteName='" & Trim(Replace(Request.QueryString("c"),"-"," ")) & "' AND SiteID = " & SiteID
  '  print SQLid
    Set objRsID = OpenDB(SQLid)
    MiniSiteId = objRsID("MiniSiteID")
    MiniSiteName = objRsID("MiniSiteName")
    MiniSiteTitle = objRsID("MiniSiteTitle")
    MiniSiteDescription = objRsID("MiniSiteDescription")
    MiniSiteKeywords = objRsID("MiniSiteKeywords")
    CloseDB(objRsID)


Function MiniSiteMenu()
		
	Set objRsMenu = OpenDB("Select * From [MiniSitePages] Where MiniSiteID =" &  MiniSiteId &" AND SiteID = " & SiteID & "  ORDER BY MiniSiteID ASC")
	v = 1
	    Output = Output & "<ul>"
	Do Until objRsMenu.Eof
		Output = Output & "<li class="">"
		
			If v = 1 Then
				Output = Output & "first"
			ElseIf objRsMenu.AbsolutePosition = objRsMenu.RecordCount Then
				Output = Output & "last"
			Else
				Output = Output & "btn" & v
			End If
			
			Output = Output & """>"
							
			If  AddMiniSiteName = True Then
                Output = Output & "<a href=""" & Replace(MiniSiteName," ","-") & "/" & objRsMenu("urltext") & """>" & objRsMenu("MiniSitePagesName") & "</a>"
            Else
                Output = Output & "<a href=""" &  objRsMenu("urltext") & """>" & objRsMenu("MiniSitePagesName") & "</a>"
            End If
			Output = Output & "</li>"
	
			v = v + 1
		objRsMenu.MoveNext
	Loop
	
	
		Output = Output & "<ul>"
	
	CloseDB(objRsMenu)
	
	MiniSiteMenu = Output

End Function


Function contactform()
temp = "<form action=""?mode=send"" class=""_validate"" method=""post"" id=""ContactForm"">"
	            
		If Request.QueryString("mode") = "send" then
		 	print "נשלח בהצלחה"
           response.Redirect("http://www.google.co.il")
            exit function

		end if
		
			TemplateContact = templatelocation & "MiniSite/" & "contactform.html" 

		temp = temp & Trim(GetURL(TemplateContact))
        temp = temp & "</form>"
        contactform = temp
End Function

If lcase(Request.querystring("p")) = "admin" Then
response.redirect("admin/")
end if

If Request.Querystring("ID") = "" Then
    If Request.Querystring("p") = "" Then
        AddMiniSiteName = True
	    SQL = "SELECT * FROM MiniSitePages WHERE MiniSiteID=" & MiniSiteID 
	Else
        AddMiniSiteName = False
        SQL = "SELECT * FROM MiniSitePages WHERE MiniSiteID=" & MiniSiteID & " And urltext='" & Trim(Replace(Request.QueryString("p"),"-"," ")) & "'"
    End If
Else 
	SQL = "SELECT * FROM MiniSitePages WHERE MiniSitePagesID = " & Request.QueryString("ID") & " And SiteID=" & SiteID
End If
			Set objRs = OpenDB(SQL)
			
			Session("UsersID")= objRs("UsersID")
			If objRs.RecordCount = 0 Then
				header
				Response.Write("<div id=""errormeseage"">כנראה נפלה טעות בכתובת חזור לעמוד הבית נסה שנית!</div>")
				bottom
				response.end
			End If
			
			'	LogDisplay "MiniSitePages", objRs("MiniSitePagesName") 

		SqlMiniSite = "SELECT MiniSiteTemplate FROM MiniSite WHERE MiniSiteID = " & MiniSiteID & " And SiteID=" & SiteID
	'	print SqlMiniSite
        Set objRsMiniSite = OpenDB(SqlMiniSite)
		
            TemplateURL = objRsMiniSite("MiniSiteTemplate") 
        
         objRsMiniSite.Close

			SetSession "BackURL", objRs("urltext")
		'	SetSession "contentiD", objRs("MiniSitePageID")
		'	CheckUserSecurity_Level objRs("MiniSitePage9Level"),objRs("MiniSitePageSecurityTarget")
			
			SetPageTitle ""
            If objRs("PageTitle") = "" OR objRs("PageTitle") = NULL Then
			    SetPageTitle MiniSiteTitle
            Else
			    SetPageTitle objRs("PageTitle")
            End If
			SetPageDesc ""
            If objRs("PageDescription") = "" OR objRs("PageDescription") = NULL Then
			    SetPageDesc MiniSiteDescription
            Else
			    SetPageDesc objRs("PageDescription")
            End If

			SetPagekeywords ""
            If objRs("Pagekeywords") = "" OR objRs("Pagekeywords") = NULL Then
			    SetPagekeywords MiniSitekeywords
            Else
			    SetPagekeywords objRs("Pagekeywords")
            End If



			'if objRs("MiniSitePageHeader") <> "" Then
			' 		ProcessLayout GetURL(templatelocation  & objRs("MiniSitePageHeader"))
			'else
		'		header
			'end if
			'MiniSitePagefooter = objRs("MiniSitePageFooter")

			If objRs.BOF And objRs.EOF Then 
							Response.write("<div id=""errormeseage"">")
							Response.write("כנראה נפלה טעות בכתובת חזור לעמוד הבית נסה שנית!")
							Response.write("</div>")
							Response.write("</div>")
			'Else
			'	if request.querystring("t")= "" then
			'		TemplateURL = templatelocation & "MiniSite/" & objRs("MiniSiteTemplate") 
			'	else
			'		TemplateURL = templatelocation  & request.querystring("t") & ".html" 
			end if
				
				
								
				'gallerypage = "/Sites/" &  Application(ScriptName & "ScriptPath") & "/layout/MiniSite/gallery/gallery.asp"				
				'			ddd=ExecutePage gallerypage
							
									Template = GetURL(TemplateURL)
										For Each Field In objRs.Fields
											value = objRs(Field.Name)
												If Len(value) > 0 Then
													Template = Replace(Template, "[" & Field.Name & "]", value)
													Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
													Template = Replace(Template, "[MiniSiteMenu]", MiniSiteMenu)
												'	Template = Replace(Template, "[contactform]", contactform)
											'		Template = Replace(Template, "[gallery]",ddd)
                                                    	        

												Else
													Template = Replace(Template, "[" & Field.Name & "]", "")
												End If
										Next
										
											 ProcessLayout(Template)
								
								%>
								   
								<%
											 	
				'objRs.MoveNext
				'	Loop

							
 			'	End If
 			
			objRs.Close
			
			'if MiniSitePagefooter  <> "" Then
			' 		ProcessLayout GetURL(templatelocation & MiniSitePagefooter)
		'	else
			'	bottom
		'	end if
	
	
	
	Session(SiteID & "PageTitle") = ""
	
%>
</div>