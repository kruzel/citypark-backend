<!--#include file="../config.asp"-->
<!--#include file="../md5.asp"-->
<!--#include file="../inc_cart.asp"-->
<!--#include file="../hash.asp"-->
<%
header
SQL = "SELECT * FROM Orders WHERE ordersID = " & Request.Querystring("ID")
Set objRs = OpenDB(SQL)

strMessageBody = strMessageBody & "<table border=""1"" dir=""rtl"" align=""right"" width=""500"">"
strMessageBody = strMessageBody & "<tr><td colspan=""5"" align=""right"" style=""text-weight: bold; font-size: 20px;"">" & OrderdetailsText & "</td></tr>"
strMessageBody = strMessageBody & "<tr><td   align=""right"">הזמנה מספר:</td><td align=""right"" colspan=""4"">" & objRs("OrdersID") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><td   align=""right"">תאריך ושעת ההזמנה:</td><td align=""right"" colspan=""4"">" & objRs("date") & "</td></tr>"
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
strMessageBody = strMessageBody & "<tr><td  align=""right""><b>משלוח:</b></td><td align=""right""colspan=""4"">₪" &  FormatNumber(objRs("ShipCost"), 2) & "</td></tr>"
strMessageBody = strMessageBody & "<tr><td  align=""right""><b>סהכ:</b></td><td align=""right""colspan=""4"">₪" &  FormatNumber(objRs("Total")+objRs("ShipCost"), 2) & "</td></tr>"

SQLUsers = "SELECT * FROM Users WHERE usersID = " & objRs("UsersID")
Set objRsUsers = OpenDB(SQLUsers )
		
strMessageBody = strMessageBody & "<tr><td colspan=""4"" align=""right"" style=""text-weight: bold; font-size: 20px;"">פרטי הלקוח</td><td><a href=admin_users_edit.asp?ID=" & objRs("UsersID" )& ">ערוך</a></td></tr>"
strMessageBody = strMessageBody & "<tr><th  align=""right"">שם פרטי:</th><td colspan=""4"" align=""right"">" & objRsUsers("Name") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">שם משפחה:</th><td align=""right"" colspan=""4"">" & objRsUsers("FamilyName") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">טלפון:</th><td align=""right"" colspan=""4"">" & objRsUsers("Phone") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">סלולרי:</th><td align=""right"" colspan=""4"">" & objRsUsers("Cellular") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">אימייל:</th><td align=""right"" colspan=""4"">" & objRsUsers("Email") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת:</th><td align=""right"" colspan=""4"">" & objRsUsers("Address") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת 2:</th><td align=""right"" colspan=""4"">" & objRsUsers("Address2") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">עיר:</th><td align=""right"" colspan=""4"">" & objRsUsers("City") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מיקוד:</th><td align=""right"" colspan=""4"">" & objRsUsers("Zipcode") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מדינה:</th><td align=""right"" colspan=""4"">" & objRsUsers("Country") & "</td></tr>"
CloseDB(objRsUsers)
strMessageBody = strMessageBody & "<tr><td colspan=""5"" align=""right"" style=""text-weight: bold; font-size: 20px;"">פרטי המשלוח</td></tr>"
strMessageBody = strMessageBody & "<tr><th  align=""right"">צורת המשלוח:</th><td colspan=""4"" align=""right"">" & objRs("ShipMethod") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th  align=""right"">שם פרטי:</th><td colspan=""4"" align=""right"">" & objRs("shipName") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">שם משפחה:</th><td align=""right"" colspan=""4"">" 		& objRs("shipFailyName") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת:</th><td align=""right"" colspan=""4"">" & objRs("shipAddress") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת 2:</th><td align=""right"" colspan=""4"">" & objRs("shipAddress2") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">עיר:</th><td align=""right"" colspan=""4"">" & objRs("shipCity") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מיקוד:</th><td align=""right"" colspan=""4"">" & objRs("shipZipcode") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מדינה:</th><td align=""right"" colspan=""4"">" & objRs("shipCountry") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">חברה:</th><td align=""right"" colspan=""4"">" & objRs("shipCompany") & "</td></tr>"
	
strMessageBody = strMessageBody & "<tr><td colspan=""5"" align=""right"" style=""text-weight: bold; font-size: 20px;"">פרטי התשלום</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">אמצעי תשלום:</th><td align=""right"" colspan=""4"">" & objRs("PaymentMethod") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">שם בעל הכרטיס:</th><td align=""right"" colspan=""4"">" & objRs("CName") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מספר תעודת זהות:</th><td align=""right"" colspan=""4"">" & objRs("IdNumber") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">כתובת:</th><td align=""right"" colspan=""4"">" & objRs("CAddress") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">מספר כרטיס אשראי:</th><td align=""right"" colspan=""4"">" & EnDecrypt(objRs("CardNumber"),encryptkey) & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">תוקף הכרטיס:</th>&nbsp;<td align=""right"" colspan=""4"">" & objRs("Month") & "/" & objRs("year")& "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">קוד אימות בגב כרטיס:</th><td align=""right"" colspan=""4"">" & objRs("Cnv") & "</td></tr>"
strMessageBody = strMessageBody & "<tr><th   align=""right"">הערות::</th><td align=""right"" colspan=""4"">" & objRs("Comments") & "</td></tr>"
strMessageBody = strMessageBody & "</table>"
Print strMessageBody 
bottom %>
