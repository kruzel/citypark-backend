<!--#include file="../config.asp"-->
<%

' Editing Table System
' By Alon Gubkin
' Dooble.co.il

'---------------------------------------------------System Configuration---------------------------------------------------

'Fields that will not showed. 
'Syntax: [FieldName],[Table OR * to all];[FieldName],[Table OR * to all];[FieldName],[Table OR * to all]...

FieldsNotShow = "SiteID,*;RehevBrandID,rehev;RegionID,rehev;SecondCatID,second;SecondName,second"


'Select Groups
'Syntax: [FieldName],[Table];[FieldName],[Table];[FieldName],[Table];...

OptGroups = "CityID,Region;SecondSubCatID,SecondCat;RehevModelID,RehevBrand;AnimalsSubCatID,AnimalsCat;MivtzarCustomersID,MivtzarAsset;GCityID,GRegionID"

'Table, * to QueryString Table.
ConfTable = "*"

'----------------------------------------------End System Configuration-----------------------------------------------------

'header

'WARNING: DON'T CHANGE LATER CODE OR CAUSE SYSTEM WILL NOT WORKING.

%>
<!--#include file="inc_admin_icons.asp"-->

<!--#include file="../$db.asp"-->

<!--#include file="popupcalendardatecapture.asp"-->
<script type="text/javascript" src="../js/jquery.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
<script type="text/javascript" src="../js/validation.js"></script>
<script>
		function ColorChanged(ColorBox, ColorField)
		{
			var hex = ColorField.value.toUpperCase();
			var bad = false;
			for(var i = 0; i < 6; i++)
				if("0123456789ABCDEF".indexOf(hex.substr(i, 1)) == -1)
				{
					bad = true;
					break;
				}
			if(bad || hex.length != 6) 
			{
				alert('Invalid Color');
				return;
			}
			ColorBox.style.backgroundColor = '#' + ColorField.value;
		}
		var ColorPicker_InputField;
		var ColorPicker_Icon;
		function ColorPicker_Picked(color)
		{
			ColorPicker_InputField.value = color;
			ColorPicker_Icon.style.backgroundColor = "#" + color;
		}
		function ChangeColor(ColorBox, ColorField)
		{
			var ieVersion = null;
			var color = null;

			if(document.all && navigator.appVersion.indexOf("MSIE ") != -1)
			{
				ieVersion = navigator.appVersion;
				ieVersion = ieVersion.substr(ieVersion.indexOf("MSIE ") + 5);
				ieVersion = ieVersion.substr(0, ieVersion.indexOf(";"));
				ieVersion = new Number(ieVersion);
			}

			if(ieVersion != null && ieVersion >= 5.5)
			{
				var arguments = new Array();
				arguments["Color"] = new String(ColorField.value);
				arguments["DefaultLanguage"] = "he";
				arguments["LanguageDetection"] = false;
				color = window.showModalDialog("ColourPicker/IE5.5+/ColorPicker.htm", arguments, "dialogWidth:488px;dialogHeight:350px;help:no;center:yes;status:no;");
				if(color != null)
				{
					ColorBox.style.backgroundColor = "#" + color;
					ColorField.value = color;
				}
			} 
			else 
			{
				var query = "?DefaultLanguage=he&LanguageDetection=true&Color=" + ColorField.value;
				ColorPicker_InputField = ColorField;
				ColorPicker_Icon = ColorBox;
				window.open("ColourPicker/NS7.1/ColorPicker.htm" + query, "ColorPicker", "width=488, height=300");
			}
		}
 function getCookie(c_name)
{
if (document.cookie.length>0)
  {
  c_start=document.cookie.indexOf(c_name + "=");
  if (c_start!=-1)
    { 
    c_start=c_start + c_name.length+1; 
    c_end=document.cookie.indexOf(";",c_start);
    if (c_end==-1) c_end=document.cookie.length;
    return unescape(document.cookie.substring(c_start,c_end));
    } 
  }
return "";
}
	function ajaxFileUpload(imagename)
	{
//	alert(imagename);
	
		$$$$("#load"+imagename+'x')
		.ajaxStart(function(){
			$$$$(this).show();
		})
		.ajaxComplete(function(){
			$$$$(this).hide();
		});

		$$$$.ajaxFileUpload
		(
			{
				url:'doajaxfileupload.php?image='+imagename+'x',
				secureuri:false,
				fileElementId:imagename+'x',
				dataType: 'json',
				success: function (data, status)
				{
					if(typeof(data.error) != 'undefined')
					{
						if(data.error != '')
						{
							alert(data.error);
						}else
						{
						//alert(data.msg);
							onUpload(imagename,data.msg);
						}
					}
				},
				error: function (data, status, e)
				{
					alert(e);
				}
			}
		)
		
		return false;

	}
	function ajaxFileUpload2(imagename)
	{
//	alert(imagename);
	
		$$$$("#load"+imagename+'x')
		.ajaxStart(function(){
			$$$$(this).show();
		})
		.ajaxComplete(function(){
			$$$$(this).hide();
		});

		$$$$.ajaxFileUpload
		(
			{
				url:'doajaxfileupload2.php?image='+imagename+'x',
				secureuri:false,
				fileElementId:imagename+'x',
				dataType: 'json',
				success: function (data, status)
				{
					if(typeof(data.error) != 'undefined')
					{
						if(data.error != '')
						{
							alert(data.error);
						}else
						{
						//alert(data.msg);
							fileType(imagename,data.msg);
						}
					}
				},
				error: function (data, status, e)
				{
					alert(e);
				}
			}
		)
		
		return false;

	}
function Right(str, n){
    if (n <= 0)
       return "";
    else if (n > String(str).length)
       return str;
    else {
       var iLen = String(str).length;
       return String(str).substring(iLen, iLen - n);
    }
}

	function onUpload(imagename,datax){
		var userdircookie = getCookie('userdir');		
		$(imagename).value = userdircookie+'/'+datax;
		$(imagename+'x').disabled=true;
//		$('div'+imagename).style.display = 'none';
		$('prv'+imagename).src = userdircookie+'/'+datax;
		$('prv'+imagename).style.display = 'block';
		$('del'+imagename).style.display = 'block';
		$('del'+imagename).style.cursor = 'pointer';
	}	

