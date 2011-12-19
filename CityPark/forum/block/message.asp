<!--#include file="../config.asp"-->
<!--#include file="../inc_sendmail.asp"-->
<%
Set objRsForum = OpenDB("Select * From [Forums] Where ID = " & Request("ForumID"))
CheckSecurity_Level Int(objRsForum("WriteAccessLevel"))

Function GetSQL(Table, Mode, ID)
	Select Case Mode
		Case "add"
			SQL = "Insert Into [" & Table & "] ("	
		
			First = True
		
			For Each x In Request.Form
			
				If x <> "IsSubmitted" And x <> "m" And x <> "Submit" Then
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
				If x <> "IsSubmitted" And x <> "m" And x <> "Submit" Then
					If First Then
						First = False
					Else
						SQL = SQL & ", "
					End If
					
					If Request.Form(x) = "GetDate()" Then
					SQL = SQL & Request.Form(x) 
					Else
						SQL = SQL & "'" & Request.Form(x) & "'"

					End If
End If
			Next
			
			SQL = SQL & ", " & SiteID & ");"

		Case "edit"
			SQL = "Update [" & Table & "] Set "	
		
			First = True
		
			For Each x In Request.Form
				If x <> "IsSubmitted" And x <> "m" And x <> "ID" And x <> "Submit" Then
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

Mode = LCase(Request("m"))
ID = Int(Request("ID"))
Table = "ForumMessage"
If LCase(Request.Form("IsSubmitted")) = "true" Then
	SQL = GetSQL(Table, Mode, ID)
	ExecuteRS SQL
	If objRsForum("forumemail") <> "" Then
	messege = "התקבלה הודעה בפורום"
	   If SendMail(" התקבלה הודעה בפורום " & objRsForum("Name"), "אתר האינטרנט שלך", objRsForum("forumemail"),messege) = True Then
	   

	   End If
	End If

	Response.Redirect GetSession("BackURL")
Else
	SQL = "Select * From [" & Table & "]"
	
	If Mode = "edit" Then
		SQL = SQL & " Where [" & Table & "]." & Table & "ID = " & ID
	End If
	
	
	Header
	%>
	<form action="message.asp" id="form1" method="post" class="_validate">
		<input type="hidden" name="IsSubmitted" value="true" />
		<input type="hidden" name="m" value="<% = Mode %>" />
		<% If Mode = "edit" Then %>
		<input type="hidden" name="ID" value="<% = ID %>" />
		<% End If %>
		
		<% ProcessFormLayout GetURL(templatelocation  & "forum/message.html"), SQL, Mode %>
	</form>

	<%
	Bottom
End If
%>