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
CheckSecuirty "Customformfields"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Customformfields] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Customformfields-Disposition", "attachment;filename=Customformfields-"&filedate&".xls"
        Response.CustomformfieldsType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Customformfields-Disposition", "attachment;filename=Customformfields-"&filedate&".doc"
        Response.CustomformfieldsType = "application/vnd.ms-word"
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

CheckSecuirty "Customformfields"
SQLn = "Select Name From Content where Id=" & Request.QueryString("formid")
Set objRsn = OpenDB(SQLn)
nName = objRsn("Name")
CloseDB(objRsn)
 %>   
    <div class="formtitle">
        <h1><a href="admin_customform.asp">ניהול טפסים</a> -- <%= nName %> -- ניהול שדות בטופס</h1>
		<div class="admintoolber">
		</div>
		<div class="adminicons">
			<p><a href="admin_Customformfields.asp?action=add&formid=<%=Request.Querystring("formid") %>"><img src="images/addnew.gif" border="0" alt="הוספת שדה" title="הוספת שדה" /></a></p>
	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th style="width:10%;" class="recordid">ID</th>
		<th style="width:40%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>סוג שדה</th>
        <th>נהל אפשרויות שדה</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM Customformfields WHERE CustomformID= " & Request.QueryString("FormId") & " AND SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM Customformfields WHERE CustomformID=" & Request.QueryString("FormId") & " AND SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
    End If
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין שדות ניתן להוסיף שדות"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
        fatherID =  objRs("Id")
