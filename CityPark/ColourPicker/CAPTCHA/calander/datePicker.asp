<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Date Picker</title>
<link href="calendar.css" rel="stylesheet" type="text/css" />
<%
dBx = request("dBx")
mBx = request("mBx")
yBx = request("yBx")
%>
<script type="text/javascript">
function applyDate (dayValue,monthValue,yearValue){
	window.opener.document.getElementById("<%=dBx%>").value = dayValue;
	window.opener.document.getElementById("<%=mBx%>").value = monthValue;
	window.opener.document.getElementById("<%=yBx%>").value = yearValue;
	window.close();
}
</script>
</head>
<body>
<table id="calendar" cellspacing="0" cellpadding="0" summary="This month's calendar">
<%
dateToView = request("dateToView")
IF dateToView = "" THEN dateToView = date
daysInCurrentMonth = Day(DateSerial(year(dateToView), month(dateToView) + 1, 0))
firstDateofMonthDate = "1/" & month(dateToView) & "/" & year(dateToView)
firstOfMonthDay = weekday(firstDateofMonthDate)
lastOfMonthDay = weekday(daysInCurrentMonth & "/" & month(dateToView) & "/" & year(dateToView))
prevMonth = DateAdd("m", -1, dateToView)
nextMonth = DateAdd("m", 1, dateToView)
%>
<caption><a href="datePicker.asp?dateToView=<%=prevMonth %>&dBx=<%=dBx%>&mBx=<%=mBx%>&yBx=<%=yBx%>" title="View Previous Month (<%=monthName(month(prevMonth))%>)">&lt;&lt;</a> <%=monthName(month(dateToView))%>  <%=year(dateToView)%> <a href="datePicker.asp?dateToView=<%=nextMonth%>&dBx=<%=dBx%>&mBx=<%=mBx%>&yBx=<%=yBx%>"  title="View Next Month (<%=monthName(month(nextMonth))%>)">&gt;&gt;</a></caption>
  <tr><th abbr="Sunday" title="Sunday">S</th><th abbr="Monday" title="Monday">M</th><th abbr="Tuesday" title="Tuesday">T</th><th abbr="Wednesday" title="Wednesday">W</th><th abbr="Thursday" title="Thursday">T</th><th abbr="Friday" title="Friday">F</th><th abbr="Saturday" title="Saturday">S</th></tr>
<tr>
<%
'WRITTEN BY BOB MCKAY, FRESHMANGO.COM - USE AS YOU WISH BUT PLEASE LEAVE THIS
'ALL CSS AND XHTML BY VEERLE: veerle.duoh.com
columnCounter = 0
FOR fillLeadingEmptyDays = 1 TO (firstOfMonthDay - 1)
	columnCounter = columnCounter + 1
	Response.Write("<td></td>")
NEXT
FOR enterDays = 1 TO daysInCurrentMonth
	columnCounter = columnCounter + 1
	Response.Write("<td><a ")
	IF enterDays & "/" & month(dateToView) = day(date) & "/" & month(date) THEN Response.Write(" class = ""today""")
	dayLinkDestination = "javascript:applyDate(" & enterDays & "," & month(dateToView) & "," & year(dateToView) & ")"
	Response.Write(" href=""" & dayLinkDestination & """>" & enterDays & "</a></td>")
	IF columnCounter = 7 THEN
		Response.Write("</tr><tr>")
		columnCounter = 0
	END IF
NEXT
FOR fillEmptyDays = (columnCounter + 1) TO 7
	IF columnCounter = 0 THEN EXIT FOR
	Response.Write("<td></td>")
NEXT
%></tr>
</table>

</body>
</html>
