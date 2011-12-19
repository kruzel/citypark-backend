<head>
	<script language="javascript">
function getQueryVariable(variable)
 {  
 var query = window.location.search.substring(1); 
  var vars = query.split("&");
    for (var i=0;i<vars.length;i++)
     {     
     var pair = vars[i].split("=");   
       if (pair[0] == variable)        {  
            return pair[1];    
             }  
             }    
            } 

		function wPrintWindow(){
		$("toolbartable").hide();
		GUI_PRINT_TOOLS.style.display="none";
		window.print();
		GUI_PRINT_TOOLS.style.display="block";
		$("toolbartable").show();
		}

function ajaxFunctionToolBar(son,father,selectedid){
//alert(son+'+'+father+'+'+selectedid);
var url = 'xml_get_combo.asp?GetFrom=' + son + '&RecordID=' + selectedid + "&father=" + father + '&S=<% = SiteID %>';
new Ajax.Request(url, 
 {   
 	method: 'get',
 	onSuccess: function(transport) 
 	{    
 	
 	if(transport.responseText != null)
 	{
 	var s = transport.responseText.split(';');
 	
 	$(son).options.length = 0;

 	for (var i=0;i<s.length;i++)
 	{
 		var ss = s[i].split(",");
 		
 		$(son).options[$(son).length] = new Option(ss[1], ss[0], false, false);
 	}
 	}	
 	
//alert(transport.responseText);
 		 	}
 })};

function LoadFirstDDLToolBar2(FieldName,son,selectedid){
//alert(FieldName+'+'+son+'+'+selectedid);
		var queryint = parseInt(getQueryVariable(FieldName));
var url = 'xml_get_combo.asp?mode=first&GetFrom=' + FieldName + '&S=<% = SiteID %>';
new Ajax.Request(url, 
 {   
 	method: 'get',
 	onSuccess: function(transport) 
 	{    
 	
 	var s = transport.responseText.split(';');
 	
 	$(FieldName).options.length = 0;

 	for (var i=0;i<s.length;i++)
 	{
 		var ss = s[i].split(",");
		$(FieldName).options[$(FieldName).length] = new Option(ss[1], ss[0], false,(queryint==ss[0]));//(getQueryVariable(FieldName)==ss[0]));
	if (getQueryVariable(FieldName)==ss[0]) {
	ajaxFunctionToolBar(son,ss[0],FieldName);	
}

 	}
 		 	}
 })};
 
</script>
</head>

<body>
 <script language="javascript">
 </script>
<%
if Request.ServerVariables("SCRIPT_NAME") = "/app/showtoolbar.asp" or Request.ServerVariables("SCRIPT_NAME") = "/app/showtoolbargeneral.asp" then
 actionx = "/app/showtable.asp"
else
 actionx = Request.ServerVariables("SCRIPT_NAME") 
end if


 %>

<form action="<%=actionx%>" target=_parent id="toolbarid" name="toolbarid" method="get">
<%If Not Request.QueryString("URL") = "" Then %><input type="hidden" name="URL" value="<%= Request.QueryString("URL")%>"><%End If%>
<input type="hidden" name="table" value="<%=Request.QueryString("Table")%>">
<input type="hidden" name="ToolbarID" value="<%=Request.QueryString("ToolbarID")%>">
<input type="hidden" name="mode" value="search">
<input type="hidden" name="sl" value="<%=Request.QueryString("sl")%>">
<input type="hidden" name="sb" value="<%=Request.QueryString("sb")%>">
<input type="hidden" name="t" value="<%=Request.QueryString("t")%>">
<input type="hidden" name="sr" value="<%=Request.QueryString("sr")%>">
<input type="hidden" name="st" value="<%=Request.QueryString("st")%>">
<input type="hidden" name="printGui" value="<%=Request.QueryString("printGui")%>">

<%
Set objRsToolbar = OpenDB("SELECT * FROM Toolbar WHERE ToolbarID=" & Request.QueryString("ToolbarID") & " AND SiteID=" & SiteID)
Fields = Split(objRsToolbar("ToolbarFields"), ",")	
CloseDB(objRsToolbar)				
%>

<table id="toolbartable" bgcolor=<% = Application(ScriptName & "Modaabackgroundcolor") %> width="95%"
		background="<% = Application(ScriptName & "UploadPath") & "\" & Application(ScriptName & "ToolbarBGImage") %>"
    	 
		>
	<tr>
		
		<%	
		For Each x In objRs.Fields
			For Each y In Fields
				If x.name = y Then
%>

				<td><% If (LCase(Left(x.name, 5)) = "range") or (LCase(Right(x.name, 4)) = "date") Then %>מ<% End If %><% GetLang(x.name) %></td>
				
				<% If (LCase(Left(x.name, 5)) = "range") or (LCase(Right(x.name, 4)) = "date") Then %>
					<td>עד</td>
				<% End If %>
								
