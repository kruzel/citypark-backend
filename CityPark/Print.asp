<!--#include file="config.asp"-->
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body onload="window.print();window.close();" dir="rtl"></body>
<%	

SQL = "SELECT * FROM [Content] WHERE "
SQL = SQL & "Id =" & Request.QueryString("ID")
SQL = SQL & " AND [Content].SiteId =" & SiteID

Set objRs = OpenDB(SQL)

			If objRs.RecordCount = 0 Then
				header
				Response.Write("<div id=""errormeseage"">כנראה נפלה טעות בכתובת חזור לעמוד הבית נסה שנית!</div>")
				bottom
				response.end
			End If

			If objRs("Active") = 0 Then
				header
				Response.Write("<div id=""errormeseage"">העמוד אינו פעיל יש לפנות למנהל האתר!</div>")
				bottom
				response.end
			End If

			CheckUserSecurity_Level objRs("UserLevel"),objRs("usersecuritytarget")

            If Request.QueryString("mode") = "image" Then
            field =  Request.QueryString("field")
                    print  "<img src=" & objRs(field) & " />"
            Else
                     print "<h2>" & objRs("Name") & "</h2><br /><br />"
                     print objRs("Text") 

            End If

            Print "<br /><div dir=""ltr"">http://" & Request.ServerVariables("server_name") & "/" & objRs("Urltext")& "</div>"
			CloseDB(objRs)
			
%>
</body>
</html>

