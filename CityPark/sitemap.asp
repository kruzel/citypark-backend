<!--#include file="config.asp"-->
<%	header	%>
<div id="site_map">
<ul>
<li><h1>מפת האתר</h1></li>
<li class="sitemapitem"><a href="/">עמוד הבית</a></li>
</ul>
<ul>
<%
Set objRsCategory = OpenDB("SELECT * FROM Category Where CategoryFatherName = 0 AND SiteID = " & SiteID & "  ORDER BY CategoryPosition")	
	Do While Not objRsCategory.EOF
%>
</ul><ul><li class="sitemapitem"><h2><% = objRsCategory("CategoryName") %></h2></li>
<%            Set objRs = OpenDB("SELECT * FROM News WHERE CategoryID = " & objRsCategory("CategoryID"))	
                Do While Not objRs.EOF 
                    If objRs("NewsID") <> GetConfig("WebPageID") then %>
<li class="sitemapitem"><a href="/<% = Replace(objRs("urltext")," ","-") %>"><% = objRs("NewsHeadline") %></a></li>
<%		     
                    End If
                  objRs.MoveNext 
			    Loop
                objRs.Close
                    Set objRsCategory2 = OpenDB("SELECT * FROM Category Where CategoryFatherName = " & objRsCategory("CategoryID")	& " AND SiteID = " & SiteID & "  ORDER BY CategoryPosition")
	                    Do While Not objRsCategory2.EOF
%>

</ul></ul><ul><li class="sitemapitem"><h3><% = objRsCategory2("CategoryName") %></h3></li>
<%
                    Set objRs = OpenDB("SELECT * FROM News WHERE CategoryID = " & objRsCategory2("CategoryID"))	
	                    Do While Not objRs.EOF	%>
<li class="sitemapitem"><a href="/<% = objRs("urlprefix") %><% = Replace(objRs("urltext")," ","-") %>"><% = objRs("NewsHeadline") %></a></li>
<%	                        objRs.MoveNext 
		                    Loop
                            objRs.Close
                            
                            objRsCategory2.MoveNext 
		                    Loop
                            objRsCategory2.Close
	
	    objRsCategory.MoveNext 
		Loop
		objRsCategory.Close
%>
</ul>
</div>
<%	bottom	%>