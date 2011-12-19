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
    });
</script>

<%
CheckSecuirty "menu"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Content] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Content-Disposition", "attachment;filename=content-"&filedate&".xls"
        Response.ContentType = "application/ms-excel" 
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
        <h1>ניהול  כפתורים</h1>
		<div class="admintoolber">
        <form action="admin_menu.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %>&string=<%=Request.form("search") %>" method="post">
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
						<option value="0" <% If objRsCategory("Name") = "עמוד אב" Then Response.Write(" selected") %>>עמוד אב</option>
                	<%
                            Do While Not objRsCategory.EOF
					    
                        %>
						<option value="<% = objRsCategory("Id") %>" <% If Request.form("category")= "" Then%> <% If objRsCategory("Name") = "כפתור האתר" Then Response.Write(" selected") %><% Else %><% If int(objRsCategory("Id")) = int(Request.Form("category")) Then Response.Write(" selected") %><% End if %>><% = objRsCategory("Name") %></option>
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
			<p><a href="admin_menu.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת כפתור חדש" title="הוספת כפתור חדש" /></a></p>
			<p><a href="admin_menu.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_menu.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_menu.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th>ID</th>
		<th style="width:40%;text-align:right;padding-right:40px;cursor:pointer;">שם הכפתור</th>
		<th style="width:8%;"><a href="admin_content_positions.asp?type=menu&action=edit" class="_dialog { width: 500, title:'יש לגרור את הדפים לפי הסדר הרצוי',modal:true,position:top}">סדר כפתורים</a></th>
        <th>סדר בנים</th>
        <th>ערוך</th>
        <th>פעיל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
Function bringrecrds(id)
If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
                SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (datalength(Menus)>0)  ORDER By Menusorder ASC"
     If Request.QueryString("mode") = "search" then
                SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE"
                SQL = SQL & "(Contentfather.FatherID = " & Request.form("category") & ")"
            If Request.form("text") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("text") & "%'"
             End If
                SQL = SQL & " AND Active=" & Int(Request.form("Active"))
                SQL = SQL &  " AND (Content.SiteID=" & SiteID & ") AND (datalength(Menus)>0)  ORDER By Menusorder ASC"
    End If
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	        objRsg.PageSize = Session("records")
                HowMany = 0
                fatherID =  objRsg("Id")
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize
                        If Request.QueryString("mode") = "search" then
                                SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRsg("Id") & ") AND (Contentfather.FatherID = " & Request.form("category") & ") AND Name LIKE '%" & Request.form("text") & "%' AND Active=" & Request.form("Active") & " AND Content.SiteID=" & SiteID & " AND (datalength(Menus)>0) ORDER By Menusorder ASC"
                        Else
                                SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRsg("Id") & ") AND Content.SiteID=" & SiteID & " AND (datalength(Menus)>0) ORDER By Menusorder ASC"
                        End If
                                Set objRs2 = OpenDB(SQL2) 


            	%>
    <tr id="node-<%= objRsg("Id") %>" <% if id <> 0 Then %>class="child-of-node-<%= id %>"<% end if %>>
        <td><%= objRsg("Id")  %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("Id") %>_Name"><% = objRsg("Name") %></div></td>
		<td class="editlocal"><div class="inlinetext" id="<%= objRsg("id") %>_Menusorder"><%= objRsg("Menusorder") %></div>
        <!--
		<%If objRs2.RecordCount > 1 Then %>
        <a href="javascript:void(0)" onclick="window.open('admin_content_positions.asp?type=menu&ID=<% = objRsg("Id") %>&action=edit','welcome','width=600,height=50000')"><img src="images/order.gif" border="0" alt="סדר בנים" /></a>
        <% End If %>
		-->
        </td>
		<td>
		<% If objRs2.RecordCount > 1 Then %>
        <a href="admin_content_positions.asp?type=menu&ID=<% = objRsg("Id") %>&action=edit" class="_dialog { width: 500, title:'יש לגרור את הדפים לפי הסדר הרצוי',modal:true,position:top}"><img src="images/order.gif" border="0" alt="סדר כפתורים" /></a>
        <% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/order.gif" border="0" alt="סדר בנים" />
		<% End If %>
        </td>
        <td><a href="admin_menu.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><% If objRsg("Active")= 1 Then %><img style="border:0px;" src="images/active.png" border="0" alt="" /><% Else %><img style="border:0px;" src="images/notactive.png" border="0" alt="" /><% End if %></td>
        
        <td style="border-left:0px;"><%If objRs2.RecordCount < 1 Then %><a href="admin_menu.asp?ID=<% = objRsg("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק כפתור זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a>
		<% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/delete.gif" border="0" alt="מחק" />
		<% End If %>
		</td>
       
    </tr>	
 <%		
                    If objRs2.RecordCount > 0 Then
                            bringrecrds(objRsg("Id"))
                    End If
           CloseDB(objRs2)
                
                
                 HowMany = HowMany + 1
                objRsg.MoveNext
		  		Loop
                objRsg.Close
                End If
    End If
