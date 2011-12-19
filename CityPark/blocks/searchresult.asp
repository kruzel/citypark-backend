<!--#include file="../config.asp"-->
<%
TemplateURL = templatelocation  & "LastSearch.html"
value= Split(Request.Cookies(SiteID & "LastSearch1"), ",")
If Request.Cookies(SiteID & "LastSearch1") <> "" Then
%>
<h3>החיפוש האחרון שלי</h3>
	<div id="rb">
		<div id="rbtop"></div>
		<div id="rbmiddle">
<%
End If
Template = GetURL(TemplateURL)
			

For Index = 0 To 2

    if Index <= UBound(value) then
		SQL = "SELECT * FROM News WHERE other3 ='" & value(index) & "'"

	Set objRs = OpenDB(SQL)
    If index <> "" Then
        Template = Replace(Template, "[search" & (Index + 1) & "]","<li><a href=""hotels.asp?HotelID=" & value(index)  & """>" & objRs("newsheadline") & "</a></li>")
    End If
       closedb(objrs)
   else
        Template = Replace(Template, "[search" & (Index + 1) & "]", "")
      
    end if



Next			
					
				
			
	Response.Write Template
			print "</div>"
If Request.Cookies(SiteID & "LastSearch1") <> "" Then
 %>
    <div id="rbbottom"></div>
  </div>
  </div>
<% End If %>