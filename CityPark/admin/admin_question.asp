<!--#include file="../config.asp"-->
<%
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
     If  format  = "pdf" Then
     %>
        <!--#include file="fpdf.asp"-->
    <%
        Set pdf=CreateJsObject("FPDF")
        pdf.CreatePDF()
        pdf.SetPath("fpdf/")
        pdf.SetFont "Arial","",16
        pdf.Open()
        pdf.AddPage()
        pdf.Cell 40,10,"format"
        pdf.Close()
        pdf.Output()
        End if

if format = "" then %><!--#include file="inc_admin_icons.asp"--><% End If
CheckSecuirty "nailsquestion"

If  Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM nailsquestion WHERE SiteID=" & SiteID & " ORDER BY ID DESC"
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM nailsquestion WHERE SiteID=" & SiteID & " AND question LIKE '%" & Request.form("search") & "%'" & "  ORDER BY ID DESC"
	End If

	Set objRs = OpenDB(SQL)
	    If False Then 'objRs.RecordCount = 0 Then
           print "אין רשומות"
	    Else
	        If Request.QueryString("records") = "" Then
	            records = 20
	        Else 
	            records = Request.QueryString("records")
	        End If
	objRs.PageSize = records

            if format = "" then %>
                <script type="text/javascript">
                    jQuery(document).ready(function() {
                        jQuery('#contentTable').tablesorter({ sortList: [[0, 0]], headers: { 3: { sorter: false }, 4: { sorter: false}} });
                    });
                </script>
                <div style="background:#F0F0F0;height:auto;border:1px solid #CCCCCC;margin:10px 15px;padding:15px;">
                <center>
                    <div style="width:99%;height:43px;background:#fff;line-height:43px;border:1px solid #ccc;">
                    <div style="width:150px;float:right;line-height:43px;text-align:right;padding-right:10px;color:#25BAE2;font-size:22px;">ניהול שאלונים</div>
                    <div style="width:40px;float:left;line-height:43px;"><a href="admin_question.asp?action=add"><img src="../admin/images/add.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></div>
                    <div style="width:40px;float:left;line-height:43px;"><a href="admin_question.asp?format=xls&<%Request.Querystring %>"><img src="../admin/images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
                    <div style="width:40px;float:left;line-height:43px;"><a href="admin_question.asp?format=doc&<%Request.Querystring %>"><img src="../admin/images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
                    <div style="float:left;line-height:43px;margin-left:10px;width:50px;">
                        <select style="float:right;font-family:arial;height:23px;margin-top:9px;width:50px;" name="records" onchange="location.href='admin_question.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
        	                <option value="10" <%if records = 10 then print "selected" End if%>>10</option>
        	                <option value="20" <%if records = 20 then print "selected" End if%>>20</option>
        	                <option value="50" <%if records = 50 then print "selected" End if%>>50</option>
        	                <option value="100" <%if records = 100 then print "selected" End if%>>100</option>
        	                <option value="1000" <%if records = 1000 then print "selected" End if%>>1000</option>
                        </select>
                    </div>
                    <div style="width:80px;float:left;line-height:43px;">רשומות לדף:</div>
                    <div style="height:42px;line-height:42px;float:left;">
                         <form action="admin_question.asp?action=show&mode=search" method="post">
                    <div style="line-height:42px;width:500px;">
                    <div style="float:right;height:23px;margin-right:10px;">שאלה:</div>
                         <input type="text" dir="rtl" name="search" style="width:150px;float:right;margin-top:9px;height:17px;margin-right:10px;font-family:arial;">
                        <input type="submit" value="חפש" name="searchbtn" style="float:right;margin-right:10px;margin-top:9px;font-family:arial;">
                    </div>
                        </form>
                    </div>
                    </div>
    		   <%  End if 'format%>        
