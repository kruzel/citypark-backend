<!--#include file="$connection.asp"-->
<!--#include file="md5.asp"-->
<!--#include file="hash.asp"-->

<%

Function SetConn()
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open(strconn)
		
	Set SetConn = Conn

End Function

Function stripHTML(strHTML)
'Strips the HTML tags from strHTML

  Dim objRegExp, strOutput
  Set objRegExp = New Regexp

  objRegExp.IgnoreCase = True
  objRegExp.Global = True
  objRegExp.Pattern = "<(.|\n)+?>"

  'Replace all HTML tag matches with the empty string
  strOutput = objRegExp.Replace(strHTML, "")
  
  'Replace all < and > with &lt; and &gt;
  strOutput = Replace(strOutput, "<", "&lt;")
  strOutput = Replace(strOutput, ">", "&gt;")
  strOutput = Replace(strOutput, "&nbsp;", " ")
  strOutput = Replace(strOutput, "&ndash;", " ")
  strOutput = Replace(strOutput, "&quot;", " ")
  strOutput = Replace(strOutput, " &middot;", " ")
 
  
  stripHTML = strOutput    'Return the value of strOutput

  Set objRegExp = Nothing
End Function



Function SetRS(SQL, Conn)
	Set Conn = SetConn()
	Set Rs = Server.CreateObject("ADODB.Recordset")
             If Request.QueryString("vafel")="true" then
                response.Write sql & "<br />"
             End if
			' response.write sql
	Rs.Open SQL, Conn, 3, 3
		
	Set SetRS = Rs
End Function

Function OpenDB(SQL)
	Set Rs = SetRS(sql,Conn)
	Set OpenDB = Rs
End Function

Sub ExecuteRS(SQL)
	Set objConn = SetConn()
	objConn.Execute SQL
	objConn.Close
	Set objConn = Nothing
End Sub	

Function ExecuteFunction(SQL)
	Set objConn = SetConn()
	set rs = objConn.Execute(SQL)
	ExecuteFunction = rs("A")
	objConn.Close
	Set objConn = Nothing
End Function	

Sub CloseDB(Rs)
	Rs.close
	Set Rs = Nothing	
	Set Conn = Nothing

End Sub 


Function GetLang(LangNameA)
	iTrue = 0
	SQL = "SELECT * FROM Lang WHERE LangName='" & LangNameA & "' AND SiteID=" & SiteID
	Set objRsLang = OpenDB(SQL)
	
	If objRsLang.RecordCount > 0 Then
		iTrue = 1
	End If

	If iTrue = 0 Then
		Response.Write(LangNameA)
	Else
		Response.Write(objRsLang("LangValue"))
	End If
	
	CloseDB(objRsLang)
End Function


Function GetLangA(LangNameA)
	iTrue = 0
	SQL = "SELECT * FROM Lang WHERE LangName='" & LangNameA & "' AND SiteID=" & SiteID
	Set objRsLang = OpenDB(SQL)
	
	If objRsLang.RecordCount > 0 Then
		iTrue = 1
	End If

	If iTrue = 0 Then
		GetLangA = LangNameA
	Else
		GetLangA = objRsLang("LangValue")
	End If
	
	CloseDB(objRsLang)
End Function


Sub CheckSecuirty(Table)
	Username = Session(SiteID & "Username")
	Password = Session(SiteID & "Password")

		Set objRsAdmin = OpenDB("SELECT * FROM Admin WHERE (Username='" & Username & "') And (Password='" & Password & "') And (SiteID=" & SiteID & ")")

	If objRsAdmin.RecordCount > 0 Then
		Login = True

		Tables = Split(objRsAdmin("Tables"), ",")
		
		For Each x In Tables
			If lcase(x) = lcase(Table) OR x = "*" Then
				AllowTable = True
				Exit For
			Else
				AllowTable = False
			End If
		Next
	
	Else
		AllowTable = False
		Login = False
	End If
		
	If AllowTable = False Then
		Session(SiteID & "URL") = Request.ServerVariables("URL") & "?" & Request.QueryString
		
		If Login = False Then
			Response.Redirect "/admin/"
		Else
			Response.Redirect "security.asp?mode=denied"
		End If
		
	End If

	CloseDB(objRsAdmin)
	
End Sub

'-------------------------------
Sub CheckCategorySecuirty(Category)
	Username = Session(SiteID & "Username")
	Password = Session(SiteID & "Password")
	
		Set objRsAdmin = OpenDB("SELECT Categorys FROM Admin WHERE (Username='" & Username & "') And (Password='" & Password & "') And (SiteID=" & SiteID & ")")

	If objRsAdmin.RecordCount > 0 Then
		Login = True

		'print objRsAdmin("Categorys")
		AllowTable = False
		Tables = Split(objRsAdmin("Categorys"), ",")
		For Each x In Tables
			
			'print "--"&X&"--"&Category
			If int(x) = int(Category) OR x = 0  Then
				AllowTable = True
				Exit For
			End if
			If CheckCategorySons(x,Category) And AllowTable = False then 
				AllowTable = True
				Exit For
			End if
		Next
	
	Else
		AllowTable = False
		Login = False
	End If
		
	If AllowTable = False Then
		Session(SiteID & "URL") = Request.ServerVariables("URL") & "?" & Request.QueryString
		
		If Login = False Then
			Response.Redirect "/admin/"
		Else
			Print "<div id=""error"">אין הרשאה לקטגורייה זאת</div>"
			response.end
			'Response.Redirect "security.asp?mode=denied"
		End If
		
	End If

	CloseDB(objRsAdmin)
	
End Sub

