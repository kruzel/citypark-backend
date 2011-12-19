<!--#include file="../config.asp"-->
<%
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "users-Disposition", "attachment;filename=users-"&filedate&".xls"
        Response.usersType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "users-Disposition", "attachment;filename=users-"&filedate&".doc"
        Response.usersType = "application/vnd.ms-word"
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
	<script type="text/javascript">
	    function ShowHide(obj) {
	        obj.animate({ "height": "toggle" }, { duration: 1000 });
	    }
</script>

<% 
End If
CheckSecuirty "Block"

If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM Block WHERE SiteID=" & SiteID"
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM Block WHERE SiteID=" & SiteID & " AND BlockName LIKE '%" & Request.form("search") & "%'" & " AND BlockID=" & Request.form("category")
	End If
'print SQL
	Set objRs = OpenDB(SQL)
	    If objRs.RecordCount = 0 Then
	           print "אין רשומות"
	    Else
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
<script type="text/javascript" language="javascript">

        jQuery(document).ready(function() {
            jQuery("#pager").pager({ pagenumber: 1, pagecount: 15, buttonClickCallback: PageClick });
        });

        PageClick = function(pageclickednumber) {
            jQuery("#pager").pager({ pagenumber: pageclickednumber, pagecount: 15, buttonClickCallback: PageClick });
            jQuery("#result").asp("page " + pageclickednumber);
        }
       
    </script>
