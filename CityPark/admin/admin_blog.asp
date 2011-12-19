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


if format = "" then %>  
<!--#include file="inc_admin_icons.asp"-->

<% 
End If
CheckSecuirty "Blog"

If  Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM Blog WHERE SiteID=" & SiteID & " ORDER BY BlogID DESC"
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM Blog WHERE SiteID=" & SiteID & " AND BlogName LIKE '%" & Request.form("search") & "%'" & "  AND Active=" & Int(Request.form("Active"))& " ORDER BY BlogID DESC"
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

  if format = "" then
  %>

<script type="text/javascript">
    jQuery(document).ready(function() {
        jQuery('#contentTable').tablesorter({ sortList: [[0, 0]], headers: { 3: { sorter: false }, 4: { sorter: false}} });
    });
</script>
<div style="background:#F0F0F0;height:auto;border:1px solid #CCCCCC;margin:10px 15px;padding:15px;">
<center>
    <div style="width:99%;height:43px;background:#fff;line-height:43px;border:1px solid #ccc;">
        <div style="width:120px;float:right;line-height:43px;text-align:right;padding-right:10px;color:#25BAE2;font-size:22px;">ניהול בלוגים</div>
        <div style="width:40px;float:left;line-height:43px;"><a href="admin_blog.asp?action=add"><img src="../admin/images/add.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></div>
        <div style="width:40px;float:left;line-height:43px;"><a href="admin_blog.asp?format=xls&<%Request.Querystring %>"><img src="../admin/images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
        <div style="width:40px;float:left;line-height:43px;"><a href="admin_blog.asp?format=doc&<%Request.Querystring %>"><img src="../admin/images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
        <div style="float:left;line-height:43px;margin-left:10px;width:50px;">
        <select style="float:right;font-family:arial;height:23px;margin-top:9px;width:50px;" name="records" onchange="location.href='admin_blog.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
        	<option value="10" <%if records = 10 then print "selected" End if%>>10</option>
        	<option value="20" <%if records = 20 then print "selected" End if%>>20</option>
        	<option value="50" <%if records = 50 then print "selected" End if%>>50</option>
        	<option value="100" <%if records = 100 then print "selected" End if%>>100</option>
        	<option value="1000" <%if records = 1000 then print "selected" End if%>>1000</option>
        </select>
        </div>
        <div style="width:80px;float:left;line-height:43px;">רשומות לדף:</div>
        <div style="height:42px;line-height:42px;float:left;">
        <form action="admin_blog.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>" method="post">
           <div style="line-height:42px;width:640px;">
               <select name="Active" style="width:60px;float:right;margin-top:9px;height:23px;margin-right:10px;font-family:arial;">
						<option value="1">פעיל</option>
						<option value="0">לא פעיל</option>
                </select>
               
               <div style="float:right;height:23px;margin-right:10px;">שם הבלוג:</div>
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
					                        <a href="admin_blog.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_blog.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
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
        <th style="padding-right:10px;" align="right">שם הבלוג</th>
        <%if format = "" then %>
        <td style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">ערוך</td>
        <td style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">שכפל דף</td>
        <td style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">צור קישור</td>
        <td style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">
            &nbsp;</td>
        <td style="border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">מחק</td>
        <% End If ' format %>
    </tr>
