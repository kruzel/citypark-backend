<!--#include file="config.asp"-->

<%
	Countclick Request.QueryString("table"), GetSession( Request.querystring("id")), Request.querystring("field")
%>
