<!--#include file="../config.asp"-->
<%
if getConfig("ApplicationID") <> "" Then
%>
<!--#include file="../facebook/fblogin.asp"-->
<% End if %>

<form action="/user/login.asp?mode=LetMeIn" method="post" class="_validate">
    
    <table class="shortlogin">
<% If Request.Cookies(SiteID & "LoginName") = "" Then %>
		<tr>		
			<td><input type="text" dir="ltr"  name="Email" class="loginmame required email" onblur="if(this.value=='')this.value='דואל';" onfocus="if(this.value=='דואל')this.value='';" value="דואל"></td>	
		</tr>
		
		<tr>
			<td><input type="password" dir="ltr" name="Password" class="smallpass" onfocus="if(this.value=='סיסמא')this.value='';" onblur="if(this.value=='')this.value='סיסמא';" value="סיסמא"></td>
		</tr>
		<tr>
			<td colspan="2">
				<a href="/user/login.asp" class="smallsignin">הירשם</a>
				<input type="submit" class="smalllogin" value="התחבר">
			</td>
		</tr>
<% Else %>
		<tr>
		<td>
			<div id="login-message">שלום לך <a href="/user/"><% = Request.Cookies(SiteID & "LoginName") %></a>, <a href="/user/login.asp?mode=logout">התנתק</a>.</div>
		</td>
		</tr>

<% End If %>	
	</table>
</form>
