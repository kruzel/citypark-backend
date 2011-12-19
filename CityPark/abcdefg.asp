<!--#include file="config.asp"-->
<!--#include file="admin/inc_admin_icons.asp"-->

<%
CheckSecuirty "DshopAtarim"
	Set objRs = OpenDB("SELECT DshopCust.Email, DshopCust.DshopCustCell AS Cellular, DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) As diff, dshopatarim.DshopAtarimPayDate AS PayDate FROM dshopatarim INNER JOIN DshopCust ON dshopatarim.DshopCustID = DshopCust.DshopCustID WHERE (dshopatarim.DshopAtarimStatID = 3) AND (dshopatarim.DshopProductsID = 1) AND (DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) = 30) ORDER BY PayDate")
	%>
		<table border="1" cellspacing="0" width="900">
		<tr>
			<td><% = FormatDateTime(Now()) %></td>
		</tr>
	</table>

	<h1>צריכים לשלם בעוד חודש</h1>
	<table border="1" cellspacing="0" width="900">
		<tr>
			<th bgcolor="#eeeeee" width="350">Email</th>
			<th bgcolor="#eeeeee" width="200">סלולרי</th>
			<th bgcolor="#eeeeee" width="200">תאריך תשלום</th>
			<th bgcolor="#eeeeee" width="150">diff</th>
		</tr>
	<%
	Do Until objRs.EOF
		%>
		<tr>
			<td><% = objRs("Email") %></td>
			<td><% = objRs("Cellular") %></td>			
			<td><% = objRs("Paydate") %></td>
			<td><% = objRs("diff") %></td>
		</tr>
		<%		
		objRs.MoveNext
	Loop
	%>
	</table>
	<div style="width:900px;"><b>הודעה למייל: לקוח יקר, בעוד חודש תסתיים תקופת האחזקה השנתית של אתרך, אנא צור קשר כדי לחדש לשנה נוספת. תודה, צוות dooble.</b></div>
<div style="width:900px;"><b>הודעת SMS: לקוח יקר,בעוד חודש תסתיים תקופת האחזקה לאתרך, צור קשר לחידוש. dooble.</b></div>
	<br/>
	<%
	CloseDB(objRS)	

	Set objRs = OpenDB("SELECT DshopCust.Email, DshopCust.DshopCustCell AS Cellular, DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) As diff, dshopatarim.DshopAtarimPayDate AS PayDate FROM dshopatarim INNER JOIN DshopCust ON dshopatarim.DshopCustID = DshopCust.DshopCustID WHERE (dshopatarim.DshopAtarimStatID = 3) AND (dshopatarim.DshopProductsID = 1) AND (DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) = 14) ORDER BY PayDate")
	%>
	<h1>צריכים לשלם בעוד שבועיים</h1>
	<table border="1" cellspacing="0" width="900">
		<tr>
			<th bgcolor="#eeeeee" width="350">Email</th>
			<th bgcolor="#eeeeee" width="200">סלולרי</th>
			<th bgcolor="#eeeeee" width="200">תאריך תשלום</th>
			<th bgcolor="#eeeeee" width="150">diff</th>
		</tr>
	<%
	Do Until objRs.EOF
		%>
		<tr>
			<td><% = objRs("Email") %></td>
			<td><% = objRs("Cellular") %></td>			
			<td><% = objRs("Paydate") %></td>
			<td><% = objRs("diff") %></td>
		</tr>
		<%		
		objRs.MoveNext
	Loop
	%>
	</table>
	<div style="width:900px;"><b>הודעה במייל: לקוח יקר, בעוד שבועיים תסתיים תקופת האחזקה השנתית של אתרך ועדיין לא חדשת לשנה נוספת, אנא צור קשר בהקדם כדי להסדיר את הנושא. תודה, צוות dooble.</b></div>
	<div style="width:900px;"><b>הודעת SMS: לקוח יקר,בעוד שבועיים תסתיים תקופת האחזקה ועדיין לא חידשת. dooble.</b></div>
	<br/>
	<%
	CloseDB(objRS)	
	
	Set objRs = OpenDB("SELECT DshopCust.Email, DshopCust.DshopCustCell AS Cellular, DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) As diff, dshopatarim.DshopAtarimPayDate AS PayDate FROM dshopatarim INNER JOIN DshopCust ON dshopatarim.DshopCustID = DshopCust.DshopCustID WHERE (dshopatarim.DshopAtarimStatID = 3) AND (dshopatarim.DshopProductsID = 1) AND (DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) = 7) ORDER BY PayDate")
	%>
	<h1>צריכים לשלם בעוד שבוע</h1>
	<table border="1" cellspacing="0" width="900">
		<tr>
			<th bgcolor="#eeeeee" width="350">Email</th>
			<th bgcolor="#eeeeee" width="200">סלולרי</th>
			<th bgcolor="#eeeeee" width="200">תאריך תשלום</th>
			<th bgcolor="#eeeeee" width="150">diff</th>
		</tr>
	<%
	Do Until objRs.EOF
		%>
		<tr>
			<td><% = objRs("Email") %></td>
			<td><% = objRs("Cellular") %></td>			
			<td><% = objRs("Paydate") %></td>
			<td><% = objRs("diff") %></td>
		</tr>
		<%		
		objRs.MoveNext
	Loop
	%>
	</table>
	<div style="width:900px;"><b>הודעה במייל: לקוח יקר, בעוד שבוע תסתיים תקופת האחזקה השנתית של אתרך ועדיין לא חדשת לשנה נוספת, אנא צור קשר בהקדם כדי להסדיר את הנושא. תודה, צוות dooble.</b></div>
	<div style="width:900px;"><b>הודעת SMS: לקוח יקר,עוד שבוע תסתיים תקופת האחזקה,צור קשר כדי לחדש בהקדם. dooble.</b></div>
	<br/>
	<%
	CloseDB(objRS)
	
	Set objRs = OpenDB("SELECT DshopCust.Email, DshopCust.DshopCustCell AS Cellular, DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) As diff, dshopatarim.DshopAtarimPayDate AS PayDate FROM dshopatarim INNER JOIN DshopCust ON dshopatarim.DshopCustID = DshopCust.DshopCustID WHERE (dshopatarim.DshopAtarimStatID = 3) AND (dshopatarim.DshopProductsID = 1) AND (DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) = 3) ORDER BY PayDate")
	%>
	<h1>צרכים לשלם בעוד 3 ימים</h1>
	<table border="1" cellspacing="0" width="900">
		<tr>
			<th bgcolor="#eeeeee" width="350">Email</th>
			<th bgcolor="#eeeeee" width="200">סלולרי</th>
			<th bgcolor="#eeeeee" width="200">תאריך תשלום</th>
			<th bgcolor="#eeeeee" width="150">diff</th>
		</tr>
	<%
	Do Until objRs.EOF
		%>
		<tr>
			<td><% = objRs("Email") %></td>
			<td><% = objRs("Cellular") %></td>			
			<td><% = objRs("Paydate") %></td>
			<td><% = objRs("diff") %></td>
		</tr>
		<%		
		objRs.MoveNext
	Loop
	%>
	</table>
	<div style="width:900px;"><b>הודעה במייל: לקוח יקר, בעוד 3 ימים תסתיים תקופת האחזקה השנתית של אתרך ועדיין לא חדשת לשנה נוספת, במידה ולא תסדיר את התשלום תוך 3 ימים ירד האתר מהאויר. תודה, צוות dooble.</b></div>
	<div style="width:900px;"><b>הודעת SMS: לקוח יקר, במידה ולא תחדש את אתרך תוך 3 ימים הוא ירד מהאויר. dooble.</b></div>
	<br/>
	<%
	CloseDB(objRS)
	
	Set objRs = OpenDB("SELECT DshopCust.Email, DshopCust.DshopCustCell AS Cellular, DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) As diff, dshopatarim.DshopAtarimPayDate AS PayDate FROM dshopatarim INNER JOIN DshopCust ON dshopatarim.DshopCustID = DshopCust.DshopCustID WHERE (dshopatarim.DshopAtarimStatID = 3) AND (dshopatarim.DshopProductsID = 1) AND (DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) = 1) ORDER BY PayDate")
	%>
	<h1>צריכים לשלם מחר</h1>
	<table border="1" cellspacing="0" width="900">
		<tr>
			<th bgcolor="#eeeeee" width="350">Email</th>
			<th bgcolor="#eeeeee" width="200">סלולרי</th>
			<th bgcolor="#eeeeee" width="200">תאריך תשלום</th>
			<th bgcolor="#eeeeee" width="150">diff</th>
		</tr>
	<%
	Do Until objRs.EOF
		%>
		<tr>
			<td><% = objRs("Email") %></td>
			<td><% = objRs("Cellular") %></td>			
			<td><% = objRs("Paydate") %></td>
			<td><% = objRs("diff") %></td>
		</tr>
		<%		
		objRs.MoveNext
	Loop
	%>
