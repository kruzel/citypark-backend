<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<!--#include file="right.asp"-->
	<div id="incontent">
	<div class="incontentboxgrid">
<center>
    <div class="formtitle">
        <h1>ניהול יבוא</h1>
		<div class="admintoolber">
		</div>
		<div class="adminicons">
			<p><a href="../data/<% =Request("formid")%>.csv"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
			</p>
	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
	
<%
	Mode = LCase(Request("mode"))
	Function AddQuotes(str)
		AddQuotes = """" & Replace(str, """", """""") & """"
	End Function

	Function RemoveQuotes(str)
	'	RemoveQuotes = Replace(Mid(str, 2, len(str) - 2), """""", """")
	RemoveQuotes = str
	End Function
	
	Set fs = CreateObject("Scripting.FileSystemObject")
	
	If Mode = "" Then
		set f = fs.OpenTextFile(Server.MapPath("../../data/" & Request("formid") & ".csv"), 1)
		
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
				<t<%If i = 0 Then Print "h" Else Print "d" %>><% = RemoveQuotes(h) %></t<% If i = 0 Then Print "h" Else Print "d" %>> 
				<%	Next %>
			</tr>
			<%
			End If
			
			i = i + 1
			
			Next
		%>
		</table>
		<form action="/admin/import.asp?<%=Request.QueryString%>&mode=add" method="post">
		<button>הוסף</button>
		</form>
	<%
		f.Close
	ElseIf mode = "add" Then
		set f = fs.OpenTextFile(Server.MapPath("../../data/" & Request("formid") & ".csv"), 1)
		p = Split(f.ReadAll, vbCrLF)
		
		Dim headers()
		
		For x = 0 To UBound(p)
			If p(x) <> "" Then
				k = Split(p(x), ",")

				If x = 0 Then
					ReDim headers(UBound(k))
					
					For y = 0 To UBound(k) 
						headers(y) = k(y)
					Next
				Else
					idIndex = -1
				
					If LCase(Request.QueryString("update")) = "true" Then
						For z = 0 To UBound(headers)
							If LCase(headers(z)) = "id" Then
								idIndex = z
								Exit For
							End If
						Next
					End If
					
					j = false
					
					Do Until j
						If idIndex = -1 Or LCase(Request.QueryString("update")) <> "true" Then
							Set objRs = OpenDB("SELECT * FROM Users WHERE SiteID= " & SiteID)
							objRs.AddNew
							
							j = true
						Else
							Set objRs = OpenDB("SELECT * FROM Users WHERE Id = " & k(idIndex) & " AND SiteID= " & SiteID)
							
							If objRs.RecordCount = 0 Then
								idIndex = -1
							Else
								j = true
							End If
						End If
					Loop
					
					For y = 0 To UBound(k)
						If LCase(headers(y)) <> "id" Then
							objRs(headers(y)) = k(y)
						End If
					Next
					
					objRs("UrlText") = Lcase(Replace(Replace(k(1),".","")," ",""))
					'objRs("Name") = k(1)
					objRs("ContentType") = 2
					objRs("Template") = 169
						
					objRs("SiteID") = SiteID
						
					objRs.Update

					If idIndex = -1 Then
						Set objRs = OpenDB("Select TOP 1 Id From Users Order By Id Desc")
						cId = objRs("Id")
						CloseDb(objRs)
						
						ExecuteRS("INSERT INTO [UsersPerCategory] (UsersID, UsersCategoryID, SiteID) VALUES (" & cId & ", 52, " & SiteID & ");")						
					End If
				End If
			End If
		Next
	ElseIf mode = "edit" Then
	ElseIf mode = "edit_f" Then
	ElseIf mode = "delete" Then
	End If
	
	set fs = Nothing
	
%>
<!--#include file="footer.asp"-->