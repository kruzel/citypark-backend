<!--#include file="config.asp"-->

<%	
session("pagetype") = "content"

SQLstat = "SELECT Clicks FROM [Site] WHERE SiteID=" & SiteID
Set objRsstat = OpenDB(SQLstat)
objRsstat("Clicks") = objRsstat("Clicks") + 1
objRsstat.Update
Closedb(objRsstat)

If lcase(Request.querystring("p")) = "admin" Then
response.redirect("admin/")
end if
If lcase(Request.querystring("p")) = "user" Then
response.redirect("user/")
end if
SQL = "SELECT * FROM [CITYPARK].[dbo].[Content] WHERE "

If Request.QueryString("ID") <> "" Then
	SQL = SQL & "Id =" & Request.QueryString("ID")
ElseIf Request.QueryString("p") <> "" Then
	SQL = SQL & "urltext ='" & Trim(Replace(Request.QueryString("p"),"-"," ")) & "'"
Else
	SQL = SQL & "Id =" & Session(SiteID & "HomeQSID")
End If

SQL = SQL & " AND [Content].SiteId =" & SiteID

			Set objRs = OpenDB(SQL)

			If objRs.RecordCount = 0 Then
				'Response.status = "404 Not Found" 
			    'Response.AddHeader "Location", "404.htm"
               print Request.QueryString("p")+"<div><h2>the page not found</h2></div><br>"+SQL
				response.end
			End If

			SetSession "contentiD", objRs("id")


            objRs("Count") = objRs("Count") + 1
            objRs.Update
If objRs("Contenttype") <> 7 then  			
    iF Getconfig("Cache") = True then
	    if (InStr(1,lcase(Request.ServerVariables("PATH_INFO")),"/admin/") = 0) then
		    Dim objCache
			    Set objCache = New CPageCache 
			    objCache.CacheIntervalUnit = CI_DAYS'CI_MINUTES
			    objCache.CacheIntervalLength =1
			    objCache.AutoCacheToFile()
	    end if
    End if
 End if
			If objRs("Active") = 0 Then
				header
				Response.Write("<div id=""errormeseage"">העמוד אינו פעיל יש לפנות למנהל האתר!</div>")
				bottom
				response.end
			End If
				'LogDisplay "content", objRs("name") 

		SQLTemplate = "SELECT * FROM template WHERE Id = " & objRs("Template") & " And SiteID=" & SiteID

			Set objRstemplate = OpenDB(SQLTemplate)
			Session("SiteLang") = objRstemplate("LangID")
			SetSession "BackURL", "/" & objRs("urltext")
                Session(SiteID & "BackURL") = Replace(Session(SiteID & "BackURL"),"//","/")
			CheckUserSecurity_Level objRs("UserLevel"),objRs("usersecuritytarget")
			If SiteID = 54 then
				If Int(objRs("UserLevel")) < 6 then
					CheckUserCategorySecuirty(objRs("id"))
				End if
			End if
			
			SetPageTitle ""
			SetPageTitle objRs("Title")
			SetPageDesc ""
			SetPageDesc objRs("Description")
			SetPagekeywords ""
			SetPagekeywords objRs("keywords")
            urlfacebook = LCase(Request.ServerVariables("HTTP_HOST")) & ReplaceSpaces(GetSession("BackUrl"))

			if objRstemplate("Header") <> "" Then
			 		ProcessLayout GetURL(objRstemplate("Header"))
			else
				header
			end if

			If objRs.BOF And objRs.EOF Then 
							Response.write("<div id=""errormeseage"">")
							Response.write("כנראה נפלה טעות בכתובת חזור לעמוד הבית נסה שנית!")
							Response.write("</div>")
							Response.write("</div>")
			 Else
				if request.querystring("t")= "" then
					TemplateURL =  objRstemplate("Template") 
				else
					TemplateURL = templatelocation  & request.querystring("t") & ".html" 
				end if


