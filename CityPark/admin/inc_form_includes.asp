<%
Function GetSQL(Table, Mode, ID)
	Select Case Mode
		Case "add"
			SQL = "Insert Into [" & Table & "] ("	
		
			First = True
		
			For Each x In Request.Form
			
				If x <> "IsSubmitted" Then
					If First Then
						First = False
					Else
						SQL = SQL & ", "
					End If
					
					SQL = SQL & "[" & Table & "]." & x
				End If
			Next
			
			SQL = SQL & ", " & "[" & Table & "].SiteID) Values ("
			
			First = True

			For Each x In Request.Form
				If x <> "IsSubmitted" Then
					If First Then
						First = False
					Else
						SQL = SQL & ", "
					End If
					
					SQL = SQL & "'" & Request.Form(x) & "'"
				End If
			Next
			
			SQL = SQL & ", " & SiteID & ");"
		
		Case "update"
			SQL = "Update [" & Table & "] Set "	
		
			First = True
		
			For Each x In Request.Form
				If x <> "IsSubmitted" And x <> "ID" Then
					If First Then First = False Else SQL = SQL & ", "
					
					SQL = SQL & "[" & Table & "]." & x & " = '" & Request.Form(x) & "'"
				End If
			Next
			
			SQL = SQL & " Where [" & Table & "]." & Table & "ID = " & ID & ";"
			
		Case "delete"
			SQL = "Delete From [" & Table & "] Where [" & Table & "]." & Table & "ID = " & ID & ";"
	End Select
	
	GetSQL = SQL
End Function

Function GetHiddenFields(Mode, ID)
	Value = "<input type=""hidden"" name=""IsSubmitted"" value=""true"" />"
	If Mode = "update" Then Value = Value & "<input type=""hidden"" name=""ID"" value=""" & ID & """ />"
	
	GetHiddenFields = Value
End Function

Function GetValue(Name, RecordSet, Mode)
	If Mode = "update" Then
		GetValue = RecordSet(Name)
	End If
End Function
%>
