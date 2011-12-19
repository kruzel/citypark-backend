<!--#include file="../config.asp"-->
<%
if request("inline") = "true" Then

    fieldName = Split(Request.QueryString("id"), "_")(1)
    rowId = Split(Request.QueryString("id"), "_")(0)
	value = UrlDecode2(Request.QueryString("value"))
	
	
    ExecuteRS "UPDATE [Rating] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
    
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
CheckSecuirty "Rating"

If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM Rating WHERE SiteID=" & SiteID & " ORDER BY ID DESC"
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT * FROM Rating WHERE SiteID=" & SiteID & " AND TableName LIKE '%" & Request.form("table") & "%'" & " AND EntityId=" & Request.form("name")
	End If


	Set objRs = OpenDB(SQL)
	    If False Then 'objRs.RecordCount = 0 Then
           print "אין רשומות"
	    Else
        Set objRsName = OpenDB("SELECT DISTINCT NewsHeadline FROM News Where NewsID = " & objRs("EntityId"))
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
    jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
});


</script>
<div style="background:#F0F0F0;height:auto;border:1px solid #CCCCCC;margin:10px 15px;padding:15px;">
<center>
    <div style="width:99%;height:43px;background:#fff;line-height:43px;border:1px solid #ccc;">
        <div style="width:200px;float:right;line-height:43px;text-align:right;padding-right:10px;color:#25BAE2;font-size:22px;">ניהול מערכת דירוג</div>
        <div style="float:left;line-height:43px;margin-left:10px;width:50px;">
        <select style="float:right;font-family:arial;height:23px;margin-top:9px;width:50px;" name="records" onchange="location.href='admin_rating.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
        	<option value="10" <%if records = 10 then print "selected" End if%>>10</option>
        	<option value="20" <%if records = 20 then print "selected" End if%>>20</option>
        	<option value="50" <%if records = 50 then print "selected" End if%>>50</option>
        	<option value="100" <%if records = 100 then print "selected" End if%>>100</option>
        	<option value="1000" <%if records = 1000 then print "selected" End if%>>1000</option>
        </select>
        </div>
        <div style="width:80px;float:left;line-height:43px;">רשומות לדף:</div>
        <div style="height:42px;line-height:42px;float:left;">
        <form action="admin_rating.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %>&string=<%=Request.form("search") %>" method="post">
           <div style="line-height:42px;width:640px;">
               <div style="float:right;height:23px;margin-right:10px;">טבלה:</div>
               <select id="table" name="table" style="width:80px;float:right;margin-top:9px;height:23px;margin-right:10px;font-family:arial;">
					<%	Set objRsTable = OpenDB("SELECT DISTINCT TableName FROM Rating Where SiteID = " & SiteID)
                        Do While NOT objRsTable.EOF %>
					<option value="<% = objRsTable("TableName")%>"><% = objRsTable("TableName")%></option>
                    <% objRsTable.MoveNext
                        Loop%>
				</select>
					
               <div style="float:right;height:23px;margin-right:10px;">כתבה/מוצר:</div>
                <select id="Name" name="Name" style="width:80px;float:right;margin-top:9px;height:23px;margin-right:10px;font-family:arial;">
					<%	Set objRsTable = OpenDB("SELECT DISTINCT EntityId FROM Rating Where SiteID = " & SiteID)
                       
                        Do While NOT objRsTable.EOF
                     Set objRsName = OpenDB("SELECT DISTINCT NewsHeadline FROM News Where NewsID = " & objRsTable("EntityId"))
					 %><option value="<% = objRsTable("EntityId")%>"><% = objRsName("NewsHeadline")%></option>
                    <% objRsTable.MoveNext
                        Loop
                       'CloseDB(objRsTable)
                      '  CloseDB(objRsName)
                      %>
				</select>               <input type="submit" value="חפש" name="searchbtn" style="float:right;margin-right:10px;margin-top:9px;font-family:arial;">
               <input type="reset" value="אפס" name="searchbtn" style="float:right;margin-right:10px;margin-top:9px;font-family:arial;">
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
					                        <a href="admin_rating.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_rating.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
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
                <th style="line-height:20px;" align="right" width="150">כתבה</th>
