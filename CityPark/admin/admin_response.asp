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
CheckSecuirty "response"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [response] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "response-Disposition", "attachment;filename=response-"&filedate&".xls"
        Response.responseType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "response-Disposition", "attachment;filename=response-"&filedate&".doc"
        Response.responseType = "application/vnd.ms-word"
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

CheckSecuirty "response"
 %>   
    <div class="formtitle">
        <h1>ניהול תגובות</h1>
		<div class="admintoolber">
        <form action="admin_response.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_response.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_response.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_response.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_response.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th>פעיל</th>
        <th>ערוך</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM response WHERE SiteID=" & SiteID 
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM response WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
    End If
    SQL = SQL & " ORDER BY Id DESC"
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
        <td><% If objRs("Active")= 1 Then %><img style="border:0px;" src="images/active.png" border="0" alt="" /><% Else %><img style="border:0px;" src="images/notactive.png" border="0" alt="" /><% End if %></td>
        <td><a href="admin_response.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td style="border-left:0px;"><a href="admin_response.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM response WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM response"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("Text") = Request.Form("Text")
								objRs("Email") = Request.Form("Email")
								objRs("ContentId") = Request.Form("ContentId")
								objRs("AuthorName") = Request.Form("AuthorName")
								If Request.Form("Active")<> 1 Then
								    objRs("Active") = 0
								Else
								    objRs("Active") = 1
								 End If

								objRs.Update
								objRs.Close
						                 Response.Redirect("admin_response.asp?notificate=תגובה נוספה בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM response WHERE ID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("Text") = Request.Form("Text")
								objRs("Email") = Request.Form("Email")
								objRs("ContentId") = Request.Form("ContentId")
								objRs("AuthorName") = Request.Form("AuthorName")
								If Request.Form("Active")<> 1 Then
								    objRs("Active") = 0
								Else
								    objRs("Active") = 1
								 End If
								objRs.Update
								objRs.Close
						                 Response.Redirect("admin_response.asp?notificate=תגובה נערכה בהצלחה")
	        
	        Case "delete"
				    Sql = "SELECT * FROM response WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						                 Response.Redirect("admin_response.asp?notificate=תגובה נמחקה בהצלחה")
	            End Select
		Else
				SQL = "SELECT * FROM response WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM response WHERE SiteID=" & SiteID   
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
<form action="admin_response.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="response2" name="response2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת תגובה</h1>
				<% ELSE 
				%>
					<h1>עריכת תגובה</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>כותרת:</p><img src="images/ask22.png" id="east" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right"><input class="goodinputshort" id="Name"  type="text" name="Name" <%If Editmode = "True" Then %> value="<% = objRs("Name") %><% end if %>" /></td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>שם כותב:</p><img src="images/ask22.png" id="Img1" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right"><input class="goodinputshort" id="Authorname"  type="text" name="Authorname" <%If Editmode = "True" Then %> value="<% = objRs("Authorname") %><% end if %>" /></td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>Email:</p><img src="images/ask22.png" id="Img2" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right"><input class="goodinputshort" id="Email"  type="text" name="Email" <%If Editmode = "True" Then %> value="<% = objRs("Email") %><% end if %>" /></td>
					</tr>
                    <tr>
				    <td width="20%" align="right">כתבה:</td>
					<td valign="middle" width="72%">
   					<select class="goodselect" name="ContentID">
						<% Set objRsNews = OpenDB("SELECT id, Name FROM Content WHERE Contenttype != 3 AND SiteID= " & SiteID)						  
					       Do While Not objRsNews.EOF %>											    
							<option value="<% =objRsNews("id")%>"<% If objRs("ContentID") = objRsNews("id") Then Response.Write(" selected") %> ><% = objRsNews("Name") %></option>
						<%	objRsNews.MoveNext 
								Loop
							objRsNews.Close	%>
					</select>
					</td>
				  </tr>
                  <tr>
					 <td align="right"><p>מופיע באתר:</p><img src="images/ask22.png" id="east6" original-title="חייב להיות פעיל כדי להופיע באתר." /></td>
					 <td align="right"><input id="Active"  type="checkbox" dir="ltr" name="Active" value="1" <%If Editmode = "True" Then %><% If objRs("Active")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					</td>
				   </tr>

					<tr>
                        <td align="right">תגובה:</td>
                        <td align="right"><textarea rows="3" name="Text" cols="10" class="goodinputlongbig" wrap="soft"><% If Editmode = "True" Then print objRs("Text") End If %></textarea></td>
                        
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