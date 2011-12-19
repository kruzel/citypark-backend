<!--#include file="../config.asp"-->
<!--#include file="../$db.asp"-->
<% 
Function LogThisEntry
    			    Set objRslogin = OpenDB("SELECT * FROM adminlogins")
				objRslogin.AddNew
				
				objRslogin("loginip")= Request.ServerVariables("REMOTE_ADDR")
				objRslogin("loginsitename")=  GetConfig("SiteName")
				objRslogin("loginsiteid")= SiteId
				objRslogin("logintime")= Now()
				objRslogin("loginusername")= Request.Form("Username")
				objRslogin("loginpass")= Request.Form("Password")
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

if GetSession("URL") = "" then
	SetSession "URL","default.asp"
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

Set objRsPages = OpenDB("SELECT NewsID FROM News Where SiteID= " & SiteID)
TotalPages  = objRsPages.RecordCount
objRsPages.Close

	Dim fs,fo
	Set fs=Server.CreateObject("Scripting.FileSystemObject")
	MainFolderPath = fs.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\Content")
	Set fo=fs.GetFolder(MainFolderPath)
	SiteSize = fo.size
	set fo=nothing
	set fs=nothing


%>
	 <!--#include file="inc_admin_icons.asp"-->
	
<div style="background:#F0F0F0;height:270px;border:1px solid #CCCCCC;margin:10px 15px;padding:15px;">
    <div style="height:100%;float:right;width:65%">
        <div style="width:24%;height:150px;float:right;"><a href="admin_content.asp"><img src="/sites/cms/layout/images/i1.gif" border="0" alt="" /></a></div>
        <div style="width:24%;height:150px;float:right;"><a href="admin_category.asp"><img src="/sites/cms/layout/images/i2.gif" border="0" alt="" /></a></div>
        <div style="width:24%;height:150px;float:right;"><a href="admin_Menu.asp"><img src="/sites/cms/layout/images/i3.gif" border="0" alt="" /></a></div>
        <div style="width:24%;height:150px;float:right;"><a href="admin_block.asp"><img src="/sites/cms/layout/images/i4.gif" border="0" alt="" /></a></div>
        <div style="width:24%;height:150px;float:right;"><a href="admin_news.asp"><img src="/sites/cms/layout/images/i5.gif" border="0" alt="" /></a></div>
        <div style="width:24%;height:150px;float:right;"><a href="admin_gallery.asp"><img src="/sites/cms/layout/images/i6.gif" border="0" alt="" /></a></div>
        <div style="width:24%;height:150px;float:right;"><a href="<% = GetConfig("adminusersbutton") %>"><img src="/sites/cms/layout/images/i7.gif" border="0" alt="" /></a></div>
        <div style="width:24%;height:150px;float:right;"><a href="admin_config.asp"><img src="/sites/cms/layout/images/i8.gif" border="0" alt="" /></a></div>
    </div>
    <div style="height:100%;float:right;width:35%;">
        <div style="width:100%;height:252px;background:#fff;border:1px solid #ccc;margin-top:10px;float:left;">
            <ul id="mainul">
                <li>מנהל האתר: <span style="color:#26BADE;font-weight:bold;margin-right:5px;"><% = GetConfig("AdminEmail") %></span></li>
                <li>כתובת האתר: <span style="color:#26BADE;font-weight:bold;margin-right:5px;"><% = GetConfig("Domains") %></span></li>
                <li>דפים באתר: <span style="color:#26BADE;font-weight:bold;margin-right:5px;"><% = TotalPages %> דפים</span></li>
                <li>כמות SMS שנותרו: <span style="color:#26BADE;font-weight:bold;margin-right:5px;"><% = GetConfig("smscredit") %> sms <a href"#">רכוש חבילה</a></span></li>
                <li>נפח אחסון מקסימלי: <span style="color:#26BADE;font-weight:bold;margin-right:5px;"><% = ConvertBytes(GetConfig("maxfoldersize")) %></span></li>
                <li>משקל הקבצים הנוכחי: <span style="color:#26BADE;font-weight:bold;margin-right:5px;"><% = ConvertBytes(SiteSize) %></span></li>
                <li>תאריך הבא לחידוש האתר: <span style="color:#26BADE;font-weight:bold;margin-right:5px;"><% = GetConfig("nextregistrationdate") %></span></li>
                <% Set objRsStats = OpenDB("SELECT COUNT(*) AS TOTAL FROM [nextwww].[dbo].[Analytics] Where SiteId= " & SiteId)
                Total = objRsStats("TOTAL")
                CloseDB(objRsStats)
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE(), 103) AND SiteID =" & SiteID)
                Today = objRsStats("today")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today1 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-1, 103)AND SiteID =" & SiteID)
                Today1 = objRsStats("today1")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today2 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-2, 103)AND SiteID =" & SiteID)
                Today2 = objRsStats("today2")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today3 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-3, 103)AND SiteID =" & SiteID)
                Today3 = objRsStats("today3")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today4 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-4, 103)AND SiteID =" & SiteID)
                Today4 = objRsStats("today4")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today5 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-5, 103)AND SiteID =" & SiteID)
                Today5 = objRsStats("today5")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today6 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-6, 103)AND SiteID =" & SiteID)
                Today6 = objRsStats("today6")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS today7 FROM [nextwww].[dbo].[Analytics] WHERE CONVERT(VARCHAR(10),[Datetime], 103) = CONVERT(VARCHAR(10),GETDATE()-7, 103)AND SiteID =" & SiteID)
                Today7 = objRsStats("today7")
                
                Set objRsStats = OpenDB("SELECT COUNT(*) AS ThisWeek FROM [nextwww].[dbo].[Analytics] Where SiteId=" & SiteID & " AND DATEPART(wk,datetime)= DATEPART(wk,GETDATE())")
                ThisWeek = objRsStats("ThisWeek")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS ThisWeek1 FROM [nextwww].[dbo].[Analytics] Where SiteId=" & SiteID & " AND DATEPART(wk,datetime)= DATEPART(wk,GETDATE())-1")
                ThisWeek1 = objRsStats("ThisWeek1")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS ThisWeek2 FROM [nextwww].[dbo].[Analytics] Where SiteId=" & SiteID & " AND DATEPART(wk,datetime)= DATEPART(wk,GETDATE())-2")
                ThisWeek2 = objRsStats("ThisWeek2")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS ThisWeek3 FROM [nextwww].[dbo].[Analytics] Where SiteId=" & SiteID & " AND DATEPART(wk,datetime)= DATEPART(wk,GETDATE())-3")
                ThisWeek3 = objRsStats("ThisWeek3")
                Set objRsStats = OpenDB("SELECT COUNT(*) AS ThisWeek4 FROM [nextwww].[dbo].[Analytics] Where SiteId=" & SiteID & " AND DATEPART(wk,datetime)= DATEPART(wk,GETDATE())-4")
                ThisWeek4 = objRsStats("ThisWeek4")

                CloseDB(objRsStats)
                %>
                 <li style="border-bottom:0px;">סה"כ: <span style="font-weight:bold;color:#26BADE;margin-right:5px;"><a href="stat.asp"><% = Total %> כניסות</a></span></li>
         </ul>
        </div>
    </div>
