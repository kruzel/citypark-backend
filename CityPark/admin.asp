<!--#include file="config.asp"-->
<%

Set objRsForm = OpenDB("Select * From [FormBlock] Where [FormBlock].FormBlockID = " & Int(Request("FormID")))

Dim Mode : Mode = LCase(Request("m"))
Dim ID : ID = Int(Request("ID"))
Dim Table : Table = LCase(objRsForm("TableName"))
Dim FormID : FormID = Int(Request("FormID"))
Dim Action : Action = LCase(objRsForm("Action"))
'--Security

'Implements security
Sub ImplementSecurity()
	If Mode = "delete" Or Mode = "edit" Then
		If GetSession("Type") = "Admin" Then
			CheckSecuirty Table
		Else
			Set objRsSecurity = OpenDB("Select UserId From [" & objRsForm("TableName") & "] Where " & objRsForm("TableName") & "ID = " & ID)
		
			If GetUserID() <> Int(objRsSecurity("UserId")) then
				SetSession "BackURL", """ & Action & """ & Request.QueryString
				Response.Redirect "/userlogin.asp"
			End If
				
			CloseDB(objRsSecurity)
		End If
	ElseIf Mode = "add" Then
		CheckSecurity_Level objRsForm("User9Level")
	ElseIf Mode = "" Then
		CheckSecurity_Level objRsForm("ShowUser9Level")
	End If
End Sub

'Returns the connected User ID
Function GetUserID()
	If GetSession("UserID") = "" Then
		If Request.Cookies(SiteID & "UserID") <> "" Then
			GetUserID = Int(Request.Cookies(SiteID & "UserID"))
		End If
	Else
		GetUserID = Int(GetSession("UserID"))
	End If
End Function

'--SQL
Function GetSQL(Table, Mode, ID)
	Select Case Mode
		
		Case "add"
			SQL = "Insert Into [" & Table & "] ("	
		
			First = True
			For Each x In Request.Form
				If LCase(x) <> "issubmitted" And LCase(x) <> "formid" And LCase(x) <> "m" And LCase(x) <> "id" And Mid(UCase(x), 1, Len("SYSTEM_SENDMAIL")) <> "SYSTEM_SENDMAIL" And LCase(left(x,7)) <> "remlen_" and lcase(x) <> "captchacode" Then
					If First Then
						First = False
					Else
						SQL = SQL & ", "
					End If
					
					If Mid(x, 1, 1) = "_" Then
						Session(SiteID & Mid(x,2)) = Request.Form(x)
						SQL = SQL & "[" & Table & "]." & Mid(x,2)
					Else
						SQL = SQL & "[" & Table & "]." & x
					End If
				End If
			Next
			
			SQL = SQL & ", " & "[" & Table & "].SiteID) Values ("
			
			First = True

			For Each x In Request.Form
				If LCase(x) <> "issubmitted" And LCase(x) <> "formid" And LCase(x) <> "m" And LCase(x) <> "id" And Mid(UCase(x), 1, Len("SYSTEM_SENDMAIL")) <> "SYSTEM_SENDMAIL" And LCase(left(x,7)) <> "remlen_" and lcase(x) <> "captchacode" Then
					If First Then
						First = False
					Else
						SQL = SQL & ", "
					End If
					
					Value = Replace(Request.Form(x), "'", "''")
					SQL = SQL & "'" & Value & "'"
				End If
			Next
			
			SQL = SQL & ", " & SiteID & ");"
			'print sql
			
		Case "edit"
			SQL = "Update [" & Table & "] Set "	
		
			First = True
		
			For Each x In Request.Form
				If LCase(x) <> "issubmitted" And LCase(x) <> "formid" And LCase(x) <> "m" And LCase(x) <> "id" And Mid(UCase(x), 1, Len("SYSTEM_SENDMAIL")) <> "SYSTEM_SENDMAIL" And LCase(left(x,7)) <> "remlen_" And lcase(x) <> "captchacode" Then
					If First Then First = False Else SQL = SQL & ", "
					Value = Replace(Request.Form(x), "'", "''")
					SQL = SQL & "[" & Table & "]." & x & " = '" & value & "'"
				End If
			Next
			
			SQL = SQL & " Where [" & Table & "]." & Table & "ID = " & ID & ";"
			
		Case "delete"
			SQL = "Delete From [" & Table & "] Where [" & Table & "]." & Table & "ID = " & ID & ";"

	End Select
	
	GetSQL = SQL
