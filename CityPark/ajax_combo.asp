<!--#include file="config.asp"-->
<%
Field = Request.QueryString("field")
Table = Mid(Request.QueryString("Son"), 1, Len(Request.QueryString("Son")) - 2)
Value = Request.QueryString("value")

SQL = "Select " & Request.QueryString("Son") & "," & Table & "Name From [" & Table & "] Where " & Field & " = '" & Value & "' And SiteID = " & SiteID
Set objRs = OpenDB(SQL)
IsFirst = True
Do Until objRs.Eof
	
	If Not IsFirst Then
		Print ";"
	Else
		IsFirst = False
	End If
	
	Print objRs(0) & "," & objRs(Table & "Name")

	objRs.MoveNext	
Loop
	
CloseDB(objRs)
%>