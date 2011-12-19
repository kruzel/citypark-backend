<!--#include file="../config.asp"-->
<!--#include file="../$db.asp"-->
<%
'Header

Const adSchemaTables = 20
Set objConnection = SetConn()
Set objRecordSet = CreateObject("ADODB.Recordset")
Set objRecordSet = objConnection.OpenSchema(adSchemaTables)

If Request.QueryString("mode") = "doit" Then

	Dim Tables
	
	Do While NOT objRecordset.EOF
		If lcase(objRecordset.Fields.Item("TABLE_TYPE")) = "table" Then
			If Request.Form(objRecordset.Fields.Item("TABLE_NAME")) = "on" Then
				Tables = Tables & "," & objRecordset.Fields.Item("TABLE_NAME")
			End If
		End If    
    objRecordset.MoveNext
    Loop

    Tables = Mid(Tables, 2)
%>
	<script language="javascript">
		opener.form1.Tables.value = '<%=Tables%>'
		window.close();
	</script>
<%
End If

%>

<form method="post" action="tablespopup.asp?mode=doit&object=<%=Request.QueryString("Object")%>">
<table width="90%" dir="rtl">
<%
SET objRs = OpenDB("SELECT * FROM " & Request.QueryString("Table") & " WHERE " & Request.QueryString("Table") & "ID=" & Request.QueryString("RecordID"))
Array_01 = Split(objRs("Tables"), ",")

Function IsFieldTurnOn(TableName)
	For each x in Array_01
		If x = TableName Then
			IsFieldTurnOn = "True"
		End If
	Next
End Function

Do While NOT objRecordset.EOF
	If lcase(objRecordset.Fields.Item("TABLE_TYPE")) = "table" Then
	%>
			<tr>
					<td><input <%If IsFieldTurnOn(objRecordset.Fields.Item("TABLE_NAME")) = "True" then%>checked<%End If%> type="checkbox" name="<%=objRecordset.Fields.Item("TABLE_NAME")%>"></td>
					<td><a href="edittable.asp?table=<%=objRecordset.Fields.Item("TABLE_NAME")%>"><%=objRecordset.Fields.Item("TABLE_NAME")%></a></td>
			</tr>
				<%  
	End If    
    objRecordset.MoveNext
Loop
%>
			<tr>
				<td align="center" colspan="2"><input type="submit" value="<%=SysLang("Send")%>"></td>	
			</tr>

</table>
</form>
<%
'Bottom
%>