If objRs("Contenttype") = 1 then    'עמוד תוכן
        If objRs("CreateadminID") <> "" then
            Sqladmin="Select * FROM Admin Where Id = " & objRs("CreateadminID")
            Set objRsadmin=OpenDB(Sqladmin)
                If objRsadmin.recordcount > 0 then
                    Adminname = objRsadmin("Name") 
                End If
             CloseDB(objRsadmin)
        End if
				   Template = GetURL(TemplateURL)
					For Each Field In objRs.Fields
					value = objRs(Field.Name)
						If Len(value) > 0 Then
                            If Field.Name = "Text" then
							    Template = Replace(Template, "[Text]", Autolink(value))
                            Else
							    Template = Replace(Template, "[" & Field.Name & "]", value)
							    Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							    Template = Replace(Template, "[Adminname]", Adminname)
                            End If
						Else
							    Template = Replace(Template, "[urlfacebook]",urlfacebook)
							    Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
					Next
							 ProcessLayout(Template)
								
							
 		End If
End if


If objRs("Contenttype") = 2 then    'מוצרים
			        'start futures
			       Function BringFutures
						If 	objRs("other7")<> "" Then
								IDArray = Split(objRs("other7"), ",")
									
								For Each TheID In IDArray 							
			                    
			                    Set objRsFutereName = OpenDB("Select ProductFeaturesGroupName,ProductFeaturesGroupTipe From ProductFeaturesGroup WHERE ProductFeaturesGroupID=" & TheID)
				                FeaturesGroupName = objRsFutereName("ProductFeaturesGroupName")
				                FeaturesGroupTipe = objRsFutereName("ProductFeaturesGroupTipe")
				                CloseDB(objRsFutereName)
				                
				                SQLfutures = "SELECT * FROM ProductFeatures WHERE ProductFeaturesGroupID ="  & TheID & " And SiteID=" & SiteID
			                    Set objRsfutures = OpenDB(SQLfutures)
			                    BringFutures = BringFutures & "<div class=""futuresgroup""><b>" & FeaturesGroupName & "</b></div>"
			                    Select Case FeaturesGroupTipe
			                     Case "radio" 
			                       Do Until objRsfutures.Eof
			                            BringFutures = BringFutures & "<div class=""futuresradio""><img src=" & objRsfutures("ProductFeaturesImage") & " width =""20px"" hight=""20px"" /><input value=" & objRsfutures("ProductFeaturesID") & " type=""radio"" name=""Featuresnumber" & TheID & """> " & objRsfutures("ProductFeaturesName") & "   ₪" & objRsfutures("ProductFeaturesPrice")  &  "   </div>"
			 				            objRsfutures.MoveNext
					                Loop
					              Case "combo"
			                            BringFutures = BringFutures & "<div class=""futurescombo""><Select name=""Featuresnumber" & TheID & """></div>"
				                       Do Until objRsfutures.Eof
			                            BringFutures = BringFutures & "<option value=" & objRsfutures("ProductFeaturesID") & ">" & objRsfutures("ProductFeaturesName") &  "--" & objRsfutures("ProductFeaturesPrice") & "₪</option>"
			                    
			 				            objRsfutures.MoveNext
					                Loop
			                            BringFutures = BringFutures & "<div></Select></div>"
					              End Select

			                    CloseDb(objRsfutures)
			              Next
			            End If

			      End Function
			 'end futures
             'start Relatedproducts

			       Function Relatedproducts
                   If 	objRs("other8")<> "" Or objRs("other8")<> NULL Then
								Relatedproducts = "<div class=""relatedborder"">מוצרים קשורים</div>"
								IDArray = Split(objRs("other8"), ",")
								If UBound(IDArray) >= 0 then
                                    For Each TheID In IDArray
			                        Set objRsRelatedproducts = OpenDB("Select * FROM Content Where Contenttype = 2 AND ID=" & TheID)
									If objRsRelatedproducts.recordcount > 0 Then
										Relatedproducts = Relatedproducts & "<div class=""Relatedproducts""><h3><a class=""title"" href="""& objRsRelatedproducts("Urltext") & """>" & objRsRelatedproducts("Name") & "</a></h3><img src=""" & objRsRelatedproducts("Image") & """ /><p>מחיר:" &objRsRelatedproducts("Other1")& "<span>₪</span></p><a class=""more"" href=""" & objRsRelatedproducts("Urltext")  & """></a></div>"
                                    End if
									CloseDB(objRsRelatedproducts)
                                    Next
                                End if
                   End if
                   End Function
				   
			       Function nilvim
                   If 	objRs("nilvim")<> "" Or objRs("nilvim")<> NULL Then
								nilvim = "<div class=""relatedborder"">מוצרים נילוים</div>"
								IDArray = Split(objRs("nilvim"), ",")
								If UBound(IDArray) >= 0 then
                                    For Each TheID In IDArray
			                        Set objRsRelatedproducts = OpenDB("Select * FROM Content Where Contenttype = 2 AND ID=" & TheID)
									If objRsRelatedproducts.recordcount > 0 Then
										nilvim = nilvim & "<div class=""Relatedproducts""><h3><a class=""title"" href="""& objRsRelatedproducts("Urltext") & """>" & objRsRelatedproducts("Name") & "</a></h3><img src=""" & objRsRelatedproducts("Image") & """ /><p>מחיר:" &objRsRelatedproducts("Other1")& "<span>₪</span></p><input rel='"& objRsRelatedproducts("Name")&"' type='checkbox' id='nilve"&TheID&"' title='"&objRsRelatedproducts("Other1")&"' class='nilve'>הוסף לסל</div>"
                                    End if
									CloseDB(objRsRelatedproducts)
                                    Next
                                End if
                   End if
                   End Function
            'end Relatedproducts
			       Function shipingperproduct
						
							If objRs("mishloaj") <> "" Then
							shipingperproduct = "<div class=""futurescombo""><Select class=""shipingperproduct required"" Name=""shipingperproduct"">"
							shipingperproduct = shipingperproduct & "<option value="""">בחר צורת משלוח</option>"

								IDArray = Split(objRs("mishloaj"), ",")
								If UBound(IDArray) >= 0 then
                                    For Each TheID In IDArray
			                        Set objRsshipingperproduct = OpenDB("Select * FROM ShipingPerProduct Where SiteId = " & SiteID & " AND Id=" & TheID)
                                    shipingperproduct = shipingperproduct & "<option value=""" & objRsshipingperproduct("Id") & """>" & objRsshipingperproduct("Name") & " - " & objRsshipingperproduct("alut") & "₪</option>"
                                    CloseDB(objRsshipingperproduct)
                                    Next
                                End if
							shipingperproduct = shipingperproduct & "</select></div>"
							End if
						
				   End Function
			
			'start shiping per product
        If objRs("CreateadminID") <> "" then
            Sqladmin="Select * FROM Admin Where Id = " & objRs("CreateadminID")
            Set objRsadmin=OpenDB(Sqladmin)
                Adminname = objRsadmin("Name") 
             CloseDB(objRsadmin)
        End if
				   Template = GetURL(TemplateURL)
                Print "<form action=""newcart.asp?mode=add"" method=""post"" class=""_validate"">"
				Print "<input Type=""hidden"" Name=""mode"" value=""add"">"
				Print "<input Type=""hidden"" Name=""productID"" value=""" & objRs("Id")& """>"
				Print "<input Type=""hidden"" Name=""name"" value=""" & objRs("Name")& """>"
				Print "<input Type=""hidden"" Name=""price"" value=""" & objRs("other1")& """>"

					For Each Field In objRs.Fields
					value = objRs(Field.Name)
						If Len(value) > 0 Then
                             If Field.Name = "Text" then
							    Template = Replace(Template, "[Text]", Autolink(value))
                            Else
							    Template = Replace(Template, "[" & Field.Name & "]", value)
							    Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							    Template = Replace(Template, "[Adminname]", Adminname)
                            End if
						Else
							Template = Replace(Template, "[urlfacebook]",urlfacebook)
							Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
                            Template = Replace(Template, "[futures]", BringFutures)
							
                            Template = Replace(Template, "[shipingperproduct]", shipingperproduct)
                            Template = Replace(Template, "[Relatedproducts]", Relatedproducts)
                            Template = Replace(Template, "[nilvim]", nilvim)
                    Next
                            Template = Replace(Template, "[showreviews]", Showreviews)
                             ProcessLayout(Template)
								
				Print "</form>"
		
End If


If objRs("Contenttype") = 4 then    'גלרייה
   Template = GetURL(objRs("other3"))
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
							 ProcessLayout(Template)
   
    If objRs("other5") = 1 then  ' להציג את כל הספרייה
        Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
        Set MyFolder=MyFileObject.GetFolder(phisicalpath & Getconfig("Sitename") & "\content\images\" & objRs("other1") & "\" )
		i=1
		FOR EACH thing in MyFolder.Files
			        FileName=thing.Name
			        imagelink= "sites/" & Getconfig("Sitename") & "/content/images/" & objRs("other1") & "/" & FileName
					    Template = GetURL(objRs("other2"))
                        Template = Replace(Template, "[Image]", imagelink)
						Template = Replace(Template, "[Name]", FileName)
						Template = Replace(Template, "[Pid]", i)
			 		ProcessLayout(Template)
                i=i+1
				Next
    Else
        SQLp = "SELECT * FROM [Photos] WHERE PhotosgalleryID=" & objRs("Id") & " Order By Itemorder Asc"
        Set objRsP = OpenDB(SQLp)
			If objRsP.RecordCount = 0 Then
				print "אין תמונות"
            Else
			           i=1
                        Do While NOT objRsP.Eof
                                            Templateg = GetURL(objRs("other2"))
            		            For Each Field In objRsP.Fields
					                value = objRsP(Field.Name)
                    	                If Len(value) > 0 Then
							                Templateg = Replace(Templateg, "[" & Field.Name & "]", value)
							                Templateg = Replace(Templateg, "[/" & Field.Name & "]", ReplaceSpaces(value))
							                Templateg = Replace(Templateg, "[Pid]", i)
						                Else
							                Templateg = Replace(Templateg, "[" & Field.Name & "]", "")
						                End If
					            Next
							 ProcessLayout(Templateg)
                             i=i+1
                        objRsP.movenext
                            loop
            End If
    End If


	ProcessLayout GetURL(objRs("other4"))
End if
If objRs("Contenttype") = 5 then    'גלריית וידיאו
      Template = GetURL(objRs("other3"))
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
							 ProcessLayout(Template)
        SQLp = "SELECT * FROM [Videos] WHERE VideogalleryID=" & objRs("Id") & " Order By " & objRs("other6")
        Set objRsP = OpenDB(SQLp)
			If objRsP.RecordCount = 0 Then
				print "אין סרטונים"
            Else
			           i=1
                        Do While NOT objRsP.Eof
                                            Template = GetURL(objRs("other2"))
            		            For Each Field In objRsP.Fields
					                value = objRsP(Field.Name)
                    	                If Len(value) > 0 Then
							                Template = Replace(Template, "[" & Field.Name & "]", value)
							                Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
						                Else
							                Template = Replace(Template, "[" & Field.Name & "]", "")
						                End If
					            Next
							 ProcessLayout(Template)
                             i=i+1
                        objRsP.movenext
                            loop
            End If


	ProcessLayout GetURL(objRs("other4"))
End if




If objRs("Contenttype") = 6 then    'סרטון וידיאו
                        Do While NOT objRs.Eof
				   Template = GetURL(TemplateURL)
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
                        objRs.movenext
                            loop


End if

If objRs("Contenttype") = 7 then    'טופס
%>
<!--#include file="inc_sendmail.asp"-->
<% 

If Request.querystring("mode") = "doit"  then
    Text2Send = "<div style""direction:rtl;""><table dir=""rtl"">"
    Set msg = CreateObject("Scripting.Dictionary")

        For Each x In Request.Form
             If x <> "B2" then
                msg.Add x, Request.Form(x)
            End if
        next

Function GetValue(str)
	GetValue = """" & Replace(str, """", """""") & """"
