<!--#include file="config.asp"-->
<!--#include file="JSON.asp"-->
<%	
Set Conn = SetConn()

Select Case request("m")
	Case "srch"
		SQL = "EXEC	getPark @street_name = N'" & replace(request("street"),"'","''''") & "',@city_name = N'" & request("city") & "'  "
		if request("limit") = "true" then SQL = SQL & ", @limit = '1'"
		if request("barrier") = "true" then SQL = SQL & ", @barrier = '1'"
		if request("underground") = "true" then SQL = SQL & ", @underground = '1'"
		if request("walls") = "true" then SQL = SQL & ", @walls = '1'"
		if request("disabled") = "true" then SQL = SQL & ", @disabled = '1'"
		if request("hourly") = "true" then SQL = SQL & ", @hourly = '1'"
		if request("Daily") = "true" then SQL = SQL & ", @Daily = '1'"
		if request("weekly") = "true" then SQL = SQL & ", @weekly = '1'"
		if request("monthly") = "true" then SQL = SQL & ", @monthly = '1'"
		if request("yearly") = "true" then SQL = SQL & ", @yearly = '1'"
		if request("startdate") <> "" then SQL = SQL & ", @d1 = N'"&request("startdate")&"'"
		if request("enddate") <> "" then SQL = SQL & ", @d2 = N'"&request("enddate")&"'"
		if request("house") <> "" then SQL = SQL & ", @house = N'"&request("house")&"'"
		if request("payment") <> "" then SQL = SQL & ", @payment = N'"&request("payment")&"'"
		if request("price") <> "" then SQL = SQL & ", @price = N'"&request("price")&"'"
		sql = sql & ", @dist = '"&request("distance")&"'"
		SQL = SQL & ", @vip = '1'"
	'  print sql&"<br>"
		x = 1
		Set objVIP = OpenDB(SQL)
		response.write "<div id='parks1' class='prods _current'>"
			Do While NOT objVIP.EOF
				TemplateURL =  Templatelocation & "parkVIP.html" 
				
				Template = GetURL(TemplateURL)
				For Each Field In objVIP.Fields
					value = objVIP(Field.Name)
					If Len(value) > 0 Then
						Template = Replace(Template, "[" & Field.Name & "]", value)
						Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
						Template = Replace(Template, "[Adminname]", Adminname)
					Else
						Template = Replace(Template, "[urlfacebook]",urlfacebook)
						Template = Replace(Template, "[" & Field.Name & "]", "")
					End If
				Next
				ProcessLayout(Template)
				z =z +1
				if z = 5 then
					x = x + 1
					response.write "</div>"
					response.write "<div id='parks"&x&"' style='display:none;' class='parks'>"
					z = 0
				 end if
				objVIP.Movenext
			loop
		CloseDB(objVIP)	
		SQL = "EXEC	 getPark @street_name = N'" &replace(request("street"),"'","''''") & "',@city_name = N'" & request("city") & "'  "
		if request("limit") = "true" then SQL = SQL & ", @limit = '1'"
		if request("barrier") = "true" then SQL = SQL & ", @barrier = '1'"
		if request("underground") = "true" then SQL = SQL & ", @underground = '1'"
		if request("walls") = "true" then SQL = SQL & ", @walls = '1'"
		if request("disabled") = "true" then SQL = SQL & ", @disabled = '1'"
		if request("hourly") = "true" then SQL = SQL & ", @hourly = '1'"
		if request("Daily") = "true" then SQL = SQL & ", @Daily = '1'"
		if request("weekly") = "true" then SQL = SQL & ", @weekly = '1'"
		if request("monthly") = "true" then SQL = SQL & ", @monthly = '1'"
		if request("startdate") <> "" then SQL = SQL & ", @d1 = N'"&request("startdate")&"'"
		if request("enddate") <> "" then SQL = SQL & ", @d2 = N'"&request("enddate")&"'"
		if request("house") <> "" then SQL = SQL & ", @house = N'"&request("house")&"'"
		if request("payment") <> "" then SQL = SQL & ", @payment = N'"&request("payment")&"'"
		if request("price") <> "" then SQL = SQL & ", @price = N'"&request("price")&"'"
		sql = sql & ", @dist = '"&request("distance")&"'"
		'print sql
		Set objRs = OpenDB(SQL)
			Do While NOT objRs.EOF
				TemplateURL =  Templatelocation & "park.html" 
				Template = GetURL(TemplateURL)
				For Each Field In objRs.Fields
					value = objRs(Field.Name)
						If Len(value) > 0 Then
						Template = Replace(Template, "[" & Field.Name & "]", value)
							Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							Template = Replace(Template, "[Adminname]", Adminname)
						Else
							Template = Replace(Template, "[urlfacebook]",urlfacebook)
							Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
				Next
				ProcessLayout(Template)
				z =z +1
				if z = 5 then
					x = x + 1
					response.write "</div>"
					response.write "<div id='parks"&x&"' style='display:none;' class='parks'>"
					z = 0
				end if
				objRs.Movenext
			loop
		response.write "</div>"				
	CloseDB(objRs)
'	print TemplateURL
'	response.end
'	response.write sql
'	response.write sql
	Case "ac"
		SQL = "SELECT top 10 street "
		if request("housenum") <> "" then SQL = SQL & "+' '+ CAST(house_number AS nvarchar(20)) "
		SQL = SQL & "+', '+city as name "
		if request("housenum") <> "" then SQL = SQL & ",house_number "
		SQL = SQL & " FROM [streets]"
		SQL = SQL & " WHERE SiteID=" & SiteID
		SQL = SQL & " AND street LIKE '%" & trim(replace(request("street"),"'","''")) & "%'"
		if request("housenum") <> "" then SQL = SQL & " AND house_number like '%" & trim(request("housenum")) & "%'"
		if request("city") <> "" then SQL = SQL & " AND city LIKE '%" & trim(request("city")) & "%'"
		SQL = SQL & " group by street"
		if request("housenum") <> "" then SQL = SQL & "+' '+ CAST(house_number AS nvarchar(20)) "
		SQL = SQL &"+', '+city "
		if request("housenum") <> "" then SQL = SQL & ",house_number "
		if request("housenum") <> "" then SQL = SQL & "order by house_number asc "	
		'print sql
		QueryToJSON(Conn, SQL).Flush 
		response.end
	case "attr"
	
	if trim(cstr(request("type"))) = trim(cstr("הכל"))	then
		SQL = "EXEC	 getAttraction2 @parkid = "& request("id")
	else
		SQL = "EXEC	 getAttraction @parkid = "& request("id")&", @type=N'"&request("type")&"'"
	end if
		
		'print sql
		Set objAtr = OpenDB(SQL)					
		         
             Do While NOT objAtr.EOF 
				    TemplateURL =  Templatelocation & "sons_atrac.html" 
				   Template = GetURL(TemplateURL)
					For Each Field In objAtr.Fields
					value = objAtr(Field.Name)
						If Len(value) > 0 Then
							Template = Replace(Template, "[" & Field.Name & "]", value)
							Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							Template = Replace(Template, "[Adminname]", Adminname)
						Else
							Template = Replace(Template, "[urlfacebook]",urlfacebook)
							Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
					Next
							 ProcessLayout(Template)
                   
                objAtr.Movenext
		loop	
		
End Select
'response.write sql

			


%>