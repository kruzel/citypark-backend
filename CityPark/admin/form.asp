<!--#include file="../config.asp"-->
<%
SetSession "BackURL","/admin/form.asp?"& Request.querystring
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

%>
<!--#include file="../$form_functions.asp"-->
<%

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