</thead>
<tbody>
				<% HowMany = 0
		
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize
				%>
    <tr onmouseover="Mark(this);" onmouseout="Unmark(this);">
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% = objRs("BlogID") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><% = objRs("BlogName") %></td>
        <%if format = "" then %>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="admin_blog.asp?ID=<% = objRs("BlogID") %>&action=edit"><img src="/sites/cms/layout/images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="admin_blog.asp?ID=<% = objRs("BlogID") %>&action=copy"><img src="/sites/cms/layout/images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="admin_Menu.asp?action=add&src=<% =objRs("BlogID") %>&Headline=<% =objRs("BlogName") %>&lang=<% = SiteLang %>&S=<% = SiteID %>"><img src="/sites/cms/layout/images/link.gif" border="0" alt="צור קישור" /></a></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center">
        
        &nbsp;</td>
        <td style="border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="admin_blog.asp?ID=<% = objRs("BlogID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="/sites/cms/layout/images/delete.gif" border="0" alt="מחק" /></a></td>
        <% End If ' format %>
    </tr>	
    			<% HowMany = HowMany + 1
				objRs.MoveNext
		  		Loop
				%>
</tbody>
					<!--<div id="pager" ></div>-->
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
					                        <a href="admin_blog.asp?page=<% = objRs.AbsolutePage - 1 %>&records=<% = records %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_blog.asp?page=<% = objRs.AbsolutePage + 1 %>&records=<%= records %>" style="text-decoration: none"><% 	End If%>
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
			      Set objRsUrl = OpenDB("SELECT * FROM Blog WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM Blog WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
	                    
	                    CheckCategorySecuirty(Request.Form("CategoryID"))

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("BlogName") = Request.Form("BlogName")
								objRs("BlogDescription") = Request.Form("BlogDescription")	
								objRs("Image") = Trim(Request.Form("Image"))
								'objRs("BlogUsersID") = Int(Request.Form("BlogUsersID"))	
								'objRs("LangID") = Int(Request.Form("LangID"))
								objRs("ViewLevel") = Int(Request.Form("ViewLevel"))	
								objRs("PostCommentLevel") = Int(Request.Form("PostCommentLevel"))
								objRs("BlogDate") = Now()
								    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>בלוג נוסף בהצלחה. <a href='admin_blog.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
				
					If GetConfig("twitterusername") <> "" AND Request.Form("sendtotwitter") = 1 Then
			            Response.Buffer = True  
                        Set xml = Server.CreateObject("Microsoft.XMLHTTP")  
                        twitter_username = GetConfig("twitterusername")   'change to your twitter username  
                        twitter_password = GetConfig("twitterpassword")   'change to your twitter password 
                        url =  "http://" & LCase(Request.ServerVariables("HTTP_HOST")) & "/" & Replace(Request.Form("urltext")," ","-") 
                        new_status = Trim(Request.Form("BlogName")& " <br> -" & url )  'change to your new status  
                        xml.Open "POST", "http://" & twitter_username & ":" & twitter_password & "@twitter.com/statuses/update.xml?status=" & server.URLencode(new_status), False  
                        xml.setRequestHeader "Content-Type", "content=text/html; charset=utf-8"  
                        xml.Send  
						Response.Write("<br><br><p align='center'>סטטוס עודכן בטוויטר. <a href='admin_blog.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
                        Set xml = Nothing  
                     End If
							     '   Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_blog.asp?S=" & SiteID & "'>")
                     
	       Case "edit"
	       	 Editmode= "True"
	       

	            
				    Sql = "SELECT * FROM Blog WHERE BlogID=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)

				             objRs("BlogName") = Request.Form("BlogName")
								objRs("BlogDescription") = Request.Form("BlogDescription")	
								objRs("Image") = Trim(Request.Form("Image"))
								'objRs("BlogUsersID") = Int(Request.Form("BlogUsersID"))	
								'objRs("LangID") = Int(Request.Form("LangID"))
								objRs("ViewLevel") = Int(Request.Form("ViewLevel"))	
								objRs("PostCommentLevel") = Int(Request.Form("PostCommentLevel"))
								'objRs("BlogDate") = Request.Form("BlogDate")
								    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If

								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>בלוג נערך בהצלחה. <a href='admin_blog.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_blog.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"


				    Sql = "SELECT * FROM Blog WHERE BlogID=" & Request.QueryString("ID")
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				             objRs("BlogName") = Request.Form("BlogName")
								objRs("BlogDescription") = Request.Form("BlogDescription")	
								objRs("Image") = Trim(Request.Form("Image"))
								'objRs("BlogUsersID") = Int(Request.Form("BlogUsersID"))	
								'objRs("LangID") = Int(Request.Form("LangID"))
								objRs("ViewLevel") = Int(Request.Form("ViewLevel"))	
								objRs("PostCommentLevel") = Int(Request.Form("PostCommentLevel"))
								objRs("BlogDate") = Now()
								    If Request.Form("Active")<> 1 Then
								        objRs("Active") = 0
								    Else
								        objRs("Active") = 1
								    End If
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>בלוג נוסף בהצלחה. <a href='admin_blog.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
			
					If GetConfig("twitterusername") <> "" AND Request.Form("sendtotwitter") = 1 Then
			            Response.Buffer = True  
                        Set xml = Server.CreateObject("Microsoft.XMLHTTP")  
                        twitter_username = GetConfig("twitterusername")   'change to your twitter username  
                        twitter_password = GetConfig("twitterpassword")   'change to your twitter password 
                        url =  "http://" & LCase(Request.ServerVariables("HTTP_HOST")) & "/" & Replace(Request.Form("urltext")," ","-") 
                        new_status = Trim(Request.Form("BlogName")& " <br> -" & url )  'change to your new status  
                        xml.Open "POST", "http://" & twitter_username & ":" & twitter_password & "@twitter.com/statuses/update.xml?status=" & server.URLencode(new_status), False  
                        xml.setRequestHeader "Content-Type", "content=text/html; charset=utf-8"  
                        xml.Send  
						Response.Write("<br><br><p align='center'>סטטוס עודכן בטוויטר. <a href='admin_blog.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
                        Set xml = Nothing  
                     End If
					
					
							    '    Response.Write("<meta http-equiv='Refresh' content='1; URL=admin_blog.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    Sql = "SELECT * FROM Blog WHERE BlogID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>בלוג נמחק בהצלחה. <a href='admin_blog.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_blog.asp?S=" & SiteID & "'>")
	        
	        


	            End Select
		Else
		print "555"
			If Request.QueryString("action") ="edit" OR  Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM Blog WHERE BlogID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Blog WHERE BlogID=" & SiteID   
			End If	
	Set objRs = OpenDB(SQL)
		
		If Request.QueryString("action")<> "add" then
		    Editmode = "True"
		Else
		    Editmode = "False"
		End If

 %>
<form action="admin_blog.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("BlogID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
<div id="formcontainer">
<center>
    <div id="formheader">
    <% If  Request.QueryString("action") = "add" Then %>
        <div id="formtitle">הוספת בלוג</div>
    <% ELSE 
    %>
        <div id="formtitle">עריכת בלוג</div>
    <% End If %>
        <div id="formsave"><input type="submit" value="" style="width:40px;height:42px;border:0px;background:url(/sites/cms/layout/images/save.gif) no-repeat;" class=""  /></div>
        <div id="formcancel"><img src="/sites/cms/layout/images/cancel.gif" border="0" alt="" /></div>
    </div>
    <div id="formcontent">
        <div id="formrightfields">
            <table dir="rtl" cellpadding="5" cellspacing="0" width="99%" style="margin-top:10px;">
                <tr>
                    <td width="75" align="right" valign="top">שם הבלוג</td>
                    <td align="right" valign="top">
                    
                  <textarea name="BlogName" cols="3" style="width:80%; height: 20px; font-family:Arial;" 
                            class="required"><%If Editmode = "True" Then print objRs("BlogName") End If %><% if request.querystring("name")<> "" Then print request.querystring("name") end if%></textarea> </td>
                </tr>
                <tr>
                    <td align="right" valign="top">תאור</td>
                    <td align="right" valign="top">
					<%
Dim oFCKeditor
Set oFCKeditor = New FCKeditor
oFCKeditor.BasePath = "FCKeditor/"
If Editmode = "True" Then
    oFCKeditor.Value=objRs("BlogDescription")
End If
if request.querystring("block")<> "" Then  oFCKeditor.Value=request.querystring("block") end if
oFCKeditor.width="100%"
oFCKeditor.height="370px"
if Session("SiteLang") = 1 Then
oFCKeditor.config("DefaultLanguage")= "he"
oFCKeditor.config("ContentLangDirection")= "rtl"
Else
oFCKeditor.config("DefaultLanguage")= "en"
oFCKeditor.config("ContentLangDirection")= "ltr"
End If
oFCKeditor.Create "BlogDescription"

%>

					</td>
                </tr>
                <% If GetConfig("twitterusername") <> "" AND Editmode = "False" Then %> 
                <tr>
                 <td align="right">שלח לטוויטר</td>
                 <td align="right"><input id="sendtotwitter"  type="checkbox" dir="ltr" name="sendtotwitter" value="1" checked="yes" onchange="" maxlength="" value="" style="float:right;" class="" format="" /></td>
               </tr>
               <% End If %>
                <tr>
                 <td align="right">פעיל</td>
                 <td align="right"><input id="active"  type="checkbox" dir="ltr" name="active" value="1" <%If Editmode = "True" Then %><% If objRs("active")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>" onchange="" maxlength="" value="" style="float:right;" class="" format="" /></td>
               </tr>

            </table>
        </div>
        <div id="formleftfields">
            <div id="formleftfieldsheader">
                <div id="formleftfieldstitle" style="padding-right:10px;width:60%;float:right;font-weight:bold;">תמונה </div>
                <div id="formleftfieldsopen">
                <a href="#" onclick="ShowHide(jQuery('#slidingDivdesc')); return false;">פתח</a>
                </div>
                <div id="slidingDivdesc" class="slidingdivdesc">
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">תמונה</td>
                        </tr>
                        <tr>
                            <td align="right">
							<input style="width: 210px;" id="xFileName" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" onclick="BrowseServer('xFileName');"/>

							</td>
                        </tr>
   
                    </table>
                </div>
            </div>
            <div id="formleftfieldsheader">
                <div id="formleftfieldstitle">הגדרות אבטחה</div>
                <div id="formleftfieldsopen">
                <a href="#" onclick="ShowHide(jQuery('#slidingDivseciur')); return false;">פתח</a>
                </div>
                <div id="slidingDivseciur" class="slidingdivdesc">
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">רמת הרשאה לצפייה</td>
                        </tr>
                        <tr>
                            <td align="right">
							<select style="width: 40px;" name="ViewLevel" ID="ViewLevel" size="1">
						<%
							i=1	
				 			Do Until i > 9
				 		 %>
							<option value=<% = i %> <%If Editmode = "True" Then %> <% If  objRs("ViewLevel") = i   Then Response.Write(" selected") %><% Else %><% If  i = GetConfig("ViewLevel")   Then Response.Write(" Selected") %><% End If %>><% = i %></option>
							<% i=i+1
							Loop
							%>
					</select>
							</td>
                        </tr>
                        <tr>
                            <td align="right">רמת הרשאה לתגובה</td>
                        </tr>
                        <tr>
                            <td align="right">
							<select style="width: 40px;" name="PostCommentLevel" ID="PostCommentLevel" size="1">
						<%
							i=1	
				 			Do Until i > 9
				 		 %>
							<option value=<% = i %> <%If Editmode = "True" Then %> <% If  objRs("PostCommentLevel") = i   Then Response.Write(" selected") %><% Else %><% If  i = GetConfig("PostCommentLevel")   Then Response.Write(" Selected") %><% End If %>><% = i %></option>
							<% i=i+1
							Loop
							%>
					</select>
							</td>
                        </tr>
                          </table>
                </div>
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

<br />
<%	
End if
End if
%>