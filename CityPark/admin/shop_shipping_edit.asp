<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="../config.asp"-->

<!--#include file="inc_admin_icons.asp"-->
<%
CheckSecuirty "Shipping"
	SQL="SELECT * FROM Shipping WHERE ShippingID=" & Request.Querystring("ID")

if Request.Querystring("mode") = "doit" Then
		Set objRs = OpenDB(SQL)
		objRs("ShippingName") = Request.Form("ShippingName")
		objRs("ShippingCost") = Request.Form("ShippingCost")
		objRs.Update 
Response.Write("<br><br><div align='center'>אמצעי משלוח נערך בהצלחה <a href='shop_Shipping.asp?S=" & SiteID & "''>לחץ להמשך</a>!</p>")
Response.Write("<meta http-equiv='Refresh' content='1; URL=shop_Shipping.asp?S=" & SiteID & "''>")
		CloseDB(objRs)
Else

		Set objRs = OpenDB(SQL)	
%>
<form action="shop_shipping_edit.asp?mode=doit&ID=<%=Request.Querystring("ID")%>" method="Post">
	<div align="center" style="margin-top:20px;">
	<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td width="0"><table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font  face="Arial" size="2">&nbsp;עריכת צורת משלוח</font></b></td>
				</tr></table>
<table border="0" width="100%" cellspacing="0" cellpadding="4">
	 <tr>
		<td valign="top" align="right"><font face="Arial" size="2">שם:</font></td>
		<td valign="top" align="right"><input type="text" name="ShippingName" size="50" maxlength="50"  value="<% = objRs("ShippingName") %>"></td>	 	 </tr>
	  <tr>
		<td valign="top" align="right"><font face="Arial" size="2">מחיר:</font></td>
		<td valign="top" align="right"><input type="text" name="ShippingCost" size="20" maxlength="20"  value="<% = objRs("ShippingCost") %>">
		</td>
		</tr>
	<tr>			
		<td valign="top" align="center" colspan="2" bgcolor="#dddddd"> <font face="Arial">
	<input type="submit" value="עדכן"/>
</font>		
    	</td>
	  </tr>
 </table>
			    </td>
			  </tr>
			</table>
			</div>
</form>
			
<%	
	CloseDB(objRs)
	End If
%>