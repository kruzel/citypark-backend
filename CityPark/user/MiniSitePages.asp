<!--#include file="../config.asp"-->
	<script type="text/javascript">
	    function ShowHide(obj) {
	        obj.animate({ "height": "toggle" }, { duration: 1000 });
	    }
    </script>

<% 
Header
Userheader = GetURL(Getconfig("Userheader"))
		 ProcessLayout(Userheader)

If Request.QueryString("MiniSiteID")<> "" Then
    SetSession "MiniSiteID",Request.QueryString("MiniSiteID")
End If
SetSession "BackURL","/user/MiniSitePages.asp"
If Request.Cookies(SiteID & "UserLevel") = "" Then 
 Response.Redirect("/userlogin.asp")
End If
    CheckUserSecurity_Level Request.Cookies(SiteID & "UserLevel"),GetSession("BackURL")

SQLConfig = "SELECT * FROM MiniSiteConfig WHERE SiteID=" & SiteID
Set objRsConfig = OpenDB(SQLConfig)
MaxPages = 10
CloseDB(objRsConfig)

If Request.QueryString("ID")= "" AND Lcase(Request.QueryString("action"))<> "add" Then
If GetSession("MiniSiteID") <> "" OR GetSession("MiniSiteID") <> NULL Then
        SQL = "SELECT * FROM MiniSitePages WHERE SiteID=" & SiteID & " AND UsersID=" & Request.Cookies(SiteID & "UserID") & " AND MiniSiteID=" & GetSession("MiniSiteID") 
Else
        SQL = "SELECT * FROM MiniSitePages WHERE SiteID=" & SiteID & " AND UsersID=" & Request.Cookies(SiteID & "UserID") 
End If	
Set objRs = OpenDB(SQL)
	If Request.QueryString("records") = "" Then
	records = 10
	Else 
	records = Request.QueryString("records")
	End If
	objRs.PageSize = records

             if format = "" then
  %>

<script type="text/javascript">
    jQuery(document).ready(function() {
    jQuery('#usersTable').tablesorter({ sortList: [[0, 0]], headers: { 3: { sorter: false }, 4: { sorter: false}} });
    });
</script>
<div style="background:#F0F0F0;height:auto;border:1px solid #CCCCCC;margin:10px 15px;padding:15px;">
<center>
    <div style="width:99%;height:43px;background:#fff;line-height:43px;border:1px solid #ccc;">
        <div style="width:200px;float:right;line-height:43px;text-align:right;padding-right:10px;color:#25BAE2;font-size:22px;">ניהול מיניסייט</div>
    <% If objRs.RecordCount < MaxPages Then %>
        <div style="width:40px;float:left;line-height:43px;"><a href="MiniSitePages.asp?action=add"><img src="../admin/images/add.gif" border="0" alt="הוספת מיניסייט" PageTitle="הוספת מיניסייט" /></a></div>
    <% End If %> 
        <div style="float:left;line-height:43px;margin-left:10px;width:50px;">
        <select style="float:right;font-family:arial;height:23px;margin-top:9px;width:50px;" name="records" onchange="location.href='MiniSitePages.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
        	<option value="10" <%if Request.Querystring("records") = 10 then print "selected" End if%>>10</option>
        	<option value="20" <%if Request.Querystring("records") = 20 then print "selected" End if%>>20</option>
        	<option value="50" <%if Request.Querystring("records") = 50 then print "selected" End if%>>50</option>
        	<option value="100" <%if Request.Querystring("records") = 100 then print "selected" End if%>>100</option>
        	<option value="1000" <%if Request.Querystring("records") = 1000 then print "selected" End if%>>1000</option>
        </select>
        </div>
        <div style="width:80px;float:left;line-height:43px;">רשומות לדף:</div>
        <div style="height:42px;line-height:42px;float:left;">
        <form action="MiniSitePages.asp?action=show&mode=search" method="post">
           <div style="line-height:42px;width:350px;">
               <div style="float:right;height:23px;margin-right:10px;">שם מיניסייט:</div>
               <input type="text" dir="rtl" name="search" style="width:150px;float:right;margin-top:9px;height:17px;margin-right:10px;font-family:arial;">
               <input type="submit" value="חפש" name="searchbtn" style="float:right;margin-right:10px;margin-top:9px;font-family:arial;">
           </div>
        </form>
        </div>
     </div>
    		   <%  End if 'format%>        

