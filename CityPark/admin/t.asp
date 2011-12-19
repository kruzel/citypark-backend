<!--#include file="../config.asp"-->
<!--#include file="../md5.asp"-->
<!--#include file="../inc_cart.asp"-->
<!--#include file="../hash.asp"-->
<%
header
SQL = "SELECT * FROM Orders WHERE ordersID = " & Request.Querystring("ID")
Set objRs = OpenDB(SQL)
If Request.Querystring("mode") = "Update" Then
		'objRs("OrdersStatus") = 1
		objRs("Total") = Request.Form("Total") 
		objRs("ShipMethod") =	Request.Form("ShipMethod") 
		objRs("ShipCost") =	Request.Form("ShipCost") 
		objRs("shipName") = Request.Form("shipName") 
		objRs("shipFailyName") = Request.Form("shipFailyName") 
		objRs("shipaddress") = Request.Form("shipaddress") 
		objRs("shipaddress2") = Request.Form("shipaddress2") 
		objRs("shipCity") = Request.Form("shipCity") 
		objRs("shipCountry") = Request.Form("shipCountry") 
		objRs("shipZipcode") = Request.Form("shipZipcode") 
		objRs("shipCompany") = Request.Form("shipCompany")
		


		objRs("PaymentMethod") = Request.Form("PaymentMethod")
		objRs("CName") = Request.Form("CName")
		objRs("IdNumber") = Request.Form("IdNumber")
		objRs("CAddress") = Request.Form("CAddress")
		objRs("CardNumber") = EnDecrypt(Request.Form("CardNumber"),encryptkey )
		objRs("Month") = Request.Form("Month")
		objRs("year") = Request.Form("year")
		objRs("Cnv") = Request.Form("Cnv")
		objRs("Comments") = Request.Form("Comments")
		objRs.Update
		CloseDB(objRs)
				print"<br><br><p align='center'>הזמנה נערכה בהצלחה. <a href='shop_orders.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>"
				print"<meta http-equiv='Refresh' Product='1; URL=shop_orders.asp?S=" & SiteID & "'>"

		print "ההזמנה עודכנה בהצלחה"
Else

%>
<Form action="shop_orders_edit.asp?mode=Update&ID=<% =Request.Querystring("ID")%>" method="post">
<%
strMessageBody = strMessageBody & "<tr><td colspan=""5"" align=""right"" style=""text-weight: bold; font-size: 20px;"">פרטי המשלוח</td></tr>"
strMessageBody = strMessageBody & "<tr><th  align=""right"">צורת המשלוח:</th><td colspan=""4"" align=""right""><input type=""text"" name=""ShipMethod"" size=""30"" value=""" & objRs("ShipMethod") & """></td></tr>"
strMessageBody = strMessageBody & "<tr><th  align=""right"">צורת המשלוח:</th><td colspan=""4"" align=""right"">" & objRs("ShipMethod") & "</td></tr>"

strMessageBody = strMessageBody & "</table>"
Print strMessageBody %>
</Form>
<input type="text" name="ShipMethod" size="20"  value="<% = objRs("ShipMethod")%>">

<% End If
bottom %>