Do While Not objRs.EOF And HowMany < objRs.PageSize
            	%>
    <tr>
        <td><%= objRs("Id")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Id") %>_Name"><% = objRs("Name") %></span></td>
		<td><% = objRs("Type") %></td>
        <td><a href="admin_Customformfieldsoptions.asp?fieldid=<% = objRs("Id") %>&formid=<%=request.querystring("formid")%>"><img src="images/edit.gif" border="0" alt="נהל רשומות" /></a></td>
        <td><a href="admin_Customformfields.asp?FormID=<%= request.querystring("FormId") %>&ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_Customformfields.asp?FormID=<%= request.querystring("FormId") %>&ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_Customformfields.asp?FormID=<%= request.querystring("FormId") %>&ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM Customformfields WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM Customformfields"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
				                objRs("Text") = Trim(Request.Form("Text"))
								objRs("value") = Request.Form("value")
								objRs("Type") = Request.Form("Type")
								objRs("Required") = Request.Form("Required")
								objRs("Width") = Request.Form("Width")
								objRs("Direction") = Request.Form("Direction")
								objRs("CustomformID") =  Request.QueryString("FormId")
								objRs.Update
								objRs.Close
                                    Response.Redirect("admin_Customformfields.asp?FormId=" & request.querystring("FormId") & "&notificate=שדה נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM Customformfields WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
                '    print Sql
                '    response.end
			            Set objRs = OpenDB(sql)
				                objRs("Name") = Trim(Request.Form("Name"))
				                objRs("Text") = Trim(Request.Form("Text"))
								objRs("value") = Request.Form("value")
								objRs("Type") = Request.Form("Type")
								objRs("Required") = Request.Form("Required")
								objRs("Width") = Request.Form("Width")
								objRs("Direction") = Request.Form("Direction")

								objRs.Update
								objRs.Close
                                    Response.Redirect("admin_Customformfields.asp?FormId=" & request.querystring("FormId") & "&notificate=שדה נערך בהצלחה")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM Customformfields WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
				                objRs("Text") = Trim(Request.Form("Text"))
								objRs("value") = Request.Form("value")
								objRs("Type") = Request.Form("Type")
								objRs("Required") = Request.Form("Required")
								objRs("Width") = Request.Form("Width")
								objRs("Direction") = Request.Form("Direction")
								objRs("CustomformID") =  Request.QueryString("FormId")
                                objRs.Update
								objRs.Close
                                    Response.Redirect("admin_Customformfields.asp?FormId=" & request.querystring("FormId") & "&notificate=שדה נוסף בהצלחה")

	        
	        Case "delete"
				    Sql = "SELECT * FROM Customformfields WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
                                    Response.Redirect("admin_Customformfields.asp?FormId=" & request.querystring("FormId") & "&notificate=שדה נערך בהצלחה")
	            End Select
		Else
				SQL = "SELECT * FROM Customformfields WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Customformfields WHERE SiteID=" & SiteID  
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
<form action="admin_Customformfields.asp?mode=doit&FormID=<%= request.querystring("FormId") %><%If Editmode = "True" then %>&ID=<% = objRs("Id")%><% End if %>&action=<%=Request.Querystring("action") %>" method="post" id="Customformfields2" name="Customformfields2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת שדה</h1>
				<% ELSE 
				%>
					<h1>עריכת שדה</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>כותרת שדה:</p><img src="images/ask22.png" id="east" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
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
					  <textarea name="value" cols="6" class="goodinputlong" style="width:100px;" ><%If Editmode = "True" Then print objRs("value") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>תיאור:</p><img src="images/ask22.png" id="Img6" original-title="דואל שישילחו פרטי הטופס לאחר מילוי" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Text" cols="6" class="goodinputlong" style="width:400px;height:100px;" ><%If Editmode = "True" Then print objRs("Text") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>סוג שדה:</p><img src="images/ask22.png" id="Img2" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					<select class="goodselectshort"  name="Type">
							<option value="text"<%If Editmode = "True" then %><% If objRs("Type")="text" Then Response.Write(" selected") End if %><%End If %>>שדה טקסט</option>
							<option value="texterea"<%If Editmode = "True" then %><% If objRs("Type")="texterea" Then Response.Write(" selected") End if %><%End If %>>טקסט חופשי</option>
							<option value="combo"<%If Editmode = "True" then %><% If objRs("Type")="combo" Then Response.Write(" selected") End if %><%End If %>>רשימה נפתחת</option>
							<option value="radio"<%If Editmode = "True" then %><% If objRs("Type")="radio" Then Response.Write(" selected") End if %><%End If %>>רדיו</option>
							<option value="checkbox"<%If Editmode = "True" then %><% If objRs("Type")="checkbox" Then Response.Write(" selected") End if %><%End If %>>תיבת סימון</option>
							<option value="image"<%If Editmode = "True" then %><% If objRs("Type")="image" Then Response.Write(" selected") End if %><%End If %>>העלאת תמונה</option>
							<option value="file"<%If Editmode = "True" then %><% If objRs("Type")="file" Then Response.Write(" selected") End if %><%End If %>>העלעת קובץ</option>
							<option value="freetext"<%If Editmode = "True" then %><% If objRs("Type")="freetext" Then Response.Write(" selected") End if %><%End If %>>שדה תיאור</option>
					</select>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>שדה נדרש:</p><img src="images/ask22.png" id="Img3" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					<select class="goodselectshort"  name="Required">
							<option value=""<%If Editmode = "True" then %><% If objRs("required")="text" Then Response.Write(" selected") End if %><%End If %>>לא חובה</option>
							<option value="required"<%If Editmode = "True" then %><% If objRs("required")="required" Then Response.Write(" selected") End if %><%End If %>>שדה חובה</option>
							<option value="required email"<%If Editmode = "True" then %><% If objRs("required")="required email" Then Response.Write(" selected") End if %><%End If %>>שדה חובה אימייל</option>
							<option value="required sellectone"<%If Editmode = "True" then %><% If objRs("required")="required sellectone" Then Response.Write(" selected") End if %><%End If %>>שדה חובה בחירה</option>
							<option value="required phone"<%If Editmode = "True" then %><% If objRs("required")="required phone" Then Response.Write(" selected") End if %><%End If %>>שדה חובה טלפון</option>
							<option value="required cellular"<%If Editmode = "True" then %><% If objRs("required")="required cellular" Then Response.Write(" selected") End if %><%End If %>>שדה חובה סלולאר</option>
					</select>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>רוחב:</p><img src="images/ask22.png" id="Img4" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Width" cols="3" class="goodinputshort" ><%If Editmode = "True" Then print objRs("Width") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>כיוון:</p><img src="images/ask22.png" id="Img5" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					<select class="goodselectshort"  name="Direction">
							<option value="ltr"<%If Editmode = "True" then %><% If objRs("Direction")="ltr" Then Response.Write(" selected") End if %><%End If %>>משמאל לימין</option>
							<option value="rtl"<%If Editmode = "True" then %><% If objRs("Direction")="rtl" Then Response.Write(" selected") End if %><%End If %>>מימין לשמאל</option>
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