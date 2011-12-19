<!--#include file="config.asp"-->

<%
Function GetMenu(ID)
	Set objRsMenuCategory = OpenDB("Select * From [Menu] Where ID = " & ID)
	Session("menutype") = objRsMenuCategory("Type")
	If objRsMenuCategory.RecordCount = 0 Then
		print  "תפריט  " & ID & " לא נמצא במערכת."
		Exit Function
	End If
	    If Int(objRsMenuCategory("Type")) = 1 Then
           print vbcrlf &  "<ul class=""sf-menu" & ID & """>"& vbcrlf
        End If
        If Int(objRsMenuCategory("Type")) = 2 Then
            print vbcrlf &  "<ul class=""sf-menu" & ID & " sf-vertical"">"& vbcrlf
        End If
        If Int(objRsMenuCategory("Type")) =3 Then 'from template
            ProcessLayout(GetURL(objRsMenuCategory("Header")))
            ' ProcessLayout(GetURL(objRsMenuCategory("Template")))
                     buildtree 0, ID
            ProcessLayout(GetURL(objRsMenuCategory("Footer")))
     ' response.end
        End If
    
    
        If Int(objRsMenuCategory("Type")) <> 3 Then 'from template
             buildtree 0, ID
             print "</ul>"
        End if
	CloseDB(objRsMenuCategory)
End Function

Function buildtree(Fid, menu)
        SQLm = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE   LangID = '" & Session("SiteLang") & "' AND (Contentfather.FatherID = " & Fid & ") AND (Content.SiteID = " & SiteID & ") AND (Menus != '') ORDER By Menusorder ASC"
           Set objRsm = OpenDB(SQLm)
	If objRsm.RecordCount = 0 Then
		 print   "לא נמצאו כפתורים בתפריט בעל מספר יחודי  " & Fid
		   Exit Function
	End If
    v=1
       
        Do while Not objRsm.EOF
        If Not IsNull(Trim(objRsm("Menus"))) Then
			IDArray = Split(objRsm("Menus"), ",")
			
			Continue = False
			
			For Each TheID In IDArray
				If Int(TheID) = menu Then Continue = True
			Next
			If v = 1 Then
				x= "first"
			ElseIf objRsm.AbsolutePosition = objRsm.RecordCount Then
				x= "last"
			Else
				x= "btn" & v
			End If
            y=""
            If    Url ="/Default.asp" AND Getconfig("HomePageID") = objRsm("id") Or LCase(Request.QueryString("p")) = Replace(LCase(objRsm("Urltext")), " ", "-") Then
              
              
              
              
              
                If Session("menutype") = 3 Then
                    y =  " expand"
                Else
                    y =  " active"
                End if
			End If

			If Continue Then
            Urltext = objRsm("Urltext")
                        slash = ""
                    If Urltext <> "/" then
                        slash = "/"
                    End If 
                If Left(Urltext,4) = "http" then
                        slash = ""
                End if
                        If objRsm("Menuislink") = True Then
		                    print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & slash & ReplaceSpaces(Urltext) & """>" & objRsm("Menusname") & "</a>"
                        Else
		                    print vbCrLf & "  <li class=""" & x &  y & """><a style=""cursor:default;"" href=""#"">" & objRsm("Menusname") & "</a>"
                        End If
            End If
        End If
                SQLson = "SELECT TOP 1 [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE LangID = '" & Session("SiteLang") & "' AND (Contentfather.FatherID = " & objRsm("id") & ") AND (Content.SiteID = " & SiteID & ")AND  (Menus != '') ORDER By Menusorder ASC"
                Set objRsSon = OpenDB(SQLson)
                     If objRsSon.Recordcount > 0 Then
                       If Continue Then
                                   If Session("menutype") = 3 Then
                                        Set objRsfa =  OpenDB("SELECT * FROM [Contentfather]  WHERE ContentID=" &  GetSession("contentiD"))
                                            If objRsfa("FatherID")= objRsm("Id") then
                                                 actives = " expand" 
                                            Else
                                                 actives = " acitem" 
                                            End If
                                        CloseDB(objRsfa)  
                                          
                                        print  vbCrLf & "    <ul class=" & actives & ">" 
                                   Else
                                        print  vbCrLf & "    <ul>" 
                                    End if
                        End if
                            buildtree objRsm("id"), menu 
                            If Continue Then
                                print "</li>" & vbCrLf
                            End If  
                    Else
                            If Continue Then
                                print "</li>" & vbCrLf
                            End if
                    End if
			    If Continue Then
                    v=v+1
                End If
        objRsm.MoveNext
	        Loop
    If Continue Then
        print "</ul>" & vbCrLf
	End If            		
	    CloseDB(objRsm)		
End Function
%>