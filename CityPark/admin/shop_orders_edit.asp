<!--#include file="../config.asp"-->
<!--#include file="../inc_cart.asp"-->
<%
header
SQL = "SELECT * FROM Orders WHERE ordersID = " & Request.Querystring("ID")
Set objRs = OpenDB(SQL)
If Request.Querystring("mode") = "Update" Then
		objRs("OrdersStatus") = Request.Form("status")
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
Elseif Request.Querystring("mode") = "delete" Then

			SQLSub = "SELECT * FROM SubOrders WHERE ordersID = " & Request.Querystring("ID")
			Set objRsSub = OpenDB(SQLSub)
			Do Until objRsSub.EOF
			objRsSub.Delete
				objRsSub.MoveNext
					Loop
			CloseDB(objRSSub)
	objRs.Delete
	CloseDB(objRs)
			print"<br><br><p align='center'>הזמנה נמחקה בהצלחה. <a href='shop_orders.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>"
			print"<meta http-equiv='Refresh' Product='1; URL=shop_orders.asp?S=" & SiteID & "'>"

Else
%>
<Form action="shop_orders_edit.asp?mode=Update&ID=<% =Request.Querystring("ID")%>" method="post">
<%
strMessageBody = strMessageBody & "<table border=""1"" dir=""rtl"" align=""right"" width=""500"">"
strMessageBody = strMessageBody & "<tr><td colspan=""5"" align=""right"" style=""text-weight: bold; font-size: 20px;"">" & OrderdetailsText & "</td></tr>"
strMessageBody = strMessageBody & "<tr><td   align=""right"">הזמנה מספר:</td><td align=""right"" colspan=""4"">" & objRs("OrdersID") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><td   align=""right"">תאריך ושעת ההזמנה:</td><td align=""right"" colspan=""4"">" & objRs("date") & "</td></tr>"
	Set objRsstatus = OpenDB("Select * From Orderstatus")
strMessageBody = strMessageBody & "<tr><td align=""right"">סטטוס ההזמנה:</td><td align=""right"" colspan=""4""><select name=""status"">"
	Do While NOT objRsstatus.EOF
strMessageBody = strMessageBody & "<option value=" & objRsstatus("OrderStatusID") 
if objRsstatus("OrderStatusID")= objRs("OrdersStatus") then strMessageBody = strMessageBody & " selected=""selected""" 
strMessageBody = strMessageBody & ">" & objRsstatus("OrderStatusName")& "</option>"
	objRsstatus.MoveNext
		Loop
CloseDB(objRsstatus)
strMessageBody = strMessageBody & "</select></td><tr>"

strMessageBody = strMessageBody & "<tr><td>מספר</td><td>תאור</td><td>כמות</td><td>מחיר יחידה</td><td>סהכ</td></tr>" 
			SQLSub = "SELECT * FROM SubOrders WHERE ordersID = " & Request.Querystring("ID")
			Set objRsSub = OpenDB(SQLSub)
			Do While NOT objRsSub.EOF
					strMessageBody = strMessageBody & "<tr><td align=""center"">"& objRsSub("ProductID")& "</td>"
					strMessageBody = strMessageBody & "<td align=""right"" width=""200"">" & objRsSub("ProductName") & "</td>"
					strMessageBody = strMessageBody & "<td align=""center"">" & objRsSub("Qty") & "</td>"
					strMessageBody = strMessageBody & "<td align=""right"">₪" &  objRsSub("ProductPrice") & "</td>" 
					strMessageBody = strMessageBody & "<td align=""right"">₪" &  FormatNumber(objRsSub("Qty") * objRsSub("ProductPrice"), 2) & "</td><tr>"
			objRsSub.MoveNext
				Loop
			CloseDB(objRSSub)