function fileType(imagename,datax){
		var userdircookie = getCookie('userdir')+'/../file';
		$(imagename).value = userdircookie+'/'+datax;
		$(imagename+'x').disabled=true;
//		$('div'+imagename).style.display = 'none';
		$('prv'+imagename).src = 'images/'+Right(datax,3)+'.jpg';
		$('prv'+imagename).style.display = 'block';
		$('del'+imagename).style.display = 'block';
		$('del'+imagename).style.cursor = 'pointer';
	}

	function imageExist(imagename){
	//	$('div'+imagename).style.display = 'none';
		$('prv'+imagename).style.display = 'block';
		$('del'+imagename).style.display = 'block';
		$('del'+imagename).style.cursor = 'pointer';
	}
	
	function delimage(imagename){

		$(imagename+'x').disabled=false;
		$(imagename).value = '';
		$('prv'+imagename).style.display = 'none';
		$('del'+imagename).style.display = 'none';
		$('div'+imagename).style.display = 'block';
	}


		</script>


<% 

'Announce a new variable stores the table name from configuration.
If ConfTable = "*" Then
	Table = lcase(Request.QueryString("Table"))
Else
	Table = ConfTable
End If 

CheckSecuirty(Table)

'Main Recordset - Table: From Configuration
SQL = "SELECT * FROM " & Table
SQL = SQL & " WHERE SiteID=" & SiteID

Set objRs = OpenDB(SQL)

'Another recordset for langunge..
Set objRsReplace = OpenDB("SELECT * FROM Lang WHERE SiteID=" & SiteID)		

'Recordset used at edit, delete etc modes.. Select the RecordID row.
If NOT Request.QueryString("RecordID") = "" Then
		Set objRsSelected = OpenDB("SELECT * FROM " & Table & " WHERE (" & objRs.Fields(0).Name & "='" & Request.QueryString("RecordID") & "') AND (SiteID=" & SiteID & ")" )
End If

'---------------------------------------Adding a new record to a normal table---------------------------------------
If Request.QueryString("mode") = "addnew" Then
	
	Set objRsLength = OpenDB("SELECT * FROM " & Table)
	
		If objRsLength.RecordCount > 0 Then
			objRsLength.MoveLast
			iCount = Int(objRsLength(0)) + 1
		Else
			iCount = 1
		End If
		
		
	CloseDB(objRsLength)
	
	'Starts an AddNew block
	objRs.AddNew	
	
		On Error Resume Next
		
		Error = False
		Set nFields = Server.CreateObject("Scripting.Dictionary")
		
		For Each x In objRs.Fields 'loop all fields at selected table.
			If (Not x.name = objRs.Fields(0).name) Then
				
				objRs(x.name) = Request.Form(x.name)
				If err<>0 then
					Error = True
					nFields.Add x.name, x.name
				End If
							
			End If
		Next

	If Error = True Then
		a=nFields.Items
		for i=0 to d.Count-1
  			GetLang(a(i))
  			Response.Write(" הוא שדה חובה.<br>")
		next
	Else
		objRs.Update 'Update Records and close AddNew blcok.
		Response.Redirect "edittable.asp?Table=" & Table 'Redirects to main page
	End If
'----------------------------------------------------Deleting a record from a normal table-----------------------------------------
ElseIf Request.QueryString("mode") = "delete" Then
	
	ExecuteRS("DELETE FROM " & Table & " WHERE " & objRs.Fields(0).name & "=" & Request.QueryString("RecordID")) 'Execute a DELETE SQL
	Response.Redirect "edittable.asp?Table=" & Table 'Redirect away to main page

'--------------------------------------FIN
ElseIf Request.QueryString("mode") = "editfinish" Then
	
		For Each x In objRsSelected.Fields 'loop all fields at selected table.
			If Not x.name = objRsSelected.Fields(0).name Then
			
				if objRsSelected(x.name).type = 135 and Request.Form(x.name) <> "" then
					time_stamp = month(Request.Form(x.name))&"/"&day(Request.Form(x.name))&"/"&year(Request.Form(x.name))
					objRsSelected(x.name) =time_stamp
				else							
					Response.write(objRsSelected(x.name)& "=" & Request.Form(x.name)& "<br>")
					if Request.Form(x.name) <> "" then objRsSelected(x.name) = Request.Form(x.name)
				End if
			End If
		Next
		
	objRsSelected.Update
	
	If Request.QueryString("BackURL") = "" Then
		Response.Redirect "edittable.asp?Table=" & Table
	Else
	'Response.WRite(Request.QueryString("BackURL"))
		BackURLArray = Split(Request.QueryString("BackURL"), ".")

		BackURL = "edittable.asp?mode=" & BackURLArray(0) & "&table=" & BackURLArray(2)
	
		If Not BackURLArray(1) = "" Then
			BackURL = BackURL & "&Father=" & BackURLArray(1)
		End If
		

		Response.Redirect BackURL
	End If
	
