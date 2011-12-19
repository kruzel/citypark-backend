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
<script type='text/javascript'>
    $(function () {
        $('#east').tipsy({ html: true });
        $('#east2').tipsy({ html: true });
        $('#east3').tipsy({ html: true });
    });
</script>
 <script type="text/javascript">
     jQuery(document).ready(function () {
         jQuery("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });
     });
</script>

<%

CheckSecuirty "Cal"
    if request("inline") = "true" Then
        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Cal] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if

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

CheckSecuirty "Cal"
 %>   
    <div class="formtitle">
        <h1>ניהול יומנים</h1>
		<div class="admintoolber">
		</div>
		<div class="adminicons">
			<p><a href="admin_cal.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_cal.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th style="width:8%;" class="recordid">ID</th>
		<th style="width:36%;text-align:right;padding-right:40px;cursor:pointer;">שם</th>
		<th style="width:8%;">ערוך</th>
        <th style="width:8%;">מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
               SQL = "SELECT * FROM [Cal]  WHERE SiteID=" & SiteID & "  ORDER By Id DESC"
       
   '  print sql
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	            objRsg.PageSize = Session("records")
                HowMany = 0
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize

            	%>
    <tr>
        <td><%= objRsg("Id")  %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("Id") %>_Name"><% = objRsg("Name") %></div></td>
        <td><a href="admin_cal.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_cal.asp?ID=<% = objRsg("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
    </tr>	
 <%		
                
                 HowMany = HowMany + 1
                objRsg.MoveNext
		  		Loop
                objRsg.Close
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
			        Sql = "SELECT * FROM Cal WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Request.Form("Name")
                                objRs.Update
									Response.Redirect("admin_cal.asp?notificate=יומן נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"
				    Sql = "SELECT * FROM Cal WHERE Id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)

				                objRs("Name") = Request.Form("Name")
                                objRs.Update

					 Response.Redirect("admin_cal.asp?notificate=יומן נערך בהצלחה")

	        Case "delete"
				    Sql = "SELECT * FROM Cal WHERE Id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Redirect("admin_cal.asp?notificate=יומן נמחק בהצלחה")

	            End Select
		Else
			If  Request.QueryString("action") ="edit" OR  Request.QueryString("action") ="copy" Then
                SQL = "SELECT * FROM Cal WHERE Id=" & Request.QueryString("ID") & " And SiteID=" & SiteID
            End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Cal WHERE SiteID=" & SiteID   
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

 
<form action="admin_cal.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת יומן</h1>
				<% ELSE 
				%>
					<h1>עריכת יומן</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform"  dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם יומן:</p></td>
						<td width="80%" align="right" colspan="5">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" onkeyup ="Menusname.value = this.value;urltext.value = this.value;title.value = this.value;return true;"><%If Editmode = "True" Then print objRs("Name") End If %><% if request.querystring("Name")<> "" Then print request.querystring("Name") end if%></textarea>
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
				<h3><a style="background:url(images/link_img.png) no-repeat right;" href="#">יצירת כפתור לדף</a></h3>
			        <div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
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