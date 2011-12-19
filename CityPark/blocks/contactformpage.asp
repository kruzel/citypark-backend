<!--#include file="../config.asp"-->
<!--#include file="../inc_sendmail.asp"-->
<%
SetSession "PageTitle", "צור קשר"

If Request.QueryString("mode") = "doit"  and TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
Text2Send = "<p align='right'>"
Text2Send = Text2Send & "<b>הודעה נכתבה באתר האינטרנט שלכם</b>"
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & "<b>שם: </b>" & Trim(Request.Form("LastName")) & " " & Trim(Request.Form("Name")) & vbcrlf & vbcrlf
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & "<b>אימייל: </b>" & Trim(Request.Form("Email")) & vbcrlf & vbcrlf
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & "<b>טלפון: </b>" & vbcrlf & Trim(Request.Form("Phone")) & vbcrlf & vbcrlf
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & "<b>כתובת: </b>" & vbcrlf & Trim(Request.Form("City")) & vbcrlf & vbcrlf
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & "<b>סיבת פניה: </b>" & vbcrlf & Trim(Request.Form("About")) & vbcrlf & vbcrlf
Text2Send = Text2Send &"<br>"
Text2Send = Text2Send & "<b>הודעה: </b>" & vbcrlf & Trim(Request.Form("Message")) & vbcrlf & vbcrlf
	If SendMail("הודעה מאתר" & Application(ScriptName & "WebPageTitle"),"mailer@outmail.info", Application(ScriptName & "AdminEmail"), Text2Send) = True Then
		'Start Insert To Database
				Sql = "SELECT * FROM Contactform WHERE SiteID= " & SiteID
			     Set objRs = OpenDB(sql)
	                    
				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("Name") = Request.Form("Name")
				             objRs("Email") = Request.Form("eMail")
							 objRs("Phone") = Request.Form("Phone")
							 objRs("City") = Trim(Request.Form("City"))	
							 objRs("About") = Trim(Request.Form("About"))	
							 objRs("Message") = Trim(Request.Form("Message"))	
							 objRs("date") = Now()
							 objRs("status") = 0
							 objRs.Update
				CloseDB(objRs)

		
		'Start SMS
			 If Getconfig("sendcontactformsms") = True Then
			        If Getconfig("smscredit") > 0 Then
			        	TemplateURL = templatelocation  & "contactformSMS.html" 			        	
			            SendSMS Getconfig("smsnumber"),getposttemplate(GetURL(TemplateURL)),GetConfig("smsfrom")
                        'CloseDB(objRsSMS)
			        Else
                        SendMail "הודעה מאתר" & Application(ScriptName & "WebPageTitle"), "web@website.com", Application(ScriptName & "AdminEmail"), "אין אפשרות לשלוח SMS"
                    End If
               End If
        'End SMS

If Session("SiteLang") = "he-IL" Then
	Response.Write("<br><br><p align='center'>ההודעה נשלחה בהצלחה!</p>")
Else 
	Response.Write("<br><br><p align='center'>Message Was Sent!</p>")
End If 

End If
Else
%>

<%               
If Request.QueryString("mode") = "doit" then
if not TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
Response.Write("<b style=""color:#FF0000"">הקוד שגוי</b>")
end if
end if
%>

<form action="<% = Getsession("BackURL")  & "&mode=doit"%>" method="post" id="ContactFormpage" class="_validate" >
<input type="hidden" name="IsPostback" value="true"> 
<table id="contactform" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2"><input id="cff" name="Name" style="float: right">
</td>
<td align="right">:<span lang="he"><% = SysLang("name")%></span></td>
</tr>
<tr>
<td colspan="2">
<input id="cff" dir="rtl"name="Phone" style="float: right"></td>
<td align="right">:<span lang="he"><% = SysLang("phone")%></span></td>
</tr>
<tr>
<td colspan="2">
<input id="cff" name="eMail" style="float: right" class="required email"></td>
<td align="right">:Email</td>
</tr>
<tr>
<td colspan="2">
<input id="cff" name="City" style="float: right"></td>
<td align="right">:<span lang="he"><% = SysLang("Address") %></span></td>
</tr>
<tr>
<td colspan="2">
<input id="cff" name="About" style="float: right"></td>
<td align="right">:<span lang="he"><% = SysLang("Subject") %></span></td>
</tr>
<tr>
<td colspan="2">
<textarea style="float: right" rows="6" id="cff" name="Message"></textarea></td>
<td align="right" valign="top">:<span lang="he"><% = SysLang("Message") %></span></td>
</tr>
<% If getconfig("EnableCaptcha") = 1 then %>
<tr>
<td>
&nbsp;</td>
<td>
<img id="imgCaptcha2" src="../captcha.asp" align="right" style="border: 1px solid #000000" /></td>
<td align="right">
<div align="right"><a href="javascript:void(0)" onclick="RefreshImage('imgCaptcha2')" style="text-decoration: none">החלפת קוד</a></div></td>
</tr>
<tr>
<td>
<input id="send" type="submit" value="<% = SysLang("send")%>" name="B2"></td>
<td>
<input name="captchacode" id="captchacode" style="float: right; width: 132px;" /></td>
<td align="right"><span lang="he">:הכנס קוד</span></td>
</tr>
<% Else %>
<tr>
<td colspan="2">
<input id="send" type="submit" value="<% = SysLang("send")%>" name="B2"></td>
<td></td>
</tr>
<% End if %>
</table>
</form>

<% End If
'bottom
%>