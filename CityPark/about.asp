<%
DDomain = LCase(Request.ServerVariables("HTTP_HOST"))	
		Response.Status="301 Moved Permanently"
		Response.AddHeader "Location", "http://." & DDomain 
		response.Redirect "http://" & DDomain
%>



