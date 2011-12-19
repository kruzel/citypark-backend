<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<SCRIPT LANGUAGE="JavaScript">
 
function textCounter(field, countfield, maxlimit) {
if (field.value.length > maxlimit) // if too long...trim it!
field.value = field.value.substring(0, maxlimit);
// otherwise, update 'characters left' counter
else 
countfield.value = maxlimit - field.value.length;
}
</script>

<script language="javascript" type="text/javascript">
// <!CDATA[

function newrecord_onclick() {

}

// ]]>
</script>
<!--#include file="../config.asp"-->

<!--#include file="inc_admin_icons.asp"-->

<% 
CheckSecuirty "Product"

		If Request.QueryString("mode") = "doit" Then
						Set objRs = OpenDB("SELECT * FROM Product WHERE ProductID= " & Request.Querystring("ID"))	
								objRs.Delete
							objRs.Close
								Response.Write("<br><br><p align='center'>מוצר נמחק בהצלחה. <a href='shop_Product.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' Product='1; URL=shop_Product.asp?S=" & SiteID & "'>")
		Else
		
						Set objRs = OpenDB("SELECT * FROM Product WHERE ProductID= " & Request.Querystring("ID"))	
			 	
%>
<form name="Product" action="shop_Product_delete.asp?mode=doit&amp;ID=<% = Request.QueryString("ID") %>&S=<% = SiteID %>" method="post">
<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td width="0">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp;מחיקת מוצר</font></b></td>
				</tr></table>
			<table border="0" width="100%" cellspacing="0" cellpadding="4">
			    <tr>
				    <td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">שם מוצר:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 300px;" type="text" 
     name="ProductName" size="50" maxlength="100" 
     value="<% = objRS("ProductName") %>"><font size="2">
					</font></font>
					</td>
			    </tr>
				<tr>
				    <td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">מספר קטלוגי:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 300px;" type="text" name="ProductCode" size="50" maxlength="100" value="<% = objRS("ProductCode") %>"><font size="2">
					</font></font>
					</td>
			    </tr>
			    <tr>
					<td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">תאור קצר:</font></td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
					<textarea style="width: 300px;" rows="6" name="ProductShortText" cols="43" onKeyDown="textCounter(this.form.ProductShortText,this.form.remLen,200);" onKeyUp="textCounter(this.form.ProductShortText,this.form.remLen,200);"><% = objRS("ShortDescription") %></textarea></font>
			   <br>
			   		<font size="1">
			   <input readonly type=text name=remLen size=1 maxlength=3 value="200"> תווים (מקסימום 200)</font>
					</font>
				</td>
 					</tr>
			    <tr>			
					<td valign="top" align="center" colspan="2" height="22" bgcolor="#DDDDDD">
					<font face="Arial">
					<input type="submit" id="save" value="מחק מוצר"></font></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>
</form>
<br />
<%			
End if
%>