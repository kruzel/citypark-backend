<!--#include file="../config.asp"-->
<!--#include file="../inc_sendmail.asp"-->

<% 
header
if lcase(Request.QueryString("Table"))= "" then
    Table = "Users" 
else
    table=lcase(Request.QueryString("Table"))
end if

URL = session(SiteID & "BackURL")


If Request.QueryString("mode") = "logout" Then
		Response.Cookies(SiteID & "UserID").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "LoginName").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "Password").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "UserLevel").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "FB").Expires = Now()-1 'למחוק את העוגייה

		Response.Cookies(getConfig("ApplicationID") & "_expires").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(getConfig("ApplicationID") & "_ss").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(getConfig("ApplicationID") & "_user").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(getConfig("ApplicationID") & "_session_key").Expires = Now()-1 'למחוק את העוגייה
		For Each objCookie In Request.Cookies
   			Response.Cookies(objCookie).Expires =  Now()-1
		Next
		Response.Redirect "/"
		SetSession UserID,""
End If

If Request.QueryString("mode") = "AddUser" AND  Getconfig("AllowSeffRegistredUsers") = True  Then	

		Set objRs = OpenDB("SELECT * FROM " & Table)
				If Not Trim(Request.Form("Password1")) = Trim(Request.Form("Password2")) Then
						Response.Write("<br><br><p align='center'>Passwords do not match. <a href='javascript:history.go(-1)'>Go Back</a>!</p>")
				Else
						Set objRsUser = OpenDB("SELECT * FROM " & Table & " WHERE  SiteID = " & SiteID)
						AuthorNickExists = False
							Do While Not objRsUser.EOF
								If objRsUser("Email") = Trim(Request.Form("Email")) Then
								AuthorNickExists = True
								End If
							objRsUser.MoveNext 
							Loop
									If AuthorNickExists = True Then
										Response.Write("<br><br><p align='center'>האימייל קיים כבר<a href='javascript:history.go(-1)'>לחץ כאן</a>!</p>")						
						CloseDB(objRsUser)
									Else
                            objRs.AddNew 
						    
                            objRs("Name") = Trim(Request.form("name"))
						    objRs("Familyname") = Trim(Request.form("Familyname"))
                            objRs("Usersname") = lcase(Request.Form("LoginName"))
							objRs("Email") = Trim(Request.Form("Email"))
							objRs("Password") = Md5(Request.Form("Password2"))
							objRs("birthday") = Request.Form("birthday")
							objRs("MailingList") = 1
                            
                            objRs("Users9Level") = GetConfig("AllowSelfRegister")
							objRs("SiteID") = SiteID
						If Getconfig("Useremailvalidationtype") <> "0" Then
                             objRs("Confirmed") = 0
                            If Getconfig("Useremailvalidationtype") = "Email" then
                                Text2Send = "שלום רב<br/>"
                                Text2Send = Text2Send & " לחץ על הקישור הבא כדי לאמת את כתובת הדואל שלך"
                                Text2Send = Text2Send & "<a href=""http//" & LCase(Request.ServerVariables("HTTP_HOST")) & "/user/login.asp?mode=confirmemail&email="&Request.Form("Email")&"&code=" & Md5(Request.Form("Email")) & "</a>קישור"
                                  If SendMail("אימות כתובת דוא""ל",LCase(Request.ServerVariables("HTTP_HOST")), Request.Form("Email"), Text2Send) = True Then
	                              End if
                             End if
                             If Getconfig("Useremailvalidationtype") = "Sms" then
                                Text2Send = "שלום רב<br/>"
                                Text2Send = Text2Send & " קוד האימות שלך לאתר  " & vbCrLf
                                Text2Send = Text2Send & " <br /> " &  LCase(Request.ServerVariables("HTTP_HOST")) & vbCrLf
                               Text2Send = Text2Send  & " <br /> " & Left(Md5(Request.Form("Email")),5)& vbCrLf
                          
                                  Sendsms Request.Form("Phone"),Text2Send,"3333"  
	                         End if
                        Else
                             objRs("Confirmed") = 1
							Response.Cookies(SiteID & "LoginName") = lcase(Request.Form("LoginName"))
							Response.Cookies(SiteID & "LoginName").Expires=now() + 1
							Response.Cookies(SiteID & "Password") = objRs("Password")
							Response.Cookies(SiteID & "Password").Expires=now() + 1
							Response.Cookies(SiteID & "UserLevel") = GetConfig("AllowSelfRegister")
							Response.Cookies(SiteID & "UserLevel").Expires=now() + 1
							Response.Cookies(SiteID & "Type") = "User"
							Response.Cookies(SiteID & "Type").Expires=now() + 1

                       End if

							objRs.Update
							objRs.MoveLast()
					
                           ExecuteRS("INSERT INTO [UsersPerCategory] (UsersID, UsersCategoryID, SiteID) VALUES (" & objRs(0) & ", " & Getconfig("Defaultregistredgroup") & ", " & SiteID & ");")
						If Getconfig("Useremailvalidationtype") = "0" Then
							Response.Write("<br><br><p align='center'>" & SiteTranslate("תודה על הרשמתך") & "</p>")
                        Else
            	               Response.Redirect("/?notificate=קישור לאימות נשלח בהצלחה")
                        End if
							If Getconfig("sendmailtomanagerwhenuserregister") <> "" then
							   SendMail "משתמש נרשם באתר", "register@yourwebsite.com",Getconfig("sendmailtomanagerwhenuserregister"), Request.Form("Familyname") & " " & Request.Form("name") & " נרשם באתר"
							End if
							If Session(SiteID & "URL") = "login.asp" then Session(SiteID & "URL") = "/"
							IF NOT Session(SiteID & "URL") = "" Then
								URL = Session(SiteID & "URL")
							End If
							Response.Write("<meta http-equiv=""refresh"" content=""0;url=" & URL  & """>")
									End If
				End If
					
ElseIf Request.QueryString("mode") = "LetMeIn" Then	

	
		SQL = "SELECT * FROM " & Table & " WHERE Email='" & CheckHacker(Request.Form("Email")) & "' AND Password='" &  CheckHacker(Md5(Request.Form("Password"))) & "' AND SiteID=" & SiteID
      '  print SQL
		Set objRs = OpenDB(SQL)
		If objRs.RecordCount = 0 Then
        Response.Redirect("/user/login.asp?notificate=לא נמצא משתמש עם הנתונים האלו")
Elseif objRs("Confirmed") <> True then

            If Getconfig("Useremailvalidationtype") = "Email" then
                   Response.Redirect("/user/login.asp?notificate=יש לאמת את כתובת הדואל")
            End if
	        
            If Getconfig("Useremailvalidationtype") = "Sms" then
     %>
       <form action="/user/login.asp?mode=confirmphonenumber&Email=<%= Request.Form("Email")%>" method="post" name="login" class="_validate">
            <div class="align:center;">
	            <table title="400">
		            <tr>
			            <td colspan="2"><b>הכנסת קוד אימות</b></td>
		            </tr>
		            <tr>
			            <td width="67">Email</td>			
			            <td><input type="text" name="Email" class="required email"></td>	
		            </tr>
		            <tr>
			            <td width="67">קוד אימות:</td>			
			            <td><input type="code" name="code" class="required"></td>	
		            </tr>
		       
	            </table>
            </div>
                <input type="submit" class="send" style="float:left;" value="שלח">
            </form>
<%         End if
	Else
	
		Response.Cookies(SiteID & "UserID") = objRs(0)
Response.Cookies(SiteID & "UserID").Expires=now() + 1
If objRs("Name") <> "" Then 
	Response.Cookies(SiteID & "LoginName") = lcase(objRs("Name"))
	Response.Cookies(SiteID & "LoginName").Expires=now() + 1
End if
Response.Cookies(SiteID & "Password") = objRs("Password")
Response.Cookies(SiteID & "Password").Expires=now() + 1
		Response.Cookies(SiteID & "UserLevel") = objRs("Users9Level")
Response.Cookies(SiteID & "UserLevel").Expires=now() + 1
Response.Cookies(SiteID & "Type") = "User"
Response.Cookies(SiteID & "Type").Expires=now() + 1

	If session(SiteID & "BackURL") = "" Then
		Response.Redirect "http://" & Getconfig("Domains")
	ELse

		Response.Redirect  Replace(URL, " ", "-")
	ENd If
	CloseDB(objRs)
	End if



ElseIf Request.QueryString("mode") = "forgotpassword" Then	
		SQL = "SELECT * FROM " & Table & " WHERE (Email='" & Request.Form("Email") & "') AND SiteID=" & SiteID
		Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
        Response.Redirect("/user/login.asp?forgot=password&notificate=כתובת המייל שהקשת לא נמצאה במערכת")
	Else
            Text2Send = "שלום" & objRs("Name") & "<br />"
            Text2Send = Text2Send & "שלום:" & objRs("Name") & " " & objRs("Familyname") &  "<br />"
            Text2Send = Text2Send & "הודעה זאת נשלחה אליך בגלל שהוגשה בקשה לאפס את הסיסמא" &  "<br />"
            Text2Send = Text2Send & "<a href=""" & Getconfig("Domains") &"/user/login.asp?mode=passwordrecovery&token=" & objRs("Password") &""">לחץ כאן כדי לשחזר את בסיסמא</a>"
            If SendMail("איפוס סיסמא","no_reply@website.com", objRs("Email"), Text2Send) = True Then
            	Response.Redirect("/user/login.asp?notificate=הוראות ההתחברות נשלחו בהצלחה בדוק את תיבת הדאר שלך")
	        End if
    CloseDB(objRs)
	End if




ElseIf Request.QueryString("mode") = "confirmemail" Then	'אימות דואל
		SQL = "SELECT * FROM " & Table & " WHERE (Email='" & Request.querystring("email") & "') AND SiteID=" & SiteID
        'print sql
		Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
        print "הקוד שהוכנס שגוי אין אפשרות לאמת את האימייל"
	Else

        if Md5(objRs("Email")) =  Request.QueryString("code") then
            objRs("Confirmed") = 1
            objRs.update
             dim fs ' אם התבנית קיימת שלח דואל ללקוח
             set fs=Server.CreateObject("Scripting.FileSystemObject")
            othertemplate = templatelocation & "userpanel/mail_after_confirm.html"
                 if fs.FileExists(Server.MapPath(othertemplate))=true then
                     txt2send = getformlayout(GetUrl(othertemplate), SQL, "edit")
                     SendMail LCase(Request.ServerVariables("HTTP_HOST")), "register@yourwebsite.com",objRs("Email"), txt2send

                 End if

            	Response.Redirect("/?notificate=האימייל אושר בהצלחה")
        Else
                Response.Redirect("/user/login.asp?mode=confirmphonenumber&Email="& Request.Form("Email")& "&notificate=הקוד שהוכנס שגוי אין אפשרות לאמת את האימייל")
        End if
    CloseDB(objRs)
	End if
    
    
    ElseIf Request.QueryString("mode") = "confirmphonenumber" Then	' אימות SMS
		SQL = "SELECT * FROM " & Table & " WHERE (Email='" & Request.querystring("email") & "') AND SiteID=" & SiteID
        'print sql
		Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
        print "הקוד שהוכנס שגוי אין אפשרות לאמת את האימייל"
	Else

        if Left(Md5(objRs("Email")),5) =  Request.form("code") then
            objRs("Confirmed") = 1
            objRs.update
            	Response.Redirect("/?notificate=מספר הטלפון אושר בהצלחה")
        Else
        print "הקוד שהוכנס שגוי אין אפשרות לאמת את המספר"
        End if
    CloseDB(objRs)
	End if
ElseIf Request.QueryString("mode") = "passwordrecovery" Then	
		SQL = "SELECT * FROM " & Table & " WHERE (password='" & Request.querystring("token") & "') AND SiteID=" & SiteID
		'print sql
        Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
		Response.Write("<center><b><br><font color=red>" & "ארעה שגיאה.</font></b></center>")						
	Else %>
           <form action="/user/login.asp?mode=newpassword&token=<%= Request.querystring("token")%>" method="post" name="login" class="_validate">
            <div class="checkout1">
	            <table>
		            <tr>
			            <td colspan="2"><b>יצירת סיסמא חדשה</b></td>
		            </tr>
		            <tr>
			            <td width="67">Email</td>			
			            <td><input type="text" name="Email" class="required email"></td>	
		            </tr>
		            <tr>
			            <td width="67">סיסמה:</td>			
			            <td><input type="password" name="password" class="required"></td>	
		            </tr>
		            <tr>
			            <td width="67">סיסמה שוב:</td>			
			            <td><input type="password" name="password1" class="required"></td>	
		            </tr>
	            </table>
            </div>
                <input type="submit" class="send" style="float:left;" value="שלח">
            </form>



   <% CloseDB(objRs)
	End if
    ElseIf Request.QueryString("mode") = "newpassword" Then	
		SQL = "SELECT * FROM " & Table & " WHERE (Email='" & Request.Form("Email") & "') AND (password='" & Request.querystring("token") & "') AND SiteID=" & SiteID
		print SQL
        Set objRs = OpenDB(SQL)
	    If objRs.RecordCount = 0 Then
		    Response.Write("<center><b><br><font color=red>" & "שם משתמש לא נמצא.</font></b></center>")	
            Response.end					
	    ElseIf Not Trim(Request.Form("Password")) = Trim(Request.Form("Password1")) Then
				Response.Write("<br><br><p align='center'>Passwords do not match. <a href='javascript:history.go(-1)'>Go Back</a>!</p>")
       Else
                objRs("Password") = Md5(Request.Form("Password1"))
                objRs.update
            	Response.Redirect("/user/login.asp?notificate=סיסמא שוחזרה בהצלחה")

	    End if
    CloseDB(objRs)

Else
%>

<%
Userheader = GetURL(Getconfig("Userheader"))
ProcessLayout(Userheader)
        If Request.querystring("forgot") = "password" then %>
       <form action="/user/login.asp?mode=forgotpassword" method="post" name="login" class="_validate">
            <div class="checkout1">
	            <table>
		            <tr>
			            <td colspan="2"><b>שיחזור סיסמא</b></td>
		            </tr>
		            <tr>
			            <td width="67">כתובת מייל:</td>			
			            <td><input type="text" name="Email" style="width:250px;direction:ltr;" class="required email"></td>	
		            </tr>
	            </table>
            </div>
                <input type="submit" class="send" style="float:left;" value="שלח">
            </form> 
        <%
        Else
            If getConfig("ApplicationID") <> "" Then %>
                        <!--#include file="../facebook/fblogin.asp"--><%
            end if

			If Request.QueryString("mode") = "lowlevel" Then
					print SiteTranslate("אין לך הרשאה לצפות בדף זה") & " <BR />"
				if Request.Cookies(SiteID & "UserLevel") <> "" then
					print " במידה וקיבלת אישור בדואל עלייך להתנתק ולהתחבר שוב  "
					print "<a href=""/user/login.asp?mode=logout"">לחץ כאן להתנתק מהמערכת ולנסות שוב</a>"
				End if
			End If

            Userlogin = GetURL(Getconfig("Userlogin"))
	        ProcessLayout(Userlogin)
    
            If Getconfig("AllowSeffRegistredUsers") = True then
                    Userregister = GetURL(Getconfig("Userregister"))
	                ProcessLayout(Userregister)
            End if
        End if
Userfooter = GetURL(Getconfig("Userfooter"))
ProcessLayout(Userfooter)

%>
<% 
End If 
Bottom
%>