<!--#include file="../config.asp"-->

	
	
<% 
Function LogThisEntry
    			Set objRslogin = OpenDB("SELECT * FROM adminlogins")
				objRslogin.AddNew
				
				objRslogin("loginip")= Request.ServerVariables("REMOTE_ADDR")
				objRslogin("loginsitename")=  GetConfig("SiteName")
				objRslogin("loginsiteid")= SiteId
				objRslogin("logintime")= Now()
				objRslogin("loginusername")= CheckHacker(Request.Form("Username"))
				objRslogin("loginpass")= CheckHacker(Request.Form("Password"))
				objRslogin("loginsuccseed")= loginsuccseed 
				objRslogin.Update
				
				CloseDB(objRslogin)
				'/////////End Log This Entry
End Function

if GetSession("URL") = "" then
	SetSession "URL","default.asp"
End If

If Request.QueryString("mode")  = "logout" Then
		SetSession "Username",""
		SetSession "Password",""
		SetSession "Type",""
		SetSession "UserID",""

		Response.Redirect("../" & Application(ScriptName & "WebPageURL"))
End If

if GetSession("Type") = "Admin" Then 
    function ConvertBytes(ByRef anBytes)
    	Dim lnSize			' File Size To be returned
    	Dim lsType			' Type of measurement (Bytes, KB, MB, GB, TB)
    	
    	Const lnBYTE = 1
    	Const lnKILO = 1024						' 2^10
    	Const lnMEGA = 1048576					' 2^20
    	Const lnGIGA = 1073741824				' 2^30
    	Const lnTERA = 1099511627776			' 2^40
    	'	Const lnPETA = 1.12589990684262E+15		' 2^50
    	'	Const lnEXA = 1.15292150460685E+18		' 2^60
    	'	Const lnZETTA = 1.18059162071741E+21	' 2^70
    	'	Const lnYOTTA = 1.20892581961463E+24	' 2^80
    	
    	if anBytes = "" Or Not IsNumeric(anBytes) Then Exit function
    	
    	if anBytes < 0 Then Exit function	
    '	If anBytes < lnKILO Then
    '		' ByteConversion
    '		lnSize = anBytes
    '		lsType = "bytes"
    '	Else		
    		if anBytes < lnMEGA Then
    			' KiloByte Conversion
    			lnSize = (anBytes / lnKILO)
    			lsType = "KB"
    		ElseIf anBytes < lnGIGA Then
    			' MegaByte Conversion
    			lnSize = (anBytes / lnMEGA)
    			lsType = "<small>MB</small>"
    		ElseIf anBytes < lnTERA Then
    			' GigaByte Conversion
    			lnSize = (anBytes / lnGIGA)
    			lsType = "GB"
    		Else
    			' TeraByte Conversion
    			lnSize = (anBytes / lnTERA)
    			lsType = "TB"
    		End if
    '	End If
    	' Remove fraction
    	'lnSize = CLng(lnSize)
    	lnSize = FormatNumber(lnSize, 2, True, False, True)
    	
    	' Return the results
    	ConvertBytes = lnSize & "<small>" & lsType & "</small>"
    End function

Set objRsPages = OpenDB("SELECT id FROM Content Where SiteID= " & SiteID)
TotalPages  = objRsPages.RecordCount
objRsPages.Close

	Dim fs,fo
	Set fs=Server.CreateObject("Scripting.FileSystemObject")
	MainFolderPath = fs.GetFolder(phisicalpath &  GetConfig("SiteName") & "\Content")
	Set fo=fs.GetFolder(MainFolderPath)
	SiteSize = fo.size
	set fo=nothing
	set fs=nothing


%>
<!--#include file="header.asp"-->
<script type="text/javascript" src="js/raphael.js"></script>
    <script type="text/javascript" src="js/popup.js"></script>
	<script type='text/javascript' src='http://www.google.com/jsapi'></script>
   <% If Getconfig("Analyticsusername") = "" Then %>
    <script type="text/javascript" src="js/analytics.js"></script>
    <% Else %>
    <script type="text/javascript" src="js/analytics2.js"></script>
	<script type="text/javascript">
	    google.load('visualization', '1', { packages: ['annotatedtimeline', 'geomap', 'table'] });       
	</script>
    <% End if %>
