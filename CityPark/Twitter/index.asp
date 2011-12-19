<!--#include file="asp_twitter_lib.asp" -->
<%
Dim oTwitterAPI
set oTwitterAPI = new AspTwitterLib
	oTwitterAPI.aspTwitterLoginUser = "doobleweb"
	oTwitterAPI.aspTwitterLoginPass = "k161281"
	
Dim objUserDetail,strUserDetailError
Set objUserDetail = oTwitterAPI.aspTwitterUserDetail()
	if Len(oTwitterAPI.aspTwitterError) > 0 then
		strUserDetailError =  "<p class=""error"">" & _ 
							  "Oops error fetching user detail : " & _
						      "<cite><small>" & oTwitterAPI.aspTwitterError & "<small></cite></p>"
	else
		Dim arrTimeline,strTimelineError
		arrTimeline = oTwitterAPI.aspTwitterGetUserTimeline()
		if Len(oTwitterAPI.aspTwitterError) > 0 then
		strTimelineError =  "<p class=""error"">" & _ 
							  "Oops unabled fetching user statuses : " & _
						      "<cite><small>" & oTwitterAPI.aspTwitterError & "<small></cite></p>"
		end if
	end if
%>
<html>
	<head>
	 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

		<title>Classic ASP Twitter API</title>
		<style type="text/css">
			* { padding:0; margin:0; }
			body { padding:25px; margin:0; background:#f5f5f5; color:#666; font-family:arial; font-size:20px; text-align:center; }
			#wrap { text-align:left; background:#fff; width:600px; margin:0px auto; }
			#twitter { padding-bottom:20px; }
			h1 { font-size:30px; letter-spacing:-2px; padding:20px; }
			ul {}
			ul li { border-top:solid 1px #f5f5f5; padding:10px 30px; list-style:none; display:block; }
			ul li.alt { background:#f6f9d0; }
			small { color:#999; font-size:14px; }
			a { color:#999; }
			#user { margin:20px 30px; width:100%; overflow:hidden; }
			#user img { border:solid 5px #ccc; float:left; margin:0px 10px 10px 0px; }
			#user ul li { border:none; }
			p.error { padding:0px 25px; }
			#twitter p.error cite { color:red!important; }
		</style>
	</head>
	<body>
		<div id="wrap">
		<div id="twitter">
		<h1>Classic ASP Twitter API</h1>
		<%
		if Len(strUserDetailError) > 0 then
			response.write strUserDetailError
		else
			%>
			<div id="user">
				<img src="<%= objUserDetail.Item("profile_image_url") %>" alt="" />
				<strong><%=objUserDetail.Item("name")%> (<%=objUserDetail.Item("screen_name")%>)</strong> in 
				<%=objUserDetail.Item("location")%><br />
				<small><a href="<%=objUserDetail.Item("url")%>" rel="nofollow" target="_blank"><%=objUserDetail.Item("url")%></a>
				<br /><%=objUserDetail.Item("description")%><br />
				Currently following <%=objUserDetail.Item("friends_count")%> peoples, 
				followed by <%=objUserDetail.Item("followers_count")%> peoples and 
				has <%=objUserDetail.Item("statuses_count")%> Statuses update</small>
				<br clear="all" />
			</div>
			<%
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
							%><li class="<%=strStyle%>"><%=i(1)%><br /><small>posted at <%=i(0)%> from <%=i(2)%></small></li><%
							intCounter = intCounter + 1
						end if
					next
					%></ul><%
				Else
					response.Write "<p>Currently "&objUserDetail.Item("name")&" has no status update</p>"
				End if
			end if
		end if
		%>
		</div>
		</div>
	</body>
</html>
<% Set objUserDetail = Nothing:Set oTwitterAPI = Nothing %>