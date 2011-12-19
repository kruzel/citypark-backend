<div id="search">
<form action="../search.asp" method="get">
<input type="hidden" value="<% = Request.QueryString("S") %>" name="S" />
<input type=hidden value="doit" name="mode">	
<input type="text" name="SearchString" <% if Application(ScriptName & "SiteLang") = 1 Then %>												dir=rtl
<% Else %>
<% end if %> size="10">
<input type="submit" value="חפש" name="searchbtn" value="<% = Application("langsearch")%>">
</form>
</div>