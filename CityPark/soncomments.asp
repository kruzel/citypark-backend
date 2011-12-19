<!--#include file="config.asp"-->
<!--#include file="inc_sendmail.asp"-->
<SCRIPT LANGUAGE="JavaScript">
 
function textCounter(field, countfield, maxlimit) {
if (field.value.length > maxlimit) // if too long...trim it!
field.value = field.value.substring(0, maxlimit);
// otherwise, update 'characters left' counter
else 
countfield.value = maxlimit - field.value.length;
}
</script>

<script language="javascript" type="text/javascript">
// <!CDATA[

function newrecord_onclick() {

}

// ]]>
</script>


<% 	maxchars = 500
	if 	Request.Cookies(SiteID & "UserLevel") = "" then
	 	UserLevel = 9
	else
		UserLevel = Cint(Request.Cookies(SiteID & "UserLevel"))
	end if
	
		AllowCommentText = false ' האם רשאי להגיב
				if Cint(getconfig("comments9Level")) = 9 OR UserLevel  <= Cint(getconfig("comments9Level")) Then 
		AllowComment = true
			end if
			
If Lcase(Request.Querystring("ID")) = "" Then

	    SQL = "SELECT Id,urltext FROM Content WHERE ID='" & session(siteID & "Sonid") & "' And SiteID=" & SiteID
		'	print sql
        Set objRs = OpenDB(SQL)
		UrlID =  objRs("Id")
		CloseDB(objRs)

	
Else 
	UrlID = Request.QueryString("ID")
End If




