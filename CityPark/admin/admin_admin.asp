<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type="text/javascript">
    $(document).ready(function () {

        if ($("#AllModuls").is(':checked'))
            $(".all_moduls").hide();
        else
            $(".all_moduls").show();


        $("#AllModuls").change(function () {
            if ($(this).is(':checked'))
                $(".all_moduls").hide();
            else
                $(".all_moduls").show();
        });

        if ($("#AllCategory").is(':checked'))
            $(".all_category").hide();
        else
            $(".all_category").show();


        $("#AllCategory").change(function () {
            if ($(this).is(':checked'))
                $(".all_category").hide();
            else
                $(".all_category").show();
        });

    });
  </script>
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
    });

</script>
<script type='text/javascript'>
    $(function () {
        $('#east').tipsy({ html: true });
        $("#categorylist").load("admin_ajax2.asp?ajax=5&id=<%=Request.QueryString("id")%>&action=<%=Request.QueryString("action")%>",function() {sb=true;sc=true;sa = true;initTree();});

    });
</script>

<%
CheckSecuirty "admin"
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

CheckSecuirty "admin"
 %>   
    <div class="formtitle">
        <h1>ניהול הרשאות מנהל</h1>
		<div class="admintoolber">
        <form action="admin_admin.asp?action=show&mode=search" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_admin.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_admin.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_admin.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_admin.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		SQL = "SELECT * FROM admin WHERE SiteID=" & SiteID
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM admin WHERE SiteID=" & SiteID & " AND Name LIKE '%" & Request.form("search") & "%'"
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
        <td><%= objRs("Id")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("Id") %>_Name"><% = objRs("Name") %></span></td>
        <td><a href="admin_admin.asp?ID=<% = objRs("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_admin.asp?ID=<% = objRs("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_admin.asp?ID=<% = objRs("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
			      Set objRsUrl = OpenDB("SELECT * FROM admin WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM admin Where SiteID=" & SiteID
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("Username") = Request.Form("Username")
								objRs("Password") = md5(Request.Form("Password"))
								objRs("Email") = Trim(Request.Form("Email"))
								    objRs("Admin9Level") = int(Request.Form("Admin9Level"))
							 If GetSession("AdminLevel")= 0 then 
							    If Request.Form("AllModuls") = "on" Then
                                    objRs("Tables") = "*"
                                Else
                            	    x = 0
								        For Each line in Split(GetUrl("availableTables.asp"), vbCrLf)					
									        If Request.Form("table_" & x) = "on" Then
										        Tables = Tables & "," & Split(line, ":")(1)
									        End If 
									x = x + 1
								            Next
								    objRs("Tables") = Mid(Tables, 2)
							    End If
							End If
'------------------------------------
                                
                            	    For Each x In Request.Form
									If Mid(x, 1, Len("Uategory_")) = "Uategory_" Then
                                    	 If Request.Form(x) = "on" Then
											Categorys = Categorys & "," & mid(x,16)
									     End If
									 End If
								Next
								        objRs("Categorys") = Mid(Categorys, 2)
                                        objRs.update
								        objRs.Close
									Response.Write("<br><br><p align='center'>מנהל נוסף בהצלחה. <a href='admin_admin.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_admin.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM admin WHERE ID=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
						   if int(Request.Form("Admin9Level"))< int(GetSession("AdminLevel")) Then
						   	print "אין הרשאה מספיקה"
                                response.end
                            End if
								objRs("Name") = Trim(Request.Form("Name"))
								objRs("Username") = Request.Form("Username")
						'			if trim(request.form("password")) <> "" Then objRs("Password") = md5(Request.Form("Password"))
								objRs("Email") = Trim(Request.Form("Email"))
								objRs("Admin9Level") = int(Request.Form("Admin9Level"))
							 If GetSession("AdminLevel")= 0 then 
							   
                               
                               
                                If Request.Form("AllModuls") = "on" Then
                                    objRs("Tables") = "*"
                                Else
                            	    x = 0
								        For Each line in Split(GetUrl("availableTables.asp"), vbCrLf)					
									        If Request.Form("table_" & x) = "on" Then
										        Tables = Tables & "," & Split(line, ":")(1)
									        End If 
									x = x + 1
								            Next
								objRs("Tables") = Mid(Tables, 2)
							    End If
							  End If
'------------------------------------
                                    For Each x In Request.Form
									If Mid(x, 1, Len("Uategory_")) = "Uategory_" Then
                                    	 If Request.Form(x) = "on" Then
											Categorys = Categorys & "," & mid(x,16)
									     End If
									 End If
								Next
								        objRs("Categorys") = Mid(Categorys, 2)
                               objRs.update
								objRs.Close
									Response.Write("<br><br><p align='center'>מנהל נערך בהצלחה. <a href='admin_admin.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_admin.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    Sql = "SELECT * FROM admin WHERE id=" & Request.QueryString("ID") & " AND SiteID=" & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>מנהל נמחק בהצלחה. <a href='admin_admin.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' users='0; URL=admin_admin.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM admin WHERE ID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM admin WHERE SiteID=" & SiteID   
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
<form action="admin_admin.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("Id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת מנהל</h1>
				<% ELSE 
				%>
					<h1>עריכת מנהל</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם:</p><img src="images/ask22.png" id="east" original-title="שם התפריט משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
					  <textarea name="Name" cols="3" class="goodinputshort required"><%If Editmode = "True" Then print objRs("Name") End If %></textarea>
					  </div>
					  </td>
					</tr>
                     <tr>
						<td width="20%" align="right"><p>כינוי:</p><img src="images/ask22.png" id="Img1" original-title="שם התפריט משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<input class="goodinputshort" type="text"<%If Editmode = "True" Then %> value="<%=objRs("Username") %>" <% end if %>dir="ltr" name="Username" size="50" maxlength="100" class="required">
					</td>			      
			    </tr>	
                               <%If Editmode = "False" Then %>
   
			    <tr>
						<td width="20%" align="right"><p>סיסמא:</p><img src="images/ask22.png" id="Img2" original-title="שם התפריט משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<input class="goodinputshort" type="text"<%If Editmode = "True" Then %>  value="<%=EnDecrypt(objRs("Password"),encryptkey ) %>" <% end if %>dir="ltr" name="Password" size="50" maxlength="100" class="required">
                </td>			      
			    </tr>
                  <% end if %>	
			    <tr>
						<td width="20%" align="right"><p>Email:</p><img src="images/ask22.png" id="Img3" original-title="שם התפריט משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<input class="goodinputshort" type="text" dir="ltr" <%If Editmode = "True" Then %>  value="<%=objRs("Email") %>" <% end if %>name="Email" size="50" maxlength="100" class="required email">
                    </td>			      
			    </tr>	
			    <tr>
					<td colspan="2" align="right">
					
					<ul style="width:150px;float:right;list-style-type:none;padding:0px 0px 0px 40px;border-left:1px dotted #2D2D2D">
						<li style="font-size:16px;font-weight:bold;color:#2D2D2D;padding:0px 0px 10px 0px;">מודולים:<img src="images/ask22.png" id="Img4" original-title="שם התפריט משמש להתמצאות בלבד" /></li>
						<li style="font-weight:bold;color:#2D2D2D;padding:0px 0px 10px 0px;"><input type="checkbox" id="AllModuls"name="AllModuls" <%If Editmode = "True" Then %><% If objRs("Tables") = "*" Then %>checked="selected"<% End If %><% end if %>  />כל המודולים</li>	
					<% If GetSession("AdminLevel")= 0 then %>
						<%
							x = 0
							For Each line in Split(GetUrl("availableTables.asp"), vbCrLf)
								y = Split(line, ":")
							If 	Editmode = "True" then
								Selected = False
								If objRs("Tables") = "*" Then
									Selected = True
								Else
									For Each k In Split(y(1), ",")	
										For Each r In Split(objRs("Tables"), ",")
											If k = r Then
												Selected = True
												Exit For
											End If
										Next
									Next
								End If
							Else
									Selected = True
                            End If
								%>
							<li class="all_moduls"><input type="checkbox" name="table_<% = x %>" <% If Selected Then %>checked="selected"<% End If %> /> <% = y(0) %></li>
						
								<%
								x = x + 1
							Next
						%>
					<% End If %>
                    </ul>
					<ul style="width:350px;float:right;list-style-type:none;padding:0px 0px 0px 40px;border-left:1px dotted #2D2D2D">
						<li style="font-size:16px;font-weight:bold;color:#2D2D2D;padding:0px 0px 10px 0px;">קטגוריות:<img src="images/ask22.png" id="Img5" original-title="שם התפריט משמש להתמצאות בלבד" align="right;" /></li>
						<li style="font-weight:bold;color:#2D2D2D;padding:0px 0px 10px 0px;">
                        <table width="100%">
                        <tr>
								<td align="right" valign="top"><div style="float:right;height:auto;padding:4px 0 0;width:100%;"><p>קטגוריה:</p><img src="images/ask22.png" id="east3" original-title="יש ללחוץ על החץ כדי לפתוח את עץ הקטגוריות <br>ניתן לבחור יותר מקטגוריה אחת לדף" /></div></td>
								<td align="right" id="categorylist">
											טוען...
								</td>
							</tr>	
                        </table>
					</ul>
					</td>
			    </tr>	
	
			    <tr>
						<td width="20%" align="right"><p>רמת הרשאה:</p><img src="images/ask22.png" id="Img6" original-title="שם התפריט משמש להתמצאות בלבד" /></td>
						<td width="80%" align="right">
					<select class="goodselect" style="width: 60px;" name="Admin9Level" ID="Admin9Level" size="1">
						<%
							x= GetSession("AdminLevel") 
				 			Do Until x > 9
				 		 %>
							<option value=<% = x %><%If Editmode = "True" Then %><% If objRs("Admin9Level") = x Then Response.Write(" selected") %><% End If %>><% = x %></option>
							<% x=x+1
							Loop
							%>
					</select>
				</td>			      
			    </tr>	
				</table>
				</div>
			</div><div id="left">
<div id="formcontainer">
<center>
    <div id="formcontent">
        <div id="formleftfields">
		    <div style="width:100%;" id="accordion">
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">עתידי</a></h3>
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