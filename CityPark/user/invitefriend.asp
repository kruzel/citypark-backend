<!--#include file="../config.asp"-->
<% 
header


SetSession "BackURL","/user/invitefriend.asp"
If Request.Cookies(SiteID & "UserLevel") = "" Then 
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
		    SetSession UserID,""
            Response.Redirect "/"
        End If
			
            
             Userheader = GetURL(Getconfig("Userheader"))
							 ProcessLayout(Userheader)
                 
            Sqluser ="Select * FROM users Where Id = " & Request.Cookies(SiteID & "UserID")
            Set objRsuser=OpenDB(Sqluser)
             Usertemplate = GetURL(Templatelocation & "userpanel/invitefriend.html")
					For Each Field In objRsuser.Fields
					value = objRsuser(Field.Name)
						If Len(value) > 0 Then
							    Usertemplate = Replace(Usertemplate, "[" & Field.Name & "]", value)
							    Usertemplate = Replace(Usertemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
						Else
							    Usertemplate = Replace(Usertemplate, "[ref_link]","http://" & LCase(Request.ServerVariables("HTTP_HOST")) & "/?ref=" & Md5(objRsuser("Id")& encryptkey))
							    Usertemplate = Replace(Usertemplate, "[" & Field.Name & "]", "")
						End If
					Next
							 ProcessLayout(Usertemplate)
	        
             Userfooter = GetURL(Getconfig("Userfooter"))
							 ProcessLayout(Userfooter)




 bottom %>
	
