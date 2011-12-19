<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type='text/javascript'>
    $(function () {
        $('#east').tipsy({ html: true });
    });
</script>

<%

CheckSecuirty "site"
If request.querystring("deletecache") = "True" then
	deletecache "all"
	print " נמחק "
	response.end
End if
If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then

%>
<!--#include file="right.asp"-->
	<div id="incontent">
	<div class="incontentboxgrid">
<center>
<%
	If Request.QueryString("records") = "" Then
	Session("records") = 50
	Else 
	Session("records") = Request.QueryString("records")
	End If

CheckSecuirty "site"
 %>   
    <div class="formtitle">
        <h1>ניהול הגדרות אתר</h1>
		<div class="admintoolber">
        <form action="admin_site.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_site.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_site.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_site.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_site.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
					<option value="10" <%if Session("records") = 10 then print "selected" End if%>>10</option>
					<option value="20" <%if Session("records") = 20 then print "selected" End if%>>20</option>
					<option value="50" <%if Session("records") = 50 then print "selected" End if%>>50</option>
					<option value="100" <%if Session("records") = 100 then print "selected" End if%>>100</option>
					<option value="1000" <%if Session("records") = 1000 then print "selected" End if%>>1000</option>
				</select>
			</p>
			<p class="reshumot">רשומות לדף:</p>
	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th style="width:10%;" class="recordid">ID</th>
		<th style="width:80%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>ערוך</th>
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM site WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM site WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
    End If
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין רשומות"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
Do While Not objRs.EOF And HowMany < objRs.PageSize
            	%>
    <tr>
        <td><%= objRs("SiteID")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("SiteID") %>_Name"><% = objRs("SiteName") %></span></td>
        <td><a href="admin_site.asp?ID=<% = objRs("SiteID") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
	</tr>	
 <%	 HowMany = HowMany + 1
       objRs.MoveNext
		 Loop

      objRs.Close
    End If
