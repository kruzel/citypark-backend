 <!--#include file="../config.asp"-->
 
<%
sendmode=True
CheckSecuirty "Users"
if request.querystring("type") = "sendmail" then
%>
<!--#include file="header.asp"-->
<script>
function start() {
		var email,tmpl,attach;
		$("#mailist tbody tr").each(function() {
		var tr = $(this);
		email = $(this).find(".email").text();
		id = $(this).find(".id").text();
		attach = $("#attachment").val();
		sender = $("#sender").val();
		subject = $("#subject").val();
		tmpl = $("#template").val();
			$.ajax({
				type: "GET",
				url: "/admin/ajax_mailer.asp",
				data: "type=sendit&template="+tmpl+"&attachment="+attach+"&email="+email+"&id="+id+"&sender="+sender+"&subject="+subject,
				success: function(msg){
				//alert(msg);
					$(tr).find(".sent").text(msg);
				}
			});
	
		});
		}
		//start();
</script>
<%  
print "<table width='100%' border=1 id='mailist'><thead><tr><th>id</th><th>email</th><th>name</th><th>sent?</th></tr></thead><tbody>"
		For Each x In Request.Form
	
			If Mid(x, 1, 5) = "Send_" Then	
				If Request.Form(x) = "on" Then	
					uid = uid &replace(x,"Send_","")&","
				End If
			End If
	  	Next
	 	uid = uid &",,"
		uid = replace(uid,",,,","")
		
	'	print "Select * From [Users] Where id in("&uid&") AND SiteID = " & SiteID
		Set Rs = OpenDB("Select *, Familyname+' '+Name as fullname From [Users] Where id in("&uid&") AND SiteID = " & SiteID)
	 	Do While Not Rs.EOF 
			print "<tr><td class='id'>"&rs("id")&"</td><td class='email'>"&rs("email")&"</td><td >"&rs("fullname")&"</td><td class='sent'>&nbsp;</td></tr>"
			
			Rs.MoveNext 
		Loop
		Rs.Close
		print "</tbody></table>"
		print "<br><span onclick='start()'>התחל</span>"
		
		print "<input type='hidden' name='attachment' id='attachment' value='"&filepath & Request.form("Attachment")&"'>"
		print "<input type='hidden' name='sender' id='sender' value='"& Request.form("Sender")&"'>"
		print "<input type='hidden' name='subject' id='subject' value='"& Request.form("Subject")&"'>"
		print "<input type='hidden' name='template' id='template' value='"& Request.form("template")&"'>"
		If Request.form("Template")<> "" Then
			print Request.form("Template")
		else
			print Request.form("message")
		end if
		print "'>"
		%>
		<!--#include file="footer.asp"-->
		<%
		
End If


if request.querystring("type") = "sendit" then
		 Set myMail = CreateObject("CDO.Message")
		 myMail.Subject = Trim(Request("subject"))
		 myMail.From = Trim(Request("sender"))
		 myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		 myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtp
		 myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
		 If Request.Form("attachment")<> "" Then 'צריך לוודא שהערך הוא באמת קובץ לפני שמוסיפים
			 myMail.AddAttachment filepath & Request.Form("Attachment")
		 End if
	'	print  Request("template")
		 myMail.Configuration.Fields.Update
 		 Set Rs = OpenDB("Select * From [Users] Where id ='"&request("id")&"' AND SiteID = " & SiteID)
			Do While Not Rs.EOF 
				 If Request("template")<> "" Then
					 myMail.HtmlBody = GetPostTemplate(GetRecordSetTemplate(GetUrl(Request("template")),Rs))
					 myMail.HTMLBodyPart.charset = "utf-8"
				 Else
					 myMail.HtmlBody=Request("message") 
				 End If
				 Rs.MoveNext
			 Loop
		 Rs.Close
	
			
					
				   
	
				
				 myMail.Bcc = Request("email") 
				 myMail.HtmlBody = myMail.HtmlBody & "דבר דאר זה נשלח לרשימת תפוצה של האתר.<br />להסרה מרשימת התפוצה לחץ <a href=http://" & LCase(Request.ServerVariables("HTTP_HOST"))& "/mailinglist.asp?mode=Del&email=" & theemail & "&ID=" & theid & ">כאן</a>.<br />"
			'	 Print"<div align=center> הודעה נשלחה בהצלחה אל: " & myMail.Bcc & "<br>"
			     On Error Resume Next
					myMail.Send
					If Err.Number<>0 Then
						print Err.Description
						Err.Clear
					else
						print "נשלח בהצלחה"
					End If
				On Error Goto 0
				
				
			set myMail=nothing
		'print Request.querystring("email")
end if
%>
