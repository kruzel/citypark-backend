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
CheckSecuirty "banners"
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

CheckSecuirty "banners"
 %>   
    <div class="formtitle">
        <h1>ניהול באנרים</h1>
		<div class="admintoolber">
        <form action="admin_banners.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_banners.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_banners.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_banners.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_banners.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th>צפיות</th>
        <th>לחיצות</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM banners WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM banners WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
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
        <td><% = objRs("Shows") %></td>
        <td><% = objRs("Count") %></td>
        <td><a href="admin_banners.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_banners.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_banners.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			        Sql = "SELECT * FROM banners WHERE SiteID=" & SiteID
			        	Set objRs = OpenDB(sql)

						        objRs.Addnew
						        objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("bannerscategoryID") = Request.Form("bannerscategoryID")
								objRs("Type") = Int(Request.Form("Type"))
								objRs("Src") = Trim(Request.Form("Src"))
								objRs("Video") = Trim(Request.Form("Video"))
								objRs("Html") = Trim(Request.Form("Html"))
								objRs("Link") = Trim(Request.Form("Link"))
								objRs("target") = Trim(Request.Form("target"))
								objRs("Count") = 0
								objRs("Shows") = 0
								If Request.Form("startdate")<> "" Then
								objRs("startdate") = Request.Form("startdate")
								End If
								If Request.Form("enddate")<> "" Then
								objRs("enddate") = Request.Form("enddate")
								End If
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>נוסף בהצלחה. <a href='admin_banners.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_banners.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM banners WHERE ID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
						        objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("bannerscategoryID") = Request.Form("bannerscategoryID")
								objRs("Type") = Int(Request.Form("Type"))
								objRs("Src") = Trim(Request.Form("Src"))
								objRs("Video") = Trim(Request.Form("Video"))
								objRs("Html") = Trim(Request.Form("Html"))
								objRs("Link") = Trim(Request.Form("Link"))
								objRs("target") = Trim(Request.Form("target"))
								
                                If Request.Form("startdate")<> "" Then
								objRs("startdate") = Request.Form("startdate")
								End If
								If Request.Form("enddate")<> "" Then
								objRs("enddate") = Request.Form("enddate")
								End If
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>נערך בהצלחה. <a href='admin_banners.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_banners.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM banners WHERE ID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
						        objRs.Addnew
						        objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("bannerscategoryID") = Request.Form("bannerscategoryID")
								objRs("Type") = Int(Request.Form("Type"))
								objRs("Src") = Trim(Request.Form("Src"))
								objRs("Video") = Trim(Request.Form("Video"))
								objRs("Html") = Trim(Request.Form("Html"))
								objRs("Link") = Trim(Request.Form("Link"))
								objRs("target") = Trim(Request.Form("target"))
								objRs("Count") = 0
								objRs("Shows") = 0
								If Request.Form("startdate")<> "" Then
								objRs("startdate") = Request.Form("startdate")
								End If
								If Request.Form("enddate")<> "" Then
								objRs("enddate") = Request.Form("enddate")
								End If
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'> נוסף בהצלחה. <a href='admin_banners.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_banners.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    
                    Sql = "SELECT * FROM banners WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'נמחק בהצלחה. <a href='admin_banners.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_banners.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM banners WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM banners WHERE SiteID=" & SiteID   
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
<form action="admin_banners.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
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
				    <td valign="top" width="20%" align="right">שם:</td>
					<td width="80%" align="right">
					    <textarea name="Name" cols="50" rows="1" class="required goodinputshort"><% If Editmode = "True" Then %><% = objRs("Name") %><% End If %></textarea>
					</td>
			    </tr>
                <tr>
					<td width="20%" align="right">קמפיין:</td>
					<td width="80%" align="right">
					<% Set objRsbannercategory = OpenDB("SELECT * FROM bannerscategory Where SiteID = " & SiteID)%>					  
					     <select  name="bannerscategoryID" class="goodselect">
					<%	Do While Not objRsbannercategory.EOF %>
						    <option value="<% = objRsbannercategory("ID") %>"<% If Editmode = "True" Then %> <% If objRsbannercategory("ID") = objRs("bannerscategoryID") Then Response.Write(" selected") %><% End If %>><% = objRsbannercategory("Name") %></option>
					<%	objRsbannercategory.MoveNext 
                    		Loop%>
					</select>
					<% objRsbannercategory.Close %>
					</td>				
				</tr>
				<tr>
					<td width="20%" align="right">סוג מדיה:</td>
					<td width="80%" align="right">
					<select  name="Type" class="goodselect">
					<option value="1"<% If Editmode = "True" Then %><% if objRS("Type")= 1 then Response.Write(" selected")  %><% End If %>>תמונה</option>
					<option value="2"<% If Editmode = "True" Then %><% if objRS("Type")= 2 then Response.Write(" selected")  %><% End If %>>FLASH סרטון</option>
					<option value="3"<% If Editmode = "True" Then %><% if objRS("Type")= 3 then Response.Write(" selected")  %><% End If %>>HTML קוד</option>
					<option value="4"<% If Editmode = "True" Then %><% if objRS("Type")= 4 then Response.Write(" selected")  %><% End If %>>פלאש עם קישור</option>
					</select>
					</td>				
				</tr>
			    <tr>
				    <td width="20%" align="right">תמונה:</td>				
					<td width="80%" align="right">
					<input class="goodinputshort" id="xFilePath" name="Src" dir="ltr" <% If Editmode = "True" Then %>  value="<% =objRs("Src")%>" <% End If %>type="text" size="60" />
					<input class="goodinputbrows" type="button" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/><font size="2">
					</td>			      
			    </tr>
                <tr>
                    <td align="right" colspan="4">במידה ובוחרים פלאש או HTML יש להוסיף קישור בפורמט: redirect.asp?ID=id&target=target</td>
                </tr>
                <tr>
				    <td width="20%" align="right">קובץ פלאש:</td>				
					<td width="80%" align="right">
					    <input class="goodinputshort" id="xFilePath2" name="Video" dir="ltr" <% If Editmode = "True" Then %>  value="<% =objRs("Video")%>" <% End If %>type="text" size="60" />
					    <input class="goodinputbrows" type="button" value="חפש בשרת" onclick="BrowseVideo('xFilePath2');"/><font size="2">
					</td>			      
			    </tr>
               	<tr>
				    <td width="20%" align="right">קובץ Html:</td>				
					<td width="80%" align="right">
					<textarea style="direction:ltr;" name="html" id="html" class="goodinputlongbig"><% If Editmode = "True" Then %><% = objRs("html") %><% End If %></textarea>
					
                    </td>			      
			    </tr>	
				<tr>
					<td width="20%" align="right">קישור:</td>
					<td width="80%" align="right">
						<input class="goodinputlong" type="text" dir="ltr" name="Link" size="50" maxlength="100"<% If Editmode = "True" Then %> value="<% = objRs("Link") %>"<% End If %>><font size="2">
					</td>
			    </tr>
			    <tr>
					<td width="20%" align="right">יעד:</td>
                    <td width="80%" align="right">
                    <select  name="target" class="goodselect">
					    <option value="_self"<% If Editmode = "True" Then %><% if objRS("target")= "_self" then Response.Write(" selected")  %><% End If %>>אותו הדף</option>
					    <option value="_blank"<% If Editmode = "True" Then %><% if objRS("target")= "_blank" then Response.Write(" selected")  %><% End If %>>דף חדש</option>
					</select>
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">תאריכי פרסום הבאנר</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                       			      <tr>			
					<td valign="top" align="right">מ-תאריך</td>
					<td valign="top" align="right">
					  <input type="text" dir="ltr" name="startdate" class="_date goodinputshort" <%If Editmode = "True" Then %> value="<% = objRs("startdate") %>" <% End if %> size="10" maxlength="100"></td>			 
			        </tr>
					<td valign="top" align="right">
					  <span lang="he"><font face="Arial" size="2">עד-תאריך</font></span></td>
					<td valign="top" height="20" align="right">
					  <font face="Arial">
					  <input type="text" dir="ltr" name="enddate" <%If Editmode = "True" Then %>value="<% = objRs("enddate") %>"<% End if %> class="_date goodinputshort" size="10" maxlength="100" 
                            style="margin-left: 183px"></font></td>
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