ElseIf Request.QueryString("mode") = "show" Then
%>

	<table width="90%">
	<%
	For Each x In objRsSelected.Fields
		iBool = 0
			
		s = Split(FieldsNotShow, ";")
			
		j = 0
			
		For j = 0 To UBound(s)	
			d = Split(s(j), ",")
					
			If (d(0) = x.name) Then
				If (d(1) = Table) OR (d(1) = "*") Then 
					iBool = 1
				End If
			End If
		Next
			
		If (iBool = 0) AND (not x.name = objRs.Fields(0).name) Then 
			iTrue = 0
				
			objRs.MoveFirst
			Do While NOT objRsReplace.EOF
				If objRsReplace("LangName") = x.name Then
					iTrue = 1
					Exit Do
				End If
	
				objRsReplace.MoveNext
			Loop
		
			If iTrue = 1 Then
			%>
				<tr>
					<td><b><%=objRsReplace("LangValue") %>:</b></td>
					<% 
					If Right(x.name, 2) = "ID" Then 
							Set objRsTemp = OpenDB("SELECT * FROM " & Replace(x.name, Right(x.name,2),"") & " WHERE " & Replace(x.name, Right(x.name,2),"") & "ID='" & objRsSelected(x.name) & "' AND SiteID=" & SiteID )
					%>
						<td><%=objRsTemp(Replace(x.name, Right(x.name,2),"") & "Name")%></td>			
					<%
						CloseDB(objRsTemp)
					Else 
					%>
						<td><%=objRsSelected(x.name)%></td>
					<% 
					End If 
					%>
				</tr>
			<%
			Else
			%>
				<tr>
					<td><b><%=x.name%>:</b></td>
					<% 
					If Right(x.name, 2) = "ID" Then 
							Set objRsTemp = OpenDB("SELECT * FROM " & Replace(x.name, Right(x.name,2),"") & " WHERE " & Replace(x.name, Right(x.name,2),"") & "ID='" & objRsSelected(x.name) & "' AND SiteID=" & SiteID )
					%>
						<td><%=objRsTemp(Replace(x.name, Right(x.name,2),"") & "Name")%></td>			
					<%
						CloseDB(objRsTemp)
					Else 
					%>
						<td><%=objRsSelected(x.name)%></td>
					<% 
					End If 
					%>
				</tr>
	 		<%		
	 		End If	
	 	End If
	Next
	%>
	</table>
	<%'************************************************ TOOLBAR EDIT *************************************
ElseIf Request.QueryString("mode") = "te" Then
	%>
		<form action="edittable.asp?table=<% = Table %>&mode=teadd&emode=<%If Request.QueryString("emode") = "add" Then%>add<%ElseIf Request.QueryString("emode") = "edit" Then%>&emode=editfinish&ToolbarID=<%=Request.QueryString("ToolbarID")%>"<%End If%> method="post">
			<table align="center" width="90%">
				<% 
				For Each x In objRs.Fields
				%>
					<tr>
					<%
					If Request.QueryString("emode") = "edit" Then
						Set objRsToolbar = OpenDB("SELECT * FROM Toolbar WHERE ToolbarID=" & Request.QueryString("ToolbarID"))	
						Fields = Split(objRsToolbar("ToolbarFields"), ",")
						
						iTrueE = 0
						For Each s In Fields
							If x.name = s Then
								iTrueE = 1
								Exit For
							End If
						Next
						
					End If
					%>
						<td align="left"><input type="checkbox" <% If Request.QueryString("emode") = "edit" And iTrueE = 1 Then %>checked<%End If%> name="<% = x.name %>"></td>
					<% 
					If Request.QueryString("emode") = "edit" Then
						CloseDB(objRsToolbar)	
					End If
					%>
					<td align="right"><% = x.name %></td>
	
						
					</tr>
				<%
				Next
				%>
			</table>
			
			<input type="submit" value="הוסף סרגל">
		</form>
	<%
ElseIf Request.QueryString("mode") = "teadd" Then
	
	strTemp = ""
	
	For Each x In objRs.Fields
		If Request.Form(x.name) = "on" Then
			strTemp = strTemp & x.name & ","
		End If
	Next
	
	'response.write strTemp
	strTemp = Mid(strTemp, 1, Len(strTemp) - 1)
	
	Set objRsToolbar = OpenDB("SELECT * FROM Toolbar")	
	
		If Request.QueryString("emode") = "editfinish" Then
				objRsToolbar("ToolbarTable") = Table
				objRsToolbar("ToolbarFields") = strTemp
				objRsToolbar("SiteID") = SiteID
			objRsToolbar.Update
		Else 
			objRsToolbar.AddNew
				objRsToolbar("ToolbarTable") = Table
				objRsToolbar("ToolbarFields") = strTemp
				objRsToolbar("SiteID") = SiteID
			objRsToolbar.Update
		End If			
	CloseDB(objRsToolbar)	
	
