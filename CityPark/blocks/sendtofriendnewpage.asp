<!--#include file="../config.asp"-->



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
Text2Send = Text2Send &"<a href=http://" & LCase(Request.ServerVariables("HTTP_HOST"))& Replace(GetSession("BackUrl"),"&mode=doit","")&">http://"  & LCase(Request.ServerVariables("HTTP_HOST"))& Replace(GetSession("BackUrl"),"&mode=doit","") & "</a>"
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & Request.Form("Message")& vbcrlf & vbcrlf
	If SendMail(Request.Form("LastName") & " " & "שלח לך קישור", Request.Form("LastName"), Request.Form("eMail"), Text2Send) = True Then
If Session("SiteLang") = 1 Then
	Response.Write("<br><br><p align='center'>ההודעה נשלחה בהצלחה. !</p>")
Else 
	Response.Write("<br><br><p align='center'>Message Was Sent.!</p>")
End If 
End If
Else
%>

<form action="<% = "../Sc.asp?" & Request.Querystring & "&mode=doit"%>" method="post" id="ContactFormpage" >
<div id="sendtofriend"><a href="javascript:toggle('sendtofriendform');">שלח לחבר</a></div>
<div id="sendtofriendform" style="padding-top:10px;display:none" align="center">
<table id="contactform" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2"><input id="cff" name="Name" style="float: right">
</td>
<td align="right">:<span lang="he"><% = SysLang("name")%></span></td>
</tr>
<tr>
<td colspan="2">
<input id="cff" name="eMail" style="float: right" class="required validate-email"></td>
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
				<script type="text/javascript">
  new Validation('ContactFormpage',{stopOnFirst:true});
</script>

<% End If
%>