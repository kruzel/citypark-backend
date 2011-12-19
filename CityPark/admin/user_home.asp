<!--#include file="../config.asp"-->
<html>
<head>
</head>
<body>
<p align=center>
	<table bgcolor= "#FFFFFF" width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td align="center">
<% 
Sub IpAddressDisplay
dim ipaddress
ipaddress=Request.ServerVariables("REMOTE_ADDR")
response.write ipaddress
End Sub

'Function CheckHacker(strTemp)

	'strTemp = Replace(strTemp, "'", "@")
	'strTemp = Replace(strTemp, "=", "@")
	'strTemp = Replace(strTemp, "Like", "@")

	'CheckHacker = strTemp
	
'End Function 

Function LogThisEntry()

			    '/////////Log This Entry
				objRslogin.open "SELECT * FROM adminlogins" ,objConn, 3, 3
				objRslogin.AddNew
				
				objRslogin("loginip")= Request.ServerVariables("REMOTE_ADDR")
				objRslogin("loginsitename")=  Application(ScriptName & "SiteName")
				objRslogin("loginsiteid")= SiteId
				objRslogin("logintime")= logintime
				objRslogin("loginusername")= struser
				objRslogin("loginpass")= strpass
				objRslogin("loginsuccseed")= loginsuccseed 
				
				objRslogin.Update
				objRslogin.close
				Set objRslogin=Nothing
				'/////////End Log This Entry


End Function 
If Request.QueryString("Logout") = "1" Then

	Session("LoggedIn") = False
	Response.Write("<meta http-equiv='Refresh' content='0; URL=default.asp'>")
	
End If
session("LogError") = 0
If Session("LogError") < 3 Then
	
		If Not Session("LoggedIn") = True&SiteID Then		
		
			If Request.QueryString("Login") = "1" Then
				 
			     struser=Request.Form("Nickname")
			     strpass=Request.Form("Password")
			     logintime=Now()
			     
			     
				 Set objConn = Server.CreateObject("ADODB.Connection")
			     Set objRs = Server.CreateObject("ADODB.Recordset")
			     Set objRslogin = Server.CreateObject("ADODB.Recordset")
				 objConn.Open strConn
				
			     
			     objRs.Open "SELECT * FROM Author WHERE AuthorNick = '" &_
			      	
			      	CheckHacker(struser) & "' AND AuthorPassword = '" &_
			     	CheckHacker(strpass) & "' AND SiteID = " & SiteID & " ", objConn, 0, 1
			     
			    If objRs.BOF And objRs.EOF Then
			   
					Session("LoggedIn") = False
					loginsuccseed = "No"
				LogThisEntry()


					%>	

		<table bgcolor="white" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr valign=top>
				<td>
				<%

					Response.Write("<br><br><p align='center'>נתוני התחברות שגויים. אנא <a href='default.asp'>נסה שנית</a>!</p>")
					Response.Write("<p align='center'>במקרה ושכחת את סיסמתך, <a href='user_reminder.asp'>לחץ כאן</a>!")
					Session("LogError") = Session("LogError") + 1
			 	%>
				</td>
			</tr>
		</table>	
			<%

			     Else
			     
			     loginsuccseed = "Yes"
			     LogThisEntry()

				
					Session("Level") = objRs("Admin9Level")
					Session("AuthrID") = objRs("AuthorID")
					Session("LoggedIn") = True&SiteID
					
					If NOT Session(SiteID & "BackURL") = "" And Int(Session("Level")) = 4 Then
						Response.Redirect(Session(SiteID & "BackURL"))
		  				Session(SiteID & "BackURL") = ""
		  			Else
					%>	

		<table bgcolor="white" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr valign=top>
				<td>
				<font size="2" face="arial" color="#000000">
				<%
				
					Response.Write("<br><br><p align='center'>נתוני התחברות נכונים. אנא <a href='default.asp'>לחץ כאן</a>!</p>")
					'Response.Write("<meta http-equiv='Refresh' content='1; URL=default.asp'>")
											'Response.Redirect("default.asp")

			   	%>
				</font>
				</td>
			</tr>
		</table>	
			<p></p>
			<p>	
			<%
  				
  				End If
  				
			     End If
			     
			     objRs.Close
			     objConn.Close 
			     Set objConn = Nothing
			     Set objRs = Nothing
		
			Else
%>
			
		
				<form name="Login" action="default.asp?Login=1&S=<% = Session("S") %>" method="post">
			 
			<div align="center">
			<table border="1" cellpadding="3" cellspacing="0" bordercolor="#cccccc">
			<tr>
			<td> 
			<table bgcolor="white" width="100%" class="Main" border="0" cellpadding="2" dir=rtl>
					  <tr>
					    <td class="Head" align="center" colspan="2" bgcolor="#6699FF" height="25">
					      <font face="Arial" size="2" color="#FFFFFF">
					      <b>כניסה מאובטחת</b>
					    </font>
					    </td>
					  </tr>
					  <tr>
					    <td align="left" valign="middle">
					      <p align="right"><font face="Arial" size="2">הכנס את הכינוי שלך:
					    	</font>
					    </td>
					    <td valign="middle">
					      <font face="Arial">
					      <input name="Nickname" size="20" style="float: left"><font size="2">
							</font></font>
					    </td>
					  </tr>
					  <tr>
					    <td align="left" valign="middle">
					      <p align="right"><font face="Arial" size="2">הכנס את הסיסמא שלך:
					    	</font>
					    </td>
					    <td valign="middle">
					      <font face="Arial">
					      <input type="password" name="Password" size="20" style="float: left"><font size="2">
							</font></font>
					    </td>
					  </tr>
					  
					  <tr>
					    <td align="center">
					      <p align="right"><font face="Arial">
					      <a href="../OLD_FILES/user_reminder.asp"><small><font size="1">אופס! שכחתי את הסיסמא שלי.</font></small></a><font size="1">
							</font></font>
					    </td>
					    <td align="center">
					      <span lang="he"><input type="submit" value="התחבר" style="float: left"><font size="2"></span></td>
					  </tr>
					   <tr>
					    <td colspan="2" align="center">

					 <p><font face="Arial" size="2">כתובת האינטרנט שלך נרשמה במערכת: <b><%IpAddressDisplay%></b> 
						</font> </p>
					 
						</td>
					  </tr>

					  
					 
					  </table>
					  </div>
					  </p>
				</form> 
		
<%			End If
	
		Else
%>
			

    			<table width="100%" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="0">
			</td>
			</tr>
			</table>		
			  <tr>
			    <td>
			    <!--#include file="inc_admin_icons.asp"-->
			   </td>
			  </tr>
			</table>
						
<%		End If
		
	Else
		

		Response.Write("<br><br><p align='center'>ניסית 3 פעמים להתחבר. עליך לחכות כעת על מנת לנסות שוב!</p>")
		Response.Write("<p align='center'>במקרה ושכחת את סיסמתך, <a href='user_reminder.asp'>לחץ כאן</a>!")
			  
	End If
	
%></td></tr></table>
</body>
</html>