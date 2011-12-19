<!--#include file="../config.asp"-->
<div id="site_map">
<ul>
<% 
Function Langname(langID)
select case langID
case "en-US"
case "he-IL"
Langname= "He-עברית"
case "ru-RU"
Langname= "Rusian-Ru"
case "en-GB"
Langname= "English-Gb"
case "de-DE"
Langname= "Dautch-De"
End Select
Langname = "<img src=""/admin/flags/" & langID & ".png"" width=""20"" height=""13"" style=""float:none"" />"
End Function

buildtree 0

    Function buildtree(id)
   SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)  AND (Showinsitemap = 1) ORDER By ItemOrder ASC"
   Set objRs = OpenDB(SQL)
        Do while Not objRs.EOF
		    print vbCrLf & "  <li>" & Langname(objRs("LangID")) & " <a href="& Replace(objRs("urltext")," ","-") & ">" & objRs("Name") & "</a>"
         SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRS("id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1) AND (Showinsitemap = 1) ORDER By ItemOrder ASC"
   Set objRsSon = OpenDB(SQL2)
         If objRsSon.Recordcount > 0 Then
            print  vbCrLf & "    <ul>" 
                buildtree objRS("id")
            print "</li>" & vbCrLf
         Else
            print "</li>" & vbCrLf
         End If 
   objRs.MoveNext
	  Loop
print "</ul>" & vbCrLf
	CloseDB(objRsSon)		
	CloseDB(objRs)		
    End Function

%>
</div>