'--------------------------------------------------------הצגת קטגורויות אב ובן---------------------------------------------------
ElseIf Request.QueryString("mode") = "cat" Then 

	If Request.QueryString("GrandFather") = "" Then
		Set objRsFather = OpenDB("SELECT * FROM " & lcase(Request.QueryString("Father")) & " WHERE SiteID=" & SiteID)
	Else
		Set objRsGFather = OpenDB("SELECT * FROM " & lcase(Request.QueryString("GrandFather")) & " WHERE SiteID=" & SiteID)
		If NOT Request.QueryString("GFID") = "" Then
				Set objRsFather = OpenDB("SELECT * FROM " & lcase(Request.QueryString("Father")) & " WHERE SiteID=" & SiteID & " AND " & Request.QueryString("GrandFather") & "ID=" & Request.QueryString("GFID"))
		Else
				Set objRsFather = OpenDB("SELECT * FROM " & lcase(Request.QueryString("Father")) & " WHERE SiteID=" & SiteID)

		End If
		
	End If
	
	If Request.QueryString("emode") = "addfinisht" Then
		
 		objRs.AddNew
 			objRs(Table & "Name") = Request.Form(Table & "Name")
 			objRs(Request.QueryString("Father") & "ID") = Request.QueryString("RecordID")
 			objRs("SiteID") = SiteID
 		objRs.Update
 		 		
 		If NOT Request.QueryString("grandfather") = "" Then
 			RedirectURL = "&grandfather=" & Request.QueryString("grandfather") & "&GFID=" & Request.QueryString("GFID")
 		End If
 			
	   		Response.Redirect("edittable.asp?Table=" & Table & "&Father=" & lcase(Request.QueryString("Father")) & "&mode=cat&s=" & SiteID & RedirectURL)
 	
 	ElseIf Request.QueryString("emode") = "editfinisht" Then
 	
 		objRsSelected(Table & "Name") = Request.Form(Table & "Name")
 		objRsSelected(Request.QueryString("Father") & "ID") = objRsSelected(Request.QueryString("Father") & "ID")
 		objRsSelected.Update

	    If NOT Request.QueryString("grandfather") = "" Then
 			RedirectURL = "&grandfather=" & Request.QueryString("grandfather") & "&GFID=" & Request.QueryString("GFID")
 		End If

			Response.Redirect("edittable.asp?Table=" & Table & "&Father=" & lcase(Request.QueryString("Father")) & "&mode=cat&s=" & SiteID & RedirectURL)

 	ElseIf Request.QueryString("emode") = "addfinish" Then

 		objRsFather.AddNew
 			objRsFather(Request.QueryString("Father") & "Name") = Request.Form("Name")
			If Not Request.QueryString("grandfather") = "" Then
	 			objRsFather(Request.QueryString("grandfather") & "ID") = Request.QueryString("GFID")
	 		End If
 			objRsFather("SiteID") = SiteID
 		objRsFather.Update
 		
 				
	If NOT Request.QueryString("grandfather") = "" Then
 		RedirectURL = "&grandfather=" & Request.QueryString("grandfather") & "&GFID=" & Request.QueryString("GFID")
 	End If
 		
 		Response.Redirect("edittable.asp?Table=" & Table & "&Father=" & lcase(Request.QueryString("Father")) & "&mode=cat&s=" & SiteID & RedirectURL)

	ElseIf Request.QueryString("emode") = "deletet" Then
		objRsSelected.Delete
		
		If NOT Request.QueryString("grandfather") = "" Then
 			RedirectURL = "&grandfather=" & Request.QueryString("grandfather") & "&GFID=" & Request.QueryString("GFID")
 		End If
 		
			Response.Redirect("edittable.asp?Table=" & Table & "&Father=" & lcase(Request.QueryString("Father")) & "&mode=cat&s=" & SiteID & RedirectURL)
 	
 	ElseIf Request.QueryString("emode") = "delete" Then
			Set objRsS = OpenDB("SELECT * FROM " & lcase(Request.QueryString("Father")) & " WHERE " & lcase(Request.QueryString("Father")) & "ID=" & Request.QuerySTring("RecordID") & " AND SiteID=" & SiteID)
 		objRsS.Delete
		CloseDB(objRsS)

 		If NOT Request.QueryString("grandfather") = "" Then
 			RedirectURL = "&grandfather=" & Request.QueryString("grandfather") & "&GFID=" & Request.QueryString("GFID")
 		End If
 		
 		Response.Redirect("edittable.asp?Table=" & Table & "&Father=" & Request.QueryString("Father") & "&mode=cat" & RedirectURL)
 	
	ElseIf Request.Querystring("emode") = "up" Then
				Response.Redirect("edittable.asp?Table=" & Table & "&father=" & lcase(Request.QueryString("Father")) & "&mode=cat&s=" & SiteID & RedirectURL)

	ElseIf Request.Querystring("emode") = "down" Then
				Response.Redirect("edittable.asp?Table=" & Table & "&father=" & lcase(Request.QueryString("Father")) & "&mode=cat&s=" & SiteID & RedirectURL)

 	ElseIf Request.QueryString("emode") = "editfinish" Then
 	  	
		
			Set objRsS = OpenDB("SELECT * FROM " & lcase(Request.QueryString("Father")) & " WHERE " & lcase(Request.QueryString("Father")) & "ID=" & Request.QuerySTring("RecordID") & " AND SiteID=" & SiteID)
 	 	objRsS(lcase(Request.QueryString("Father")) & "Name") = Request.Form("Name")
 		objRsS.Update
		CloseDB(objRsS)
		
		If NOT Request.QueryString("grandfather") = "" Then
 			RedirectURL = "&grandfather=" & Request.QueryString("grandfather") & "&GFID=" & Request.QueryString("GFID")
 		End If
 	
			Response.Redirect("edittable.asp?Table=" & Table & "&father=" & lcase(Request.QueryString("Father")) & "&mode=cat&s=" & SiteID & RedirectURL)
	
 	End If
	%>
	
	<% If Not Request.QueryString("grandfather") = "" Then %>
		<select name="GFID" onchange="location.href='edittable.asp?table=<% = Table %>&Father=<% = Request.QueryString("Father") %>&grandfather=<% = Request.QueryString("GrandFather") %>&mode=cat&GFID='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
		<% Do While NOT objRsGFather.EOF %>
				<option <% If Int(Request.QueryString("GFID")) = Int(objRsGFather(0)) Then%>selected<% End If %> value="<% = objRsGFather(0) %>"><% = objRsGFather(Request.QueryString("GrandFather") & "Name")%></option>
		<%
			objRsGFather.MoveNext
		Loop
		%>
	</select>
	<% End If %>
	<table width="60%"  bgcolor="#FFFFFF" align="right">
		<tr>
			<td>
				<tr>
					<td><b>	<a href="edittable.asp?mode=cat&emode=addt&Father=<%=Request.QueryString("Father")%>&Table=<%=Table%><%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>">(הוספת רשומה)</a></b></td>
					<td></td>
					<td></td>
				</tr>		
				<% Do While NOT objRsFather.EOF 
					SQL = "SELECT * FROM " & Table & " WHERE " & objRsFather.Fields(0).name & "=" & objRsFather(0) & " AND SiteID=" & SiteID
					Set objRsSona = OpenDB(SQL)
				i = 1
				Cont = false
					
					For Each x In objRsSona.Fields 
						If lcase(x.name) = "orderfield" Then
							Cont = True
						End If
					Next
					
					If Cont=True then
				
						SQL = SQL & " ORDER BY orderfield ASC"
					end if
					closedb(objrssona)
					
				Set objRsSon = OpenDB(SQL)
				%>
				<tr>
				<% If Request.QueryString("emode") = "editt" And int(Request.QueryString("RecordID")) = int(objRsFather(0)) Then %>
							<form action="edittable.asp?mode=cat&emode=editfinish&RecordID=<%=objRsFather(0)%>&table=<%=Table%>&Father=<%=Request.QueryString("Father")%><%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>" method="post">
						<td><input type="text" value="<%=objRsFather(lcase(Request.QueryString("Father")) & "Name")%>" name="Name"></td>
						<td><input type="submit" value="שמור"></td>
						<td><input type="button" value="בטל" onclick="history.back()"></td>
				</form>
				<% Else %>
						<td><b><%=objRsFather(lcase(Request.QueryString("Father")) & "Name")%> <a href="edittable.asp?Table=<%=Table%>&Father=<%=lcase(Request.QueryString("Father"))%>&mode=cat&emode=add&RecordID=<%=objRsFather(0)%><%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>">(הוסף רשומה)</a></b></td>
						<td><b><a href="edittable.asp?table=<%=table%>&Father=<%=request.queryString("Father")%>&RecordID=<%=objRsFather(0)%>&mode=cat&emode=editt<%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>">עריכה</b></td>
						<td><% If NOT objRsSon.RecordCount > 0 Then %><b><a href="edittable.asp?table=<%=table%>&Father=<%=request.queryString("Father")%>&RecordID=<%=objRsFather(0)%>&mode=cat&emode=delete<%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>">מחיקה</b><% End If %></a></td>
					<% End If %>
				</tr>
				<%		
				
				Do While NOT objRsSon.EOF 
				%>
				<tr>					
					<% If (Request.QueryString("emode") = "edit") Then  %>
							<form action="edittable.asp?mode=cat&emode=editfinisht&RecordID=<%=objRsSon(0)%>&table=<%=Table%>&Father=<%=Request.QueryString("Father")%><%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>" method="post">
					<% End If %>
					
					<td>
					<% If (Request.QueryString("emode") = "edit") AND (Int(objRsSon(0)) = Int(Request.QueryString("RecordID"))) Then %>
					<input type="text" value="<%=objRsSon(Table & "Name")%>" name="<%=Table & "Name"%>">
					<% Else %>
					---<%=objRsSon(Table & "Name")%>
					<% End If %>
					</td>
					<td>
						<% If (Request.QueryString("emode") = "edit") AND (Int(Request.QueryString("RecordID")) = Int(objRsSon(0))) Then %>
							<input type="submit" value="שמור">
							
						<% Else %>
							<a href="edittable.asp?Table=<%=Table%>&Father=<%=lcase(Request.QueryString("Father"))%>&mode=cat&emode=edit&RecordID=<%=Int(objRsSon(0))%><%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>">
						<img src="../images/edit.png" border="0"></a>			
						<% End If %>
					</td>
					<% If (Request.QueryString("emode") = "edit") Then %>
					</form>
					<% End If %>
					<td>
					<% If (Request.QueryString("emode") = "edit") AND (Int(Request.QueryString("RecordID")) = Int(objRsSon(0))) Then %>
						<input type="button" value="בטל" onclick="history.back()">
					<% Else %>
						<a href="edittable.asp?table=<%=table%>&Father=<%=request.queryString("Father")%>&RecordID=<%=objRsSon(0)%>&mode=cat&emode=deletet<%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>">
					<img src="../images/remove.png" border="0"></a>
					<% End If %>
					</td>
						<td><a href="edittable.asp?mode=edit&table=<%=Table%>&RecordID=<%=objRsSon(0)%>&BackURL=cat.<%=Request.QueryString("Father")%>.<%=Table%>">
						<img src="../images/move.png" border="0"></a></td>
					<%
					Cont = false
					
					For Each x In objRsSon.Fields 
						If lcase(x.name) = "orderfield" Then
							Cont = True
						End If
					Next
					
					If Cont=True then %>
						<td><a href="edittable.asp?table=<% = table%>&Father=<% = Request.querystring("father") %>&RecordID=<% = objRsSon(0) %>&mode=cat&xRecordID=&emode=up">
						<img border="0" src="../images/up.png"></a></td>
						<td><a href="edittable.asp?table=<% = table%>&Father=<% = Request.querystring("father") %>&RecordID=<% = objRsSon(0) %>&mode=cat&xRecordID=&emode=down">
						<img border="0" src="../images/down.png"></a><% = objRsSon("orderfield") %></td>
					<% End if %>
				</tr>

				<%				
				i = i + 1

     			objRsSon.MoveNext
				Loop
				
				CloseDB(objRsSon)
				
				If lcase(request.queryString("emode") = "add") and Int(objRsFather(0)) = Int(Request.QueryString("RecordID")) Then 
				%>
					<form action="edittable.asp?Table=<%=Table%>&Father=<%=lcase(Request.QueryString("Father"))%>&mode=cat&emode=addfinisht&RecordID=<%=objRsFather(0)%><%If Not Request.QueryString("grandfather")="" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><% End If %>" method="post">
					<tr>
						<td>---<input name="<%=Table%>Name"></td>
						<td><input type="submit" value="הוסף"></td>
						<td><input type="button" value="בטל" onClick="history.back()"></td>
					</tr>
				</form>
				<% end if
				objRsFather.MoveNext
				Loop
		
				If Request.QueryString("emode") = "addt" Then
				%>
				
			<tr>
					<form action="edittable.asp?mode=cat&emode=addfinish&table=<%=Table%>&father=<%=Request.QueryString("Father")%><%If NOT Request.QueryString("GrandFather") = "" Then%>&grandfather=<%=Request.QueryString("GrandFather")%>&GFID=<%=Request.QueryString("GFID")%><%End If%>" method="post">
					<td><input type="text" name="Name"></td>
					<td><input type="submit" value="הוסף"></td>
					<td><input type="button" value="בטל" onClick="history.back()"></td>
				</form>
			</tr>
				<% End IF %>
			</td>
		</tr>
				

	</table><%