</div> 
<div style="background:#fff;height:225px;border:1px solid #CCCCCC;margin:10px 15px;">
<div style="height:auto;margin:10px 15px;padding:0px;float:right"><img src="http://chart.apis.google.com/chart?chs=450x150&chd=t:<% = (SiteSize / GetConfig("maxfoldersize")) * 100 %>,<% = ((GetConfig("maxfoldersize") - SiteSize) / GetConfig("maxfoldersize")) * 100 %>&cht=p3&chl=משקל האחסון הנוכחי|נפח אחסון מקסימלי&chco=FDFFDF,26BADE"/></div>
<div style="height:auto;padding left:0px;float:left">
	<SCRIPT LANGUAGE="Javascript" SRC="/JS/FusionCharts.js"></SCRIPT>
	
	<SCRIPT LANGUAGE="JavaScript">
	    var data = new Array();
	    data[0] = new Array("כניסות",<% = Today %> ,<% = Today1 %>,<% = Today2 %>,<% = Today3 %>,<% = Today4 %>,<% = Today5 %>,<% = Today6 %>,<% = Today7 %>);
	    var colors = new Array("26BADE");
	    function updateChart(domId) {
	        updateChartXML(domId, generateXML(this.document.productSelector.AnimateChart.checked));
	    }
	    function generateXML(animate) {
	        var strXML = "";
	        strXML = "<graph numberPrefix='' decimalPrecision='0' animation='" + ((animate == true) ? "1" : "0") + "' " + ((this.document.productSelector.ShowValues.checked == true) ? ("showValues='1' rotateValues='1'") : (" showValues='0' ")) + "yaxismaxvalue='30'>";
	        strXML = strXML + "<categories><category name='<%= day(date)&"/"& month(date) %> ' /><category name=' <%= day(date-1)&"/"& month(date) %>' /><category name=' <%= day(date-2)&"/"& month(date) %>' /><category name='<%= day(date-3)&"/"& month(date) %> ' /><category name='<%= day(date-4)&"/"& month(date) %> ' /><category name='<%= day(date-5)&"/"& month(date) %> ' /><category name='<%= day(date-6)&"/"& month(date) %> ' /><category name='<%= day(date-7)&"/"& month(date) %> ' /></categories>";
	        strXML = (this.document.productSelector.ProductA.checked == true) ? (strXML + getProductXML(0)) : (strXML);
	        strXML = strXML + "</graph>";
	        return strXML;
	    }
	    function getProductXML(productIndex) {
	        var productXML;
	        productXML = "<dataset seriesName='" + data[productIndex][0] + "' color='" + colors[productIndex] + "' >";
	        for (var i = 1; i <= 8; i++) {
	            productXML = productXML + "<set value='" + data[productIndex][i] + "' />";
	        }
	        productXML = productXML + "</dataset>";
	        return productXML;
	    }
	</SCRIPT>
		<div id="chart1div">
		</div>
		<div style="display:none;">
			<FORM NAME='productSelector' Id='productSelector' action='Chart.html' method='POST' >
			<INPUT TYPE='Checkbox' name='ProductA' onClick="JavaScript:updateChart('chart1Id');" checked />&nbsp;סה"כ כניסות&nbsp;&nbsp;
			
			<INPUT TYPE='Checkbox' name='AnimateChart' checked />אנימציה?&nbsp;&nbsp;
			<INPUT TYPE='Checkbox' name='ShowValues' onClick="JavaScript:updateChart('chart1Id');" checked />הצג ערכים?&nbsp;&nbsp;
		</FORM>
        </div>
		<script language="JavaScript">
		    var chart1 = new FusionCharts("FCF_MSColumn3D.swf", "chart1Id", "350", "200");
		    var strXML = generateXML(this.document.productSelector.AnimateChart.checked);
		    chart1.setDataXML(strXML);
		    chart1.render("chart1div");
		</script>
		
		<SCRIPT LANGUAGE="JavaScript">
	    var data = new Array();
	    data[0] = new Array("כניסות",<% = Total %> ,<% = ThisWeek %>,<% = ThisWeek1 %>,<% = ThisWeek2 %>,<% = ThisWeek3 %>,<% = ThisWeek4 %>);
	    var colors = new Array("26BADE");
	    function updateChart(domId) {
	        updateChartXML(domId, generateXML2(this.document.productSelector2.AnimateChart.checked));
	    }
	    function generateXML2(animate) {
	        var strXML2 = "";
	        strXML2 = "<graph numberPrefix='' decimalPrecision='0' animation='" + ((animate == true) ? "1" : "0") + "' " + ((this.document.productSelector.ShowValues.checked == true) ? ("showValues='1' rotateValues='1'") : (" showValues='0' ")) + "yaxismaxvalue='100'>";
	        strXML2 = strXML2 + "<categories><category name='סהכ כניסות' /><category name='השבוע' /><category name='שבוע שעבר' /><category name='לפני שבועיים' /><category name='לפני 3 שבועות' /><category name='לפני 4 שבועות' /></categories>";
	        strXML2 = (this.document.productSelector.ProductA.checked == true) ? (strXML2 + getProductXML(0)) : (strXML2);
	        strXML2 = strXML2 + "</graph>";
	        return strXML2;
	    }
	    function getProductXML2(productIndex) {
	        var productXML2;
	        productXML2 = "<dataset seriesName='" + data[productIndex][0] + "' color='" + colors[productIndex] + "' >";
	        for (var i = 1; i <= 5; i++) {
	            productXML2 = productXML2 + "<set value='" + data[productIndex][i] + "' />";
	        }
	        productXML2 = productXML2 + "</dataset>";
	        return productXML2;
	    }
	 </SCRIPT>
			<div style="display:none;" id="chart2div">
		</div>
		<div style="display:none;">
				<FORM NAME='productSelector2' Id='productSelector2' action='Chart.html' method='POST' >
			<INPUT TYPE='Checkbox' name='ProductA' onClick="JavaScript:updateChart('chart2Id');" checked />&nbsp;סה"כ כניסות&nbsp;&nbsp;
			
			<INPUT TYPE='Checkbox' name='AnimateChart' checked />אנימציה?&nbsp;&nbsp;
			<INPUT TYPE='Checkbox' name='ShowValues' onClick="JavaScript:updateChart('chart2Id');" checked />הצג ערכים?&nbsp;&nbsp;
		</FORM>