If Request.QueryString("mode") = "add" Then
Father = Request.QueryString("father")
ContentId = Request.QueryString("ID")
AuthorName =  stripHtml(Request.Form("Name"))
Name =  Replace(stripHtml(Request.Form("Title")), """", "'")
Email =  stripHtml(Request.Form("Email"))
Text = stripHtml(Replace(Request.Form("Content"), "'", ""))
	if getconfig("AutoInsertComments") = 1 then 'האם להציג את ההודעה באתר או להמתין לאישור
			SQL = "Insert Into Response (Name, Text, Email, ContentId, Father, AuthorName, Date, SiteID, active) Values ('" & Name & "', '" & Text & "', '" & Email & "', " & ContentId & ", " & Father & ", '" & AuthorName & "', GetDate(), " & SiteID & ",1);"
	else
			SQL = "Insert Into Response (Name, Text, Email, ContentId, Father, AuthorName, Date, SiteID) Values ('" & Name & "', '" & Text & "', '" & Email & "', " & ContentId & ", " & Father & ", '" & AuthorName & "', GetDate(), " & SiteID & ");"
	end if
If 	Name <> "" AND AuthorName <> "" Then
	ExecuteRs(SQL)
	
    	deletecache "all"

	if getconfig("commentsemail") <> "" then 'האם לשלוח איממיל לאישור
		if Cint(getconfig("AutoInsertComments")) = 0 then ' שולח איממיל מותאם אישית
				Sendmail "תגובה נוספה באתרך", "mailer@dooble.co.il", getconfig("commentsemail"), "תגובה נוספה בהצלחה ומחכה לאישורך."
		else	
				Sendmail "תגובה נוספה באתרך", "mailer@dooble.co.il", getconfig("commentsemail"), "תגובה נוספה בהצלחה."
		end if
	end if
end if
Response.Redirect Request.QueryString("redirect")

Else
		
 			TotalRecords = ExecuteFunction("Select Count(*) As A From Response Where Active = 1 And ContentId = " & UrlID & " And SiteID = " & SiteID)
 			TotalRecords2 = ExecuteFunction("Select Count(*) As A From Response Where Active = 1 And ContentId = " & UrlID & " And SiteID = " & SiteID & " And Father = 0")

 		Sub PrintResponses(Father, Level)
 		sql = "Select * From Response Where ContentId = " & UrlID & " And Father = " & Father & " And Active = 1"

 		If Int(Request.QueryString("order")) = 0 Then
			Sql = Sql & " Order by Id DESC"
		ElseIf Int(Request.QueryString("order")) = 1 Then
			Sql = Sql & " Order by Id ASC"
		End If	

		Set objRsResponse = OpenDB(Sql)
 		
 		If objRsResponse.RecordCount > 0 Then

				Do Until objRsResponse.Eof
	 			%>
					<div id="comments_container">
					<tr>
						<td class="response_t_" id="response_t_<% = objRsResponse(0) %>">	<div class="response_b_" id="response_b_<% = objRsResponse(0) %>"><% If Father = 0 Then %><% = I %>.<% End If %></div></td>
						
						<td class="response_x_" id="response_x_<% = objRsResponse(0) %>">
							<div style="<% If Level > 1 Then %>margin-right: <% = level * 10 %>px;<% End If %>">	
								<% 
								If Father > 0 Then 
									Print("<font size=""2"" color=""#f97c00"">&#9668;</font>") 
								End If 
								%>
									<a id="response_a_<% = objRsResponse(0) %>" style="color: #000000; text-decoration: none;" href="javascript:toggle('response_<% = objRsResponse(0) %>', 'response_t_<% = objRsResponse(0) %>', 'response_x_<% = objRsResponse(0) %>', 'response_a_<% = objRsResponse(0) %>', 'response_b_<% = objRsResponse(0) %>')"><% = Replace (objRsResponse(1), """", "'") %></a>
									<div style="color: #666666; font-size:12px; "><% = objRsResponse("AuthorName") %> (<% = Split(FormatDateTime(objRsResponse("Date"),vbgeneraldate), " ")(0) %>)</div>
							
									<div style="width: 300px; display: none; background-color: #F1F5FA;" id="response_<% = objRsResponse(0) %>">
								<% = objRsResponse(2) %>
								<br>
								<div>
								<% 	 if AllowComment = true Then %>
								<a href="javascript:normalToggle('NewPost_<% = objRsResponse(0) %>')"><% = Syslang("New comment") %></a> | 	<a href="javascript:normalToggle('PostPost_<% = objRsResponse(0) %>')"><% = Syslang("Comment to comment") %></a>
								<% end if %>
								<div id="NewPost_<% = objRsResponse(0) %>" style="display: none;">
									<form name="sendcomment" id="sendcomment" onsubmit="return validate_form(this)" method="post" action="soncomments.asp?mode=add&father=0&ID=<% = UrlID %>&redirect=<% = Server.URLEncode(URL) %>">
									<INPUT type="hidden" id="Hidden1" name="IsPostback" value="true">
                                    <table class="To_Post_New">
										<tr>
											<th align="right"><%=Syslang("Name") %>:</th>
											<td align="right"><input type="text" name="Name" size="35" /></td>
										</tr>
										
										<tr>
											<th align="right"><%=Syslang("Title") %>:</th>
											<td align="right"><input type="text" name="Title" size="35" /></td>
										</tr>
										
										<tr>
											<th align="right"><%=Syslang("Email") %>:</th>
											<td align="right"><input type="text" name="Email" size="35" /></td>
										</tr>
										
										
										<tr>
											<td colspan="2">
												<textarea class="NewPost_Regular" name="Content" rows="10" cols="32"></textarea>
											</td>
										</tr>
										
										<% if Application(ScriptName & "EnableAgreeInComments") = 1 Or Application(ScriptName & "showAgreeInComments1") = 1 then %>
										<tr>
											<td>
											<% if Application(ScriptName & "EnableAgreeInComments") = 1 Then%><input type="checkbox" id="Agree" name="Agree" /><% end If %>
											</td>
												<td>אני מצהיר/ה בזאת שהסכמתי
												<a target="_blank" href="<% = "sites/" & Application(ScriptName & "ScriptPath") & "/content/files/takanon.html" %>">לתקנון</a>.</td>
										</tr>
										<% End If %>


										<tr>
											<td colspan="2" align="left">
												<input type="submit" name="submit" value="<%=Syslang("Send") %>" />
											</td>
										</tr>
									</table>
								</form>
								</div>
								
								<div id="PostPost_<% = objRsResponse(0) %>" style="display: none;">
									<form onsubmit="return validate_form(this)" method="post" action="soncomments.asp?mode=add&father=<% = objRsResponse(0) %>&ID=<% = UrlID %>&redirect=<% = Server.URLEncode(URL) %>">
									<INPUT type="hidden" id="Hidden2" name="IsPostback" value="true">
                                    <table class="To_Post_Regular">
										<tr>
											<th align="right"><%=Syslang("Name") %>:</th>
											<td align="right"><input type="text" name="Name" size="35" /></td>
										</tr>
										
										<tr>
											<th align="right"><%=Syslang("Title") %>:</th>
											<td align="right"><input type="text" name="Title" size="35" /></td>
										</tr>
										
										<tr>
											<th align="right"><%=Syslang("Email") %>:</th>
											<td align="right"><input type="text" name="Email" size="35" /></td>
										</tr>
										<tr>
											<td colspan="2">
												<textarea class="NewPost_Regular" name="Content" rows="10" cols="32"></textarea>
											</td>
										</tr>
										<% if Application(ScriptName & "EnableAgreeInComments") = 1 OR Application(ScriptName & "ShowAgreeInComments1") = 1 then %>
										<tr>
											<td><% if Application(ScriptName & "EnableAgreeInComments") = 1 then %><input type="checkbox" id="Agree" name="Agree" /><% end If %>
											</td>
												<td>אני מצהיר/ה בזאת שהסכמתי
												<a target="_blank" href="<% = "sites/" & Application(ScriptName & "ScriptPath") & "/content/files/takanon.html" %>">לתקנון</a>.</td>
										</tr>
										<% End If %>

										<tr>
											<td colspan="2" align="left">
												<input type="submit" name="submit" value="<%=Syslang("Send") %>" />
											</td>
										</tr>
									</table>
								</form>
								</div>	
							</div>
						</td>
					</tr>
					
					<tr>
						<td style="height: 10px;" colspan="2"></td>
					</tr>
	
	
	 				<%
	 				PrintResponses objRsResponse(0), Level + 1
	 				objRsResponse.MoveNext
	 				
	 				If Father = 0 Then
	 					If Int(Request.QueryString("order")) = 0 Then
							I = I - 1
						ElseIf Int(Request.QueryString("order")) = 1 Then
							I = I + 1
						End If	
					End If 
					
	 			Loop
	 			objRsResponse.Close
 			End If
 				 			
 		End Sub

%>		<script type="text/javascript">
			var isToggled = false;
			
			function toggleAll(text_obj){
				<%
					Sub PR(Father)
					 		sql = "Select * From Response Where ContentId = " & UrlID & " And Father = " & Father & " And Active = 1"
	
	 					If Int(Request.QueryString("order")) = 0 Then
							Sql = Sql & " Order by Id DESC"
						ElseIf Int(Request.QueryString("order")) = 1 Then
							Sql = Sql & " Order by Id ASC"		
						End If	
	
						Set objRsResponse2 = OpenDB(Sql)

						Do Until objRsResponse2.Eof
							%>
					toggle('response_<% = objRsResponse2(0) %>', 'response_t_<% = objRsResponse2(0) %>', 'response_x_<% = objRsResponse2(0) %>', 'response_a_<% = objRsResponse2(0) %>', 'response_b_<% = objRsResponse2(0) %>');
							<%
							
							Pr objRsResponse2(0)
							objRsResponse2.MoveNext
						Loop
					End Sub
					
					PR 0
				%>
				
				isToggled = !isToggled;	
				if (!isToggled) {
					document.getElementById(text_obj).innerHTML = "פתיחת כל התגובות";
				}
				else {
					document.getElementById(text_obj).innerHTML = "סגירת כל התגובות";
				}

	 		}
			
			function toggle(object_name, object2_name, object3_name, object4_name, object5_name) {
				if (document.getElementById(object_name).style.display == "none"){
					document.getElementById(object_name).style.display = "block";
					document.getElementById(object2_name).style.backgroundColor = "#F1F5FA";
					document.getElementById(object3_name).style.backgroundColor = "#F1F5FA";
					document.getElementById(object4_name).style.fontWeight = "bold";
					document.getElementById(object5_name).style.fontWeight = "bold";
				} else { 
					document.getElementById(object_name).style.display = "none";
					document.getElementById(object2_name).style.backgroundColor = "";
					document.getElementById(object3_name).style.backgroundColor = "";
					document.getElementById(object4_name).style.fontWeight = "";
					document.getElementById(object5_name).style.fontWeight = "";
				}
			}

			function normalToggle(object_name) {
				if (document.getElementById(object_name).style.display == "none"){
					document.getElementById(object_name).style.display = "block";
				} else { 
					document.getElementById(object_name).style.display = "none";
				}
			}
			
			function validate_required(field,alerttxt)
			{
				with (field)
				{
					if (value==null||value=="")
  						{alert(alerttxt);return false;}
					else {return true}
				}
			}
			
			function validate_form(thisform)
			{
				with (thisform)
				{
  					if (!validate_required(Name,'<%=Syslang("Name is required") %>'))
  					{
  						Name.focus();
  						return false;
  					}
  					
  					if (!validate_required(Title,'<%=Syslang("Title is required") %>'))
  					{
  						Title.focus();
  						return false;
  					}
					
					if(Agree.checked == false)
					{ 
  						alert("יש לקרוא ולהסכים לתקנון.") 
   						Agree.focus();
   						return false; 
   					}
   				}
   				<% If Int(GetConfig("AutoInsertComments")) <> 1 Then %>
   				alert("קיבלנו את תגובתך ונשתדל לפרסמה, בכפוף לשיקולי המערכת.");
   				<% End If %>
   				return true;
			}

		</script>
		<div>
		<div class="commendsheader">
		<% if AllowComment = true Then %>
		<a href="javascript:normalToggle('NewPost_Regular')"><% = Syslang("Add comment") %></a>
		<% end If %>
		 <% = Syslang("There is") %>&nbsp;<%=Cint(TotalRecords)%>&nbsp;<% = Syslang("comments") %>
		  </div>
		
		<div id="NewPost_Regular" style="display: none;">
       <%  If UrlID ="" then %>
				<form onsubmit="return validate_form(this)" method="post" action="soncomments.asp?mode=add&father=0&ID=<% = Request.querystring("ID") %>&redirect=<% = Server.URLEncode(URL) %>" style="margin:0;padding:0;float:right;">
	    <% Else %>
				<form onsubmit="return validate_form(this)" method="post" action="soncomments.asp?mode=add&father=0&ID=<% = UrlID %>&redirect=<% = Server.URLEncode(URL) %>" style="margin:0;padding:0;float:right;">
         <% End If %>	
    		<INPUT type="hidden" id="Hidden3" name="IsPostback" value="true">
                <table class="NewPost_Regular">
					<tr>
						<th class="NewPost_Regular" align="right"> <% = Syslang("Name") %>:</th>
						<td align="right"><input type="text" name="Name" size="35" /></td>
					</tr>
										
					<tr>
					<th align="right"> <% = Syslang("Title") %>:</th>
											<td align="right"><input type="text" name="Title" size="35" /></td>
										</tr>
										
										<tr>
											<th align="right"> <% = Syslang("Email") %>:</th>
											<td align="right"><input type="text" name="Email" size="35" /></td>
										</tr>
										
										
										<tr>
											<td colspan="2">
												<textarea class="NewPost_Regular" name="Content" rows="10" cols="32" onKeyDown="textCounter(this.form.Content,this.form.remLen,<% = maxchars %>);" onKeyUp="textCounter(this.form.Content,this.form.remLen,<% = maxchars %>);"></textarea>
											 <input readonly type=text name=remLen size=1 maxlength=3 value="<% = maxchars %>">(<% = maxchars %>)</font>

											</td>
										</tr>
										<% if Application(ScriptName & "EnableAgreeInComments") = 1 Or Application(ScriptName & "showAgreeInComments1") = 1 then %>
										<tr>
											<td><% if Application(ScriptName & "EnableAgreeInComments") = 1 Then %><input type="checkbox" id="Agree" name="Agree" /><% end If %>
											</td>
												<td>אני מצהיר/ה בזאת שהסכמתי
												<a target="_blank" href="<% = "sites/" & Application(ScriptName & "ScriptPath") & "/content/takanon.html" %>">לתקנון</a>.</td>
										</tr>
										<% End If %>
										<tr>
											<td colspan="2" align="left">
												<input type="submit" name="submit" value=" <% = Syslang("Send") %>" />
											</td>
										</tr>
									</table>
								</form>
								</div>
 		<table id="comments_container" cellspacing="0" align="right">
 		<div id="comments_menu">
 			<a href="<% = Request.ServerVariables("URL") %>?id=<% = UrlID %>&s=<% = siteid %>&order=0"><% = Syslang("Last comment First") %></a> | 
 			<a href="<% = Request.ServerVariables("URL") %>?id=<% = UrlID %>&s=<% = siteid %>&order=1"><% = Syslang("First comment First") %></a> |
 			<a id="toggle" href="javascript:toggleAll('toggle');"><% = Syslang("Open all coments") %></a> 
 		</div>
 		
 		<div style="height: 10px" />
 		<%
 		If Int(Request.QueryString("order")) = 0 Then
			I = TotalRecords2
		ElseIf Int(Request.QueryString("order")) = 1 Then
			I = 1
		End If	
 		PrintResponses 0, 0
 				
 		%>
 	</table>
 	</div>

<%
End If
%>