ElseIf Request.QueryString("mode") = "add" or request.querystring("mode") = "edit" Then
%>
	<table width="700" border="0" cellpadding="0" cellspacing="0" dir="<%=SysLang("Direction")%>">
	  <tr valign=top>
	    <td>
		<form action="edittable.asp?Table=<%=Table%>&mode=<%If Request.QueryString("mode") = "add" Then%>addnew<%ElseIf Request.QueryString("mode")="edit" Then%>editfinish&RecordID=<%=Request.QueryString("RecordID")%><%end IF %>&BackURL=<%=Request.QueryString("BackURL")%>" name="form1" method="post">
	<input type="hidden" name="SiteID" value="<%=SiteID%>">
	<table width="90%">
	<script type="text/javascript">
	
		function ShowTables() {
				window.open('TablesPopup.asp?table=<%=Table%>&RecordID=<%=Request.QueryString("RecordID")%>', "SelectTablesPopup", "width=600, height=600, dependent=yes, resizeable=yes, menubar=no, scrollbars=yes");
		}
		
		function ShowFields(Table) {
				window.open('FieldsPopup.asp?table='+Table+'&RecordID=<%=Request.QueryString("RecordID")%>', "SelectTablesPopup", "width=600, height=600, dependent=yes, resizeable=yes, menubar=no, scrollbars=yes");
		}
		
		function ShowToolbar(Table) {
				window.open('ToolbarPopup.asp?table='+Table+'&RecordID=<%=Request.QueryString("RecordID")%>', "SelectTablesPopup", "width=600, height=600, dependent=yes, resizeable=yes, menubar=no, scrollbars=yes");
		}
		
		function isNull(val){
			if(val==null){
				return true;
			}
		}

		function ChangeURL(ComboBox,xname,QS)
		{
		  if (!escape(ComboBox.options[ComboBox.selectedIndex].value)=="0")
			document.location = "edittable.asp?"+xname+"="+escape(ComboBox.options[ComboBox.selectedIndex].value)+"&"+QS;//+strURL;
		 }
						</script>
						
		<% 
		
		for each x in objRs.Fields			
			iBool = 0
			
			s = Split(FieldsNotShow, ";")
			
			j = 0
			
			For j = 0 To UBound(s)	
				d = Split(s(j), ",")
					
				If (d(0) = x.name) Then
					If (d(1) = Table) OR (d(1) = "*") Then 
						iBool = 1
					End If
				End If
			Next
		
			If (iBool = 0) AND (not x.name = objRs.Fields(0).name) Then 
		%>
		<tr>
			<td>
				<a href="edittable.asp?<% If GetIDByName(x.name) = "*" Then%>mode=add&table=lang&LangName=<%=x.name%><%Else%>mode=edit&table=lang&RecordID=<%=GetIDByName(x.name)%><% End If %>"><% GetLang x.name %></a>
			</td>
			<td>
				
				<% 
					DepenGroupsSplitted = Split(DepenGroups, ";")
					InConfig = False
					
					For Each DGS In DepenGroupsSplitted
						SplittedDepenGroupsSplitted = Split(DGS, ",")
						
							If UBound(SplittedDepenGroupsSplitted) = 1 Then
								If SplittedDepenGroupsSplitted(0) = x.name OR SplittedDepenGroupsSplitted(1) = x.name Then
									FirstItem = SplittedDepenGroupsSplitted(0)
									LastItem = SplittedDepenGroupsSplitted(1)
									Link = 2
								End If
							ElseIf UBound(SplittedDepenGroupsSplitted) = 2 Then
									If SplittedDepenGroupsSplitted(0) = x.name OR SplittedDepenGroupsSplitted(1) = x.name or SplittedDepenGroupsSplitted(2) = x.name Then
									FirstItem = SplittedDepenGroupsSplitted(0)
									MiddleItem = SplittedDepenGroupsSplitted(1)
									LastItem = SplittedDepenGroupsSplitted(2)
									Link = 3
								End If
							End If
										
						For Each i In SplittedDepenGroupsSplitted 
							If i = x.name Then
								InConfig = True
							End If
						Next
					Next
	
					If (Right(x.name, 2) = "ID") And (not x.name = "SiteID") and (InConfig = True) Then  
							WhereSql = ""
							WhereSql2 = ""
						if inStr(GlobalFields,","&x.name&",") = 0 Then
							WhereSql = " WHERE SiteID=" & SiteID
							WhereSql2 = " AND SiteID=" & SiteID
						End if
						If (x.name = LastItem) or (InConfig = False) Then
							SQL = "SELECT * FROM " & Replace(x.name, Right(x.name,2),"") & WhereSql
						Else
							If Request.QueryString("mode")="edit" Then
								If Request.QueryString(Father) <> "" Then
										SQL = "SELECT * FROM " & Replace(x.name, "ID", "") & " WHERE " & Father & "='" & Request.QueryString(Father) & "'" & WhereSql2
								Else
										SQL = "SELECT * FROM " & Replace(x.name, "ID", "") & " WHERE " & Father & "='" & objRsSelected(Father) & "'" & WhereSql2
								End If
							Else
									SQL = "SELECT * FROM " & Replace(x.name, "ID", "") & " WHERE " & Father & "='" & Request.QueryString(Father) & "'" & WhereSql2
							End If
						End If
		
						
						Father = x.name
						Set objRsTemp = OpenDB(SQL)
						

						QS = Request.QueryString
						QS = Replace(QS, "&" & x.name & "=" & Request.QueryString(x.name),"")
						QS = Replace(QS, x.name & "=" & Request.QueryString(x.name) & "&","")
						%>
						
						<select x name="<% = x.name %>" onchange="ChangeURL(this, '<%=x.name%>', '<% = QS%>');">
							<option value="0"><%=SysLang("Select")%></option>
							<% 
							Do While NOT objRsTemp.EOF  %>
										<option <% If Request.QueryString("mode") = "edit" then %><%If REquest.QueryString(Father) = "" Then%><%if objRsSelected(x.name) = objRsTemp(0) Then%>selected<%End If%><%Else%><% If Int(objRsTemp(0)) = Int(Request.QueryString(x.name)) Then %>selected<%End If%><%End If%><%Else%><% If Int(objRsTemp(0)) = Int(Request.QueryString(x.name)) Then %>selected<% End If %><%End If%> value="<%=objRsTemp(x.name)%>"><% = objRsTemp(Replace(x.name, Right(x.name,2),"") & "Name") %></option>
							<%
								objRsTemp.MoveNext
							Loop
							%>
					</select>
					<% if instr(GlobalFields,","&FirstItem&",") = 0 then %>
						<% If Link = 2 Then %><a href="edittable.asp?table=<% = Replace(FirstItem, "ID", "") %>&Father=<% = Replace(LastItem, "ID", "") %>&mode=cat"><%=SysLang("Edit")%></a><% End If %>
					<% end if %>
					<% 
						CloseDB(objRsTemp)	
					ElseIf (Right(x.name, 2) = "ID") And (not x.name = "SiteID") and (InConfig = False) Then  
						Set objRsTemp = OpenDB("SELECT * FROM " & Replace(x.name, Right(x.name,2),"") & " WHERE SiteID=" & SiteID )
						'הריפלס = הרי השם של השדה הוא טבלה+איידי, אז זה מוחק את האיידי ואז נשאר לנו השם של הטבלה
					%>
						<select name="<% = x.name %>">
							<% 
							Do While NOT objRsTemp.EOF  %>
									<option <% If Request.QueryString("mode") = "edit" Then %><%If objRsSelected(x.name) = objRsTemp(0) Then %>selected<%End If%><%End If%> value="<%=objRsTemp(x.name)%>"><% = objRsTemp(Replace(x.name, Right(x.name,2),"") & "Name") %></option>
								<%
								objRsTemp.MoveNext
							Loop
							%>
						</select>
						<a href="edittable.asp?table=<%= Replace(x.name, Right(x.name,2),"")%>&S=<%=SiteID%>"><%=SysLang("Edit")%></a>
					<%
						CloseDB(objRsTemp)
					ElseIf instr(lcase(x.name),"image") <> 0 Then
					response.cookies("userdir") = Application(ScriptName & "UploadPath")
					%>