Function CheckCategorySons(cat,pageid)
	Set objRscat = OpenDB("SELECT FatherID FROM Contentfather WHERE ContentID='" & pageid & "' And (SiteID=" & SiteID & ")")

	If objRscat.recordcount > 0 then
		Do While not objRsCat.eof
			If int(ObjRscat("FatherID")) = int(cat) then
				CheckCategorySons = True
				Exit Do
			ElseIf objRscat("FatherID") = 0 Then
				CheckCategorySons = false
				Exit Do
			Else
				call CheckCategorySons(cat,ObjRscat("FatherID"))
			End if
		objRsCat.movenext
		loop
	End if
	CloseDB(ObjRscat)
End Function

Sub Checkcategoryfather(category)
'Checkcategoryfather = False
		'Set objRscat = OpenDB("SELECT * FROM Contentfather WHERE ContentID=" & category & " And (SiteID=" & SiteID & ")")
			'If objRscat.recordcount > 0 then
				'If CheckCategorySecuirty(objRscat("FatherID")) = True then
					Checkcategoryfather = True
				'End If
			'Else
					'Checkcategoryfather(objRscat("FatherID"))
			'End if
End sub

'-----------------------------

Function CheckCategorySecuirty2(Category)
	Username = Session(SiteID & "Username")
	Password = Session(SiteID & "Password")
	
		Set objRsAdmin = OpenDB("SELECT * FROM Admin WHERE (Username='" & Username & "') And (Password='" & Password & "') And (SiteID=" & SiteID & ")")
		Tables = Split(objRsAdmin("Categorys"), ",")
		For Each x In Tables
			If int(x) = int(Category) OR x = 0 Then
                CheckCategorySecuirty2=1
				Exit For
			Else
                CheckCategorySecuirty2=0
			End If
		Next
	CloseDB(objRsAdmin)
	
End Function





Sub CheckSecurity_Level(Level)
	m_Level = Int(Level)
	m_UserLevel = Request.Cookies(SiteID & "UserLevel")
	
	If m_UserLevel = "" Then
		m_UserLevel = 9
	Else
		m_UserLevel = Int(m_UserLevel)
	End If
	
	If m_UserLevel > m_Level Then
		Response.Redirect GetConfig("loginPage")
	End If
End Sub

Sub CheckUserSecurity_Level(Level,Target)
	m_Level = Int(Level)
	m_UserLevel = Request.Cookies(SiteID & "UserLevel")
	
	If m_UserLevel = "" Then
		m_UserLevel = 9
	Else
		m_UserLevel = Int(m_UserLevel)
	End If
	
	If m_UserLevel > m_Level Then
		Response.Redirect Target & "?mode=lowlevel"
	End If
End Sub


Function GetIDByName(Name)

	Set objRsGetID = OpenDB("SELECT LangID, LangName, SiteID FROM Lang WHERE (LangName='" & Name & "') AND (SiteID=" & SiteID & ")")
	
	If objRsGetID.RecordCount = 0 Then
		GetIDByName = "*"
	Else
		GetIDByName = objRsGetID(0)
	End If
	
	CloseDB objRsGetID


End Function 


Function SysLang(Word)

	
		Set objRsSysLang = OpenDB("SELECT * FROM SysLang  WHERE (SysLangName='" & Word & "') AND (SiteLangID='" & Session("SiteLang")& "')")
	
	If Not objRsSysLang.RecordCount > 0 Then
		SysLang = Word
	Else
		SysLang = objRsSysLang("SysLangTrans")
	End If
	
	CloseDB(objRsSysLang)
End Function

Function SiteTranslate(Word)

	
		Set objRsSiteLang = OpenDB("SELECT * FROM SiteLang  WHERE (SiteLangName='" & Word & "') AND (LangID='" & Session("SiteLang")& "') AND (SiteID='" & SiteID& "')")
	
	If Not objRsSiteLang.RecordCount > 0 Then
		SiteTranslate = Word
	Else
		SiteTranslate = objRsSiteLang("SiteLangTrans")
	End If
	
	CloseDB(objRsSiteLang)
End Function

Function CheckHacker(strTemp)

	strTemp = Replace(strTemp, "'", "@")
	strTemp = Replace(strTemp, "=", "@")
	strTemp = Replace(strTemp, "Like", "@")

	CheckHacker = strTemp
	
End Function 



Sub CheckUserCategorySecuirty(Category)
	AllowTable = False
	If Request.Cookies(SiteID & "UserID") <> "" then
		Set objRsAdmin = OpenDB("SELECT * FROM Users WHERE ID=" & Request.Cookies(SiteID & "UserID") & " AND SiteID=" & SiteID)
			
			Tables = Split(objRsAdmin("Categorys"), ",")
				For Each x In Tables
				Set objRscat = OpenDB("SELECT * FROM Contentfather Where ContentID=" & int(Category))
					'If int(x) = int(Category) OR x = 0 Then
					If (int(x) = int(Category)) OR (int(x) = int(objRscat("FatherID"))) OR x = 0 Then
						AllowTable = True
						Exit For
					Else
						AllowTable = False
					End If
				Next
		End if

	If AllowTable = False Then
		header
		' set fs=Server.CreateObject("Scripting.FileSystemObject")
             othertemplate = templatelocation & "nopermision.html"
                           ' if fs.FileExists(Server.MapPath(othertemplate))=true then
                                ProcessLayout(GetUrl(othertemplate))
                           ' end if
		bottom
	CloseDB(objRscat)
	CloseDB(objRsAdmin)
		Response.end
	End If
		

	CloseDB(objRscat)
	CloseDB(objRsAdmin)
End Sub









%>
