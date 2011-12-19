<!--#include file="../config.asp"-->
<script type="text/javascript">
function RefreshImage(valImageId) {
	var objImage = document.images[valImageId];
	if (objImage == undefined) {
		return;
	}
	var now = new Date();
	objImage.src = objImage.src.split('?')[0] + '?x=' + now.toUTCString();
}
</script>
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
end function
%>
<form action="../ContactForm.asp?mode=doit&headers=no" class="_ajax_form" method="post" id="ContactForm">
	<%               
		If Request.QueryString("mode") = "doit" then
		 	If getconfig("EnableCaptcha") = 1 then
				if not TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
					Response.Write("<b style=""color:#FF0000"">הקוד שגוי</b>")
				end if
			end if
		end if
		
			TemplateURL = templatelocation  & "contactform.html" 
			ProcessLayout(Trim(GetURL(TemplateURL)))
	%>

</form>
