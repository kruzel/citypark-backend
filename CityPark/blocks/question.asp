<!--#include file="../config.asp"-->
<%
    If Request.QueryString("mode") = "vote" then
        Set objRscheck = OpenDB("SELECT * FROM nailsanswers Where id=" & Session(SiteID & "questionID"))	
	        If objRscheck.RecordCount > 0 Then
		        Print(SysLang("הצבעת כבר עבור שאלה זאת"))
		       CloseDB(objRscheck)
            Else
                Set objRs = OpenDB("SELECT * FROM nailsanswers")
                objRS.Addnew	
                objRs("questionID") = Session(SiteID & "questionID")
                objRs("userID") = Request.Cookies(SiteID & "UserID")
                print Request.form("answer")
                objRs("answer") = Request.form("answer")
                objRs("SiteID") = SiteID
                objRs.update
	                Response.Write("<br><br><p align='center'>תודה על הצבעתך. <a href='home.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
	                Response.Write("<meta http-equiv='Refresh' content='1; URL=home.asp?S=" & SiteID & "'>")
	            closeDB(objRs)
            End If
      Else
Set objRs = OpenDB("SELECT TOP 1 * FROM nailsquestion Where  active=1 AND SiteID = " & SiteID & "  ORDER BY id DESC")	
	If objRs.RecordCount = 0 Then
		Print(SysLang("אין שאלה פעילה"))
	Else
	setsession "questionID",objRs("id")
	

%>
<form action="question.asp?mode=vote" method="post">
<div class="question"><% print objRs("question") %></Div>
<div class="answer"><% print objRs("answer1") %><input type="radio" name="answer" value=1 /></Div>
<div class="answer"><% print objRs("answer2") %><input type="radio" name="answer" value=2 /></Div>
<%if objRs("answer3")<> "" Then %><div class="answer"><% print objRs("answer3") %><input type="radio" name="answer" value=3 /></Div> <% End If %>
<%if objRs("answer4")<> "" Then %><div class="answer"><% print objRs("answer4") %><input type="radio" name="answer" value=4 /></Div> <% End If %>
<%if objRs("answer5")<> "" Then %><div class="answer"><% print objRs("answer5") %><input type="radio" name="answer" value=5 /></Div> <% End If %>
<%if objRs("answer6")<> "" Then %><div class="answer"><% print objRs("answer6") %><input type="radio" name="answer" value=6 /></Div> <% End If %>
<div class="sendquestion"><input type="submit"  value="שלח" /></Div>
</form>
<%
      closeDB(objRs)
        End If
        End If
 %>