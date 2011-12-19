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
<script type="text/javascript">
    $().ready(function() {
        // validate the comment form when it is submitted
    $("#ContactForm").validate();
    });
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
<form action="../ContactForm.asp?mode=doit" onsubmit="return validate_form(this);" method="post" id="ContactForm">
	<%               
		If Request.QueryString("mode") = "doit" then
		 	If getconfig("EnableCaptcha") = 1 then
				if not TestCaptcha("ASPCAPTCHA", Request.Form("captchacode")) then
					Response.Write("<b style=""color:#FF0000"">&#1492;&#1511;&#1493;&#1491; &#1513;&#1490;&#1493;&#1497;</b>")
				end if
			end if
		end if
	%>

<table id="contact">
	<tr>
		<td><input id="ci1" name="Name" class="required" minlength="2" /></td>
		<td>:<% = SysLang("name")%></td>
	</tr>
	<tr>
		<td><input id="ci2" name="Phone" class="required number" ></td>
		<td>:<% = SysLang("phone")%></td>
	</tr>
	<tr>
		<td><input id="ci3" name="eMail" class="required email"></td>
		<td>:Email</td>
	</tr>
	<%	If getconfig("EnableCaptcha") = 1 then %>
	<tr>
		<td><input name="captchacode" type="text" id="captchacode"/></td>
		<td>:<% = SysLang("code")%></td>
	</tr>

	<tr>
		<td><img id="imgCaptcha2" width="98" src="../captcha.asp" /></td>
		<td><a href="javascript:void(0)" onclick="RefreshImage('imgCaptcha2')" style="text-decoration: none">:<% = SysLang("change")%></a></td>
	</tr>
	<% end if %>
	<tr>
		<td><input id="send" type="submit" value="<% = SysLang("send")%>" name="B2"></td>
		<td></td>
	</tr>
</table>
</form>
