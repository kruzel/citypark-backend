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

CheckSecuirty "CalEvent"
    if request("inline") = "true" Then
        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [CalEvent] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
    Response.Clear
    Response.CodePage = "1255" 
    'Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=users.csv"
		SQL = "SELECT * FROM CalEvent WHERE SiteID=" & SiteID & " ORDER BY Name ASC"
	Set objRs = OpenDB(SQL)
	    Do While Not objRs.EOF
            for each f in objRs.Fields
                print(f.Value & ",")
            next
                print  vbCrLf
     objRs.MoveNext
		Loop
    CloseDB(objRs)
    response.end
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Content-Disposition", "attachment;filename=content-"&filedate&".doc"
        Response.ContentType = "application/vnd.ms-word"
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

CheckSecuirty "CalEvent"
 %>   
    <div class="formtitle">
        <h1>ניהול אירועים</h1>
		<div class="admintoolber">
        <form action="admin_calendarevents.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %>&string=<%=Request.form("search") %>&lang=<%=Request.form("lang") %>" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_calendarevents.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_calendarevents.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_calendarevents.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_calendarevents.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th style="width:8%;">תאריך</th>
		<th style="width:36%;text-align:right;padding-right:40px;cursor:pointer;">שם</th>
		<th style="width:8%;">ערוך</th>
        <th style="width:8%;">שכפל דף</th>
        <th style="width:8%;">מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
               SQL = "SELECT * FROM [CalEvent]  WHERE SiteID=" & SiteID & "  ORDER By CalEventID DESC"
       
     If Request.QueryString("mode") = "search" then
               SQL = "SELECT * FROM [CalEvent]  WHERE" 
                SQL = SQL & "(SiteID=" & SiteID & ") "
           If Request.form("category") <> "*" then
                SQL = SQL & " AND (Contentfather.FatherID = " & Request.form("category") & ")"
            end If
            If Request.form("text") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("text") & "%'"
             End If
          '  If Request.form("lang") <> "" Then
              '  SQL = SQL & " AND LangID LIKE '%" & Request.form("lang") & "%'"
           '  End If
                SQL = SQL & " AND Active=" & Int(Request.form("Active"))
                SQL = SQL &  " AND (Contenttype != 2)   ORDER By ItemOrder ASC"
              
    End If
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
        <td><%= objRsg("CalEventID")  %></td>
        <td><%= Left(objRsg("StartDate"),10)  %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("CalEventID") %>_Name"><% = objRsg("Title") %></div></td>
        <td><a href="admin_calendarevents.asp?ID=<% = objRsg("CalEventID") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_calendarevents.asp?ID=<% = objRsg("CalEventID") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td><a href="admin_calendarevents.asp?ID=<% = objRsg("CalEventID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			        Sql = "SELECT * FROM CalEvent WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Title") = Request.Form("Title")
				                objRs("CalId") = Request.Form("CalId")
								objRs("CalEventText") = Request.Form("CalEventText")
								objRs("LangID") = Request.Form("LangID")
								objRs("Image") = Request.Form("Image")
								objRs("StartDate") = Request.Form("Starttime")&" " & Request.Form("StartHour")&":"&	Request.Form("StartMin")
								objRs("EndDate") = Request.Form("Endtime")&" " & Request.Form("EndHour")&":"&	Request.Form("EndMin")
								If Request.Form("Allday")=1 Then
								    objRs("Allday") = Request.Form("Allday")
								Else
									objRs("Allday") = 0
							    End If
								objRs("Url") = Trim(Request.Form("Url"))
                                objRs.Update
									Response.Redirect("admin_calendarevents.asp?notificate=הדף נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"
				    Sql = "SELECT * FROM CalEvent WHERE CalEventID=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)

				                objRs("Title") = Request.Form("Title")
				                objRs("CalId") = Request.Form("CalId")
								objRs("CalEventText") = Request.Form("CalEventText")
								objRs("Image") = Request.Form("Image")
								objRs("LangID") = Request.Form("LangID")
								objRs("StartDate") = Request.Form("Starttime")&" " & Request.Form("StartHour")&":"&	Request.Form("StartMin")
								objRs("EndDate") = Request.Form("Endtime")&" " & Request.Form("EndHour")&":"&	Request.Form("EndMin")
								If Request.Form("Allday")=1 Then
								    objRs("Allday") = Request.Form("Allday")
								Else
									objRs("Allday") = 0
							    End If
								objRs("Url") = Trim(Request.Form("Url"))
                                objRs.Update

					 Response.Redirect("admin_calendarevents.asp?notificate=הדף נערך בהצלחה")

	        Case "copy"
				    Sql = "SELECT * FROM CalEvent WHERE CalEventID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				             objRs("SiteID") = SiteID

				                objRs("Title") = Request.Form("Title")
				                objRs("CalId") = Request.Form("CalId")
								objRs("CalEventText") = Request.Form("CalEventText")
								objRs("LangID") = Request.Form("LangID")
								objRs("Image") = Request.Form("Image")
								objRs("StartDate") = Request.Form("Starttime")&" " & Request.Form("StartHour")&":"&	Request.Form("StartMin")
								objRs("EndDate") = Request.Form("Endtime")&" " & Request.Form("EndHour")&":"&	Request.Form("EndMin")
								If Request.Form("Allday")=1 Then
								    objRs("Allday") = Request.Form("Allday")
								Else
									objRs("Allday") = 0
							    End If
								objRs("Url") = Trim(Request.Form("Url"))
                                objRs.Update
									Response.Redirect("admin_calendarevents.asp?notificate=הדף נוסף בהצלחה")
	        Case "delete"
				    Sql = "SELECT * FROM CalEvent WHERE CalEventID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Redirect("admin_calendarevents.asp?notificate=הדף נמחק בהצלחה")

	            End Select
		Else
			If  Request.QueryString("action") ="edit" OR  Request.QueryString("action") ="copy" Then
                SQL = "SELECT * FROM CalEvent WHERE CalEventID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
            End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM CalEvent WHERE SiteID=" & SiteID   
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

 
<form action="admin_calendarevents.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("CalEventID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת אירוע</h1>
				<% ELSE 
				%>
					<h1>עריכת אירוע</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform"  dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם אירוע (H1):</p><img src="images/ask22.png" id="east" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right" colspan="5">
					<div style="position:relative;">
					  <textarea name="Title" cols="3" class="goodinputlong required" onkeyup ="Menusname.value = this.value;urltext.value = this.value;title.value = this.value;return true;"><%If Editmode = "True" Then print objRs("Title") End If %><% if request.querystring("Title")<> "" Then print request.querystring("Title") end if%></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>יומן:</p></td>
						<td width="80%" align="right" colspan="5">
					<div style="position:relative;">
						<select class="goodselectshort"  name="CalId">
						<% Set objRsg = OpenDB("Select * From Cal Where SiteID=" & SiteID)
							Do While NOT objRsg.EOF %>
						<option value="<% = objRsg("Id") %>"<% If Editmode = "True" Then %><% If objRsg("Id") = objRs("CalId") Then Response.Write(" selected") End if %><% End if%>><% = objRsg("Name") %></option>
						<% objRsg.Movenext
							loop
							CloseDB(objRsg) %>
						</select>
					  </div>
					  </td>
					</tr>
					<tr>
						<td colspan="2" align="right" colspan="6">
						<%
	Dim oFCKeditor
	Set oFCKeditor = New FCKeditor
	oFCKeditor.BasePath = "FCKeditor/"
	If Editmode = "True" Then
		oFCKeditor.Value=objRs("CalEventText")
	End If
	if request.querystring("block")<> "" Then  oFCKeditor.Value=request.querystring("block") end if
	oFCKeditor.width="100%"
	oFCKeditor.height="370px"
	if Session("SiteLang") = "he-IL" Then
	oFCKeditor.config("DefaultLanguage")= "he"
	oFCKeditor.config("ContentLangDirection")= "rtl"
	Else
	oFCKeditor.config("DefaultLanguage")= "en"
	oFCKeditor.config("ContentLangDirection")= "ltr"
	End If
	oFCKeditor.Create "CalEventText"

	%>

						</td>
					</tr>
					<tr>
						<td>התמונה קשורה</td>
						<td>
						<input dir="ltr" class="goodinputshort" id="xFilePath" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" size="60" />
						<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
						</td>
					</tr>
					   <tr>
						<td width="15%" align="right"><p>שפה:</p><img src="images/ask22.png" id="east4" original-title="הדף יופיע רק שהאתר בשפה שתבחר" /></td>
						<td width="35%" align="right" colspan="5"><%
							Set objRsLang = OpenDB("SELECT * FROM Lang ORDER BY langorder ASC")
						%>					  					
						<select class="goodselectshort"  name="LangID">
						<%
						If Editmode = "True" Then
							Do While Not objRsLang.EOF	%>
							<option value="<% = objRsLang("LangID") %>"<% If objRsLang("LangID") = objRs("LangID") Then Response.Write(" selected") End if %>><% = objRsLang("LangName") %></option>
						<%	objRsLang.MoveNext 
								Loop
						Else
							Do While Not objRsLang.EOF
						%><option value="<% = objRsLang("LangID") %>"<% If Trim(objRsLang("LangID")) = Session("SiteLang") Then Response.Write(" selected") End if %>><% = objRsLang("LangName") %></option>
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
					<td width="15%" align="right">תאריך</td>
					<td valign="top" align="right">
					  <input type="text" dir="ltr" name="Starttime" class="_date goodinputlong" <% If Editmode = "True" Then %> value="<% = Left(objRs("StartDate"),10) %>"<% End If %> size="10" maxlength="100" style="margin-left: 183px; width: 100px;"></td>
                    <td width="10%" align="right">שעה</td>
                    <td>
                    <select name="StartHour">
                    <% for i = 00 to 23 %>
                        <% If Editmode = "True" Then %>
                          <option value="<%=i %>"<% If  i = DatePart("h",objRs("StartDate"))Then print "selected" End if %>><%=i %></option>
                         <% Else %>
                          <option value="<%=i %>"><%=i %></option>
                        <% End If %>
                    <% next %>
                    </select>
                    </td>	
                    <td width="10%" align="right">דקות</td>
                    <td>
                    <select name="StartMin">
                    <% for i = 00 to 59 %>
                        <% If Editmode = "True" Then %>
                              <option value="<%=i %>" <% If Editmode = "True" AND i = DatePart("n",objRs("StartDate"))Then print "selected" End if %>><%=i %></option>
                         <% Else %>
                              <option value="<%=i %>" ><%=i %></option>
                        <% End If %>
                    
                    
                    <% next %>
                    </select>
                    </td>			 
			        </tr>
					<td valign="top" align="right">
					  <span lang="he"><font face="Arial" size="2">תאריך</font></span></td>
					<td valign="top" height="20" align="right">
					  <input type="text" dir="ltr" name="Endtime" class="_date goodinputlong" <% If Editmode = "True" Then %> value="<% = Left(objRs("EndDate"),10) %>" <% End If %> size="10" maxlength="100"style="margin-left: 183px; width: 100px;"></font>
                            </td>
                             <td width="10%" align="right">שעה</td>
                    <td>
                    <select name="EndHour">
                    <% for i =00 to 23 %>
                   
                         <% If Editmode = "True" Then %>
                             <option value="<%=i %>"<% If i = DatePart("h",objRs("EndDate"))Then print "selected" End if %>><%=i %></option>
                         <% Else %>
                             <option value="<%=i %>"><%=i %></option>
                        <% End If %>
                    <% next %>
                    </select>
                    </td>	
                     <td width="10%" align="right">דקות</td>
                    <td>
                    <select name="EndMin">
                    <% for i = 00 to 59 %>
                    
                         <% If Editmode = "True" Then %>
                    <option value="<%=i %>" <% If  i = DatePart("n",objRs("EndDate"))Then print "selected" End if %>><%=i %></option>
                         <% Else %>
                    <option value="<%=i %>"><%=i %></option>
                        <% End If %>
                    
                    
                    
                    
                    <% next %>
                    </select>
                    </td>	
			      </tr>
					<tr>
					 <td align="right"><p>אירוע של יום שלם?:</p><img src="images/ask22.png" id="east6" original-title="חייב להיות פעיל כדי להופיע באתר." /></td>
					 <td align="right" colspan="5" ><input id="Active"  type="checkbox" dir="ltr" name="Allday" value="1" <%If Editmode = "True" Then %><% If objRs("Allday")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					</td>
				   </tr>
					<tr>
						<td align="left" colspan="2"><input type="submit" value="שמור" class="saveform" colspan="6" /></td>
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