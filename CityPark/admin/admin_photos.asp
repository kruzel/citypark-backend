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
CheckSecuirty "photos"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Photos] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
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
        <h1>ניהול תמונות</h1>
		<div class="admintoolber">
        <form action="admin_photos.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               	<% Set objRs = OpenDB("SELECT * FROM Content Where SiteID = " & SiteID)
                        If objRs.RecordCount > 0 then
						Set objRsCategory = OpenDB("SELECT * FROM Content Where SiteID = " & SiteID & " AND Contenttype=4")
					  
                    %>					  
				<select id="category" name="category" style="width:auto">
                	<%
                            Do While Not objRsCategory.EOF
					    
                        %>
						<option value="<% = objRsCategory("Id") %>" <% If Request.form("category")= "" Then%> <% If objRsCategory("Name") = "תוכן האתר" Then Response.Write(" selected") %><% Else %><% If int(objRsCategory("Id")) = int(Request.Form("category")) Then Response.Write(" selected") %><% End if %>><% = objRsCategory("Name") %></option>
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

               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_photos.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת תמונה" title="הוספת תמונה" /></a></p>
			<p><a href="admin_photos.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_photos.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_photos.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th>סדר מיון</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM photos WHERE SiteID=" & SiteID
     If Request.QueryString("mode") = "search" then
		        SQL = "SELECT * FROM photos WHERE SiteID=" & SiteID
            If Request.form("category") <> 0 Then
                SQL = SQL & " AND PhotosgalleryID = " & Request.form("category") 
            End If
            If Request.form("text") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("text") & "%'"
             End If
                SQL = SQL &  " ORDER By ItemOrder ASC"
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
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRs("Id") %>_Name"><% = objRs("Name") %></div></td>
        <td class="editlocal"><div class="inlinetext" id="<% = objRs("id") %>_Itemorder"><%= objRs("Itemorder") %></div>
        <td><a href="admin_photos.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_photos.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_photos.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			        Sql = "SELECT * FROM photos WHERE SiteID=" & SiteID
			        	Set objRs = OpenDB(sql)

						        objRs.Addnew
						        objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("PhotosgalleryID") = Request.Form("PhotosgalleryID")
								objRs("Description") = Request.Form("Description")
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Link") = Trim(Request.Form("Link"))
								objRs("Itemorder") = int(Request.Form("Itemorder"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>נוסף בהצלחה. <a href='admin_photos.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_photos.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM photos WHERE ID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
						        objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("PhotosgalleryID") = Request.Form("PhotosgalleryID")
								objRs("Description") = Request.Form("Description")
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Link") = Trim(Request.Form("Link"))
								objRs("Itemorder") = int(Request.Form("Itemorder"))
								
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>נערך בהצלחה. <a href='admin_photos.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_photos.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM photos WHERE ID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)

						        objRs.Addnew
						        objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("PhotosgalleryID") = Request.Form("PhotosgalleryID")
								objRs("Description") = Request.Form("Description")
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Link") = Trim(Request.Form("Link"))
								objRs("Itemorder") = int(Request.Form("Itemorder"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'> נוסף בהצלחה. <a href='admin_photos.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_photos.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    
                    Sql = "SELECT * FROM photos WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'נמחק בהצלחה. <a href='admin_photos.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_photos.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM photos WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM photos WHERE SiteID=" & SiteID   
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
<form action="admin_photos.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת תמונה</h1>
				<% ELSE 
				%>
					<h1>הוספת תמונה</h1>
				<% End If %>
				</div>
			    <div class="rightform">
				<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
                <tr>
				    <td width="20%" align="right">שם:</td>
					<td width="80%" align="right">
					    <textarea name="Name" cols="50" rows="1" class="goodinputlong required"><% If Editmode = "True" Then %><% = objRs("Name") %><% End If %></textarea>
					</td>
			    </tr>
                <tr>
					<td width="20%" align="right">גלרייה:</td>
					<td width="80%" align="right">
					<% Set objRsgallery = OpenDB("SELECT * FROM Content Where Contenttype=4 AND SiteID = " & SiteID)%>					  
					     <select name="PhotosgalleryID" class="goodselectshort">
					<%	Do While Not objRsgallery.EOF %>
						    <option value="<% = objRsgallery("ID") %>"<% If Editmode = "True" Then %> <% If objRsgallery("ID") = objRs("PhotosgalleryID") Then Response.Write(" selected") %><% End If %>><% = objRsgallery("Name") %></option>
					<%	objRsgallery.MoveNext 
                    		Loop%>
					</select>
					<% objRsgallery.Close %>
					</td>				
				</tr>
			    <tr>
				    <td width="20%" align="right">תמונה:</td>				
					<td width="80%" align="right">
					<input class="goodinputshort" id="xFilePath" name="Image" dir="ltr" <% If Editmode = "True" Then %>  value="<% =objRs("Image")%>" <% End If %>type="text" size="60" />
					<input class="goodinputbrows" type="button" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/><font size="2">
					</td>			      
			    </tr>
               	<tr>
				    <td width="20%" align="right">תאור:</td>				
					<td width="80%" align="right">
					<%      Dim oFCKeditor
                            Set oFCKeditor = New FCKeditor
                            oFCKeditor.BasePath = "FCKeditor/"
                            If Editmode = "True" Then
                                oFCKeditor.Value=objRs("Description")
                            End If
                            if request.querystring("block")<> "" Then  oFCKeditor.Value=request.querystring("block") end if
                            oFCKeditor.width="100%"
                            oFCKeditor.height="370px"
                            if Session("SiteLang") ="he-IL" Then
                                oFCKeditor.config("DefaultLanguage")= "he"
                                oFCKeditor.config("ContentLangDirection")= "rtl"
                            Else
                                oFCKeditor.config("DefaultLanguage")= "en"
                                oFCKeditor.config("ContentLangDirection")= "ltr"
                            End If
                                oFCKeditor.Create "Description" %>
                    </td>			      
			    </tr>	
				<tr>
					<td width="20%" align="right">קישור:</td>
					<td width="80%" align="right">
						<input class="goodinputlong" type="text" dir="ltr" name="Link" maxlength="100"<% If Editmode = "True" Then %> value="<% = objRs("Link") %>"<% End If %>><font size="2">
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