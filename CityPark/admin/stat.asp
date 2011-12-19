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


if format = "" then %>  
<!--#include file="inc_admin_icons.asp"-->

<% 
End If
CheckSecuirty "Analytics"
If Request.QueryString("ID")= ""  AND Request.QueryString("action")<> "add" AND Request.QueryString("action")<> "edit" AND Request.QueryString("action")<> "positions"Then
		SQL = "SELECT Count(name)As Nname,name FROM [nextwww].[dbo].[Analytics] Where SiteId=" & SiteID & " GROUP BY name order by Nname Desc"
	If Request.QueryString("mode") = "search" then
		SQL = "SELECT Count(name)As Nname,name FROM [nextwww].[dbo].[Analytics] Where SiteId=" & SiteID  & " AND name LIKE '%" & Request.form("search") & "%'" & " GROUP BY name order by Nname Desc"
	End If
'print SQL
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

<div style="background:#F0F0F0;height:auto;border:1px solid #CCCCCC;margin:10px 15px;padding:15px;">
<center>
    <div style="width:99%;height:43px;background:#fff;line-height:43px;border:1px solid #ccc;">
        <div style="width:250px;float:right;line-height:43px;text-align:right;padding-right:10px;color:#25BAE2;font-size:22px;">הצגת צפיות לפי כתבה</div>
        <div style="width:40px;float:left;line-height:43px;"><a href="stat.asp?format=xls&<%=Request.Querystring %>"><img src="../admin/images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
        <div style="width:40px;float:left;line-height:43px;"><a href="stat.asp?format=doc&<%=Request.Querystring %>"><img src="../admin/images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></div>
        <div style="float:left;line-height:43px;margin-left:10px;width:50px;">
        <select style="float:right;font-family:arial;height:23px;margin-top:9px;width:50px;" name="records" onchange="location.href='stat.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
        	<option value="10" <%if records = 10 then print "selected" End if%>>10</option>
        	<option value="20" <%if records = 20 then print "selected" End if%>>20</option>
        	<option value="50" <%if records = 50 then print "selected" End if%>>50</option>
        	<option value="100" <%if records = 100 then print "selected" End if%>>100</option>
        	<option value="1000" <%if records = 1000 then print "selected" End if%>>1000</option>
        </select>
        </div>
        <div style="width:80px;float:left;line-height:43px;">רשומות לדף:</div>
        <div style="height:42px;line-height:42px;float:left;">
        <form action="stat.asp?action=show&mode=search" method="post">
           <div style="line-height:42px;width:500px;">
               <div style="float:right;height:23px;margin-right:10px;">שם הדף:</div>
               <input type="text" dir="rtl" name="search" style="width:150px;float:right;margin-top:9px;height:17px;margin-right:10px;font-family:arial;">
               <input type="submit" value="חפש" name="searchbtn" style="float:right;margin-right:10px;margin-top:9px;font-family:arial;">
           </div>
        </form>
        </div>
     </div>
    		   <%  End if 'format%>        

<table id="contentTable" class="tablesorter"  align="center" dir="rtl" cellpadding="0" cellspacing="0" border="0" width="99%" style="border:1px solid #ccc;margin-top:10px;background:#fff;border-bottom:0px;">

<thead>
    <tr style="background:#eee;">
        <td style="line-height:40px;" align="center" width="73">כמות כניסות</th>
        <td style="padding-right:10px;" align="right">שם הדף</th>
        <%if format = "" then %>
        <% End If ' format %>
    </tr>
</thead>
<tbody>
<%HowMany = 0
 Do While Not objRs.EOF And HowMany < objRs.PageSize %>
    <tr onmouseover="Mark(this);" onmouseout="Unmark(this);">
        <td style="border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="center"><% = objRs("Nname") %></td>
        <td style="padding-right:10px;border-left:1px solid #eee;border-bottom:1px solid #eee;line-height:25px;" align="right"><% = objRs("name") %></td>
    </tr>	
    			<%HowMany=HowMany+1
    			 objRs.MoveNext
		  		Loop
				%>
</tbody>
	            </tr>

			            </table>
		            </td>
	            </tr>
            </table>
</div><font face="Arial" size="2"><br>
</font>
<%	objRs.Close 
End If
End If
%>