<th style="line-height:20px;" align="right" width="100">שם</th>
        <th style="line-height:20px;" align="right" width="100">email</th>
        <td style="line-height:20px;" align="right" width="400">תגובה</th>
        <th style="line-height:20px;" align="right" width="50">ציוו</th>
        <th style="line-height:20px;" align="right" width="30">מחק</td>
    </tr>
</thead>
<tbody>
				<% HowMany = 0
		
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize
				%>
    <tr onmouseover="Mark(this);" onmouseout="Unmark(this);">
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% = objRsName("NewsHeadline") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><p class="inlinetext" id="<% = objRs("id") %>_CName"><% = objRs("CName") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><p class="inlinetext" id="<% = objRs("id") %>_Mail"><% = objRs("Mail") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><p class="inlinetext" id="<% = objRs("id") %>_Review"><% = objRs("Review") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><% = objRs("Rating") %></td>
        <td style="border-bottom:1px solid #eee;line-height:25px;" align="center"><a href="admin_rating.asp?ID=<% = objRs("id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="/sites/cms/layout/images/delete.gif" border="0" alt="מחק" /></a></td>
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
					                        <a href="admin_rating.asp?page=<% = objRs.AbsolutePage - 1 %>&records=<% = records %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_rating.asp?page=<% = objRs.AbsolutePage + 1 %>&records=<%= records %>" style="text-decoration: none"><% 	End If%>
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
	       Case "edit"
	       	 Editmode= "True"
	            
				    Sql = "SELECT * FROM Rating WHERE id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)

								objRs("Rating") = Request.Form("Rating")
								objRs("CName") = Trim(Request.Form("CName"))	
								objRs("Mail") = Request.Form("Mail")
								objRs("Review") = Trim(Request.Form("Review"))
								objRs.Update
								objRs.Close
	        
	        Case "delete"
				    Sql = "SELECT * FROM Rating WHERE id=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
						    Response.Write("<br><br><p align='center'>דירוג נמחק בהצלחה. <a href='admin_rating.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' content='0; URL=admin_rating.asp?S=" & SiteID & "'>")
	        
	        

	        
	            End Select
		Else
			If Request.Querystring("ID") = "" AND Request.QueryString("action") ="edit" OR Request.Querystring("ID") = "" AND Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM Rating WHERE urltext='" & Trim(Replace(Request.QueryString("p"),"-"," ")) & "' And SiteID=" & SiteID
			Else
				SQL = "SELECT * FROM Rating WHERE id=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM Rating WHERE SiteID=" & SiteID   
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
<form action="admin_rating.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
<div id="formcontainer">
<center>
    <div id="formheader">
    <% If  Request.QueryString("action") = "add" Then %>
        <div id="formtitle">הוספת דף תוכן</div>
    <% ELSE 
    %>
        <div id="formtitle">עריכת דירוג</div>
    <% End If %>
        <div id="formsave"><input type="submit" value="" style="width:40px;height:42px;border:0px;background:url(/sites/cms/layout/images/save.gif) no-repeat;" class=""  /></div>
        <div id="formcancel"><img src="/sites/cms/layout/images/cancel.gif" border="0" alt="" /></div>
    </div>
    <div id="formcontent">
        <div id="formrightfields">
            <table dir="rtl" cellpadding="5" cellspacing="0" width="99%" style="margin-top:10px;">
                <tr>
                    <td align="right" valign="top">שם</td>
                    <td align="right" valign="top"><input id="CName" type="text" name="CName"  value="<%=request.querystring("name")%>" style="width:200px;" class="required" /></td>
                </tr>
                <tr>
                    <td align="right" valign="top">אימייל</td>
                    <td align="right" valign="top"><input id="Text1" type="text" name="Mail"  value="<%=request.querystring("Mail")%>" style="width:200px;" class="required" /></td>
                </tr>
                <tr>
                    <td align="right" valign="top">אימייל</td>
                    <td align="right" valign="top"><texterea name="Review"><%=request.querystring("Review")%></td>
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

<br />
<%	
End if
End if
End if
%>
