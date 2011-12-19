<!--#include file="config.asp"-->

<%	
session("pagetype") = "search"
    Header 
    ProcessLayout GetURL(templatelocation  & "searchheader.html")
	    If  Lcase(Request.QueryString("SearchString")) = "" Then
		    SsearchString = Lcase(Request.Form("SearchString"))
		Else
		    SsearchString = Lcase(Request.QueryString("SearchString"))
		End if
	Print("<div class=""searchresult"">" & SysLang("Searchresult") & ": " & Request.QueryString("SearchString") & "</div>")
    	 '   If SsearchString  = ""  Then 
		    '    Print("<div class=""search"">עליך לפרט מחרוזת חיפוש!</div>")
		     '   ProcessLayout GetURL(templatelocation  & "searchfooter.html")
             '   bottom
              '  Response.end
           ' End if
%>
<div id="site_map">
<ul>
<% 
If Request.querystring("categoryID") <> "" Then
buildsearchtree Request.querystring("categoryID")
Else
buildsearchtree 0
End if


Function buildsearchtree(id)
If Request.querystring("categoryID") <> "" Then
  SQL = "SELECT  [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE  Contentfather.FatherID=" & id & " AND Content.SiteID=" & SiteID & " AND ((Contenttype = 1) OR  (Contenttype = 2))"
Else
  SQL = "SELECT  * FROM [Content]  WHERE   Content.SiteID=" & SiteID & " AND ((Contenttype = 1) OR  (Contenttype = 2))"
End if
    SQL = SQL & " AND (Name LIKE '%" & Replace(SsearchString,"'","") & "%' OR Text LIKE '%" & Replace(SsearchString,"'","") & "%')"
   
   If Request.querystring("other1")<> ""  Then
    SQL = SQL & " AND other1 LIKE '%" & Request.Querystring("other1") & "%'"
   ' print sql2
   End if
    SQL = SQL & " AND LangID LIKE '%" & Session("SiteLang") & "%'" 
    SQL = SQL & " AND Menuislink = 1"
   SQL = SQL &  " ORDER By ItemOrder ASC"
  ' print sql
   Set objRs = OpenDB(SQL)
   If objRs.Recordcount = 0 Then
        Print Syslang("No records")
   Else
        Do while Not objRs.EOF
		    print vbCrLf & "  <li><a href="& Replace(objRs("urltext")," ","-") & ">" & objRs("Name") & "</a>"
   'SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRS("id") & ") AND Content.SiteID=" & SiteID & " AND ((Contenttype = 1) OR  (Contenttype = 2))  ORDER By ItemOrder ASC"
   'Set objRsSon = OpenDB(SQL2)
	'CloseDB(objRsSon)		
   objRs.MoveNext
	  Loop
print "</ul>" & vbCrLf
End If
	CloseDB(objRs)		
    End Function

%>
</div>
<% ProcessLayout GetURL(templatelocation  & "searchfooter.html")

bottom
%>
        </table>