End Function


Function GetToolbarSQL()
	Set objRsSearch = OpenDB("Select Top 1 * From [" & objRsForm("TableName") & "] Where SiteID = " & SiteID)

	For Each x In objRsSearch.Fields
		If Request("to_" & x.Name) <> "" And Request("to_" & x.Name) <> "0" Then
			SQL = SQL & " And " & x.Name & " <= '" & Request("to_" & x.Name) & "'"
		End If
		
		If Request("from_" & x.Name) <> "" And Request("from_" & x.Name) <> "0" Then
			SQL = SQL & " And " & x.Name & " >= '" & Request("from_" & x.Name) & "'"
		End If
			
		If Request(x.Name) <> "" And Request.QueryString(x.Name) <> "0" Then
			SQL = SQL & " And " & x.Name & " = '" & Request(x.name) & "'"
		End If
	Next
				
	IsFirst = True
	
	For Each x In objRsSearch.Fields
	'	If Request.QueryString(x.Name) <> "" And Request.QueryString(x.Name) <> "0" Then
			If Not IsFirst Then 
				FreeTextSQL = FreeTextSQL & " Or "
			Else
				IsFirst = False
			End If
			
			FreeTextSQL = FreeTextSQL & x.Name & " Like '%" & Request.QueryString("FreeText") & "%'"	
	'	End If
	Next
			
	If FreeTextSQL <> "" Then
		SQL = SQL & " And (" & FreeTextSQL & ")"
	End If
	
	CloseDB(objRsSearch)
	
	GetToolbarSQL = SQL
End Function


'--Template Management

Sub ProcessShowLayout(strTemplate, objRs)
	PrintCustomizedTemplate strTemplate, objRs, "ProcessShowCommand"
End Sub	

Function ProcessFormHeaderTemplate(template)
	ProcessFormHeaderTemplate = GetCustomizedTemplate(template, Null, "ProcessFormHeaderBlock")
End Function

Function GetEmailTemplate(emailTemplate)
	GetEmailTemplate = GetPostTemplate(emailTemplate)
End Function

Function ProcessValue(Value, Default)
	If Value = "" Or IsNull(Value) Then
		ProcessValue = Default
	Else
		ProcessValue = Value
	End If
End Function

Sub ProcessShowCommand(strCommand, objRs)
	If Mid(strCommand, 1, 1) = "#" Then
		Command = LCase(Mid(strCommand, 2))
		Table = Mid(Command, 1, InStr(Command, "id") - 1)

		Set objRs2 = OpenDB("Select " & Table & "Name From [" & Table & "] Where " & Command & " = " & objRs(Command))
		
		Print objRs2(0)
		
		CloseDB(objRs2)
	Else
		If lcase(strCommand) = "formid" Then
			Print FormID
		Else
			Print objRs(strCommand)
		End If
	End If
End Sub

