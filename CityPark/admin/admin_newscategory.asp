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
<%
CheckSecuirty "News"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [News] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 
 format = Request.QueryString("format")
    If  format  = "xls" Then
            Response.Clear
            Response.CodePage = 1255  
            Response.ContentType = "text/csv"
            Response.AddHeader "Content-Disposition", "filename=newscategory.csv"
		        SQL = "SELECT * FROM newscategory WHERE SiteID=" & SiteID & " ORDER BY id ASC"
	            Set objRs = OpenDB(SQL)
	                Do While Not objRs.EOF
                        for each f in objRs.Fields
                            print(f.Value & ",")
                        next
                            print  vbCrLf
                objRs.MoveNext
		            Loop
     End If
     If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "News-Disposition", "attachment;filename=News-"&filedate&".doc"
        Response.NewsType = "application/vnd.ms-word"
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

CheckSecuirty "News"
 %>   
    <div class="formtitle">
        <h1>ניהול בלוקי חדשות</h1>
		<div class="admintoolber">
        <form action="admin_newscategory.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_newscategory.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_newscategory.asp?format=xls"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_newscategory.asp?format=doc"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_newscategory.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		<th style="width:60%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM Newscategory WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM Newscategory WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
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
        <td><a href="admin_newscategory.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_newscategory.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_newscategory.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM newscategory  WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM NewsCategory"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("Header") = Request.Form("Header")
								objRs("Template") = Request.Form("Template")
								objRs("Footer") = Request.Form("Footer")
								objRs("LangID") = Request.Form("LangID")
                                objRs("OrderType") = Request.Form("OrderType")	
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>בלוק חדשות נוסף בהצלחה. <a href='admin_NewsCategory.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_NewsCategory.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM newscategory WHERE id =" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
				                objRs("Name") = Trim(Request.Form("Name"))
								objRs("Header") = Request.Form("Header")
								objRs("Template") = Request.Form("Template")
								objRs("Footer") = Request.Form("Footer")
								objRs("LangID") = Request.Form("LangID")	
                                objRs("OrderType") = Request.Form("OrderType")	
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>בלוק חדשות נערכה בהצלחה. <a href='admin_NewsCategory.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_NewsCategory.asp?S=" & SiteID & "'>")

	        
	        
	        Case "delete"
				    Sql = "SELECT * FROM newscategory WHERE id =" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>בלוק חדשות נמחקה בהצלחה. <a href='admin_NewsCategory.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' users='0; URL=admin_NewsCategory.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM newscategory WHERE id =" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM newscategory WHERE SiteID=" & SiteID   
			End If
				Set objRs = OpenDB(SQL)
					If Session("Level") > 3 Then 
						Response.Write("<br><br><p align='center'>אין לך הרשאה לבצע פעולה זאת <a href='default.asp'>נסה שנית</a>!</p>")
	Else
		
		If Request.QueryString("action")<> "add" then
		    Editmode = "True"
		Else
		    Editmode = "False"
		End If

 %>
 <div id="incontentform">
<form action="admin_newscategory.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="News2" name="News2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת בלוק חדשות</h1>
				<% ELSE 
				%>
					<h1>עריכת בלוק חדשות</h1>
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
                    <td align="right" valign="top">תבנית</td>
                        <td align="right" valign="top">
                         <input dir="ltr" style="width: 210px;" id="xFilepath" name="Template" type="text" size="60" <%If Editmode = "True" Then %> value="<% =objRs("Template")%>" <%Else%> value="runnews.html" <% End if %> />
					     <input type="button" value="בחר תבנית" onclick="BrowseLayout('xFilepath');"/>
                        </td>
                    </tr>
                    <tr>
                    <td align="right" valign="top">חלק עליון</td>
                        <td align="right" valign="top">
                         <input dir="ltr" style="width: 210px;" id="xFilepath2" name="Header" type="text" size="60" <%If Editmode = "True" Then %> value="<% =objRs("Header")%>" <%Else%> value="runnewsheader.html" <% End if %> />
					     <input type="button" value="בחר תבנית" onclick="BrowseLayout('xFilepath2');"/>
                        </td>
                    </tr>
                    <tr>
                    <td align="right" valign="top">חלק תחתון</td>
                        <td align="right" valign="top">
                         <input dir="ltr" style="width: 210px;" id="xFilepath3" name="Footer" type="text" size="60" <%If Editmode = "True" Then %> value="<% =objRs("Footer")%>" <%Else%> value="Runnewsbottom.html" <% End if %> />
					     <input type="button" value="בחר תבנית" onclick="BrowseLayout('xFilepath3');"/>
                        </td>
                    </tr>
                        <tr>
				            <td align="right">סדר מיון</td>
					<td align="right">
					  <select style="width:180px;" name="OrderType">
					    <option value="ItemOrder DESC"<%If Editmode = "True" Then %> <% If objRs("OrderType") = "ItemOrder DESC" Then Response.Write(" selected") %><%End If %>>אחרון שהוכנס מופיע ראשון</option>
					    <option value="ItemOrder ASC" <%If Editmode = "True" Then %><% If objRs("OrderType") = "ItemOrder ASC" Then Response.Write(" selected") %><%End If %>>ראשון שהוכנס מופיע ראשון</option>
					    <option value="NEWID()"<%If Editmode = "True" Then %> <% If objRs("OrderType") = "NEWID()" Then Response.Write(" selected") %><%End If %>>רנדומאלי</option>
					  </select>				  
					</td>
				  </tr>
			      <tr>
					<td valign="top" align="right" height="20" width="20%">שפה:</td>
					    <td valign="top" height="20" align="right">
					        <select style="width: 150px;" name="LangID">
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