<table id="tablesorter" class="tablesorter"  align="center" dir="rtl" cellpadding="0" cellspacing="0" border="0" width="99%" style="border:1px solid #ccc;margin-top:10px;background:#fff;border-bottom:0px;">
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
					                        <a href="MiniSitePages.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="MiniSitePages.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
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
        <th style="padding-right:10px;line-height:20px;" align="right">שם</th>
        <th style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">ניהול דפים</th>
        <%if format = "" then %>
        <th style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">ערוך</th>
        <th style="border-left:1px solid #ccc;border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">שכפל</th>
        <th style="border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">מחק</th>
        <% End If ' format %>
    </tr></thead>
    <tbody>
				<% HowMany = 0
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize
				%>
    <tr onmouseover="Mark(this);" onmouseout="Unmark(this);">
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% = objRs("MiniSitePagesID") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><% = objRs("MiniSitePagesName") %></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="MinSitePages.asp?MiniSitePagesID=<% = objRs("MiniSitePagesID") %>"><img src="/sites/cms/layout/images/ordernews.gif" border="0" alt="ניהול דפים" /></a></td>
    <%if format = "" then %>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="MiniSitePages.asp?ID=<% = objRs("MiniSitePagesID") %>&action=edit"><img src="/sites/cms/layout/images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% If objRs.RecordCount < MaxPages Then %><a href="MiniSitePages.asp?ID=<% = objRs("MiniSitePagesID") %>&action=copy"><img src="/sites/cms/layout/images/copy.gif" border="0" alt="שכפל דף" /></a>       <% End If %>
