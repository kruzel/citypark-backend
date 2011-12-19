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
CheckSecuirty "template"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [template] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "template-Disposition", "attachment;filename=template-"&filedate&".xls"
        Response.templateType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "template-Disposition", "attachment;filename=template-"&filedate&".doc"
        Response.templateType = "application/vnd.ms-word"
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

CheckSecuirty "template"
 %>   
    <div class="formtitle">
        <h1>ניהול תבניות תוכן</h1>
		<div class="admintoolber">
        <form action="admin_template.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_template.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת תבנית " /></a></p>
			<p><a href="admin_template.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_template.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_template.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		<th style="width:50%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>ברירת מחדל</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM template WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM template WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
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
        <td><% If objRs("Defaultremplate")= True Then %><img style="border:0px;" src="images/active.png" border="0" alt="" /><% Else %><img style="border:0px;" src="images/notactive.png" border="0" alt="" /><% End if %></td>
        <td><a href="admin_template.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_template.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_template.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM template WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM template"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("Name") = Request.Form("Name")
							 objRs("Header") = Request.Form("Header")
							 objRs("Template") = Trim(Request.Form("Template"))	
							 objRs("Footer") = Trim(Request.Form("Footer"))
							 objRs("Image") = Trim(Request.Form("Image"))
							 objRs("LangID") = Trim(Request.Form("LangID"))
							 objRs("Defaultremplate") = Request.Form("Defaultremplate")
                            	objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>תבנית נוספה בהצלחה. <a href='admin_template.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_template.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM template WHERE ID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
				             objRs("Name") = Request.Form("Name")
							 objRs("Header") = Request.Form("Header")
							 objRs("Template") = Trim(Request.Form("Template"))	
							 objRs("Footer") = Trim(Request.Form("Footer"))
							 objRs("Image") = Trim(Request.Form("Image"))
							 objRs("LangID") = Trim(Request.Form("LangID"))
							 objRs("Defaultremplate") = Request.Form("Defaultremplate")
                            	objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>תבנית נערכה בהצלחה. <a href='admin_template.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_template.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"
				    Sql = "SELECT * FROM template WHERE ID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("Name") = Request.Form("Name")
							 objRs("Header") = Request.Form("Header")
							 objRs("Template") = Trim(Request.Form("Template"))	
							 objRs("Footer") = Trim(Request.Form("Footer"))
							 objRs("Image") = Trim(Request.Form("Image"))
							 objRs("LangID") = Trim(Request.Form("LangID"))
							 objRs("Defaultremplate") = Request.Form("Defaultremplate")
                            	objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>תבנית נוספה בהצלחה. <a href='admin_template.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_template.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    Sql = "SELECT * FROM template WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>תבנית נמחק בהצלחה. <a href='admin_template.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' users='0; URL=admin_template.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM template WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM template WHERE SiteID=" & SiteID   
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
<form action="admin_template.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="template2" name="template2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת תבנית</h1>
				<% ELSE 
				%>
					<h1>עריכת תבנית</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם תבנית:</p><img src="images/ask22.png" id="east" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" onkeyup ="Menusname.value = this.value;urltext.value = this.value;title.value = this.value;return true;"><%If Editmode = "True" Then print objRs("Name") End If %><% if request.querystring("name")<> "" Then print request.querystring("name") end if%></textarea>
					  </div>
					  </td>
					</tr>
					 <tr>
                    <td align="right">שפה</td>
                    <td align="right"><%
						Set objRsLang = OpenDB("SELECT * FROM Lang ORDER BY langorder ASC")
					%>					  
					</font>
				
					<select  name="LangID">
					<%
                    If Editmode = "True" Then
					    Do While Not objRsLang.EOF	%>
						<option value="<% = objRsLang("LangID") %>"<% If objRsLang("LangID") = objRs("LangID") Then Response.Write(" selected") End if %>><% = objRsLang("LangName") %></option>
					<%	objRsLang.MoveNext 
					        Loop
					Else
					    Do While Not objRsLang.EOF
					%><option value="<% = objRsLang("LangID") %>"<% If Trim(objRsLang("LangName")) = defaultcategory Then Response.Write(" selected") End if %>><% = objRsLang("LangName") %></option>
					<%	
					    objRsLang.MoveNext 
					        Loop
					End If
					%>
					</select>
					<% 
					objRsLang.Close
					%></td>
                         </tr>
                        <tr>
                            <td align="right">חלק עליון<img src="images/ask22.png" id="Img1" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath2" name="Header" <%If Editmode = "True" Then %> value="<% =objRs("Header")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('xFilePath2');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תבנית<img src="images/ask22.png" id="east9" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath1" name="Template" <%If Editmode = "True" Then %> value="<% =objRs("Template")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('xFilePath1');"/>
							</td>
                        </tr>

                        <tr>
                            <td align="right">חלק תחתון<img src="images/ask22.png" id="Img2" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath3" name="Footer" <%If Editmode = "True" Then %> value="<% =objRs("Footer")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('xFilePath3');"/>
							</td>
                        </tr>
                        <tr>
					        <td align="right"><p>ברירת מחדל:</p><img src="images/ask22.png" id="east6" original-title="טקסט." /></td>
					        <td align="right"><input id="Defaultremplate"  type="checkbox" dir="ltr" name="Defaultremplate" value="1" <%If Editmode = "True" Then %><% If objRs("Defaultremplate")= True Then print " checked=""yes""" %><% End If %>" /></td>
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">תמונה</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">תמונה</td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" size="60" />
							<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
						<img src="images/ask22.png" id="east10" original-title="תופיע בהתאם לתבנית תצוגת התוכן" />
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