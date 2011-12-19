<!--#include file="config.asp"-->
<% 
header
URL = GetSession("BackURL")
Table = "Users" 

If Request.QueryString("mode") = "AddUser" Then	
	Set objRs = OpenDB("SELECT * FROM " & Table)
		If Not Trim(Request.Form("Password1")) = Trim(Request.Form("Password2")) Then
			Response.Write("<br><br><p align='center'>הסיסמאות לא תואמות. <a href='javascript:history.go(-1)'>חזור אחורה</a>!</p>")
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
								Response.Write("<br><br><p align='center'>שם המשתמש שבחרת כבר תפוס <a href='javascript:history.go(-1)'>חזור אחורה</a>!</p>")			
			CloseDB(objRsUser)
							Else
								objRs.AddNew 
								objRs("Usersname") = lcase(Request.Form("LoginName"))
								objRs("Email") = Trim(Request.Form("Email"))
								objRs("Password") = Trim(Request.Form("Password1"))
								objRs("Admin9Level") = GetConfig("AllowSelfRegister")
								objRs("SiteID") = SiteID
							
								Response.Cookies(SiteID & "LoginName") = lcase(Request.Form("LoginName"))
									Response.Cookies(SiteID & "LoginName").Expires=#May 10,2025#
								Response.Cookies(SiteID & "Password") = Trim(Request.Form("Password1"))
									Response.Cookies(SiteID & "Password").Expires=#May 10,2025#
								Response.Cookies(SiteID & "UserLevel") = GetConfig("AllowSelfRegister")
									Response.Cookies(SiteID & "UserLevel").Expires=#May 10,2025#
								Response.Cookies(SiteID & "Type") = "User"
									Response.Cookies(SiteID & "Type").Expires=#May 10,2025#

								objRs.Update
								objRs.MoveLast()
					
									Response.Cookies(SiteID & "UserID") = objRs(0)
										Response.Cookies(SiteID & "UserID").Expires=#May 10,2025#
								
								'	Response.Write("<br><br><p align='center'>תודה על הרשמתך...</p>")
							
							IF NOT Session(SiteID & "URL") = "" Then
								URL = Session(SiteID & "URL")
							End If
							Response.Write("<meta http-equiv=""refresh"" content=""0;url=" & URL  & """>")
								'	CloseDB(objRs)
							End If
						End If

 Else %>
<form action="userregister.asp?mode=AddUser" id="userregisterform" method="post">
<%
	If Request.Querystring("t") <> "" Then
		TemplateURL = templatelocation  & Request.Querystring("t")& ".html"
	Else
		TemplateURL = templatelocation  & "userregister.html" 
	End if
	Template = GetURL(TemplateURL)
	
	ProcessLayout(Template)
%>
</form>
	<script type="text/javascript">
		new Validation("userregisterform",{stopOnFirst: true});
	</script>

<%
End If 
Bottom
%>