<div style="background:#F0F0F0;height:auto;border:1px solid #CCCCCC;margin:10px 15px;padding:15px;">
<center>
    <div style="width:99%;height:43px;background:#fff;line-height:43px;border:1px solid #ccc;">
        <div style="width:200px;float:right;line-height:43px;text-align:right;padding-right:10px;color:#25BAE2;font-size:22px;">ניהול קטגוריות תוכן</div>
        <div style="width:40px;float:left;line-height:43px;"><a href="admin_Block.asp?action=add"><img src="../admin/images/add.gif" border="0" alt="הוספת קטגוריה" title="הוספת קטגוריה" /></a></div>
        <div style="width:40px;float:left;line-height:43px;"><a href="admin_Block.asp?format=xls&<%Request.Querystring %>"><img src="../admin/images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
        <div style="width:40px;float:left;line-height:43px;"><a href="admin_Block.asp?format=doc&<%Request.Querystring %>"><img src="../admin/images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
        <div style="float:left;line-height:43px;margin-left:10px;width:50px;">
        <select style="float:right;font-family:arial;height:23px;margin-top:9px;width:50px;" name="records" onchange="location.href='admin_Block.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
        	<option value="10" <%if Request.Querystring("records") = 10 then print "selected" End if%>>10</option>
        	<option value="20" <%if Request.Querystring("records") = 20 then print "selected" End if%>>20</option>
        	<option value="50" <%if Request.Querystring("records") = 50 then print "selected" End if%>>50</option>
        	<option value="100" <%if Request.Querystring("records") = 100 then print "selected" End if%>>100</option>
        	<option value="1000" <%if Request.Querystring("records") = 1000 then print "selected" End if%>>1000</option>
        </select>
        </div>
        <div style="width:80px;float:left;line-height:43px;">רשומות לדף:</div>
        <div style="height:42px;line-height:42px;float:left;">
        <form action="admin_Block.asp?action=show&mode=search" method="post">
           <div style="line-height:42px;width:500px;">
         
               <div style="float:right;height:23px;margin-right:10px;">שם קטגוריה:</div>
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
					                        <a href="admin_Block.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_Block.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
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
    <tr style="background:url(/sites/cms/layout/images/gridheaderbg.gif) repeat-x;height:29px;">
        <th style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #ccc;" align="right">שם</th>
        <th style="border-left:1px solid #eee;border-bottom:1px solid #ccc;" align="center" width="73">שינוי סדר כתבות</th>
        <%if format = "" then %>
        <th style="border-left:1px solid #eee;border-bottom:1px solid #ccc;" align="center" width="73">ערוך</th>
        <th style="border-left:1px solid #eee;border-bottom:1px solid #ccc;" align="center" width="73">שכפל</th>
        <th style="border-left:1px solid #eee;border-bottom:1px solid #ccc;" align="center" width="73">מחק</th>
        <th style="border-bottom:1px solid #ccc;font-weight:bold;" align="center" width="73">סדר מיון</th>
        <% End If ' format %>
    </tr></thead>
    <tbody>
				<% HowMany = 0
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize
				%>
    <tr onmouseover="Mark(this);" onmouseout="Unmark(this);" style="height:35px;">
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;" align="right"><% = objRs("BlockName") %></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;" align="center"></a></td>
    <%if format = "" then %>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;" align="center"><a href="admin_Block.asp?ID=<% = objRs("BlockID") %>&action=edit"><img src="/sites/cms/layout/images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;" align="center"><a href="admin_Block.asp?ID=<% = objRs("BlockID") %>&action=copy"><img src="/sites/cms/layout/images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;" align="center"><a href="admin_Block.asp?ID=<% = objRs("BlockID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="/sites/cms/layout/images/delete.gif" border="0" alt="מחק" /></a></td>
        <td style="border-bottom:1px solid #eee;" align="center"></td>
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
					                        <a href="admin_Block.asp?page=<% = objRs.AbsolutePage - 1 %>&records=<% = records %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_Block.asp?page=<% = objRs.AbsolutePage + 1 %>&records=<%= records %>" style="text-decoration: none"><% 	End If%>
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
End If
Else
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	        Case "add"
	        Editmode= "False"
			      Set objRsUrl = OpenDB("SELECT * FROM Block WHERE SiteID=" & SiteID)

			        Sql = "SELECT * FROM Block"
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Blockname") = Trim(Request.Form("Blockname"))
								objRs("BlockTitle") = Request.Form("BlockTitle")
								objRs("BlockDescription") = Request.Form("BlockDescription")
								objRs("BlockKeywords") = Request.Form("BlockKeywords")
								objRs("BlockPosition") = int(Request.Form("BlockPosition"))	
								objRs("BlockFatherName") = int(Request.Form("BlockFatherName"))
								objRs("LangID") = int(Request.Form("LangID"))
								objRs("TipeID") = int(Request.Form("TipeID"))	
								objRs("BlockDesc") = Request.Form("BlockDesc")	
								objRs("BlockContainerTemplate") = Trim(Request.Form("BlockContainerTemplate"))	
								objRs("BlockTemplate") = Trim(Request.Form("BlockTemplate"))
								objRs("Blockheader") = Trim(Request.Form("Blockheader"))
								objRs("Blockfooter") = Trim(Request.Form("Blockfooter"))
								objRs("ShowBlockDesc") = Trim(Request.Form("ShowBlockDesc"))
								objRs("Admin9level") = int(Request.Form("Admin9level"))
								objRs("BlockOrder") = int(Request.Form("BlockOrder"))
								objRs("categorypagerecords") =int(Request.Form("categorypagerecords"))
								objRs("categoryblockrecords") =int(Request.Form("categoryblockrecords"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>קטגוריה נוספה בהצלחה. <a href='admin_Block.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_Block.asp?S=" & SiteID & "'>")
	       Case "edit"
	       	 Editmode= "True"

	            If Request.Querystring("ID") = "" Then
				    Sql = "SELECT * FROM Block WHERE urltext=" & Replace(Request.QueryString("p"),"-"," ")
			    Else
				    Sql = "SELECT * FROM Block WHERE BlockID=" & Request.QueryString("ID")
			    End If
			            Set objRs = OpenDB(sql)
				                objRs("Blockname") = Trim(Request.Form("Blockname"))
								objRs("BlockTitle") = Request.Form("BlockTitle")
								objRs("BlockDescription") = Request.Form("BlockDescription")
								objRs("BlockKeywords") = Request.Form("BlockKeywords")
								objRs("BlockPosition") = int(Request.Form("BlockPosition"))	
								objRs("BlockFatherName") = int(Request.Form("BlockFatherName"))
								objRs("LangID") = int(Request.Form("LangID"))
								objRs("TipeID") = int(Request.Form("TipeID"))	
								objRs("BlockDesc") = Request.Form("BlockDesc")	
								objRs("BlockContainerTemplate") = Trim(Request.Form("BlockContainerTemplate"))	
								objRs("BlockTemplate") = Trim(Request.Form("BlockTemplate"))
								objRs("Blockheader") = Trim(Request.Form("Blockheader"))
								objRs("Blockfooter") = Trim(Request.Form("Blockfooter"))
								objRs("ShowBlockDesc") = Trim(Request.Form("ShowBlockDesc"))
								objRs("Admin9level") = int(Request.Form("Admin9level"))
								objRs("BlockOrder") = int(Request.Form("BlockOrder"))
								objRs("categorypagerecords") =int(Request.Form("categorypagerecords"))
								objRs("categoryblockrecords") =int(Request.Form("categoryblockrecords"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>קטגוריה נערכה בהצלחה. <a href='admin_Block.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_Block.asp?S=" & SiteID & "'>")

	        Case "copy"
	        	Editmode = "True"


	            If Request.Querystring("ID") = "" Then
				    Sql = "SELECT * FROM Block WHERE urltext=" & Replace(Request.QueryString("p"),"-"," ")
			    Else
				    Sql = "SELECT * FROM Block WHERE BlockID=" & Request.QueryString("ID")
			    End If
			        	Set objRs = OpenDB(sql)

				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Blockname") = Trim(Request.Form("Blockname"))
								objRs("BlockTitle") = Request.Form("BlockTitle")
								objRs("BlockDescription") = Request.Form("BlockDescription")
								objRs("BlockKeywords") = Request.Form("BlockKeywords")
								objRs("BlockPosition") = int(Request.Form("BlockPosition"))	
								objRs("BlockFatherName") = int(Request.Form("BlockFatherName"))
								objRs("LangID") = int(Request.Form("LangID"))
								objRs("TipeID") = int(Request.Form("TipeID"))	
								objRs("BlockDesc") = Request.Form("BlockDesc")	
								objRs("BlockContainerTemplate") = Trim(Request.Form("BlockContainerTemplate"))	
								objRs("BlockTemplate") = Trim(Request.Form("BlockTemplate"))
								objRs("Blockheader") = Trim(Request.Form("Blockheader"))
								objRs("Blockfooter") = Trim(Request.Form("Blockfooter"))
								objRs("ShowBlockDesc") = Trim(Request.Form("ShowBlockDesc"))
								objRs("Admin9level") = int(Request.Form("Admin9level"))
								objRs("BlockOrder") = int(Request.Form("BlockOrder"))
								objRs("categorypagerecords") =int(Request.Form("categorypagerecords"))
								objRs("categoryblockrecords") =int(Request.Form("categoryblockrecords"))
								objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>קטגוריה נוספה בהצלחה. <a href='admin_Block.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' users='1; URL=admin_Block.asp?S=" & SiteID & "'>")

	        
	        Case "delete"
				    Sql = "SELECT * FROM Block WHERE BlockID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>קטגוריה נמחקה בהצלחה. <a href='admin_Block.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' users='0; URL=admin_Block.asp?S=" & SiteID & "'>")
	        Case "copy"
	            End Select
		Else
				SQL = "SELECT * FROM Block WHERE BlockID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Block WHERE SiteID=" & SiteID   
			End If
				Set objRs = OpenDB(SQL)
					If Session("Level") > 3 Then 
						Response.Write("<br><br><p align='center'>אין לך הרשאה לבצע פעולה זאת <a href='user_home.asp'>נסה שנית</a>!</p>")
					ElseIf objRs.RecordCount = 0 Then
					print "פעולה לא חוקית אנא חזור לאחור ונסה שוב"
		Else
		
		If Request.QueryString("action")<> "add" then
		    Editmode = "True"
		Else
		    Editmode = "False"
		End If

 %>
<form action="admin_Block.asp?mode=doit&ID=<% = objRs("BlockID")%>&action=<%=Request.Querystring("action") %>" method="post" id="category" name="category">
<div id="formcontainer">
<center>
    <div id="formheader">
    <% If  Request.QueryString("action") = "add" Then %>
        <div id="formtitle">הוספת קטגוריה</div>
    <% ELSE %>
        <div id="formtitle">עריכת קטגוריה</div>
    <% End If %>
        <div id="formsave"><input type="submit" value="" style="width:40px;height:42px;border:0px;background:url(/sites/cms/layout/images/save.gif) no-repeat;" class=""  /></div>
        <div id="formcancel"><img src="/sites/cms/layout/images/cancel.gif" border="0" alt="" /></div>
    </div>
    <div id="formcontent">
        <div id="formrightfields">
            <table dir="rtl" cellpadding="5" cellspacing="0" width="99%" style="margin-top:10px;">
                <tr>
                    <td width="75" align="right" valign="top">שם קטגוריה</td>
                    <td align="right" valign="top"><input id="BlockName" type="text" name="BlockName"<%If Editmode = "True" Then %> value="<% =objRs("BlockName")%>"<% End if %> style="width:200px;" class="required" /></td>
                </tr>
                <tr>
                    <td align="right" valign="top">שפה</td>
					<td align="right" valign="top">
					<%Set objRslang=OpenDB("SELECT * FROM lang")%>
					    <select style="width:150px;" name="langID">
					<%Do While Not objRslang.EOF%>
						<option value="<% = objRslang("langID") %>"<% If objRslang("langID") = objRs("langID") Then Response.Write(" selected") %>><% = objRslang("Langvalue") %></option>
					<%objRslang.MoveNext 
						Loop
					CloseDB(objRslang)%>
					    </select>
					</td>
                </tr>
                <tr>
                    <td align="right" valign="top">סוג תוכן</td>
					<td align="right" valign="top">
					<%Set objRsTipe = OpenDB("SELECT * FROM Tipe Order By TipePosition")%>
					    <select style="width:150px;" name="TipeID">
					<%Do While Not objRsTipe.EOF %>							
						<option value="<% = objRsTipe("TipeID") %>" <% If objRsTipe("TipeID") = objRs("TipeID") Then Response.Write(" selected") %>><% = objRsTipe("TipeName") %></option>
					<%objRsTipe.MoveNext 
						Loop
					CloseDB(objRsTipe)%>
</td>
                </tr>
                <tr>
                    <td align="right" valign="top">קטגוריית אב</td>
					<td align="right" valign="top">
					<% Set objRsBlock = OpenDB("SELECT * FROM Block Where BlockFatherName=0 AND SiteID= " & SiteID)%>
					  <select style="width:150px;" name="BlockFatherName">
					     <option selected value="0">קטגוריית אב</option>
					 <%Do While Not objRsBlock.EOF %>
						 <option value="<% = objRsBlock("BlockID") %>" <% If objRsBlock("BlockID") = objRs("BlockFatherName") Then Response.Write(" selected") %>><% = objRsBlock("BlockName") %></option>
					 <%	objRsBlock.MoveNext 
						Loop
					 %>
					    </select>
					  <%CloseDB(objRsBlock)%>

					</td>
                </tr>
                
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
                        <tr>
                            <td align="right">כמות כתבות בדף קטגוריה</td>
                        </tr>
                        <tr>
                            <td align="right"><input id="categorypagerecords" type="text" name="categorypagerecords" <%If Editmode = "True" Then %> value="<% = objRs("categorypagerecords") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                        <tr>
                            <td align="right">כמות כתבות בבלוק קטגוריה</td>
                        </tr>
                        <tr>
                            <td align="right"><input id="categoryblockrecords" type="text" name="categoryblockrecords" <%If Editmode = "True" Then %> value="<% = objRs("categoryblockrecords") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                                        <tr>
                    <td align="right" valign="top">להציג תיאור בראש דף</td>
                     </tr>
                  <tr>
					<td align="right" valign="top">
						<select style="width:80;" name="ShowBlockDesc" size="1">
					        <option value="No" <% If objRs("ShowBlockDesc") = "No" Then Response.Write(" selected") %>>	לא</option>
    					    <option value="Yes" <% If objRs("ShowBlockDesc") = "Yes" Then Response.Write(" selected") %>>	כן</option>
					    </select>
					</td>
                </tr>
                <tr>
                    <td align="right" valign="top">תוכן בראש הדף</td>
                  </tr>
                  <tr>
                    <td align="right"><textarea rows="5" name="BlockDesc" cols="20" style="width:80%;" class="" onKeyDown="formTextCounter(this.form.BlockDesc,this.form.remLen_BlockDesc,200);" onKeyUp="formTextCounter(this,$('remLen_BlockDesc'),200);" wrap="soft"><%If Editmode = "True" Then print objRs("BlockDesc") End If %></textarea><br><input readonly="readonly" type="text" name="remLen_BlockDesc" size="1" maxlength="3" value="200"></td>
                </tr>

                    </table>
                </div>
            </div>
            <div id="formleftfieldsheader">
                <div id="formleftfieldstitle">אפשרויות לקידום</div>
                <div id="formleftfieldsopen">
                <a href="#" onclick="ShowHide(jQuery('#slidingDivseo')); return false;">פתח</a>
                </div>
                <div id="slidingDivseo" class="slidingdivdesc">
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table1">
                        <tr>
                            <td align="right">כותרת העמוד (Title)</td>
                        </tr>
                        <tr>
                            <td align="right"><input id="BlockTitle" type="text" name="BlockTitle" onchange="" maxlength=""<%If Editmode = "True" Then %> value="<% = objRs("BlockTitle") %>"<%End If %> style="width:80%;" /></td>
                        </tr>
                        <tr>
                            <td align="right">תיאור (Description)</td>
                        </tr>
                        <tr>
                            <td align="right"><textarea rows="3" name="BlockDescription" cols="10" style="width:80%;" class="" onKeyDown="formTextCounter(this.form.BlockDescription,this.form.remLen_BlockDescription,200);" onKeyUp="formTextCounter(this,$('remLen_BlockDescription'),200);" wrap="soft"><%If Editmode = "True" Then print objRs("BlockDescription") End If %></textarea><br><input readonly="readonly" type="text" name="remLen_BlockDescription" size="1" maxlength="3" value="200"></td>
                        </tr>
                        <tr>
                            <td align="right">מילות מפתח (KeyWords)</td>
                        </tr>
                        <tr>
                            <td align="right"><textarea rows="3" name="BlockKeywords" cols="10" style="width:80%;" class="" onKeyDown="formTextCounter(this.form.BlockKeywords,this.form.remLen_BlockKeywords,200);" onKeyUp="formTextCounter(this,$('remLen_BlockKeywords'),200);" wrap="soft"><% If Editmode = "True" Then print objRs("BlockKeywords") End If %></textarea><br><input readonly="readonly" type="text" name="remLen_BlockKeywords" size="1" maxlength="3" value="200"></td>
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
                        <tr>
                            <td align="right">תבנית</td>
                        </tr>
                        <tr>
                            <td align="right">
                            <select style="width:300px;" name="BlockTemplate" dir="ltr" size="1">
						<% 
                            Whichfolder=server.mappath("../Sites/" & Application(ScriptName & "ScriptPath") & "/layout") &"/"  
                            Set fs = CreateObject("Scripting.FileSystemObject") 
                            Set f = fs.GetFolder(Whichfolder) 
                            Set fc = f.files
                            For Each f1 in fc 
                             %>
 		                        <option value="<% = f1.name %>" <% If f1.name = "categories.html" Then Response.Write(" selected") %>><% = f1.name %></option>
                             <%Next %>
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
	<script type="text/javascript">
	    new Validation('users', { stopOnFirst: true });
	</script>
<br />
<%	
End if
End if
End if

%>