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
 <script type="text/javascript">
     jQuery(document).ready(function () {
         jQuery("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });
     });
</script>

<%
CheckSecuirty "forms"
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

CheckSecuirty "photos"
 %>   
    <div class="formtitle">
        <h1>ניהול טפסים</h1>
		<div class="admintoolber">
        <form action="admin_forms.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_forms.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת תמונה" title="הוספת תמונה" /></a></p>
			<p><a href="admin_forms.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_forms.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_forms.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		<th style="width:40%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM forms WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM forms WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
    End If
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין רשומות"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
        fatherID =  objRs("Id")
Do While Not objRs.EOF And HowMany < objRs.PageSize
 
   
            	%>
    <tr>
        <td><%= objRs("Id")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Id") %>_Name"><% = objRs("Name") %></span></td>
        <td><a href="admin_forms.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_forms.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_forms.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
						Set objRs = OpenDB("SELECT * FROM Forms WHERE  SiteID= " & SiteID)	
								objRs.addnew
								objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("Action") = Request.Form("Action")
								
								objRs("TemplateURL") = Trim(Request.Form("TemplateURL"))
								objRs("EditTemplateURL") = Trim(Request.Form("EditTemplateURL"))
								objRs("adminEditTemplateURL") = Trim(Request.Form("adminEditTemplateURL"))

								objRs("TableName") = Trim(Request.Form("TableName"))
								objRs("DefaultOrder") = Request.Form("DefaultOrder")
								objRs("AdminEmail") = Trim(Request.Form("AdminEmail"))
								objRs("Subscribesemailfrom") = Trim(Request.Form("Subscribesemailfrom"))
								objRs("Subscribesemailsubject") = Trim(Request.Form("Subscribesemailsubject"))
								objRs("AdminEmailTemplate") = Request.Form("AdminEmailTemplate")	
								objRs("UserEmailField") = Trim(Request.Form("UserEmailField"))	
								objRs("UserEmailTemplate") = Trim(Request.Form("UserEmailTemplate"))
								objRs("ComfirmationText") = Trim(Request.Form("ComfirmationText"))
								objRs("RedirectionUrl") = Trim(Request.Form("RedirectionUrl"))
								objRs("AdminRedirectionURL") = Trim(Request.Form("AdminRedirectionURL"))
								objRs("Redirecttime") = Trim(Request.Form("Redirecttime"))
								objRs("IsAjax") = Request.Form("IsAjax")
								objRs("IsCaptcha") = Request.Form("IsCaptcha")
								
								objRs("AdminSms") = Request.Form("AdminSms")
								objRs("AdminSmsTemplate") = Request.Form("AdminSmsTemplate")
								objRs("UserSmsField") = Request.Form("UserSmsField")
								objRs("UserSmsTemplate") = Request.Form("UserSmsTemplate")

								objRs("ShowHeaderTemplateURL") = Trim(Request.Form("ShowHeaderTemplateURL"))
								objRs("ShowTemplateURL") = Trim(Request.Form("ShowTemplateURL"))
								objRs("ShowBottomTemplateURL") = Trim(Request.Form("ShowBottomTemplateURL"))
						
								objRs("ShowLevelFieldName") = Trim(Request.Form("ShowLevelFieldName"))
								objRs("ShowFieldLevel") = Cint(Request.Form("ShowFieldLevel"))
								objRs("Days") = Cint(Request.Form("Days"))

								objRs("GridHeaderTemplate") = Trim(Request.Form("GridHeaderTemplate"))
								objRs("GridBottomTemplate") = Trim(Request.Form("GridBottomTemplate"))
								objRs("GridRowTemplate") = Trim(Request.Form("GridRowTemplate"))

								objRs("userHeaderTemplate") = Trim(Request.Form("userHeaderTemplate"))
								objRs("userBottomTemplate") = Trim(Request.Form("userBottomTemplate"))
								objRs("userRowTemplate") = Trim(Request.Form("userRowTemplate"))
							
								objRs("ShowHeaderTemplateURL") = Trim(Request.Form("ShowHeaderTemplateURL"))
								objRs("ShowTemplateURL") = Trim(Request.Form("ShowTemplateURL"))
								objRs("ShowBottomTemplateURL") = Trim(Request.Form("ShowBottomTemplateURL"))
								objRs("NoRecordsTemplate") = Trim(Request.Form("NoRecordsTemplate"))
								
								objRs("User9Level") = Cint(Request.Form("User9Level"))
								objRs("ShowUser9Level") = Cint(Request.Form("ShowUser9Level"))

								objRs("Title") = Trim(Request.Form("Title"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>נוסף בהצלחה. <a href='admin_forms.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_forms.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

						Set objRs = OpenDB("SELECT * FROM Forms WHERE Id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID)	
								
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("Action") = Request.Form("Action")
								
								objRs("TemplateURL") = Trim(Request.Form("TemplateURL"))
								objRs("EditTemplateURL") = Trim(Request.Form("EditTemplateURL"))
								objRs("adminEditTemplateURL") = Trim(Request.Form("adminEditTemplateURL"))

								objRs("TableName") = Trim(Request.Form("TableName"))
								objRs("DefaultOrder") = Request.Form("DefaultOrder")
								objRs("AdminEmail") = Trim(Request.Form("AdminEmail"))
								objRs("Subscribesemailfrom") = Trim(Request.Form("Subscribesemailfrom"))
								objRs("Subscribesemailsubject") = Trim(Request.Form("Subscribesemailsubject"))
								objRs("AdminEmailTemplate") = Request.Form("AdminEmailTemplate")	
								objRs("UserEmailField") = Trim(Request.Form("UserEmailField"))	
								objRs("UserEmailTemplate") = Trim(Request.Form("UserEmailTemplate"))
								objRs("ComfirmationText") = Trim(Request.Form("ComfirmationText"))
								objRs("RedirectionUrl") = Trim(Request.Form("RedirectionUrl"))
								objRs("AdminRedirectionURL") = Trim(Request.Form("AdminRedirectionURL"))
								objRs("Redirecttime") = Trim(Request.Form("Redirecttime"))
								objRs("IsAjax") = Request.Form("IsAjax")
								objRs("IsCaptcha") = Request.Form("IsCaptcha")
								
								objRs("AdminSms") = Request.Form("AdminSms")
								objRs("AdminSmsTemplate") = Request.Form("AdminSmsTemplate")
								objRs("UserSmsField") = Request.Form("UserSmsField")
								objRs("UserSmsTemplate") = Request.Form("UserSmsTemplate")

								objRs("ShowHeaderTemplateURL") = Trim(Request.Form("ShowHeaderTemplateURL"))
								objRs("ShowTemplateURL") = Trim(Request.Form("ShowTemplateURL"))
								objRs("ShowBottomTemplateURL") = Trim(Request.Form("ShowBottomTemplateURL"))
						
								objRs("ShowLevelFieldName") = Trim(Request.Form("ShowLevelFieldName"))
								objRs("ShowFieldLevel") = Cint(Request.Form("ShowFieldLevel"))
								objRs("Days") = Cint(Request.Form("Days"))

								objRs("GridHeaderTemplate") = Trim(Request.Form("GridHeaderTemplate"))
								objRs("GridBottomTemplate") = Trim(Request.Form("GridBottomTemplate"))
								objRs("GridRowTemplate") = Trim(Request.Form("GridRowTemplate"))

								objRs("userHeaderTemplate") = Trim(Request.Form("userHeaderTemplate"))
								objRs("userBottomTemplate") = Trim(Request.Form("userBottomTemplate"))
								objRs("userRowTemplate") = Trim(Request.Form("userRowTemplate"))
							
								objRs("ShowHeaderTemplateURL") = Trim(Request.Form("ShowHeaderTemplateURL"))
								objRs("ShowTemplateURL") = Trim(Request.Form("ShowTemplateURL"))
								objRs("ShowBottomTemplateURL") = Trim(Request.Form("ShowBottomTemplateURL"))
								objRs("NoRecordsTemplate") = Trim(Request.Form("NoRecordsTemplate"))
								
								objRs("User9Level") = Cint(Request.Form("User9Level"))
								objRs("ShowUser9Level") = Cint(Request.Form("ShowUser9Level"))

								objRs("Title") = Trim(Request.Form("Title"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>נערך בהצלחה. <a href='admin_forms.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_forms.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"



						Set objRs = OpenDB("SELECT * FROM Forms WHERE Id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID)	
				             objRs.Addnew
				             objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("Action") = Request.Form("Action")
								
								objRs("TemplateURL") = Trim(Request.Form("TemplateURL"))
								objRs("EditTemplateURL") = Trim(Request.Form("EditTemplateURL"))
								objRs("adminEditTemplateURL") = Trim(Request.Form("adminEditTemplateURL"))

								objRs("TableName") = Trim(Request.Form("TableName"))
								objRs("DefaultOrder") = Request.Form("DefaultOrder")
								objRs("AdminEmail") = Trim(Request.Form("AdminEmail"))
								objRs("Subscribesemailfrom") = Trim(Request.Form("Subscribesemailfrom"))
								objRs("Subscribesemailsubject") = Trim(Request.Form("Subscribesemailsubject"))
								objRs("AdminEmailTemplate") = Request.Form("AdminEmailTemplate")	
								objRs("UserEmailField") = Trim(Request.Form("UserEmailField"))	
								objRs("UserEmailTemplate") = Trim(Request.Form("UserEmailTemplate"))
								objRs("ComfirmationText") = Trim(Request.Form("ComfirmationText"))
								objRs("RedirectionUrl") = Trim(Request.Form("RedirectionUrl"))
								objRs("AdminRedirectionURL") = Trim(Request.Form("AdminRedirectionURL"))
								objRs("Redirecttime") = Trim(Request.Form("Redirecttime"))
								objRs("IsAjax") = Request.Form("IsAjax")
								objRs("IsCaptcha") = Request.Form("IsCaptcha")
								
								objRs("AdminSms") = Request.Form("AdminSms")
								objRs("AdminSmsTemplate") = Request.Form("AdminSmsTemplate")
								objRs("UserSmsField") = Request.Form("UserSmsField")
								objRs("UserSmsTemplate") = Request.Form("UserSmsTemplate")

								objRs("ShowHeaderTemplateURL") = Trim(Request.Form("ShowHeaderTemplateURL"))
								objRs("ShowTemplateURL") = Trim(Request.Form("ShowTemplateURL"))
								objRs("ShowBottomTemplateURL") = Trim(Request.Form("ShowBottomTemplateURL"))
						
								objRs("ShowLevelFieldName") = Trim(Request.Form("ShowLevelFieldName"))
								objRs("ShowFieldLevel") = Cint(Request.Form("ShowFieldLevel"))
								objRs("Days") = Cint(Request.Form("Days"))

								objRs("GridHeaderTemplate") = Trim(Request.Form("GridHeaderTemplate"))
								objRs("GridBottomTemplate") = Trim(Request.Form("GridBottomTemplate"))
								objRs("GridRowTemplate") = Trim(Request.Form("GridRowTemplate"))

								objRs("userHeaderTemplate") = Trim(Request.Form("userHeaderTemplate"))
								objRs("userBottomTemplate") = Trim(Request.Form("userBottomTemplate"))
								objRs("userRowTemplate") = Trim(Request.Form("userRowTemplate"))
							
								objRs("ShowHeaderTemplateURL") = Trim(Request.Form("ShowHeaderTemplateURL"))
								objRs("ShowTemplateURL") = Trim(Request.Form("ShowTemplateURL"))
								objRs("ShowBottomTemplateURL") = Trim(Request.Form("ShowBottomTemplateURL"))
								objRs("NoRecordsTemplate") = Trim(Request.Form("NoRecordsTemplate"))
								
								objRs("User9Level") = Cint(Request.Form("User9Level"))
								objRs("ShowUser9Level") = Cint(Request.Form("ShowUser9Level"))

								objRs("Title") = Trim(Request.Form("Title"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'> נוסף בהצלחה. <a href='admin_forms.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_forms.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    
                    Sql = "SELECT * FROM forms WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'נמחק בהצלחה. <a href='admin_forms.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_forms.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM forms WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM forms WHERE SiteID=" & SiteID   
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
<form action="admin_forms.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת באנר</h1>
				<% ELSE 
				%>
					<h1>עריכת באנר</h1>
				<% End If %>
				</div>
			    <div class="rightform">
				<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
                <tr>
				    <td width="30%" align="right">	שם:</td>
					<td width="80%" align="right">
					    <textarea name="Name" cols="50" rows="1" class="required"><% If Editmode = "True" Then %><% = objRs("Name") %><% End If %></textarea>
					</td>
			    </tr>
			    <tr>
				    <td width="20%" align="right">תבנית עיצוב הטופס (הוספה):</td>
					<td valign="top" align="right" width="80%">
						<input dir="ltr" class="goodinputshort" id="TemplateURL" name="TemplateURL" <%If Editmode = "True" Then %> value="<% =objRs("TemplateURL")%>"<%End If %> type="text" size="100" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('TemplateURL');"/>
					</td>
				</tr>
				<tr>
                	<td width="20%" align="right">-תבנית עיצוב הטופס (עריכה משתמש):</td>
					<td valign="top" align="right" width="80%">
						<input dir="ltr" class="goodinputshort" id="EditTemplateURL" name="EditTemplateURL" <%If Editmode = "True" Then %> value="<% =objRs("EditTemplateURL")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('EditTemplateURL');"/>
					</td>
				</tr>

				</tr>
				<tr>
                    <td width="20%" align="right">-תבנית עיצוב הטופס (עריכה מנהל):</td>
					<td valign="top" align="right" width="80%">
						<input dir="ltr" class="goodinputshort" id="adminEditTemplateURL" name="adminEditTemplateURL" <%If Editmode = "True" Then %> value="<% =objRs("adminEditTemplateURL")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('adminEditTemplateURL');"/>
					</td>
				</tr>
				<tr>
				    <td width="20%" align="right">טבלה:</td>
					<td valign="top" align="right" width="80%">
                    <select style="width: 200px;"  name="TableName"  size="1" dir="ltr">
                    <option value="0">ללא טבלה</option>
                    <% Const adSchemaTables = 20
                        Set objConnection = SetConn()
                        Set objRecordSet = CreateObject("ADODB.Recordset")
                        Set objRecordSet = objConnection.OpenSchema(adSchemaTables)
                        Do While NOT objRecordset.EOF
	                        If lcase(objRecordset.Fields.Item("TABLE_TYPE")) = "table" Then %>
                                <option value="<% = objRecordset.Fields.Item("TABLE_NAME")%>"<% If Editmode = "True" Then %><% If objRecordset.Fields.Item("TABLE_NAME") = objRs("TableName") Then Response.Write(" selected") %><% end if %>><% = objRecordset.Fields.Item("TABLE_NAME") %></option>
                        <% End If
                        objRecordset.MoveNext
                            Loop %>
                </select>
                </td>
			    </tr>
				<tr>
				    <td width="20%" align="right">שדה ושיטה למיון ברירת מחדל</td>
                    <td valign="top" align="right" width="80%"><input style="width: 200px;" type="text" name="DefaultOrder" size="50" maxlength="100"  <% If Editmode = "True" Then %> value="<% = objRs("DefaultOrder") %><% End If %>" dir="ltr"></td>
			    </tr>
				<tr>
			        <td width="20%" align="right">רמת הרשאה משתמש ל-הכנסת נתונים)</td>
			        <td valign="top" align="right" width="80%">					  					  
					<select style="width: 40px;" name="User9Level" ID="User9Level" size="1">
					<% x=1	
				 	    Do Until x > 9	 %>
							<option value=<% = x %><% If Editmode = "True" Then %><% If objRs("User9Level") = x Then Response.Write(" selected") %><% End if %>><% = x %></option>
					<% x=x+1
							Loop%>
					</select>
                    </td>
			    </tr>
			    <tr>
				    <td width="20%" align="right">פעולה(action):</td>
					<td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="Action" size="80" maxlength="200" <% If Editmode = "True" Then %>value="<% = objRs("Action") %>"<% End If %> dir="ltr"></td>
			    </tr>
				<tr>
					 <td width="20%" align="right">טקסט אישור לאחר שנשלח בהצלחה:</td>
					<td valign="top" align="right" width="80%">
					<textarea style="width: 300px;" rows="6" name="ComfirmationText" cols="43" onKeyDown="textCounter(this.form.FormBlockShortText,this.form.remLen,<% = maxchars %>);" onKeyUp="textCounter(this.form.ComfirmationText,this.form.remLen,<% = maxchars %>);"><% If Editmode = "True" Then %><% = objRs("ComfirmationText") %><% End If %></textarea>
					<br>
			   <input readonly type=text name=remLen size=1 maxlength=3 value="<% = maxchars %>"> תווים (מקסימום <% = maxchars %>)
				</td>
			    </tr>
				<tr>
				    <td width="20%" align="right">זמן להפנייה:</td>
					<td valign="top" align="right" width="80%"><input style="width: 52;height:19" type="text" name="Redirecttime" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("Redirecttime") %>" <% End If %> dir="ltr"></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">הפנייה לאחר המילוי:</td>
					<td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="RedirectionUrl" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("RedirectionUrl") %>" <% End If %> dir="ltr"></td>
			    </tr>
				<tr>
				     <td width="20%" align="right">האם להשתמש בAJAX:</td>
					<td valign="top" align="right" width="80%"><input type="checkbox" name="IsAjax" value="True" <% If Editmode = "True" Then %><% If objRs("IsAjax") = true Then %> checked ="checked"<% End if %> <% End if %>></td>
			    </tr>
				<tr>
				     <td width="20%" align="right">האם יש CAPTHA:</td>
					<td valign="top" align="right" width="80%"><input type="checkbox" name="IsCaptcha" value="True" <% If Editmode = "True" Then %><% If objRs("IsCaptcha") = true Then %> checked ="checked"<% End if %> <% End If %>></td>
			    </tr>
				<tr>
				     <td width="20%" align="right">הפניית ADMIN לאחר המילוי:</td>
					<td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="AdminRedirectionURL" size="50" maxlength="100" <% If Editmode = "True" Then %>value="<% = objRs("AdminRedirectionURL") %>" <% End If %> dir="ltr"></td>
			    </tr>
				
				
			    <tr>			
					<td valign="top" align="center" colspan="2" height="22" 
     bgcolor="#DDDDDD">
					<input type="submit" id="save" value="שמור שינויים"></td>
				</tr>
			</table>
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">מודעות - ADS</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
				        <tr>
			       <td width="20%" align="right">רמת הרשאה לצפייה במודעות(כל המודעות):</td>
                   </tr>
                   <tr>
			       <td valign="top" align="right" width="80%">				  					  
					<select style="width: 40px;" name="ShowUser9Level" ID="User9Level0" size="1">
					<%	x=1	
				 		Do Until x > 9 %>
							<option value=<% = x %><% If Editmode = "True" Then %><% If objRs("ShowUser9Level") = x Then Response.Write(" selected") %><%End If %>>	<% = x %></option>
					<% x=x+1
						 Loop%>
					</select>
                    </td>
			    </tr>
				<tr>
				   <td width="20%" align="right">ימים עד שהמודעה לא מוצגת:</td>
                   </tr>
                   <tr>
                    <td valign="top" align="right" width="80%"><input style="width: 52;height:19" type="text" name="Days" size="10" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("Days") %>" <% End If %> dir="ltr"></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">Ads Header:</td>
                   </tr>
                   <tr>
                    <td valign="top" align="right" width="80%">					
						<input dir="ltr" class="goodinputshort" id="ShowHeaderTemplateURL" name="ShowHeaderTemplateURL" <%If Editmode = "True" Then %> value="<% =objRs("ShowHeaderTemplateURL")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('ShowHeaderTemplateURL');"/>
                    </td>
				</tr>
				<tr>
				    <td width="20%" align="right">Ads Footer</td>
                   </tr>
                   <tr>
                    <td valign="top" align="right" width="80%">					
						<input dir="ltr" class="goodinputshort" id="ShowBottomTemplateURL" name="ShowBottomTemplateURL" <%If Editmode = "True" Then %> value="<% =objRs("ShowBottomTemplateURL")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('ShowBottomTemplateURL');"/>
                    </td>
				</tr>
				<tr>
				    <td width="20%" align="right">Ads Row</td>
                   </tr>
                   <tr>
                    <td valign="top" align="right" width="80%">					
						<input dir="ltr" class="goodinputshort" id="ShowTemplateURL" name="ShowTemplateURL" <%If Editmode = "True" Then %> value="<% =objRs("ShowTemplateURL")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('ShowTemplateURL');"/>
                </td>
				</tr>
				<tr>
				   <td width="20%" align="right">אין רשומות</td>
                   </tr>
                   <tr>
                    <td valign="top" align="right" width="80%">					
						<input dir="ltr" class="goodinputshort" id="NoRecordsTemplate" name="NoRecordsTemplate" <%If Editmode = "True" Then %> value="<% =objRs("NoRecordsTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('NoRecordsTemplate');"/>
                </td>
				</tr>
			    <tr>
				   <td width="20%" align="right">שדה ברשומה שמחזיק רמת הרשאה לצפייה במודעה</td>
                   </tr>
                   <tr>
        		   <td valign="top" align="right" width="80%"><input style="width: 214;height:19" type="text" name="ShowLevelFieldName" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("ShowLevelFieldName") %>" <%End If %> dir="ltr"></td>
			    </tr>
				<tr>
			        <td width="20%" align="right">רמת הרשאה לצפייה במודעה(מתייחס לשדה ברשומה):</td>
                   </tr>
                   <tr>
                    <td valign="top" align="right" width="80%">				  					  
					<select style="width: 40px;" name="ShowFieldLevel" ID="ShowFieldLevel" size="1">
						<%	x=1	
				 			Do Until x > 9 %>
							<option value=<% = x %><% If Editmode = "True" Then %><% If objRs("ShowFieldLevel") = x Then Response.Write(" selected") %><%End If %>>	<% = x %></option>
						<% x=x+1
							Loop%>
					</select>
                    </td>
			    </tr>
                       </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">מנהל - ADMIN</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table1">
                        
				<tr>
				    <td width="20%" align="right">Admin header</td>
				</tr>
				<tr>
                    <td valign="top" align="right" width="80%">				  					  
						<input dir="ltr" class="goodinputshort" id="GridHeaderTemplate" name="GridHeaderTemplate" <%If Editmode = "True" Then %> value="<% =objRs("GridHeaderTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('GridHeaderTemplate');"/>
                    </td>
				</tr>
				<tr>
				    <td width="20%" align="right">Admin footer</td>
				</tr>
				<tr>
                    <td valign="top" align="right" width="80%">				  					  
						<input dir="ltr" class="goodinputshort" id="GridBottomTemplate" name="GridBottomTemplate" <%If Editmode = "True" Then %> value="<% =objRs("GridBottomTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('GridBottomTemplate');"/>
                    </td>
				</tr>
				<tr>
				   <td width="20%" align="right">Admin row</td>
				</tr>
				<tr>
        	        <td valign="top" align="right" width="80%">				  					  
						<input dir="ltr" class="goodinputshort" id="GridRowTemplate" name="GridRowTemplate" <%If Editmode = "True" Then %> value="<% =objRs("GridRowTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('GridRowTemplate');"/>
                    </td>
				</tr>
                       </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">משתמש - USER</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table2">
                      
				<tr>
				    <td width="20%" align="right">User header</td>
				</tr>
				<tr>
                    <td valign="top" align="right" width="80%">				  					  
						<input dir="ltr" class="goodinputshort" id="UserHeaderTemplate" name="UserHeaderTemplate" <%If Editmode = "True" Then %> value="<% =objRs("UserHeaderTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('UserHeaderTemplate');"/>
	                </td>
				</tr>
				<tr>
				   <td width="20%" align="right">User footer</td>
				</tr>
				<tr>
    		        <td valign="top" align="right" width="80%">				  					  
						<input dir="ltr" class="goodinputshort" id="UserBottomTemplate" name="UserBottomTemplate" <%If Editmode = "True" Then %> value="<% =objRs("UserBottomTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('UserBottomTemplate');"/>
                    </td>
				</tr>
				<tr>
				    <td width="20%" align="right">User row</td>
				</tr>
				<tr>
    		        <td valign="top" align="right" width="80%">				  					  
						<input dir="ltr" class="goodinputshort" id="UserRowTemplate" name="UserRowTemplate" <%If Editmode = "True" Then %> value="<% =objRs("UserRowTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('UserRowTemplate');"/>
	                </td>
				</tr>
                       </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">שליחת אימייל למנהל</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table3">
				<tr>
				     <td width="20%" align="right">מאת:	</td>
			    </tr>
				<tr>
        			<td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="Subscribesemailfrom" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("Subscribesemailfrom") %>" <%End If %> dir="ltr"></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">כותרת האימייל:</td>
			    </tr>
				<tr>
        			<td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="Subscribesemailsubject" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("Subscribesemailsubject") %>" <%End If %> dir="ltr"></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">אימייל מנהל:</td>
			    </tr>
				<tr>
					<td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="AdminEmail" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("AdminEmail") %>" <%End If %> dir="ltr"></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">תבנית עיצוב אימייל מנהל:</td>
         			    </tr>
				<tr>
   
                    <td valign="top" align="right" width="80%">
						<input dir="ltr" class="goodinputshort" id="AdminEmailTemplate" name="AdminEmailTemplate" <%If Editmode = "True" Then %> value="<% =objRs("AdminEmailTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('AdminEmailTemplate');"/>
					</td>
				</tr>
                       </table>

                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">שליחת אימייל למשתמש</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table4">
				<tr>
				    <td width="20%" align="right">שדה בטופס המייצג את האימייל של המשתמש:</td>
			    </tr>
				<tr>
                    <td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="UserEmailField" size="50" maxlength="100" <%If Editmode = "True" Then %> value="<% = objRs("UserEmailField") %>" <%End If %> dir="ltr"></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">תבנית עיצוב אימייל לקוח:</td>
			    </tr>
				<tr>
    				<td valign="top" align="right" width="80%">
						<input dir="ltr" class="goodinputshort" id="UserEmailTemplate" name="UserEmailTemplate" <%If Editmode = "True" Then %> value="<% =objRs("UserEmailTemplate")%>" <%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('UserEmailTemplate');"/>
					</td>
				</tr>
                       </table>

                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">שליחת SMS למנהל</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table5">
                <tr>
        			<td valign="top" align="right" width="80%"><input style="width: 150px; margin-left: 80px;" type="text" name="AdminSms" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("AdminSms") %>" <%End If %> dir="ltr"></td>
			    </tr>
				<tr>
				     <td width="20%" align="right">תבנית עיצוב Sms מנהל:</td>
			    </tr>
				<tr>
    				<td valign="top" align="right" width="80%">
						<input dir="ltr" class="goodinputshort" id="AdminSmsTemplate" name="AdminSmsTemplate" <%If Editmode = "True" Then %> value="<% =objRs("AdminSmsTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('AdminSmsTemplate');"/>
                    </td>
				</tr>

                       </table>

                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">שליחת SMS למשתמש</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table6">
				<tr>
				    <td width="20%" align="right">שדה בטופס המייצג את מספר הטלפון של המשתמש לשליחת SMS:</td>
			    </tr>
				<tr>
            		<td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="UserSmsField" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("UserSmsField") %>" <%End If %> dir="ltr"></td>
			    </tr>
				<tr>
				   <td width="20%" align="right">תבנית עיצוב SMS לקוח:</td>
			    </tr>
				<tr>
    				<td valign="top" align="right" width="80%">
						<input dir="ltr" class="goodinputshort" id="UserSmsTemplate" name="UserSmsTemplate" <%If Editmode = "True" Then %> value="<% =objRs("UserSmsTemplate")%>"<%End If %> type="text" size="60" />
					    <input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('UserSmsTemplate');"/>
                    </td>
				</tr>
                       </table>

                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">הגדרות SEO</a></h3>
			        <div>
                       <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table7">
                    <tr>
                        <td width="20%" align="right">כיתוב בכותרת האתר:</td>
			    </tr>
				<tr>
                	    <td valign="top" align="right" width="80%"><input style="width: 300px;" type="text" name="Title" size="50" maxlength="100" <% If Editmode = "True" Then %> value="<% = objRs("Title") %>" <%End If %>></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">מילות מפתח:</td>
				</tr>
				<tr>
                	<td valign="top" align="right" width="80%"><textarea style="width: 300px;" rows="6" name="Keywords" cols="46"><% If Editmode = "True" Then %><% = objRs("Keywords") %><%End If %></textarea></td>
			    </tr>
				<tr>
				    <td width="20%" align="right">תאור לקידום:</td>
			    </tr>
				<tr>
                    <td valign="top" align="right" width="80%"><textarea style="width: 300px;" rows="6" name="Description" cols="46"><% If Editmode = "True" Then %><% = objRs("Description") %><%End If %></textarea></td>
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