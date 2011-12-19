<!--#include file="config.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" media="screen" type="text/css" href="<%= Templatelocation%>style/style.css" />
    <script src="/js/jquery.js" type="text/javascript"></script>
	<script type="text/javascript" src="/js/ajax.asp"></script>
	<script type="text/javascript" src="/js/validate.asp"></script>
	<script> $(document).ready(function() { $('._validate').validate(); $('._ajax_form').validate({ submitHandler: function(form) { var p = $(form); $.ajax({ type: p.attr('method'), url: p.attr('action'), data: p.serialize(), success: function(html) { p.parent().html(html); } }); return false; } }); });</script>


</head>
<%

SetSession "PageTitle", "צור קשר"
Function SendMail(Subject, Sender, Recipient, Body)

	SendMail= False
						
			
		
			Set myMail=CreateObject("CDO.Message")
			myMail.Subject = Subject
			myMail.From = Request.Form("Name")
			myMail.To=Recipient
			'myMail.Bcc=""
			myMail.HTMLBody  = Body
			myMail.Configuration.Fields.Item _
				("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
			'Name or IP of remote SMTP server
			myMail.Configuration.Fields.Item _
				("http://schemas.microsoft.com/cdo/configuration/smtpserver") _
			="212.179.18.100"
			'Server port
			myMail.Configuration.Fields.Item _
				("http://schemas.microsoft.com/cdo/configuration/smtpserverport") _
			=25 
			myMail.Configuration.Fields.Update
			myMail.Send
			set myMail=nothing
SendMail= True
End Function


If Request.QueryString("mode") = "doit" then
Text2Send = "<p align='right'>"
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send &  Trim(Request.Form("LastName")) & " " & Trim(Request.Form("Name")) & vbcrlf & vbcrlf
Text2Send = Text2Send & "מעוניין להראות לך דף מעניין לחץ על הקישור כדי לצפות בדף זה"
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send &"<a href=http://" & LCase(Request.ServerVariables("HTTP_HOST"))& Replace(ReplaceSpaces(GetSession("BackUrl")),"&mode=doit","")&">http://"  & LCase(Request.ServerVariables("HTTP_HOST"))& Replace(ReplaceSpaces(GetSession("BackUrl")),"&mode=doit","") & "</a>"
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & Request.Form("Message")& vbcrlf & vbcrlf
	If SendMail(Request.Form("Name") & " " & SysLang("Send you a link"), "no_replay@"& LCase(Request.ServerVariables("HTTP_HOST")), Request.Form("eMail"), Text2Send) = True Then
		Response.Write("<br><br><p align='center'>" & Syslang("The mesage was sent click") & "<a href=""javascript:window.close();""> <b> " & Syslang("here") & "</b></a> " & Syslang("to close this window") & "</p>")
	End If
Else
%>
<body style="background:transparent;">
<form action="sendtofriend.asp?mode=doit" class="_validate" method="post">
<div id="sendtofriendform" align="center">
<table id="contactform" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2"><input id="cff" name="Name" style="float: right">
</td>
<td align="right">:<span lang="he"><% = SysLang("name")%></span></td>
</tr>
<tr>
<td colspan="2">
<input id="cff" name="eMail" style="float: right" class="required email"></td>
<td align="right">:Email</td>
</tr>
<tr>
<tr>
<td colspan="2">
<textarea style="float: right" rows="6" id="cff" name="Message"></textarea></td>
<td align="right" valign="top">:<span lang="he"><% = SysLang("Message") %></span>
</td>
</tr>
<tr>
<td colspan="2">
<p>הקישור לכתבה יתווסף באופן אוטומטי</p>
<input id="send" type="submit" value="<% = SysLang("send")%>" name="B2"></td>
<td></td>
</tr>
</table>
</div>
</form>
</body>
<% End If
%>