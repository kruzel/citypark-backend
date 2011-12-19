 <!--#include file="../config.asp"-->
<!--#include file="header.asp"-->

<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
    });
</script>
<script type="text/javascript">

    $(document).ready(function () {
        $("#contentTable").treeTable();
    });
  
</script>
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });
    });

</script>
<script type="text/javascript">
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

<script type='text/javascript'>
    $(function () {
        $('#east').tipsy({ html: true });
        $('#east2').tipsy({ html: true });
        $('#east3').tipsy({ html: true });
    });
</script>
<% 
Function GetEmailTemplate(emailTemplate)
	GetEmailTemplate = GetPostTemplate(emailTemplate)
End Function

Sub SendMailForm(subject, from, recipient, emailTemplate)

	Set myMail=CreateObject("CDO.Message")
			myMail.Subject = subject
			myMail.From = from
			myMail.To=recipient
			'myMail.Bcc=""
			myMail.BodyPart.Charset = "utf-8"

			myMail.HTMLBody = GetEmailTemplate(GetURL(emailTemplate))
			
			myMail.Configuration.Fields.Item("urn:schemas:mailheader:x-content-type") = "text/html; charset=utf-8"
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")= 2
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtp
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
			myMail.Configuration.Fields.Update
			myMail.Send
			set myMail=nothing

End Sub

sendmode = false


If Request.QueryString("type") = "sendsms" Then
sendmode=True
CheckSecuirty "Users"

  
    Dim str
    
	For Each x In Request.Form
	    If Mid(x, 1, 5) = "Send_" Then	
		    If Request.Form(x) = "on" Then	
                str = str & ";" & Request("OSelular_" & Mid(x, 6))
		    End If
		End If
	Next
	
	str = Mid(str, 2)
    If GetConfig("smscredit") > UBound(Split(str, ";")) Then
	    SendSMS str, Request.Form("message"),Request.Form("sender")
	    Response.Write(" הודעה נשלחה אל" & str & "בהצלחה<br> ")	
    Else
        print "אין מספיק קרדיט לשלוח הודעות"
    End If
     Response.end
End If


If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then

	If Request.QueryString("records") = "" Then
	Session("records") = 50
	Else 
	Session("records") = Request.QueryString("records")
	End If

CheckSecuirty "Users"
 format = Request.QueryString("format")
    If  format  = "xls" Then
    Response.Clear
    Response.CodePage = "1255" 
    Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=users.csv"
		SQL = "SELECT * FROM Users WHERE SiteID=" & SiteID & " ORDER BY Name ASC"
	Set objRs = OpenDB(SQL)
	    Do While Not objRs.EOF
            for each f in objRs.Fields
                print(f.Value & ",")
            next
                print  vbCrLf
     objRs.MoveNext
		Loop
    CloseDB(objRs)
    response.end
     End If
         If  format  = "doc" Then
    Response.Clear
    Response.CodePage = "1255" 
    Response.ContentType = "text/csv"
        Response.AddHeader "Content-Disposition", "attachment;filename=content-"&filedate&".doc"
        Response.ContentType = "application/vnd.ms-word"
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
		SQL = "SELECT * FROM Users WHERE SiteID=" & SiteID & " ORDER BY Name ASC"
	Set objRs = OpenDB(SQL)
    print "<html><body><table><tr>"
	    Do While Not objRs.EOF
            for each f in objRs.Fields
                print("<td>" & f.Value & "</td>")
            next
                print  "</tr><tr>"

     objRs.MoveNext
		Loop
        print "</tr></table></body></html>"
    CloseDB(objRs)
    response.end

     End If

 %>   
 <!--#include file="right.asp"-->
	<div id="incontent">
	<div class="incontentboxgrid">
