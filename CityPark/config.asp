<!--#include file="$SqlInjectionProtection.asp"-->
<!--#include file="$connection.asp"-->
<!--#include file="$db.asp"-->
<!--#include file="admin/fckeditor/fckeditor.asp"-->
<!--#include file="objPageCache.asp"-->

<%
		Function EndsWith(str, str2)
			EndsWith = LCase(Mid(str, Len(str) + 1 - Len(str2))) = LCase(str2)
		End Function
	DDomain = LCase(Request.ServerVariables("HTTP_HOST"))
	IsTLK1 = EndsWith(DDomain, ".com") Or EndsWith(DDomain, ".net") Or EndsWith(DDomain, ".org") Or EndsWith(DDomain, ".info")Or EndsWith(DDomain, ".jobs") 
	IsTLK2 = EndsWith(DDomain, ".co.il") Or EndsWith(DDomain, ".co.uk") Or EndsWith(DDomain, ".ac.il") Or EndsWith(DDomain, ".org.il") Or EndsWith(DDomain, ".net.il") Or EndsWith(DDomain, ".muni.il")
	IsSubdomain = (IsTLK1 And UBound(Split(DDomain, ".")) = 2) Or (IsTLK2 And UBound(Split(DDomain, ".")) = 3)
	

	'REMOVE THIS FALSE RAN BRANDES
	If false And LCase(Request.ServerVariables("HTTPS")) = "off" And Not IsSubdomain  Then
		TheURL = "http://www." & DDomain
		
		If LCase(Request.ServerVariables("URL")) <> "/default.asp" Then
            p = Request.ServerVariables("URL") & "?" & Request.QueryString
		    If Mid(p, 1, Len("/sc.asp?p=")) = "/sc.asp?p=" Then 
		        TheURL = TheURL & "/" & Mid(p, Len("/sc.asp?p=") + 1)
		   		Response.Status="301 Moved Permanently"
		        Response.AddHeader "Location", TheURL
		     Else

			    TheURL = TheURL & Request.ServerVariables("URL")
		
			    If Request.QueryString <> "" Then
    				TheURL = TheURL & "?" & Request.QueryString
    		    End If	
    		    
 		   		Response.Status="301 Moved Permanently"
		        Response.AddHeader "Location", TheURL   		
    		
    		End If
        End If		
	End If
	

'--------------------------------------------------áãé÷ú SQL INJECTION--------------------------------------
Function URLDecode(sIn)
    dim x, y, abfrom, abto
    Decode="": ABFrom = ""

    For x = 0 To 25: ABFrom = ABFrom & Chr(65 + x): Next 
    For x = 0 To 25: ABFrom = ABFrom & Chr(97 + x): Next 
    For x = 0 To 9: ABFrom = ABFrom & CStr(x): Next 

    abto = Mid(abfrom, 14, Len(abfrom) - 13) & Left(abfrom, 13)
    For x=1 to Len(sin): y=InStr(abto, Mid(sin, x, 1))
        If y = 0 then
            Decode = Decode & Mid(sin, x, 1)
        Else
            Decode = Decode & Mid(abfrom, y, 1)
        End If
    Next
    
    URLDecode = Decode
End Function

Function URLDecode2(str) 
        str = Replace(str, "+", " ") 
        For i = 1 To Len(str) 
            sT = Mid(str, i, 1) 
            If sT = "%" Then 
                If i+2 < Len(str) Then 
                    sR = sR & _ 
                        Chr(CLng("&H" & Mid(str, i+1, 2))) 
                    i = i+2 
                End If 
            Else 
                sR = sR & sT 
            End If 
        Next 
        URLDecode2 = sR 
    End Function 

'--------------------------------------------------ñéåí áãé÷ú SQL INJECTION--------------------------------------

Response.Buffer = true
Session.Timeout=50

If  Request.QueryString("S") <> "" Then
Session("SiteID") = Request.QueryString("S")
End if

