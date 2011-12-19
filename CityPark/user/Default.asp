<!--#include file="../config.asp"-->
<% 
header
MiniSiteUserLevel = 5


SetSession "BackURL","/user/default.asp"
If Request.Cookies(SiteID & "UserID") = "" Then 
 Response.Redirect("/user/login.asp")
End If

    CheckUserSecurity_Level Request.Cookies(SiteID & "UserLevel"),GetSession("BackURL")

        If Request.QueryString("mode") = "logout" Then
          
           response.cookies("fbs_" & GetConfig("ApplicationID"))=""
           response.cookies("fbs_" & GetConfig("ApplicationID")).expires = Date()-10

		    Response.Cookies(SiteID & "UserID").Expires = Now()-1 'למחוק את העוגייה
		    Response.Cookies(SiteID & "LoginName").Expires = Now()-1 'למחוק את העוגייה
		    Response.Cookies(SiteID & "Password").Expires = Now()-1 'למחוק את העוגייה
		    Response.Cookies(SiteID & "UserLevel").Expires = Now()-1 'למחוק את העוגייה
		    Response.Cookies(SiteID & "Type").Expires = Now()-1 'למחוק את העוגייה
		    Response.Cookies(SiteID & "FB").Expires = Now()-1 'למחוק את העוגייה
			
		    SetSession UserID,""
            Response.Redirect "/"
        End If
			
            
             Userheader = GetURL(Getconfig("Userheader"))
							 ProcessLayout(Userheader)
           
             
             Usertemplate = GetURL(Getconfig("Usertemplate"))
			 ProcessLayout(Usertemplate)
             If len(" "&Request.Cookies(SiteID & "FB")) > 1 Then %>
			 <script type='text/javascript' src='/facebook/fbinit.asp'></script>
			<a href="#" onclick='FB.Connect.logoutAndRedirect("/user/login.asp?mode=logout");return false;' style="background:#F5F5F5;border:1px solid #CCCCCC;float:right;height:160px;margin:10px 0 0 19px;text-align:center;width:150px;"><img src="/sites/stav/layout/he-IL/images/ilogout.png" border="0" alt="התנתק" /><span style="background:#94C94E;color:#FFFFFF;float:right;font-size:16px;font-weight:bold;height:32px;line-height:32px;width:150px;">התנתק</span></a>
			<% else %> 
			<a href="/user/login.asp?mode=logout" style="background:#F5F5F5;border:1px solid #CCCCCC;float:right;height:160px;margin:10px 0 0 19px;text-align:center;width:150px;"><img src="/sites/stav/layout/he-IL/images/ilogout.png" border="0" alt="התנתק" /><span style="background:#94C94E;color:#FFFFFF;float:right;font-size:16px;font-weight:bold;height:32px;line-height:32px;width:150px;">התנתק</span></a>
			<%End if 
           
             Userfooter = GetURL(Getconfig("Userfooter"))
							 ProcessLayout(Userfooter)




 bottom %>
	