<table id="contentTable" class="tablesorter"  align="center" dir="rtl" cellpadding="0" cellspacing="0" border="0" width="99%" style="border:1px solid #ccc;margin-top:10px;background:#fff;border-bottom:0px;">
      	            <!--<tr valign="top">
		            <td style="border-bottom:1px solid #ccc;height:25px;vertical-align:middle;" align="center" colspan="8">
	      	            <table width="200" cellspacing="0" align="center">
		  		            <% If Not objRs.PageCount = 0 Then
				                    If Len(Request.QueryString("page")) > 0 Then
				                        objRs.AbsolutePage = Request.QueryString("page")
				                       Else
				                        objRs.AbsolutePage = 1
				                    End If
					            End If
				            %>
							 <tr>
							            <td width="166"><font size="2">
							                <img border="0" src="../admin/images/rightadmin.gif" width="16" height="16" align="left"></font>
							             </td>
							            <td width="177"><font size="2" face="Arial">
							                <div align="center">
	                        <% If objRs.AbsolutePage > 1 Then %>
					                        <a href="admin_question.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_question.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
					                         <font color="#808080">דף הבא</font></a></font>
					                     </td>
							                <td width="167"><font size="2" face="Arial">
							                <img border="0" src="../admin/images/leftadmin.gif" width="16" height="16" align="right"></font>
						                </td>
						            </tr>
					            </table>
			               </td>
					         
		            </tr>-->
<thead>
    <tr style="background:#eee;">
        <th style="line-height:20px;" align="center" width="73">ID</th>
        <th style="padding-right:10px;" align="right">שאלה</th>
        <th style="padding-right:10px;" align="right">סה"כ תשובות</th>
        <td style="padding-right:10px;" align="right">תשובה1</td>
        <td style="padding-right:10px;" align="right">תשובה2</td>
        <td style="padding-right:10px;" align="right">תשובה3</td>
        <td style="padding-right:10px;" align="right">תשובה4</td>
        <td style="padding-right:10px;" align="right">תשובה5</td>
        <td style="padding-right:10px;" align="right">תשובה6</td>
        <%if format = "" then %>
        <td style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">ערוך</td>
        <td style="border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">מחק</td>
        <% End If ' format %>
    </tr>
</thead>
<tbody>
				<% HowMany = 0
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize

				%>
    <tr onmouseover="Mark(this);" onmouseout="Unmark(this);">
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% = objRs("ID") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><a href="admin_questionanswer.asp?ID=<% = objRs("ID") %>"><% = objRs("question") %></a></td>
        <%Set objRsTotal = OpenDB("SELECT COUNT(*) AS Total FROM [nextwww].[dbo].[nailsanswers] WHERE questionid = " & objRs("id")& " AND SiteID =" & SiteID)%>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><%print objRsTotal("Total") %></td>
        <%Set objRsTotal = OpenDB("SELECT COUNT(*) AS Total1 FROM [nextwww].[dbo].[nailsanswers] WHERE questionid = " & objRs("id")& " AND answer = 1")%>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% = objRs("answer1")& "-<small>" & objRsTotal("Total1")&" הצבעות </small>" %></td>
       <%Set objRsTotal = OpenDB("SELECT COUNT(*) AS Total2 FROM [nextwww].[dbo].[nailsanswers] WHERE questionid = " & objRs("id")& " AND answer = 2")%>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% = objRs("answer2")& "-<small>" & objRsTotal("Total2")&" הצבעות " %></td>
       <%Set objRsTotal = OpenDB("SELECT COUNT(*) AS Total3 FROM [nextwww].[dbo].[nailsanswers] WHERE questionid = " & objRs("id")& " AND answer = 3")%>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% If objRs("answer3")<> "" Then print objRs("answer3")& "-<small>" & objRsTotal("Total3")&" הצבעות </small>" End If%></td>
       <%Set objRsTotal = OpenDB("SELECT COUNT(*) AS Total4 FROM [nextwww].[dbo].[nailsanswers] WHERE questionid = " & objRs("id")& " AND answer = 4")%>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% If objRs("answer4")<> "" Then print objRs("answer4")& "-<small>" & objRsTotal("Total4")&" הצבעות </small>" End If %></td>
       <%Set objRsTotal = OpenDB("SELECT COUNT(*) AS Total5 FROM [nextwww].[dbo].[nailsanswers] WHERE questionid = " & objRs("id")& " AND answer = 5")%>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% If objRs("answer5")<> "" Then print objRs("answer5")& "-<small>" & objRsTotal("Total5")&" הצבעות </small>" End If %></td>
       <%Set objRsTotal = OpenDB("SELECT COUNT(*) AS Total6 FROM [nextwww].[dbo].[nailsanswers] WHERE questionid = " & objRs("id")& " AND answer = 6")%>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% If objRs("answer6")<> "" Then print objRs("answer6")& "-<small>" & objRsTotal("Total6")&" הצבעות </small>" End If %></td>

        <%if format = "" then %>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="admin_question.asp?ID=<% = objRs("ID") %>&action=edit"><img src="/sites/cms/layout/images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td style="border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="admin_question.asp?ID=<% = objRs("ID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="/sites/cms/layout/images/delete.gif" border="0" alt="מחק" /></a></td>
        <% End If ' format %>
    </tr>	
    			<% HowMany = HowMany + 1
				objRs.MoveNext
		  		Loop
				%>
