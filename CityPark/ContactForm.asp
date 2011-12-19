<!--#include file="config.asp"-->
<!--#include file="inc_sendmail.asp"-->
<%
SetSession "PageTitle", "צור קשר"

If Request.QueryString("headers") <> "no" then
    header
End if


	If Request.QueryString("mode") = "sendmailtocust"  and TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
        Text2Send = "<html dir=rtl><head><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8""></head><body>"
		Text2Send = Text2Send & "<table><tr><td colspan=""2"">הודעה נכתבה באתר האינטרנט שלכם</td></tr>"
		'Text2Send = Text2Send &"<br>"
		Text2Send = Text2Send & "<tr><td>שם:</td><td>" & Trim(Request.Form("LastName")) & "" & Trim(Request.Form("Name")) 
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "אימייל: </td><td>" & Trim(Request.Form("Email"))   
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "טלפון:  </td><td>" & Trim(Request.Form("Phone")) 
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "כתובת: </td><td>" & vbcrlf & Trim(Request.Form("City")) 
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "סיבת פניה: </td><td>" & vbcrlf & Trim(Request.Form("About"))
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "הודעה:  </td><td>"  & Trim(Request.Form("Message")) 
		Text2Send = Text2Send &"</td></tr></table>"
       ' print Text2Send

                If SendMail("A mesage from" & Application(ScriptName & "WebPageTitle"),"mailer@outmail.info", Request.QueryString("mail"), Text2Send) = True Then
		'Start Insert To Database

						Response.Write("<br><br><p align='center'>ההודעה נשלחה בהצלחה.</p>")
			
			End If
	Else
    If Request.QueryString("mode") = "doit"  and TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
			If Len(Request.Form("Email")) < 5 then
             print " ארעה שגיאה"
            'response.end
       Else
	
     If Session("SiteLang") = "he-IL" Then
        Text2Send = "<html dir=rtl><head><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8""></head><body>"
		Text2Send = Text2Send & "<table><tr><td colspan=""2"">הודעה נכתבה באתר האינטרנט שלכם</td></tr>"
		'Text2Send = Text2Send &"<br>"
		Text2Send = Text2Send & "<tr><td>שם:</td><td>" & Trim(Request.Form("LastName")) & "" & Trim(Request.Form("Name")) 
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "אימייל: </td><td>" & Trim(Request.Form("Email"))   
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "טלפון:  </td><td>" & Trim(Request.Form("Phone")) 
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "כתובת: </td><td>" & vbcrlf & Trim(Request.Form("City")) 
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "סיבת פניה: </td><td>" & vbcrlf & Trim(Request.Form("About"))
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "הודעה:  </td><td>"  & Trim(Request.Form("Message")) 
		Text2Send = Text2Send &"</td></tr></table>"
       ' print Text2Send
	Else
        Text2Send = "<html dir=ltr><head><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8""></head><body>"
		Text2Send = Text2Send & "<table><tr><td colspan=""2"">A Masage from your web site</td></tr>"
		'Text2Send = Text2Send &"<br>"
		Text2Send = Text2Send & "<tr><td>Name:</td><td>" & Trim(Request.Form("LastName")) & "" & Trim(Request.Form("Name")) 
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "Email: </td><td>" & Trim(Request.Form("Email"))   
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "Phone:  </td><td>" & Trim(Request.Form("Phone")) 
		If Request.Form("City") <> "" Then
        Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "Address: </td><td>" & vbcrlf & Trim(Request.Form("City")) 
        End if
        If Request.Form("About") <> "" then
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "Cause of her: </td><td>" & vbcrlf & Trim(Request.Form("About"))
        End if
		Text2Send = Text2Send &"</td></tr><tr><td>"
		Text2Send = Text2Send & "Mesage:  </td><td>"  & Trim(Request.Form("Message")) 
		Text2Send = Text2Send &"</td></tr></table>"
       ' print Text2Send
    
    End if	
                If SendMail("A mesage from" & Application(ScriptName & "WebPageTitle"),"mailer@outmail.info", Application(ScriptName & "AdminEmail"), Text2Send) = True Then
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
							 objRs("Status") = 0	
							 objRs("date") = Now()
							 objRs.Update
				CloseDB(objRs)

		
		'Start SMS
			 If Getconfig("sendcontactformsms") = True Then
			        If Getconfig("smscredit") > 0 Then
			        	TemplateURL = templatelocation  & "contactformSMS.html" 			        	
			            SendSMS Getconfig("smsnumber"),getposttemplate(GetURL(TemplateURL))
                        CloseDB(objRsSMS)
			        Else
                        SendMail "הודעה מאתר" & Application(ScriptName & "WebPageTitle"), "mailer@outmail.info", Application(ScriptName & "AdminEmail"), "אין אפשרות לשלוח SMS"
                    End If
               End If
        'End SMS

				If Session("SiteLang") = "he-IL" Then
						Response.Write("<br><br><p align='center'>ההודעה נשלחה בהצלחה.</p>")
				Else 
						Response.Write("<br><br><p align='center'>The message was sent successfully.</p>")
				End If 
			
			End If
		End If
	Else
		If Request.QueryString("mode") = "doit" then
			if not TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
				Response.Write("<b style=""color:#FF0000"">הקוד שגוי</b>")
			end if
		end if
%>
<form action="ContactForm.asp?mode=doit" method="post" class="_validate">
<div style="padding-top: 10px;" align="center">
    <table id="contactform" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <input id="cff" name="Name" class="required" minlength="2" />
            </td>
            <td align="right">
                :<% = SysLang("name")%>
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <input id="cff" dir="rtl" name="Phone" class="required" />
            </td>
            <td align="right">
                :<% = SysLang("phone")%>
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <input id="cff" name="eMail" class="required email" />
            </td>
            <td align="right">
                :Email
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <input id="cff" name="City" />
            </td>
            <td align="right">
                :כתובת
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <input id="cff" name="About" />
            </td>
            <td align="right">
                :נושא
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <textarea rows="6" id="Textarea1" name="Message"></textarea>
            </td>        
            <td valign="top">
                :הודעה
            </td>
            <td>
            </td>
        </tr>
        <% If getconfig("EnableCaptcha") = 1 then %>
        <tr>
            <td>
                <p align="right">
                    <a href="javascript:void(0)" onclick="RefreshImage('imgCaptcha2')" style="text-decoration: none">
                        החלפת קוד</a>
            </td>
            <td>
                <img id="imgCaptcha2" src="captcha.asp" align="right" style="border: 1px solid #000000" />
            </td>
            <td align="right">
                :<span lang="he"><% = SysLang("code")%></span>
            </td>
        </tr>
        <tr>
            <td>
                <p align="center">
                    <td>
                        <input name="captchacode" id="captchacode" style="float: right; width: 132px;" />
                    </td>
                    <td align="right">
                        &nbsp;
                    </td>
        </tr>
        <% end if %>
        <tr>
            <td>
                <td>
                </td>
                <td align="right">
                </td>
        </tr>
        <tr>
            <td>
                <p align="center">
                    <input type="submit" value="<% = SysLang("send")%>" name="B2">
            </td>
            <td>
                <td align="right">
                    &nbsp;
                </td>
        </tr>
    </table>
</div>
</form>
<% 
	End If
If Request.QueryString("headers") <> "no" then
        bottom
End if
End if
%>