<%
				End If
			Next
		Next
		%>	
		<td>טקסט </td>	
	
	</tr>
	
	<tr>
		<%	
		For Each x In objRs.Fields
			For Each y In Fields
				If x.name = y Then
			
					FirstItem = ""
					MiddleItem = ""
					LastItem = ""
					
					DepenGroupsSplitted = Split(DepenGroups, ";")
					InConfig = False

					For Each DGS In DepenGroupsSplitted
						SplittedDepenGroupsSplitted = Split(DGS, ",")
						
							If UBound(SplittedDepenGroupsSplitted) = 1 Then
								If SplittedDepenGroupsSplitted(0) = x.name OR SplittedDepenGroupsSplitted(1) = x.name Then
									FirstItem = SplittedDepenGroupsSplitted(0)
									LastItem = SplittedDepenGroupsSplitted(1)
								End If
							ElseIf UBound(SplittedDepenGroupsSplitted) = 2 Then
									If SplittedDepenGroupsSplitted(0) = x.name OR SplittedDepenGroupsSplitted(1) = x.name or SplittedDepenGroupsSplitted(2) = x.name Then
									FirstItem = SplittedDepenGroupsSplitted(0)
									MiddleItem = SplittedDepenGroupsSplitted(1)
									LastItem = SplittedDepenGroupsSplitted(2)
								End If
							End If
										
						For Each i In SplittedDepenGroupsSplitted 
							If i = x.name Then
								InConfig = True
							End If
						Next
					Next
					
					If (LCase(Left(x.name, 5)) = "range") And (LCase(Right(x.name, 2)) = "id") Then
					
						t = x.name
						t = Replace(t, "ID", "")
						t = Replace(t, "Range", "")
						
						SQL = "SELECT * FROM " & t & " order by "&t&"Name desc WHERE SiteID=" & SiteID
						Set rs = OpenDB(SQL)
						
						For I = 1 To 2 
						%>
							<td>
								<select name="<% If I = 1 Then %>From<%ElseIf I = 2 Then %>To<% End If %><% = x.name %>">
									<option value="0">הכל</option>	
									<% 
									rs.MoveFirst
									Do While NOT rs.Eof %>
										<option <% If I = 1 Then%><% If Request.QueryString("From" & x.name) = rs(t & "Name") Then%>selected<%End If%><%Else%><% If Request.QueryString("To" & x.name) = rs(t & "Name") Then%>selected<% end If%><%End If%>  value="<% = rs(t & "Name") %>"><% = rs(t & "Name") %></option>
									<% 
									rs.movenext
									Loop %>
								</select>
							</td>
						<%
						Next
					ElseIf (Right(x.name, 2) = "ID") And (not x.name = "SiteID") and (CombinedCombo = False) Then  
						
						FirstItemTemp = LastItem
						LastItemTemp = FirstItem
									
						DontOnChange = false
						If MiddleItem = "" Then
							If x.name = FirstItemTemp Then 
								son = LastItemTemp
							Else
								DontOnChange = true
							End If
						Else
							If x.name = FirstItemTemp Then 
								son = MiddleItem
							ElseIf x.name = MiddleItem Then
								son = LastItemTemp	
							Else
								DontOnChange = true
							End If						
						End If
						OnChange = ""
						if DontOnChange = false Then OnChange = "ajaxFunctionToolBar('" & son & "', this.value, this.id);"
		
