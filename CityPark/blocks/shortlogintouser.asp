<!--#include file="../config.asp"-->
<%
SetSession "BackURL","/user/"
If Request.Cookies(SiteID & "Loginname") = "" Then %>
שלום אורח, <a href="/user/login.asp?t=login">התחבר !</a>
<% Else %>
שלום <% = Request.Cookies(SiteID & "Loginname") %>, <a href="/user/login.asp?mode=logout">התנתק !</a>
<% End If %>