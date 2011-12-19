<!--#include file="config.asp"-->
<!--#include file="$db.asp"-->
<!--#include file="inc_top.asp"-->

<%
if lcase(Request.QueryString("Table"))= "" then
Table = "Users" 
else
table=lcase(Request.QueryString("Table"))
end if
	If Not Session(SiteID & "UserID") = "" Then 

	Set objRs = OpenDB("SELECT * FROM ControlPanel WHERE SiteID=" & SiteID)
%>
		<div align="center">
		<table bgcolor=<% = Application(ScriptName & "DefaultBGColor") %>
    		   	  background="<% = Application(ScriptName & "UploadPath") & "\" & Application(ScriptName & "DefaultBGImage") %>"
    	 		  height="200" 
				  width="<% = Application(ScriptName & "DefaultBGImageWidth") %>" 
				  border="0">
		<tr>
		<td>
		<div align="center">
		<table cellspacing="0" cellpadding="5" background="images/userpanel2.jpg" width="725" height="200"><tr><td valign="top">
			<font face="Arial">שלום <% = Session(SiteID & "LoginName")%> | <a href="@UserLogin.asp?mode=logout">
			<font color="#FF0000">התנתק</font></a></font></td></tr>

				<tr>	
		
		
			<% 
			Do While NOT objRs.EOF
			If Int(objRs("ControlPanel9Level")) >= Session(SiteID & "UserLevel") Then
			If I Mod 5 = 0 Then
			%>	
			<% End If%>
				<td>
					<table align="center">
						<tr>
							<td valign="top"><a href="<% = objRs("ControlPanellink") %>"><img border="0" src="<% = objRs("image") %>" /></a></td>
						</tr>
						
						<tr>
							<td align="center"><a href="<% = objRs("ControlPanellink") %>"><% = objRs("ControlPanelName") %></td>
						</tr>
					</table>
				</td>
				<%		
				I=i + 1
				End If
				objRs.MoveNext
				
			Loop
		%></tr>
		<tr>
			<td valign="top">
				</td>
			</td>
		</tr></table>
		</div>
		</td></tr>
</table>
</div>
<!--#include file="inc_bottom.asp"-->
<%	Else

		Response.Redirect("userlogin.asp?") & Request.QueryString
		
	End If
%>