<!--start-->
<%
if request("mode") ="add" then
%>
<input  style="width:300px;" type="hidden" name="<%=x.name%>" id="<%=x.name%>">
<img id="load<%=x.name%>x" src="../images/loader.gif" style="display:none;">
<input onchange="return ajaxFileUpload('<%=x.name%>');" id="<%=x.name%>x" type="file" size="10" name="<%=x.name%>x" class="input">
<img id="prv<%=x.name%>" src="" style="display:none;" width="100" height="80">
<span id="del<%=x.name%>" style="display:none;cursor:point;" onclick="delimage('<%=x.name%>')">מחק תמונה</span>
<%
If Request.QueryString("mode") = "edit" Then
If objRsSelected(x.name) <> "" Then								
%>
<script language="javascript" type="text/javascript">
imageExist('<%=x.name%>');
</script>
<% 
End If
End If
else
%>

<!--end-->
<input  value="<%=objRsSelected(x.name)%>" style="width:300px;" type="text" name="<%=x.name%>" id="<%=x.name%>">
<span style="cursor:pointer;" onClick="javascript:	window.open('/filemanger/default.asp?object=<%=x.name%>&subfolder=/Content', 'SelectTablesPopup', 'width=600, height=600, dependent=yes, resizeable=yes, menubar=no, scrollbars=yes');">בחר תמונה קיימת</span>
					<%