'						response.write "("&DontOnChange&"-"&son&")"
						' T H I S T O O L
						%>
						<td>
						<select style="font-size: 75%;" name="<% = x.name %>" id="<% = x.name %>" onchange="<% = OnChange %>">
							<option value="0" selected>הכל</option>
						
							<% 
							If (FirstItem = "" ) And (MiddleItem = "") And (LastItem ="") Then 
								Set objRsTempT = OpenDB("SELECT * FROM " & Replace(x.name, "ID", "") & " WHERE SiteID=" & SiteID& " order by "&Replace(x.name, "ID", "") & "Name desc" )
								
								Do While Not objRsTempT.EOF
								%>
									<option value="<% = objRsTempT(0) %>"><% = objRsTempT(Replace(x.name, "ID", "") & "Name") %></option>
								<%
									objRsTempT.MoveNext
								Loop	
								
								CloseDB(objRsTempT)
							 End If 
							 %>
						</select>
						</td>
								
					<% 
					Father = x.name
					If x.name = FirstItemTemp Then
						%>
							<script type="text/javascript">
								setTimeout("LoadFirstDDLToolBar2('<% = x.name %>','<%=son%>',$('<%=x.name%>').value )",10000);
							</script><%
					End If					
					ElseIf (Right(x.name, 2) = "ID") And (not x.name = "SiteID") and (CombinedCombo = True) Then  
						Set objRsC1 = OpenDB("SELECT * FROM " & sTable & " WHERE SiteID=" & SiteID)
						
						If Request.QueryString(x.name & "FatherID") = "" Then
							FatherID = objRsC1(0)
							Selected = 0
						Else
							FatherID = Int(Request.QueryString(x.name & "FatherID"))
							Selected = 1
						End If
						
							Set objRsC2 = OpenDB("SELECT * FROM " & Replace(x.name, "ID", "") & " WHERE " & sTable & "ID=" & FatherID  & " AND SiteID=" & SiteID)
						
						If objRsC2.RecordCount > 0 Then
							ShowIT = True
						Else
							ShowIT = False
						End If
									
						QS = Request.QueryString
						QS = Replace(QS, "&" & x.name & "FatherID" & "=" & Request.QueryString(x.name & "FatherID"), "")
						QS = Replace(QS, x.name & "FatherID" & "=" & Request.QueryString(x.name & "FatherID") & "&", "")
					%>
						<td>
							<select style="font-size: 75%;" name="<% = x.name %>" onchange="location.href='<%If Request.QueryString("URL") = "" Then%>showtable.asp<%Else%>html.asp<%End If%>?<%=x.name%>FatherID='+escape(this.options[this.selectedIndex].value)+'&<%=QS%>'">
							<option selected value="0">הכל</option>
							<% 
							objRsC1.MoveFirst
							Do While NOT objRsC1.EOF %>
								<option <% If FatherID = objRsC1(0) And Not Selected=0 Then %>selected<%End If%> value="<% = objRsC1(0) %>"><% = objRsC1(sTable & "Name") %></option>
							<%
							objRsC1.MoveNext
							Loop
							%>
					</select>
					</td>
					<td>
					<select style="font-size: 75%;" name="<% = x.name %>">
							<option selected value="0">הכל</option>
							<% 
							If Not Selected = 0 and showit = true Then 
							objRsC2.MoveFirst
							Do While NOT objRsC2.EOF %>
							<option value="<% = objRsC2(0) %>"><% = objRsC2(Replace(x.name, "ID", "") & "Name") %></option>
							<%
							objRsC2.MoveNext
							Loop	
							End If
							%>
					</select>
					</td>
					<%
						CloseDB(objRsC2)
						CloseDB(objRsC1)
					ElseIf x.type = 11 Then
					%>
					<td>
						<select style="font-size: 75%;" name="<% = x.name %>">
							<option <% If Request.QueryString(x.name) = "all" Then %>selected<%End If%> value="all">הכל</option>
							<option <% If Request.QueryString(x.name) = "True" Then %>selected<%End If%> value="True">כן</option>
							<option <% If Request.QueryString(x.name) = "False" Then %>selected<%End If%> value="False">לא</option>
						</select>
					</td>
					<%
					ElseIf lcase(mid(x.name,1,5)) = "range" Then
					%>
							<td><input style="font-size: 75%;" size="3" type="text" value="<% = Request.QueryString("From" & x.name) %>" name="From<%=x.name%>"></td>
							<td><input style="font-size: 75%;" size="3" type="text" value="<% = Request.QueryString("To" & x.name) %>" name="To<%=x.name%>"></td>
					<%
					Elseif LCase(Right(x.name, 4)) = "date" Then
					%>
							<td><input  size="8" type="text" value="<% = Request.QueryString("From" & x.name) %>" name="From<%=x.name%>">
<a href="#" onclick="popupCalendarDateCapture('toolbarid','From<% = x.name %>');">
							<img src="images/calendar.png" border="0" align="absbottom"></a>
</td>
							<td><input  size="8" type="text" value="<% = Request.QueryString("To" & x.name) %>" name="To<%=x.name%>">
<a href="#" onclick="popupCalendarDateCapture('toolbarid','To<% = x.name %>');">
							<img src="images/calendar.png" border="0" align="absbottom"></a>
</td>
					<%
					'if the last 5 chars of the x.name is refer than it takes all the data from the table and shows it as combo box.
					ElseIf LCase(Right(x.name,5)) = "refer" Then
					%>
						<td>
							<select name="<% = x.name %>" >
							<option selected value="0">הכל</option>
							<% 
							Set objRsRef = OpenDB("SELECT "&x.name&" FROM " & request("table") & " WHERE SiteID=" & SiteID&" Group by "&x.name)
							objRsRef.MoveFirst
							Do While NOT objRsRef.EOF %>
								<option value="<% = objRsRef(x.name) %>"><% = objRsRef(x.name) %></option>
							<%
							objRsRef.MoveNext
							Loop
							CloseDB(objRsRef)
							%>
					</select>
						</td>
					<%
					Else
					%>
						<td><input style="font-size: 75%;" value="<% = Request.QueryString(x.name) %>" type="text" name="<% = x.name %>"></td>
					<%

					End If
					
					Exit For
				End If
			Isun = Isun + 1
			Next
		Next
		%>	
			<td>
			<input value="<% = Request.QueryString("FREETEXT") %>" style="font-size: 75%;" name="FREETEXT" type="text" size="5"></td>
		<td><input style="font-size: 90%;" type="submit" value="חפש"></td>	
	</tr>
</table>

<% if request("printGui") = "true" then %>
<div id=GUI_PRINT_TOOLS style="width:125px;height:38px;text-align:left;" class="wp-0-b">
<a href="" class="btn" onclick='setTimeout("wPrintWindow()",100); return false;'><nobr><img border="0" src="images/printer.png">הדפס</nobr></a>
</div>
<% end if %>
<% if request("ExportGui") = "true" then %>
<a href="ShowtableExcel.asp?<%=Request.QueryString%>"><img src="/app/images/icons/xls.gif" border="0" align="absbottom"></a>
<% end if %>