<!--#include file="../config.asp"-->
<!--#include file="inc_admin_icons.asp"-->


<% 
CheckSecuirty "quiz"

If Request.QueryString("mode") = "add_quiz" Then

If Request.Form("add_quiz") <> "" Then
	
		ExecuteRs "Insert Into [Quiz] (QuizName, QuizDescription, SiteID) Values ('" & Replace(Request.Form("QuizName"), "'", "") & "', '" & Request.Form("QuizDescription") & "', " & SiteID & ")"
	
	Set objRs = OpenDB("Select QuizID From [Quiz] Order By [Quiz].QuizID ASC")
	objRs.MoveLast
	
	QuizID = objRs("QuizID")
	
	CloseDb(objRs)
	
	For x = 1 To 25
		If Request.Form("Question_Name_" & x) = "" Then Exit For
			ExecuteRS "Insert Into [QuizQuestion] (QuizQuestionName, QuizID, IsValidationRequid, SiteID) Values ('" & Request.Form("Question_Name_" & x) & "', " & QuizID & ", 1, " & SiteID & ")"
		Set objRs = OpenDB("Select QuizQuestionID From [QuizQuestion] Order By QuizQuestionID ASC")
		objRs.MoveLast
		QuizQuestionID = objRs("QuizQuestionID")
		CloseDb(objRs)
		
		For y = 0 To 25
		
			If Request.Form("Question_Name_" & x & "_" & y) = "" Then Exit For
			
				ExecuteRs "Insert Into [QuizAnswer] (QuizAnswerName, QuizQuestionID, QuizAnswerVotes, SiteID) Values ('" & Replace(Request.Form("Question_Name_" & x & "_" & y), "'", "") & "', " & QuizQuestionID & ", 0, " & SiteID & ")"
				
		Next	
	Next

	Response.Write ("<h2>השאלון נוסף בהצלחה.</h2>")
Else
%>

<script type="text/javascript">
	var i = 0;
	
	function AddQuestion(t, i_i_i) {
		i_i_i++;
		x_x_x = 0;
		var b1 = document.createElement("tr");
		var b2 = document.createElement("td");
		var b3 = document.createElement("input");
		b3.size = "83";
		b3.type = "text";
		b3.name = "Question_Name_" + i_i_i;
		b2.appendChild(b3);
		var control1 = document.createElement("input");
		control1.type="button"
		control1.value = "הוסף תשובה";
		var x_x_x = 0;
		control1.onclick = function() {
			var a1 = document.createElement("table");
			var a5 = document.createElement("tbody");
			var a2 = document.createElement("tr");
			var a3 = document.createElement("td");
			var a4 = document.createElement("input");
			a4.type = "text";
			a4.size = 78;
			a4.name = "Question_Name_" + i_i_i + "_" + x_x_x;
			a4.style.marginRight = "20px";
			a3.appendChild(a4);
			a2.appendChild(a3);
			a5.appendChild(a2);
			a1.appendChild(a5);
			td2.appendChild(a1);
			x_x_x++;
		}
		b2.appendChild(control1);


		b1.appendChild(b2);
		t.appendChild(b1);
		
		var row2 = document.createElement("tr");
		var td2 = document.createElement("td");

		row2.appendChild(td2);
		
		t.appendChild(row2);
		
		i++;
	}
</script>


<form action="quiz.asp?q=<% = Request.QueryString %>&mode=add_quiz" method="post">
	<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td width="0">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font face="Arial" size="2" color="#FFFFFF">&nbsp;<span lang="he">הוספת</span>
	<span lang="he">שאלון</span></font></b></td>
				</tr></table>	    <table align="right" border="0" width="100%" cellspacing="0" cellpadding="4">
	      		
	      <tr>
			<td width="17%">
			<div align="right"><font face="Arial" size="2">שם השאלון:</font></th>
			<td width="81%">
			<div align="right"><font face="Arial">
				<input size="50" name="QuizName" style="text-decoration: underline" /></font></td>
		</tr>
		
		<tr>
			<td valign="top" width="17%">
			<div align="right"><font face="Arial" size="2">תאור:</font></th>
			<td width="81%">
			<font face="Arial" size="2">
			
			<%
				Dim oFCKeditor
				Set oFCKeditor = New FCKeditor
				oFCKeditor.ToolbarSet = "Basic"
				oFCKeditor.BasePath = "FCKeditor/"
				oFCKeditor.width="100%"
				oFCKeditor.height = "150"
				oFCKeditor.Create "QuizDescription"
			%>
			
			</font>
			</td>
		</tr>
		
		<tr>
			<td width="17%">
			<div align="right"></td>
			<td width="81%">
			<div align="right"><font face="Arial">
				<input type="button" onclick="javascript:AddQuestion(document.getElementById('quiz_questions')	, i);" value="הוסף שאלה" style="text-decoration: underline" /></font></td>
			
		</tr>
		<tr>
			<td width="17%">
			<div align="right"></td>
			<td width="81%">
				<table>
					<tbody id="quiz_questions">
					
					</tbody>
				</table>			
			</td>
		</tr>
		
		<tr>
			<td colspan="2" bgcolor="#dddddd">
			<div align="center"><font face="Arial">
				<input type="submit" name="add_quiz" value="אישור" style="text-decoration: underline" /></font></td>
		</tr>
	</table>
		<font face="Arial" size="2">
		
</form>
<%
End If
ElseIf Request.QueryString("mode") = "show" Then
	Set objRsQuiz = OpenDB("Select * From [Quiz] Where QuizID = " & Request.QueryString("id"))
	Set objRsQuizQuestion = OpenDB("Select * From [QuizQuestion] Where QuizID = " & objRsQuiz(0))
