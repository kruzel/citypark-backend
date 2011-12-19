<!--#include file="../config.asp"-->
<!--#include file="../inc_sendmail.asp"-->
<% header 
SetSession "BackURL","/user/tlcusermenu.asp"
If Request.Cookies(SiteID & "UserLevel") = "" Then 
 Response.Redirect("/user/")
End If
    CheckUserSecurity_Level Request.Cookies(SiteID & "UserLevel"),GetSession("BackURL")

Set objRsuser = OpenDB("Select * From Users where Id=" & Request.Cookies(SiteID & "UserID"))
name = objRsuser("other7") 

If Request.querystring("mode") = "doit" then
	

	SQl = "Select * From tlcmenus where siteID=" & SiteID
	SQl = SQl & " And UsersID=" & Request.Cookies(SiteID & "UserID")
	Set objRs=OpenDB(SQl)
		objRs("tlcclassID") = objRsuser("tlcclassID")
		objRs("SunMeat") = Request.form("SunMeat")
		objRs("SunSoup") = Request.form("SunSoup")

		objRs("MonMeat") = Request.form("MonMeat")
		objRs("MonSoup") = Request.form("MonSoup")

		objRs("ThrMeat") = Request.form("ThrMeat")
		objRs("ThrSoup") = Request.form("ThrSoup")

		objRs("WedMeat") = Request.form("WedMeat")
		objRs("WedSoup") = Request.form("WedSoup")

		objRs("ThuMeat") = Request.form("ThuMeat")
		objRs("ThuSoup") = Request.form("ThuSoup")
		objRs.update
				print "Select ManagerMail From tlchomes Where tlchomesID=" & objRs("tlchomesID")
				set obj = OpenDB("Select ManagerMail From tlchomes Where tlchomesID=" & objRs("tlchomesID")) ' לשלוח מייל עדכון למנהל

				dim fs ' אם התבנית קיימת שלח דואל ללקוח
				set fs=Server.CreateObject("Scripting.FileSystemObject")
				ManagerMail = templatelocation & "Email/weeklymenutomanager.html"
						 if fs.FileExists(Server.MapPath(ManagerMail))=true then
							 txt2send = getformlayout(GetUrl(ManagerMail), SQL, "edit")
							SendMail "תפריט השבוע של" & objRsuser("Name") & "-" & objRsuser("Familyname"),"web@tl-care.co.il", obj("ManagerMail"), txt2send
						 
						 else
							print "לא קיים"
						 End if
				Response.Redirect("/user/?notificate=תפריט עודכן בהצלחה")		 
				CloseDB(obj)
	CloseDB(objRs)

            
End if


SQl = "Select * From tlcmenus where siteID=" & SiteID
SQl = SQl & " And UsersID=" & Request.Cookies(SiteID & "UserID")
Set objRs=OpenDB(SQl)
If objRs.recordcount = 0 then 'אם למשתמש אין תפריט אז נפתח לו תפריט חדש
		objRs.addnew
		objRs("UsersID") = objRsuser("Id")
		objRs("tlchomesID") = objRsuser("tlchomesID")
		objRs("SiteID") = SiteID
		objRs.update
		objRs.movelast
	CloseDB(objRsuser)
End if

%>
<div class="verticalMenuDiv">
	<div class="RmenuTop"></div>
	<div class="RmenuMiddle">
		<h2>איזור אישי</h2>
		<ul class="sf-menu2 sf-vertical">
		  <li class=""><a href="/user/user.asp">הפרטים שלי</a></li>
		  <li class=""><a href="/user/tlcusermenu.asp">התפריט שלי</a></li>
		  <li class=""><a href="/צור-קשר">כתוב לנו</a></li>
		  <li class=""><a href="/user/login.asp?mode=loguot">התנתק</a></li>
		</ul>
	</div>
	<div class="RmenuBottom"></div>
</div>
<div class="content1">
	<div class="contentTextTop"></div>
	<div class="contentTextMiddle">
		<h1>תפריט של - <% = name %></h1>
		<div class="contentText" style="width:729px;">
			<div class="inText2" style="width:739px;">
			
			
			
