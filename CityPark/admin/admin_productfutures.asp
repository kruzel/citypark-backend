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
Function bringcat(id)
sqlf = "select * from ProductFeaturesGroup Where ProductFeaturesGroupID=" & id
set objRsf=openDB(sqlf)
bringcat = objRsf("ProductFeaturesGroupName")
CloseDB(objRsf)
End Function

CheckSecuirty "ProductFeatures"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [ProductFeatures] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
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
	Session("records") = 1000
	Else 
	Session("records") = Request.QueryString("records")
	End If

CheckSecuirty "ProductFeatures"
 %>   
    <div class="formtitle">
        <h1>ניהול מאפיינים</h1>
		<div class="admintoolber">
        <form action="admin_productfutures.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <% Set objRs = OpenDB("SELECT * FROM ProductFeatures Where SiteID = " & SiteID)
                  If objRs.RecordCount > 0 then
				Set objRsCategory = OpenDB("SELECT * FROM ProductFeaturesGroup Where SiteID = " & SiteID)
               %>					  
				<select id="category" name="category" style="width:200px;">
						<option value="*">הכל</option>
						<option value="0" <% If objRsCategory("ProductFeaturesGroupID") = "עמוד אב" Then Response.Write(" selected") %>>עמוד אב</option>
                	<%
                            Do While Not objRsCategory.EOF
					    
                        %>
						<option value="<% = objRsCategory("ProductFeaturesGroupID") %>"<% If objRsCategory("ProductFeaturesGroupID") = Request.querystring("category") Then Response.Write(" selected") %>><% = objRsCategory("ProductFeaturesGroupName") %></option>
					<%
                    objRsCategory.MoveNext 
					Loop
					%>
			</select>
					<% 
					objRsCategory.Close
					End if
                    CloseDB(objRs)
					%>

               <input type="text" dir="rtl" name="text" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_productfutures.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_productfutures.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_productfutures.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_productfutures.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th style="width:5%;" class="recordid">ID</th>
		<th style="width:40%;text-align:right;padding:0 10px 0 0">שם</th>
		<th style="width:15%;text-align:right;padding:0 10px 0 0">קבוצת מאפיינים</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM ProductFeatures WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM ProductFeatures WHERE "
        SQL = SQL & "(SiteID=" & SiteID & ") "
           If Request.form("category") <> "*" then
                SQL = SQL & " AND (ProductFeaturesGroupID = " & Request.form("category") & ")"
            end If
            If Request.form("text") <> "" Then
                SQL = SQL & " AND ProductFeaturesName LIKE '%" & Request.form("text") & "%'"
             End If
    End If
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין רשומות"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
Do While Not objRs.EOF And HowMany < objRs.PageSize
            	%>
    <tr>
        <td><%= objRs("ProductFeaturesID")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("ProductFeaturesID") %>_Name"><% = objRs("ProductFeaturesName") %></span></td>
        <td><%= bringcat(objRs("ProductFeaturesGroupID"))  %></td>
        <td><a href="admin_productfutures.asp?ID=<% = objRs("ProductFeaturesID") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_productfutures.asp?ID=<% = objRs("ProductFeaturesID") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_productfutures.asp?ID=<% = objRs("ProductFeaturesID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM ProductFeatures WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM ProductFeatures"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("ProductFeaturesName") = (Request.Form("ProductFeaturesName"))
								objRs("ProductFeaturesGroupID") = Request.Form("ProductFeaturesGroupID")
								objRs("ProductFeaturesPrice") = Request.Form("ProductFeaturesPrice")
								objRs("ProductFeaturesImage") = Request.Form("ProductFeaturesImage")
								objRs.Update
								objRs.Close
									Response.Redirect("admin_productfutures.asp?notificate=מאפיין נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM ProductFeatures WHERE ProductFeaturesID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
				                objRs("ProductFeaturesName") = Trim(Request.Form("ProductFeaturesName"))
								objRs("ProductFeaturesGroupID") = Request.Form("ProductFeaturesGroupID")
								objRs("ProductFeaturesPrice") = Request.Form("ProductFeaturesPrice")
								objRs("ProductFeaturesImage") = Request.Form("ProductFeaturesImage")
								objRs.Update
								objRs.Close
									Response.Redirect("admin_productfutures.asp?notificate=מאפיין נערך בהצלחה")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM ProductFeatures WHERE ProductFeaturesID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("ProductFeaturesName") = Trim(Request.Form("ProductFeaturesName"))
								objRs("ProductFeaturesGroupID") = Request.Form("ProductFeaturesGroupID")
								objRs("ProductFeaturesPrice") = Request.Form("ProductFeaturesPrice")
								objRs("ProductFeaturesImage") = Request.Form("ProductFeaturesImage")
								objRs.Update
								objRs.Close
									Response.Redirect("admin_productfutures.asp?notificate=מאפיין נוסף בהצלחה")

	        
	        Case "delete"
				    Sql = "SELECT * FROM ProductFeatures WHERE ProductFeaturesID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
									Response.Redirect("admin_productfutures.asp?notificate=מאפיין נמחק בהצלחה")
	            End Select
		Else
				SQL = "SELECT * FROM ProductFeatures WHERE ProductFeaturesID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM ProductFeatures WHERE SiteID=" & SiteID   
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
<form action="admin_productfutures.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("ProductFeaturesID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת מאפיין</h1>
				<% ELSE 
				%>
					<h1>עריכת מאפיין</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם מאפיין:</p><img src="images/ask22.png" id="east" original-title="שם המאפיין משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="ProductFeaturesName" cols="3" class="goodinputlong required"><%If Editmode = "True" Then print objRs("ProductFeaturesName")%></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
                        <td width="20%" align="right">סוג מאפיין:</td>
                        <td width="80%" align="right">
                        <select class="goodselect" name="ProductFeaturesGroupID">
                        <% SQL = "SELECT * FROM ProductFeaturesGroup WHERE SiteID=" & SiteID
                        Set objRscat = OpenDB(SQL)
                        Do While NOT objRscat.EOF                         %>
                            <option value="<% = objRscat("ProductFeaturesGroupID") %>"<% If objRscat("ProductFeaturesGroupID") = objRs("ProductFeaturesGroupID") Then Response.Write(" selected")%>><% = objRscat("ProductFeaturesGroupName") %> </option>
                        <% objRscat.movenext
                        loop
                        CloseDB(objRscat) %>
                         </select>
						</td>
					</tr>
                    <tr>
                    <td width="20%" align="right">מחיר</td>
                    <td align="right" valign="top"><input  type="text"  name="ProductFeaturesPrice" cols="40"<%If Editmode = "True"  Then%> value="<%= objRs("ProductFeaturesPrice")%>"<% Else %>value="0"<% End if %> /></td>
                    </tr>
                    <tr>
                            <td align="right">תמונה</td>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="ProductFeaturesImage" name="ProductFeaturesImage" <%If Editmode = "True" Then %> value="<% =objRs("ProductFeaturesImage")%>"<%End If %> type="text" size="60" />
							<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseServer('ProductFeaturesImage');"/>
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