<center>

 

    <div class="formtitle">
        <h1>ניהול משתמשים</h1>
		<div class="admintoolber">
        <form action="admin_users.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %><&string=<%=Request.form("search") %>&type=<%=Request.Querystring("type") %>" method="post">
               <p>חיפוש:</p>
					<% Set objRsCategory = OpenDB("SELECT * FROM Userscategory Where SiteID = " & SiteID)
                    %>					  
				        <select id="category" name="category">
						    <option value="0">כולם</option>
                	<% Do While Not objRsCategory.EOF %>
						    <option value="<% = objRsCategory("Id") %>" <% If int(objRsCategory("Id")) = int(Request.Form("category")) Then Response.Write(" selected") %>><% = objRsCategory("Name") %></option>
					<% objRsCategory.MoveNext 
					        Loop%>
					    </select>
					<% 
                    CloseDB(objRsCategory)
					%>
        <p>פרטי:</p>
               <input type="text" dir="rtl" name="name" style="width:80px;float:right;margin-top:9px;height:17px;margin-right:10px;font-family:arial;">
  
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_users.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_users.asp?format=xls"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_users.asp?format=doc"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_users.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>&category=<%=Request.querystring("category") %>&string=<%=Request.querystring("search") %>&type=<%=Request.querystring("type") %>';">
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
<% 
if request.querystring("type") = "preparesms" then
sendmode=True
CheckSecuirty "Users"
 %>
<form action="admin_users.asp?type=sendsms" method="post" >
<div class="rightform">
	<table style="padding:0 20px;width:100%;">
	    <tr>
	       <th align="right" width="10%">מספר השולח</th>
	       <td align="right" width="90%"><input class="goodinputshort" type="text" name="sender"></td>
	    </tr>
        <tr>
			<td align="right" width="100%" align="center" valign="top" colspan="2">
			<textarea rows="3" name="message" cols="10" class="goodinputlongbig" onKeyDown="formTextCounter(this.form.message,this.form.remLen_message,69);" onKeyUp="formTextCounter(this,$('remLen_message'),69);" wrap="soft"><%If Editmode = "True" Then print objRs("message") End If %></textarea><br>
            <div style="float:right;width:100%;"><input readonly="readonly" type="text" name="remLen_message" size="5" value="69" maxlength="3" class="goodinputlong" style="width: 25px;float:right;"></div>
            <input type="submit" class="saveform" style="float:right;margin:10px 0 0 0;" value="שלח">
			</td>
        </tr>
      </table>
	 </div>
</form>
<%
End if
if request.querystring("type") = "preparemail" then
CheckSecuirty "Users"
sendmode = True 
 %>
<form action="ajax_mailer.asp?type=sendmail" method="post" >
<div class="rightform">
	<table style="padding:0 20px;">
	    <tr>
	       <th align="right" width="10%">השולח</th>
	       <td width="40%"><input class="goodinputlong" type=text name="Sender" value="<% = LCase(Request.ServerVariables("HTTP_HOST")) %>"></td>
	        <th align="right" width="10%">כותרת</th>
	        <td width="40%"><input type="text" class="goodinputlong" name="Subject">
   	        </td>
	    </tr>
	   <tr>
            <th align="right" width="10%">תבנית</th>
            <td width="40%" align="right">
				<input class="goodinputshort" id="Template" name="Template" type="text" size="60" />
				<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseLayout('Template');"/>
			</td>
	        <th align="right" width="10%">קובץ מצורף</th>
			<td width="40%">
                <input class="goodinputshort" id="Attachment" name="Attachment" type="text" size="60" />
				<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseFile('Attachment');"/>
			</td>
	    </tr>
        
        <tr>
			<td align="center" valign="top" align="left" colspan="4">
			 <% 
                Dim oFCKeditor
                Set oFCKeditor = New FCKeditor
                oFCKeditor.BasePath = "FCKeditor/"
                oFCKeditor.width="100%"
                oFCKeditor.height="300px"
                oFCKeditor.Create "message"
             %>
            </td>
           </tr>
           <tr>
             <td>
                <input type="submit" class="saveform" value="שלח">
            </td>
           </tr>
      </table>
	  </div>
