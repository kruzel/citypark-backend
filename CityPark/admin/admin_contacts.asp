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
CheckSecuirty "Contactform"
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

CheckSecuirty "Contactform"
 %>   
    <div class="formtitle">
        <h1>ניהול פניות</h1>
		<div class="admintoolber">
        <form action="admin_contacts.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_contacts.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_contacts.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_contacts.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_contacts.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th style="width:20%;">תאריך</th>
		<th style="width:15%;">שם</th>
		<th style="width:20%;">Email</th>
		<th style="width:13%;">טלפון</th>
		<th style="width:12%;">סטאטוס</th>
        <th>ערוך</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM contactform WHERE SiteID=" & SiteID & " ORDER BY Date DESC"
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM contactform WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'  ORDER BY Date DESC"
    End If
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין רשומות"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
Do While Not objRs.EOF And HowMany < objRs.PageSize
            	 
         If objRs("status") = "0" Then status = "<b>פנייה חדשה</b>"
         If objRs("status") = "1" Then status = "בטיפול"
         If objRs("status") = "2" Then status = "טופל"
	%>

    <tr>
        <td><%= objRs("Date")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Id") %>_Name"><% = objRs("Name") %></span></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Email") %>_Name"><% = objRs("Email") %></span></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Phone") %>_Name"><% = objRs("Phone") %></span></td>
		<td style="text-align:right;"><% = status %></td>
        <td><a href="admin_contacts.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td style="border-left:0px;"><a href="admin_contacts.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
	       	 Editmode= "True"

	            
				    Sql = "SELECT * FROM Contactform WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
				                objRs("SiteID") = SiteID
				                objRs("Name") = Request.Form("Name")
								objRs("Email") = Request.Form("Email")
								objRs("Phone") = Request.Form("Phone")
								objRs("City") = Request.Form("City")
								objRs("About") = Request.Form("About")
								objRs("Message") = Request.Form("Message")
								objRs("status") = Request.Form("status")
								objRs("hearot") = Request.Form("hearot")

								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>רשומה נערכה בהצלחה. <a href='admin_Contacts.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_Contacts.asp?S=" & SiteID & "'>")

	        	
	        
	        Case "delete"
				    Sql = "SELECT * FROM Contactform WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>רשומה נמחקה בהצלחה. <a href='admin_Contacts.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' users='0; URL=admin_Contacts.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM contactform WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM contactform WHERE SiteID=" & SiteID   
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
<form action="admin_contacts.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת פנייה</h1>
				<% ELSE 
				%>
					<h1>עריכת פנייה</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td width="75" align="right" valign="top">שם</td>
                    <td align="right" valign="top"><input id="Name" type="text" name="Name"<%If Editmode = "True" Then %> value="<% =objRs("Name")%>"<% End if %> class="goodinputlong" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">טלפון</td>
                    <td align="right" valign="top"><input id="cellular" type="text" name="Phone"<%If Editmode = "True" Then %> value="<% =objRs("Phone")%>"<% End if %> class="goodinputlong" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">Email</td>
                    <td align="right" valign="top"><input id="Email" type="text" name="Email"<%If Editmode = "True" Then %> value="<% =objRs("Email")%>"<% End if %> class="goodinputlong" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">כתובת</td>
                    <td align="right" valign="top"><input id="City" type="text" name="City"<%If Editmode = "True" Then %> value="<% =objRs("City")%>"<% End if %> class="goodinputlong" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">נושא הפנייה</td>
                    <td align="right" valign="top"><input id="About" type="text" name="About"<%If Editmode = "True" Then %> value="<% =objRs("About")%>"<% End if %> class="goodinputlong" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תאור</td>
                    <td align="right"><textarea rows="3" name="Message" cols="10" style="width:80%;height:200px;" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("Message") End If %></textarea></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תאריך</td>
                    <td align="right" valign="top"><input readonly id="date" type="text" name="date"<%If Editmode = "True" Then %> value="<% =objRs("date")%>"<% End if %> class="goodinputshort" style="margin:5px 0 0 0" /></td>
                </tr>
                
                <tr>
                    <td align="right">סטאטוס</td>
                    <td align="right" valign="top">   
           				        <select class="goodselect" name="status" size="1">
					                <option value="0"<%If Editmode = "True" Then %><% If objRs("status") = "0" Then Response.Write(" selected") %><% End If %>>פנייה חדשה</option>
    					            <option value="1"<%If Editmode = "True" Then %> <% If objRs("status") = "1" Then Response.Write(" selected") %><% End If %>>בטיפול</option>
    					            <option value="2"<%If Editmode = "True" Then %> <% If objRs("status") = "2" Then Response.Write(" selected") %><% End If %>>טופל</option>
					            </select>
                    </td>
               </tr>
               <tr>
                    <td width="75" align="right" valign="top">הערות</td>
                    <td align="right"><textarea rows="3" name="hearot" cols="10" style="width:80%;" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("hearot") End If %></textarea></td>
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