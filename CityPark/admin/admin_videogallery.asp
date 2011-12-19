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
CheckSecuirty "videogallery"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [videogallery] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
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

CheckSecuirty "videogallery"
 %>   
    <div class="formtitle">
        <h1>ניהול גלריות וידיאו</h1>
		<div class="admintoolber">
        <form action="admin_videogallery.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&string=<%=Request.form("search") %>" method="post">
               <p>חיפוש:</p>
			   <select name="Active">
						<option value="1">פעיל</option>
						<option value="0">לא פעיל</option>
                </select>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_videogallery.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_videogallery.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_videogallery.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_videogallery.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th class="recordid">ID</th>
		<th style="width:43%;text-align:right;padding-right:40px;cursor:pointer;">שם הדף</th>
		<th style="width:8%;"><a href="javascript:void(0)" onclick="window.open('admin_videogallery_positions.asp?type=videogallery&action=edit','welcome','width=600,height=50000')">סדר בנים</a></th>
        <th>ערוך</th>
        <th>שכפל דף</th>
        <th>פעיל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<%
Function bringrecrds(id)
If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
           '     SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 5)  ORDER By ItemOrder ASC"
                SQL = "SELECT * FROM [Content]  WHERE SiteID=" & SiteID & " AND (Contenttype = 5)  ORDER By ItemOrder ASC"
     If Request.QueryString("mode") = "search" then
               ' SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE"
                SQL = "SELECT * FROM [Content] WHERE"
               ' SQL = SQL & "(Contentfather.FatherID = " & Request.form("category") & ")"
            If Request.form("text") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("text") & "%'"
             End If
                SQL = SQL & " AND Active=" & Int(Request.form("Active"))
                SQL = SQL &  " AND (Content.SiteID=" & SiteID & ") AND (Contenttype = 5)  ORDER By ItemOrder ASC"
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
                                SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRsg("Id") & ") AND (Contentfather.FatherID = " & Request.form("category") & ") AND Name LIKE '%" & Request.form("text") & "%' AND Active=" & Request.form("Active") & " AND Content.SiteID=" & SiteID & " AND (Contenttype = 1) ORDER By ItemOrder ASC"
                        Else
                                SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRsg("Id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1) ORDER By ItemOrder ASC"
                        End If
                                Set objRs2 = OpenDB(SQL2) 


            	%>
    <tr id="node-<%= objRsg("Id") %>" <% if id <> 0 Then %>class="child-of-node-<%= id %>"<% end if %>>
        <td><%= objRsg("Id")  %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("Id") %>_Name"><% = objRsg("Name") %></div></td>
        <td class="editlocal"><div class="inlinetext" id="<% = objRsg("id") %>_Itemorder"><%= objRsg("Itemorder") %></div>
        <!--
		<% If objRs2.RecordCount > 1 Then %>
        <a href="javascript:void(0)" onclick="window.open('admin_videogallery_positions.asp?type=content&ID=<% = objRsg("Id") %>&action=edit','welcome','width=600,height=50000')" class="_dialog"><img src="images/order.gif" border="0" alt="סדר בנים" /></a>
        <% End If %>
		-->
        </td>
        <td><a href="admin_videogallery.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_videogallery.asp?ID=<% = objRsg("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td><% If objRsg("Active")= 1 Then %><img style="border:0px;" src="images/active.png" border="0" alt="" /><% Else %><img style="border:0px;" src="images/notactive.png" border="0" alt="" /><% End if %></td>
        
        <td style="border-left:0px;"><%If objRs2.RecordCount < 1 Then %><a href="admin_videogallery.asp?ID=<% = objRsg("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a> <% End If %></td>
       
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
	   SqlCategory2 = "SELECT  TOP 1 * FROM Content WHERE SiteID= " & SiteID & " AND (Contenttype = 1) ORDER BY Id DESC"
		    Set objRsCategory2 = OpenDB(SqlCategory2)
             If objRsCategory2.RecordCount = 0 then
                LastNews = 0
             Else
                LastNews = objRsCategory2("ItemOrder")
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
				             objRs("Contenttype") = 5
				             objRs("urltext") = Trim(Request.Form("urltext"))
				             objRs("Name") = Request.Form("Name")
								objRs("Text") = Request.Form("Text")
								objRs("ShortText") = Trim(Request.Form("ShortText"))	
								objRs("LangID") = Request.Form("LangID")
								objRs("Tags") = Trim(Request.Form("Tags"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Userlevel") = Request.Form("Userlevel")	
								objRs("UserSecurityTarget") = Request.Form("UserSecurityTarget")	
								objRs("Title") = Trim(Request.Form("Title"))	
								objRs("Template") = Trim(Request.Form("Template"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("showinsitemap") = Request.Form("showinsitemap")
								objRs("priority") = Request.Form("priority")
								objRs("urlprefix") = Request.Form("urlprefix")
								objRs("Datecreated") = Now()
								objRs("other1") =Request.Form("other1") 'ספרייה
								objRs("other2") =Request.Form("other2") 'תבנית
								objRs("other3") =Request.Form("other3") 'חלק עליון
								objRs("other4") =Request.Form("other4") 'חלק תחתון
								objRs("other5") =Request.Form("other5") 'להציג את כל הספרייה

							'	objRs("Snosshow") = Request.Form("Snosshow")
							'	objRs("Sonstemplate") = Request.Form("Sonstemplate")
							'	objRs("Sonsrecords") = Request.Form("Sonsrecords")
							'	objRs("Sonsshowpager") = Request.Form("Sonsshowpager")

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

                            Response.Redirect("admin_videogallery.asp?notificate=גלרייה נוספה בהצלחה")
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

			                     objRs("Name") = Trim(Request.Form("Name"))
								objRs("Text") = Request.Form("Text")
								objRs("ShortText") = Trim(Request.Form("ShortText"))	
								objRs("LangID") = Request.Form("LangID")
								objRs("Tags") = Trim(Request.Form("Tags"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Userlevel") = CInt(Request.Form("Userlevel"))	
								objRs("UserSecurityTarget") = Request.Form("UserSecurityTarget")	
								objRs("Title") = Trim(Request.Form("Title"))	
								objRs("Template") = Request.Form("Template")
								objRs("Description") = Trim(Request.Form("Description"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("showinsitemap") = Request.Form("showinsitemap")
								objRs("priority") = Request.Form("priority")
								objRs("urlprefix") = Request.Form("urlprefix")
								objRs("other1") =Request.Form("other1") 'ספרייה
								objRs("other2") =Request.Form("other2") 'תבנית
								objRs("other3") =Request.Form("other3") 'חלק עליון
								objRs("other4") =Request.Form("other4") 'חלק תחתון
								objRs("other5") =Request.Form("other5") 'להציג את כל הספרייה

                            '    objRs("Snosshow") = Request.Form("Snosshow")
							'	objRs("Sonstemplate") = Request.Form("Sonstemplate")
							'	objRs("Sonsrecords") = Request.Form("Sonsrecords")
							'	objRs("Sonsshowpager") = Request.Form("Sonsshowpager")
                                
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

								objRs.Update
								objRs.Close
                        
                        ExecuteRS("DELETE FROM [Contentfather] WHERE ContentID = " & Request.QueryString("ID"))
								
								For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
										ExecuteRS("INSERT INTO [Contentfather] (ContentID, FatherID, SiteID) VALUES (" & Request.QueryString("ID") & ", " & Request.Form(x) & ", " & SiteID & ");")
									End If
								Next


                            Response.Redirect("admin_videogallery.asp?notificate=גלרייה נערכה בהצלחה")

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
                                        CheckCategorySecuirty(Request.Form(x))
						    		End If
								Next

				             objRs.Addnew
				             objRs("SiteID") = SiteID
                             objRs("Contenttype") = 5
				             objRs("urltext") = Trim(Request.Form("urltext"))
				             objRs("Name") = Trim(Request.Form("Name"))
								objRs("Text") = Request.Form("Text")
								objRs("ShortText") = Trim(Request.Form("ShortText"))	
								objRs("LangID") = Request.Form("LangID")
								objRs("Tags") = Trim(Request.Form("Tags"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs("Image3") = Trim(Request.Form("Image3"))
								objRs("Image4") = Trim(Request.Form("Image4"))
								objRs("Image5") = Trim(Request.Form("Image5"))
								objRs("Userlevel") = Request.Form("Userlevel")	
								objRs("UserSecurityTarget") = Request.Form("UserSecurityTarget")	
								objRs("Title") = Trim(Request.Form("Title"))	
								objRs("Template") = Trim(Request.Form("Template"))
								objRs("Description") = Trim(Request.Form("Description"))
								objRs("Keywords") = Trim(Request.Form("Keywords"))
								objRs("showinsitemap") = Request.Form("showinsitemap")
								objRs("priority") = Request.Form("priority")
								objRs("urlprefix") = Request.Form("urlprefix")
								objRs("Datecreated") = Now()
								objRs("other1") =Request.Form("other1") 'ספרייה
								objRs("other2") =Request.Form("other2") 'תבנית
								objRs("other3") =Request.Form("other3") 'חלק עליון
								objRs("other4") =Request.Form("other4") 'חלק תחתון
								objRs("other5") =Request.Form("other5") 'להציג את כל הספרייה

                          '      objRs("Snosshow") = Request.Form("Snosshow")
							'	objRs("Sonstemplate") = Request.Form("Sonstemplate")
							'	objRs("Sonsrecords") = Request.Form("Sonsrecords")
							'	objRs("Sonsshowpager") = Request.Form("Sonsshowpager")
								
                                
                                For Each r in Request.Form
						        If LCase(Mid(r, 1, Len("category"))) = "category" Then
							        If Request.Form(r) = "on" Then
								        If c = "" Then
									        c = Mid(r, Len("category") + 1)
								        Else
									        c = c & "," & Mid(r, Len("category") + 1)
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
								objRs.Update
								objRs.Close

                               For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
										ExecuteRS("INSERT INTO [Contentfather] (ContentID, FatherID, SiteID) VALUES (" & Request.QueryString("ID") & ", " & Request.Form(x) & ", " & SiteID & ");")
									End If
								Next

									Response.Write("<br><br><p align='center'>תוכן נוסף בהצלחה. <a href='admin_videogallery.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_videogallery.asp?S=" & SiteID & "'>")
                        End If

	        
	        Case "delete"
				    Sql = "SELECT * FROM Content WHERE Id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)

	                            For Each x In Request.Form
									If Mid(x, 1, Len("category_")) = "category_" Then
                                        CheckCategorySecuirty(Request.Form(x))
						    		End If
								Next

			            objRs.Delete
			            objRs.Close
                         ExecuteRS("DELETE FROM [Contentfather] WHERE ContentID = " & Request.QueryString("ID"))

						    Response.Write("<br><br><p align='center'>גלרייה נמחקה בהצלחה. <a href='admin_videogallery.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_videogallery.asp?S=" & SiteID & "'>")
	        
	        

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
<form action="admin_videogallery.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת גלריית וידיאו</h1>
				<% ELSE 
				%>
					<h1>עריכת גלריית וידיאו</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם גלרייה (H1):</p><img src="images/ask22.png" id="east" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" onkeyup ="Menusname.value = this.value;urltext.value = this.value;title.value = this.value;return true;"><%If Editmode = "True" Then print objRs("Name") End If %><% if request.querystring("name")<> "" Then print request.querystring("name") end if%></textarea>
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
					  <td align="right" valign="top"><div style="float:right;height:auto;padding:4px 0 0;width:100%;"><p>קטגוריה:</p><img src="images/ask22.png" id="east3" original-title="ניתן לבחור יותר מקטגוריה אחת לדף" /></div></td>
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
									Set objRsCategory = OpenDB("SELECT * FROM Content Where id <>" &  objRs("id") & " AND SiteID= " & SiteID & " AND (Contenttype = 1) ORDER BY id ASC")			
                                    else
									Set objRsCategory = OpenDB("SELECT * FROM Content Where SiteID= " & SiteID & " AND (Contenttype = 1) ORDER BY id ASC")			
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
										    .attr("class", "buttonadd")
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
									I = 0
									Do Until objRsPerCategory.Eof
										Print "addCategory(" & I & ", " & objRsPerCategory("FatherId") & ", " & LCase(NOT I + 1 = objRsPerCategory.RecordCount) & ");"
										
										I = I + 1
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
					 <td align="right"><p>פעיל:</p><img src="images/ask22.png" id="east6" original-title="חייב להיות פעיל כדי להופיע באתר." /></td>
					 <td align="right"><input id="Active"  type="checkbox" dir="ltr" name="Active" value="1" <%If Editmode = "True" Then %><% If objRs("Active")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" />
					</td>
				   </tr>
					<tr>
						<td align="left" colspan="2"><input type="submit" value="שמור" class="saveform"  /></td>
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
					<td colspan="2" align="right"><input class="goodinputlong" type="text" name="Menusname"<% If Editmode = "True" Then %> value="<% = objRs("Menusname") %>"<% End If %> />
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
                    </table>
			</div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">תיאור קצר ותמונות</a></h3>
			        <div>
                    <table dir="rtl" class="leftstuff" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">תיאור קצר על הדף<img src="images/ask22.png" id="east8" original-title="משמש לבלוגים ומאמרים<br />לתצוגת תקציר התוכן" /></td>
                        </tr>
                        <tr>
                            <td align="right"><textarea class="goodinputlongbig" rows="3" name="ShortText" cols="5" class="" onKeyDown="formTextCounter(this.form.ShortText,this.form.remLen_ShortText,<% = Getconfig("maxinshortdescription") %>);" onKeyUp="formTextCounter(this,$('remLen_ShortText'),<% = Getconfig("maxinshortdescription") %>);" wrap="soft"><%If Editmode = "True" Then print objRs("ShortText") End If %></textarea>
                                <input class="goodinputlong" readonly="readonly" type="text" name="remLen_ShortText" size="5" 
                                    maxlength="3" value="<% = Getconfig("maxinshortdescription") %>" 
                                    style="width: 25px;clear:both;"></td>
                        </tr>
                        <tr>
                            <td align="right">תמונה מייצגת לדף</td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" size="60" />
							<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
							</td>
                        </tr>
                    </table>
			</div>
            <h3><a style="background:url(images/template.png) no-repeat right;" href="#">תבניות עיצוב</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table2">
                        <tr>
                            <td align="right">תבנית הדף<img src="images/ask22.png" id="Img3" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                            <td align="right">
					<% 
						Set objRsTemplate = OpenDB("SELECT * FROM template WHERE  SiteID = " & SiteID)
					%>					  
					<select class="goodselect" name="Template" size="1">
					<%
					Do While Not objRsTemplate.EOF
					%>
						<option value="<% = objRsTemplate("Id") %>" 
						<% If Editmode = "True" then 
						        If int(objRsTemplate("Id")) = int(objRs("Template"))  Then
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
                            <td align="right">תבנית<img src="images/ask22.png" id="east9" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath1" name="other2" <%If Editmode = "True" Then %> value="<% =objRs("other2")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('xFilePath1');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">חלק עליון<img src="images/ask22.png" id="Img1" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath2" name="other3" <%If Editmode = "True" Then %> value="<% =objRs("other3")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('xFilePath2');"/>
							</td>
                        </tr>
                        <tr>
                            <td align="right">חלק תחתון<img src="images/ask22.png" id="Img2" original-title="יש לבחור את תבנית<br />תצוגת התוכן של הדף" /></td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath3" name="other4" <%If Editmode = "True" Then %> value="<% =objRs("other4")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" class="goodinputbrows" onclick="BrowseLayout('xFilePath3');"/>
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
							i=1	
				 			Do Until i > 9
				 		 %>
							<option value=<% = i %> <%If Editmode = "True" Then %> <% If  objRs("Userlevel") = i   Then Response.Write(" selected") %><% Else %><% If  i = GetConfig("defaultnewpagelevel")   Then Response.Write(" Selected") %><% End If %>><% = i %></option>
							<% i=i+1
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
                        <td align="right">תבנית עיצוב - בנים</td>
                    </tr>
                    <tr>
                       <td align="right">
                       <input dir="ltr" class="goodinputshort" id="xFileName" name="Sonstemplate" type="text" size="60" <%If Editmode = "True" Then %> value="<% =objRs("Sonstemplate")%>" <%Else%> value="sons.html" <% End if %> />
					   <input type="button" value="בחר תבנית" onclick="BrowseLayout('xFileName');"/>
                    </tr>
                    <tr>
                       <td align="right">כמות בדף</td>
                    </tr>
                    <tr>
                       <td align="right"><input id="Sonsrecords" type="text" name="Sonsrecords" <%If Editmode = "True" Then %> value="<% =objRs("Sonsrecords")%>" <%Else%> value="3" <% End if %> class="goodinputshort" style="width:25px;" /></td>
                    </tr>
                    <tr>
                      <td align="right">להציג מספור</td>
                    </tr>
                    <tr>
                      <td align="right"><input id="Sonsshowpager"  type="checkbox" name="Sonsshowpager" value="1" <%If Editmode = "True" Then %><% If objRs("Sonsshowpager")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" /></td>
                    </tr>
                    </table>
                </div>
            <h3><a style="background:url(images/more_icon.png) no-repeat right;" href="#">שדות נוספים</a></h3>
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