<% 
end if %>
	
	
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
	<% if sendmode=True then %>
    <tr style="background:#eee;">
        <td align="left" style="padding:0 0 0 20px;" colspan="8"><a href="javascript:SelectEverything();">סמן הכל</a> | <a href="javascript:SelectNothing();">נקה הכל</a>
        </td>
    </tr>
	<% end if %>
    <tr>
        <th>ID</th>
		<th style="width:20%;padding:0 32px 0 0;text-align:right;">שם משפחה</th>
		<th style="width:20%;padding:0 32px 0 0;text-align:right;">שם פרטי</th>
		<th style="width:20%;padding:0 32px 0 0;text-align:right;">Email</th>
		<th style="width:10%;padding:0 32px 0 0;text-align:right;">רמת הרשאה</th>
        <% if sendmode=False then %>
		<th style="width:10%;padding:0 32px 0 0;text-align:right;">ערוך</th>
        <th style="width:10%;padding:0 32px 0 0;text-align:right;">שכפל</th>
        <th style="width:10%;padding:0 32px 0 0;text-align:right;">מחק</th>
		<% end if %>
        <% if sendmode=True then %>
        <th style="width:10%;padding:0 32px 0 0;text-align:right;">דיוור</th>
        <% end if %>
    </tr>
</thead>
<tbody>

<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then 
                SQL = "SELECT DISTINCT Users.*,  Users.SiteID FROM Users INNER JOIN UsersPerCategory ON Users.Id = UsersPerCategory.UsersID  AND Users.SiteID = UsersPerCategory.SiteID WHERE "
            SQL = SQL & " Users.SiteID = " & SiteID 

             if request.querystring("type") = "preparemail" then
                SQL = SQL & " AND Mailinglist = 1"
                SQL = SQL & " AND Confirmed = 1"
             End If
             if request.querystring("type") = "preparesms" then
                SQL = SQL & " AND SendSms = 1"
             End If
            SQL = SQL & " ORDER BY Users.Id DESC"



     If Request.QueryString("mode") = "search" then
       
      	If Request.QueryString("mode") = "search" then
                SQL = "SELECT DISTINCT Users.*,  Users.SiteID FROM Users INNER JOIN UsersPerCategory ON Users.Id = UsersPerCategory.UsersID  AND Users.SiteID = UsersPerCategory.SiteID WHERE "
            
			If Request.Form("category") <> 0 then
    	        SQL = SQL & "UsersPerCategory.UsersCategoryID = " & Request.Form("category") & " AND"
            End If
            
            SQL = SQL & " Users.SiteID = " & SiteID 

            If Request.Form("Name") <> "" Then
                SQL = SQL & " AND Users.Name LIKE '%" & Request.Form("Name") & "%'"
            End If
             If Request.Form("family") <> "" Then
                SQL = SQL & " AND Users.familyname LIKE '%" & Request.Form("family") & "%'"
            End If
             If Request.Form("cell") <> "" Then
                SQL = SQL & " AND Users.cellular LIKE '%" & Request.Form("cell") & "%'"
            End If
             if request.querystring("type") = "preparemail" then
                SQL = SQL & " AND Mailinglist = 1"
             End If
             if request.querystring("type") = "preparesms" then
                SQL = SQL & " AND SendSms = 1"
             End If
            SQL = SQL & " ORDER BY Users.Id DESC"
          '  print SQL
          End If
    End If
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	        objRsg.PageSize = Session("records")
                HowMany = 1
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize
            	%>
    <tr>
          
        
        
        <td><%= HowMany  %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><% = objRsg("Familyname") %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><% = objRsg("Name") %></td>
        <td dir="ltr" class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><%= objRsg("Email") %></td>
        <td dir="ltr" class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><%= objRsg("Users9Level") %></td>
		<% if sendmode=False then %>
        <td><a href="admin_users.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_users.asp?ID=<% = objRsg("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td style="border-left:0px;"><a href="admin_users.asp?ID=<% = objRsg("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
        <% end if %>
		<% if sendmode=True then %>
        <td style="border-bottom:1px solid #eee;line-height:25px;" align="center"><input type="checkbox" name="Send_<% = objRsg(0) %>" checked="checked" /></td>
        <% end if %>
    </tr>	
 <%		
                 HowMany = HowMany + 1
                objRsg.MoveNext
		  		Loop
                objRsg.Close
                End If
    End If
