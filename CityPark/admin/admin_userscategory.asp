<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
    });
</script>
<script type='text/javascript'>
    $(function () {
        $('#east').tipsy({ html: true });
    });
</script>

<%
CheckSecuirty "userscategory"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [block] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "block-Disposition", "attachment;filename=block-"&filedate&".xls"
        Response.blockType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "block-Disposition", "attachment;filename=block-"&filedate&".doc"
        Response.blockType = "application/vnd.ms-word"
     End If

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

CheckSecuirty "Userscategory"
 %>   
    <div class="formtitle">
        <h1>ניהול קבוצות משתמשים</h1>
		<div class="admintoolber">
        <form action="admin_userscategory.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_userscategory.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_userscategory.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_userscategory.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_userscategory.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		<th style="width:60%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM userscategory WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM userscategory WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
    End If
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין רשומות"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
        fatherID =  objRs("Id")
Do While Not objRs.EOF And HowMany < objRs.PageSize
SQLusers = "SELECT Users.*,  Users.SiteID FROM Users INNER JOIN UsersPerCategory ON Users.Id = UsersPerCategory.UsersID  AND Users.SiteID = UsersPerCategory.SiteID WHERE UsersPerCategory.userscategoryID = " &  objRs("Id")
Set objRsusers = OpenDB(SQLusers)
if objRsusers.recordcount = 0 then 
    emptycategory = True
end if
    CloseDB(objRsusers)
 
   
            	%>
    <tr>
        <td><%= objRs("Id")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Id") %>_Name"><% = objRs("Name") %></span></td>
        <td><a href="admin_userscategory.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_userscategory.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><% if emptycategory = True then %><a href="admin_userscategory.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a><% end If %></td>
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
	        Editmode= "False"
			        Sql = "SELECT * FROM userscategory WHERE SiteID=" & SiteID
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>קבוצה נוספה בהצלחה. <a href='admin_userscategory.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_userscategory.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM userscategory WHERE ID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>קבוצה נערכה בהצלחה. <a href='admin_userscategory.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_userscategory.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM userscategory WHERE ID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>קבוצה נוספה בהצלחה. <a href='admin_userscategory.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_userscategory.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    
                    Sql = "SELECT * FROM userscategory WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'קבוצה נמחקה בהצלחה. <a href='admin_userscategory.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_userscategory.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM userscategory WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM userscategory WHERE SiteID=" & SiteID   
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
<form action="admin_userscategory.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת קבוצת משתמשים</h1>
				<% ELSE 
				%>
					<h1>עריכת קבוצת משתמשים</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם הקבוצה:</p><img src="images/ask22.png" id="east" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" onkeyup ="Menusname.value = this.value;urltext.value = this.value;title.value = this.value;return true;"><%If Editmode = "True" Then print objRs("Name") End If %><% if request.querystring("name")<> "" Then print request.querystring("name") end if%></textarea>
					  </div>
					  </td>
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">עתידי</a></h3>
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