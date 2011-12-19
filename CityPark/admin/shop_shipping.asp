<!--#include file="../config.asp"-->
<!--#include file="../$db.asp"-->
<!--#include file="inc_admin_icons.asp"-->
<script type="text/javascript">
var doConfirm = function(id)
{
var link = document.getElementById(id);
if(confirm("האם אתה בטוח שברצונך למחוק?"))
return true;
else
return false;
}
</script>

<%	
CheckSecuirty "shiping"
		URL = "SELECT * FROM Shipping WHERE SiteID=" & SiteID & " ORDER BY ShippingID ASC"
	Set objRs = OpenDB(URL)
	objRs.PageSize=20

%>
<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td background="/images/menuin.jpg" height="30" width="360">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp;ניהול צורות משלוח</font></b><font face="Arial">
	<font color="#FFFFFF" size="2">
	<a style="text-decoration: none; color: #FFFFFF" 
 href="shop_shipping_edit.asp">  ( הוסף אמצעי משלוח )  </a></font></font></td>
		<td background="/images/menuin.jpg" height="30" width="338">
</td></tr>
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
					<td align="left" colspan="4">
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
					<a href="shop_Shipping.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
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
					<a href="shop_Shipping.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
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
	        			<td valign="top" width="56%" bgcolor="#eeeeee" align="right">
						<font face="Arial" size="2"><b>כותרת</b></td>
	        			<td valign="top" colspan="4" bgcolor="#eeeeee" 
      align="right"><font face="Arial" size="2"><b>פעולות</b></font></td>
	      		</tr>		  
				<% HowMany = 0
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize
				%>
				<tr align="right" onmouseover="Mark(this);" onmouseout="Unmark(this);">
			  		<td font face="Arial" size="2" ><a href="shop_Shipping_edit.asp?ID=<% = objRS("ShippingID") %>&S=<% = SiteID %>" style="text-decoration: none">	
					<font color="#808080"><% = objRs("ShippingName") %></a></font></td>
<td font face="Arial" size="2" ><a href="shop_Shipping_edit.asp?ID=<% = objRS("ShippingID") %>&S=<% = SiteID %>" style="text-decoration: none">	
					<font color="#808080"> ₪ <% = objRs("ShippingCost") %></a></font></td>
			 		<td width="30">
					<font face="Arial" size="2">
					<a href="shop_Shipping_edit.asp?ID=<% = objRS("ShippingID") %>&S=<% = SiteID %>" style="text-decoration: none">	
					<font color="#808080">ערוך</font></a></font></td>
			 		<td width="16">
					<font face="Arial" size="2"><a href="shop_Shipping_edit.asp?ID=<% = objRS("ShippingID") %>&S=<% = SiteID %>&mode=Delete" style="text-decoration: none" id="link" onclick="return doConfirm(this.id);">
					<img border="0" src="/images/delete.jpg" width="16" height="16"></a></font></td>
			 		<td width="35">
					<font face="Arial" size="2">
					<a href="shop_Shipping_edit.asp?ID=<% = objRS("ShippingID") %>&S=<% = SiteID %>&mode=Delete" style="text-decoration: none" id="link" onclick="return doConfirm(this.id);">
					<font color="#808080">מחק</font></a>&nbsp;	</font></td>
				</tr>		      
				<% HowMany = HowMany + 1
				objRs.MoveNext
		  		Loop
				%>
		  		<tr>
					<td class="Head" align="left" colspan="5" bgcolor="#eeeeee">
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