<!--#include file="right.asp"-->
	<div id="incontent">
		<div class="incontentbox">
			<h1>קיצורי דרך</h1>
				<ul>
					<li><div><a href="admin_content.asp">ניהול דפי תוכן<img src="images/i1.gif" alt="" /></a></div></li>
					<li><div><a href="admin_content.asp?action=add">הוספת דף<img src="images/i2.gif" alt="" /></a></div></li>
					<li><div><a href="admin_Menu.asp">ניהול כפתורים<img src="images/i3.gif" alt="" /></a></div></li>
					<li><div><a href="admin_news.asp">חדשות ועדכונים<img src="images/i4.gif" alt="" /></a></div></li>
					<li><div><a href="admin_gallery.asp">גלריות ומולטימדיה<img src="images/i5.gif" alt="" /></a></div></li>
					<li><div><a href="admin_contacts.asp">ניהול פניות מהאתר<img src="images/i6.gif" alt="" /></a></div></li>
					<li><div><a href="admin_users.asp">ניהול חברי מועדון<img src="images/i7.gif" alt="" /></a></div></li>
					<li><div><a href="admin_users.asp?type=preparemail">שליחת ניוזלטר<img src="images/i8.gif" alt="" /></a></div></li>
					<li><div><a href="admin_users.asp?type=preparesms">שליחת SMS<img src="images/i9.gif" alt="" /></a></div></li>
					<li><div><a href="admin_site.asp?ID=<%=SiteID%>&action=edit">פרטי מנהל האתר<img src="images/i10.gif" alt="" /></a></div></li>
				</ul>
		</div>
<div class="analytics" style="vertical-align:top">
<% If Getconfig("Analyticsusername") <> "" Then %>

<div id="tabs2" style="width:100%;height:auto;-moz-border-radius:0px;-webkit-border-radius:0px;">
	<ul style="width:100%;height:auto;">
		<li style="border:0;width:16%;height:37px;line-height:37px;background:#000;"><a style="width:100%;height:37px;line-height:37px;padding:0;text-align:center;" href="#tabs2-7">כניסות לאתר</a></li>
		<li style="border:0;width:16%;height:37px;line-height:37px;background:#000;"><a style="width:100%;height:37px;line-height:37px;padding:0;text-align:center;" href="#tabs2-8">מקורות תנועה</a></li>
		<li style="border:0;width:16%;height:37px;line-height:37px;background:#000;"><a style="width:100%;height:37px;line-height:37px;padding:0;text-align:center;" href="#tabs2-9">כניסות ע"ג מפה</a></li>
		<li style="border:0;width:16%;height:37px;line-height:37px;background:#000;"><a style="width:100%;height:37px;line-height:37px;padding:0;text-align:center;" href="#tabs2-10">מילות מפתח</a></li>
		<li style="border:0;width:16%;height:37px;line-height:37px;background:#000;"><a style="width:100%;height:37px;line-height:37px;padding:0;text-align:center;" href="#tabs2-11">דפים נצפים</a></li>
		<li style="border:0;width:20%;height:37px;line-height:37px;background:#fff;"><img src="images/galogo2.gif" alt="" /></li>
	</ul>
	<div style="margin:30px auto;float:right;margin:30px;float:right;font-size:20px;margin:30px;" id="analoading"><img src="images/indicator.gif" style="margin:12px 10px 0 0;float:right;" /><div style="margin:7px 10px 0 0;float:right;">מייבא נתונים מ - </div><img src="images/galogo.gif" style="margin:0 10px 0 0;float:right;" /></div>
	<div id="tabs2-7" style="width:100%;padding:0;height:auto;">
			<div id="holder" class="holder"></div>
			<table id="data" cellspacing="0" cellpadding="0" border="0">
            <tfoot>
                <tr>
                    <th><% = FormatDate(Now()-28, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-27, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-26, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-25, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-24, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-23, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-22, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-21, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-20, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-19, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-18, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-17, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-16, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-15, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-14, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-13, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-12, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-11, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-10, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-9, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-8, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-7, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-6, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-5, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-4, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-3, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-2, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now()-1, "dd/mm/yyyy") %></th>
                    <th><% = FormatDate(Now(), "dd/mm/yyyy") %></th>
                </tr>
            </tfoot>
            <tbody>
                <tr>
          
                </tr>
            </tbody>
        </table>
	</div>
	<div id="tabs2-8" style="width:100%;padding:0;height:auto;">
			<div id="holderpie" class="holder pie" style="float:left;height:200px;padding:30px 0 0 50px;width:60%;"></div>
			<table id="tablepie" width="30%" border="0" cellspacing="0" cellpadding="3" style="float:right;margin:20px 10px 0 0;">
				<thead>
					<tr>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="10%">מקום</th>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;line-height:25px;" width="50%">מקור</th>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="20%">כניסות</th>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="20%">אחוזים</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	</div>
	<div id="tabs2-9" style="width:100%;padding:0;height:auto;text-align:left;margin:20px 0 0;">
			<div id="chartWorldMap" class="holder map" style="width:72%;float:left;margin:0 auto;"></div>
			<table id="worldmap" width="25%" border="0" cellspacing="0" cellpadding="3" style="float:right;margin:0 10px 10px 0;">
				<thead>
					<tr>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="10%">מקום</th>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;line-height:25px;text-align:center;" width="70%">מדינה</th>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="20%">כניסות</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	</div>
	<div id="tabs2-10" style="width:100%;padding:0;height:auto;">
			<div id="tables" class="holder">
				<table id="topkeywords" cellspacing="0" cellpadding="3" border="0" width="100%">
					<thead>
						<tr>
							<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="10%">מקום</th>
							<th style="border-bottom:1px dotted #ccc;background:#ddd;line-height:25px;" width="80%">מילה</th>
							<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="10%">כניסות</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
	</div>
	<div id="tabs2-11" style="width:100%;padding:0;height:auto;">
			<table id="toppages" cellspacing="0" cellpadding="3" border="0" width="100%">
				<thead>
					<tr>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="10%">מקום</th>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;line-height:25px;" width="80%">כתובת הדף</th>
						<th style="border-bottom:1px dotted #ccc;background:#ddd;text-align:center;line-height:25px;" width="10%">כניסות</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
				</table>
	</div>
