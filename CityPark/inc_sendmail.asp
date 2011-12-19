<%
function TestCaptcha(byval valSession, byval valCaptcha)
	dim tmpSession
	valSession = Trim(valSession)
	valCaptcha = Trim(valCaptcha)
	if (valSession = vbNullString) or (valCaptcha = vbNullString) then
		TestCaptcha = false
	else
		tmpSession = valSession
		valSession = Trim(Session(valSession))
		Session(tmpSession) = vbNullString
		if valSession = vbNullString then
			TestCaptcha = false
		else
			valCaptcha = Replace(valCaptcha,"i","I")
			if StrComp(valSession,valCaptcha,1) = 0 then
				TestCaptcha = true
			else
				TestCaptcha = false
			end if
		end if		
	end if
	If getconfig("EnableCaptcha") = 0 then TestCaptcha = true
end function

	
	Function SendMail(Subject, Sender, Recipient, Body)

	SendMail= False
						
			
		
			Set myMail=CreateObject("CDO.Message")
			myMail.Subject = Subject
			If Getconfig("sender") = "" then
                myMail.From = Sender
            Else
                myMail.From = Getconfig("sender")
            End if
			myMail.To=Recipient
			myMail.BodyPart.Charset = "utf-8"
			myMail.HTMLBody  = Body
			myMail.Configuration.Fields.Item("urn:schemas:mailheader:x-content-type") = "text/html; charset=utf-8"
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtp
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = sendusername
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = sendpassword
			myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
			myMail.Configuration.Fields.Update
			myMail.Send
			set myMail=nothing
SendMail= True

End Function
%>