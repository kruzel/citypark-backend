<!--#include file="config.asp"-->
<%
Header
	Set objConn = Server.CreateObject("ADODB.Connection")
	Set objRs = Server.CreateObject("ADODB.Recordset")
	objConn.Open strConn

' // Settings
body_bg = Application(ScriptName & "DefaultBGColor")
bg = Application(ScriptName & "DefaultBGColor")
nodaycell = Application(ScriptName & "TableHeaderBGColor")
todayCell = Application(ScriptName & "TableHeaderBGColor")
tablewidth = "100%"
cell_height2 = 80

monthstart = 1 'Start from January
monthend = 12 'End at december

'Display last year, this year and next year.
yearstart = year(date) - 1
yearend = year(date) + 1


'response.write "<body bgcolor="""&body_bg&""">"



If request("idcal") <> "" Then
  
		' // GET EVENT BY ID
  		objRs.open "SELECT * FROM calendarEvent where ID = "& Request.QueryString("idcal"),objConn,0,1
		if objRs.bof or objRs.eof then
			response.write "אין ארועים."
		else
			eyeD = objRs("id")
			title = objRs("title")
			descr = objRs("description")
			admin = objRs("admin")
		end if
  		objRs.close

		response.write "<div id=""calltext"">"
				response.write "<span class=""caltitle"">"&title&"</span>"
				response.write descr
				response.write "<center><hr noshade width=""50%"">"
				If Session(SiteID & "Type") = "Admin" Then 
					response.write "<a href=""admin/admin_calendar_edit.asp?id="&eyeD&""">(ערוך)</a> | <a href=""admin/admin_calendar_delete.asp?idcal="&eyeD&""">(מחק)</a></center>"
			end if

		response.write "<a href=""calendar.asp"">חזור</a></div>"
else


if trim(request.form("curMonth")) <> "" then
  curMonth = trim(request.form("curMonth"))
	if isNumeric(curMonth) then
		if cint(curMonth) < 1 OR cint(curMonth) > 12 then
		  curMonth = month(Date)
		end if
	else
	  curMonth = month(Date)
	end if
else
  curMonth = month(Date)
end if

if trim(request.form("curDay")) <> "" then
  curDay = trim(request.form("curDay"))
	if isNumeric(curDay) then
		if curDay < 1 OR curDay > 31 then
		  curDay = Day(Date)
	 	end if
	else
  	curDay = Day(Date)
	end if
Else
  curDay = Day(Date)
End If

if trim(request.form("curYear")) <> "" then
  curYear = trim(request.form("curYear"))
	if isNumeric(curYear) then
		if curYear < 1 OR curYear > 31 then
		  curYear = Year(Date)
	 	end if
	else
  	vcurYear = year(Date)
	end if
Else
  curYear = year(Date)
End If


'search for valid date (2/31/2001 -> 2/28/2001)
while not isDate(curMonth&"/"&curDay&"/"&curYear) 
  curDay = curDay - 1
wend

'look for lasy day number of the current month
searchEnd = 31
while not isDate(curMonth&"/"&curDay&"/"&curYear)
  searchEnd = searchEnd - 1
wend

'searchStart is the first day of month
'searchEnd is the last day of month
'searchStart = cdate(curMonth1&"/"&curDay&"/"&curYear)
'searchEnd = cdate(curMonth&"/"&searchEnd&"/"&curYear)

curDate = searchStart

'check if date is in this month
if Not month(DateAdd("d", curDay-1, curMonth&"/1/"&curYear)) = curMonth then curDay = 1
lastDay = day(dateserial(curYear,curMonth+1,1-1))
today = currentDay&"/"&curMonth&"/"&curYear
'lastmonth = curDay&"/"&curmonth - 1&"/"&curYear
'nextmonth = curDay&"/"&curmonth + 1&"/"&curYear
%>
<table class="maincalendar"><tr><td>
<div class="mainsearchdate">
<div class="searchdate">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
	  <form action="calendar.asp" name="Go" method="post">
            <select onchange="this.form.submit();" name="curMonth">
              <% for x = monthstart to monthend %>
              <option value="<%= x %>" <% if cint(curMonth) = x then %> selected <% end if %>><%= monthName(x) %></option>
              <% next %>
            </select>
            <select onchange="this.form.submit();"  name="curYear">
              <% for x = yearstart to yearend %>
              <option value="<%= x %>" <% if cint(curYear) = x then %> selected <% end if %>><%= x %></option>
              <% next %>
            </select>
            <input type="submit" name="submit" value="חפש">
        </form>
	  </td>
    </tr>
  </table>
</div>
</td>
<td>
<div class="date"><%= monthName(curMonth) %>&nbsp;<%= curYear %></div></div></td></tr>
<tr><td colspan="2">
<table class="calendar">
  <tr> 
	<td class="day"><center><strong>ראשון</strong></center></td>
	<td class="day"><center><strong>שני</strong></center></td>
	<td class="day"><center><strong>שלישי</strong></center></td>
	<td class="day"><center><strong>רביעי</strong></center></td>
	<td class="day"><center><strong>חמישי</strong></center></td>
	<td class="day"><center><strong>שישי</strong></center></td>
	<td class="day"><center><strong>שבת</strong></center></td>
   </tr>
</table>
</td></tr>
<tr><td colspan="2">
<table class="calendar">
<tr>
<%
currentDay = 1 - weekday(dateserial(curYear,curMonth,1))+1
lastDay = day(dateserial(curYear,curMonth+1,1-1))
if currentDay = -4 AND lastDay >  30 then
  maxRows = 5
elseif currentDay = -5 AND lastDay >=  30 then
  maxRows = 5
else
 maxRows = 4
end If

num = 1
%>

<table class="calendar">
<% for x = 0 to maxRows %>
<tr>
<%  for xx = 0 to 6
    if currentDay > 0 AND currentDay <= lastDay then
      today = currentDay&"/"&curMonth&"/"&curYear
        if cstr(today) = cstr(day(now())&"/"&month(now())&"/"&year(now())) then
        bgcolour = white
      else
        bgcolour = bg
      end if %>
      <td class="calendar" valign="top"><% If Session(SiteID & "Type") = "Admin" Then %><a href="admin/admin_calendar_add.asp?Day=<%=today %>&S=<%=SiteID%>"><%=currentDay%></a><% Else%><%=currentDay%><% End IF%><br />
      
        <% 
        objRs.open "SELECT * FROM calEvent WHERE convert(datetime,startDate,103)=convert(datetime,'" & today & "',103) AND SiteId=" & SiteID ,objConn, 0,1
		number_events = objRs.recordcount
		i=1
		Do While NOT objRs.EOF
		if objRs("description") <> "" then 
		response.write "<a href=""calendar.asp?idcal="&objRs("id")& "&S="&SiteId&""">"&objRs("title")&"</a>"
		Else
			response.write objRs("title")
			If GetSession("Type") = "Admin" Then %><a href="admin/admin_calendar_edit.asp?id=<% = objRs("id")%>">*</a>" <% end if 
		End If
			'if objRs.RecordCount <> i-1 then
				response.write "<hr>" 
			'	end if
				i=i+1
		objRs.movenext
		loop
	
	objRs.close
%>
      </td>
	<%
	 num = num + 1
    else %>
		<td class="nocalendar"></td>
	<% end if 
		currentDay = currentDay + 1
  next %>
  <tr>
  <% next %>
  </tr>
</table>
</td></tr></table>
  <%
End If
  %>
<%
objConn.close
Bottom
%>