strMessageBody = strMessageBody & "<tr><td colspan=""5"">" & vbCrLf & "</td></tr>"
strMessageBody = strMessageBody & "<tr><td  align=""right""><b>משלוח:</b></td><td align=""Left""colspan=""4"">₪<input type=""text"" name=""ShipCost"" value=""" & objRs("ShipCost")&""" size=""6""</td></tr>"
strMessageBody = strMessageBody & "<tr><td  align=""right""><b>סהכ:</b></td><td align=""Left""colspan=""4"">₪<input  type=""text"" name=""Total"" value=""" &objRs("Total")& """ size=""6"" </td></tr>"
strMessageBody = strMessageBody & "<tr><td colspan=""5"" align=""right"" style=""text-weight: bold; font-size: 20px;"">פרטי המשלוח</td></tr>"
strMessageBody = strMessageBody & "<tr><th  align=""right"">צורת המשלוח:</th><td colspan=""4"" align=""right""><input type=""text"" name=""ShipMethod"" value="""& objRs("ShipMethod")& """ size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th  align=""right"">שם פרטי:</th><td colspan=""4"" align=""right""><input type=""text"" name=""shipName"" value="""& objRs("shipName")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">שם משפחה:</th><td align=""right"" colspan=""4""><input type=""text"" name=""shipFailyName"" value="""& objRs("shipFailyName")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת:</th><td align=""right"" colspan=""4""><input type=""text"" name=""shipAddress"" value="""& objRs("shipAddress")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת 2:</th><td align=""right"" colspan=""4""><input type=""text"" name=""shipAddress2"" value="""& objRs("shipAddress2")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">עיר:</th><td align=""right"" colspan=""4""><input type=""text"" name=""shipCity"" value="""& objRs("shipCity")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מיקוד:</th><td align=""right"" colspan=""4""><input type=""text"" name=""shipZipcode"" value="""& objRs("shipZipcode")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מדינה:</th><td align=""right"" colspan=""4""><input  type=""text"" name=""shipCountry"" value="""& objRs("shipCountry")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">חברה:</th><td align=""right"" colspan=""4""><input type=""text"" name=""shipCompany"" value="""& objRs("shipCompany")& """size=""30""</td></tr>"
	
strMessageBody = strMessageBody & "<tr><td colspan=""5"" align=""right"" style=""text-weight: bold; font-size: 20px;"">פרטי התשלום</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">אמצעי תשלום:</th><td align=""right"" colspan=""4""><input type=""text"" name=""PaymentMethod"" value="""& objRs("PaymentMethod")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">שם בעל הכרטיס:</th><td align=""right"" colspan=""4""><input type=""text"" name=""CName"" value="""& objRs("CName")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מספר תעודת זהות:</th><td align=""right"" colspan=""4""><input type=""text"" name=""IdNumber"" value="""& objRs("IdNumber")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת:</th><td align=""right"" colspan=""4""><input type=""text"" name=""CAddress"" value="""& objRs("CAddress")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מספר כרטיס אשראי:</th><td align=""right"" colspan=""4""><input type=""text"" name=""CardNumber"" value="""& EnDecrypt(objRs("CardNumber"),encryptkey) &""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th align=""right"">תוקף הכרטיס</th><td align=""right""> חודש  <select name=""Month"" style=""width: 60px;"">"
	for x=1 to 12
strMessageBody = strMessageBody &"<option value=" & x 

if x= objRs("Month") then strMessageBody = strMessageBody & " selected=""selected""" 

strMessageBody = strMessageBody & ">" & x & "</option>"
		Next
strMessageBody = strMessageBody &"</select>"
strMessageBody = strMessageBody & "    שנה  <select name=""Year"" style=""width: 60px;"">"
	for x=2009 to 2015
strMessageBody = strMessageBody &"<option value=" & x 

if x= objRs("Year") then strMessageBody = strMessageBody & " selected=""selected""" 

strMessageBody = strMessageBody & ">" & x & "</option>"
		Next
strMessageBody = strMessageBody &"</select></td>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">קוד אימות בגב כרטיס:</th><td align=""right"" colspan=""4""><input type=""text"" name=""Cnv"" value="""& objRs("Cnv")&""" size=""30""</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">הערות::</th><td align=""right"" colspan=""4""><textarea rows=""6"" name=""Comments"" cols=""40"">" & objRs("Comments") & "</textarea>"
strMessageBody = strMessageBody & "<td align=""right""></td><tr><td colspan=""5"" align=""left""><input type=""submit"" value=""עדכן"" /></td></tr>" 	
strMessageBody = strMessageBody & "</table>"
Print strMessageBody %>
</Form>
<% End If
bottom %>