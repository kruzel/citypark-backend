<%
'****************************************************************************************
'**  Copyright Notice
'**
'**  Web Wiz Guide - Web Wiz CAPTCHA
'**  
'**  http://www.webwizCAPTCHA.com
'**
'**  Copyright 2005-2006 Bruce Corkhill All Rights Reserved.
'**
'**  This program is free software; you can modify (at your own risk) any part of it
'**  under the terms of the License that accompanies this software and use it both
'**  privately and commercially.
'**
'**  All copyright notices must remain in tacked in the scripts and the
'**  outputted HTML.
'**
'**  You may use parts of this program in your own private work, but you may NOT
'**  redistribute, repackage, or sell the whole or any part of this program even
'**  if it is modified or reverse engineered in whole or in part without express
'**  permission from the author.
'**
'**  You may not pass the whole or any part of this application off as your own work.
'**
'**  All links to Web Wiz Guide and powered by logo's must remain unchanged and in place
'**  and must remain visible when the pages are viewed unless permission is first granted
'**  by the copyright holder.
'**
'**  This program is distributed in the hope that it will be useful,
'**  but WITHOUT ANY WARRANTY; without even the implied warranty of
'**  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR ANY OTHER
'**  WARRANTIES WHETHER EXPRESSED OR IMPLIED.
'**
'**  You should have received a copy of the License along with this program;
'**  if not, write to:- Web Wiz Guide, PO Box 4982, Bournemouth, BH8 8XP, United Kingdom.
'**
'**
'**  No official support is available for this program but you may post support questions at: -
'**  http://www.webwizguide.info/forum
'**
'**  Support questions are NOT answered by e-mail ever!
'**
'**  For correspondence or non support questions contact: -
'**  info@webwizguide.info
'**
'**  or at: -
'**
'**  Web Wiz Guide, PO Box 4982, Bournemouth, BH8 8XP, United Kingdom
'**
'****************************************************************************************            



'***** START WARNING - REMOVAL OR MODIFICATION OF THIS CODE WILL VIOLATE THE LICENSE AGREEMENT ******
Response.Write(vbCrLf & vbCrLf & "<!--//" & _
vbCrLf & "/* *******************************************************" & _
vbCrLf & "Application: Web Wiz CAPTCHA ver. " & strCAPTCHAversion & "" & _
vbCrLf & "Author: Bruce Corkhill" & _
vbCrLf & "Info: http://www.webwizCAPTCHA.com" & _
vbCrLf & "Available FREE: http://www.webwizCAPTCHA.com" & _
vbCrLf & "Copyright: Bruce Corkhill ©2005-2006. All rights reserved" & _
vbCrLf & "******************************************************* */" & _
vbCrLf & "//-->")
'***** END WARNING - REMOVAL OR MODIFICATION OF THIS CODE WILL VIOLATE THE LICENSE AGREEMENT ******              


%>
<script language="javaScript">
function reloadCAPTCHA() {
	document.getElementById('CAPTCHA').src='CAPTCHA/CAPTCHA_image.asp?'+Date();
}
</script>           
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr>
  <td>
  	<img src="CAPTCHA/CAPTCHA_image.asp" alt="Code Image - Please contact webmaster if you have problems seeing this image code" id="CAPTCHA" />
	&nbsp;<a href="javascript:reloadCAPTCHA();"><% = strTxtLoadNewCode %></a>
  </td>
 </tr>
 <tr>
  <td><input type="text" name="securityCode" id="securityCode" class="required validate-captcha" size="12" maxlength="12" autocomplete="off" class="txtfield" /></td>
 </tr><%

'***** START WARNING - REMOVAL OR MODIFICATION OF THIS CODE WILL VIOLATE THE LICENSE AGREEMENT ******
If blnCAPTCHAabout Then
	'Response.Write("<tr><td><span style=""font-size: 10px; font-family: Arial, Helvetica, sans-serif;"">Powered by <a href=""http://www.webwizcaptcha.com"" target=""_blank"" style=""font-size:10px"">Web Wiz CAPTCHA </a> version " & strCAPTCHAversion & "<br />Copyright &copy;2005-2006 <a href=""http://www.webwizguide.info"" target=""_blank"" style=""font-size:10px"">Web Wiz Guide</a></span></td></tr>")
End If 
'***** END WARNING - REMOVAL OR MODIFICATION OF THIS CODE WILL VIOLATE THE LICENSE AGREEMENT ******      
      
      %>
</table>