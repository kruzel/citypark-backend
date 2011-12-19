Function GetMenu(ID)
	Set objRsMenuCategory = OpenDB("Select * From [MenuCategory] Where MenuCategoryID = " & ID)
	
	If objRsMenuCategory.RecordCount = 0 Then
		GetMenu = "×?×₪×¨×™×˜ ×‘×¢×? ×?×¡×₪×¨ ×™×—×•×“×™ " & ID & " ×?× × ×?×¦× ×‘×?×¢×¨×›×?."
		Exit Function
	End If
	
	Set objRsMenu = OpenDB("Select * From [Menu] Where MenuFatherName = 0  AND SiteID = " & SiteID & " AND LangID = " & Session("SiteLang") & " ORDER BY MenuPosition ASC")

	If objRsMenu.RecordCount = 0 Then
		GetMenu = "×?× × ×?×¦××• ×›×₪×?×•×¨×™× ×‘×?×₪×¨×™×˜ ×‘×¢×? ×?×¡×₪×¨ ×™×—×•×“×™  " & ID
		Exit Function
	End If
	
	If Int(objRsMenuCategory("MenuCategoryType")) = 1 Then
		Output = "<script type=""text/javascript"" src=""/js/dropdown.js""></script>" & vbcrlf
		Output = Output & "<div id=""MenuContainer" & ID & """><table cellspacing=""0"" id=""nav"">" & vbcrlf
	Else
		Output ="<script type=""text/javascript"" src=""/js/dropdown2.js""></script>" & vbcrlf
		Output = Output & "<div id=""MenuContainer" & ID & """><table id=""navs"">" & vbcrlf
	End if

	If Int(objRsMenuCategory("MenuCategoryType")) = 1 Then
		Output = Output & "<tr>" & vbcrlf
	End If
	
	v = 1
	
	Do Until objRsMenu.Eof
		If Not IsNull(Trim(objRsMenu("MenuCategoryID"))) Then
			IDArray = Split(objRsMenu("MenuCategoryID"), ",")
			
			Continue = False
			
			For Each TheID In IDArray
				If Int(TheID) = ID Then Continue = True
			Next
			
			If Continue Then
				Set objRsMenu2 = OpenDB("SELECT * FROM Menu WHERE  MenuFatherName = " & objRsMenu("MenuID")  & " AND SiteID = " & Session("S") & " AND LangID = " & Session("SiteLang")  & " ORDER BY MenuPosition ASC")
	
			If Int(objRsMenuCategory("MenuCategoryType")) = 2 Then
				Output = Output & "<tr>"
			End If
			
			Output = Output & "<td class=""" 
			
			If objRsMenu.AbsolutePosition = 1 Then
				Output = Output & "first"
			ElseIf objRsMenu.AbsolutePosition = objRsMenu.RecordCount Then
				Output = Output & "last"
			Else
				Output = Output & "btn" & v
			End If
			If url = "/" & objRsMenu("MenuLink") Or LCase(Request.QueryString("p")) = Replace(objRsMenu("MenuName"), " ", "-") Then
				Output = Output & " active""" 
				Output = Output & " id=""btn" & v & "active"""
			End If
			
			Output = Output & """>"
			
			MenuLink = objRsMenu("MenuLink")
			
			If Mid(MenuLink, 1, Len("http://")) <> "http://" And Mid(MenuLink, 1, 1) <> "/" Then
				MenuLink = "/" & MenuLink
			End If

			If getconfig("EnableMenuBread") = 1  then
				If  Left(MenuLink,4)<> "http" Then
					Output = Output & "<a href=""" & MenuLink & "&tm=" & objRsMenu("MenuID") & """>" & objRsMenu("MenuName") & "</a>"
				Else
					Output = Output & "<a href=""" & MenuLink & """>" & objRsMenu("MenuName") & "</a>"
				End if
				
			Else
			       If objRsMenu("openinnewwindow") = True Then
					    Output = Output & "<a href=""" & MenuLink & """ target=""_blank"">" & objRsMenu("MenuName") & "</a>"
					Else
						Output = Output & "<a href=""" & MenuLink & """>" & objRsMenu("MenuName") & "</a>"
					End If
			End If		
			
			If objRsMenu2.RecordCount > 0 Then 
				Output = Output & "<ul>"
			
				Do Until objRsMenu2.Eof
					Output = Output & "<li>"
	
					If URL = "/" & objRsMenu2("MenuLink") Or LCase(Request.QueryString("p")) = Replace(objRsMenu2("MenuName"), " ", "-") Then
				'		Output = Output & " class=""active"""
					End If
					
					MenuLink2 = objRsMenu2("MenuLink")
			
					If Mid(MenuLink2, 1, Len("http://")) <> "http://" And Mid(MenuLink2, 1, 1) <> "/" Then
						MenuLink2 = "/" & MenuLink2
					End If

					If getconfig("EnableMenuBread") = 1 then
							Output = Output & "><a href=""" & MenuLink2  & "&tm=" & objRsMenu("MenuID")  & "&m=" & objRsMenu2("MenuID") & """>" & objRsMenu2("MenuName") & "</a></li>"
					Else
						If objRsMenu2("openinnewwindow") = True Then
					        Output = Output & "<a href=""" & MenuLink2 & """ target=""_blank"">" & objRsMenu2("MenuName") & "</a>"
					    Else
						    Output = Output & "<a href=""" & MenuLink2 & """>" & objRsMenu2("MenuName") & "</a>"
					    End If
	'Output = Output & "><a href=""" & MenuLink2 & """>" & objRsMenu2("MenuName") & "</a></li>"
					End if
					
					objRsMenu2.MoveNext
				Loop
			
				Output = Output & "</ul>"
			End If
	
			Output = Output & "</td>" & vbcrlf
			
			If Int(objRsMenuCategory("MenuCategoryType")) = 2 Then
				Output = Output & "</tr>"
			End If
			
			v = v + 1
			
			CloseDB(objRsMenu2)
			
			End If
		End If
					
		objRsMenu.MoveNext
	Loop
	
	If Int(objRsMenuCategory("MenuCategoryType")) = 1 Then
		Output = Output & "</tr>"
	End If
	
	Output = Output & "</table></div>"
	
	CloseDB(objRsMenu)
	CloseDB(objRsMenuCategory)
	
	GetMenu = Output
End Function
