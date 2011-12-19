<!--#include file="../config.asp"-->
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>מערכת ניהול</title>
    <meta name="keywords" content="מערכת ניהול" />
    <meta name="description" content="מערכת ניהול" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="Content-Language" content="he" />
    <meta name="ROBOTS" content="INDEX,FOLLOW" />
    <meta name="copyright" content="Dooble.co.il" />
    <meta name="Author" content="Dooble.co.il" />
    <meta name="rating" content="General" />
        <link rel="stylesheet" media="all" type="text/css" href="/sites/cms/layout/style/style.css" />
		<link href="/css/tablesorter.css" rel="stylesheet" type="text/css" />
<link type="text/css" media="screen" rel="stylesheet" href="/js/colorbox.css" />
<link href="/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="/CSS/treeview.css" />
	<link rel="stylesheet" type="text/css" href="/CSS/treeviewpicker.css" />
  
    <link rel="stylesheet" href="../js/lightbox.css" type="text/css" media="screen" />
	<script type="text/javascript" src="../js/lightbox.js"></script>


<script type="text/javascript">
	function toggleDiv(reference_object)
	{
		if (reference_object.style.display == 'none')
			reference_object.style.display = 'block';
		else 
			reference_object.style.display = 'none';
	}
	
	function toggleAllItems(ID)
	{
		var items = document.getElementsByTagName('tr');
		
		for (i = 0; i < items.length; i++)
		{
			if (items[i].id.indexOf('_') > 0)
			{
				var x = items[i].id.indexOf('_');
				
				if (items[i].id.substring(0,x) == 't' + ID)					
					toggleDiv(items[i]);
			}
		}
	}
</script>
<script type="text/javascript">
var doConfirm = function(id)
{
var link = document.getElementById(id);
if(confirm("האם אתה בטוח שברצונך למחוק הזמנה זאת?"))
return true;
else
return false;
}
</script>


<%	
CheckSecuirty "orders"

URL = "SELECT * FROM orders WHERE SiteID=" & SiteID & " ORDER BY ordersID ASC"
If Request.QueryString("mode") = "search" then
if Request.form("status") = 0 then
URL = "SELECT * FROM orders WHERE SiteID=" & SiteID & " AND shipName LIKE '%" & Request.form("search") & "%'" & "  ORDER BY ordersID DESC"
Else
URL = "SELECT * FROM orders WHERE SiteID=" & SiteID & " AND shipName LIKE '%" & Request.form("search") & "%'" & " AND OrdersStatus = " &  Request.form("status") & " ORDER BY ordersID DESC"

End if
	End If
	Set objRs = OpenDB(URL)
	objRs.PageSize=20
	%>
		
</head>

<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td background="/images/menuin.jpg" height="30" width="360">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp;<span lang="he">ניהול 
	הזמנות</span></font></b></td>
		<td background="/images/menuin.jpg" height="30" width="338">
	<table align="left" border="0" border="0" dir="rtl" cellspacing="0" cellpadding="0">
<form style="margin:0px; width:200px;" action="shop_orders.asp?mode=search&S="<% = SiteID %> method="post">
  	<tr valign="top">
  		<td align="left">
  		<font face="Arial">
  		<input type="text" dir="rtl" name="search" style="width:100px;"><font size="2">
		</font>
<% Set objRsstatus = OpenDB("Select * From Orderstatus")%>

	  <select name="status">
	<option value="0">הכל</option>
  <% Do While NOT objRsstatus.EOF %>
	<option value="<% = objRsstatus("OrderStatusID")%>"><% = objRsstatus("OrderStatusName")%></option>
		<% objRsstatus.MoveNext
			Loop
CloseDB(objRsstatus)%>
	 </select>

  		<input type="submit" value="חפש" name="searchbtn"><font size="2"> </font>
		</font>
  		</td>
  	</tr>
</form>
</table></td></tr>
  	<tr valign="top">
		<td colspan="2">
	      	<table width=100% cellspacing="0" cellpadding="4">
		  		<% If Not objRs.PageCount = 0 Then
				If Len(Request.QueryString("page")) > 0 Then
				objRs.AbsolutePage = Request.QueryString("page")
				Else
				objRs.AbsolutePage = 1
				End If %>
				<% 	End If%>
				<tr>
					<td align="left" colspan="9">
					<font size="2" face="Arial">
					<div align="center">
					<table border="0" width="250" cellspacing="0" cellpadding="0">
						<tr>
							<td width="166">
							<font size="2">
							<img border="0" src="../images/right.png" width="16" height="16" align="left"></font></td>
							<td width="177"><font size="2" face="Arial">
							<div align="center">
	<% If objRs.AbsolutePage > 1 Then %>
					<a href="shop_orders.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					<font color="#808080">דף קודם</font></a>
	
				
					</td>
					<td width="25">
					<font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font><font size="2">
					</font>
					</td>
					<td width="155">
					<font size="2" face="Arial">
					<div align="center">
	<% If objRs.AbsolutePage < objRs.PageCount Then %>
					<a href="shop_orders.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
					<font color="#808080">דף הבא</font></a>
	
					</font></td>
							<td width="167"><font size="2" face="Arial">
							<img border="0" src="../images/left.png" width="16" height="16" align="right"></font></td>
						</tr>
					</table>
					</div>
			    	</font></td>
		  		</tr>

	     		<tr>
	        			<td valign="top" width="200" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>שם </b></font></td>
	        			<td valign="top" width="60" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>עיר</b></font></td>
	        			<td valign="top" width="50" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>סכום</b></font></td>
	        			<td valign="top" width="50" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>תאריך</b></font></td>
	        			<td valign="top" width="80" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>סטטוס</b></font></td>
	        			<td valign="top" width="30" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>עריכה</b></font></td>
	        			<td valign="top" width="30" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>צפייה</b></font></td>
	        			<td valign="top" width="30" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>מחיקה</b></font></td>
	      		</tr>		  
