<!--#include file="asp_twitter_lib.asp" -->
<%
Dim oTwitterAPI
set oTwitterAPI = new AspTwitterLib
	oTwitterAPI.aspTwitterLoginUser = "doobleweb"
	oTwitterAPI.aspTwitterLoginPass = "k161281"
	
		Dim arrTimeline,strTimelineError
		arrTimeline = oTwitterAPI.aspTwitterGetFriendsTimeline(5)
		if Len(oTwitterAPI.aspTwitterError) > 0 then
		strTimelineError =  "<p class=""error"">" & _ 
							  "Oops unabled fetching friends statuses : " & _
						      "<cite><small>" & oTwitterAPI.aspTwitterError & "<small></cite></p>"
		end if

			if Len(strTimelineError) > 0 then
				response.write	strTimelineError
			else
				if IsArray(arrTimeline) then
					%><ul><%
					Dim intCounter,strStyle
					intCounter = 0
					for each i in arrTimeline
						if isArray(i) then
							strStyle = ""
							if intCounter MOD 2 = 0 then strStyle = "alt"
							%><li class="<%=strStyle%>"><%=i(1)%><br /><small>
							<%if len(i(5)) > 0 then%><a href="http://twitter.com/<%=i(4)%>" rel="nofollow"><%=i(4)%></a><%end if%>
							posted at <%=i(0)%> from <%=i(2)%></small></li><%
							
							intCounter = intCounter + 1
						end if
					next
					%></ul><%
				Else
					response.Write "<p>Currently no status update</p>"
				End if
			end if
		%>
<% Set objUserDetail = Nothing:Set oTwitterAPI = Nothing %>