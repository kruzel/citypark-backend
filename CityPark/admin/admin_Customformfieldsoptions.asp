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
CheckSecuirty "Customformfieldsoptions"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Customformfieldsoptions] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Customformfieldsoptions-Disposition", "attachment;filename=Customformfieldsoptions-"&filedate&".xls"
        Response.CustomformfieldsoptionsType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Customformfieldsoptions-Disposition", "attachment;filename=Customformfieldsoptions-"&filedate&".doc"
        Response.CustomformfieldsoptionsType = "application/vnd.ms-word"
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

CheckSecuirty "Customformfieldsoptions"
SQLn = "Select Name From Customformfields where Id=" & Request.QueryString("fieldid")
Set objRsn = OpenDB(SQLn)
nName = objRsn("Name")
CloseDB(objRsn)
SQLo = "Select Name, id From Content where Id=" & Request.QueryString("formid")
Set objRso = OpenDB(SQLo)
xName = objRso("Name")
xurl = "admin_Customformfields.asp?formid=" & objRso("id")
CloseDB(objRso)
 %>   
    <div class="formtitle">
        <h1><a href="admin_customform.asp">ניהול טפסים</a> -- <a href="<%= xurl %>"><% = xName%> </a> -- <%= nName %>  -- אפשרויות שדה </h1>
		<div class="admintoolber">
		</div>
		<div class="adminicons">
			<p><a href="admin_Customformfieldsoptions.asp?action=add&fieldid=<%= request.querystring("fieldid") %>&formid=<%=Request.QueryString("formid")%>"><img src="images/addnew.gif" border="0" alt="הוספת שדה" title="הוספת שדה" /></a></p>
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
		SQL = "SELECT * FROM Customformfieldsoptions WHERE CustomformfieldsID= " & Request.QueryString("fieldid") & " AND SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM Customformfieldsoptions WHERE CustomformfieldsID=" & Request.QueryString("fieldid") & " AND SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
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
        <td><a href="admin_Customformfieldsoptions.asp?fieldid=<%= request.querystring("fieldid") %>&formid=<%=request.querystring("formid")%>&ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_Customformfieldsoptions.asp?fieldid=<%= request.querystring("fieldid") %>&formid=<%=request.querystring("formid")%>&ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_Customformfieldsoptions.asp?fieldid=<%= request.querystring("fieldid") %>&formid=<%=request.querystring("formid")%>&ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM Customformfieldsoptions WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM Customformfieldsoptions"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("value") = Request.Form("value")
								objRs("selected") = Request.Form("selected")
								objRs("CustomformfieldsID") = Request.Querystring("fieldid")				
								objRs.Update
								objRs.Close
                               
                                    Response.Redirect("admin_Customformfieldsoptions.asp?fieldid=" & request.querystring("fieldid") & "&formid=" & request.querystring("formid") & "&notificate=שדה נערך בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM Customformfieldsoptions WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
                   ' print Sql
                   ' response.end
			            Set objRs = OpenDB(sql)
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("value") = Request.Form("value")
								objRs("selected") = Request.Form("selected")
								objRs("CustomformfieldsID") = Request.Querystring("fieldid")				

								objRs.Update
								objRs.Close
                                    Response.Redirect("admin_Customformfieldsoptions.asp?fieldid=" & request.querystring("fieldid")& "&formid=" & Request.QueryString("formid") & "&notificate=שדה נערך בהצלחה")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM Customformfieldsoptions WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("value") = Request.Form("value")
								objRs("selected") = Request.Form("selected")
								objRs("CustomformfieldsID") = Request.Querystring("fieldid")				
                                objRs.Update
								objRs.Close
                                    Response.Redirect("admin_Customformfieldsoptions.asp?fieldid=" & request.querystring("fieldid")& "formid=" & Request.QueryString("formid") & "&notificate=שדה נערך בהצלחה")

	        
	        Case "delete"
				    Sql = "SELECT * FROM Customformfieldsoptions WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
                                    Response.Redirect("admin_Customformfieldsoptions.asp?FormId=" & request.querystring("FormId") & "&fieldid=" & request.querystring("fieldid") &" &notificate=שדה נערך בהצלחה")
	            End Select
		Else
				SQL = "SELECT * FROM Customformfieldsoptions WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Customformfieldsoptions WHERE SiteID=" & SiteID   
			End If
		'	print sql
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
<form action="admin_Customformfieldsoptions.asp?mode=doit&fieldid=<%= request.querystring("fieldid") %>&formid=<%=Request.QueryString("formid")%>&ID=<% = Request.Querystring("Id")%>&action=<%=Request.Querystring("action") %>" method="post" id="Customformfieldsoptions2" name="Customformfieldsoptions2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
				<% If  Request.QueryString("action") = "add" Then
				Editmode = "False"
				%>
					<h1>הוספת אפשרות שדה</h1>
				<% ELSE 
				Editmode = "True"
				%>
					<h1>עריכת אפשרות שדה</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם:</p><img src="images/ask22.png" id="east" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" ><%If Editmode = "True" Then print objRs("Name") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>ערך:</p><img src="images/ask22.png" id="Img1" original-title="דואל שישילחו פרטי הטופס לאחר מילוי" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="value" cols="3" class="goodinputlong required" ><%If Editmode = "True" Then print objRs("value") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>ברירת מחדל:</p><img src="images/ask22.png" id="Img2" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					<select class="goodselectshort"  name="selected">
							<option value="">ללא</option>
							<option value="selected"<% If Editmode = "True" Then %><% If objRs("selected")= "selected" Then Print " selected" End if %><% End if %>>ברירת מחדל</option>
					</select>
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">תמונה</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
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