<% HowMany = 0
Do While Not objRs.EOF And HowMany < objRs.PageSize
URL = "SELECT * FROM SubOrders WHERE OrdersID= " & objRs("ordersID")& " AND SiteID=" & SiteID & " ORDER BY SubOrdersID ASC"
Set objRsSubOrders = OpenDB(URL)
objRsSubOrders.PageSize=20
Set objRsstatus = OpenDB("Select * From Orderstatus Where OrderstatusID = " & objRs("OrdersStatus"))
%>
<tr align="right" onmouseover="Mark(this);" onmouseout="Unmark(this);">
<td><font face="Arial" size="2"><b><a href="javascript:toggleAllItems('<% = objRs(0) %>')"><% = objRs ("shipName") & " " &  objRs("shipFailyName") %> </b></a></font></td>
<td><font face="Arial" size="2"> <% = objRs("shipCity")%></font></td>
<td><font face="Arial" size="2"><% = objRs("Total")%></font></td>
<td><font face="Arial" size="2"><% = Left(objRs("Date"),10)%></font></td>
<td><font face="Arial" size="2"><% = objRsstatus("OrderstatusName")%></font></td>
<td><font face="Arial" size="2"><a href="shop_orders_edit.asp?ID=<% = objRS("ordersID") %>&S=<% = SiteID %>"><font color="#808080">ערוך</font></a></font></td>
<td><font face="Arial" size="2"><a href="shop_orders_view.asp?ID=<% = objRS("ordersID") %>&S=<% = SiteID %>"><font color="#808080">צפה</a></font></td>
<td><font face="Arial" size="2"><a href="shop_orders_edit.asp?ID=<% = objRS("ordersID") %>&mode=delete&S=<% = SiteID %>" id="link" onclick="return doConfirm(this.id);"><font color="#808080">מחק</a></font></td>
				</tr>
		  		<% If Not objRsSubOrders.PageCount = 0 Then
				If Len(Request.QueryString("page")) > 0 Then
				objRsSubOrders.AbsolutePage = Request.QueryString("page")
				Else
				objRsSubOrders.AbsolutePage = 1
				End If %>
				<% 	End If%>
				<tr   id="t<% = objRs(0) %>_<%=objRsSubOrders(0) %>" align="right" onmouseover="Mark(this);" onmouseout="Unmark(this);" style="display:none">
			  		<td colspan="3" width="200"><font face="Arial" size="2"><b><u>שם</u></b></td>
			 		<td width="50"><u><b>כמות</b></u></td>
			 		<td align="left" width="50"><u><b>מחיר</b></u></td>
			 		<td align="left" width="50"><u><b>סה"כ</b></u></td>
				</tr>		      

				<%
				Do While Not objRsSubOrders.EOF 
				%>
				<tr id="t<% = objRs(0) %>_<%=objRsSubOrders(0) %>" align="right" onmouseover="Mark(this);" onmouseout="Unmark(this);" style="display:none">
			  		<td colspan="3" width="200"><font face="Arial" size="2"><% = objRsSubOrders("ProductName") %></font></td>
			 		<td width="50"><font face="Arial" size="2"><% = objRsSubOrders("Qty") %></font></td>
			 		<td align="left" width="50"><font face="Arial" size="2"><% = objRsSubOrders("ProductPrice")  %></font></td>
			 		<td align="left" width="50"><font face="Arial" size="2"><% = objRsSubOrders("Qty")* objRsSubOrders("ProductPrice")  %></font></td>
				</tr>
				</font>		      
				<% 
				objRsSubOrders.MoveNext
		  		Loop
				%>



</font>
<%	CloseDB(objRsstatus)
objRsSubOrders.Close %>
		  		
		  		
		  		
		  		
		  		
		  		
		  		
	      
				<% HowMany = HowMany + 1
				objRs.MoveNext
		  		Loop
				%>
		  		<tr>
					<td class="Head" align="left" colspan="9" bgcolor="#eeeeee">
					<font size="2" face="Arial">
					<div align="center">
					<table border="0" width="100%" cellspacing="0" cellpadding="0">
						<tr>
							<td width="165">
							&nbsp;</td>
							<td width="355">&nbsp;</td>
							<td width="165">&nbsp;</td>
						</tr>
					</table>
					</div>
			    	</font></td>
		  		</tr>

			</table>
		</td>
	</tr>
</table>
</div><font face="Arial" size="2"><br>
</font>
<%	objRs.Close %>