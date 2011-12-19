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
        $('#east10').tipsy({ html: true });
    });
</script>
 <script type="text/javascript">
     jQuery(document).ready(function () {
         jQuery("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });
     });
</script>

<%
CheckSecuirty "News"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [News] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Lcase(Request.QueryString("format"))
    If  format  = "xls" Then
             Response.Clear
             Response.CodePage = 1255  
             Response.ContentType = "text/csv"
             Response.AddHeader "Content-Disposition", "filename=users.csv"
		         SQL = "SELECT * FROM News WHERE SiteID=" & SiteID & " ORDER BY id ASC"
	            Set objRs = OpenDB(SQL)
	                Do While Not objRs.EOF
                        for each f in objRs.Fields
                            print(f.Value & ",")
                        next
                            print  vbCrLf
                objRs.MoveNext
		            Loop
      Response.End
     End If
     
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "News-Disposition", "attachment;filename=News-"&filedate&".doc"
        Response.NewsType = "application/vnd.ms-word"
     End If
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

CheckSecuirty "News"
 %>   
    <div class="formtitle">
        <h1>ניהול חדשות</h1>
		<div class="admintoolber">
        <form action="admin_News.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_News.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_News.asp?format=xls"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_News.asp?format=doc"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_News.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		<td style="width:8%;"><a href="admin_news_positions.asp?type=content&action=edit" class="_dialog { width: 500, title:'יש לגרור את הדפים לפי הסדר הרצוי',modal:true,position:top}">סדר חדשות</a></td>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM News WHERE SiteID=" & SiteID 
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM News WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
    End If
        SQL = SQL & " ORDER By LangID ASC,Itemorder ASC"
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
		<td class="editlocalbig" style="text-align:right;"><div class="inlinetext" id="<% = objRs("Id") %>_Name"><%= Langname(objRs("LangID")) & "  " %>  <% = objRs("Name") %></div></td>
        <td><% = objRs("itemorder") %></td>
        <td><a href="admin_News.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_News.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_News.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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

			        Sql = "SELECT * FROM News WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("Name") = Trim(Request.Form("Name"))
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
					            objRs("CategoryID") = c
								objRs("Text") = Trim(Request.Form("Text"))	
								objRs("Link") = Request.Form("Link")
								objRs("image") = Request.Form("image")
								objRs("ContentLink") = Request.Form("ContentLink") 
								objRs("Itemorder") = objRs.RecordCount + 1 	
								objRs("Time") = Date()	
                                
                                If Request.Form("FromDate") <> "" Then	  							
	  							    objRs("FromDate") = Request.Form("FromDate")
	  							Else
	  							    objRs("FromDate") = NULL
	  						    End If
								
								If Request.Form("ToDate") <> "" Then
	  							    objRs("ToDate") = Request.Form("ToDate")
	  							Else
	  							    objRs("ToDate") = NULL
								End If	
								
								objRs("LangID") = Request.Form("LangID")
								objRs("Other1") = Request.Form("Other1")
								objRs("Other2") = Request.Form("Other2")
								objRs.Update
								Closedb(objRS)
									Response.Write("<br><br><p align='center'>חדשות נוספו בהצלחה. <a href='admin_news.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
					
                    If GetConfig("twitterusername") <> "" AND Request.Form("sendtotwitter") = 1 Then
			            Response.Buffer = True  
                        Set xml = Server.CreateObject("Microsoft.XMLHTTP")  
                        twitter_username = GetConfig("twitterusername")  
                        twitter_password = GetConfig("twitterpassword")   
                        url =  "http://" & LCase(Request.ServerVariables("HTTP_HOST"))
                        new_status = Trim(Request.Form("Name")& " <br> -" & url )  'change to your new status  
                        xml.Open "POST", "http://" & twitter_username & ":" & twitter_password & "@twitter.com/statuses/update.xml?status=" & server.URLencode(new_status), False  
                        xml.setRequestHeader "Content-Type", "content=text/html; charset=utf-8"  
                        xml.Send  
						Response.Write("<br><br><p align='center'>סטטוס עודכן בטוויטר. <a href='admin_news.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
                        Set xml = Nothing  
                     End If
   
							        Response.Write("<meta http-equiv='Refresh' content='3; URL=admin_news.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM News WHERE id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)
			            objRs("Name") = Trim(Request.Form("Name"))
				             objRs("Name") = Trim(Request.Form("Name"))
				            
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
					            objRs("CategoryID") = c
					            
								objRs("Text") = Trim(Request.Form("Text"))	
								objRs("Link") = Request.Form("Link")
								objRs("image") = Request.Form("image")
								objRs("ContentLink") = Trim(Request.Form("ContentLink"))
                                
                                If Request.Form("FromDate") <> "" Then	  							
	  							    objRs("FromDate") = Request.Form("FromDate")
	  							Else
	  							    objRs("FromDate") = NULL
	  						    End If
								
								If Request.Form("ToDate") <> "" Then
	  							    objRs("ToDate") = Request.Form("ToDate")
	  							Else
	  							    objRs("ToDate") = NULL
								End If	
								objRs("LangID") = Request.Form("LangID")
								objRs("Other1") = Request.Form("Other1")
								objRs("Other2") = Request.Form("Other2")
								objRs.Update
								Closedb(objRS)
									Response.Write("<br><br><p align='center'>חדשות נערך בהצלחה. <a href='admin_news.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_news.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM News WHERE id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("Name") = Trim(Request.Form("Name"))
				             
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
					            objRs("CategoryID") = c
					            
								objRs("Text") = Trim(Request.Form("Text"))	
								objRs("Link") = Request.Form("Link")
								objRs("image") = Request.Form("image")
								objRs("ContentLink") = Trim(Request.Form("ContentLink"))
								objRs("Itemorder") = objRs.RecordCount + 1 	
								objRs("Time") = Date()	
                               
                                If Request.Form("FromDate") <> "" Then	  							
	  							    objRs("FromDate") = Request.Form("FromDate")
	  							Else
	  							    objRs("FromDate") = NULL
	  						    End If
								
								If Request.Form("ToDate") <> "" Then
	  							    objRs("ToDate") = Request.Form("ToDate")
	  							Else
	  							    objRs("ToDate") = NULL
								End If	
								
								objRs("LangID") = Request.Form("LangID")
								objRs("Other1") = Request.Form("Other1")
								objRs("Other2") = Request.Form("Other2")
								objRs.Update
								Closedb(objRS)
									Response.Write("<br><br><p align='center'>חדשות נוספו בהצלחה. <a href='admin_news.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_news.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    Sql = "SELECT * FROM News WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
						Closedb(objRS)
						    Response.Write("<br><br><p align='center'>חדשות נמחקו בהצלחה. <a href='admin_news.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							'Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_news.asp?S=" & SiteID & "'>")
	        Case "positions"
			        Sql = "SELECT * FROM News WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
			                Do While Not objRs.EOF
            				    objRs("Itemorder") = Request.Form("ID" & objRs("id"))
				                objRs.MoveNext
			                Loop	
						Closedb(objRS)
			                    Response.Write("<br><br><p align='center'>מיקום  שונה בהצלחה. <a href='admin_news.asp'>לחץ להמשך</a>!</p>")
			                    Response.Write("<meta http-equiv='Refresh' content='2; URL=admin_news.asp'>")
	          
	            End Select
          '//////CACHE//////////
             deletecache "all"
          '//////CACHE//////////

		Else
			If  Request.QueryString("action") ="edit" Then
				SQL = "SELECT * FROM News WHERE id=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM News WHERE SiteID=" & SiteID   
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
<form action="admin_News.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="News2" name="News2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת חדשות</h1>
				<% ELSE 
				%>
					<h1>עריכת חדשות</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>כותרת:</p><img src="images/ask22.png" id="east" original-title="כותרת הידיעה" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputlong required" onkeyup ="Menusname.value = this.value;urltext.value = this.value;title.value = this.value;return true;"><%If Editmode = "True" Then print objRs("Name") End If %><% if request.querystring("name")<> "" Then print request.querystring("name") end if%></textarea>
					  </div>
					  </td>
					</tr>
					<tr>			
					<td width="20%" valign="top" align="right">מופיע ב:</td>
					<td width="80%" align="right">
                        <table>
						<tr>
						<td>
					  <%
						Set objRsCategory = OpenDB("SELECT * FROM NewsCategory Where SiteID= " & SiteID)			
						Do WHILE NOT objRsCategory.Eof
							Selected = False
							If Editmode = "True" Then
							    If objRs("CategoryID") <> "" Then
								    IDArray = Split(objRs("CategoryID"), ",")
									
								For Each TheID In IDArray 							
									If Int(TheID) = objRsCategory(0) Then
										Selected = True
									End If
								Next
							End If
							End If
							
							%>
							
								<input type="checkbox" name="category<% = objRsCategory(0) %>"<% If Editmode = "True" AND Selected Then%> checked="1"<% End If %> /> <% = objRsCategory("Name") %><br />
											
							<%
							objRsCategory.MoveNext
						Loop						
										
					  CloseDB(objRsCategory)
					  %>
						</td>
						</tr>
					 </table>	
					</td>
			      </tr>
					<tr>
                        <td colspan="2" align="right">תוכן הידיעה:</td>
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
	'if request.querystring("News")<> "" Then  oFCKeditor.Value=request.querystring("News") end if
	oFCKeditor.width="100%"
	oFCKeditor.height="370px"
	if Session("SiteLang") = "he-IL" Then
	oFCKeditor.config("DefaultLanguage")= "he"
	oFCKeditor.config("NewsLangDirection")= "rtl"
	Else
	oFCKeditor.config("DefaultLanguage")= "en"
	oFCKeditor.config("NewsLangDirection")= "ltr"
	End If
	oFCKeditor.Create "Text"

	%>

					</td>
				</tr>
                <% If GetConfig("twitterusername") <> "" AND Editmode = "False" Then %> 
                <tr>
                 <td width="20%" align="right">שלח לטוויטר</td>
                 <td width="80%" align="right"><input id="sendtotwitter"  type="checkbox" dir="ltr" name="sendtotwitter" value="1" checked="yes" onchange="" maxlength="" value="" style="float:right;" class="" format="" /></td>
               </tr>
               <% End If %>
               <tr>			
					<td align="right" valign="top">קישור ידני:</td>
					<td valign="top" align="right">
					  <input class="goodinputshort" type="text" dir="ltr" name="Link" size="50" maxlength="100"<%If Editmode = "True" Then %> value="<% = objRs("Link") %>"><% End if %> 
					</td>
			      </tr>
                  <tr>
					<td align="right" valign="top">קישור לכתבה באתר:</td>
					<td valign="top"align="right">
					<%
					    Set objRsNews = OpenDB("SELECT id, Name FROM Content WHERE SiteID= " & SiteID)
					%>					  
					    <select class="goodselect" name="ContentLink" size="1">
					   	<option value="">ללא</option>
					    <%
					    Do While Not objRsNews.EOF
					    %>											    
							<option value="<% = objRsNews("id") %>"><% = objRsNews("Name") %></option>
						<% objRsNews.MoveNext 
						     Loop
						%>
					  </select>
					  <% 
					  CloseDB(objRsNews)
					%>
					</td>					
			      </tr>
			      <tr>
					<td valign="top" align="right" height="20" width="20%">שפה:</td>
					    <td valign="top" height="20" align="right">
					        <select class="goodselectshort" name="LangID">
						<%
                       Set objRsLang = OpenDB("SELECT * FROM Lang ORDER BY langorder ASC")
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
                        <tr>
                            <td align="right">תמונה</td>
                        </tr>
                        <tr>
                            <td align="right">
							<input dir="ltr" class="goodinputshort" id="xFilePath" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" size="60" />
							<input type="button" class="goodinputbrows" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
						<img src="images/ask22.png" id="east10" original-title="תופיע בהתאם לתבנית תצוגת התוכן" />
							</td>
                        </tr>
                       

                    </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">תאריכי הופעה</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table1">
                       			      <tr>			
					<td valign="top" align="right">מ-תאריך</td>
					<td valign="top" align="right">
					  <input type="text" dir="ltr" name="FromDate" class="_date goodinputlong" <%If Editmode = "True" Then %> value="<% = objRs("FromDate") %>" <% End if %> size="10" maxlength="100" style="margin-left: 183px;width:100px;"></td>			 
			        </tr>
					<td valign="top" align="right">
					  <span lang="he"><font face="Arial" size="2">עד-תאריך</font></span></td>
					<td valign="top" height="20" align="right">
					  <font face="Arial">
					  <input type="text" dir="ltr" name="ToDate" <%If Editmode = "True" Then %> value="<% = objRs("ToDate") %>"<% End if %> class="_date goodinputlong" size="10" maxlength="100" style="margin-left: 183px;width:100px;"></font></td>
			      </tr>
 
                    </table>
                 </div>
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">שדות נוספים</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table2">
                       			      <tr>			
					<td valign="top" align="right"><% = SiteTranslate("Other1") %></td>
					<td valign="top" align="right">
					  <input type="text" dir="ltr" name="Other1" class="goodinputlong" <%If Editmode = "True" Then %> value="<% = objRs("Other1") %>" <% End if %> size="30" maxlength="100" style="margin-left: 183px;width:100px;"></td>			 
			        </tr>
					<td valign="top" align="right">
					  <span lang="he"><font face="Arial" size="2"><% = SiteTranslate("Other2") %></font></span></td>
					<td valign="top" height="20" align="right">
					  <font face="Arial">
					  <input type="text" dir="ltr" name="Other2" <%If Editmode = "True" Then %> value="<% = objRs("Other2") %>"<% End if %> class="goodinputlong" size="30" maxlength="100" style="margin-left: 183px;width:100px;"></font></td>
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