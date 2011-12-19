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
CheckSecuirty "nailsanswers"

		SQL = "SELECT * FROM nailsanswers WHERE questionid= " & Request.QueryString("ID") & " AND SiteID=" & SiteID

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
                    <div style="width:40px;float:left;line-height:43px;"><a href="admin_questionanswer.asp?format=xls&ID=<%=Request.Querystring("ID") %>"><img src="../admin/images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
                    <div style="width:40px;float:left;line-height:43px;"><a href="admin_questionanswer.asp?format=doc&ID=<%=Request.Querystring("ID") %>"><img src="../admin/images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
                    <div style="float:left;line-height:43px;margin-left:10px;width:50px;">
                        <select style="float:right;font-family:arial;height:23px;margin-top:9px;width:50px;" name="records" onchange="location.href='admin_questionanswer.asp?records='+escape(this.options[this.selectedIndex].value)+'&ID=<%=request.querystring("id")%>&SiteID=<%=SiteID%>';">
        	                <option value="10" <%if records = 10 then print "selected" End if%>>10</option>
        	                <option value="20" <%if records = 20 then print "selected" End if%>>20</option>
        	                <option value="50" <%if records = 50 then print "selected" End if%>>50</option>
        	                <option value="100" <%if records = 100 then print "selected" End if%>>100</option>
        	                <option value="1000" <%if records = 1000 then print "selected" End if%>>1000</option>
                        </select>
                    </div>
                    <div style="width:80px;float:left;line-height:43px;">רשומות לדף:</div>
                    <div style="height:42px;line-height:42px;float:left;">
                         <form action="admin_questionanswer.asp?action=show&mode=search" method="post">
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
					                        <a href="admin_questionanswer.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_questionanswer.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
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
        <th style="padding-right:10px;" align="right">שם</th>
        <th style="padding-right:10px;" align="right">תשובה</th>
    </tr>
</thead>
<tbody>
				<% HowMany = 0
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize

				%>
    <tr onmouseover="Mark(this);" onmouseout="Unmark(this);">
       <% Set objRsName = OpenDB("SELECT UsersID, Name, FamilyName ,Usersname AS FullName FROM users WHERE UsersID = " & objRs("userid"))%>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><%If objRsName.recordcount > 0 then print  objRsName("Name")& " " & objRsName("FamilyName") Else print "משתמש נמחק" End if%></td>
       <%CloseDB(objRsName) %>
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><%= objRs("answer") %></td>
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
					                        <a href="admin_questionanswer.asp?page=<% = objRs.AbsolutePage - 1 %>&records=<% = records %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRs.AbsolutePage < objRs.PageCount Then %>
					                         <a href="admin_questionanswer.asp?page=<% = objRs.AbsolutePage + 1 %>&records=<%= records %>" style="text-decoration: none"><% 	End If%>
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
%>