End If
%>
</tbody>
</table></div>
<%	 
Else
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	       Case "add"
	     
         
           Case "edit"
                       SQL =  "SELECT TOP 1 * FROM Site  Where SiteID=" &  SiteID &  " AND SiteID=" & SiteID 
                        Set objRs = OpenDB(SQL)
                        
                        objRs("Title") = Trim(Request.Form("Title"))
						objRs("Keywords") = Request.Form("Keywords")
						objRs("Description") = Trim(Request.Form("Description"))
						objRs("domains") = Trim(Request.Form("domains"))
						objRs("LangID") = Request.Form("lang")
						objRs("HomePageID") = Request.Form("HomePageID")
						objRs("Sender") = Trim(Request.Form("Sender"))
						objRs("AdminEmail") = Trim(Request.Form("AdminEmail"))
						objRs("EnableCaptcha") = Cint(Request.Form("EnableCaptcha"))

						objRs("sendcontactformsms") = Request.Form("sendcontactformsms")
						objRs("smsfrom") = Request.Form("smsfrom")
						objRs("smsnumber") = Request.Form("smsnumber")

						objRs("Userheader") = Trim(Request.Form("Userheader"))
						objRs("Usertemplate") = Trim(Request.Form("Usertemplate"))
						objRs("Userfooter") = Trim(Request.Form("Userfooter"))
						objRs("Userlogin") = Trim(Request.Form("Userlogin"))
						objRs("Userregister") = Trim(Request.Form("Userregister"))
					
                    	objRs("loginPage") = Trim(Request.Form("loginPage"))
						objRs("AllowSelfRegister") = Cint(Request.Form("AllowSelfRegister"))
                        objRs("AllowSeffRegistredUsers") = Request.Form("AllowSeffRegistredUsers")
                        objRs("Useremailvalidationtype") = Request.Form("Useremailvalidationtype")
                        objRs("Cache") = Request.Form("Cache")
                        objRs("Defaultregistredgroup") = Request.Form("Defaultregistredgroup")

						objRs("EnableNameinSubcribes") = Cint(Request.Form("EnableNameinSubcribes"))
						objRs("EnableAgreeInComments") = Cint(Request.Form("EnableAgreeInComments"))
						objRs("comments9Level") = Cint(Request.Form("comments9Level"))
						objRs("maxinshortdescription") = Cint(Request.Form("maxinshortdescription"))
						objRs("EnableMenuBread") = Cint(Request.Form("EnableMenuBread"))
						objRs("sendmailtomanagerwhenuserregister") = Request.Form("sendmailtomanagerwhenuserregister")

						objRs("defaultnewpagelevel") = Cint(Request.Form("defaultnewpagelevel"))
						objRs("AutoInsertComments") = Cint(Request.Form("AutoInsertComments"))
						objRs("commentsemail") = Request.Form("commentsemail")
						objRs("twitterusername") = Request.Form("twitterusername")
						objRs("twitterpassword") = Request.Form("twitterpassword")
						
                        objRs("ApplicationID") = Request.Form("ApplicationID")
						objRs("APIKey") = Request.Form("APIKey")
						objRs("ApplicationSecret") = Request.Form("ApplicationSecret")
						
                        objRs("Analyticsusername") = Request.Form("Analyticsusername")
						objRs("Analyticspassword") = Request.Form("Analyticspassword")
						objRs("Analyticssiteid") = Request.Form("Analyticssiteid")
						
					
						objRs("EnableDateInRunNews") = Request.Form("EnableDateInRunNews")
						objRs.Update
						CloseDB(objRs)
							Response.Write("<br><br><p align='center'>הגדרות נערכו בהצלחה. <a href='admin_site.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							response.Write("<meta http-equiv='Refresh' content='0; URL=admin_site.asp?S=" & SiteID & "'>")

	        
	            End Select
		Else
				        SQL = "SELECT * FROM Site  WHERE SiteID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			        If Request.QueryString("action") = "add" Then
			            SQL = "SELECT * FROM Site  WHERE SiteID=" & SiteID   
			        End If	
				        Set objRs = OpenDB(SQL)
		            If Request.QueryString("action")<> "add" then
		                Editmode = "True"
		            Else
		                Editmode = "False"
		            End If

 %>
 <div id="incontentform">
<form action="admin_site.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("SiteID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת אתר</h1>
				<% ELSE 
				%>
					<h1>עריכת הגדרות כלליות</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td width="20%" align="right">כותרת</td>
                    <td align="right" valign="top"><input class="goodinputlong" type="text"  name="Title" cols="40"<%If Editmode = "True"  Then%> value="<%= objRs("Title")%>" /></textarea>
                </tr>
                <tr>
                    <td width="20%" align="right">מילות מפתח</td>
                    <td align="right" valign="top"><textarea class="goodinputlongbig" rows="5" name="Keywords" cols="40"><%If Editmode = "True"  Then print objRs("Keywords")%></textarea>
                </tr>
                <tr>
                    <td width="20%" align="right">תאור האתר</td>
                    <td align="right" valign="top"><textarea class="goodinputlongbig" rows="5" name="Description" cols="40"><%If Editmode = "True"  Then print objRs("Description")%></textarea>
                </tr>
                <tr>
                    <td width="20%" align="right">דומין</td>
                    <td align="right" valign="top"><textarea class="goodinputlongbig" rows="2" dir="ltr" name="domains" cols="40"><%If Editmode = "True"  Then print objRs("domains")%></textarea>
                </tr>
                <tr>
				    <td width="20%" align="right">עמוד הבית:</td>
					<td valign="middle" width="72%">
   					<select class="goodselect" name="HomePageID">
						<% Set objRsNews = OpenDB("SELECT id, Name FROM Content WHERE Contenttype = 1 AND SiteID= " & SiteID)						  
					       Do While Not objRsNews.EOF %>											    
							<option value="<% =objRsNews("id")%>"<% If objRs("HomePageID") = objRsNews("id") Then Response.Write(" selected") %> ><% = objRsNews("Name") %></option>
						<%	objRsNews.MoveNext 
								Loop
							objRsNews.Close	%>
					</select>
					</td>
				  </tr>
			      <tr>
				    <td width="20%" align="right">שפת האתר:</td>
					<td valign="middle" width="72%">
					 <%  Set objRslang=OpenDB("SELECT * FROM lang")  %>
					<select class="goodselect" name="Lang">
					<% Do While Not objRslang.EOF %>
						        <option value="<% = objRslang("langID") %>"<% If objRslang("langID") = objRs("langID") Then Response.Write(" selected") %>><% = objRslang("Langvalue") %></option>
                    <%	objRslang.MoveNext 
						    Loop
						objRslang.close	%>
					</select>
					</td>
				  </tr>

				  <% If Int(Session("Level")) = 0 Then %>

				  <% End If %>

				</table>
				</div>
			</div>
<div id="left">
<div id="formcontainer">
<center>
    <div id="formcontent">
        <div id="formleftfields">
		    <div style="width:100%;" id="accordion">
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">הגדרות אימייל טוויטר ו-SMS</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                   <tr>
				    <td valign="middle" align="right">EMail מנהל האתר:</td>
					<td valign="middle"><input dir="ltr" type="text" name="AdminEmail" class="goodinputlong" maxlength="100" value="<% = objRs("AdminEmail") %>"></td>
				  </tr>
                   <tr>
				    <td valign="middle" align="right">נשלח מכתובת:</td>
					<td valign="middle"><input dir="ltr" type="text" name="Sender" class="goodinputlong" maxlength="100" value="<% = objRs("Sender") %>"></td>
				  </tr>
			      <tr>
				    <td valign="middle" align="right">להוסיף קוד אימות CAPTCHA?</td>
					<td valign="middle" align="right">
					  <select class="goodselect" name="EnableCaptcha">
					    <option value="0" <% If objRs("EnableCaptcha") = "0" Then Response.Write(" selected") %>>לא</option>
					    <option value="1" <% If objRs("EnableCaptcha") = "1" Then Response.Write(" selected") %>>כן</option>
					  </select>					  
					</td>
				  </tr>
                        <tr>
                            <td align="right">טלפון לשליחת SMS</td>
                            <td align="right"><input id="smsnumber" type="text" dir="ltr" name="smsnumber" value="<% = objRs("smsnumber") %>" onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>
                        <tr>
                            <td align="right">נשלח ממספר</td>
                            <td align="right"><input id="smsfrom" type="text" dir="ltr" name="smsfrom" value="<% = objRs("smsfrom") %>" onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>

                        <tr>
                            <td align="right">לשלוח בצור קשר</td>
                            <td align="right"><input id="sendcontactformsms"  type="checkbox" dir="ltr" name="sendcontactformsms" value=1 <% If objRs("sendcontactformsms")= "True" Then print " checked" %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" /></td>
                        </tr>
                        <tr>
                            <td align="right">שם משתמש טוויטר</td>
                            <td align="right"><input id="twitterusername" type="text" dir="ltr" name="twitterusername" value="<% = objRs("twitterusername") %>" onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>
                        <tr>
                            <td align="right">סיסמא טוויטר</td>
                            <td align="right"><input id="twitterpassword" type="text" dir="ltr" name="twitterpassword" value="<% = objRs("twitterpassword") %>" onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>
                        <tr>
                            <td align="right">פייסבוק ApplicationID</td>
                            <td align="right"><input id="ApplicationID" type="text" dir="ltr" name="ApplicationID" value="<% = objRs("ApplicationID") %>" onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>
                        <tr>
                            <td align="right">פייסבוק APIKey</td>
                            <td align="right"><input id="APIKey" type="text" dir="ltr" name="APIKey" value="<% = objRs("APIKey") %>" onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>
                        <tr>
                            <td align="right">פייסבוק ApplicationSecret</td>
                            <td align="right"><input id="ApplicationSecret" type="text" dir="ltr" name="ApplicationSecret" value="<% = objRs("ApplicationSecret") %>" onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>
                    </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">הגדרות מתקדמות</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table1">
				  <tr>
				    <td>תאריך בחדשות רצות?</td>
					<td >
					  <select class="goodselect" style="width:60px;" name="EnableDateInRunNews">
					    <option value="0" <% If objRs("EnableDateInRunNews") = "0" Then Response.Write(" selected") %>>לא</option>
					    <option value="1" <% If objRs("EnableDateInRunNews") = "1" Then Response.Write(" selected") %>>כן</option>
					  </select>				  
					</td>
				  </tr>
				  <tr>
				    <td>מפת התמצאות לפי תפריט?</td>
					<td>
					  <select class="goodselect" style="width:60px;" name="EnableMenuBread" size="1">
					    <option value="0" <% If objRs("EnableMenuBread") = "0" Then Response.Write(" selected") %>>לא</option>
					    <option value="1" <% If objRs("EnableMenuBread") = "1" Then Response.Write(" selected") %>>כן</option>
					  </select>				  
					</td>
				  </tr>
				  <tr>
				    <td>מקסימום תווים בתאור קצר:</td>
					<td>
					  <input class="goodinputshort" style="width:40px;" dir="ltr" type="text" name="maxinshortdescription" size="6" maxlength="6" value="<% = objRs("maxinshortdescription") %>">
					</td>
				  </tr>
                  <tr>
                            <td align="right">להפעיל Cache<a href="admin_site.asp?ID=<%= Request.querystring("ID")%>&deletecache=True"><small><font color = "black">מחק Cache</font></small></a></td>
                            <td align="right"><input id="Cache" type="checkbox" dir="ltr" name="Cache" value="1" <% If objRs("Cache")= "True" Then print " checked" %> style="float:right;"  /></td>
                   </tr>

                    </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">סטטיסטיקה</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table4">
				  <tr>
				    <td>Analytics שם משתמש</td>
                    <td align="right"><input id="Analyticsusername" type="text" dir="ltr" name="Analyticsusername" value="<% = objRs("Analyticsusername") %>" class="goodinputlong" /></td>
				  </tr>
				  <tr>
				    <td>Analytics סיסמא</td>
                    <td align="right"><input id="Analyticspassword" type="text" dir="ltr" name="Analyticspassword" value="<% = objRs("Analyticspassword") %>" class="goodinputlong" /></td>
				  </tr>
				  <tr>
				    <td>Analytics קוד אתר</td>
                    <td align="right"><input id="Analyticssiteid" type="text" dir="ltr" name="Analyticssiteid" value="<% = objRs("Analyticssiteid") %>" class="goodinputlong" /></td>
				  </tr>
                    </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">הגדרת מערכת תגובות</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table2">
                                        				   <tr>
			        <td>רמת הרשאה להוספת תגובות:</td>
			        <td>				  					  
					<select class="goodselect" style="width:60px;" name="comments9Level" ID="comments9Level" size="1">
						<%
							x=1	
				 			Do Until x > 9
				 		 %>
							<option value=<% = x %><% If objRs("comments9Level") = x Then Response.Write(" selected") %>>	<% = x %></option>
							<% x=x+1
							Loop
							%>
					</select></td>
			    	</tr>
				  <tr>
				    <td>כתובת למשלוח על הוספת תגובה:</td>
					<td>
					  <input dir="ltr" type="text" name="commentsemail" class="goodinputlong" maxlength="30" value="<% = objRs("commentsemail") %>">
					</td>
				  </tr>
				  <tr>
			        <td>להציג תגובה ללא אישור?:
			        <td>				  					  
					  <select class="goodselect" style="width:60px;" name="AutoInsertComments">
					    <option value="0" <% If objRs("AutoInsertComments") = "0" Then Response.Write(" selected") %>>לא</option>
					    <option value="1" <% If objRs("AutoInsertComments") = "1" Then Response.Write(" selected") %>>כן</option>
					  </select>				  
					</td>
			    	</tr>
				  <tr>
				    <td>להוסיף "אני מסכים" בהוספה?</td>
					<td>
					  <select class="goodselect" style="width:60px;" name="EnableAgreeInComments">
					    <option value="0" <% If objRs("EnableAgreeInComments") = 0 Then Response.Write(" selected") %>>לא</option>
					    <option value="1" <% If objRs("EnableAgreeInComments") = 1 Then Response.Write(" selected") %>>כן</option>
					  </select>				  
					</td>
				  </tr>
                    </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">הגדרות אבטחה</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table3">
                   <tr>
				    <td>רמת הרשאה שמקבל דף חדש</td>
					<td>
					<select class="goodselect" style="width: 60px;" name="defaultnewpagelevel" ID="Select1" size="1">
						<%
							z=1	
				 			Do Until z > 9
				 		 %>
							<option value=<% = z %><% If objRs("defaultnewpagelevel") = z Then Response.Write(" selected") %>>	<% = z %></option>
							<% z=z+1
							Loop
							%>
					</select>					</td>
				  </tr>
                   <tr>
				    <td>דף התחברות</td>
					<td>
					  <input dir="ltr" type="text" name="loginPage" class="goodinputlong" maxlength="30" value="<% = objRs("loginPage") %>">
					</td>
				  </tr>
                   <tr>
                            <td align="right">לאפשר הרשמה לאתר</td>
                            <td align="right"><input id="AllowSeffRegistredUsers" type="checkbox" dir="ltr" name="AllowSeffRegistredUsers" value="1" <% If objRs("AllowSeffRegistredUsers")= "True" Then print " checked" %> style="float:right;"  /></td>
                   </tr>
                                     <tr>
			        <td>האם לדרוש אימות של הדואל?</small></td>
			        <td>				  					  
					<select class="goodselect" name="Useremailvalidationtype" ID="Useremailvalidationtype" size="1">
							<option value="0" <% If  objRs("Useremailvalidationtype") = "0"  Then Response.Write(" selected") %>>ללא</option>
							<option value="Email"  <% If  objRs("Useremailvalidationtype") = "Email"  Then Response.Write(" selected") %>>Email</option>
							<option value="Sms" <% If  objRs("Useremailvalidationtype") = "Sms"  Then Response.Write(" selected") %>>Sms</option>
					</select>
                    </td>
			    	</tr>
                   <tr>
                            <td align="right">לשלוח מייל למנהל האתר כאשר משתמש נרשם</td>
							<td align="right"><input dir="ltr" type="text" name="sendmailtomanagerwhenuserregister" class="goodinputlong" maxlength="30" value="<% = objRs("sendmailtomanagerwhenuserregister") %>"/></td>
                   </tr>

                  <tr>
			        <td>רמת הרשאה שמקבל<br />משתמש שנרשם:<small>(9 פתוח לכולם)</small></td>
			        <td>				  					  
					<select class="goodselect" style="width: 60px;" name="AllowSelfRegister" ID="AllowSelfRegister" size="1">
						<%
							x=1	
				 			Do Until x > 9
				 		 %>
							<option value=<% = x %><% If objRs("AllowSelfRegister") = x Then Response.Write(" selected") %>>	<% = x %></option>
							<% x=x+1
							Loop
							%>
					</select></td>
			    	</tr>
                  <tr>
			        <td>קבוצת ברירת מחדל בהרשמה לאתר</small></td>
			        <td>				  					  
					<select class="goodselect" name="Defaultregistredgroup" ID="Select2" size="1">
						<%
							Set objRsgroup = OpenDB("select * from UsersCategory Where SiteID =" & SiteID)	
                            if objRsgroup.recordcount > 0 then
                            Edit = "True"
                            End if
                        %>
							<option value="0" <%If Edit = "True" Then %> <% If  objRsgroup("Id") = 0  Then Response.Write(" selected") %><% End If %>>משתמשי פייסבוק</option>
							<option value="1" <%If Edit = "True" Then %> <% If  objRsgroup("Id") = 1  Then Response.Write(" selected") %><% End If %>>משתמשי האתר</option>
                        <% Do Until objRsgroup.EOF %>
							<option value="<%= objRsgroup("Id") %>" <%If Edit = "True" Then %><% If  objRsgroup("Id") =  objRs("Defaultregistredgroup") Then Response.Write(" selected") %><% End If %>>	<% = objRsgroup("Name") %></option>
							<%
                            objRsgroup.Movenext
							Loop
                            CloseDB(objRsgroup)
							%>
					</select></td>
			    	</tr>
                    <tr>
                            <td align="right"> תבנית חלק עליון<img src="images/ask22.png" id="east9" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input class="goodinputshort" dir="ltr" class="" id="Userheader" name="Userheader" <%If Editmode = "True" Then %> value="<% =objRs("Userheader")%>"<%End If %> type="text" />
							<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('Userheader');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תבנית<img src="images/ask22.png" id="Img1" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="Usertemplate" name="Usertemplate" <%If Editmode = "True" Then %> value="<% =objRs("Usertemplate")%>"<%End If %> type="text"  />
							<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('Usertemplate');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תבנית חלק תחתון<img src="images/ask22.png" id="Img2" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="Userfooter" name="Userfooter" <%If Editmode = "True" Then %> value="<% =objRs("Userfooter")%>"<%End If %> type="text"  />
							<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('Userfooter');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תבנית טופס התחברות<img src="images/ask22.png" id="Img3" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="Userlogin" name="Userlogin" <%If Editmode = "True" Then %> value="<% =objRs("Userlogin")%>"<%End If %> type="text"  />
							<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('Userlogin');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תבנית טופס הרשמה<img src="images/ask22.png" id="Img4" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="Userregister" name="Userregister" <%If Editmode = "True" Then %> value="<% =objRs("Userregister")%>"<%End If %> type="text"  />
							<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('Userregister');"/>
							</td>
                        </tr>

                    </table>
                 </div>
            </div>
            <div id="formsubmit">
            <input type="submit" style="margin:10px 0 0;" value="שמור" class="saveform"  />
            </div>
        </div>
        <div id="clearboth"></div>
    </div>
</center>
</div>
</div>
</div>
</form>


<%	
End if
End if
End if
%>

<!--#include file="footer.asp"-->