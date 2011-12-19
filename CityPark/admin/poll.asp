<!--#include file="../config.asp"-->
	<!--#include file="inc_admin_icons.asp"-->

<%
CheckSecuirty "BlockPoll"

If Request("mode") = "add" Or Request("mode") = "edit" Then
If InStr(Request.QueryString, "submit") > 0 Then

	If Request("mode") = "add" Then
	
	sql = "INSERT INTO [BlockPoll] (BlockPollQuestion, urlaftervote, IsVoteAllowed, IsActive, SiteID) VALUES ('" & Request.Form("PollQuestion") & "', '" & Request.Form("urlaftervote") & "', " & Request.Form("VoteAllowed") & ", 0, " & SiteID & ")"
print sql	
	ExecuteRS sql
	Set RS = OPENDB("SELECT BlockPollID From BlockPoll Order By BlockPollID asc")
	Rs.Movelast
	ID = Rs("BlockPollID")
	CloseDb(rs)
	
		For Each x In Request.Form
			If Mid(x, 1, Len("Answer_Question")) = "Answer_Question" Then
				Answer = Request.Form(x)
				sql = "INSERT INTO BlockPollAnswer (BlockPollAnswerName, BlockPollID, BlockPollAnswerVotes) VALUES ('" & Answer & "', " & ID & ", 0);"		
				executers sql
			End If
		Next		

	Response.Redirect ("poll.asp")
	
	ElseIf Request("mode") = "edit" Then
		sql = "DELETE FROM BlockPollAnswer WHERE BlockPollID = " & Request.QueryString("poll_id")
		executers sql
		
		sql = "Update BlockPoll Set BlockPollQuestion = '" & Request.Form("PollQuestion") & "' Where BlockPollID = " & Request.QueryString("poll_id")
		executers sql
		sql2 = "Update BlockPoll Set urlaftervote = '" & Request.Form("urlaftervote") & "' Where BlockPollID = " & Request.QueryString("poll_id")
		executers sql2
		For Each x In Request.Form
			If Mid(x, 1, Len("Answer_Question")) = "Answer_Question" Then
				Answer = Request.Form(x)
				Votes = Request.Form(Replace(x, "Answer_Question", "Answer_Votes"))

				sql = "INSERT INTO BlockPollAnswer (BlockPollAnswerName, BlockPollID, BlockPollAnswerVotes) VALUES ('" & Answer & "', " & Request.QueryString("poll_id") & ", " 
				If IsNull(Votes) Or Votes = "" Then
					Sql = Sql & "0"
				Else
					Sql = sql & Votes
				End If
				
				sql = sql & " );"	
				print sql	
				executers sql
			End If
		Next		
	End If 
	
	Response.Redirect ("poll.asp")

End If

if request("mode") = "edit" then
Set objRsSelected = OpenDB("SELECT * FROM BlockPoll WHERE BlockPollID = " & Request.QueryString("poll_id"))
Set objRsAnswerSelected = OpenDB("SELECT * FROM BlockPollAnswer WHERE BlockPollID = " & Request.QueryString("poll_id"))
end if
%>
	<form action="poll.asp?mode=<% = Request("mode") %>&poll_id=<% = Request.QueryString("poll_id") %>&submit" method="post">
	<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td width="0">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp;הוספת סקר</font></b></td>
				</tr></table>
	    <table border="0" width="100%" cellspacing="0" cellpadding="4">
	      	
	<tr>
		<th align="right"> <font face="Arial" size="2">שאלת הסקר:</font></th>
		<td align="right"><font face="Arial"><input type="text" size="60" name="PollQuestion" <% If Request("mode") = "edit" Then %>value="<% = objRsSelected("BlockPollQuestion") %>"<% End If %>/></font></td>
	</tr>
	<tr>
		<th align="right"> <font face="Arial" size="2">URL אחרי ההפנייה:</font></th>
		<td align="right"><font face="Arial"><input type="text" size="60" name="urlaftervote" <% If Request("mode") = "edit" Then %>value="<% = objRsSelected("urlaftervote") %>"<% End If %>/></font></td>
	</tr>
	
	<tr>
		<th align="right"><font face="Arial" size="2">האם ניתן להצביע:</font></th>
		<td align="right">
			<font face="Arial">
			<select name="VoteAllowed">
					<option value="1"<% If Request("mode") = "edit" Then %><% If objRsSelected("IsVoteAllowed") = "True" Then %> selected<% End If %><% End If %>>כן</option>
					<option value="0"<% If Request("mode") = "edit" Then %><% If objRsSelected("IsVoteAllowed") = "False" Then %> selected<% End If %><% End If %>>לא</option>
			</select><font size="2"> </font></font>
		</td>
	</tr>

	<tr>
		<td colspan="2">
						<font face="Arial" size="2">
						<script type="text/javascript">
					var i = 0;
	
	function AddAnswer(question, answer) {
					
		var row = document.createElement("tr");
		var td1 = document.createElement("td")
		var Answer_Question_Control = document.createElement("input");
		Answer_Question_Control.type = "text";
		Answer_Question_Control.name = "Answer_Question" + i;
		if (question != null)
		Answer_Question_Control.value = question;
    	td1.appendChild(Answer_Question_Control)
		row.appendChild(td1);
		
		var td2 = document.createElement("td")
		var Answer_Votes_Control = document.createElement("input");
		Answer_Votes_Control.type = "text";
		Answer_Votes_Control.size = 5;
		Answer_Votes_Control.name = "Answer_Votes" + i;
				if (answer!= null)
		Answer_Votes_Control.value = answer;

    	td2.appendChild(Answer_Votes_Control)
		row.appendChild(td2);

		var td4 = document.createElement("td")
		var RemoveB = document.createElement("input");
		RemoveB.type = "button";
		RemoveB.value = "מחק";
		RemoveB.onclick = function() {
			RemoveAnswer(row);
		}
    	td4.appendChild(RemoveB)
		row.appendChild(td4);	
		
		document.getElementById("Answers").getElementsByTagName("tbody")[0].appendChild(row);
		i++;
		}
	
	
	function RemoveAnswer(the_tr, btn) {
		var the_tbody = document.getElementById("Answers").getElementsByTagName("tbody")[0];
		the_tbody.removeChild(the_tr);
	}
