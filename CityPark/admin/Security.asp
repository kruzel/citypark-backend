<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->

<% 

If Request.QueryString("mode") = "doit" Then	
		Set objRs = OpenDB("SELECT * FROM Admin WHERE (AdminUserName='" & Trim(Request.Form("Username")) & "') AND (Password='" & Trim(Request.Form("Password")) & "') AND SiteID=" & SiteID)
		
	If objRs.RecordCount = 0 Then
		Response.Write("<table align=""center"" valign=""middle"" height=""300""><tr><td><div id=""error"">שם משתמש או סיסמא שגויים. נא נסה שנית</div></td></tr></table>")
	Else
		Session(SiteID & "UserID") = objRs(0)
		Session(SiteID & "Username") = objRs("AdminUserName")
		Session(SiteID & "Password") = objRs("Password")
		Session(SiteID & "AdminLevel") = objRs("Admin9Level")
		'Session(SiteID & "UserLevel") = objRs("Admin9Level")
		Session(SiteID & "Type") = "Admin"
			Response.Redirect(Session(SiteID & "URL"))
	End If
	
	CloseDB(objRs)
ElseIf Request.QueryString("mode") = "denied" Then
	Response.Write("<table align=""center"" valign=""middle"" height=""300""><tr><td><div id=""error""> אין לך גישה לדף זה </div></td></tr></table>")
ElseIf Request.QueryString("mode") = "logout" Then
		Session(SiteID & "Username") = ""
		Session(SiteID & "Password") = ""
		Session(SiteID & "AdminLevel") = ""
		Session(SiteID & "UserLevel") = ""
		Session(SiteID & "Type") = ""
Else
%>

<script language="javascript">
	function ValidateForm(form)
	{
		if(IsEmpty(form.Username)) 
		{ 
			alert('עליך להזין שם משתמש.') 
			form.Username.focus(); 
			return false; 
		} 

		if(IsEmpty(form.Password)) 
		{ 
			alert('עליך להזין סיסמא.') 
			form.Password.focus(); 
			return false; 
		} 
  
		return true;
	} 

	function IsEmpty(aTextField) {
		if ((aTextField.value.length==0) ||
			(aTextField.value==null)) {
			return true;
		}
		else { return false; }
	}	

</script>

<form name="Login" action="Security.asp?mode=doit" method="post" onsubmit="javascript:return ValidateForm(Login)">
	<table id="login" align="center" >
		<tr>
			<td id="login-secure"colspan="2">התחברות מאובטחת</td>
		</tr>
		<tr>
			<td id="login-user">שם משתמש:</td>			
			<td><input type="text" name="Username"></td>	
		</tr>
		
		<tr>
			<td id="login-password">סיסמא:</td>
			<td><input type="password" name="Password"></font></td>
		</tr>
		
		<tr>
			<td id="login-connect" colspan="2" align="left"><input type="submit" value="התחבר"></td>
		</tr>
	</table>
</form>
<% 
End If 
Bottom

%>