</div>
<%else %>
	<div style="margin:30px auto;float:right;margin:30px;float:right;font-size:20px;margin:30px;" id="Div1"><div style="margin:7px 10px 0 0;float:right;">כדי לראות סטטיסטיקות יש להרשם ל - </div><img src="images/galogo.gif" style="margin:0 10px 0 0;float:right;" /></div>
 <% End if %>
</div>
        <% Else %>

<!--#include file="headerlogon.asp"-->
<div id="content">
<%
If Request.QueryString("mode") = "doit" Then	
		Set objRs = OpenDB("SELECT * FROM Admin WHERE (Username='" & CheckHacker(Request.Form("Username")) & "') AND (Password='" & md5(Request.Form("Password")) & "') AND SiteID=" & SiteID)
		
	If objRs.RecordCount = 0 Then
	loginsuccseed = "No"
	LogThisEntry
		Response.Write("<table align=""center"" valign=""middle"" height=""300""><tr><td><div id=""error"">שם משתמש או סיסמא שגויים. נא נסה שנית</div></td></tr></table>")
	Else

		Session(SiteID & "Id") = objRs(0)
		Session(SiteID & "Username") = objRs("Username")
		Session(SiteID & "Password") = objRs("Password")
		Session(SiteID & "AdminID") = objRs("Id")
		Session(SiteID & "AdminLevel") = objRs("Admin9Level")
		Session(SiteID & "Type") = "Admin"
		loginsuccseed ="Yes"
        LogThisEntry
					Response.Redirect(GetSession("URL"))

	End If
	
	CloseDB(objRs)
ElseIf Request.QueryString("mode") = "denied" Then
	Response.Write("<table align=""center"" valign=""middle"" height=""300""><tr><td><div id=""error""> אין לך גישה לדף זה</div></td></tr></table>")

Else
%>


<div style="position:relative;width:511px;height:250px;margin:50px auto;background:url(login.gif) no-repeat;">
    <div style="width:333px;height:125px;position:absolute;top:57px;right:162px;">
        <div style="padding:10px;">
             <form name="Login" id="FormID" action="default.asp?mode=doit" method="post"  class="_validate">
                <table style="font-size:14px;font-weight:bold;height:100px;" dir="rtl" cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td align="right" width="100">שם משתמש:</td>
                        <td align="right"><input type="text" name="Username" dir="rtl" name="" style="text-align:left;width:150px;float:left;color:#999999;float:left;font-family:arial;font-size:16px;font-weight:bold;width:150px;" class="required"></td>
                    </tr>
                    <tr>
                        <td align="right">סיסמא:</td>
                        <td align="right"><input type="password" dir="rtl" name="Password" style="text-align:left;width:150px;float:left;color:#999999;float:left;font-family:arial;font-size:16px;font-weight:bold;width:150px;" class="required"></td>
                    </tr>
                    <tr>
                        <td><a style="font-size:12px;" href="#">שכחתי את סיסמתי</a></td>
                        <td>
                        <input type="submit" style="float:left;" value="הכנס">
                        </td>
                    </tr>
                </table>
				</form>
            </div>
        <div>
    </div>
</div>

<% 
End If 
%>

</div>
<div id="footer"></div>
</div>
</body>
</html>

<%
End If
if GetSession("Type") = "Admin" Then %>
<!--#include file="footer.asp"-->
<% End If %>