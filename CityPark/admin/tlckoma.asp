<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<!--#include file="../inc_sendmail.asp"-->
<%
text2send= "<html xmlns=""http://www.w3.org/1999/xhtml"" xml:lang=""en"" lang=""en"">"
text2send = text2send & "<head>"
text2send = text2send & "<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />"
%>
<style>
.menus{
text-align:right;
line-height:25px;
background:#f5f5f5;
border-left:1px solid #ccc;
border-right:1px solid #ccc;
border-collapse:collapse;
clear:both;
}
.menus tr td{
border:1px solid #ccc;
text-align:right;
}
.menus tr th{
border-left:1px solid #ccc;
text-align:right;
}
.menusclassname{
background:#555;
color:#fff;
}
</style>
<%
text2send2 = text2send2 & "</head>"
text2send2 = text2send2 & "<body>"

Set objRs=Opendb("select * from tlchomes where tlchomesID =" & Request.querystring("Id"))
text2send2 = text2send2 & "<div class=""formtitle"">"
text2send2 = text2send2 & "<h1 style=""color:#fff;padding:0 10px 0 0;float:right;width:500px;"">דוח תפריטים " & objRs("tlchomesName")  & " לפי קומה</h1>"
text2send2 = text2send2 & "<p style=""float: left; font-weight: bold; height: 39px; line-height: 39px; width: 100px;""><a href=""#"" style=""font-size: 16px;"" onclick=""javascript:window.print();"">הדפס</a></p>"
text2send2 = text2send2 & "<table align=""right"" cellspacing=""0"" cellpadding=""5"" border=""0"" dir=""rtl"" width=""100%"" class=""menus"">"
text2send2 = text2send2 & "<tr style=""background:#ddd;""><th>מחלקה</th><th>יום ראשון</th><th>יום שני</th><th>יום שלישי</th><th>יום רביעי</th><th>יום חמישי</th></th></b>"

Set objRsmaj=Opendb("select * from tlcclass where tlchomesID =" & objRs("tlchomesID"))
Do while not objRsmaj.EOF

text2send2 = text2send2 & "<tr class=""menusclassname""><td colspan=""7""><b>" & objRsmaj("tlcclassname") & "</b></td></tr>"
Set objRsm=Opendb("select * from tlcmenus where tlchomesID =" & Request.querystring("Id") & " AND tlcclassID=" & objRsmaj("tlcclassID"))
	If objRsm.recordcount > 0 then
    
SQl = "Select * From tlcmeat where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                k = ""
                i = 1
                Do While NOT objRsm.EOF
                    if i < objRsm.recordcount then
                        k = k & objRsm("Name") & ","
                    Else
                        k = k & objRsm("Name") 
                    End if
                   objRsm.movenext
                   i=i+1
                        loop
                        CloseDB(objRsm)
j = "Sun Mon Thr Wed Thu"
For Each n in Split(k, ",")
	text2send2 = text2send2 & "<tr>"
	text2send2 = text2send2 & "<td>" & n & "</td>"
	
	For Each y in Split(j)
		Set objRstotal = OpenDB("SELECT COUNT(" & y & "Meat) AS count FROM [tlcmenus] Where tlchomesID=" & objRs("tlchomesID") & " AND tlcclassID=" & objRsmaj("tlcclassID")  &" AND " & y & "Meat = '" & n & "'")
		text2send2 = text2send2 & "<td>" & objRstotal("count") & "</td>"
		CloseDB(objRsTotal)	
	Next
	
	text2send2 = text2send2 & "</tr>"
Next
SQl = "Select * From tlcsoup where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                k = ""
                i = 1
                Do While NOT objRsm.EOF
                    if i < objRsm.recordcount then
                        k = k & objRsm("Name") & ","
                    Else
                        k = k & objRsm("Name") 
                    End if
                   objRsm.movenext
                   i=i+1
                        loop
                        CloseDB(objRsm)
j = "Sun Mon Thr Wed Thu"
For Each n in Split(k, ",")
	text2send2 = text2send2 & "<tr>"
	text2send2 = text2send2 & "<td>" & n & "</td>"
	
	For Each y in Split(j)
		Set objRstotal = OpenDB("SELECT COUNT(" & y & "Soup) AS count FROM [tlcmenus] Where tlchomesID=" & objRs("tlchomesID") & " AND tlcclassID=" & objRsmaj("tlcclassID") & " AND " & y & "Soup = '" & n & "'")
		text2send2 = text2send2 & "<td>" & objRstotal("count") & "</td>"
		CloseDB(objRsTotal)	
	Next
	
	text2send2 = text2send2 & "</tr>"
Next

    
    
    
    
    
	End if
objRsmaj.movenext
loop
text2send2 = text2send2 & "<tr class=""menusclassname""><td colspan=""7""><b></b></td></tr>"
text2send2 = text2send2 & "<tr class=""menusclassname""><td colspan=""7""><b>סיכום</b></td></tr>"
SQl = "Select * From tlcmeat where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                k = ""
                i = 1
                Do While NOT objRsm.EOF
                    if i < objRsm.recordcount then
                        k = k & objRsm("Name") & ","
                    Else
                        k = k & objRsm("Name") 
                    End if
                   objRsm.movenext
                   i=i+1
                        loop
                        CloseDB(objRsm)
j = "Sun Mon Thr Wed Thu"
For Each n in Split(k, ",")
	text2send2 = text2send2 & "<tr>"
	text2send2 = text2send2 & "<td>" & n & "</td>"
	
	For Each y in Split(j)
		Set objRstotal = OpenDB("SELECT COUNT(" & y & "Meat) AS count FROM [tlcmenus] Where tlchomesID=" & objRs("tlchomesID") & " AND " & y & "Meat = '" & n & "'")
		text2send2 = text2send2 & "<td>" & objRstotal("count") & "</td>"
		CloseDB(objRsTotal)	
	Next
	
	text2send2 = text2send2 & "</tr>"
Next
SQl = "Select * From tlcsoup where siteID=" & SiteID
                Set objRsm=OpenDB(SQl)
                k = ""
                i = 1
                Do While NOT objRsm.EOF
                    if i < objRsm.recordcount then
                        k = k & objRsm("Name") & ","
                    Else
                        k = k & objRsm("Name") 
                    End if
                   objRsm.movenext
                   i=i+1
                        loop
                        CloseDB(objRsm)
j = "Sun Mon Thr Wed Thu"
For Each n in Split(k, ",")
	text2send2 = text2send2 & "<tr>"
	text2send2 = text2send2 & "<td>" & n & "</td>"
	
	For Each y in Split(j)
		Set objRstotal = OpenDB("SELECT COUNT(" & y & "Soup) AS count FROM [tlcmenus] Where tlchomesID=" & objRs("tlchomesID") & " AND " & y & "Soup = '" & n & "'")
		text2send2 = text2send2 & "<td>" & objRstotal("count") & "</td>"
		CloseDB(objRsTotal)	
	Next
	
	text2send2 = text2send2 & "</tr>"
Next
	If request.querystring("mode") ="sendmail" then
		sendmail "דוח חלוקת מזון מחלקתי ל: " & objRs("tlchomesName"),"web@tl-care.co.il",objRs("ManagerMail"),text2send2 
		print "אימייל נשלח בהצלחה ל" & objRs("ManagerMail") & "<br/ >"
		'text2send2 = ""
	End if

If request.querystring("mode") <> "sendmail" then print text2send2
%>
</body>
</table> 
</div>
</html>