<!-- #include file="CAPTCHA_setup.asp" -->
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




'Initialise variables
Dim blnCAPTCHAcodeCorrect		'Set to true if the CAPTCHA code entered is correct
Dim strCAPTCHAenteredCode		'Holds the code entered by the user





'Initilise the security code bulleon to false
blnCAPTCHAcodeCorrect = false


'Check CAPTCHA ocde is correct (case sensitive)
If blnCAPTCHAcaseSensitive Then
 	
 	If Session("strSecurityCode") = Request("securityCode") AND Session("strSecurityCode") <> "" Then blnCAPTCHAcodeCorrect = true    
 
 
 		
'Check CAPTCHA ocde is correct (non-case sensitive)
Else
	If LCase(Session("strSecurityCode")) = LCase(Request("securityCode")) AND Session("strSecurityCode") <> "" Then blnCAPTCHAcodeCorrect = true    
End If


'Reset the security code session variable so it can not be reused
'Clear session variable
Session.Contents.Remove("strSecurityCode")
%>