<!--#include file="config.asp"-->
<!--#include file="functions.asp"-->
<!--#include file="$db.asp"-->
<!--#include file="inc_top.asp"-->

<head>
<script type="text/javascript" src="/js/validation.js"></script>
<meta http-equiv="Content-Language" content="he">
</head>

<%
print GetSession("URL")&"11111111111111111"
if lcase(Request.QueryString("Table"))= "" then
Table = "Users" 
else
table=lcase(Request.QueryString("Table"))
end if

If Request.QueryString("mode") = "logout" Then
		Response.Cookies(SiteID & "UserID") = ""
		Response.Cookies(SiteID & "LoginName") = ""
		Response.Cookies(SiteID & "Password") = ""
		Response.Cookies(SiteID & "UserLevel") = ""
		Response.Cookies(SiteID & "URL") = ""
		Response.Cookies(SiteID & "Type") = ""
		Response.Cookies(SiteID & "2UsersID") = ""
		Response.Redirect GetSession("URL")
		
End If

If Request.QueryString("mode") = "AddUser" Then	

		Set objRs = OpenDB("SELECT * FROM " & Table)
				If Not Trim(Request.Form("Password1")) = Trim(Request.Form("Password2")) Then
						Response.Write("<br><br><p align='center'>Passwords do not match. <a href='javascript:history.go(-1)'>Go Back</a>!</p>")
				Else
					If Not ChkEmail(Trim(Request.Form("email"))) = True Then
							Response.Write("<br><br><p align='center'>Wrong E-Mail <a href='javascript:history.go(-1)'>Go Back</a>!</p>")
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
							objRs("Password") = Trim(Request.Form("Password1"))
							objRs("Admin9Level") = 9
							objRs("SiteID") = SiteID
							
							Response.Cookies(SiteID & "LoginName") = lcase(Request.Form("LoginName"))
							Response.Cookies(SiteID & "LoginName").Expires=#May 10,2025#
							Response.Cookies(SiteID & "Password") = Trim(Request.Form("Password1"))
							Response.Cookies(SiteID & "Password").Expires=#May 10,2025#
							Response.Cookies(SiteID & "UserLevel") = 9
							Response.Cookies(SiteID & "UserLevel").Expires=#May 10,2025#
							Response.Cookies(SiteID & "Type") = "User"
							Response.Cookies(SiteID & "Type").Expires=#May 10,2025#

							objRs.Update
							objRs.MoveLast()
					
							Response.Cookies(SiteID & "UserID") = objRs(0)
							Response.Cookies(SiteID & "UserID").Expires=#May 10,2025#
							
							Response.Write("<br><br><p align='center'>Thank You For Signing Up. Please Whait...</p>")
							
							IF NOT GetSession("URL") = "" Then
								URL = GetSession("URL")
							End If
							Response.Write("<meta http-equiv=""refresh"" content=""2;url=" & URL  & """>")
								'	CloseDB(objRs)
									End If
								End If
							End If	
					
ElseIf Request.QueryString("mode") = "LetMeIn" Then	
	Set objRs = OpenDB("SELECT * FROM " & Table & " WHERE (Usersname='" & lcase(Request.Form("LoginName")) & "') AND (Password='" & Trim(Request.Form("Password")) & "') AND SiteID=" & SiteID)
	If objRs.RecordCount = 0 Then
		'Response.Write("SELECT * FROM " & Table & " WHERE (Usersname='" & lcase(Request.Form("LoginName")) & "') AND (Password='" & Trim(Request.Form("Password")) & "') AND SiteID=" & SiteID)
		Response.Write("<center><b><br><font color=red>" & "Username and password do not match, try again.</font></b></center><br><br>")						
	Else
		Response.Cookies(SiteID & "UserID") = objRs(0)
Response.Cookies(SiteID & "UserID").Expires=#May 10,2025#
		Response.Cookies(SiteID & "LoginName") = objRs("Usersname")
Response.Cookies(SiteID & "LoginName").Expires=#May 10,2025#
		Response.Cookies(SiteID & "Password") = objRs("Password")
Response.Cookies(SiteID & "Password").Expires=#May 10,2025#
		Response.Cookies(SiteID & "UserLevel") = objRs("Admin9Level")
Response.Cookies(SiteID & "UserLevel").Expires=#May 10,2025#
		Response.Cookies(SiteID & "2UsersID") = objrs("UsersID")
		Response.Cookies(SiteID & "2UsersID").Expires=#May 10,2025#

	'IF NOT GetSession("URL") = "" Then
	'	Response.Redirect GetSession("URL")
	'Else
		Response.Redirect GetSession("URL")
	'End IF
	CloseDB(objRs)
	End if
ElseIf Request.QueryString("mode") = "forgot" Then
	Set EmailRs = OpenDB("SELECT usersname,password FROM users WHERE (Email='" & Trim(Request.Form("Email")) & "') AND SiteID=" & SiteID)
	if not EmailRs.Eof then 
		Text2Send = " Hello "&EmailRs("usersname")
		Text2Send = Text2Send &"<BR>"
		Text2Send = Text2Send &"You forgot your password,"
		Text2Send = Text2Send &"<BR>"
		Text2Send = Text2Send &"Your password is:"
		Text2Send = Text2Send &"<BR>"
		Text2Send = Text2Send &EmailRs("password")
		Text2Send = Text2Send &"<BR>"
		Text2Send = Text2Send &"<a href=""http://www.favocards.com"">Click here to Login</a>"
		Text2Send = Text2Send &"<BR>"
		Text2Send = Text2Send &"FavoCard Team"
		SendMail "Password Reminder", "Password Reminder", Request.Form("Email"), Text2Send
	End if
Response.Write("<b><br><font color=red>Your password was sent!<br></b> " & "Chack your Email<br><br>" )						
	CloseDB(EmailRS)
Else


%>

<font face="Arial">

<br />
</font>
<div align="center">
	<table border="0" cellpadding="0" cellspacing="0" dir=ltr width="100%" background="/images/loginbg.jpg" height="350">
		<tr>
			<td align="center">	
	
					<b><font face="Arial" size="2">	
	
					<span lang="en-us">
<table border="0" width="296" cellspacing="0" height="270" background="/images/loglog.png"><tr>
	<td valign="top" height="210" style="border: 1px solid #cccccc">
<div align="center">
	<table border="0" width="274" cellspacing="0" cellpadding="3" height="44">
		<tr>
			<td><font face="Arial" size="2"><b><font color="#0076BA">In the business 
		world, who remembers you? And on the Internet?<br>
		Do you own a web site? Do you want everyone to remember your site on the 
		Internet?</font><br>
		<span lang="en-us">&nbsp;</span></b><br>
		Design free of charge, your site’s Internet business card and remind 
		your visitors and clients daily that you are still in business.<br>
		Transform your sites business advantage into a winning internet business 
		card!!!</font></td>
		</tr>
	</table>
</div>
</td></tr><tr>
	<td valign="top">
&nbsp;</td></tr></table>
</span></font></b><table dir="rtl" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><b><font face="Arial" size="2"><% =Application(ScriptName & "UserLoginExtraText") %></font></b></td>
						</tr>
					</table>	

					<b><font face="Arial" size="2">	
	
<% End If %>
<% if Request.QueryString("forgotpassword") <> "true" Then %>
					</font></b></td>
			<td align="center">	
	
					<b><font face="Arial" size="2">	
	
					<span lang="en-us">
			<form name="AddUser" id="adduser" action="UserLogin.asp?mode=AddUser" method="post" >
<table border="0" width="296" cellspacing="0" height="270" background="/images/loglog.png"><tr>
	<td valign="top" height="210" style="border: 1px solid #cccccc">
<div align="center">
<table border="0" width="274" cellspacing="0" height="44" cellpadding="3">
	<tr>
		<td colspan="2"><div align="left">
			<span style="font-size:24px;"><b><font color="#0076BA">Sign Up</font> -&nbsp; It's Free!</b></span></div></td>
	</tr>
	<tr>
		<td width="102">
														<font face="Arial" size="2">User Name</font></td>
		<td width="160"><font face="Arial">
														<input name="LoginName" id="loginname" class="required" dir="ltr" style="width:125px;font-weight: 700"></font></td>
	</tr>
	<tr>
		<td width="102">
														<font face="Arial" size="2">Email</font></td>
		<td width="160"><font face="Arial">
														<input name="Email" class="required validate-email" dir="ltr" style="width:125px;font-weight: 700"></font></td>
	</tr>
	<tr>
		<td width="102">
														<font face="Arial" size="2">Password</font></td>
		<td width="160"><font face="Arial">
														<input type="password" name="Password1" id="Password1"  dir="ltr" style="width:125px;font-weight: 700"></font></td>
	</tr>
	<tr>
		<td width="102">
														<font face="Arial" size="2">Confirm</font></td>
		<td width="160"><font face="Arial">
														<input type="password" name="Password2" id="Password2" class="required validate-password-confirm" dir="ltr" style="width:125px;font-weight: 700"></font></td>
	</tr>
	<tr>
		<td width="102">&nbsp;</td>
		<td width="160"><font face="Arial">
														<input type="submit" value="Sign up" style="float: left; "></font></td>
	</tr>
</table>
</div>
</td></tr><tr>
	<td valign="top">
&nbsp;</td></tr></table>
</form></span></font></b><table dir="rtl" width="<% =Application(ScriptName & "LoginBGImageWidth") %>" height="<% =Application(ScriptName & "LoginBGImageHeight") %>" >
						<tr>
							<td><b><font face="Arial" size="2"><% =Application(ScriptName & "UserLoginExtraText") %></font></b></td>
						</tr>
					</table>	

					<b><font face="Arial" size="2">	
	
<% End If %>
<% if Request.QueryString("forgotpassword") <> "true" Then %>
					</font></b></td>
					<td align="center">
						<form name="LetMeIn" id="letmein" action="UserLogin.asp?mode=LetMeIn&<% = Request.QueryString %>" method="post" >
<table border="0" width="282" cellspacing="0" height="270" background="/images/loglog.png"><tr>
	<td valign="top" height="210" style="border: 1px solid #cccccc">
<div align="center">
<table border="0" width="263" cellspacing="0" height="44" cellpadding="3">
	<tr>
		<td colspan="2">
	
					<b>
					<font face="Arial" color="#0076BA" style="font-size: 24px">	
	
					<span lang="en-us">		
										Sign In</span></font></b></td>
	</tr>
	<tr>
		<td width="108"><font face="Arial" size="2">	
	
					<span lang="en-us">
			User Name</span></font></td>
		<td width="143"><font face="Arial">
												<input name="LoginName" id="loginname" class="required" dir="ltr" style="width:125px;font-weight: 700"></font></td>
	</tr>
	<tr>
		<td width="108"><font face="Arial" size="2">	
	
					<span lang="en-us">
			Password</span></font></td>
		<td width="143"><font face="Arial">
												<input type="password" name="Password" class="required" dir="ltr" style="width:125px;font-weight: 700"></font></td>
	</tr>
	<tr>
		<td width="108">&nbsp;</td>
		<td width="143">
												<font face="Arial">
												<input type="submit" value="Sign in" style="float: left; "></font></td>
	</tr>
	<tr>
		<td width="108">&nbsp;</td>
		<td width="143">
												<font face="Arial" size="2"><a href="?forgotpassword=true">Fo<span lang="en-us">r</span>g<span lang="en-us">o</span>t your password?</a></font></td>
	</tr>
	</table>	
</div>
</td></tr><tr>
	<td valign="top">
&nbsp;</td></tr></table>						
</form>
					</td>
				</div>
			</tr>
	</table>
</div>
<b><font face="Arial" size="2">
<% else %>
 <td>
	</font></b>
	<form name="forgotpassword" id="forgotpassword" action="UserLogin.asp?mode=forgot" method="post" >
	<div align="center">
	<table border="0" width="282" cellspacing="0" height="270" background="/images/loglog.png">					
			<tr>
				<td cellpadding="0" cellspacing="0" valign="top"  align="center" width="80%" height="210" style="border: 1px solid #cccccc">
					<table border="0" width="263" cellspacing="0" height="78" cellpadding="3">
						<tr>
							<td colspan="2"><span lang="en-us"><b>
							<font face="Arial" style="font-size: 24px" color="#0076BA">
							Forgot Password</font></b></span><b><font color="#0076BA" face="Arial" size="2"><span style="font-size:24px;" lang="en-us">?</span></font></b></td>			
						</tr>
						<tr>
							<td><font face="Arial" size="2">Enter Email</font></td>			
							<td><font face="Arial">
							<input name="email" id="email" class="required validate-email" size="16" dir="ltr" style="font-weight: 700"></font></td>	
						</tr>
						<tr>
							<td></td>
							<td><font face="Arial">
							<input type="submit" value="Get Password"></font></td>
						</tr>
						<tr>
							<td colspan="2"></td>
						</tr>
					</table>	
				</td>
			</tr>
			<tr>
				<td cellpadding="0" cellspacing="0" valign="top"  align="center" width="80%">
					&nbsp;</td>
			</tr>
		</table>	
	</div>
	</form>
<b><font face="Arial" size="2">
</tr>
</td>
</table>
</div>
<%
End if
%>
<script type="text/javascript">
	new Validation('adduser',{stopOnFirst:true}); // OR new Validation(document.forms[0]);
		Validation.addAllThese([
	['validate-password', 'Very Good!', {
		minLength : 4,
		notOneOf : ['0123','1234','2345','3456','4567','5678','6789','7890'],
		notEqualToField : 'loginname'
	}],
	['validate-password-confirm', 'Password do not match!', {
		equalToField : 'Password1'
	}]
	]);
	
</script></font></b>
<font face="Arial" size="2">
<!--#include file="inc_bottom.asp"--></font>