'	%>
</tbody>
</table></div>
<%	 
Else
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	        Case "add"
	        Editmode= "False"
			      Set objRsUrl = OpenDB("SELECT * FROM Users WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM Users"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Usersname") = Trim(Request.Form("Usersname"))
								objRs("Password") = md5(Request.Form("Password"))
								objRs("Name") = Trim(Request.Form("Name"))	
								objRs("FamilyName") = Request.Form("FamilyName")
								objRs("Address") = Trim(Request.Form("Address"))
								objRs("Address2") = Request.Form("Address2")	
								objRs("City") = Request.Form("City")	
								objRs("Country") = Trim(Request.Form("Country"))	
								objRs("Zipcode") = Trim(Request.Form("Zipcode"))
								objRs("Phone") = Trim(Request.Form("Phone"))
								objRs("cellular") = Trim(Request.Form("cellular"))
								objRs("mekutzar") = Trim(Request.Form("mekutzar"))
								objRs("Email") = Trim(Request.Form("Email"))
								objRs("Confirmed") = Request.Form("Confirmed")
								objRs("image") = Trim(Request.Form("image"))
								objRs("birthday") = Trim(Request.Form("birthday"))
								objRs("MailingList") = Request.Form("MailingList")
								objRs("SendSms") = Request.Form("SendSms")
								objRs("other1") = Request.Form("other1")
								objRs("other2") = Request.Form("other2")
								objRs("other3") = Request.Form("other3")
								objRs("other4") = Request.Form("other4")
								objRs("other5") = Request.Form("other5")
								objRs("other6") = Request.Form("other6")

								
								objRs("Users9Level") =int(Request.Form("Users9Level"))
								objRs.Update
								CloseDB(objRs)
                                
                                Set objRs = OpenDB("Select TOP 1 Id From Users Order By Id Desc")
								UsersID = objRs("Id")
								CloseDb(objRs)
								
								For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
										ExecuteRS("INSERT INTO [UsersPerCategory] (UsersID, UsersCategoryID, SiteID) VALUES (" & UsersId & ", " & Request.Form(x) & ", " & SiteID & ");")
									End If
								Next
                                    Response.Redirect("admin_users.asp?notificate=משתמש נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

	            If Request.Querystring("ID") = "" Then
				    Sql = "SELECT * FROM Users WHERE urltext=" & Replace(Request.QueryString("p"),"-"," ")
			    Else
				    Sql = "SELECT * FROM Users WHERE Id=" & Request.QueryString("ID")
			    End If
			            Set objRs = OpenDB(sql)
				                objRs("Usersname") = Trim(Request.Form("Usersname"))
								objRs("Name") = Trim(Request.Form("Name"))	
								objRs("FamilyName") = Request.Form("FamilyName")
								objRs("Address") = Trim(Request.Form("Address"))
								objRs("Address2") = Request.Form("Address2")	
								objRs("City") = Request.Form("City")	
								objRs("Country") = Trim(Request.Form("Country"))	
								objRs("Zipcode") = Trim(Request.Form("Zipcode"))
								objRs("Phone") = Trim(Request.Form("Phone"))
								objRs("cellular") = Trim(Request.Form("cellular"))
								objRs("mekutzar") = Trim(Request.Form("mekutzar"))
								objRs("Email") = Trim(Request.Form("Email"))
								objRs("Confirmed") = Request.Form("Confirmed")
								objRs("image") = Trim(Request.Form("image"))
								objRs("birthday") = Trim(Request.Form("birthday"))
								objRs("MailingList") = Request.Form("MailingList")
								objRs("SendSms") = Request.Form("SendSms")
								objRs("other1") = Request.Form("other1")
								objRs("other2") = Request.Form("other2")
								objRs("other3") = Request.Form("other3")
								objRs("other4") = Request.Form("other4")
								objRs("other5") = Request.Form("other5")
								objRs("other6") = Request.Form("other6")

								
								objRs("Users9Level") =int(Request.Form("Users9Level"))
								If Request.form("sendmailtocustomer") = "on" then
	SendMailForm "אושרה כניסתך למערכת","no_replay@webserver.com",objRs("Email"),Templatelocation & "customercomfirmation.html"
								'response.end
								End If

								objRs.Update
								objRs.Close
                                
                              ExecuteRS("DELETE FROM [UsersPerCategory] WHERE UsersID = " & Request.QueryString("ID"))
								
								For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
										ExecuteRS("INSERT INTO [UsersPerCategory] (UsersID, UsersCategoryID, SiteID) VALUES (" & Request.QueryString("ID") & ", " & Request.Form(x) & ", " & SiteID & ");")
									End If
								Next
                                    Response.Redirect("admin_users.asp?notificate=משתמש עודכן בהצלחה")

	        Case "copy"
	        	Editmode = "True"


	            If Request.Querystring("ID") = "" Then
				    Sql = "SELECT * FROM Users WHERE urltext=" & Replace(Request.QueryString("p"),"-"," ")
			    Else
				    Sql = "SELECT * FROM Users WHERE Id=" & Request.QueryString("ID")
			    End If
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Usersname") = Trim(Request.Form("Usersname"))
								objRs("Name") = Trim(Request.Form("Name"))	
								objRs("FamilyName") = Request.Form("FamilyName")
								objRs("Address") = Trim(Request.Form("Address"))
								objRs("Address2") = Request.Form("Address2")	
								objRs("City") = Request.Form("City")	
								objRs("Country") = Trim(Request.Form("Country"))	
								objRs("Zipcode") = Trim(Request.Form("Zipcode"))
								objRs("Phone") = Trim(Request.Form("Phone"))
								objRs("cellular") = Trim(Request.Form("cellular"))
								objRs("mekutzar") = Trim(Request.Form("mekutzar"))
								objRs("Email") = Trim(Request.Form("Email"))
								objRs("Confirmed") = Request.Form("Confirmed")
								objRs("image") = Trim(Request.Form("image"))
								objRs("birthday") = Trim(Request.Form("birthday"))
								objRs("MailingList") = Request.Form("MailingList")
								objRs("SendSms") = Request.Form("SendSms")
								objRs("other1") = Request.Form("other1")
								objRs("other2") = Request.Form("other2")
								objRs("other3") = Request.Form("other3")
								objRs("other4") = Request.Form("other4")
								objRs("other5") = Request.Form("other5")
								objRs("other6") = Request.Form("other6")

								
								objRs("Users9Level") =int(Request.Form("Users9Level"))
								objRs.Update
								objRs.Close
                                
                                For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
										ExecuteRS("INSERT INTO [UsersPerCategory] (UsersID, UsersCategoryID, SiteID) VALUES (" & Request.QueryString("ID") & ", " & Request.Form(x) & ", " & SiteID & ");")
									End If
								Next

                                    Response.Redirect("admin_users.asp?notificate=משתמש נוסף בהצלחה")

	        
	        Case "delete"
				    Sql = "SELECT * FROM Users WHERE Id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
                        Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
                        ExecuteRS("DELETE FROM [UsersPerCategory] WHERE UsersID = " & Request.QueryString("ID"))

                                    Response.Redirect("admin_users.asp?notificate=משתמש נמחק בהצלחה")
	            End Select
		Else



			If Request.QueryString("action") ="edit" Then
				SQL = "SELECT * FROM Users WHERE Id=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			Elseif Request.QueryString("action") = "add" Then
			    SQL = "SELECT * FROM Users WHERE SiteID=" & SiteID   
			End If	
				Set objRs = OpenDB(SQL)
					If Session("Level") > 3 Then 
						Response.Write("<br><br><p align='center'>אין לך הרשאה לבצע פעולה זאת <a href='user_home.asp'>נסה שנית</a>!</p>")
				
		Else
		
		If Request.QueryString("action")<> "add" then
		    Editmode = "True"
		Else
		    Editmode = "False"
		End If

 %>
 <div id="incontentform">
<form action="admin_users.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת משתמש</h1>
				<% ELSE 
				%>
					<h1>עריכת משתמש</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם</p><img src="images/ask22.png" id="east" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required""><%If Editmode = "True" Then print objRs("Name") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>שם משפחה</p><img src="images/ask22.png" id="Img1" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Familyname" cols="3" class="goodinputlong required"><%If Editmode = "True" Then print objRs("Familyname") End If %></textarea>
					  </div>
					  </td>
					</tr>
						 <tr>
					  <td align="right" valign="top"><div style="float:right;height:auto;padding:4px 0 0;width:100%;"><p>קבוצה:</p><img src="images/ask22.png" id="east3" original-title="ניתן לבחור יותר מקטגוריה אחת לדף" /></div></td>
					  <td align="right">
                      <div id="selectCategories"></div>
                            <script type="text/javascript">
						
							 addCategory =  function(id, selected, del) {
								jQuery(function($) {
									var selectBoxContainer = $("<div />")
										.attr("id", "selectBoxContainer_" + id)
										.appendTo($("#selectCategories"));
										
									var selectBox = $("<select class='goodselect' />")
										.attr("name", "category_" + id)
										.appendTo(selectBoxContainer);
									
									<% 
									Set objRsCategory = OpenDB("SELECT * FROM Userscategory Where SiteID= " & SiteID & "  ORDER BY id ASC")			
									%>
									var op1 = $('<option />')
										.val('<% = 0 %>')
										.text('משתמשי פייסבוק');
									var op2 = $('<option />')
										.val('<% = 1 %>')
										.text('משתמשים באתר');
										
									
									<%	
									Do Until objRsCategory.Eof
                                    %>	
									if (0 == selected)
										op1.attr("selected", "selected");
																
									var op = $('<option />')
										.val('<% = objRsCategory(0) %>')
										.text('<% = Replace(objRsCategory("Name"), "'", "\'") %>');
										
									if (<% = objRsCategory(0) %> == selected)
										op.attr("selected", "selected");
										
                                    op1.appendTo(selectBox);
                                    op2.appendTo(selectBox);
									op.appendTo(selectBox);

									<%
										objRsCategory.MoveNext
									Loop
								
									CloseDb(objRsCategory)
									%>
									

									if(del)
										$("<button type=\"button\"></button>")	
											.text("")
											.attr("class", "buttondelete")
											.click(function() { 
												selectBoxContainer.remove();
											})						
											.appendTo(selectBoxContainer);								
									else {
										$("<button type=\"button\"></button>")	
											.text("")
										    .attr("class", "buttonadd3")
											.click(function() { 
												addCategory(id + 1);
												
												$(this)
													.text("")
													.attr("class", "buttondelete")
													.unbind("click")
													.click(function() {
														selectBoxContainer.remove();
												});
											})
											.appendTo(selectBoxContainer);
                                     }
								});
							};
							
							jQuery(document).ready(function() {
								<%
								If EditMode Then
									Set objRsPerCategory = OpenDb("Select * From UsersPerCategory Where UsersID = " & objRs(0))
									x = 0
									Do Until objRsPerCategory.Eof
										Print "addCategory(" & x & ", " & objRsPerCategory("UsersCategoryID") & ", " & LCase(NOT x + 1 = objRsPerCategory.RecordCount) & ");"
										
										x = x + 1
										objRsPerCategory.MoveNext
									Loop
									
									CloseDB(objRsPerCategory)
								Else
								%>
									addCategory(0, -1);
								<%
								End If
								%>
							});
						</script>
						
					</td>
					</tr>
                    <tr>
						<td width="20%" align="right"><p>שם משתמש</p><img src="images/ask22.png" id="Img2" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right"><div style="position:relative;"><input class="goodinputshort" name="Usersname"<%If Editmode = "True" Then print "value=" & objRs("Usersname") End If %> />
					  </div>
					  </td>
					</tr>
                    <%If Editmode = "False" Then %>
                    <tr>
						<td width="20%" align="right"><p>סיסמא</p><img src="images/ask22.png" id="Img3" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right"><div style="position:relative;"><input class="goodinputshort" name="password">
					  </div>
					  </td>
					</tr>
                    <% End if %>
                    <tr>
						<td width="20%" align="right"><p>Email</p><img src="images/ask22.png" id="Img4" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right"><div style="position:relative;"><input class="goodinputshort" name="Email"<%If Editmode = "True" Then print "value=" & objRs("Email") End If %> />
                        האימייל מאושר <input disabled id="Confirmed"  type="checkbox" dir="ltr" name="Confirmed" value="1" <%If Editmode = "True" Then %><% If objRs("Confirmed")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  style="float:right;" />	
                        </td>
					</tr>
                    <tr>
					 <td align="right"><p>מעוניין לקבל דאר:</p></td>
					 <td align="right"><input id="Active"  type="checkbox" dir="ltr" name="MailingList" value="1" <%If Editmode = "True" Then %><% If objRs("MailingList")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					</td>
				   </tr>
					<tr>
					 <td align="right"><p>מעוניין לקבל SMS:</p></td>
					 <td align="right"><input id="Checkbox1"  type="checkbox" dir="ltr" name="Sendsms" value="1" <%If Editmode = "True" Then %><% If objRs("Sendsms")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					</td>
				   </tr>

					<tr>
						<td align="left" colspan="2"><input type="submit" value="שמור" class="saveform"  /></td>
					</tr>
				</table>
				</div>
			</div>
<div id="left">
<div id="formcontainer">
<center>
    <div id="formcontent">
        <div id="formleftfields">
		    <div style="width:100%;" id="accordion">
				<h3><a style="background:url(images/link_img.png) no-repeat right;" href="#">מספרי טלפון</a></h3>
			        <div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">טלפון</td>
						</tr>
                        <tr>
							<td align="right"><input id="Text1" class="goodinputlong" type="text" name="Phone"  <%If Editmode = "True" Then %> value="<% =objRs("Phone")%>"   <% End if %> />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">סלולארי</td>
						</tr>
                        <tr>
							<td align="right"><input id="Text2" class="goodinputlong" type="text" name="cellular"  <%If Editmode = "True" Then %> value="<% =objRs("cellular")%>"   <% End if %> />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">מקוצר</td>
						</tr>
                        <tr>
							<td align="right"><input id="Text4" class="goodinputlong" type="text" name="mekutzar"  <%If Editmode = "True" Then %> value="<% =objRs("mekutzar")%>"   <% End if %> />
                            </td>
                        </tr>
                    </table>
			</div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">כתובת</a></h3>
			        <div>
                    <table dir="rtl" class="leftstuff" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">כתובת</td>
                        </tr>
                        <tr>
                            <td align="right"><input class="goodinputlong" id="Address" type="text" name="Address" <%If Editmode = "True" Then %> value="<% = objRs("Address") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                        <tr>
                            <td align="right">כתובת נוספת</td>
                        </tr>
                        <tr>
                            <td align="right"><input class="goodinputlong" id="Address2" type="text" name="Address2"<%If Editmode = "True" Then %> value="<% = objRs("Address2") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                        <tr>
                            <td align="right">עיר</td>
                        </tr>
                        <tr>
                            <td align="right"><input class="goodinputlong" id="City" type="text" name="City"<%If Editmode = "True" Then %> value="<% = objRs("City") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                        <tr>
                            <td align="right">מדינה</td>
                        </tr>
                        <tr>
                            <td align="right"><input class="goodinputlong" id="Country" type="text" name="Country"<%If Editmode = "True" Then %> value="<% = objRs("Country") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                        <tr>
                            <td align="right">מיקוד</td>
                        </tr>
                        <tr>
                            <td align="right"><input class="goodinputlong" id="Zipcode" type="text" name="Zipcode"<%If Editmode = "True" Then %> value="<% = objRs("Zipcode") %>"<%End If %> style="width:80%;"/></td>
                        </tr>

                    </table>
			</div>
            <h3><a style="background:url(images/template.png) no-repeat right;" href="#">תמונה ותאריך לידה</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table2">
                        <tr>
                            <td align="right">תמונה</td>
                        </tr>
                        <tr>
                            <td align="right">
							<input class="goodinputshort" id="xFilePath" name="image" <%If Editmode = "True" Then %> value="<% =objRs("image")%>"<%End If %> type="text" size="60" />
							<input class="goodinputbrows" type="button" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תאריך לידה</td>
                        </tr>
                        <tr>
                            <td align="right">
					  <input type="text" dir="ltr" name="birthday" style="width:100px;" class="_date goodinputlong" <%If Editmode = "True" Then %> value="<% = objRs("birthday") %>" <% End if %> size="10" maxlength="100" style="margin-left: 183px"></td>			 

							</td>
                        </tr>

                    </table>
			</div>

			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">הגדרות אבטחה</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">רמת הרשאה</td>
                        </tr>
                        <tr>
                            <td align="right">
							<select class="goodselect" style="width: 60px;" name="Users9Level" ID="Users9Level" size="1">
						<%
							i=1	
				 			Do Until i > 9
				 		 %>
							<option value=<% = i %><% If objRs("Users9Level") = i Then Response.Write(" selected") %>>	<% = i %></option>
							<% i=i+1
							Loop
							%>
					</select>
							</td>
                        </tr>
                    </table>
            </div>
            <h3><a style="background:url(images/more_icon.png) no-repeat right;" href="#">שדות נוספים</a></h3>
				<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table1">
                       <tr>
                           <td align="right"><% = SiteTranslate("other1") %><img src="images/ask22.png" id="east13" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                         <td align="right"><input id="other1" type="text" name="other1" <%If Editmode = "True" Then %> value="<% =objRs("other1")%>" <%Else%> value="" <% End if %> class="goodinputlong" /></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other2") %></td>
                        </tr>
                        <tr>
                         <td align="right"><input id="other2" type="text" name="other2" <%If Editmode = "True" Then %> value="<% =objRs("other2")%>" <%Else%> value="" <% End if %> class="goodinputlong" /></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other3") %></td>
                        </tr>
                        <tr>
                         <td align="right"><input id="other3" type="text" name="other3" <%If Editmode = "True" Then %> value="<% =objRs("other3")%>" <%Else%> value="" <% End if %> class="goodinputlong" /></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other4") %></td>
                        </tr>
                        <tr>
                         <td align="right"><input id="other4" type="text" name="other4" <%If Editmode = "True" Then %> value="<% =objRs("other4")%>" <%Else%> value="" <% End if %> class="goodinputlong" /></td>
                         <tr>
                           <td align="right"><% = SiteTranslate("other5") %></td>
                        </tr>
                        <tr>
                         <td align="right"><input id="other5" type="text" name="other5" <%If Editmode = "True" Then %> value="<% =objRs("other5")%>" <%Else%> value="" <% End if %> class="goodinputlong" /></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other6") %></td>
                        </tr>
                        <tr>
                         <td align="right"><input id="other6" type="text" name="other6" <%If Editmode = "True" Then %> value="<% =objRs("other6")%>" <%Else%> value="" <% End if %> class="goodinputlong" /></td>
                        </tr>
                        </tr>
                    </table>
                 </div>

            </div>
            <div id="formsubmit">
            <input type="submit" style="margin:10px 0 0;" value="שמור" class="saveform"  />
			<p style="margin:10px 0 0 0 ;float:right;"><input type="checkbox" name="sendmailtocustomer">שלח מייל אישור ללקוח</p>

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