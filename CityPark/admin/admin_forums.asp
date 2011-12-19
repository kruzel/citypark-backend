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
CheckSecuirty "forums"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [forums] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "forums-Disposition", "attachment;filename=forums-"&filedate&".xls"
        Response.forumsType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "forums-Disposition", "attachment;filename=forums-"&filedate&".doc"
        Response.forumsType = "application/vnd.ms-word"
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

CheckSecuirty "forums"
 %>   
    <div class="formtitle">
        <h1>ניהול פורומים</h1>
		<div class="admintoolber">
        <form action="admin_forums.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_forums.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת פורום" title="הוספת פורום" /></a></p>
			<p><a href="admin_forums.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_forums.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_forums.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM forums WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM forums WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
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
        <td><a href="admin_forums.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_forums.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_forums.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM forums WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM forums"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
					        objRs("Name") = Trim(Request.Form("Name"))
					        objRs("Text") = Request.Form("Text")
					        objRs("Image") = Request.Form("Image")
					        objRs("WriteAccessLevel") = CInt(Request.Form("WriteAccessLevel"))
					        objRs("ReadAccessLevel") = CInt(Request.Form("ReadAccessLevel"))
					        objRs("Title") = Request.Form("Title")
					        objRs("Keywords") = Request.Form("Keywords")
					        objRs("Description") = Request.Form("Description")
					        objRs("AutoInsert") = CInt(Request.Form("AutoInsert"))
	  				        objRs("EnableAgree") = CInt(Request.Form("EnableAgree"))
	  				        objRs("LangID") = Request.Form("lang")
	  				        objRs("forumemail") = Request.Form("forumemail")
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>פורום נוסף בהצלחה. <a href='admin_forums.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_forums.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM forums WHERE ID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
					        objRs("Text") = Request.Form("Text")
					        objRs("Image") = Request.Form("Image")
					        objRs("Text") = Request.Form("Text")
					        objRs("WriteAccessLevel") = CInt(Request.Form("WriteAccessLevel"))
					        objRs("ReadAccessLevel") = CInt(Request.Form("ReadAccessLevel"))
					        objRs("Title") = Request.Form("Title")
					        objRs("Keywords") = Request.Form("Keywords")
					        objRs("Description") = Request.Form("Description")
					        objRs("AutoInsert") = CInt(Request.Form("AutoInsert"))
	  				        objRs("EnableAgree") = CInt(Request.Form("EnableAgree"))
	  				        objRs("LangID") = Request.Form("lang")
	  				        objRs("forumemail") = Request.Form("forumemail")
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>פורום נערך בהצלחה. <a href='admin_forums.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_forums.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM forums WHERE ID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
					        objRs("Name") = Trim(Request.Form("Name"))
					        objRs("Text") = Request.Form("Text")
					        objRs("Image") = Request.Form("Image")
					        objRs("WriteAccessLevel") = CInt(Request.Form("WriteAccessLevel"))
					        objRs("ReadAccessLevel") = CInt(Request.Form("ReadAccessLevel"))
					        objRs("Title") = Request.Form("Title")
					        objRs("Keywords") = Request.Form("Keywords")
					        objRs("Description") = Request.Form("Description")
					        objRs("AutoInsert") = CInt(Request.Form("AutoInsert"))
	  				        objRs("EnableAgree") = CInt(Request.Form("EnableAgree"))
	  				        objRs("LangID") = Request.Form("lang")
	  				        objRs("forumemail") = Request.Form("forumemail")
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>פורום נוסף בהצלחה. <a href='admin_forums.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_forums.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    Sql = "SELECT * FROM forums WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>פורום נמחק בהצלחה. <a href='admin_forums.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' Content='0; URL=admin_forums.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM forums WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM forums WHERE SiteID=" & SiteID   
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
<form action="admin_forums.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="forums2" name="forums2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת פורום</h1>
				<% ELSE 
				%>
					<h1>עריכת פורום</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="30%" align="right"><p>כותרת הפורום:</p><img src="images/ask22.png" id="east" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
						<td width="70%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" ><%If Editmode = "True" Then print objRs("Name") End If %><% if request.querystring("name")<> "" Then print request.querystring("name") end if%></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="30%" align="right"><p>הקדמה/תיאור:</p><img src="images/ask22.png" id="Img1" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
					</tr>
					<tr>
                        <td colspan="2" align="right">
						<%
	Dim oFCKeditor
	Set oFCKeditor = New FCKeditor
	oFCKeditor.BasePath = "FCKeditor/"
	If Editmode = "True" Then
		oFCKeditor.Value=objRs("Text")
	End If
	'if request.querystring("forums")<> "" Then  oFCKeditor.Value=request.querystring("forums") end if
	oFCKeditor.width="100%"
	oFCKeditor.height="370px"
	if Session("SiteLang") = "he-IL" Then
	oFCKeditor.config("DefaultLanguage")= "he"
	oFCKeditor.config("forumsLangDirection")= "rtl"
	Else
	oFCKeditor.config("DefaultLanguage")= "en"
	oFCKeditor.config("forumsLangDirection")= "ltr"
	End If
	oFCKeditor.Create "Text"

	%>

						</td>
					</tr>
                                     <tr>
						<td width="30%" align="right"><p>כותרת העמוד (Title):</p><img src="images/ask22.png" id="Img2" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
                         <td align="right"><textarea name="Title" cols="3" style="width:80%; height: 20px; font-family:Arial;"><%If Editmode = "True" Then %><%= objRs("Title") %><% End if %></textarea> </td>
                        </tr>
                        <tr>
						<td width="30%" align="right"><p>תיאור (Description):</p><img src="images/ask22.png" id="Img3" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
                            <td align="right"><textarea rows="3" name="Description" cols="10" style="width:80%;" class="" onKeyDown="formTextCounter(this.form.Description,this.form.remLen_Description,200);" onKeyUp="formTextCounter(this,$('remLen_Description'),200);" wrap="soft"><%If Editmode = "True" Then %><%= objRs("Description")  %><% End if %></textarea><br><input readonly="readonly" type="text" name="remLen_Description" size="1" maxlength="3" value="200"></td>
                        </tr>
                        <tr>
						<td width="30%" align="right"><p>מילות מפתח (KeyWords):</p><img src="images/ask22.png" id="Img4" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
                            <td align="right"><textarea rows="3" name="Keywords" cols="10" style="width:80%;" class="" onKeyDown="formTextCounter(this.form.Keywords,this.form.remLen_Keywords,200);" onKeyUp="formTextCounter(this,$('remLen_Keywords'),200);" wrap="soft"><%If Editmode = "True" Then %><%= objRs("Keywords") %><% End if %></textarea><br><input readonly="readonly" type="text" name="remLen_Keywords" size="1" maxlength="3" value="200"></td>
                        </tr>

			      <tr>
						<td width="30%" align="right"><p>הודעה בפורום מופיעה באתר ללא אישור?::</p><img src="images/ask22.png" id="Img5" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
			        <td valign="top" height="20" align="right">				  					  
					  <select name="AutoInsert">
					    <option value="0" <%If Editmode = "True" Then %><% If objRs("AutoInsert") = "0" Then Response.Write(" selected") %><% End if %>>לא</option>
					    <option value="1" <%If Editmode = "True" Then %><% If objRs("AutoInsert") = "1" Then Response.Write(" selected") %><% End if %>>כן</option>
					  </select>				  
					</td>
			    	</tr>
					<tr>
						<td width="30%" align="right"><p>להוסיף אני מסכים לתנאים?:</p><img src="images/ask22.png" id="Img6" original-title="שם הבלוק משמש להתמצאות בלבד" /></td>
			            <td valign="top" height="20" align="right">				  					  
					        <select name="EnableAgree" size="1">
					            <option value="0" <%If Editmode = "True" Then %> <% If objRs("EnableAgree") = "0" Then Response.Write(" selected") %><% End if %>>לא</option>
					            <option value="1" <%If Editmode = "True" Then %><% If objRs("EnableAgree") = "1" Then Response.Write(" selected") %><% End if %>>כן</option>
					        </select>				  
					    </td>
			    	</tr>
				    <tr>
						<td width="30%" align="right"><p>כתובת למשלוח  email על הוספת הודעה:</p><img src="images/ask22.png" id="Img7" original-title="שם הבלוק משמש להתמצאות בלבד" />
					  <br /><small>(אם משאירים ריק זה לא שולח)</small></td>
                        <td width="70%" align="right"><input dir="ltr" type="text" name="forumemail" size="30" maxlength="30" <%If Editmode = "True" Then %>value="<% = objRs("forumemail") %><% End if %>"></font></td>
				  </tr>
				   <tr>
						<td width="30%" align="right"><p>רמת הרשאה להוספת הודעות בפורום</p><img src="images/ask22.png" id="Img9" original-title="שם הבלוק משמש להתמצאות בלבד" />
			                    <br /><small>(9 פתוח לכולם)</small></td>
			            <td valign="top" height="20" align="right">				  					  
					        <select style="width: 40px;" name="WriteAccessLevel" ID="WriteAccessLevel" size="1">
						    <%  i=1	
				 			    Do Until i > 9 %>
							        <option value=<% = i %><%If Editmode = "True" Then %><% If objRs("WriteAccessLevel") = i Then Response.Write(" selected") %><% End if %>>	<% = i %></option>
							<%  i=i+1
							        Loop%>
					        </select>
                        </td>
			    	</tr>
				    <tr>
						<td width="30%" align="right"><p>רמת הרשאה לקריאת הודעות בפורום:</p><img src="images/ask22.png" id="Img8" original-title="שם הבלוק משמש להתמצאות בלבד" />
			                <br /><small>(9 פתוח לכולם)</small></td>
			            <td valign="top" height="20" align="right">				  					  
					        <select style="width: 40px;" name="ReadAccessLevel" ID="ReadAccessLevel" size="1">
						<%  i=1	
				 			Do Until i > 9 %>
							    <option value=<% = i %><%If Editmode = "True" Then %><% If objRs("ReadAccessLevel") = i Then Response.Write(" selected") %><% End if %>>	<% = i %></option>
						<% i=i+1
							Loop %>
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">אפשרויות מתקדמות</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">תמונה</td>
                        </tr>
                                          <tr>
                    <td align="right">
					<input dir="ltr" class="goodinputshort" id="xFilePath" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" size="60" />
					<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
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