end if
	ElseIf instr(lcase(x.name),"file") <> 0 Then
					response.cookies("userdir") = Application(ScriptName & "UploadPath")
					%>

<!--start-->
<%
if request("mode") ="add" then
%>
<input  style="width:300px;" type="hidden" name="<%=x.name%>" id="<%=x.name%>">
<img id="load<%=x.name%>x" src="../images/loader.gif" style="display:none;">
<input onchange="return ajaxFileUpload2('<%=x.name%>');" id="<%=x.name%>x" type="file" size="10" name="<%=x.name%>x" class="input">
<img id="prv<%=x.name%>" src="" style="display:none;" width="100" height="80">
<span id="del<%=x.name%>" style="display:none;cursor:point;" onclick="delimage('<%=x.name%>')">מחק תמונה</span>
<%
If Request.QueryString("mode") = "edit" Then
If objRsSelected(x.name) <> "" Then								
%>
<script language="javascript" type="text/javascript">
fileType('<%=x.name%>');
</script>
<% 
End If
End If
else
%>

<!--end-->
<input  value="<%=objRsSelected(x.name)%>" style="width:300px;" type="text" name="<%=x.name%>" id="<%=x.name%>">
<span style="cursor:pointer;" onClick="javascript:	window.open('/filemanger/default.asp?object=<%=x.name%>&subfolder=/Content', 'SelectTablesPopup', 'width=600, height=600, dependent=yes, resizeable=yes, menubar=no, scrollbars=yes');">בחר תמונה קיימת</span>
					<%
end if
					ElseIf lcase(Right(x.name,5)) = "color" Then
					%>