SiteID = Session("SiteID")
Session.LCID = 1037 


'if session of siteid is null then redirect to the server
		If Session("SiteID") = "" then

			DDomain = LCase(Request.ServerVariables("HTTP_HOST"))
				Set objRs = OpenDB("SELECT SiteID,SiteName, LangID, Domains FROM Site WHERE (NOT Domains = '')")
					Do While Not objRs.EOF
						Domains = Split(objRs("Domains"), ",")
							For Each Domain In Domains
								If (LCase(Domain) = DDomain) Then

				Session("SiteID") = objRs("SiteID")
				SiteID = objRs("SiteID")
				Session("SiteLang") = objRs("LangID") 
				
      				Exit Do
			End If
		Next
		
		objRs.MoveNext
	Loop
	
	CloseDB(objRs)

	End If	
If  Request.QueryString("ref") <> "" Then
	Response.Cookies(SiteID & "ref") = Request.QueryString("ref")
End if
	
		
	'	If Application(ScriptName & "ConfigLoaded") <> "Yes" Then 
				Set objRsConfig=OpenDB("SELECT * FROM Site Where SiteID= " & SiteID)
					ScriptName = objRsConfig("Sitename")
					UploadPath = objRsConfig("UploadPath")
					Session("SiteFiles") =  UploadPath 

					If Session("SiteLang") = "" Then
						Session("SiteLang") = objRsConfig("LangID") 
					End If
						
					If request.querystring("lang") <> "" Then
						Session("SiteLang") = request.querystring("lang")
					End If
                    LangID = Session("SiteLang")
					For sRun = 0 to objRsConfig.Fields.Count - 1
							Application(ScriptName & objRsConfig.Fields(sRun).Name) = objRsConfig.Fields(sRun).Value
						Next
				objRsConfig.Close
					Application(ScriptName & "ConfigLoaded")= "Yes"
	'	End If
		
	Response.CodePage = 65001  
	

	

Function GenerateValueFromID(RecordID, FieldName)
	If UCase(Right(FieldName, 2)) = "ID" And IsNumeric(RecordID) And FieldName <> "SiteID" Then
			Set objRs = OpenDB("Select " & Mid(FieldName, 1, InStr(FieldName, "ID") - 1) & "Name From " & Mid(FieldName, 1, InStr(FieldName, "ID") - 1) & " Where " & FieldName & " = " & RecordID)
		GenerateValueFromID = objRs(Mid(FieldName, 1, InStr(FieldName, "ID") - 1) & "Name")
	Else
		GenerateValueFromID = RecordID
	End If
End Function
SiteFiles = "/Sites/" & GetConfig("SiteName") & "/"
SiteLayout = SiteFiles & "layout/" & Session("SiteLang") & "/"

%><!--#include file="$xmlblocks.asp"-->
<%
		URL = Request.ServerVariables("URL")


		If Request.QueryString <> "" Then URL = URL & "?" & Request.QueryString
		

		
		
		If Not URL = "/poll.asp" And Not URL = "/poll.asp?header=true&poll_id=1" Then
			SetSession "PageURL", URL
		End If
		

		Session("ID") = request.querystring("ID")
		
		Sub LogDisplay(contentType, Name)
			
			SQL = "Insert Into Analytics (Name, Datetime, SiteId) Values ('" & Replace(Name, "'", "''") & "', GetDate(), " & SiteId & ")"
			'ExecuteRs(SQL)
		End Sub
		
        Sub Countclick(Table, xId,Field)
			
			SQL = "Insert Into Clicks (Tablename,ContentId,Fieldname, date, ip, SiteId) Values ('" & Replace(Table, "'", "''") & "', " & xId & ",'" & Replace(Field, "'", "''") & "', GetDate(), '" &Request.ServerVariables("REMOTE_ADDR") & "', " & SiteId & ")"

			ExecuteRs(SQL)
		End Sub

		
%>
