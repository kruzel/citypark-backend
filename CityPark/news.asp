<% REsponse.ContentType = "text/xml" %>

<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<!--#include file="config.asp"-->

  <channel>
<title><%= Getconfig("webpagetitle")%></title>
<atom:link href="http://neguloza.co.il/feed/" rel="self" type="application/rss+xml" />
<link></link>
<description></description>
<language></language>
<copyright></copyright>

<%
CurrDate = Now()
%>
<lastBuildDate><%=CurrDateT%></lastBuildDate>

<%
SQL = "SELECT * FROM news Where SiteID = " & SiteID  & " ORDER BY NewsOrder DESC"
Set objRs = OpenDB(SQL)

do while not objRs.EOF 
	 
%>
<item>

<title>
<% = objRs("newsheadline") %>
</title>
<description>
	    <% =objRs("newstext") %>
</description>

<pubDate></pubDate>

</item>

<%
objRs.MoveNext
loop
CloseDB(objRs)
%>

</channel>
</rss>




