<!--#include file="config.asp"-->
<%		If Int(Request.QueryString("header")) = 1 Then
		Header
	End If
	
	    
	    
	ID = Int(Request.QueryString("id"))
	Table = LCase(Trim(Request.QueryString("table")))
	
	Set objRs = OpenDB("Select * From [" & Table & "] Where [" & Table & "]." & Table & "ID = " & ID)

	ProcessShowLayout(GetURL(TemplateLocation & "forms/" & objRs("template")))
	
	
	If Int(Request.QueryString("bottom")) = 1 Then
		Bottom
	End If

	Sub ProcessShowLayout(strTemplate)
		StartBlockPosition = InStr(strTemplate, "[")
		EndBlockPosition = InStr(strTemplate, "]")
		
		If StartBlockPosition = 0 Then
			Print Mid(strTemplate, 1) 
		Else
			Print Mid(strTemplate, 1, StartBlockPosition - 1) 
			Command = Mid(strTemplate, StartBlockPosition + 1, EndBlockPosition - (StartBlockPosition + 1))

			If Mid(Command, 1, 1) = "#" Then
				Command = LCase(Mid(Command, 2))
				Table2 = Mid(Command, 1, InStr(Command, "id") - 1)
				Set objRs2 = OpenDB("Select " & Table2  & "Name From [" & Table2 & "] Where " & Command & " = " & objRs(Command))
				Print objRs2(0)
				CloseDB(objRs2)
			Else
				Print objRs(Command)
			End If
			
			ProcessShowLayout Mid(strTemplate, EndBlockPosition + 1)
		End If
	End Sub	
	
	CloseDB(objRs)
	
%>