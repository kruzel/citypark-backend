<!--#include file="config.asp"-->

<% 

header
if lcase(Request.QueryString("Table"))= "" then
Table = "Users" 
else
table=lcase(Request.QueryString("Table"))
end if

URL = GetSession("BackURL")


If Request.QueryString("mode") = "logout" Then
		Response.Cookies(SiteID & "UserID").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "LoginName").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "Password").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "UserLevel").Expires = Now()-1 'למחוק את העוגייה
		Response.Cookies(SiteID & "Type").Expires = Now()-1 'למחוק את העוגייה
		Response.Redirect getconfig("webpageURL")
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
								If objRsUser("Usersname") = Trim(Request.Form("LoginName")) Then
								AuthorNickExists = True
								End If
							objRsUser.MoveNext 
							Loop
									If AuthorNickExists = True Then
										Response.Write("<br><br><p align='center'>User Name is not available <a href='javascript:history.go(-1)'>Go Back</a>!</p>")						
						CloseDB(objRsUser)
									Else
							objRs.AddNew 
							objRs("Usersname") = lcase(Request.Form("LoginName"))
							objRs("Email") = Trim(Request.Form("Email"))
							objRs("Password") = EnDecrypt(Request.Form("Password1") ,encryptkey )
							objRs("Users9Level") = GetConfig("AllowSelfRegister")
							objRs("SiteID") = SiteID
							
							Response.Cookies(SiteID & "LoginName") = lcase(Request.Form("LoginName"))
							Response.Cookies(SiteID & "LoginName").Expires=#May 10,2025#
							Response.Cookies(SiteID & "Password") = EnDecrypt(objRs("Password") ,encryptkey )
							Response.Cookies(SiteID & "Password").Expires=#May 10,2025#
							Response.Cookies(SiteID & "UserLevel") = GetConfig("AllowSelfRegister")
							Response.Cookies(SiteID & "UserLevel").Expires=#May 10,2025#
							Response.Cookies(SiteID & "Type") = "User"
							Response.Cookies(SiteID & "Type").Expires=#May 10,2025#

							objRs.Update
							objRs.MoveLast()
					
							Response.Cookies(SiteID & "UserID") = objRs(0)
							Response.Cookies(SiteID & "UserID").Expires=#May 10,2025#
							
							Response.Write("<br><br><p align='center'>תודה על הרשמתך...</p>")
							
							IF NOT Session(SiteID & "URL") = "" Then
								URL = Session(SiteID & "URL")
							End If
							Response.Write("<meta http-equiv=""refresh"" content=""2;url=" & URL  & """>")
									End If
								End If
					
ElseIf Request.QueryString("mode") = "LetMeIn" Then	
		SQL = "SELECT * FROM " & Table & " WHERE (Usersname='" & lcase(CheckHacker(Request.Form("LoginName"))) & "') AND (Password='" & EnDecrypt(Trim(CheckHacker(Request.Form("Password"))) ,encryptkey ) & "') AND SiteID=" & SiteID
        Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
		Response.Write("<center><b><br><font color=red>" & "Username and password do not match, try again.</font></b></center>")						
	Else
		Response.Cookies(SiteID & "UserID") = objRs(0)
Response.Cookies(SiteID & "UserID").Expires=#May 10,2025#
		Response.Cookies(SiteID & "LoginName") = objRs("Usersname")
Response.Cookies(SiteID & "LoginName").Expires=#May 10,2025#
		Response.Cookies(SiteID & "Password") = EnDecrypt(objRs("Password") ,encryptkey )
Response.Cookies(SiteID & "Password").Expires=#May 10,2025#
		Response.Cookies(SiteID & "UserLevel") = objRs("Users9Level")
Response.Cookies(SiteID & "UserLevel").Expires=#May 10,2025#
	
	If URL = "" Then
		Response.Redirect("/")
	ELse
	IF NOT GetSession("BackURL") = "" Then
		Response.Redirect GetSession("BackURL")
	Else
		Response.Redirect URL
	End IF
	ENd If
	'response.write(Session(SiteID & "UserID"))
	CloseDB(objRs)
	End if
Else
%>

<% If Request.QueryString("msg") <> "" Then %>
<div id="msg" style="color: #FF0000;font-weight:bold;"><% = Request.QueryString("msg") %></div>
<% End If %>
<table id="userlogincontainer" align="center" width="100%" border="0">
	<tr valign="top">
	<td>
<div>
<form action="userlogin.asp?mode=LetMeIn" method="post" id="login" name="login">
	<table id="login" align="center" >
		<tr>
			<td id="login-secure" colspan="2">התחברות מאובטחת</td>
		</tr>
		<tr>
			<td id="login-user">שם משתמש:</td>			
			<td><input type="text" dir="ltr"  name="LoginName" class="required"></td>	
		</tr>
		
		<tr>
			<td id="login-password">סיסמא:</td>
			<td><input type="password" dir="ltr" name="Password" class="required"></font></td>
		</tr>
		
		<tr>
			<td id="login-connect" colspan="2" align="left"><input type="submit" value="התחבר"></td>
		</tr>
	</table>
</form>
</div>
	</td>
	<td>
	<div>
    <% If Getconfig("AllowSeffRegistredUsers") = True then %>
<form action="userlogin.asp?mode=AddUser" id="adduser" name="adduser" method="post"  class="_validate">
	<table id="login" align="center" >
		<tr>
			<td id="login-secure"colspan="2">הרשמה לאתר</td>
		</tr>
		
		<tr>
			<td id="login-user">שם משתמש:</td>			
			<td><input type="text" dir="ltr" name="LoginName" id="LoginName" class="required"></td>	
		</tr>
		<tr>
			<td id="login-user">דוא"ל</td>			
			<td><input type="text" dir="ltr"  name="Email" class="required email"></td>	
		</tr>
		<tr>
			<td id="login-password">סיסמא:</td>
			<td><input type="password" dir="ltr"  name="Password1" id="Password1" class="required"></font></td>
		</tr>
		
		<tr>
			<td id="login-password">סיסמא:</td>
			<td><input type="password" dir="ltr"  name="Password2" class="required"></font></td>
		</tr>		
		<div id="login-status"></div>
		<tr>
			<td id="login-connect" colspan="2" align="left"><input type="submit" value="הרשם"></td>
		</tr>
	</table>
</form>
<% End if %>

</div>
	</td>
	</tr>
	</table>
<% 
End If 
Bottom
%>