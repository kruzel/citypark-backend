<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type="text/javascript">
    jQuery(document).ready(function () {
        //jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
   
        $("#contentTable").treeTable();
   
        $('#east').tipsy({ html: true });
        $('#east2').tipsy({ html: true });
        $('#east3').tipsy({ html: true });
        $('#east4').tipsy({ html: true });
        $('#east5').tipsy({ html: true });
        $('#east6').tipsy({ html: true });
        $('#east7').tipsy({ html: true });
        $('#east8').tipsy({ html: true });
        $('#east9').tipsy({ html: true });
        $('#east10').tipsy({ html: true });
        $('#east11').tipsy({ html: true });
        $('#east12').tipsy({ html: true });
        $('#east13').tipsy({ html: true });
        $('#east14').tipsy({ html: true });
        $('#east15').tipsy({ html: true });
        $('#east16').tipsy({ html: true });
        $('#east17').tipsy({ html: true });
        $('#east18').tipsy({ html: true });
        $('#east19').tipsy({ html: true });
		
		$("#categorylist").load("admin_ajax.asp?ajax=4&id=<%=Request.QueryString("id")%>&action=<%=Request.QueryString("action")%>",function() {sb=true;sc=true;sa = true;initTree();});

    });
	function bringcontent(id,p,e) {
		//if ($("table#t"+id).text() == '') 
			if ($("#h"+id).is(":visible")) {
					$("#h"+id).hide();
				} else {
					$("#h"+id).css("display","table-row");
				}
			
		if (!$(e).hasClass("ajaxed")) {//first time open
			$("table#t"+id).load("admin_ajax.asp?ajax=c&id="+id+"&p="+p,function() { dialogit(); });
			$(e).addClass("ajaxed");
			
		}
			
	//$(e).parent().parent().toggleClass("expanded");
	$(e).find("img").attr("src",($(e).find("img").attr("src").indexOf("plus")>0)?$(e).find("img").attr("src").replace("plus","minus"):$(e).find("img").attr("src").replace("minus","plus"));
	
	}
	function dialogit() {
	$("._dialog").click(function() {
            $("<div></div>")
                .load($(this).attr("href"))
                .appendTo("body")
                .dialog($(this).mmetadata())
  
            return false;
        });
	}
</script>

<%
Function Langname(langID)
select case langID
case "en-US"
case "he-IL"
Langname= "He-עברית"
case "ru-RU"
Langname= "Rusian-Ru"
case "en-GB"
Langname= "English-Gb"
case "de-DE"
Langname= "Dautch-De"
End Select
Langname = "<img src=""/admin/flags/" & langID & ".png"" width=""20"" height=""13"" style=""float:none"" />"
End Function

CheckSecuirty "Content"
    if request("inline") = "true" Then
        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Content] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
    Response.Clear
    Response.CodePage = "1255" 
    Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=users.csv"
		SQL = "SELECT * FROM Content WHERE SiteID=" & SiteID & " ORDER BY Name ASC"
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

CheckSecuirty "Content"
 %>   
    <div class="formtitle">
        <h1>ניהול דפי תוכן</h1>
		<div class="admintoolber">
        <form action="admin_content.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.Querystring("category") %>&string=<%=Request.Querystring("search") %>&lang=<%=Request.Querystring("lang") %>" method="get">
               <p>חיפוש:</p>
			   <select name="Active">
						<option value="1">פעיל</option>
						<option value="0">לא פעיל</option>
                </select>
					<% Set objRs = OpenDB("SELECT * FROM Content Where SiteID = " & SiteID)
                        If objRs.RecordCount > 0 then
						Set objRsCategory = OpenDB("SELECT * FROM Content Where SiteID = " & SiteID)
					  
                    %>					  
				<select id="category" name="category">
						<option value="*">הכל</option>
						<option value="0" <% If objRsCategory("Name") = "עמוד אב" Then Response.Write(" selected") %>>עמוד אב</option>
                	<%
                            Do While Not objRsCategory.EOF
					    
                        %>
						<option value="<% = objRsCategory("Id") %>"<% If objRsCategory("Id") = Request.querystring("category") Then Response.Write(" selected") %>><% = objRsCategory("Name") %></option>
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
               <input type="hidden" value="search" name="mode">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_content.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_content.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_content.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_content.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
					<option value="10" <%if Session("records") = 10 then print "selected" End if%>>10</option>
					<option value="20" <%if Session("records") = 20 then print "selected" End if%>>20</option>
					<option value="50" <%if Session("records") = 50 then print "selected" End if%>>50</option>
					<option value="100" <%if Session("records") = 100 then print "selected" End if%>>100</option>
					<option value="1000" <%if Session("records") = 1000 then print "selected" End if%>>1000</option>
				</select>
			</p>
						<% Set objRsLang = OpenDB("SELECT * FROM Lang ORDER BY langorder ASC")%>					  					
						<select style="width:55px;"  name="LangID" onchange="location.href='admin_content.asp?mode=lang&lang='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
							<option value="">שפה</option>
                        <%	Do While Not objRsLang.EOF	%>
							<option value="<% = objRsLang("LangID") %>"<% If Request.querystring("Lang") <> ""  Then Response.Write(" selected") End if %>><% = objRsLang("LangName") %></option>
						<%	objRsLang.MoveNext 
								Loop
						%>
						</select>
						<% 
						objRsLang.Close
						%>

	</div>
	</div>
	<table id="contentTablex" class="tablesorter treeTable" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th style="width:8%;" class="recordid">ID</th>
		<th style="width:36%;text-align:right;padding-right:40px;cursor:pointer;">שם הדף</th>
        <th style="width:8%;">שפה</th>
        <th style="width:8%;"><a href="admin_content_positions.asp?type=content&action=edit" class="_dialog { width: 500, title:'יש לגרור את הדפים לפי הסדר הרצוי',modal:true,position:top}">סדר דפים</a></th>
        <th style="width:8%;">סדר בנים</th>
		<th style="width:8%;">ערוך</th>
        <th style="width:8%;">שכפל דף</th>
        <th style="width:8%;">פעיל</th>
        <th style="width:8%;">מחק</th>
		
    </tr>
</thead>
<tbody>
<%
        If Request.QueryString("lang") <> "" Then
               SQL = "SELECT [Content].*, Contentfather.FatherID, (SELECT count(*) as counter FROM Contentfather WHERE FatherID = [Content].id) AS COUNTER FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = 0) AND Content.SiteID=" & SiteID & " AND  (Contenttype != 2 AND Contenttype != 3)  AND (LangID LIKE '%" & Request.querystring("lang") & "%') ORDER By LangID ASC,ItemOrder ASC"
        Else
               SQL = "SELECT [Content].*, Contentfather.FatherID , (SELECT count(*) as counter FROM Contentfather WHERE FatherID = [Content].id) AS COUNTER FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = 0) AND Content.SiteID=" & SiteID & " AND  (Contenttype != 2 AND Contenttype != 3)  ORDER By LangID ASC,ItemOrder ASC"
        End If
		If Request.QueryString("mode") = "search" then
			SQL = "SELECT [Content].*, Contentfather.FatherID, (SELECT count(*) as counter FROM Contentfather WHERE FatherID = [Content].id) AS COUNTER FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE "
            SQL = SQL & "(Content.SiteID=" & SiteID & ") "
	   If Request.QueryString("category") <> "*" then
			SQL = SQL & " AND (Contentfather.FatherID = " & Request.QueryString("category") & ")"
		end If
		If Request.QueryString("text") <> "" Then
			SQL = SQL & " AND Name LIKE '%" & Request.QueryString("text") & "%'"
		End If
		SQL = SQL & " AND Active=" & Int(Request.QueryString("Active"))
		SQL = SQL &  " AND (Contenttype != 2)   ORDER By ItemOrder ASC"
   
    End If
	           'print sql
		Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	        objRsg.PageSize = Session("records")
                HowMany = 0
                fatherID =  objRsg("Id")
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize

%>
   <tr class="parent collapsed" style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td  style="width:8%;"><%= objRsg("Id")  %></td>
		<td style="width:36%;" class="editlocalbig" style="padding:0 32px 0 0;text-align:right;">	
			<% If objRsg("counter") > 0 Then%>
			<span onclick="bringcontent(<%= objRsg("Id")  %>,1,this)" style="float:right;cursor:pointer;width:5%;">
			<img src="/admin/images/plus.png" style="border:0">
			</span>
			<%else %>
			<span style="float:right;cursor:pointer;width:5%;">
		&nbsp;
			</span>
			<% end if %>
			<div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_Name">
				<% = objRsg("Name") %>
			</div>
		</td>        <td style="width:8%;"><%= Langname(objRsg("LangID"))  %></td>
        <td class="editlocal" style="width:8%;">
		<div class="inlinetext" id="<% = objRsg("id") %>_Itemorder"><%= objRsg("Itemorder") %></div>
        </td>
		<td style="width:8%;" class="editlocal">
	<% If objRsg("counter") > 0 Then %>
        <a href="admin_content_positions.asp?type=content&ID=<% = objRsg("Id") %>&action=edit" class="_dialog { width: 500, title:'יש לגרור את הדפים לפי הסדר הרצוי',modal:true,position:top}"><img src="images/order.gif" border="0" alt="סדר בנים" /></a>
        <% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/order.gif" border="0" alt="סדר בנים" />
		<% End If %>
        </td>
          <% If  objRsg("Contenttype") = 1 Then %>  
                <td style="width:8%;"><a href="admin_content.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
          <% End if %>
          <% If  objRsg("Contenttype") = 4 Then %>  
                <td style="width:8%;"><a href="admin_gallery.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
          <%  End if %> 
          <% If  objRsg("Contenttype") = 6 Then %>  
                <td style="width:8%;"><a href="admin_videos.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
          <%  End if %> 
          <% If  objRsg("Contenttype") = 7 Then %>  
                <td style="width:8%;"><a href="admin_Customform.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
          <%  End if %> 
        <td style="width:8%;"><a href="admin_content.asp?ID=<% = objRsg("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td style="width:8%;"><% If objRsg("Active")= 1 Then %><img style="border:0px;" src="images/active.png" border="0" alt="" /><% Else %><img style="border:0px;" src="images/notactive.png" border="0" alt="" /><% End if %></td>
        <td style="border-left:0px;"><%If objRsg("counter") = 0 Then %><a href="admin_content.asp?ID=<% = objRsg("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a>
		<% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/delete.gif" border="0" alt="מחק" />
		<% End If %></td>

	</td>
       
    </tr>	
	<tr id="h<%=objRsg("Id")%>" style="display:none">
	<td colspan="9" cellpadding="0"><table id="t<%=objRsg("Id")%>" width="100%" border="0" cellspacing="0" cellpadding="0"><td>טוען...</td></table></td>
	
	</tr>
	<%
	if not stay then color = not color
				
                 HowMany = HowMany + 1
                objRsg.MoveNext
		  		Loop
                objRsg.Close
                End If
				%>