</div>
		<script language="JavaScript">
		  var chart2 = new FusionCharts("FCF_MSColumn3D.swf", "chart2Id", "350", "200");

		    var strXML = generateXML2(this.document.productSelector2.AnimateChart.checked);
		    chart2.setDataXML(strXML);
		    chart2.render("chart2div");

		</script>
		

		
		
		
		
		
		
		
</div>
</div>
<% Else %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>מערכת ניהול</title>
    <meta name="keywords" content="מערכת ניהול" />
    <meta name="description" content="מערכת ניהול" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="Content-Language" content="he" />
    <meta name="ROBOTS" content="INDEX,FOLLOW" />
    <meta name="copyright" content="Dooble.co.il" />
    <meta name="Author" content="Dooble.co.il" />
    <meta name="rating" content="General" />
    <link rel="stylesheet" media="all" type="text/css" href="/sites/cms/layout/style/style.css" />
<link type="text/css" media="screen" rel="stylesheet" href="/js/colorbox.css" />
<!--[if IE]>
<link type="text/css" media="screen" rel="stylesheet" href="/js/colorbox-ie.css" title="example" />
<![endif]-->
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery.colorbox.js"></script>
<script src="/js/prototype.js" type="text/javascript"></script>

<script src="/js/scriptaculous/effects.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/validation.asp"></script>
<link rel="stylesheet" href="/js/jquery-ui.css" type="text/css"  />
<script type="text/javascript" src="/js/jquery-ui-1.7.1.custom.min.js"></script>
<script type="text/javascript" src="/js/ajaxupload.js"></script>
<script type="text/javascript" src="/js/ajaxcombo.js"></script>
<script type="text/javascript" src="/js/ajaxforms.js"></script>

