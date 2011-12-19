<%
BlackList = Array("@@", "char", "nchar", "varchar", "nvarchar",_
                  "alter", "begin", "cast", "create", "cursor",_
                  "declare", "drop", "exec","script",_
                  "execute", "fetch", "insert", "kill", "open",_
                  "select", "sys", "sysobjects", "syscolumns",_
                  "update")
BlackListForm = Array("@@","nchar", "varchar", "nvarchar", "declare","execute","fetch")
'BlackListForm = Array("@@")
'  Populate the error page you want to redirect to in case the 
'  check fails.

ErrorPage = "/protected.asp"
               
'''''''''''''''''''''''''''''''''''''''''''''''''''               
'  This function does not check for encoded characters
'  since we do not know the form of encoding your application
'  uses. Add the appropriate logic to deal with encoded characters
'  in here 
'''''''''''''''''''''''''''''''''''''''''''''''''''
Function CheckStringForSQL(str) 
  On Error Resume Next 
  
  Dim lstr 
  
  ' If the string is empty, return true
  If ( IsEmpty(str) ) Then
    CheckStringForSQL = false
    Exit Function
  ElseIf ( StrComp(str, "") = 0 ) Then
    CheckStringForSQL = false
    Exit Function
  End If
  
  lstr = LCase(str)
  
  ' Check if the string contains any patterns in our
  ' black list
  For Each s in BlackList
  
    If ( InStr (lstr, s) <> 0 ) Then
	
	Session("protected") = str
      CheckStringForSQL = true
      Exit Function
    End If
  
  Next
  
  CheckStringForSQL = false
  
End Function




 Function CheckFormForSQL(str) 
  On Error Resume Next 
  
  Dim lstr 
  
  ' If the string is empty, return true
  If ( IsEmpty(str) ) Then
    CheckFormForSQL = false
    Exit Function
  ElseIf ( StrComp(str, "") = 0 ) Then
    CheckFormForSQL = false
    Exit Function
  End If
  
  lstr = LCase(str)
  
  ' Check if the string contains any patterns in our
  ' black list
  For Each s in BlackListForm
  
    If ( InStr (lstr, s) <> 0 ) Then
	
	Session("protected") = str
      CheckFormForSQL = true
      Exit Function
    End If
  
  Next
  
  CheckFormForSQL = false
  
End Function 


'''''''''''''''''''''''''''''''''''''''''''''''''''
'   Check forms data
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each s in Request.Form
  If ( CheckFormForSQL(Request.Form(s)) ) Then
  
   
   Response.Redirect(ErrorPage)
  
  End If
Next

'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check query string
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each s in Request.QueryString
  If ( CheckStringForSQL(Request.QueryString(s)) ) Then
  
    ' Redirect to error page
    Response.Redirect(ErrorPage)

    End If
  
Next


'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Check cookies
'''''''''''''''''''''''''''''''''''''''''''''''''''

For Each s in Request.Cookies
  If ( CheckStringForSQL(Request.Cookies(s)) ) Then
  
    ' Redirect to error page
    Response.Redirect(ErrorPage)

  End If
  
Next

'''''''''''''''''''''''''''''''''''''''''''''''''''
'  Add additional checks for input that your application
'  uses. (for example various request headers your app 
'  might use)
'''''''''''''''''''''''''''''''''''''''''''''''''''

If CheckStringForSQL(Request.ServerVariables("Referer")) Or CheckStringForSQL(Request.ServerVariables("User-Agent")) Then
	Response.Redirect(ErrorPage) 
End If


%>