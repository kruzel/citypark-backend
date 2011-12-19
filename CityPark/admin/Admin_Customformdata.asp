<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<!--#include file="right.asp"-->

<%

%>



	<div id="incontent">
	<div class="incontentboxgrid">
<center>
    <div class="formtitle">
        <h1>ניהול רשומות</h1>
		<div class="admintoolber">
		</div>
		<div class="adminicons">
			<p><a href="/data/<% =Request("formid")%>.csv"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_Customform.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
					<option value="10" <%if Session("records") = 10 then print "selected" End if%>>10</option>
					<option value="20" <%if Session("records") = 20 then print "selected" End if%>>20</option>
					<option value="50" <%if Session("records") = 50 then print "selected" End if%>>50</option>
					<option value="100" <%if Session("records") = 100 then print "selected" End if%>>100</option>
					<option value="1000" <%if Session("records") = 1000 then print "selected" End if%>>1000</option>
				</select>
			</p>
			<p class="reshumot">רשומות לדף:</p>
	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
	
<%
	Mode = LCase(Request("mode"))
	Function AddQuotes(str)
		AddQuotes = """" & Replace(str, """", """""") & """"
	End Function

	Function RemoveQuotes(str)
    
		RemoveQuotes = Replace(Mid(str, 2, len(str) - 2), """""", """")
	'	RemoveQuotes = str 'Replace(Mid(str, 2, len(str) - 2), """""", """")
	End Function
	
	Set fs = CreateObject("Scripting.FileSystemObject")
	
	If Mode = "" Then
		set f = fs.OpenTextFile(Server.MapPath("/data/" & Request("formid") & ".csv"), 1)
		
		p = Split(f.ReadAll, vbCrLF)
		
			i = 0
			
			For Each j in p 
			If j <> "" Then
			%>
			<tr>
			<%
				k = Split(j, ",")
				
				For Each h In k
				%>
				<t<% If i = 0 Then Print "h" Else Print "d" %>><% = RemoveQuotes(h) %></t<% If i = 0 Then Print "h" Else Print "d" %>>
				<%
				Next
				
				If i > 0 Then
				%>
				<td><a href="/admin/admin_Customformdata.asp?formid=<% = Request("formid") %>&id=<% = RemoveQuotes(k(0)) %>&mode=edit">ערוך</a></td>
				<td><a href="/admin/admin_Customformdata.asp?formid=<% = Request("formid") %>&id=<% = RemoveQuotes(k(0)) %>&mode=delete">מחק</a></td>
				<%
				End If
			%>
			</tr>
			<%
			End If
			
			i = i + 1
			
			Next
		%>
		</table>
	<%
		f.Close
	ElseIf mode = "edit" Then
		set f = fs.OpenTextFile(Server.MapPath("/data/" & Request("formid") & ".csv"), 1)
		p = Split(f.ReadAll, vbCrLF)
		
		r = 0
		
		For Each j in p 
			If r <> 0 Then
				If Int(RemoveQuotes(Split(j, ",")(0))) = Int(Request("id")) Then
					e = j
					Exit For
				End If
			End If
			
			r = r + 1
		Next
		
		b = Split(p(0), ",")
		k = Split(e, ",")
		
		%>
		<form action="/admin/admin_Customformdata.asp?formid=<% = Request("formid") %>&id=<% = Request("id") %>&mode=edit_f" method="post">		<table>
		<td><input name="r0" type="hidden" value="<% = RemoveQuotes(k(0)) %>"/></td>
		<%
			For l = 1 To UBound(b)
		%>
			<tr>
				<td><% = RemoveQuotes(b(l)) %></td>
				<td><input name="r<% = l%>" type="text" value="<% = RemoveQuotes(k(l)) %>"/></td>
			</tr>
		<%
			Next
		%>
			<tr>
				<td colspan="2" align="left"><input type="submit" value="אישור"/></td>
			</tr>
		</table>
		</form>
		<%
		f.Close
	ElseIf mode = "edit_f" Then
		set f = fs.OpenTextFile(Server.MapPath("/data/" & Request("formid") & ".csv"), 1)
		p = Split(f.ReadAll, vbCrLF)
		
		r = 0
		
		For Each j in p 
			If r = 0 Then 
				csv = csv & j
			Else
				If Int(RemoveQuotes(Split(j, ",")(0))) = Int(Request("id")) Then
					csv = csv & vbCrLf
					d = 0
					c = UBound(Split(p(0), ","))
					
					For d = 0 To c
						csv = csv & AddQuotes(Request("r" & d))
						
						If d < c Then csv = csv & ","
					Next
				Else
					csv = csv & vbCrLf & j
				End If
			End If
			
			r = r + 1
		Next
		
		f.Close
		
		set f = fs.OpenTextFile(Server.MapPath("/data/" & Request("formid") & ".csv"), 2)
		f.Write(csv)
		f.Close
		
		Response.Redirect("/admin/admin_Customformdata.asp?formid=" & Request("formid"))		
	ElseIf mode = "delete" Then
		set f = fs.OpenTextFile(Server.MapPath("/data/" & Request("formid") & ".csv"), 1)
		p = Split(f.ReadAll, vbCrLF)
		
		r = 0
		
		For Each j in p 
			If r = 0 Then 
				csv = csv & j
			Else
				k = Split(j, ",")
				
				If Int(RemoveQuotes(k(0))) <> Int(Request("id")) Then
					csv = csv & vbCrLf & j
				End If
			End If
				
			r = r + 1
		Next
		
		f.Close
		
		set f = fs.OpenTextFile(Server.MapPath("/data/" & Request("formid") & ".csv"), 2)
		f.Write(csv)
		f.Close
		
		Response.Redirect("/admin/admin_Customformdata.asp?formid=" & Request("formid"))
	End If
	
	set fs = Nothing
	
%>
<!--#include file="footer.asp"-->