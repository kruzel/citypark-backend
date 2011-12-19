<!--#include file="config.asp"-->
<% response.ContentType="text/xml" %>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
 <%	 Set objRs = OpenDB("SELECT * FROM Content WHERE ID=" & GetConfig("HomePageID") & " AND SiteID = " & SiteID)%>
	<url>
		<loc>http://<% = Split(GetConfig("Domains"), ",")(0)%></loc>
		<priority>1.0</priority>
        <changefreq>daily</changefreq>
	</url>
        <%   CloseDB(objRs) %>
	
	<% Set objRs = OpenDB("SELECT * FROM Content WHERE showinsitemap=1 AND SiteID = " & SiteID & " ORDER BY priority DESC")	
	Do While Not objRs.EOF
	    If objRs("ID") <> GetConfig("HomePageID") Then
	    'domain= "http://" & Split(GetConfig("Domains"), ",")(0) & "/" & objRs("urlprefix") & Server.urlencode(Replace(objRs("urltext"), " ", "-"))
	   domain= "http://" & Split(GetConfig("Domains"), ",")(0) & "/" & objRs("urlprefix") & Replace(objRs("urltext"), " ", "-")
	%>
	<url>
		<loc><% = domain %></loc>
		<priority><% If objRs("priority") < 1 Then %>0<% End If %><% = objRs("priority") %><% If objRs("priority") > 0.9 Then %>.0<% End If %></priority>
        <changefreq>weekly</changefreq>
   </url>
	<%  End If
	    objRs.MoveNext 
			Loop
            CloseDB(objRs) %>



</urlset>
