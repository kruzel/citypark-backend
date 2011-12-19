<!--#include file="../config.asp"-->
<!--#include file="../JSON.asp"-->
<%
Select Case request.form("m")
	Case "city"
		SQL = "SELECT DISTINCT street FROM streets where city = '"&request.form("city")&"' order by street "
		'print "-"&request("city")&"-"
		Set Conn = SetConn()
		QueryToJSON(Conn, SQL).Flush
	Case "addparkrange"
	 Sql = "SELECT * FROM  parking_shortrange "
	Set objRs = OpenDB(sql)
	objRs.Addnew
		if Request.Form("pid") = "" then
			if GetSession("lid") = "" then
				randomize
				rndnum = int((rnd*15000))+987654
				objRs("parkId") =rndnum
				SetSession "lid",rndnum
			else
				objRs("parkId") =GetSession("lid")
			end if
		else
			objRs("parkId") = Request.Form("pid")
		end if
		objRs("fromDay") = Request.Form("fromday")
		objRs("toDay") = Request.Form("xtoday")
		objRs("fromHour") = Request.Form("fromhour")
		objRs("toHour") = Request.Form("tohour")
		objRs("firstHourPrice") = Request.Form("firstHourPrice")
		objRs("extraQuarterPrice") = Request.Form("extraQuarterPrice")
		objRs("allDayPrice") = Request.Form("allDayPrice")
		objRs("onetimehour") = Request.Form("onetimehour")
		objRs("onetimeprice") = Request.Form("onetimeprice")

	objRs.Update
	objRs.Close
	print "true"
	case "parkrange"
	
	if request.form("id") = "" then
		sql = "select * from parking_shortrange where parkid = "&GetSession("lid")
	else
		sql = "select * from parking_shortrange where parkid = "&request.form("id")        
	end if
			Set objRng = OpenDB(SQL)
	                If objRng.RecordCount = 0 Then
                        print "<tr class='shortrange'><td>אין רשומות</td></tr>"
	                 Else
           %>
		   <tr class="shortrange">
		<th>טווח קצר</th>
        <th></th>
        <th></th>
        <th></th>
    </tr>
		   <%
		   Do While Not objRng.EOF 
	%>		

	
    <tr class="shortrange">
		<td>מיום
        <select id="fromday" name="fromday">
				<option value="א"<% if objRng("fromday") = "א" then %>selected=" selected"<% End if %>>א</option>
				<option value="ב"<% if objRng("fromday") = "ב" then %>selected=" selected"<% End if %>>ב</option>
				<option value="ג"<% if objRng("fromday") = "ג" then %>selected=" selected"<% End if %>>ג</option>
				<option value="ד"<% if objRng("fromday") = "ד" then %>selected=" selected"<% End if %>>ד</option>
				<option value="ה"<% if objRng("fromday") = "ה" then %>selected=" selected"<% End if %>>ה</option>
				<option value="ו"<% if objRng("fromday") = "ו" then %>selected=" selected"<% End if %>>ו</option>
				<option value="שבת"<% if objRng("fromday") = "שבת" then %>selected=" selected"<% End if %>>שבת</option>
		</select>
        עד יום 
        <select id="today" name="today">
				<option value="א"<% if objRng("today") = "א" then %>selected=" selected"<% End if %>>א</option>
				<option value="ב"<% if objRng("today") = "ב" then %>selected=" selected"<% End if %>>ב</option>
				<option value="ג"<% if objRng("today") = "ג" then %>selected=" selected"<% End if %>>ג</option>
				<option value="ד"<% if objRng("today") = "ד" then %>selected=" selected"<% End if %>>ד</option>
				<option value="ה"<% if objRng("today") = "ה" then %>selected=" selected"<% End if %>>ה</option>
				<option value="ו"<% if objRng("today") = "ו" then %>selected=" selected"<% End if %>>ו</option>
				<option value="שבת"<% if objRng("today") = "שבת" then %>selected=" selected"<% End if %>>שבת</option>
		</select>
        </td>
        <td colspan="2" >
        משעה: <select id="fromhour" name="fromhour" onchange="" style="" class="">
				<% for h = 01 to 24 %>
                	<option value="<% = h %>"<% if Int(objRng("fromhour")) = Int(h) then %>selected=" selected"<% End if %>><% = h %>:00</option>
                <% next %>
				</select>
				 עד שעה: <select id="tohour" name="tohour" onchange="" style="" class="">
				<% for h = 01 to 24 %>
                	<option value="<% = h %>"<% if Int(objRng("tohour")) =Int(h) then %>selected=" selected"<% End if %>><% = h %>:00</option>
                <% next %>
				</select>
        </td>
		<td rowspan="3" style="border-bottom:1px solid #2698D6;"><img src="http://www.citypark.co.il/sites/cityp/layout/he-IL/images/delete1.png" class="range_delete" onclick="delrange(<%=objRng("relId")%>)"></a></td>
	    </tr >
        <tr class="shortrange">
			<td valign="top">מחיר לשעה ראשונה: <input type="text" name="firstHourPrice" size="6" value="<%=objRng("firstHourPrice")%>" /></td>
			<td valign="top">מחיר לכל רבע שעה נוספת: <input type="text" name="extraQuarterPrice" value="<%=objRng("extraQuarterPrice")%>" size="6" /></td>
			<td valign="top">מחיר ליום: <input type="text" name="allDayPrice" size="6" value="<%=objRng("allDayPrice")%>" /></td>
		
    </tr>
	<tr class="shortrange">
	<td style="border-bottom:1px solid #2698D6;">מחיר לחד פעמי: <input type="text" name="onetimeprice" size="6" value="<%=objRng("onetimeprice")%>" /></td>
 <td colspan="2" style="border-bottom:1px solid #2698D6;">
        חד פעמי משעה: <select id="onetimehour" name="onetimehour" onchange="" style="" class="">
				<% for h = 01 to 24 %>
                	<option value="<% = h %>"<% if Int(objRng("onetimehour")) = Int(h) then %>selected=" selected"<% End if %>><% = h %>:00</option>
                <% next %>
				</select>
				
        </td></tr><%			
			objRng.movenext
			Loop 
			End if
    CloseDB(objRng)
	Case "delrange"		
	    Sql = "SELECT * FROM  parking_shortrange WHERE relid='" & Request.form("relid")&"'"
		Set objRs = OpenDB(sql)
		objRs.Delete
		objRs.Close
		print "true"
End Select
%>