</script>
						</font>
			<table id="Answers" width="171">
				<tbody id="aatbody">
				<tr>
					<th>
					<div align="right"><span lang="he">
						<font face="Arial" size="2">תשובה</font></span></th>
					<th>
					<div align="right"><font face="Arial" size="2">הצבעות</font></th>
				</tr>
				<tr>
					<th colspan="2">
					<div align="right"><font face="Arial" size="2">
						<a href="#" onclick="javscript:AddAnswer(null,null);" style="text-decoration: none">הוסף תשובה</a></font></th>
				</tr>
				<% If Request("mode") <> "edit" Then %>
					<script type="text/javascript">
					AddAnswer(null,null);
					</script>
				<% End If %>
				
				<% 
				If Request("mode") = "edit" Then
				%>
				
						<script type="text/javascript">

				<% Do Until objRsAnswerSelected.Eof %>
					AddAnswer('<% = objRsAnswerSelected("BlockPollAnswerName") %>', '<% = objRsAnswerSelected("BlockPollAnswerVotes") %>');
				<% 
				objRsAnswerSelected.MoveNext
				Loop 
				%>
				</script>
				<% 
				End If
				%>
				</tbody>
			</table>
		</td>
	</tr>
	
	<tr>
		<td align="left">
		<div align="right"><font face="Arial"><input type="submit" value="אישור"></font></td>
	</tr>
	
	</tbody>
</table>
		<font face="Arial" size="2">
</form>

<% 

ElseIf Request.QueryString("mode") = "change_active" Then

SQL = "UPDATE BlockPoll Set IsActive = 0 WHERE SiteID = " & SiteID
ExecuteRs SQL

SQL = "UPDATE BlockPoll Set IsActive = 1 WHERE BlockPollID=" & Request.QueryString("poll_id") & " AND SiteID = " & SiteID
ExecuteRs(SQL)

Response.Redirect ("poll.asp")

ElseIf Request.QueryString("mode") = "delete" Then
	PollID = Request.QueryString("poll_id")
	
		sql = "DELETE FROM BlockPollAnswer WHERE BlockPollID = " & PollID & "; DELETE FROM BlockPoll WHERE BlockPollID = " & PollID & ";"
	ExecuteRs sql	
	Response.Redirect ("poll.asp")
Else 

sql = "SELECT * FROM BlockPoll Where SiteID = " & SiteID
Set objRs = OpenDB(sql)
%>
</font>
<div align="center"><font face="Arial" size="2"><br />
	</font>
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr valign=top>
	   <td><table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp;ניהול סקרים</font></b></td>
				</tr></table>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="48">
<tr>
	<td bgcolor="#DDDDDD" height="22">
	<div align="right">
	<font face="Arial" size="2">שאלת הסקר (<a href="poll.asp?mode=add" style="text-decoration: none">הוסף סקר</a>)</font></td>
	<% If Request.QueryString = "-1" Then %><td bgcolor="#DDDDDD" height="22">
	<div align="right"><font face="Arial" size="2">פעיל</font></td><% End If %>
	<td bgcolor="#DDDDDD" height="22">
	<div align="right"><font face="Arial" size="2">פעיל</font></td>
	<td bgcolor="#DDDDDD" height="22">
	<div align="right"><font face="Arial" size="2">עריכה</font></td>
	<td bgcolor="#DDDDDD" height="22">
	<div align="right"><font face="Arial" size="2">מחיקה</font></td>
</tr>
<% Do Until objRs.Eof %>
	<tr>
		<td style="border-bottom: 1px dotted #dddddd;" align="right" height="22"><font face="Arial" size="2"><% = objRs("BlockPollQuestion") %></font></td>
		<td style="border-bottom: 1px dotted #dddddd;" align="right">
		<a href="poll.asp?mode=change_active&poll_id=<% = objRs("BlockPollID") %>&CurrentValue=<% = objRs("IsActive") %>" style="text-decoration: none">
		<font face="Arial" size="2"><% = objRs("IsActive") %></font></a></td>
			<td style="border-bottom: 1px dotted #dddddd;" align="right">
			<div align="right"><font face="Arial" size="2">
			<a href="poll.asp?mode=edit&poll_id=<% = objRs("BlockPollID") %>" style="text-decoration: none">עריכה</a></font></td>
			<td style="border-bottom: 1px dotted #dddddd;" align="right">
			<div align="right"><font face="Arial" size="2">
			<a href="poll.asp?mode=delete&poll_id=<% = objRs("BlockPollID") %>" style="text-decoration: none">מחיקה</a></font></td>
	</tr>
<% 
	objRs.MoveNext
Loop	
%>
</table>
<% End If %>