</td>
        <td style="border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="MiniSitePages.asp?ID=<% = objRs("MiniSitePagesID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="/sites/cms/layout/images/delete.gif" border="0" alt="מחק" /></a></td>
        <% End If ' format %>
    </tr>	
    			<% HowMany = HowMany + 1
				objRs.MoveNext
		  		Loop
				%>
				</tbody>
					<!--<div id="pager" ></div>-->
		  		<tr>
					<td class="Head" align="left" colspan="9" bgcolor="#eeeeee">
                    </td>
		  		</tr>
			
  	            <tr valign="top">
		            <td style="border-bottom:1px solid #ccc;height:25px;vertical-align:middle;" align="center" colspan="8">
	      	            <table width="300" cellpadding="0" cellspacing="0" align="center">
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
					                        <a href="MiniSitePages.asp?page=<% = objRs.AbsolutePage - 1 %>&records=<% = records %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="MiniSitePages.asp?page=<% = objRs.AbsolutePage + 1 %>&records=<%= records %>" style="text-decoration: none"><% 	End If%>
					                         <font color="#808080">דף הבא</font></a></font>
					                     </td>
							                <td width="167"><font size="2" face="Arial">
							                <img border="0" src="../admin/images/leftadmin.gif" width="16" height="16" align="right"></font>
						                </td>
						            </tr>
					            </table>
			               </td>
		            </tr>

			            </table>
		            </td>
	            </tr>
            </table>
</div><font face="Arial" size="2"><br>
</font>
<%	objRs.Close 

Else
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	        Case "add"
	        Editmode= "False"
			      Set objRsUrl = OpenDB("SELECT * FROM MiniSitePages WHERE SiteID=" & SiteID & " AND UsersID=" & Request.Cookies(SiteID & "UserID") & " AND MiniSiteID=" & GetSession("MiniSiteID"))
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
			        Sql = "SELECT * FROM MiniSitePages"
			        	Set objRs = OpenDB(sql)
                            If objRs.RecordCount < MaxPages Then 

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("MiniSiteID") = GetSession("MiniSiteID")
                                objRs("UsersID") = Int(Request.Cookies(SiteID & "UserID"))
				                objRs("MiniSitePagesName") = Trim(Request.Form("MiniSitePagesName"))
				                objRs("UrlText") = Trim(Request.Form("UrlText"))
								objRs("Text") = Trim(Request.Form("Text"))
								objRs("PageTitle") = Trim(Request.Form("PageTitle"))
								objRs("PageKeywords") = Trim(Request.Form("PageKeywords"))
								objRs("PageDescription") = Trim(Request.Form("PageDescription"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>דף נוסף בהצלחה. <a href='MiniSitePages.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=MiniSitePages.asp?S=" & SiteID & "'>")
	                    End If
                      End If
                        
           Case "edit"
	       	 Editmode= "True"

	            If Request.Querystring("ID") = "" Then
				    Sql = "SELECT * FROM MiniSitePages WHERE urltext=" & Replace(Request.QueryString("p"),"-"," ") & " AND UsersID=" & Request.Cookies(SiteID & "UserID")
			    Else
				    Sql = "SELECT * FROM MiniSitePages WHERE MiniSitePagesID=" & Request.QueryString("ID") & " AND UsersID=" & Request.Cookies(SiteID & "UserID")
			    End If
			            Set objRs = OpenDB(sql)
				                objRs("MiniSitePagesName") = Trim(Request.Form("MiniSitePagesName"))
								objRs("Text") = Trim(Request.Form("Text"))
								objRs("PageTitle") = Trim(Request.Form("PageTitle"))
								objRs("PageKeywords") = Trim(Request.Form("PageKeywords"))
								objRs("PageDescription") = Trim(Request.Form("PageDescription"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>מיניסייט נערך בהצלחה. <a href='MiniSitePages.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=MiniSitePages.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"
              If objRs.RecordCount < MaxPages Then 

                Set objRsUrl = OpenDB("SELECT * FROM MiniSitePages WHERE SiteID=" & SiteID & " AND UsersID=" & Request.Cookies(SiteID & "UserID") & " AND MiniSiteID=" & Request.Querystring("MiniSiteID"))
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
			        Sql = "SELECT * FROM MiniSitePages"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("MiniSiteID") = GetSession("MiniSiteID")
                                objRs("UsersID") = Int(Request.Cookies(SiteID & "UserID"))
				                objRs("MiniSitePagesName") = Trim(Request.Form("MiniSitePagesName"))
				                objRs("UrlText") = Trim(Request.Form("UrlText"))
								objRs("Text") = Trim(Request.Form("Text"))
								objRs("PageTitle") = Trim(Request.Form("PageTitle"))
								objRs("PageKeywords") = Trim(Request.Form("PageKeywords"))
								objRs("PageDescription") = Trim(Request.Form("PageDescription"))
								objRs("Image") = Trim(Request.Form("Image"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>דף נוסף בהצלחה. <a href='MiniSitePages.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=MiniSitePages.asp?S=" & SiteID & "'>")
	             End If
	         End If
	        Case "delete"
				    Sql = "SELECT * FROM MiniSitePages WHERE MiniSitePagesID=" & Request.QueryString("ID") & " AND UsersID=" & Request.Cookies(SiteID & "UserID")
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>מיניסייט נמחק בהצלחה. <a href='MiniSitePages.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' users='0; URL=MiniSitePages.asp?S=" & SiteID & "'>")
	            End Select
		Else
				SQL = "SELECT * FROM MiniSitePages WHERE MiniSitePagesID=" & Request.QueryString("ID") & " And SiteID=" & SiteID & " AND UsersID=" & Request.Cookies(SiteID & "UserID")
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM MiniSitePages WHERE SiteID=" & SiteID & " AND UsersID=" & Request.Cookies(SiteID & "UserID")
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
<form action="MiniSitePages.asp?mode=doit&<%If Editmode = "True" Then %>ID=<% = objRs("MiniSitePagesID")%><% Else %>ID=0 %><% End If %>&action=<%=Request.Querystring("action") %>" method="post"  name="MiniSitePages" class="_validate">
<div id="formcontainer">
<center>
    <div id="formheader">
    <% If  Request.QueryString("action") = "add" Then %>
        <div id="formtitle">הוספת דף</div>
    <% ELSE %>
        <div id="formtitle">עריכת דף</div>
    <% End If %>
        <div id="formsave"><input type="submit" value="" style="width:40px;height:42px;border:0px;background:url(/sites/cms/layout/images/save.gif) no-repeat;" class=""  /></div>
        <div id="formcancel"><img src="/sites/cms/layout/images/cancel.gif" border="0" alt="" /></div>
    </div>
    <div id="formcontent">
        <div id="formrightfields">
            <table dir="rtl" cellpadding="5" cellspacing="0" width="99%" style="margin-top:10px;">
                <tr>
                    <td width="75" align="right" valign="top">שם דף</td>
                    <td align="right" valign="top"><input id="MiniSitePagesName" type="text" name="MiniSitePagesName"<%If Editmode = "True" Then %> value="<% =objRs("MiniSitePagesName")%>"<% End if %> style="width:200px;" class="required" /></td>
                </tr>
                <% If  Request.QueryString("action") <> "edit" Then %>
                <tr>
                    <td align="right" valign="top">כתובת הדף</td>
                    <td align="right" valign="top"><input id="UrlText" type="text" name="UrlText" <%If Request.QueryString("action") = "copy" Then %> value="<% =objRs("UrlText")%>"  <% End if %> <% if request.querystring("name")<> "" Then%> value="<%=request.querystring("name")%>"<% end if%>style="width:200px;" class="required" /></td>
                </tr>
                <% End If %>
                <tr>
                    <td align="right" colspan="2">תוכן</td>
                </tr>
                <tr>
                    <td align="right" colspan="2">
                  	<%
                        Dim oFCKeditor
                        Set oFCKeditor = New FCKeditor
                        oFCKeditor.BasePath = "/Admin/FCKeditor/"
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
                   <td align="right">תמונה</td>
                    <td align="right">
					<input style="width:300px;direction:ltr;" id="xFilePath" name="image" <%If Editmode = "True" Then %> value="<% =objRs("image")%>"<%End If %> type="text" size="60" />
					<input type="button" value="חפש בשרת" onclick="BrowseUserFile('xFilePath');"/>
                    
             </table>
        </div>
        <div id="formleftfields">
            <div id="formleftfieldsheader">
                <div id="formleftfieldstitle" style="padding-right:10px;width:60%;float:right;font-weight:bold;">הגדרות מתקדמות</div>
                <div id="formleftfieldsopen">
                <a href="#" onclick="ShowHide(jQuery('#slidingDivdesc')); return false;">פתח</a>
                </div>
                <div id="slidingDivdesc" class="slidingdivdesc">
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                       
                    </table>
                </div>
            </div>
            <div id="formleftfieldsheader">
                <div id="formleftfieldstitle">קידום במנועי חיפוש</div>
                <div id="formleftfieldsopen">
                <a href="#" onclick="ShowHide(jQuery('#slidingDivseo')); return false;">פתח</a>
                </div>
                <div id="slidingDivseo" class="slidingdivdesc">
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">כותרת העמוד (PageTitle)</td>
                        </tr>
                        <tr>
                            <td align="right"><input id="PageTitle" type="text" name="PageTitle" onchange="" maxlength=""<%If Editmode = "True" Then %> value="<% = objRs("PageTitle") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                        <tr>
                            <td align="right">תיאור (PageDescription)</td>
                        </tr>
                        <tr>
                            <td align="right"><textarea rows="3" name="PageKeywords" cols="10" style="width:80%;" class="" onKeyDown="formTextCounter(this.form.PageKeywords,this.form.remLen_PageKeywords,200);" onKeyUp="formTextCounter(this,$('remLen_PageKeywords'),200);" wrap="soft"><%If Editmode = "True" Then print objRs("PageKeywords") End If %></textarea><br><input readonly="readonly" type="text" name="remLen_PageKeywords" size="1" maxlength="3" value="200"></td>
                        </tr>
                        <tr>
                            <td align="right">מילות מפתח (PageKeywords)</td>
                        </tr>
                        <tr>
                            <td align="right"><textarea rows="3" name="PageDescription" cols="10" style="width:80%;" class="" onKeyDown="formTextCounter(this.form.PageDescription,this.form.remLen_PageDescription,200);" onKeyUp="formTextCounter(this,$('remLen_PageDescription'),200);" wrap="soft"><% If Editmode = "True" Then print objRs("PageDescription") End If %></textarea><br><input readonly="readonly" type="text" name="remLen_PageDescription" size="1" maxlength="3" value="200"></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="formleftfieldsheader">
                <div id="formleftfieldstitle">תבנית</div>
                <div id="formleftfieldsopen">
                <a href="#" onclick="ShowHide(jQuery('#slidingDivtemplate')); return false;">פתח</a>
                </div>
                <div id="slidingDivtemplate" class="slidingdivdesc">
                     <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        
                       
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
End if
Userfooter = GetURL(Getconfig("Userfooter"))
		 ProcessLayout(Userfooter)

bottom

%>