<form action="tlcusermenu.asp?mode=doit" method="post" class="_validate">
	<div class="formDay">
	<div class="formDayIN">
		<img src="/sites/tlc/layout/he-IL/images/day.png" alt="" width="32" />
		<h3 class="days">יום ראשון</h3>
		<div class="divMenu">
			<ul>
            <% SQl = "Select * From tlcmeat where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="SunMeat" value="<%= objRsm("Name")%>" <% if objRs("SunMeat") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
                loop
            %>
            </ul>
			
            <% SQl = "Select * From tlcsoup where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
				If objRsm.Recordcount > 0 Then %>
				<ul>
				<li><b>מרקים:</b></li>
                <% Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="SunSoup" value="<%= objRsm("Name")%>" <% if objRs("SunSoup") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
                loop
				print "</ul>"
				End if
            %>
			

		</div>
	</div>
</div>
<div class="formDay">
	<div class="formDayIN">
		<img src="/sites/tlc/layout/he-IL/images/day.png" alt="" width="32" />
		<h3 class="days">יום שני</h3>
		<div class="divMenu">
			<ul>

            <% SQl = "Select * From tlcmeat where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="MonMeat" value="<%= objRsm("Name")%>" <% if objRs("MonMeat") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
                loop
            %>

			</ul>
			
            <% SQl = "Select * From tlcsoup where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
					If objRsm.Recordcount > 0 Then %>
				<ul>
				<li><b>מרקים:</b></li>
                <% Do While NOT objRsm.EOF %>				<li><label><input type="radio" name="MonSoup" value="<%= objRsm("Name")%>" <% if objRs("MonSoup") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
                loop
				print "</ul>"
				End if
            %>
			</div>
	</div>
</div>
<div class="formDay">
	<div class="formDayIN">
		<img src="/sites/tlc/layout/he-IL/images/day.png" alt="" width="32" />
		<h3 class="days">יום שלישי</h3>

		<div class="divMenu">
			<ul>
            <% SQl = "Select * From tlcmeat where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="ThrMeat" value="<%= objRsm("Name")%>" <% if objRs("ThrMeat") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
                loop
            %>

			</ul>
			
            <% SQl = "Select * From tlcsoup where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
				If objRsm.Recordcount > 0 Then %>
				<ul>
				<li><b>מרקים:</b></li>
                <% Do While NOT objRsm.EOF %>				<li><label><input type="radio" name="ThrSoup" value="<%= objRsm("Name")%>" <% if objRs("ThrSoup") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
               loop
				print "</ul>"
				End if
            %>
			</div>
	</div>
</div>
<div class="formDay">
	<div class="formDayIN">

		<img src="/sites/tlc/layout/he-IL/images/day.png" alt="" width="32" />
		<h3 class="days">יום רביעי</h3>
		<div class="divMenu">
			<ul>
            <% SQl = "Select * From tlcmeat where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="WedMeat" value="<%= objRsm("Name")%>" <% if objRs("WedMeat") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
                loop
            %>
			</ul>
			
            <% SQl = "Select * From tlcsoup where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                If objRsm.Recordcount > 0 Then %>
				<ul>
				<li><b>מרקים:</b></li>
                <% Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="WedSoup" value="<%= objRsm("Name")%>" <% if objRs("WedSoup") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
               loop
				print "</ul>"
				End if
            %>
		</div>
	</div>
</div>
<div class="formDay">
	<div class="formDayIN">
		<img src="/sites/tlc/layout/he-IL/images/day.png" alt="" width="32" />
		<h3 class="days">יום חמישי</h3>
		<div class="divMenu">
			<ul>

            <% SQl = "Select * From tlcmeat where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="ThuMeat" value="<%= objRsm("Name")%>" <% if objRs("ThuMeat") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
                loop
            %>

			</ul>
			
            <% SQl = "Select * From tlcsoup where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                If objRsm.Recordcount > 0 Then %>
				<ul>
				<li><b>מרקים:</b></li>
                <% Do While NOT objRsm.EOF %>
				<li><label><input type="radio" name="ThuSoup" value="<%= objRsm("Name")%>" <% if objRs("ThuSoup") =objRsm("Name") then print "checked=""checked""" %>/> <%= objRsm("Name")%></label></li>
			<% objRsm.Movenext
				loop
				print "</ul>"
				End if            %>
		</div>
	</div>
</div>
<input type="submit" value="שלח" class="send" />

	</form>
	
	
				</div>
		</div>
	</div>
	<div class="contentTextBottom"></div>
</div>
	
	
	
	
<% bottom %>