<input type="text" name="<%=x.name%>" id="<%=x.name%>" size="6" <%If Request.QueryString("mode") = "edit" Then%> value="<%=objRsSelected(x.name)%>" <%End If%> onchange="ColorChanged(document.imgColor6, this);">
<a href="javascript:void 0;" onclick="ChangeColor(<%=x.name%>c, document.getElementById('<%=x.name%>'));return false;">
<img type="image" name="<%=x.name%>c" src="../ColourPicker/dropper.gif" id="<%=x.name%>c" <%If Request.QueryString("mode") = "edit" Then%> style="BACKGROUND-COLOR:#<%=objRsSelected(x.name)%>" <%End If%> 
class="ColorPicker" align="absMiddle"></a>
					<%
					ElseIf lcase(Mid(x.name, 1, 6)) = "tables" Then		
										
					%>
							<input <%If Session(SiteID & "AdminLevel") = 1 Then%>type="text"<%Else%>type="hidden"<%End If%> <% If Request.QueryString("mode") = "edit" Then %>value="<%=objRsSelected(x.name)%>"<% End If %> size="100" name="<% = x.name %>">
						<%If Session(SiteID & "AdminLevel") = 1 Then%><a href="#" onclick="javascript:ShowTables()">הצג טבלאות</a><%End If%>
					<%	
					ElseIf lcase(Mid(x.name, 1,14)) = "showfieldsname" Then
					%>
							<input  <% If Request.QueryString("mode") = "edit" Then %>value="<%=objRsSelected(x.name)%>"<% End If %> size="100" <% If lcase(x.name) = "password" Then %>type="password"<%Else%>type="text"<%End If%> name="<% = x.name %>">
						<a href="#" onclick="javascript:ShowFields(TableName.value)">הצג שדות</a>

					<%
					ElseIf x.name = "ToolbarFields" Then
					%>
							<input  <% If Request.QueryString("mode") = "edit" Then %>value="<%=objRsSelected(x.name)%>"<% End If %> size="100" <% If lcase(x.name) = "password" Then %>type="password"<%Else%>type="text"<%End If%> name="<% = x.name %>">
						<a href="#" onclick="javascript:ShowToolbar(ToolbarTable.value)">הצג שדות</a>

					<%
					ElseIf x.name = "TableName" OR lcase(Right(x.name, 5)) = "table" Then
					
						Const adSchemaTables = 20
						Set objConnection = SetConn()
						Set objRecordSet = CreateObject("ADODB.Recordset")
						Set objRecordSet = objConnection.OpenSchema(adSchemaTables)
						%>
						<select name="<%=x.name%>">
						<%
						Do While NOT objRecordset.EOF
							If lcase(objRecordset.Fields.Item("TABLE_TYPE")) = "table" Then
							%>
									<option <%If Request.QueryString("mode") = "edit" Then%><%If objRecordset.Fields.Item("TABLE_NAME") = objRsSelected(x.name) Then%>selected<%End If%><%End If%> value="<% = objRecordset.Fields.Item("TABLE_NAME") %>"><% = objRecordset.Fields.Item("TABLE_NAME") %></option>
							<%
							End If
							objRecordset.MoveNext
						Loop
						%>
						</select>
					<%
					ElseIf lcase(Right(x.name, 5)) = "level" Then
					%>
						<select name="<%=x.name%>">
							<% For I = Int(Session(SiteID & "AdminLevel")) To Int(Replace(lcase(Right(x.name,6)), "level", "")) %>
								<option <% IF REquest.QueryString("mode") = "edit" Then %><% If I = Int(objRsSelected(x.name)) Then%>selected<%ENd If%><%End If %> value="<%=I%>"><%=I%></option>
							<%Next%>
						</select>
					<%
					ElseIf x.type = 11 Then
					%>
							<input <% If Request.QueryString("mode") = "edit" Then %><% If objRsSelected(x.name) = "True" Then %>checked<%End If %><% End If %> type="radio" value="True" name="<%=x.name%>">כן 
							<input <% If Request.QueryString("mode") = "edit" Then %><% If objRsSelected(x.name) = "False" Then %>checked<%End If %><% End If %> type="radio" value="False" name="<%=x.name%>">לא 
				
	<%				ElseIf x.type = 135 Then
					%>
<input <% If Request.QueryString("mode") = "edit" Then %> value='<%=objRsSelected(x.name)%>' dir="ltr" <%End If%> type="text"  size="20" name="<%=x.name%>">
<a href="#" onclick="popupCalendarDateCapture('form1','<% = x.name %>');">בחר תאריך</a>

					<%
					ElseIf lcase(Mid(x.name,1,7)) = "nofield" Then
					
					Else
						If x.DefinedSize > 100 And x.DefinedSize < 400 Then 						
						%>
								<textarea rows="5" cols="40" name="<%=x.name%>"><% If Request.QueryString("mode") = "edit" Then%><%=objRsSelected(x.name)%><%End If%></textarea>
					
						<%
						ElseIf x.DefinedSize >= 400 Then
							Dim oFCKeditor
							Set oFCKeditor = New FCKeditor
							oFCKeditor.BasePath = "FCKeditor/"
							
							If Request.QueryString("mode") = "edit" Then
								oFCKeditor.Value = objRsSelected(x.name)
							End If
							
							oFCKeditor.width="100%"
							oFCKeditor.height = "200"
							oFCKeditor.ToolbarSet = "Basic"
							oFCKeditor.Create x.name
					 	Else 
						%>
							<input  <% If Request.QueryString("mode") = "edit" Then %>value="<%=objRsSelected(x.name)%>"<%ElseIf Request.QueryString(x.name) <> "" Then%>value=<%=Request.QueryString(x.name)%><% End If %> size="<%=x.DefinedSize %>" <% If lcase(x.name) = "password" Then %>type="password"<%Else%>type="text"<%End If%> name="<% = x.name %>" maxlength="<%=x.DefinedSize %>">
					<%
						End If
					End If
				End If
			 %>
				
			</td>
		</tr>
		<% next %>
		
		
<script runat="server" language="javascript">
	function ValidateForm(form)
	{
		var i = 0;
		
		var elem = document.getElementById('form1').elements;
					
		for(var i = 0; i < elem.length; i++)
		{
			//if(!elem[i].name.substring(0, 3) == "NULL") {
				if (elem[i].value=="" || (elem[i].value==0 && elem[i].type=="select") ) {
					alert("שדה "+elem[i].name+" הוא חובה.");
					return false;
				}
			//}
		} 
		
	}
</script>
</table>
<input value="<% If Request.QueryString("mode") = "edit" Then %>ערוך<%Else%>הוסף<%End If%>" type="submit">
</form>
</td>
</tr>
</table>

<% Else %>

	<br>
	<table width="90%">
		<tr>
			<td width="80%"><b>
			<%
			iTrue = 0
			
			Do While NOT objRsReplace.EOF
				If objRsReplace("LangName") = Table & "Name" Then
					iTrue = 1
					Exit Do
				End If
	
				objRsReplace.MoveNext
			Loop
		
			If iTrue = 1 Then 
			%>
				<b><%=objRsReplace("LangValue") %></b>
			<% Else %>
			<% = Table & "Name"%> 
			<% End If %>
			<a href="edittable.asp?mode=add&table=<%=Table%>">(הוספת רשומה)</a></b></td>
			<td align="left" width="10%"><b>עריכה</b></td>
			<td align="left" width="10%"><b>מחיקה</b></td>
		</tr>

		<% Do While NOT objRs.Eof %>
			<tr>
					<td width="80%"><a href="edittable.asp?mode=show&table=<%=Table%>&RecordID=<%=objRs(0)%>"><% = objRs(Table & "Name") %></a></td>
				
				   <td align="left" width="10%"><a href="edittable.asp?mode=edit&table=<%=Table%>&RecordID=<%=objRs(0)%>">עריכה</a></td>
					<td align="left" width="10%"><a href="edittable.asp?mode=delete&table=<%=Table%>&RecordID=<%=objRs(0)%>">מחיקה</a></td>
			</tr>
		<% 
		objRs.MoveNext
		Loop
		%>
	</table>
	
<% 
End If 
'bottom
%>