</table>
<div style="width:900px;"><b>הודעה במייל: לקוח יקר, זוהי הודעה אחרונה! מחר תסתיים תקופת האחזקה השנתית של אתרך ועדיין לא חדשת לשנה נוספת, במידה ולא תסדיר את התשלום ב-24 שעות הקרובות ירד האתר מהאויר. תודה, צוות dooble.</b></div>
<div style="width:900px;"><b>הודעת SMS: הודעה אחרונה! במידה ולא תחדש אתרך תוך 24 ש' הוא ירד מהאויר. dooble.</b></div>
<br />
	<%
	CloseDB(objRS)	

Set objRs = OpenDB("SELECT DshopCust.Email, DshopCust.DshopCustCell AS Cellular, DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) As diff, dshopatarim.DshopAtarimPayDate AS PayDate FROM dshopatarim INNER JOIN DshopCust ON dshopatarim.DshopCustID = DshopCust.DshopCustID WHERE (dshopatarim.DshopAtarimStatID = 3) AND (dshopatarim.DshopProductsID = 1) AND (DATEDIFF(day, GETDATE(), dshopatarim.DshopAtarimPayDate) = 0) ORDER BY PayDate")
	%>
	<h1>צריכים לשלם היום</h1>
	<table border="1" cellspacing="0" width="900">
		<tr>
			<th bgcolor="#eeeeee" width="350">Email</th>
			<th bgcolor="#eeeeee" width="200">סלולרי</th>
			<th bgcolor="#eeeeee" width="200">תאריך תשלום</th>
			<th bgcolor="#eeeeee" width="150">diff</th>
		</tr>
	<%
	Do Until objRs.EOF
		%>
		<tr>
			<td><% = objRs("Email") %></td>
			<td><% = objRs("Cellular") %></td>			
			<td><% = objRs("Paydate") %></td>
			<td><% = objRs("diff") %></td>
		</tr>
		<%		
		objRs.MoveNext
	Loop
	%>
	</table>
	<div style="width:900px;"><b>הודעה במייל: לקוח יקר, עקב אי הסדרת התשלומים עבור אחזקה ואחסון, ירד האתר מהאויר. תודה, צוות dooble.</b></div>
	<div style="width:900px;"><b>הודעת SMS: לקוח יקר, עקב אי-הסדרת התשלום אתרך ירד מהאויר. dooble.</b></div>
	<br />
	<%
	CloseDB(objRS)		
%>