End Function

Function RemoveQuotes(str)
    str = Replace(str,","," ")
   ' str = Replace(str,""","")
	RemoveQuotes = str 'Replace(Mid(str, 2, Len(str) - 2), """""", """")

End Function

    Set fs = CreateObject("Scripting.FileSystemObject")
        If fs.FileExists(Server.MapPath("/data/" & objRs(0) & ".csv")) Then
	        set j = fs.OpenTextFile(Server.MapPath("/data/" & objRs(0) & ".csv"), 1)
	        p = Split(j.ReadAll, vbCrLF)
	            If LCase(RemoveQuotes(Split(p(0), ",")(0))) = "id" Then
		            kid = Int(RemoveQuotes(Split(p(UBound(p)), ",")(0))) + 1
	            End If
	            j.Close
        Else
	            kid = 0
	            y = 1
	            line = line & """ID"","
	            
                For Each x In msg
		            line = line & GetValue(x)
		                If y < msg.Count Then line = line & ","
		                    y = y + 1
	            Next
        End If

            set f = fs.OpenTextFile(Server.MapPath("/data/" & objRs(0) & ".csv"), 8, true)
                If line <> "" Then
	                f.Write(line)
	                line = ""
                End If

                    y = 1
                    line = line & """" & kid & ""","

                For Each x In msg
	                line = line & GetValue(msg(x))
	                    If y < msg.Count Then line = line & ","
	                    y = y + 1
                    Next
                    f.Write(vbCrLF & line)
                        line = ""

                f.Close
            set f=Nothing
            set fs=Nothing

            For Each x In msg
                Text2Send = Text2Send & "<tr><td>"  & x & " : " & msg(x) & " </td></tr>"
            Next
                Text2Send = Text2Send & "</table></div>"
        If objRs("other1") <> "" then  'איממיל מנהל
            If SendMail("התקבלה תגובה מטופס-" & objRs("Name"),"mailer@outbox.info", objRs("other1"), Text2Send) = True Then
                 print objRs("other3")
            end if
        End if

        If objRs("other2") <> "" then  'איממיל לקוח
            If SendMail("Thank You","mailer@outbox.info", Request.Form(objRs("other2")), Text2Send) = True Then
           ' print "נשלח אישור ל:" & Request.Form(objRs("other2"))
            End if
        End if


		Response.Write("<meta http-equiv=Refresh content=""" & objRs("other5") & "; URL=" & objRs("other4") & """>")
'////////////////////  להדפיס שאלון /////////////////////////
If objRs("other6") = "2" then 'שאלון
Template = GetURL(templatelocation & "answer.html")
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
		print "<div class=""customform customform" & objRs("Id") & """>"&vbcrlf
        '////////////////////תשובות לשאלון////////////////
    If Request.querystring("type") = "answer" then
            SQLa = "SELECT * FROM Customformanswers WHERE CustomformID= " & Request.QueryString("FormId") & " AND SiteID=" & SiteID
                 Set objRsa = OpenDB(SQLa)
	                If objRsa.RecordCount = 0 Then
                        print "אין תשובות לשאלון זה"
	                Else
                        score = 0
                        For Each x In Request.Form
                            If x <> "B2" then
                                If Request.Form(x) = "on" then 
                                    score = score +  1
                                Else
                                    score = score +  Request.Form(x)
                                End if
                            End if
                        next
                SQLanswer ="Select * From Customformanswers WHERE CustomformID=" & Request.QueryString("FormId")
                Set objRsanswer = OpenDB(SQLanswer)
                     Do While NOT objRsanswer.EOF
                        If objRsanswer("Minscore") <= score AND objRsanswer("Maxscore") >= score Then
                            print "<Div Class=""Answer"">" & objRsanswer("Answer") & "</Div>"
                        End if
                    objRsanswer.Movenext
                        Loop
                CloseDB(objRsanswer)
                    End if

    End if
'//////////////////// סוף תשובות לשאלון////////////////
		print "</div>"
end if
Else
				   Template = GetURL(TemplateURL)
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
  If objRs("other6") = "1" then 'טופס
		print "<form action=""" & objRs("Urltext") & "&mode=doit"" method=""post"" id=""ContactFormpage"" class=""_validate"">"&vbcrlf
  Else 
        print "<form action=""" & objRs("Urltext") & "&FormId=" & objRs("Id") & "&mode=doit&type=answer"" method=""post"" id=""ContactFormpage"" class=""_validate"">"&vbcrlf
 End if
		print "<div class=""customform customform" & objRs("Id") & """>"&vbcrlf
		SQLfield = "SELECT * FROM Customformfields WHERE CustomformID =" & objRs("Id") & " And SiteID=" & SiteID
		Set objRsfield = OpenDB(SQLfield)
        
        If objRsfield.recordcount > 1 Then
            Do while not objRsfield.EOF
            SQLfieldoptions = "SELECT * FROM Customformfieldsoptions WHERE CustomformfieldsID =" & objRsfield("Id") & " And SiteID=" & SiteID
            		    Set objRsfieldoptions = OpenDB(SQLfieldoptions)
                Select case objRsfield("Type")
                    case "text"
                        print "<div class=""question question" & objRs("Id")& """><p>" &  objRsfield("Name") & "</p><input  type=""" & objRsfield("Type") & """ id=""" & objRsfield("Name") & """ name=""" & objRsfield("Name") &""" class="""  & objRsfield("Required") & " " &objRsfield("Type") & """ style=""width:" & objRsfield("Width") & "px;direction:" & objRsfield("Direction") & ";""></div>" &vbcrlf 
                    case "texterea"
                        print "<div class=""question question" & objRs("Id")& """><p>" &  objRsfield("Name") & "</p><textarea rows=""6"" id=""" & objRsfield("Name") & """ name=""" & objRsfield("Name") &""" class="""  & objRsfield("Required") & " " &objRsfield("Type")   & """ style=""width:" & objRsfield("Width") & "px;direction:" & objRsfield("Direction") & ";"">" & objRsfield("value") & "</textarea></div>" &vbcrlf 
                    case "checkbox"
                            print "<div class=""question question" & objRs("Id")& """><p>" &  objRsfield("Name") & " " &  objRsfield("Text") &"</p><input type=""" & objRsfield("Type") & """ id=""" & objRsfield("Name") & """ name=""" & objRsfield("Name") &""""
                        
                       if objRsfield("value")= "selected" then
                            print    "checked=""checked"""
                        end if
                            print "></div>"&vbcrlf
                    case "radio"
                            print "<div class=""question question" & objRs("Id")& """><p>" &  objRsfield("Name") & "</p><ul>"&vbcrlf
                            If objRsfieldoptions.recordcount > 1 Then
                                Do Until objRsfieldoptions.Eof
			                         print "<li><input class=""" &  objRsfield("Required") & """ type=""radio"" value=""" & objRsfieldoptions("value") & """  name=""" & objRsfield("Name") & """" & objRsfieldoptions("selected") & " />" & objRsfieldoptions("Name") & "</li>" & vbcrlf
			                     objRsfieldoptions.MoveNext
				                    Loop
                            End if
                            print "</ul></div>"&vbcrlf
                    case "combo"
                            print "<div class=""question question" & objRs("Id")& """><p>" &  objRsfield("Name") & "</p><select name=""" &  objRsfield("Name") & """ width=""" & objRsfield("Width") & """>"&vbcrlf
                            If objRsfieldoptions.recordcount > 1 Then
                                Do Until objRsfieldoptions.Eof
			                        print "<option value=""" & objRsfieldoptions("value") & """"
                                        if objRsfieldoptions("selected")= "checked" then
                                            print    "selected=""selected"""
                                        end if
                                     print ">" & objRsfieldoptions("Name") & "</option>" &vbcrlf
			                     objRsfieldoptions.MoveNext
				                     Loop
                            End if
                                    print "</select></div>"&vbcrlf
                    Case "image"
		                Value = "/sites/" & Getconfig("Sitename") & "/Content/images/noimage.jpg"
			                Print "<div class=""question question" & objRs("Id")& """><p>" &  objRsfield("Name") & "</p><img id=""_" &  objRsfield("id") & """ src=""resize.asp?mappath=true&path=" & Value & "&width=80""/><input class=""" & objRsfield("Type") & " " &objRsfield("Type")   &  """ type=""hidden"" name=""" &  objRsfield("Name") & """ id=""v" &  objRsfield("id") & """ value=""" & Value & """ /><input id=""upload_button_" &  objRsfield("Name") & """ type=""button"" onclick=""AjaxUpload('" &  objRsfield("id") & "', 'img', 'image', 'images','"& Request.ServerVariables("HTTP_HOST")&"')"" value="""
				            Print "הוספת קובץ"
			                Print """ /></div>"&vbcrlf

		            Case "file"
		                Value = "/sites/" & Getconfig("Sitename") & "/Content/file/noimage.jpg"
			                Print "<div class=""question question" & objRs("Id")& """><p>" &  objRsfield("Name") & "</td></td><td><img id=""_" &  objRsfield("id") & """ src=""" & Value & """/><input type=""hidden"" name=""" &  objRsfield("Name") & """ id=""v" &  objRsfield("id") & """ value=""" & Value & """ /><input class=""" & objRsfield("Type") & """ id=""upload_button_" &  objRsfield("Name") & """ type=""button"" onclick=""AjaxUpload('" &  objRsfield("id") & "', 'img', 'file', 'File','"& Request.ServerVariables("HTTP_HOST")&"')"" value="""
				            Print "הוספת קובץ"
			                Print """ /></div>"&vbcrlf
		            Case "freetext"
				            Print  "<div class=""question question" & objRs("Id")& """>" & objRsfield("Value") & "</div>" &vbcrlf
        
                    End Select
        objRsfield.Movenext
        loop
        Else
        print "אין שדות"
        end if

        print "<input id=""send"" class=""send"  & objRs("Id")& """ type=""submit"" value=" & objRs("other7") &" name=""B2"">"&vbcrlf
		print "</div>"&vbcrlf
		print "</form>"&vbcrlf
      Closedb(objRsfieldoptions)
		Closedb(objRsfield)
End if
End if
'////////////// 3 level page ////////////////////
If objRs("Contenttype") = 8 then    'עמוד 3 רמות
   				   Template = GetURL(TemplateURL)
					For Each Field In objRs.Fields
					value = objRs(Field.Name)
						If Len(value) > 0 Then
                            If Field.Name = "Text" then
							    Template = Replace(Template, "[Text]", Autolink(value))
                            Else
							    Template = Replace(Template, "[" & Field.Name & "]", value)
							    Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
                            End If
						Else
							    Template = Replace(Template, "[" & Field.Name & "]", "")

						End If
					Next
							 ProcessLayout(Template)
buildtree2 objRs("Id"),1
    Function buildtree2(id,level)
       oldlevel = level
   SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & "   ORDER By ItemOrder ASC"
   Set objRst = OpenDB(SQL)
       sonTemplateURL = objRst("Sonstemplate")
        Do while Not objRst.EOF
                   sontemplate = GetURL(sonTemplateURL)
                    For Each Field In objRst.Fields
					             value = objRst(Field.Name)
						        If Len(value) > 0 Then
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", value)
							        sontemplate = Replace(sontemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
							        sontemplate = Replace(sontemplate, "[zebraclass]", zebraclass)
                                Else
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(sontemplate)
         SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRSt("id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1) AND (Showinsitemap = 1) ORDER By ItemOrder ASC"
   Set objRsSon = OpenDB(SQL2)
         If objRsSon.Recordcount > 0 AND level < 2 Then
                level =level + 1
                buildtree2 objRSt("id"),level
               level  = oldlevel

         End If 
                
   objRst.MoveNext
	  Loop
              level = oldlevel

	CloseDB(objRsSon)		
	CloseDB(objRst)		
    End Function
				   
End if

'//////////////End  3 level page ////////////////////

			CloseDB(objRs)
			
			if objRstemplate("footer")  <> "" Then
			 		ProcessLayout GetURL(objRstemplate("footer"))
			else
				bottom
			end if
	
		objRstemplate.Close
               
	
	Session(SiteID & "PageTitle") = ""
	
%>