%>
		
		</font>
		<div align="center"><font face="Arial" size="2"><br /><br />
			</font>
			
	<table width=700 border="0" dir=rtl cellspacing="0" cellpadding="0">
	  <tr valign=top>
	    <td>
	    <table align="right" class="Main" border="0" width="100%" cellspacing="0" cellpadding="4">
	      <tr>
		<td align="right" style="font-size: 20px; font-weight: bold;">
		<font face="Arial" size="2"><% = objRsQuiz(1) %></font></td>
	</tr>
	<tr>
		<td align="right"><font face="Arial" size="2"><% = objRsQuiz(2) %></font></td>
	</tr>
	<tr>
		<td align="right" style="height: 12px;"></td>
	</tr>
<% 
nRun = 1
Do Until objRsQuizQuestion.Eof 
Set os = OpenDB("SELECT Sum(QuizAnswerVotes) As TheSum From QuizAnswer Where QuizQuestionID = " & objRsQuizQuestion(0))
%>
<tr>
	<td align="right"><font face="Arial" size="2"><% = nRun %>. <% = objRsQuizQuestion(1) %> (<% = os("TheSum") %> הצבעות)</font></th>
	
</tr>
<tr>
	<td>
		<table align="right" style="margin-right: 15px;">
			<% 
				Set objRsQuizAnswer = OpenDB("Select * From [QuizAnswer] Where QuizQuestionID = " & objRsQuizQuestion(0))
				Do Until objRsQuizAnswer.Eof
			%>
					<tr>
							<td align="right"><font face="Arial" size="2"><% = objRsQuizAnswer(1) %> - 
							 
							</font> </td>
						<td>
						<div align="right"><font face="Arial" size="2"><% = objRsQuizAnswer("QuizAnswerVotes") %> הצבעות.</font></td>
					</tr>	
					
			<%
					objRsQuizAnswer.MoveNext
				Loop
			%>	
		</table>
	</td>
</tr>
<%
objRsQuizQuestion.MoveNext
nRun = nRun + 1
Loop
%>

<tr>
	<td align="left">
	<div align="right"><font face="Arial" size="2">
		<a href="<% = URLDecode(Request.QueryString("redirect")) %>" style="text-decoration: none">
		<font color="#000000">חזור</font></a></font></td>
</tr>
</table>

		<font face="Arial" size="2">

		

<%
ElseIf Request.QueryString("mode") = "delete" Then
	ExecuteRs "Delete From [Quiz] Where QuizID = " & Request.QueryString("id") 
	
	Set objRsQuestion = OpenDB("Select QuizQuestionID From [QuizQuestion] Where QuizID = " & Request.QueryString("id"))
	
	Do Until objRsQuestion.Eof
		ID = objRsQuestion(0)		
		ExecuteRs "Delete From [QuizQuestion] Where QuizQuestionID = " & ID
		ExecuteRs "Delete From [QuizAnswer] Where QuizQuestionID = " & ID
		objRsQuestion.MoveNext
	Loop
	
	Response.Redirect(URLDecode(Request.QueryString("redirect")))
Else

Set objRs = OpenDB("Select * From [Quiz] Where SiteID = " & SiteID) 
%>

<div align="center" style="margin-top:20px;">
	<table width=700 border="0" dir=rtl cellspacing="0" cellpadding="0">
	  <tr valign=top>
	    <td><table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp; ניהול שאלונים</font></b></td>
				</tr></table>
	    <table align="right" border="0" width="100%" cellspacing="0" cellpadding="4">
	      <tr>
		<td align="right" bgcolor="#DDDDDD" width="464"><font face="Arial" size="2">	
		<div align="right"></font><font color="#FFFFFF" face="Arial" size="2">
			<a href="quiz.asp?mode=add_quiz" style="text-decoration: none; font-weight:700">הוספת שאלון</a></font><font face="Arial" size="2"></th>
			
		<td align="right" bgcolor="#DDDDDD"><font face="Arial" size="2">
		<div align="right"><b><span lang="he">פעולות</span></b><td align="right" bgcolor="#DDDDDD"><font face="Arial" size="2">
		<div align="right">&nbsp;<td align="right" bgcolor="#DDDDDD"><font face="Arial" size="2">
		<div align="right">&nbsp;</tr>
	
	<% Do Until objRs.Eof %>
	
	<tr>
		<td style="border-bottom: 1px dotted #dddddd;" align="right" width="464"><font face="Arial" size="2"><% = objRs(1) %></font></td>
		<td style="border-bottom: 1px dotted #dddddd;" align="right">
		<div align="right"><font face="Arial" size="2">
			<a href="quiz.asp?mode=show&id=<% =objRs(0) %>&redirect=<% = Server.URLEncode("quiz.asp?" & Request.QueryString) %>" style="text-decoration: none">
			<font color="#000000">הצג</font></a></font></td>
			<td style="border-bottom: 1px dotted #dddddd;" align="right">
			<div align="right"><font face="Arial" size="2">
				<a href="quiz.asp?mode=delete&id=<% = objRs(0) %>&redirect=<% = Server.URLEncode("quiz.asp?" & Request.QueryString) %>" style="text-decoration: none">
				<font color="#000000">מחיקה</font></a></font></td>
		<td style="border-bottom: 1px dotted #dddddd;" align="right">
		<div align="right"><font face="Arial" size="2">
			<a href="admin_menu_add.asp?src=quiz.asp?q=<% = objRs(0) %>&HeadLine=<% = objRs(1) %>&S=<% = SiteID %>" style="text-decoration: none">
			<font color="#000000">צור</font></a></font></td>		
	
	</tr>
	
	<%
	objRs.MoveNext
	Loop%>
		<tr>
		<td colspan="4" bgcolor="#dddddd">&nbsp;</td>
	</tr> 
</table>

<% End If %></body></html>