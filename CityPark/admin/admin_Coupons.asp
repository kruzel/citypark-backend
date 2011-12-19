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
CheckSecuirty "Coupons"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Coupons] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Coupons-Disposition", "attachment;filename=Coupons-"&filedate&".xls"
        Response.CouponsType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Coupons-Disposition", "attachment;filename=Coupons-"&filedate&".doc"
        Response.CouponsType = "application/vnd.ms-word"
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

CheckSecuirty "Coupons"
 %>   
    <div class="formtitle">
        <h1>ניהול קופונים</h1>
		<div class="admintoolber">
		</div>
		<div class="adminicons">
			<p><a href="admin_Coupons.asp?action=add&formid=<%=Request.Querystring("formid") %>"><img src="images/addnew.gif" border="0" alt="הוספת שדה" title="הוספת שדה" /></a></p>
	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th style="width:10%;" class="recordid">ID</th>
		<th style="width:40%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>קוד קופון</th>
        <th>כמות</th>
        <th>השתמשו</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM Coupons WHERE  SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM Coupons WHERE  SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
    End If
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין קופונים"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
        fatherID =  objRs("Id")
Do While Not objRs.EOF And HowMany < objRs.PageSize
            	%>
    <tr>
        <td><%= objRs("Id")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Id") %>_Name"><% = objRs("Name") %></span></td>
		<td><% = objRs("Code") %></td>
		<td><% = objRs("Qty") %></td>
		<td><% = objRs("Used") %></td>
        <td><a href="admin_Coupons.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_Coupons.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_Coupons.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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

			        Sql = "SELECT * FROM Coupons"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("Qty") = Request.Form("Qty")
								objRs("Startdate") = Request.Form("Startdate")
								objRs("Enddate") = Request.Form("Enddate")
								objRs("Discount") = Request.Form("Discount")
                                objRs.Update
								objRs.Close
			      Set objRs = OpenDB("SELECT Top 1 code,id FROM Coupons WHERE SiteID=" & SiteID & " order by Id desc")
								objRs("Code") = Left(Md5(objRs("Id")),6)
                                objRs.Update
								objRs.Close

                                    Response.Redirect("admin_Coupons.asp?notificate=קופון נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM Coupons WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
                '    print Sql
                '    response.end
			            Set objRs = OpenDB(sql)
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("Qty") = Request.Form("Qty")
								objRs("Startdate") = Request.Form("Startdate")
								objRs("Enddate") = Request.Form("Enddate")
								objRs("Discount") = Request.Form("Discount")

								objRs.Update
								objRs.Close
                                    Response.Redirect("admin_Coupons.asp?notificate=קופון נערך בהצלחה")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM Coupons WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("Qty") = Request.Form("Qty")
								objRs("Startdate") = Request.Form("Startdate")
								objRs("Enddate") = Request.Form("Enddate")
								objRs("Discount") = Request.Form("Discount")
                                objRs.Update
								objRs.Close
			      Set objRs = OpenDB("SELECT Top 1 code,id FROM Coupons WHERE SiteID=" & SiteID & " order by Id desc")
								objRs("Code") = Left(Md5(objRs("Id")),6)
                                objRs.Update
								objRs.Close
                                    Response.Redirect("admin_Coupons.asp?notificate=קופון נוסף בהצלחה")

	        
	        Case "delete"
				    Sql = "SELECT * FROM Coupons WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
                                    Response.Redirect("admin_Coupons.asp?notificate=קופון נמחק בהצלחה")
	            End Select
		Else
				SQL = "SELECT * FROM Coupons WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Coupons WHERE SiteID=" & SiteID  
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
<form action="admin_Coupons.asp?mode=doit<%If Editmode = "True" then %>&ID=<% = objRs("Id")%><% End if %>&action=<%=Request.Querystring("action") %>" method="post" id="Coupons2" name="Coupons2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת קופון</h1>
				<% ELSE 
				%>
					<h1>עריכת קופון</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם:</p><img src="images/ask22.png" id="east" original-title="שם תשובה משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" style="width:200px;" ><%If Editmode = "True" Then print objRs("Name") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>כמות מכסימאלית:</p><img src="images/ask22.png" id="Img6" original-title="דואל שישילחו פרטי הטופס לאחר מילוי" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Qty" cols="6" class="goodinputlong" style="width:100px;" ><%If Editmode = "True" Then print objRs("Qty") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>אחוז הנחה:</p><img src="images/ask22.png" id="Img1" original-title="דואל שישילחו פרטי הטופס לאחר מילוי" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Discount" cols="6" class="goodinputlong" style="width:60px;direction:ltr;" ><%If Editmode = "True" Then print objRs("Discount") End If %></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>מתאריך:</p><img src="images/ask22.png" id="Img4" original-title="דואל שישילחו פרטי הטופס לאחר מילוי" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <input type="text" name="Startdate" style="width:100px;" class="_date goodinputshort"<%If Editmode = "True" Then%> value=<%= objRs("Startdate")%> <% End If %> />
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>עד תאריך:</p><img src="images/ask22.png" id="Img2" original-title="דואל שישילחו פרטי הטופס לאחר מילוי" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <input type="text" name="Enddate" style="width:100px;" class="_date goodinputshort"<%If Editmode = "True" Then%> value=<%= objRs("Enddate")%> <% End If %> />
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#"></a></h3>
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