</tbody>
  	            <tr valign="top">
		            <td style="border-bottom:1px solid #ccc;height:25px;vertical-align:middle;" align="center" colspan="8">
	      	            <table width="300" cellspacing="0" align="center">
		  		            <% If Not objRs.PageCount = 0 Then
				                    If Len(Request.QueryString("page")) > 0 Then
				                        objRs.AbsolutePage = Request.QueryString("page")
				                       Else
				                        objRs.AbsolutePage = 1
				                    End If
					            End If
				            %>
					            <tr>
							            <td width="166"><font size="2">
							                <img border="0" src="../admin/images/rightadmin.gif" width="16" height="16" align="left"></font>
							             </td>
							            <td width="177"><font size="2" face="Arial">
							                <div align="center">
	                        <% If objRs.AbsolutePage > 1 Then %>
					                        <a href="admin_question.asp?page=<% = objRs.AbsolutePage - 1 %>&records=<% = records %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_question.asp?page=<% = objRs.AbsolutePage + 1 %>&records=<%= records %>" style="text-decoration: none"><% 	End If%>
					                         <font color="#808080">דף הבא</font></a></font>
					                     </td>
							                <td width="167"><font size="2" face="Arial">
							                <img border="0" src="../admin/images/leftadmin.gif" width="16" height="16" align="right"></font>
						                </td>
						            </tr>
					            </table>
			               </td>
		            </tr>
	            </tr>
			            </table>
			            </form>
		            </td>
	            </tr>
            </table>