</head>
<body id="body">
<div id="container">
<div id="header">
    <div style="width:100%;height:56px;">
        <div style="width:200px;float:right;height:56px;color:#fff;line-height:56px;margin-right:10px;font-weight:bold;"></div>
        <div style="width:200px;float:left;height:56px;"><img style="float:left;margin-left:10px;" src="/sites/cms/layout/images/logo.gif" border="0" alt="" /></div>  
    </div>
</div>
<div id="content">
<%
If Request.QueryString("mode") = "doit" Then	
		Set objRs = OpenDB("SELECT * FROM Admin WHERE (AdminUserName='" & Trim(Request.Form("Username")) & "') AND (Password='" & Trim(Request.Form("Password")) & "') AND SiteID=" & SiteID)
		
	If objRs.RecordCount = 0 Then
	loginsuccseed = "No"
	LogThisEntry
		Response.Write("<table align=""center"" valign=""middle"" height=""300""><tr><td><div id=""error"">שם משתמש או סיסמא שגויים. נא נסה שנית</div></td></tr></table>")
	Else

		Session(SiteID & "UserID") = objRs(0)
		Session(SiteID & "Username") = objRs("AdminUserName")
		Session(SiteID & "Password") = objRs("Password")
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


<div style="width:511px;height:250px;margin:50px auto;background:url(/sites/cms/layout/images/login.gif) no-repeat;">
    <div style="width:333px;height:125px;position:relative;top:57px;right:162px;">
        <div style="padding:10px;">
                <form name="Login" id="FormID" action="default.asp?mode=doit" method="post">
                <table style="font-size:14px;font-weight:bold;" dir="rtl" cellpadding="0" cellspacing="0" border="0" width="100%" height="100">
                    <tr>
                        <td width="100">שם משתמש</td>
                        <td><input type="text" name="Username" dir="rtl" name="" style="text-align:left;width:150px;float:left;color:#999999;float:left;font-family:arial;font-size:16px;font-weight:bold;width:150px;" class="required"></td>
                    </tr>
                    <tr>
                        <td>סיסמא</td>
                        <td><input type="password" dir="rtl" name="Password" style="text-align:left;width:150px;float:left;color:#999999;float:left;font-family:arial;font-size:16px;font-weight:bold;width:150px;" class="required"></td>
                    </tr>
                    <tr>
                        <td><a style="font-size:12px;" href="#">שכחתי את סיסמתי</a></td>
                        <td>
                        
                        <input type="submit" style="float:left;" value="הכנס">
                   </form>
                <script type="text/javascript">
                    new Validation('FormID', { stopOnFirst: true });
	            </script>

                        
                        
                        
                        </td>
                    </tr>
                </table>
            </div>
        <div>
        <div style="padding:10px 10px 0 0;">כתובת ה-IP שלך נשמרה במערכת למטרת אבטחה.</div>
        <div style="padding:10px 10px 0 0;color:#1CB8DF;font-weight:bold;"><% = Request.ServerVariables("remote_addr") %></div>
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
%>