Function ProcessFormHeaderBlock(strCommand)
	Commander = Split(strCommand)
	
	If UBound(Commander) > 0 Then 
		Parameters = Split(Commander(1), ",")
	End If
	
	Select Case LCase(Commander(0))
		Case "formid"
			ProcessFormHeaderBlock = ProcessFormHeaderBlock & FormID
		
		Case "pages"
			QS = Request.QueryString
			QS = Replace(QS, "&Page=" & Request.QueryString("Page"), "")
			QS = Replace(QS, "Page=" & Request.QueryString("Page") & "&", "")
			QS = Replace(QS, "Page=" & Request.QueryString("Page"), "")
			
			nPage = Int(Request.QueryString("Page"))
			If nPage <= 0 Then
				nPage = 1
			End If

			If nPage > 1 Then
				ProcessFormHeaderBlock = ProcessFormHeaderBlock & "<span id=""backpage""><a href=""" & Action & "" & QS & "&Page=" & (nPage - 1) & """>עמוד קודם</a></span>"
			End If
			
			If nPage > 1 And nPage < Int(GetSession("PageCount")) Then
				ProcessFormHeaderBlock = ProcessFormHeaderBlock & " | "
			End If
			
			If nPage < Int(GetSession("PageCount")) Then
				ProcessFormHeaderBlock = ProcessFormHeaderBlock & "<span id=""nextpage""><a href=""""" & Action & "" & QS & "&Page=" & (nPage + 1) & """>עמוד הבא</a></span>"
			End If		
		Case "orderlink"
			If UBound(Commander) > 0 Then
				OrderField = Null
				
				For Each Parameter in Parameters
					KeyValue = Split(Parameter, "=")
					
					If LCase(KeyValue(0)) = "field" Then
						OrderField = KeyValue(1)
					End If
				Next
			End If
		
			If Not IsNull(OrderField) Then
				QS = Request.QueryString
			
				If LCase(OrderField) <> LCase(Request("order")) Then
					QS = Replace(QS, "&order=" & Request.QueryString("order"), "")
					QS = Replace(QS, "order=" & Request.QueryString("order") & "&", "")
					QS = Replace(QS, "order=" & Request.QueryString("order"), "")
					
					ProcessFormHeaderBlock =  Action & QS & "&order=" & OrderField
				Else
					QS = Replace(QS, "&ordertype=" & Request.QueryString("ordertype"), "")
					QS = Replace(QS, "ordertype=" & Request.QueryString("ordertype") & "&", "")
					QS = Replace(QS, "ordertype=" & Request.QueryString("ordertype"), "")

					If Request("OrderType") = "" Or Request("OrderType") = "ASC" Then
						ProcessFormHeaderBlock =   Action  & QS & "&ordertype=" & "DESC"
					Else
						ProcessFormHeaderBlock =  Action &  QS & "&ordertype=" & "ASC"
					End If
					
				End If				
			End If
			
		Case "toolbar"
			If UBound(Commander) > 0 Then
				TemplateURL = Null
				
				For Each Parameter in Parameters
					KeyValue = Split(Parameter, "=")
					
					If LCase(KeyValue(0)) = "templateurl" Then
						TemplateURL = KeyValue(1)
					End If
				Next
			End If
						
			If Not IsNull(TemplateURL) Then
				ProcessFormHeaderBlock = "<form action=""" & Action & """ method=""get"" id=""toolbar"">"
				ProcessFormHeaderBlock = ProcessFormHeaderBlock & "<input type=""hidden"" name=""FormID"" value=""" & FormID & """ />"
				
				If Mode <> "" Then
					ProcessFormHeaderBlock = ProcessFormHeaderBlock & "<input type=""hidden"" name=""m"" value=""" & Mode & """ />"
				End If
				
				ProcessFormHeaderBlock = ProcessFormHeaderBlock & GetFormLayout(GetFile(TemplateURL), "Select * From [" & Table & "] Where SiteID = " & SiteID, Mode)
				ProcessFormHeaderBlock = ProcessFormHeaderBlock & "</form>"
			End If
		
		Case Else
			ProcessFormHeaderBlock = "[" & strCommand & "]"
	End Select
End Function


'Mail Management
Sub SendMailForm(recipient, emailTemplate)

	Set myMail=CreateObject("CDO.Message")
			myMail.Subject = objRsForm("Subscribesemailsubject")
			myMail.From = objRsForm("Subscribesemailfrom")
			myMail.To=recipient
			'myMail.Bcc=""
						myMail.BodyPart.Charset = "windows-1255"

			myMail.HTMLBody = Replace(GetEmailTemplate(GetURL("/admin/layout/adminforms/" & emailTemplate)), "[message]", Request.Form("message"))
			
			myMail.Configuration.Fields.Item("urn:schemas:mailheader:x-content-type") = "text/html; charset=windows-1255"
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")= 2
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "212.179.18.100"
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
			myMail.Configuration.Fields.Update
			myMail.Send
			set myMail=nothing

End Sub







Sub ImplementSendMail()
	AdminHeader
	Set objRs = OpenDB("Select * From [" & objRsForm("TableName") & "] Where SiteID = " & SiteID)
		
	Do Until objRs.Eof		
		If LCase(Request.Form("SYSTEM_SENDMAIL" & objRs(0))) = "on" Then
			
			Set objMessage = CreateObject("CDO.Message")
			
			objMessage.Subject = objRsForm("Subscribesemailsubject")
			objMessage.From = objRsForm("Subscribesemailfrom")
			objMessage.To = objRs("Email")
			objMessage.BodyPart.Charset = "windows-1255"
			objMessage.Configuration.Fields.Item("urn:schemas:mailheader:content-type") = "text/html; charset=windows-1255"
			objMessage.HTMLBody = GetRecordSetTemplate(Replace(GetURL("/admin/layout/adminforms/" & Request("Template")), "[message]", Request.Form("message")), objRs)
			objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")= 2
			objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "212.179.18.100"
			objMessage.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
			objMessage.Configuration.Fields.Update
			objMessage.Send
			
			Set objMessage = Nothing
		
			Print "נשלח בהצלחה ל- " & objRs("Email") & "<br />"
		End If
				
		objRs.MoveNext
	Loop
	
	CloseDB(objRs)
End Sub



Sub ImplementAddEdit()
	If Mode = "add" Or GetSession("Type") <> "Admin" then 
		AdminHeader
	Else	
		AdminHeader
	End If
			
	SQL = "Select * From [" & Table & "]"
				
	If Mode = "edit" Then
		SQL = SQL & " Where [" & Table & "]." & Table & "ID = " & ID
	End If
	%>			
	<form action="<% = Action %>" method="post" id="<% = Int(Request("FormID")) %>">
		<input type="hidden" name="IsSubmitted" value="true" />
		<input type="hidden" name="m" value="<% = Mode %>" />
		<input type="hidden" name="ID" value="<% = ID %>" />
		<input type="hidden" name="FormID" value="<% = Int(Request("FormID")) %>" />
	<%
	 If Mode = "edit" Then ProcessFormLayout GetURL("/admin/layout/adminforms/" & objRsForm("EditTemplateURL")), SQL, Mode 
	 If Mode = "add" Then ProcessFormLayout GetURL("/admin/layout/adminforms/" & objRsForm("TemplateURL")), SQL, Mode 
	%>
	</form>
	<script type="text/javascript">
		new Validation('<% = Int(Request("FormID")) %>',{stopOnFirst: true});
	</script>
	<%
	bottom
End Sub

Sub ImplementShow()
	If Mode = "admin" Then
		SetSession "BackURL", """ & Action & """ & Request.QueryString
		CheckSecuirty Table
		AdminHeader
	ElseIf Mode = "user" Then
		If GetUserID() = "" Then
			If GetSession("Type") <> "Admin" Then
				SetSession "BackURL", """ & Action & """ & Request.QueryString
				Response.Redirect "/userlogin.asp"
			End If
		End If
		
		Header
	Else
		CheckSecurity_Level objRsForm("ShowUser9Level")
		Header	
	End If
	%>
	<script type="text/javascript">
		function ChangePage(selectBox) {
			var qs = window.location.href.split('?')[1];
			qs = qs.replace('&' + selectBox.id + '=' + querySt(selectBox.id), '');
			qs = qs.replace(selectBox.id + '=' + querySt(selectBox.id) + '&', '');
			qs = qs.replace(selectBox.id + '=' + querySt(selectBox.id), '');	
				
			window.location = '<% = Action %>' + qs + '&' + selectBox.id + '=' + unescape(selectBox.options[selectBox.selectedIndex].value);
		}
			
		function querySt(ji) {
			hu = window.location.search.substring(1);
			gy = hu.split("&");
			for (i=0;i<gy.length;i++) {
				ft = gy[i].split("=");
				if (ft[0] == ji) {
					return ft[1];
				}
			}
		}
	</script>
	<%
	If objRsForm("ShowLevelFieldName")<> "" And Mode <> "admin" Then
SQL = "Select * From [" & objRsForm("TableName") & "] Where SiteID = " & SiteID & " And " & objRsForm("ShowLevelFieldName") & " >=" & objRsForm("ShowFieldLevel") & GetToolbarSQL() 
	Else
			SQL = "Select * From [" & objRsForm("TableName") & "] Where SiteID = " & SiteID & GetToolbarSQL() 

	End If

			
	If Mode = "user" Then
		SQL = SQL & " And UserID = " & GetUserID()
	End If

	If Request("order") <> "" Then
		SQL = SQL & " Order By " & Request("order")
			If Request("OrderType") = "" Then
			SQL = SQL & " ASC"
		Else
			SQL = SQL & " " & Request("OrderType")
		End If
	Else
		If objRsForm("DefaultOrder")<> "" Then
		SQL = SQL & " Order By " & objRsForm("DefaultOrder")
		Else
		SQL = SQL
		End If
	End If
	Set objRs = OpenDB(SQL)
	
	If objRs.RecordCount = 0 Then
		ProcessFormLayout ProcessFormHeaderTemplate(GetURL("/admin/layout/adminforms/" & objRsForm("NoRecordsTemplate"))), "", ""
	Else
		If Request("Records") = "" Then
			objRs.PageSize = 10
		Else
			objRs.PageSize = Int(Request("Records"))
		End If
					
		nPage = Int(Request.QueryString("Page"))
			
		If nPage <= 0 Then
			nPage = 1
		End If
	
		SetSession "PageCount", objRs.PageCount
	
		If Mode = "admin" Then
			ProcessFormLayout ProcessFormHeaderTemplate(GetURL("/admin/layout/adminforms/" & objRsForm("GridHeaderTemplate"))), "", ""
		ElseIf Mode = "user" Then
			ProcessFormLayout ProcessFormHeaderTemplate(GetURL("/admin/layout/adminforms/" & objRsForm("userHeaderTemplate"))), "", ""
		Else	
			ProcessFormLayout ProcessFormHeaderTemplate(GetURL("/admin/layout/adminforms/" & objRsForm("ShowHeaderTemplateURL"))), "", ""
		End If
					
		objRs.AbsolutePage = nPage
					
		If Mode = "admin" Then
			Template = GetURL("/admin/layout/adminforms/" & objRsForm("GridRowTemplate"))
		ElseIf Mode = "user" Then
			Template = GetURL("/admin/layout/adminforms/" & objRsForm("userRowTemplate"))
		Else
			Template = GetURL("/admin/layout/adminforms/" & objRsForm("ShowTemplateURL"))
		End If
		
		IsDateField = False
		
		For Each x In objRs.Fields
			If LCase(x.Name) = "date" Then
				IsDateField = True
				Exit For
			End If
		Next

		Do While Not (objRs.Eof Or objRs.AbsolutePage <> nPage)
			CanContinue = False
			
			If IsDateField And Int(objRsForm("Days")) <> 0 Then
				If DateDiff("d", objRs("Date"), Date()) < objRsForm("Days") Then
					CanContinue = True
				End If
			Else
				CanContinue = True
			End If
						
			If CanContinue Then
				ProcessShowLayout Template, objRs									
			End If
			
			objRs.MoveNext
		Loop
		
	End If
								
	CloseDB(objRs)
				
	If Mode = "admin" then
		ProcessFormLayout ProcessFormHeaderTemplate(GetURL("/admin/layout/adminforms/" & objRsForm("GridBottomTemplate"))), "", ""
	Else
		ProcessFormLayout ProcessFormHeaderTemplate(GetURL("/admin/layout/adminforms/" & objRsForm("ShowBottomTemplateURL"))), "", ""
		Bottom 
	End If

End Sub


Sub ImplementSubmit()
	SQL = GetSQL(Table, Mode, ID)	
	
	If objRsForm("IsCaptcha") = "True" Then
		If Session("Captcha321234") <> Request.Form("CaptchaCode") Then
			response.redirect  Action & "FormID=" & FormID & "&m=" & Mode & "&ID=" & Id & "&msg1=הקוד אינו תקין."
		End If
	End If
	
	If Not Table = "0" Then
		ExecuteRS sql
	End If
	
	If Mode = "add" Then
		If Request("ajax") <> "true" Then
			Response.AddHeader "Refresh", objRsForm("RedirectTime") & "; URL=" & objRsForm("RedirectionUrl")
			AdminHeader
		End If
		
		If objRsForm("AdminEmail") <> "" Then
			SendMailForm LCase(objRsForm("AdminEmail")), objRsForm("AdminEmailTemplate")
		End If
	
		If objRsForm("UserEmailField") <> "" Then
			SendMailForm Request.Form(LCase(objRsForm("UserEmailField"))), objRsForm("UserEmailTemplate")
		End If
	
		Print objRsForm("ComfirmationText")
		
		If Request("ajax") <> "true" Then
			Bottom
		End If
	Else	
		RedirectTime = 1
	
		If GetSession("Type") = "Admin" Then
			If objRsForm("AdminRedirectionURL") <> 	"" Then
				RedirectURL = objRsForm("AdminRedirectionURL")
			Else
				RedirectURL = Action & "FormId=" & FormID & "&m=admin"
			End If
			
		Else
			RedirectURL =  Action & "FormId=" & FormID & "&m=user"
		End If
		
		Response.AddHeader "Refresh", RedirectTime & "; URL=" & RedirectURL 

		If GetSession("Type") = "Admin" Then
			AdminHeader
		Else
			AdminHeader
		End If
		
		Print("<br><br><p align='center'>")
		If Mode = "delete" then Print "הרשומה נמחקה  בהצלחה."
		If Mode = "edit" then	Print "הרשומה עודכנה בהצלחה."
		Print("<a href=""" & RedirectURL  & """>לחץ להמשך</a>!</p>")
		
		If GetSession("Type") <> "Admin" Then
			Bottom	
		End If
	End If
End Sub

Function IsSubmitted()
	IsSubmitted = (LCase(Request("IsSubmitted")) = "true" Or Mode = "delete")
End Function
SetSession "BackURL","/form.asp?"& Request.querystring
'Configuration
AddEditField = "TemplateURL"

AdminHeaderField = "GridHeaderTemplate"
AdminRowField = "GridRowTemplate"
AdminBottomField = "GridBottomTemplate"

ShowHeaderField = "GridHeaderTemplate"
ShowRowField = "ShowTemplateURL"
ShowBottomField = "GridBottomTemplate"

ShowDetails = ""

AdminEmailField = "AdminEmailTemplate"
UserEmailField = "UserEmailTemplate"
'End Configuration


ImplementSecurity

If IsSubmitted() Then
	ImplementSubmit
Else
	Select Case Mode
		Case "sendmail"
			ImplementSendMail	
		
		Case "add", "edit"
			ImplementAddEdit
								
		Case Else
			ImplementShow
	End Select
End If

%>
		