</div><font face="Arial" size="2"><br>
</font>
<%	objRs.Close 
End If
Else

	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	        Case "add"
	        Editmode= "False"
			        Sql = "SELECT * FROM nailsquestion"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("question") = Trim(Request.Form("question"))
				             objRs("answer1") = Trim(Request.Form("answer1"))
				             objRs("answer2") = Trim(Request.Form("answer2"))
				             objRs("answer3") = Trim(Request.Form("answer3"))
				             objRs("answer4") = Trim(Request.Form("answer4"))
				             objRs("answer5") = Trim(Request.Form("answer5"))
				             objRs("answer6") = Trim(Request.Form("answer6"))
				             objRs("active") = Request.Form("active")
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>שאלה נוספה בהצלחה. <a href='admin_question.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_question.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM nailsquestion WHERE id=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
				             objRs("question") = Trim(Request.Form("question"))
				             objRs("answer1") = Trim(Request.Form("answer1"))
				             objRs("answer2") = Trim(Request.Form("answer2"))
				             objRs("answer3") = Trim(Request.Form("answer3"))
				             objRs("answer4") = Trim(Request.Form("answer4"))
				             objRs("answer5") = Trim(Request.Form("answer5"))
				             objRs("answer6") = Trim(Request.Form("answer6"))
				             objRs("active") = Request.Form("active")
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>שאלה נערכה בהצלחה. <a href='admin_question.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_question.asp?S=" & SiteID & "'>")

	        Case "delete"
				    Sql = "SELECT * FROM nailsquestion WHERE id=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>שאלה נמחקה בהצלחה. <a href='admin_question.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_question.asp?S=" & SiteID & "'>")
	        

	            End Select
		Else
			'If Request.Querystring("ID") = NULL AND Request.QueryString("action") ="edit" Then' OR Request.Querystring("ID") = "" AND Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM nailsquestion WHERE id=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			' End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM nailsquestion WHERE SiteID=" & SiteID   
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
<form action="admin_question.asp?mode=doit<% If Editmode Then %>&ID=<% = objRs("id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2">
<div id="formcontainer">
<center>
    <div id="formheader">
    <% If  Request.QueryString("action") = "add" Then %>
        <div id="formtitle">הוספת שאלה</div>
    <% ELSE %>
        <div id="formtitle">עריכת שאלה</div>
    <% End If %>
        <div id="formsave"><input type="submit" value="" style="width:40px;height:42px;border:0px;background:url(/sites/cms/layout/images/save.gif) no-repeat;" class=""  /></div>
        <div id="formcancel"><img src="/sites/cms/layout/images/cancel.gif" border="0" alt="" /></div>
    </div>
    <div id="formcontent">
        <div id="formrightfields">
            <table dir="rtl" cellpadding="5" cellspacing="0" width="99%" style="margin-top:10px;">
                <tr>
                    <td width="75" align="right" valign="top">שאלה</td>
                    <td align="right" valign="top"><input id="question" type="text" name="question"<%If Editmode = "True" Then %> value="<% =objRs("question")%>"<% End if %> style="width:200px;" class="required" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תשובה1</td>
                    <td align="right" valign="top"><input id="answer1" type="text" name="answer1"<%If Editmode = "True" Then %> value="<% =objRs("answer1")%>"<% End if %> style="width:200px;" class="required" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תשובה2</td>
                    <td align="right" valign="top"><input id="answer2" type="text" name="answer2"<%If Editmode = "True" Then %> value="<% =objRs("answer2")%>"<% End if %> style="width:200px;" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תשובה3</td>
                    <td align="right" valign="top"><input id="answer3" type="text" name="answer3"<%If Editmode = "True" Then %> value="<% =objRs("answer3")%>"<% End if %> style="width:200px;" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תשובה4</td>
                    <td align="right" valign="top"><input id="answer4" type="text" name="answer4"<%If Editmode = "True" Then %> value="<% =objRs("answer4")%>"<% End if %> style="width:200px;" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תשובה5</td>
                    <td align="right" valign="top"><input id="answer5" type="text" name="answer5"<%If Editmode = "True" Then %> value="<% =objRs("answer5")%>"<% End if %> style="width:200px;" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">תשובה6</td>
                    <td align="right" valign="top"><input id="answer6" type="text" name="answer6"<%If Editmode = "True" Then %> value="<% =objRs("answer6")%>"<% End if %> style="width:200px;" /></td>
                </tr>
                <tr>
                    <td width="75" align="right" valign="top">פעיל</td>
                    <td align="right" valign="top"><input id="active" type="checkbox" name="active" value="1"<%If Editmode = "True" AND objRs("active")= "True" Then print " Checked" End if %> style="width:200px;" /></td>
                </tr>
            </table>
        </div>

            <div id="formsubmit">
            <input type="submit" value="שמירה" style="padding:0 10px;" class=""  />
            </div>
        </div>
        <div id="clearboth"></div>
    </div>
</center>
</div>
	</form>
	<script type="text/javascript">
	    new Validation('content2', { stopOnFirst: true });
	</script>
<br />
<%	
End if
End if
End if
%>