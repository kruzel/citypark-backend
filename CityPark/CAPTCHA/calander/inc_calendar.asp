<%'@LANGUAGE="VBSCRIPT" CODEPAGE="1255"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1255" />
<title>ASP CSS Calendar Example</title>
<link href="calendar.css" rel="stylesheet" type="text/css" />
</head>

<body>

<h3>ASP CSS Calendar Example</h3>
<table id="calendar" cellspacing="0" cellpadding="0" summary="This month's calendar">
<%
dateToView = request("dateToView")
IF dateToView = "" THEN dateToView = date
daysInCurrentMonth = Day(DateSerial(year(dateToView), month(dateToView) + 1, 0))
firstDateofMonthDate = "1/" & month(dateToView) & "/" & year(dateToView)
firstOfMonthDay = weekday(firstDateofMonthDate)
lastOfMonthDay = weekday(daysInCurrentMonth & "/" & month(dateToView) & "/" & year(dateToView))
previousMonth = DateAdd("m", -1, dateToView)
nextMonth = DateAdd("m", 1, dateToView)
%>
<caption><a href="calendar.asp?dateToView=<%=previousMonth%>" title="View Previous Month (<%=monthName(month(previousMonth))%>)">
&lt;&lt;</a> <%=monthName(month(dateToView))%>  <%=year(dateToView)%> <a href="calendar.asp?dateToView=<%=nextMonth%>"  title="View Next Month (<%=monthName(month(nextMonth))%>)">
&gt;&gt;</a></caption>
  <tr><th abbr="Sunday" title="Sunday">S</th><th abbr="Monday" title="Monday">M</th><th abbr="Tuesday" title="Tuesday">
	T</th><th abbr="Wednesday" title="Wednesday">W</th><th abbr="Thursday" title="Thursday">
	T</th><th abbr="Friday" title="Friday">F</th><th abbr="Saturday" title="Saturday">
	S</th></tr>
<tr>
<%
'WRITTEN BY BOB MCKAY, FRESHMANGO.COM - USE AS YOU WISH BUT PLEASE LEAVE THIS
columnCounter = 0
FOR fillLeadingEmptyDays = 1 TO (firstOfMonthDay - 1)
	columnCounter = columnCounter + 1
	Response.Write("<td></td>")
NEXT
FOR enterDays = 1 TO daysInCurrentMonth
	columnCounter = columnCounter + 1
	Response.Write("<td><a ")
	IF enterDays & "/" & month(dateToView) = day(date) & "/" & month(date) THEN Response.Write(" class = ""today""")
	dayLinkDestination = "#"
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