End Function
	bringrecrds(0)	%>
</tbody>
</table></div>
<%	 
Else
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	        Case "add"
	   SqlCategory2 = "SELECT  TOP 1 * FROM Content WHERE SiteID= " & SiteID & " AND (datalength(Menus)>0) ORDER BY Id DESC"
		    Set objRsCategory2 = OpenDB(SqlCategory2)
             If objRsCategory2.RecordCount = 0 then
                LastNews = 0
             Else
                LastNews = objRsCategory2("Menusorder")
             end If
            CloseDB(objRsCategory2)

	        Editmode= "False"
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
                                        CheckCategorySecuirty(Request.Form(x))
						    		End If
								Next


				             objRs.Addnew
				             objRs("SiteID") = SiteID
                            objRs("Name") = Request.Form("Menusname")
                            objRs("urltext") = Trim(Request.Form("urltext"))
							objRs("LangID") = Request.Form("LangID")
                            objRs("Contenttype") = 3
				           


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
								objRs("Menusorder") = CInt(LastNews) + 1
								    If Request.Form("Showinsonmenu")<> 1 Then
								        objRs("Showinsonmenu") = 0
								    Else
								        objRs("Showinsonmenu") = 1
								    End If
 
                                    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If
          '//////CACHE//////////
             deletecache "all"
          '//////CACHE//////////
								objRs.Update
								objRs.Close
                                Set objRs = OpenDB("Select TOP 1 Id From Content Order By Id Desc")
								cId = objRs("Id")
								CloseDb(objRs)
                                For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
										ExecuteRS("INSERT INTO [Contentfather] (ContentID, FatherID, SiteID) VALUES (" & cId & ", " & Request.Form(x) & ", " & SiteID & ");")
						    		End If
								Next

									Response.Write("<br><br><p align='center'>כפתור נוסף בהצלחה. <a href='admin_menu.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_menu.asp?S=" & SiteID & "'>")
                        End If
	       Case "edit"
	       	 Editmode= "True"
	       

	            
				    Sql = "SELECT * FROM Content WHERE Id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)


	                            For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                        CheckCategorySecuirty(Request.Form(x))
						    		End If
								Next

				            objRs("Name") = Request.Form("Menusname")
                         If  Request.QueryString("action") <> "edit" Or objRs("Contenttype")=3 OR Session(SiteID & "AdminLevel") = 0 Then 
                            objRs("urltext") = Trim(Request.Form("urltext"))
                         End if
							objRs("LangID") = Request.Form("LangID")


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
								    If Request.Form("Showinsonmenu")<> 1 Then
								        objRs("Showinsonmenu") = 0
								    Else
								        objRs("Showinsonmenu") = 1
								    End If

                                    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If
								objRs.Update
						 If  objRs("Contenttype")=3 Then 
                                    ExecuteRS("DELETE FROM [Contentfather] WHERE ContentID = " & Request.QueryString("ID"))
								
								    For Each x In Request.Form
									    If Mid(x, 1, Len("category_")) = "category_" Then
										    ExecuteRS("INSERT INTO [Contentfather] (ContentID, FatherID, SiteID) VALUES (" & Request.QueryString("ID") & ", " & Request.Form(x) & ", " & SiteID & ");")
									    End If
								    Next
                                End If
									Response.Write("<br><br><p align='center'>כפתור נערך בהצלחה. <a href='admin_menu.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_menu.asp?S=" & SiteID & "'>")
                            objRs.Close
	        Case "delete"
				    Sql = "SELECT * FROM Content WHERE Id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)

	                     objRs("Menus") =""
          '//////CACHE//////////
             deletecache "all"
          '//////CACHE//////////
								objRs.Update
								objRs.Close

						    Response.Write("<br><br><p align='center'>כפתור נמחק בהצלחה. <a href='admin_menu.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_menu.asp?S=" & SiteID & "'>")
	        
	        

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
<form action="admin_menu.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת כפתור</h1>
				<% ELSE 
				%>
					<h1>עריכת כפתור </h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
						<td align="right">שם הכפתור:</td>
						<td align="right"><input class="goodinputlong" type="text" name="Menusname"<% If Editmode = "True" Then %> value="<% = objRs("Menusname") %>"<% End If %> />
						<img src="images/ask22.png" id="Img1" original-title="טקסט של הכפתור<br />כמו שיופיע בתפריט" /></td>
					</tr>
						<% If  Request.QueryString("action") <> "edit" Or objRs("Contenttype")=3 OR Session(SiteID & "AdminLevel") = 0 Then %>

					<tr>
						<td align="right"><p>כתובת (URL):</p><img src="images/ask22.png" id="east2" original-title="תופיע בכתובת האתר אחרי הדומיין<br />מאוד חשוב לקידום בגוגל" /></td>
						<td align="right">
						<div style="position:relative;">
						<input class="goodinputshort required" type="text" name="urltext" <%If Request.QueryString("action") = "edit" Then %> value="<% =objRs("urltext")%>"  <% End if %>  />
						</div>
						</td>
					</tr>
						<% End If 
                         If Request.QueryString("action") = "add" Or objRs("Contenttype") = 3 then
                        %>
						 <tr>
					  <td align="right" valign="top"><div style="float:right;height:auto;padding:4px 0 0;width:100%;"><p>כפתור אב:</p><img src="images/ask22.png" id="east3" original-title="ניתן לבחור יותר מקטגוריה אחת לדף" /></div></td>
					  <td align="right">
                      <div id="selectCategories"></div>
                            <script type="text/javascript">
						
							 addCategory =  function(id, selected, del) {
								jQuery(function($) {
									var selectBoxContainer = $("<div />")
										.attr("id", "selectBoxContainer_" + id)
										.appendTo($("#selectCategories"));
										
									var selectBox = $("<select class='goodselect' />")
										.attr("name", "category_" + id)
										.appendTo(selectBoxContainer);
									
									<% 
                                    If Editmode="True" then
									Set objRsCategory = OpenDB("SELECT * FROM Content Where id <>" &  objRs("id") & " AND SiteID= " & SiteID & " AND (datalength(Menus)>0) ORDER BY id ASC")			
                                    else
									Set objRsCategory = OpenDB("SELECT * FROM Content Where SiteID= " & SiteID & " AND (datalength(Menus)>0) ORDER BY id ASC")			
                                    End if
									%>
									var op1 = $('<option />')
										.val('<% = 0 %>')
										.text('ראשי');
										
									
									<%	
									Do Until objRsCategory.Eof
                                    %>	
									if (0 == selected)
										op1.attr("selected", "selected");
																
									var op = $('<option />')
										.val('<% = objRsCategory(0) %>')
										.text('<% = Replace(objRsCategory("Name"), "'", "\'") %>');
										
									if (<% = objRsCategory(0) %> == selected)
										op.attr("selected", "selected");
										
                                    op1.appendTo(selectBox);
									op.appendTo(selectBox);

									<%
										objRsCategory.MoveNext
									Loop
								
									CloseDb(objRsCategory)
									%>
									

									if(del)
										$("<button type=\"button\"></button>")	
											.text("")
											.attr("class", "buttondelete")
											.click(function() { 
												selectBoxContainer.remove();
											})						
											.appendTo(selectBoxContainer);								
									else {
										$("<button type=\"button\"></button>")	
											.text("")
										    .attr("class", "buttonadd2")
											.click(function() { 
												addCategory(id + 1);
												
												$(this)
													.text("")
													.attr("class", "buttondelete")
													.unbind("click")
													.click(function() {
														selectBoxContainer.remove();
												});
											})
											.appendTo(selectBoxContainer);
                                     }
								});
							};
							
							jQuery(document).ready(function() {
								<%
								If EditMode Then
									Set objRsPerCategory = OpenDb("Select * From [Contentfather] Where ContentId = " & objRs(0))
									x = 0
									Do Until objRsPerCategory.Eof
										Print "addCategory(" & x & ", " & objRsPerCategory("FatherId") & ", " & LCase(NOT x + 1 = objRsPerCategory.RecordCount) & ");"
										
										x = x + 1
										objRsPerCategory.MoveNext
									Loop
									
									CloseDB(objRsPerCategory)
								Else
								%>
									addCategory(0, -1);
								<%
								End If
								%>
							});
						</script>
						
					</td>
					</tr>
                    <% end If %>

					   <tr>
						<td width="15%" align="right"><p>שפה:</p><img src="images/ask22.png" id="east4" original-title="הכפתור יופיע רק שהאתר בשפה שתבחר" /></td>
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
					<tr>
					 <td align="right"><p>פעיל:</p><img src="images/ask22.png" id="east7" original-title="חייב להיות פעיל כדי להופיע באתר." /></td>
					 <td align="right"><input id="Active"  type="checkbox" dir="ltr" name="Active" value="1" <%If Editmode = "True" Then %><% If objRs("Active")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					</td>
				   </tr>
					<tr>			
						<td align="right">מופיע בתפריט:</td>
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
					        <td width="15%" align="right">מופיע בתפריט בנים:</td>
					        <td width="35%" align="right"><input id="Showinsonmenu"  type="checkbox" dir="ltr" name="Showinsonmenu" value="1" <%If Editmode = "True" Then %><% If objRs("Showinsonmenu")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
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
				<h3><a style="background:url(images/link_img.png) no-repeat right;" href="#">עתידי</a></h3>
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