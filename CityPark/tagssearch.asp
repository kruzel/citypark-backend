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
	
%>
<div id="site_map">
    <ul>
<% 
buildsearchtree 0
    Function buildsearchtree(id)
        SQL = "SELECT  * FROM [Content]  WHERE   Content.SiteID=" & SiteID & " AND ((Contenttype = 1) OR  (Contenttype = 2))"
        SQL = SQL & " AND (tags LIKE '%" & Replace(SsearchString,"'","") & "%')"
        SQL = SQL &  " ORDER By ItemOrder ASC"
            Set objRs = OpenDB(SQL)
                If objRs.Recordcount = 0 Then
                    Print Syslang("No records")
                Else
                    Do while Not objRs.EOF
		                print vbCrLf & "  <li><a href="& Replace(objRs("urltext")," ","-") & ">" & objRs("Name") & "</a>"
                    objRs.MoveNext
	                    Loop
                End If
	CloseDB(objRs)		
    End Function

%>
    </ul>
</div>
<% ProcessLayout GetURL(templatelocation  & "searchfooter.html")
bottom
%>

