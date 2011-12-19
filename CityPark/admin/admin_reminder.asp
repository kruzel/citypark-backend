<!--#include file="config.asp"-->
<!--#include file="functions.asp"-->

	<!--#include file="inc_top.asp"-->
	<table bgcolor=<% = Application(ScriptName & "DefaultBGColor") %> border="0" cellpadding="0" cellspacing="0" width="100%" height="300" align="center">
<tr>
<td>

<%	If Request.QueryString("mode") = "doit" Then

		If Trim(Request.Form("Email")) = "" Then
				
			Response.Write("<br><br><p align='center'>לא מלאת את שדה ה-EMail. השתמש מלחצן חזרה בדפדפן על מנת לתקן זאת או לחץ <a href='javascript:history.go(-1)'>כאן</a>!</p>")
					
		Else
				
			If Not ChkEmail(Trim(Request.Form("Email"))) = True Then
						
				Response.Write("<br><br><p align='center'>הכנסת כתובת EMail לא תקינה. השתמש מלחצן חזרה בדפדפן על מנת לתקן זאת או לחץ <a href='javascript:history.go(-1)'>כאן</a>!</p>")
						
			Else				

				Set objConn = Server.CreateObject("ADODB.Connection")
				Set objRs = Server.CreateObject("ADODB.Recordset")
				objConn.Open strConn
				objRs.Open "SELECT AuthorNick, AuthorSID, AuthorPassword FROM Author WHERE AuthorEmail = '" & Trim(Request.Form("Email")) & "'" AND AuthorSID =" & SiteID " &, objConn, 3, 3
							
				If objRs.BOF And objRs.EOF Then
							
					Response.Write("<br><br><p align='center'>ה-EMail המוכנס לא נמצא במסד הנתונים!. <a href='admin_reminder.asp'>לחץ להמשך</a>!</p>")					
							
				Else
			
					TextToSend = "Here is your requested login for " & Application(ScriptName & "WebPageName") & ":" & vbcrlf & vbcrlf
					TextToSend = TextToSend & "Nickname: " & objRs("AuthorNick") & vbcrlf
					TextToSend = TextToSend & "Password: " & objRs("AuthorPassword") & vbcrlf & vbcrlf
					TextToSend = TextToSend & "Plase keep this email or write down the login!!!"
								
					If SendMail(Application(ScriptName & "WebPageTitle") & " Password Reminder", Application(ScriptName & "AdminEmail"), Trim(Request.Form("Email")), TextToSend) Then					
									
						Response.Write("<br><br><p align='center'>פרטי ההתחברות נשלחו לכתובת ה-EMail. <a href='admin_home.asp'>לחץ להמשך</a>!</p>")
						Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_home.asp'>")
									
					Else
								
						Response.Write("<br><br><p align='center'>פרטי ההתחברות לא נשלחו! אנא צור קשר עם <a href='mailto:" & Application(ScriptName & "AdminEmail") & "'>המנהל</a> לפרטים נוספים. <a href='admin_reminder.asp'>לחץ להמשך</a>!</p>")
								
					End If
								
				End If

				objRs.Close					
				objConn.Close 
				Set objRs = Nothing	
				Set objConn = Nothing
							
			End If
					
		End If
	
	Else
%>
		<form action="admin_reminder.asp?mode=doit" method="post">
		<table bgcolor=<% = Application(ScriptName & "DefaultBGColor") %> class="Main" width="100%" height=400 border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td>
		    <table class="Main" border="0" width="100%" cellspacing="1" cellpadding="4">
		      <tr>
		        <td class="Head">
		          <b>הזכרת סיסמא</b>
		        </td>		        
		      </tr>
		      <tr>
		        <td valign="top">
		          <b>אנא הכנס את ה-EMail שלך:</b>
		        </td>
		      </tr>				      
			  <tr>
				<td valign="top" align="center">
				  <input type="text" dir="ltr" name="Email" size="50" maxlength="100">
				</td>
		      </tr>
		      <tr>			
				<td valign="top" align="center" colspan="2">
				  <input type="submit" value="שלח פרטים">			
			    </td>
			  </tr>
			  <tr>
			    <td class="Head" align="left" colspan="2">
			      <a class="Head" href="../admin_home.asp">בחזרה לניהול ראשי</a>
			    </td>
			  </tr>				  				  		      
		    </table>
		    </td>
		  </tr>
		</table>
		</form>

<%	End if
%>
	</td></tr></table>

	<!--#include file="inc_bottom.asp"-->