</tbody>
</table>
</div>
<%	 
Else
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	        Case "add"
	   SqlCategory2 = "SELECT  TOP 1 * FROM Content WHERE SiteID= " & SiteID & " AND (Contenttype = 1) ORDER BY Id DESC"
		    Set objRsCategory2 = OpenDB(SqlCategory2)
             If objRsCategory2.RecordCount = 0 then
                LastNews = 0
             Else
                LastNews = objRsCategory2("ItemOrder")
             end If
            CloseDB(objRsCategory2)

	        Editmode= "False"
                               v = 0
                               For Each x In Request.Form
								If Mid(x, 1, Len("category_")) = "category_" Then
                                   v=v+1
								 End If
								Next
                                if v = o then
                                    print "יש לבחור לפחות קטגורייה אחת"
                                    response.end
                                End if

			      Set objRsUrl = OpenDB("SELECT * FROM Content WHERE SiteID=" & SiteID)
					UrlExists = False
						Do While Not objRsUrl.EOF
							If objRsUrl("urltext") = Trim(Request.Form("urltext")) Then
					            UrlExists = True
							End If
				        objRsUrl.MoveNext 
					        Loop
				        objRsUrl.close
						    If UrlExists = True Then
                            Response.Write("<br><br><p align='center'>שם בשורת הכתובת שבחרת כבר תפוס. השתמש מלחצן חזרה בדפדפן על מנת לתקן זאת או לחץ <a href='javascript:history.go(-1)'>כאן</a>!</p>")						
						Else

			        Sql = "SELECT * FROM Content WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
	                    
	                            For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                     If Request.Form(x) = "on" Then
                                     
                                        CheckCategorySecuirty(mid(x,16))
                                     End If
						    		End If
								Next


				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("Contenttype") = 1
				             objRs("urltext") = Trim(Request.Form("urltext"))
				                objRs("Name") = Request.Form("Name")
				                objRs("Name2") = Request.Form("Name2")
								objRs("Text") = Request.Form("Text")
								' objRs("Shorttext") = Trim(Request.Form("Shorttext"))	
								objRs("Shorttext") = replace(Request.Form("Shorttext"),VbCrLf, "<br >")
								objRs("LangID") = Request.Form("LangID")
								objRs("Tags") = Trim(Request.Form("Tags"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Image2") = Trim(Request.Form("Image2"))
								objRs("Image3") = Trim(Request.Form("Image3"))
								objRs("Image4") = Trim(Request.Form("Image4"))
								objRs("Image5") = Trim(Request.Form("Image5"))
								objRs("Image6") = Trim(Request.Form("Image6"))
								objRs("Image7") = Trim(Request.Form("Image7"))
								objRs("flv") = Trim(Request.Form("flv"))
								objRs("youtube") = Trim(Request.Form("youtube"))
								objRs("Userlevel") = Request.Form("Userlevel")	
								objRs("UserSecurityTarget") = Request.Form("UserSecurityTarget")	
								objRs("Title") = Trim(Request.Form("Title"))	
								objRs("Template") = Trim(Request.Form("Template"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("showinsitemap") = Request.Form("showinsitemap")
								objRs("priority") = Request.Form("priority")
								objRs("urlprefix") = Request.Form("urlprefix")
								objRs("other1") = Request.Form("other1")
								objRs("other2") = Request.Form("other2")
								objRs("other3") = Request.Form("other3")
								objRs("other4") = Request.Form("other4")
								objRs("other5") = Request.Form("other5")
								objRs("other6") = Request.Form("other6")
								objRs("other7") = Request.Form("other7")
								objRs("other9") = Request.Form("other9")

								objRs("Snosshow") = Request.Form("Snosshow")
					            objRs("Categorytemplate") = Request.Form("Categorytemplate")
								objRs("Sonstemplate") = Request.Form("Sonstemplate")
								objRs("Sonsrecords") = Request.Form("Sonsrecords")
								objRs("Sonscategoryrecords") = Request.Form("Sonscategoryrecords")
								objRs("Sonsshowpager") = Request.Form("Sonsshowpager")
                                objRs("Sonsvipmode") = Request.Form("Sonsvipmode")
                                   If Request.Form("Showinsonmenu")<> 1 Then
								        objRs("Showinsonmenu") = 0
								    Else
								        objRs("Showinsonmenu") = 1
								    End If
                                  
                                   If Request.Form("Menuislink")<> 1 Then
								        objRs("Menuislink") = 0
								    Else
								        objRs("Menuislink") = 1
								    End If


                                objRs("Sonsfirsttemplate") = Request.Form("Sonsfirsttemplate")
								objRs("Sonsfirstrecords") = Request.Form("Sonsfirstrecords")
								objRs("Sonsorder") = Request.Form("Sonsorder")
								objRs("Categoryorder") = Request.Form("Categoryorder")
                                
                                objRs("Datecreated") = Now()
								objRs("CreateadminID") = Session(SiteID & "AdminID")

                                For Each r in Request.Form
						        If LCase(Mid(r, 1, Len("menus"))) = "menus" Then
							        If Request.Form(r) = "on" Then
								        If c = "" OR c = NULL Then
									        c = Mid(r, Len("menus") + 1)
								        Else
									        c = c & "," & Mid(r, Len("menus") + 1)
								        End If							
							        End If			
						        End If
					        Next
					    objRs("Menus") = c
								objRs("Menusname") = Request.Form("Menusname")
								objRs("ItemOrder") = CInt(LastNews) + 1
								objRs("Menusorder") = CInt(LastNews) + 1
								    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If
                            '///////////Delete Cache/////////////
                               deletecache objRs("Urltext")
                               Application.Contents.RemoveAll
                            '///////////Delete Cache/////////////
								objRs.Update
								objRs.Close
                                Set objRs = OpenDB("Select TOP 1 Id From Content Order By Id Desc")
								cId = objRs("Id")
								CloseDb(objRs)
                                For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                    	 If Request.Form(x) = "on" Then
										   ExecuteRS("INSERT INTO [Contentfather] (ContentID, FatherID, SiteID) VALUES (" & cId & ", " &  mid(x,16) & ", " & SiteID & ");")
                                        End If
									End If
								Next

		If Request.Form("save") <> "" Then 'temporarysave
					If GetConfig("twitterusername") <> "" AND Request.Form("sendtotwitter") = 1 Then
			            Response.Buffer = True  
                        Set xml = Server.CreateObject("Microsoft.XMLHTTP")  
                        twitter_username = GetConfig("twitterusername")   
                        twitter_password = GetConfig("twitterpassword")  
                        url =  "http://" & LCase(Request.ServerVariables("HTTP_HOST")) & "/" & Replace(Request.Form("urltext")," ","-") 
                        new_status =  Left(Trim(Request.Form("Name")) & " - " &  url & " - " & StripHtml(Trim(Request.Form("Text"))),139)   'change to your new status  
                        xml.Open "POST", "http://" & twitter_username & ":" & twitter_password & "@twitter.com/statuses/update.xml?status=" & server.URLencode(new_status), False  
                        xml.setRequestHeader "Content-Type", "content=text/html; charset=utf-8"  
                        xml.Send  
						Response.Write("<br><br><p align='center'>סטטוס עודכן בטוויטר. <a href='admin_Content.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
                        Set xml = Nothing  
                     End If
            Response.Redirect("admin_Content.asp?notificate=הדף נוסף בהצלחה")
        Else
        	Sqll = "SELECT  TOP 1 * FROM Content  ORDER BY Id DESC"
		    Set objRsSqll = OpenDB(Sqll)
            tSqll =objRsSqll(0)
            CloseDB(objRsSqll)
            Response.Redirect("admin_Content.asp?ID="& tSqll &"&action=edit")
   		End If			
							  '      Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_Content.asp?S=" & SiteID & "'>")

                        End If
	       Case "edit"
	       	 Editmode= "True"
	       
                               v = 0
                               For Each x In Request.Form
								If Mid(x, 1, Len("category_")) = "category_" Then
                                   v=v+1
								 End If
								Next
                                if v = o then
                                    print "יש לבחור לפחות קטגורייה אחת"
                                    response.end
                                End if

				    Sql = "SELECT * FROM Content WHERE Id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)


	                            For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                     If Request.Form(x) = "on" Then
                                        CheckCategorySecuirty(mid(x,16))
                                     End If
						    		End If
								Next

				                objRs("Name") = Request.Form("Name")
				                objRs("Name2") = Request.Form("Name2")
								objRs("Text") = Request.Form("Text")
								' objRs("Shorttext") = Trim(Request.Form("Shorttext"))	
								objRs("Shorttext") = replace(Request.Form("Shorttext"),VbCrLf, "<br >")
								objRs("LangID") = Request.Form("LangID")
								objRs("Tags") = Trim(Request.Form("Tags"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Image2") = Trim(Request.Form("Image2"))
								objRs("Image3") = Trim(Request.Form("Image3"))
								objRs("Image4") = Trim(Request.Form("Image4"))
								objRs("Image5") = Trim(Request.Form("Image5"))
								objRs("Image6") = Trim(Request.Form("Image6"))
								objRs("Image7") = Trim(Request.Form("Image7"))
								objRs("Userlevel") = CInt(Request.Form("Userlevel"))	
								objRs("UserSecurityTarget") = Request.Form("UserSecurityTarget")	
								objRs("Title") = Trim(Request.Form("Title"))	
								objRs("Template") = Trim(Request.Form("Template"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("showinsitemap") = Request.Form("showinsitemap")
								objRs("priority") = Request.Form("priority")
								objRs("urlprefix") = Request.Form("urlprefix")
								objRs("other1") = Request.Form("other1")
								objRs("other2") = Request.Form("other2")
								objRs("other3") = Request.Form("other3")
								objRs("other4") = Request.Form("other4")
								objRs("other5") = Request.Form("other5")
								objRs("other6") = Request.Form("other6")
								objRs("other7") = Request.Form("other7")
								objRs("other9") = Request.Form("other9")
								
                                objRs("Image6") = Trim(Request.Form("Image6"))
								objRs("Image7") = Trim(Request.Form("Image7"))
								objRs("flv") = Trim(Request.Form("flv"))
								objRs("youtube") = Trim(Request.Form("youtube"))
								objRs("EditadminID") = Session(SiteID & "AdminID")

                                objRs("Snosshow") = Request.Form("Snosshow")
					            objRs("Categorytemplate") = Request.Form("Categorytemplate")
								objRs("Sonstemplate") = Request.Form("Sonstemplate")
								objRs("Sonsrecords") = Request.Form("Sonsrecords")
								objRs("Sonscategoryrecords") = Request.Form("Sonscategoryrecords")
								objRs("Sonsshowpager") = Request.Form("Sonsshowpager")
                                objRs("Sonsvipmode") = Request.Form("Sonsvipmode")
                                   If Request.Form("Showinsonmenu")<> 1 Then
								        objRs("Showinsonmenu") = 0
								    Else
								        objRs("Showinsonmenu") = 1
								    End If
                                    If Request.Form("Menuislink")<> 1 Then
								        objRs("Menuislink") = 0
								    Else
								        objRs("Menuislink") = 1
								    End If

                                objRs("Sonsfirsttemplate") = Request.Form("Sonsfirsttemplate")
								objRs("Sonsfirstrecords") = Request.Form("Sonsfirstrecords")
								objRs("Sonsorder") = Request.Form("Sonsorder")
								objRs("Categoryorder") = Request.Form("Categoryorder")
                                
                                For Each r in Request.Form
						        If LCase(Mid(r, 1, Len("menus"))) = "menus" Then
							        If Request.Form(r) = "on" Then
								        If c = "" Then
									        c = Mid(r, Len("menus") + 1)
								        Else
									        c = c & "," & Mid(r, Len("menus") + 1)
								        End If							
							        End If			
						        End If
					        Next
					    objRs("Menus") = c
								objRs("Menusname") = Request.Form("Menusname")
								    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If
                            '///////////Delete Cache/////////////
                               deletecache objRs("Urltext")
                               Application.Contents.RemoveAll
                            '///////////Delete Cache/////////////
                                objRs.Update
								objRs.Close
                        
                        ExecuteRS("DELETE FROM [Contentfather] WHERE ContentID = " & Request.QueryString("ID"))
                                For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                       sqls = "Select FatherID FROM Contentfather WHERE ContentID=" & Request.QueryString("ID") & " AND FatherID=" & mid(x,16) & " AND SiteID=" & SiteID
		                               Set objRssqls = OpenDB(sqls)
                                            If objRssqls.recordcount = 0 then
                                    	        If Request.Form(x) = "on"  Then
										         ExecuteRS("INSERT INTO [Contentfather] (ContentID, FatherID, SiteID) VALUES (" & Request.QueryString("ID") & ", " &  mid(x,16) & ", " & SiteID & ");")
                                                End If
                                            End If
                                       CloseDB(objRssqls)
									End If
								Next
                        If Request.Form("save") <> "" Then

						If GetConfig("twitterusername") <> "" AND Request.Form("sendtotwitter") = 1 Then
			            Response.Buffer = True  
                        Set xml = Server.CreateObject("Microsoft.XMLHTTP")  
                        twitter_username = GetConfig("twitterusername")   
                        twitter_password = GetConfig("twitterpassword")  
                        url =  "http://" & LCase(Request.ServerVariables("HTTP_HOST")) & "/" & Replace(Request.Form("urltext")," ","-")
                        new_status =  Left(Trim(Request.Form("Name")) & " - " &  url & " - " & StripHtml(Trim(Request.Form("Text"))),139)   'change to your new status  
                        xml.Open "POST", "http://" & twitter_username & ":" & twitter_password & "@twitter.com/statuses/update.xml?status=" & server.URLencode(new_status), False  
                        xml.setRequestHeader "Content-Type", "content=text/html; charset=utf-8"  
                        xml.Send  
						Response.Redirect("admin_content.asp?notificate=הדף נשלח לטוויטר")
                        Set xml = Nothing  
                     End If
					 Response.Redirect("admin_content.asp?notificate=הדף נערך בהצלחה")
                    else
                        Response.Redirect("admin_content.asp?ID="&Request.QueryString("ID")&"&action=edit")
                    end if
	        Case "copy"
	        	Editmode = "True"
	                    SqlCategory2 = "SELECT  TOP 1 * FROM Content WHERE SiteID= " & SiteID & " AND (Contenttype = 1) ORDER BY Id DESC"
		                Set objRsCategory2 = OpenDB(SqlCategory2)
                                If objRsCategory2.RecordCount = 0 then
                                    LastNews = 0
                                 Else
                                LastNews = objRsCategory2("ItemOrder")
                                end If
                        CloseDB(objRsCategory2)
	        			      Set objRsUrl = OpenDB("SELECT * FROM Content WHERE SiteID=" & SiteID)
					UrlExists = False
						Do While Not objRsUrl.EOF
							If objRsUrl("urltext") = Trim(Request.Form("urltext")) Then
					            UrlExists = True
							End If
				        objRsUrl.MoveNext 
					        Loop
				        objRsUrl.close
						    If UrlExists = True Then
                            Response.Write("<br><br><p align='center'>שם בשורת הכתובת שבחרת כבר תפוס. השתמש מלחצן חזרה בדפדפן על מנת לתקן זאת או לחץ <a href='javascript:history.go(-1)'>כאן</a>!</p>")						
						Else

	            If Request.Querystring("ID") = "" Then
				    Sql = "SELECT * FROM Content WHERE urltext=" & Replace(Request.QueryString("p"),"-"," ")
			    Else
				    Sql = "SELECT * FROM Content WHERE Id=" & Request.QueryString("ID")
			    End If
			        	Set objRs = OpenDB(sql)
	                         
	                            For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                     If Request.Form(x) = "on" Then
                                        CheckCategorySecuirty(mid(x,16))
                                     End If
						    		End If
								Next
                               v = 0
                               For Each x In Request.Form
								If Mid(x, 1, Len("category_")) = "category_" Then
                                   v=v+1
								 End If
								Next
                                if v = o then
                                    print "יש לבחור לפחות קטגורייה אחת"
                                    response.end
                                End if

				             objRs.Addnew
				             objRs("SiteID") = SiteID
                             objRs("Contenttype") = 1
				             objRs("urltext") = Trim(Request.Form("urltext"))
				                objRs("Name") = Request.Form("Name")
				                objRs("Name2") = Request.Form("Name2")
								objRs("Text") = Request.Form("Text")
								' objRs("Shorttext") = Trim(Request.Form("Shorttext"))	
								objRs("Shorttext") = replace(Request.Form("Shorttext"),VbCrLf, "<br >")
								objRs("LangID") = Request.Form("LangID")
								objRs("Tags") = Trim(Request.Form("Tags"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Image2") = Trim(Request.Form("Image2"))
								objRs("Image3") = Trim(Request.Form("Image3"))
								objRs("Image4") = Trim(Request.Form("Image4"))
								objRs("Image5") = Trim(Request.Form("Image5"))
								objRs("Image6") = Trim(Request.Form("Image6"))
								objRs("Image7") = Trim(Request.Form("Image7"))
								objRs("Userlevel") = Request.Form("Userlevel")	
								objRs("UserSecurityTarget") = Request.Form("UserSecurityTarget")	
								objRs("Title") = Trim(Request.Form("Title"))	
								objRs("Template") = Trim(Request.Form("Template"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("showinsitemap") = Request.Form("showinsitemap")
								objRs("priority") = Request.Form("priority")
								objRs("urlprefix") = Request.Form("urlprefix")
								objRs("other1") = Request.Form("other1")
								objRs("other2") = Request.Form("other2")
								objRs("other3") = Request.Form("other3")
								objRs("other4") = Request.Form("other4")
								objRs("other5") = Request.Form("other5")
								objRs("other6") = Request.Form("other6")
								objRs("other7") = Request.Form("other7")
								objRs("other9") = Request.Form("other9")
								
								
                                objRs("Image7") = Trim(Request.Form("Image7"))
								objRs("flv") = Trim(Request.Form("flv"))
								objRs("youtube") = Trim(Request.Form("youtube"))
								
                                objRs("Snosshow") = Request.Form("Snosshow")
					            objRs("Categorytemplate") = Request.Form("Categorytemplate")
								objRs("Sonstemplate") = Request.Form("Sonstemplate")
								objRs("Sonsrecords") = Request.Form("Sonsrecords")
								objRs("Sonscategoryrecords") = Request.Form("Sonscategoryrecords")
								objRs("Sonsshowpager") = Request.Form("Sonsshowpager")
                                objRs("Sonsvipmode") = Request.Form("Sonsvipmode")
                                   If Request.Form("Showinsonmenu")<> 1 Then
								        objRs("Showinsonmenu") = 0
								    Else
								        objRs("Showinsonmenu") = 1
								    End If
                                    
                                    If Request.Form("Menuislink")<> 1 Then
								        objRs("Menuislink") = 0
								    Else
								        objRs("Menuislink") = 1
								    End If

                                objRs("Sonsfirsttemplate") = Request.Form("Sonsfirsttemplate")
								objRs("Sonsfirstrecords") = Request.Form("Sonsfirstrecords")
								objRs("Sonsorder") = Request.Form("Sonsorder")
								objRs("Categoryorder") = Request.Form("Categoryorder")
								
                                objRs("Datecreated") = Now()
								objRs("CreateadminID") = Session(SiteID & "AdminID")

                                For Each r in Request.Form
						        If LCase(Mid(r, 1, Len("menus"))) = "menus" Then
							        If Request.Form(r) = "on" Then
								        If c = "" Then
									        c = Mid(r, Len("menus") + 1)
								        Else
									        c = c & "," & Mid(r, Len("menus") + 1)
								        End If							
							        End If			
						        End If
					        Next
					    objRs("Menus") = c
								objRs("ItemOrder") = CInt(LastNews) + 1
								objRs("Menusorder") = CInt(LastNews) + 1
								objRs("Menusname") = Request.Form("Menusname")
                                
                                    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If
                            '///////////Delete Cache/////////////
                               deletecache objRs("Urltext")
                            '///////////Delete Cache/////////////
								objRs.Update
								objRs.Close
                                    Set objRs = OpenDB("Select TOP 1 Id From Content Order By Id Desc")
								    cId = objRs("Id")
								    CloseDb(objRs)
                                For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                       sqls = "Select FatherID FROM Contentfather WHERE ContentID=" & cId & " AND FatherID=" & mid(x,16) & " AND SiteID=" & SiteID
		                               Set objRssqls = OpenDB(sqls)
                                            If objRssqls.recordcount = 0 then
                                    	        If Request.Form(x) = "on"  Then
										         ExecuteRS("INSERT INTO [Contentfather] (ContentID, FatherID, SiteID) VALUES (" & cId & ", " &  mid(x,16) & ", " & SiteID & ");")
                                                End If
                                            End If
                                        CloseDB(objRssqls)
									End If
								Next

									Response.Redirect("admin_content.asp?notificate=הדף נוסף בהצלחה")
			        If GetConfig("doobleweb") <> "" Then
			            Response.Buffer = True  
                        url = LCase(Request.ServerVariables("HTTP_HOST"))& "/" & Request.Form("urltext")
                        Dim xml  
                        Set xml = Server.CreateObject("Microsoft.XMLHTTP")  
                        twitter_username = GetConfig("twitterusername")   
                        twitter_password = GetConfig("twitterpassword")  
                        new_status = Trim(Request.Form("Name")) & Trim(Request.Form("Text")) & url 'change to your new status  
                        xml.Open "POST", "http://" & twitter_username & ":" & twitter_password & "@twitter.com/statuses/update.xml?status=" & server.URLencode(new_status), False  
                        xml.setRequestHeader "Content-Type", "content=text/html; charset=utf-8"  
                        xml.Send  
                      '  Response.Write xml.responseText     'view Twitter's response  
                        Set xml = Nothing  
                     End If
					
					
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_Content.asp?S=" & SiteID & "'>")
                        End If

	        
	        Case "delete"
				    Sql = "SELECT * FROM Content WHERE Id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)

	                            For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                     If Request.Form(x) = "on" Then
                                        CheckCategorySecuirty(mid(x,16))
                                     End If
						    		End If
								Next
   
                            '///////////Delete Cache/////////////
                               deletecache objRs("Urltext")
                            '///////////Delete Cache/////////////
			            objRs.Delete
			            objRs.Close
                         ExecuteRS("DELETE FROM [Contentfather] WHERE ContentID = " & Request.QueryString("ID"))

						    Response.Redirect("admin_content.asp?notificate=הדף נמחק בהצלחה")
	        
	        

	            End Select
		Else
			If Request.Querystring("ID") = "" AND Request.QueryString("action") ="edit" OR Request.Querystring("ID") = "" AND Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM Content WHERE urltext='" & Trim(Replace(Request.QueryString("p"),"-"," ")) & "' And SiteID=" & SiteID
			Else
				SQL = "SELECT * FROM Content WHERE Id=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Content WHERE SiteID=" & SiteID   
			End If	
				Set objRs = OpenDB(SQL)
					If Session("Level") > 3 Then 
						Response.Write("<br><br><p align='center'>אין לך הרשאה לבצע פעולה זאת <a href='user_home.asp'>נסה שנית</a>!</p>")
				
		Else
		
		If Request.QueryString("action")<> "add" then
	  
        Set objRssecurity = OpenDB("select * from Contentfather where ContentId=" & Request.Querystring("ID"))	
	    Do while not objRssecurity.eof
       if objRssecurity("FatherID") = 0 then
            CheckCategorySecuirty(objRssecurity("ContentID"))
        else
            CheckCategorySecuirty(objRssecurity("FatherID"))
       End if
		objRssecurity.movenext
            loop				    		
    CloseDB(objRssecurity)


		    Editmode = "True"
		Else
		    Editmode = "False"
		End If

 %>
 <div id="incontentform">

 
<form action="admin_content.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת דף תוכן - כללי</h1>
				<% ELSE 
				%>
					<h1>עריכת דף תוכן - כללי</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם הדף (H1):</p><img src="images/ask22.png" id="east" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" onkeyup ="Menusname.value = this.value;urltext.value = this.value;title.value = this.value;return true;"><%If Editmode = "True" Then print objRs("Name") End If %><% if request.querystring("name")<> "" Then print request.querystring("name") end if%></textarea>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>כותרת משנה (H2):</p><img src="images/ask22.png" id="Img1" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name2" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("Name2") End If %><% if request.querystring("name2")<> "" Then print request.querystring("name") end if%></textarea>
					  </div>
					  </td>
					</tr>
						<% If  Request.QueryString("action") <> "edit" Then %>

					<tr>
						<td align="right"><p>כתובת הדף:</p><img src="images/ask22.png" id="east2" original-title="תופיע בכתובת האתר אחרי הדומיין<br />מאוד חשוב לקידום בגוגל" /></td>
						<td align="right">
						<div style="position:relative;">
						<input class="goodinputshort required urltext" type="text" name="urltext" <%If Request.QueryString("action") = "copy" Then %> value="<% =objRs("urltext")%>"  <% End if %> <% if request.querystring("name")<> "" Then%> value="<%=request.querystring("name")%>"<% end if%> />
						</div>
						</td>
					</tr>
						<% End If %>
						 <tr>
					  <td align="right" valign="top"><div style="float:right;height:auto;padding:4px 0 0;width:100%;"><p>קטגוריה:</p><img src="images/ask22.png" id="east3" original-title="יש ללחוץ על החץ כדי לפתוח את עץ הקטגוריות <br>ניתן לבחור יותר מקטגוריה אחת לדף" /></div></td>
					  <td align="right" id="categorylist">
טוען...
		</td>
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
	oFCKeditor.Create "Text"

	%>

						</td>
					</tr>
					   <tr>
						<td width="15%" align="right"><p>שפה:</p><img src="images/ask22.png" id="east4" original-title="הדף יופיע רק שהאתר בשפה שתבחר" /></td>
						<td width="35%" align="right"><%
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
					<% If GetConfig("twitterusername") <> "" Then %> 
					<tr>
					 <td align="right"><p>שלח לטוויטר:</p><img src="images/ask22.png" id="east5" original-title="שליחה אוטומטית של כתובת ושם הדף לטוויטר" /></td>
				   <%If Editmode = "True" Then %>
					 <td align="right"><input id="sendtotwitter"  type="checkbox" dir="ltr" name="sendtotwitter" value="1"  onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					 
				   <% Else %> 
					 <td align="right"><input id="sendtotwitter2"  type="checkbox" dir="ltr" name="sendtotwitter" value="1" checked="yes" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					 </td>
				   <% End If %>
				   </tr>
				   <% End If %>
					<tr>
					 <td align="right"><p>פעיל:</p><img src="images/ask22.png" id="east6" original-title="חייב להיות פעיל כדי להופיע באתר." /></td>
					 <td align="right"><input id="Active"  type="checkbox" dir="ltr" name="Active" value="1" <%If Editmode = "True" Then %><% If objRs("Active")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					</td>
				   </tr>
					<tr>
			<td align="left" colspan="2">
			<input type="submit" name="save" style="margin:10px 0 0;cursor:not-allowed;" value="שמור" class="saveform" disabled="disabled" />
			<input type="submit" name="update" style="margin:10px 0 0 10px;cursor:not-allowed;" value="עדכן" class="saveform" disabled="disabled" /></td>
            
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
					<tr>
						<td colspan="2" align="right">שם הכפתור:<img src="images/ask22.png" id="east7" original-title="טקסט של הכפתור<br />כמו שיופיע בתפריט" /></td>
					</tr>
					<tr>
					<td colspan="2" align="right"><input class="goodinputlong" type="text" name="Menusname" <% If Editmode = "True" Then %> value="<% = objRs("Menusname") %>"<% End If %> />
					</td>
					</tr>
					<tr>			
						<td valign="top" width="40%" align="right">מופיע בתפריט:</td>
						<td align="right">
							<table class="pickmenu" cellpadding="0" cellspacing="0">
						  <%
							Set objRsMenuCategory = OpenDB("SELECT * FROM menu Where SiteID= " & SiteID)			
							Do Until objRsMenuCategory.Eof
								Selected = False
								If Editmode = "True" Then
									If objRs("Menus") <> "" Then
										IDArray = Split(objRs("Menus"), ",")
										
									For Each TheID In IDArray 							
										If Int(TheID) = objRsMenuCategory(0) Then
											Selected = True
										End If
									Next
								End If
								End If
								
								%>
								<tr>
									<td><input type="checkbox" name="menus<% = objRsMenuCategory(0) %>"<% If Editmode = "True" AND Selected Then%> checked="1"<% End If %> /></td>
									<td><% = objRsMenuCategory("Name") %></td>
								</tr>				
								<%
								objRsMenuCategory.MoveNext
							Loop						
											
						  objRsMenuCategory.Close
						  Set objRsMenuCategory= Nothing
						  %>

						 </table>	
						</td>
					  </tr>
                    <tr>
					 <td valign="top" width="40%" align="right">מופיע בתפריט בנים:</td>
					 <td align="right"><input id="Showinsonmenu"  type="checkbox" dir="ltr" name="Showinsonmenu" value="1" <%If Editmode = "True" Then %><% If objRs("Showinsonmenu")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
				   </tr>
                    <tr>
					 <td valign="top" width="40%" align="right">הכפתור לחיץ:</td>
					 <td align="right"><input id="Menuislink"  type="checkbox" dir="ltr" name="Menuislink" value="1" <%If Editmode = "True" Then %><% If objRs("Menuislink")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
				   </tr>

                    </table>
			</div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">תיאור קצר ותמונות</a></h3>
			        <div>
                    <table dir="rtl" class="leftstuff" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                       <% 
                        dim fs
                        set fs=Server.CreateObject("Scripting.FileSystemObject")
                           othertemplate = templatelocation & "admin/admin_content/shottext.html"
                            if fs.FileExists(Server.MapPath(othertemplate))=true then
                                 print getformlayout(GetUrl(othertemplate), SQL, "edit")
                            Else
                        %>       
                        <tr>
                            <td align="right">תיאור קצר על הדף<img src="images/ask22.png" id="east8" original-title="משמש לבלוגים ומאמרים<br />לתצוגת תקציר התוכן" /></td>
                        </tr>
                        <tr>
                            <td align="right"><textarea class="goodinputlongbig" rows="3" name="Shorttext" cols="5" class="" onKeyDown="formTextCounter(this.form.Shorttext,this.form.remLen_Shorttext,<% = Getconfig("maxinshortdescription") %>);" onKeyUp="formTextCounter(this,$('remLen_Shorttext'),<% = Getconfig("maxinshortdescription") %>);" wrap="soft"><%If Editmode = "True" then%><% if objRs("Shorttext") <> NUUL then print replace(objRs("Shorttext"),"<br >",VbCrLf ) End If %><%  End If %></textarea>
                                <input class="goodinputlong" readonly="readonly" type="text" name="remLen_Shorttext" size="5" 
                                    maxlength="3" value="<% = Getconfig("maxinshortdescription") %>" 
                                    style="width: 25px;clear:both;"></td>
                        </tr>
                        <% End if %>
                        <tr>
                            <td align="right">תמונה מייצגת לדף</td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" size="60" />
							<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("תמונה 2") %></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath2" name="Image2" <%If Editmode = "True" Then %> value="<% =objRs("Image2")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseServer('xFilePath2');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("תמונה 3") %></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath3" name="Image3" <%If Editmode = "True" Then %> value="<% =objRs("Image3")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseServer('xFilePath3');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("תמונה 4") %></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath4" name="Image4" <%If Editmode = "True" Then %> value="<% =objRs("Image4")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseServer('xFilePath4');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("תמונה 5") %></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath5" name="Image5" <%If Editmode = "True" Then %> value="<% =objRs("Image5")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseServer('xFilePath5');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("תמונה 6") %></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="Image6" name="Image6" <%If Editmode = "True" Then %> value="<% =objRs("Image6")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseServer('Image6');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("תמונה 7") %></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="Image7" name="Image7" <%If Editmode = "True" Then %> value="<% =objRs("Image7")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseServer('Image7');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("סרטון") %></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="flv" name="flv" <%If Editmode = "True" Then %> value="<% =objRs("flv")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseVideo('flv');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right"><% = SiteTranslate("Youtube") %></td>
                        </tr>
                        <tr>
                            <td align="right"><textarea name="Youtube" rows="3" cols="20" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("Youtube") End If %></textarea>
                            </td>
                        </tr>
                    </table>
			</div>
            <h3><a style="background:url(images/template.png) no-repeat right;" href="#">תבניות עיצוב</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table2">
                        <tr>
                            <td align="right">תבנית<img src="images/ask22.png" id="east9" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                            <td align="right">
					<% 
						Set objRsTemplate = OpenDB("SELECT * FROM template WHERE  SiteID = " & SiteID)
					%>					  
					<select class="goodselect validate" name="Template" size="1">
					<%
					Do While Not objRsTemplate.EOF
					%>
						<option value="<% = objRsTemplate("Id") %>" 
						<% If Editmode = "True" then 
						        If int(objRsTemplate("Id")) = int(objRs("Template"))  Then
						            Response.Write(" selected") 
						        End If
						    Else
                                If objRsTemplate("Defaultremplate") = True  Then
                                    Response.Write(" selected") 
						        End If
                            
                            End If%>
						    ><% = objRsTemplate("Name") %></option>
					<%	
					objRsTemplate.MoveNext 
					Loop
					%>
					</select>
					<% 
					objRsTemplate.Close
					%> 
					</select>
							</td>
                        </tr>
                         <tr>
                            <td align="right">תגיות</td>
                        </tr>

                         <tr>
                            <td align="right"><textarea name="Tags" rows="3" cols="10" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("Tags") End If %></textarea>
							</td>
                        </tr>

                    </table>
			</div>

			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">קידום במנועי חיפוש - SEO</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">כותרת הדף (Title)<img src="images/ask22.png" id="east10" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                            <td align="right"><textarea name="title" id="title" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("Title") End If %></textarea>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תיאור (Description)</td>
                        </tr>
                        <tr>
                            <td align="right"><textarea rows="3" name="Description" cols="10" class="goodinputlongbig" onKeyDown="formTextCounter(this.form.Description,this.form.remLen_Description,200);" onKeyUp="formTextCounter(this,$('remLen_Description'),200);" wrap="soft"><%If Editmode = "True" Then print objRs("Description") End If %></textarea><input readonly="readonly" type="text" class="goodinputlong" style="width:25px;clear:both" name="remLen_Description" size="1" maxlength="3" value="200">
							</td>
                        </tr>
                        <tr>
                            <td align="right">מילות מפתח (KeyWords)</td>
                        </tr>
                        <tr>
                            <td align="right"><textarea rows="3" name="Keywords" cols="10" class="goodinputlongbig" onKeyDown="formTextCounter(this.form.Keywords,this.form.remLen_Keywords,200);" onKeyUp="formTextCounter(this,$('remLen_Keywords'),200);" wrap="soft"><% If Editmode = "True" Then print objRs("Keywords") End If %></textarea><input readonly="readonly" type="text" class="goodinputlong" style="width:25px;clear:both" name="remLen_Keywords" size="1" maxlength="3" value="200">
							</td>
                        </tr>
                        <tr>
                            <td align="right">מופיע במפת אתר  <input id="Checkbox2"  type="checkbox" dir="ltr" name="showinsitemap" value="1" <%If Editmode = "True" Then %><% If objRs("showinsitemap")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" /></td>
                        </tr>
                        <tr>
                            <td align="right">מבוא לכתובת במפת אתר</td>
						</tr>
                        <tr>
							<td align="right"><input id="urlprefix" class="goodinputlong" type="text" name="urlprefix"  <%If Editmode = "True" Then %> value="<% =objRs("urlprefix")%>"   <% End if %> />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">קדימות (priority)</td>
                        </tr>
                        <tr>
                            <td align="right">
                                <select  class="goodselect" name="priority">
                                    <option value="1.0" <%If Editmode = "True" Then %><% If objRs("priority")= 1 Then Response.Write(" selected") %><% End If %>>1.0</option>
                                    <option value="0.9" <%If Editmode = "True" Then %><% If objRs("priority")= ".9" Then Response.Write(" selected") %><% End If %>>0.9</option>
                                    <option value="0.8" <%If Editmode = "True" Then %><% If objRs("priority")= ".8" Then Response.Write(" selected") %><% Else %>  selected <% End If %>>0.8</option>
                                    <option value="0.7" <%If Editmode = "True" Then %><% If objRs("priority")= ".7" Then Response.Write(" selected") %><% End If %>>0.7</option>
                                    <option value="0.6" <%If Editmode = "True" Then %><% If objRs("priority")= ".6" Then Response.Write(" selected") %><% End If %>>0.6</option>
                                    <option value="0.5" <%If Editmode = "True" Then %><% If objRs("priority")= ".5" Then Response.Write(" selected") %><% End If %>>0.5</option>
                                    <option value="0.4" <%If Editmode = "True" Then %><% If objRs("priority")= ".4" Then Response.Write(" selected") %><% End If %>>0.4</option>
                                    <option value="0.3" <%If Editmode = "True" Then %><% If objRs("priority")= ".3" Then Response.Write(" selected") %><% End If %>>0.3</option>
                                    <option value="0.2" <%If Editmode = "True" Then %><% If objRs("priority")= ".2" Then Response.Write(" selected") %><% End If %>>0.2</option>
                                    <option value="0.1" <%If Editmode = "True" Then %><% If objRs("priority")= ".1" Then Response.Write(" selected") %><% End If %>>0.1</option>
                                </select> 
                            </td>
                        </tr>
                    </table>
            </div>
			<h3><a style="background:url(images/secure.png) no-repeat right;" href="#">הגדרות אבטחה</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">רמת הרשאה<img src="images/ask22.png" id="east11" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                            <td align="right">
							<select class="goodselect" name="Userlevel" ID="Userlevel" size="1">
						<%
							z=1	
				 			Do Until z > 9
				 		 %>
							<option value="<% = z %>" <%If Editmode = "True" Then %> <% If  Int(objRs("Userlevel")) = z   Then Response.Write(" selected") %><% Else %><% If  z = int(GetConfig("defaultnewpagelevel"))   Then Response.Write(" Selected") %><% End If %>><% = z %></option>
							<% z=z+1
							Loop
							%>
					</select>
							</td>
                        </tr>
                        <tr>
                            <td align="right">תבנית טופס אבטחה</td>
                        </tr>
                        <tr>
                            <td align="right"><input id="UserSecurityTarget" type="text" dir="ltr" name="UserSecurityTarget"<% If Editmode = "True" Then %> value="<% = objRs("UserSecurityTarget") %>"<% Else %>value="<%=GetConfig("loginpage") %>"<% End If %> onchange="" maxlength="" value="" class="goodinputlong" format="" /></td>
                        </tr>
                    </table>
			</div>
           <h3><a style="background:url(images/banim.png) no-repeat right;" href="#">הגדרת בנים</a></h3>
				<div>
                   <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table3">
                     <tr>
                       <td align="right">הצג בנים<img src="images/ask22.png" id="east12" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                     </tr>
                     <tr>
                        <td align="right"><input id="Snosshow"  type="checkbox" name="Snosshow" value="1" <%If Editmode = "True" Then %><% If objRs("Snosshow")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" /></td>
                     </tr>
                     <tr>
                         <td align="right">תצוגת בנים VIP?</td>
                     </tr>
                     <tr>
                         <td align="right"><input id="Sonsvipmode"  type="checkbox" dir="ltr" name="Sonsvipmode" value=1 <%If Editmode = "True" Then %><% If objRs("Sonsvipmode")= "True" Then print " checked" %><% End If %>" style="float:right;" /></td>
                     </tr>

                     <tr>
                        <td align="right">תבנית עיצוב - בנים</td>
                    </tr>
                    <tr>
                       <td align="right">
                       <input dir="ltr" class="goodinputshort" id="Sonstemplate" name="Sonstemplate" type="text" size="60" <%If Editmode = "True" Then %> value="<% =objRs("Sonstemplate")%>" <%Else%> value="<% = SiteLayout %>sons.html" <% End if %> />
					   <input type="button" value="בחר תבנית" onclick="BrowseLayout('Sonstemplate');"/>
                    </tr>
                     <tr>
                        <td align="right">תבנית עיצוב - ראשונים</td>
                    </tr>
                    <tr>
                       <td align="right">
                       <input dir="ltr" class="goodinputshort" id="Sonsfirsttemplate" name="Sonsfirsttemplate" type="text" size="60" <%If Editmode = "True" Then %> value="<% =objRs("Sonsfirsttemplate")%>" <%Else%> value="<% = SiteLayout %>sons.html" <% End if %> />
					   <input type="button" value="בחר תבנית" onclick="BrowseLayout('Sonsfirsttemplate');"/>
                    </tr>
                    
                     <tr>
                        <td align="right">תבנית עיצוב - בלוק קטגורייה</td>
                    </tr>
                    <tr>
                       <td align="right">
                       <input dir="ltr" class="goodinputshort" id="Categorytemplate" name="Categorytemplate" type="text" size="60" <%If Editmode = "True" Then %> value="<% =objRs("Categorytemplate")%>" <%Else%> value="<% = SiteLayout %>sons.html" <% End if %> />
					   <input type="button" value="בחר תבנית" onclick="BrowseLayout('Categorytemplate');"/>
                    </tr>
                    <tr>
                       <td align="right">כמות בדף</td>
                    </tr>
                    <tr>
                       <td align="right"><input id="Sonsrecords" type="text" name="Sonsrecords" <%If Editmode = "True" Then %> value="<% =objRs("Sonsrecords")%>" <%Else%> value="100" <% End if %> class="goodinputshort" style="width:25px;" /></td>
                    </tr>
                    <tr>
                       <td align="right">כמות בבלוק קטגורייה</td>
                    </tr>
                    <tr>
                       <td align="right"><input id="Sonscategoryrecords" type="text" name="Sonscategoryrecords" <%If Editmode = "True" Then %> value="<% =objRs("Sonscategoryrecords")%>" <%Else%> value="0" <% End if %> class="goodinputshort" style="width:25px;" /></td>
                    </tr>
                    
                    <tr>
                       <td align="right">כמות ראשונים בדף</td>
                    </tr>
                    <tr>
                       <td align="right"><input id="Text1" type="Sonsfirstrecords" name="Sonsfirstrecords" <%If Editmode = "True" Then %> value="<% =objRs("Sonsfirstrecords")%>" <%Else%> value="0" <% End if %> class="goodinputshort" style="width:25px;" /></td>
                    </tr>
                    <tr>
                      <td align="right">להציג מספור</td>
                    </tr>
                    <tr>
                      <td align="right"><input id="Sonsshowpager"  type="checkbox" name="Sonsshowpager" value="1" <%If Editmode = "True" Then %><% If objRs("Sonsshowpager")= True Then print " checked=""yes""" %><% End If %>" /></td>
                    </tr>
                                    <tr>
				    <td align="right"> סדר הופעה בנים</td>
                    </tr>
                    <tr>
					<td>
					  <select  class="goodselect validate" name="Sonsorder">
					    <option value="ID Desc"<%If Editmode = "True" Then %> <% If objRs("Sonsorder") = "ID Desc" Then Response.Write(" selected") %><%End If %>>אחרון שהוכנס מופיע ראשון</option>
					    <option value="ID ASC" <%If Editmode = "True" Then %><% If objRs("Sonsorder") = "ID ASC" Then Response.Write(" selected") %><%End If %>>ראשון שהוכנס מופיע ראשון</option>
					    <option value="Name Desc"<%If Editmode = "True" Then %> <% If objRs("Sonsorder") = "Name Desc" Then Response.Write(" selected") %><%End If %>>כותרת ת-א</option>
					    <option value="Name ASC" <%If Editmode = "True" Then %><% If objRs("Sonsorder") = "Name ASC" Then Response.Write(" selected") %><%End If %>>כותרת א-ת</option>
					    <option value="Itemorder ASC"<%If Editmode = "True" Then %> <% If objRs("Sonsorder") = "Itemorder ASC" Then Response.Write(" selected") %><% Else%>  selected <%End If %>>מיון ידני לפי סדר מיון</option>
					    <option value="Itemorder Desc"<%If Editmode = "True" Then %> <% If objRs("Sonsorder") = "Itemorder Desc" Then Response.Write(" selected") %><%End If %>>מיון ידני מהאחרון לראשון</option>
					    <option value="NEWID()"<%If Editmode = "True" Then %> <% If objRs("Sonsorder") = "NEWID()" Then Response.Write(" selected") %><%End If %>>רנדומאלי</option>
					  </select>				  
					</td>
				  </tr>
                                    <tr>
				    <td align="right">סדר הופעה בבלוק קטגוריה</td>
                    </tr>
                    <tr>
					<td>
					  <select  class="goodselect validate" name="Categoryorder">
					    <option value="ID Desc"<%If Editmode = "True" Then %> <% If objRs("Sonsorder") = "ID Desc" Then Response.Write(" selected") %><%End If %>>אחרון שהוכנס מופיע ראשון</option>
					    <option value="ID ASC" <%If Editmode = "True" Then %><% If objRs("Sonsorder") = "ID ASC" Then Response.Write(" selected") %><%End If %>>ראשון שהוכנס מופיע ראשון</option>
					    <option value="Name Desc"<%If Editmode = "True" Then %> <% If objRs("Sonsorder") = "Name Desc" Then Response.Write(" selected") %><%End If %>>כותרת ת-א</option>
					    <option value="Name ASC" <%If Editmode = "True" Then %><% If objRs("Sonsorder") = "Name ASC" Then Response.Write(" selected") %><%End If %>>כותרת א-ת</option>
					    <option value="Itemorder ASC"<%If Editmode = "True" Then %> <% If objRs("Categoryorder") = "Itemorder ASC" Then Response.Write(" selected") %><%End If %>>מיון ידני לפי סדר מיון</option>
					    <option value="Itemorder Desc"<%If Editmode = "True" Then %> <% If objRs("Categoryorder") = "Itemorder Desc" Then Response.Write(" selected") %><%End If %>>מיון ידני מהאחרון לראשון</option>
					    <option value="NEWID()"<%If Editmode = "True" Then %> <% If objRs("Categoryorder") = "NEWID()" Then Response.Write(" selected") %><%End If %>>רנדומאלי</option>
					  </select>				  
					</td>
				  </tr>


                    </table>
                </div>
            <h3><a style="background:url(images/more_icon.png) no-repeat right;" href="#">שדות נוספים</a></h3>
				<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table1">
                       <tr>
                           <td align="right"><% = SiteTranslate("other1") %><img src="images/ask22.png" id="east13" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other1" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other1") End If %></textarea></td>
                         </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other2") %></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other2" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other2") End If %></textarea></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other3") %></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other3" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other3") End If %></textarea></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other4") %></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other4" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other4") End If %></textarea></td>
                         <tr>
                           <td align="right"><% = SiteTranslate("other5") %></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other5" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other5") End If %></textarea></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other6") %></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other6" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other6") End If %></textarea></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other7") %></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other7" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other7") End If %></textarea></td>
                        </tr>
                        <tr>
                           <td align="right"><% = SiteTranslate("other9") %></td>
                        </tr>
                        <tr>
                         <td align="right"><textarea name="other9" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("other9") End If %></textarea></td>
                        </tr>
                        </tr>
                    </table>
                 </div>

            </div>
            <div id="formsubmit">
            <input type="submit" name="save" style="margin:10px 0 0;cursor:not-allowed;" value="שמור" class="saveform" disabled="disabled" />
           <input type="submit" name="update" style="margin:10px 0 0 10px;cursor:not-allowed;" value="עדכן" class="saveform" disabled="disabled" />
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