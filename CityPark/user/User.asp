<!--#include file="../config.asp"-->
<% 
header
Userheader = GetURL(Getconfig("Userheader"))
		 ProcessLayout(Userheader)

SetSession "BackURL","/user/user.asp"
If Request.Cookies(SiteID & "UserLevel") = "" Then 
 Response.Redirect("/userlogin.asp")
End If
    CheckUserSecurity_Level Request.Cookies(SiteID & "UserLevel"),GetSession("BackURL")


	If Request.QueryString("mode") = "edit" Then
	   
	       	 Editmode= "True"

	            
				    Sql = "SELECT * FROM Users WHERE ID=" & Request.Cookies(SiteID & "UserID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
				                objRs("Usersname") = Trim(Request.Form("Usersname"))
								'objRs("Password") = EnDecrypt(Request.Form("Password") ,encryptkey )
								objRs("Name") = Trim(Request.Form("Name"))	
								objRs("FamilyName") = Request.Form("FamilyName")
								objRs("Address") = Trim(Request.Form("Address"))
								objRs("Address2") = Request.Form("Address2")	
								objRs("City") = Request.Form("City")	
								objRs("Country") = Trim(Request.Form("Country"))	
								objRs("Zipcode") = Trim(Request.Form("Zipcode"))
								objRs("Phone") = Trim(Request.Form("Phone"))
								objRs("cellular") = Trim(Request.Form("cellular"))
								objRs("Email") = Trim(Request.Form("Email"))
								objRs("image") = Trim(Request.Form("image"))
								If Request.form("tlchomesID") <> "" then
									objRs("tlchomesID") = Trim(Request.form("tlchomesID"))
								End if
								If Request.form("tlcclassID") <> "" then
									objRs("tlcclassID") = Trim(Request.form("tlcclassID"))
								End if
								objRs("other1") = Trim(Request.form("other1"))
								objRs("other2") = Trim(Request.form("other2"))
								objRs("other3") = Trim(Request.form("other3"))
								objRs("other4") = Trim(Request.form("other4"))
								objRs("other5") = Trim(Request.form("other5"))
								objRs("other6") = Request.Form("other6")
								objRs("other7") = Request.Form("other7")

								    If Request.Form("MailingList") = off Then
								        MailingList = 0
								    Else
									    MailingList = 1
								    End If
								objRs("MailingList") = MailingList
								    If Request.Form("SendSms") = off Then
								        SendSms2 = 0
								    Else
								    	SendSms2 = 1
								    End If
								objRs("SendSms") = SendSms2
								
							objRs.Update
							Set objRs = OpenDB("Select TOP 1 * FROM Users WHERE ID=" & Request.Cookies(SiteID & "UserID") & " AND SiteID=" & SiteID & " Order By id Desc")
								UsersID = objRs("ID")
								CloseDb(objRs)
							ExecuteRS("DELETE FROM [UsersPerCategory] WHERE UsersID = " & Request.Cookies(SiteID & "UserID") & " AND SiteID=" & SiteID)	

                             For Each r in Request.Form
						        If LCase(Mid(r, 1, Len("category"))) = "category" Then
							        If Request.Form(r) = "on" Then
										ExecuteRS("INSERT INTO [UsersPerCategory] (UsersID, UsersCategoryID, SiteID) VALUES (" & UsersId & ", " & mid(r,9) & ", " & SiteID & ");")
							        End If			
						        End If
					        Next
																							
									Response.Write("<br><br><p align='center'>פרופיל נערך בהצלחה. <a href='/user/'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=/user/?S=" & SiteID & "'>")

	        
		Else
		Sql = "SELECT * FROM Users WHERE ID=" & Request.Cookies(SiteID & "UserID") & " AND SiteID=" & SiteID
		Set objRs = OpenDB(SQL)
			If Session("Level") > 3 Then 
				Response.Write("<br><br><p align='center'>אין לך הרשאה לבצע פעולה זאת <a href='user_home.asp'>נסה שנית</a>!</p>")
			ElseIf objRs.RecordCount = 0 Then
				print "פעולה לא חוקית אנא חזור לאחור ונסה שוב"
		    Else
		    Editmode = "True"
   
rr = "<tr><td align=""right"" valign=""top"">קבוצה: <small><a href=""javascript:SelectEverything();"">סמן הכל</a> | <a href=""javascript:SelectNothing();"">נקה</a></small></td><td valign=""top"" align=""right""><table width=""0"">"

Set objRsCategory = OpenDB("SELECT * FROM UsersCategory Where SiteID= " & SiteID)			

Do Until objRsCategory.Eof
    Selected = False
    SQLUser = "Select * FROM UsersPerCategory Where usersID=" & Request.Cookies(SiteID & "UserID") & " AND UsersCategoryID=" & objRsCategory("ID")
    
    Set objRsUser = OpenDB(SQLUser)
    If objRsUser.RecordCount > 0 Then Selected = True
	CloseDB(objRsUser)

                           
	rr = rr & "<tr><td><input type=""checkbox"" name=""category" & objRsCategory(0) & """"
    
    If Selected Then rr = rr & " checked=""1"""
       
    rr = rr & "/></td><td>" & objRsCategory("Name") & "</td></tr>"
							
                            
							objRsCategory.MoveNext
						Loop						
										
					  objRsCategory.Close
					  Set objRsCategory= Nothing
					  
					 rr = rr & "</table></td></tr>"

 %><script type="text/javascript">
       function SelectEverything() {
           var elements = document.getElementsByTagName("input");

           for (i = 0; i < elements.length; i++) {
               if (elements[i].type == "checkbox") {
                   elements[i].checked = "checked";
               }
           }
       }

       function SelectNothing() {
           var elements = document.getElementsByTagName("input");

           for (i = 0; i < elements.length; i++) {
               if (elements[i].type == "checkbox") {
                   elements[i].checked = "";
               }
           }
       }
	
 </script>
<form action="user.asp?mode=edit" method="post" id="users" name="users" class="_validate">
<div class="checkout1">
<div id="incontentform">
<form action="admin_users.asp?mode=doit" method="post" id="content2" name="content2" class="_validate">
			<%   Print GetFormLayout(Replace(getfile("userpanel/user.html"), "[categories]", rr), Sql, "edit") %>

						<tr>
						<td align="right" colspan="2"><input type="submit" value="שמור" class="send"  /></td>
					</tr>
                    </table>
                 </div>
            </div>
        </div>
	</div>
</form>


<%	
End if
End if

%>
	<script type="text/javascript">
	    //	    new Validation("loginform", { stopOnFirst: true });
	    (function($) {
	        $(document).ready(function() {
	            var isValid = false;

	            jQuery("#loginform").submit(function() {
	                if (isValid) {
	                    return true;
	                }
	                else {
	                    $.getJSON("/checkavailable.asp?m=login&username=" + $("#Username").val() + "&password=" + $("#Password").val(), function(data) {
	                        if (data.correct)
	                            isValid = true;
	                        else {
	                            isValid = false;
	                            $("#login-status").text("פרטי ההתחברות אינם נכונים");
	                        }

	                        $("#loginform").submit();
	                        return false;
	                    });

	                    return false;
	                }
	            });
	        });
	    })(jQuery);
	</script>
<%
Userfooter = GetURL(Getconfig("Userfooter"))
							 ProcessLayout(Userfooter)
bottom
%>