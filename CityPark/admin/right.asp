<div id="right">
		<div class="rightboxfast">
			<a href="../<%=getconfig("WebPageUrl") %>" target="_blank"><span style="padding:0 0 0 10px;">עריכת תוכן מהירה</span> ››</a>
		</div>
		<div class="rightbox1">
			<h1>הודעות אחרונות מהאתר</h1>
			<ul>
				<li>
					<p><b>שם הפונה</b></p>
					<span><b>סטאטוס</b></span>
				</li>
<%
function ConvertBytes(ByRef anBytes)
    	Dim lnSize			' File Size To be returned
    	Dim lsType			' Type of measurement (Bytes, KB, MB, GB, TB)
    	
    	Const lnBYTE = 1
    	Const lnKILO = 1024						' 2^10
    	Const lnMEGA = 1048576					' 2^20
    	Const lnGIGA = 1073741824				' 2^30
    	Const lnTERA = 1099511627776			' 2^40
    	
    	if anBytes = "" Or Not IsNumeric(anBytes) Then Exit function
    	
    	if anBytes < 0 Then Exit function	
    		if anBytes < lnMEGA Then
    			lnSize = (anBytes / lnKILO)
    			lsType = "KB"
    		ElseIf anBytes < lnGIGA Then
    			lnSize = (anBytes / lnMEGA)
    			lsType = "MB"
    		ElseIf anBytes < lnTERA Then
    			lnSize = (anBytes / lnGIGA)
    			lsType = "GB"
    		Else
    			lnSize = (anBytes / lnTERA)
    			lsType = "TB"
    		End if
    	lnSize = FormatNumber(lnSize, 2, True, False, True)
    	ConvertBytes = lnSize & "<small>" & lsType & "</small>"
End function
	
    Set fs=Server.CreateObject("Scripting.FileSystemObject")
	MainFolderPath = fs.GetFolder(phisicalpath & Getconfig("Sitename"))
	Set fo=fs.GetFolder(MainFolderPath)
	SiteSize = fo.size
	set fs=nothing


SQL = "SELECT top 4 * FROM contactform WHERE SiteID=" & SiteID & " ORDER BY Date DESC"
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין רשומות"
	Else
        HowMany = 0
Do While Not objRs.EOF And HowMany < objRs.PageSize
      if objRs("status") = 0 Then status = "פנייה חדשה"
      if objRs("status") = 1 Then status = "בטיפול"
      if objRs("status") = 2 Then status = "טופל"
 %>
				<li>
			    <p><% = objRs("Name") %></p>
				<span><a href="admin_contacts.asp?ID=<% = objRs("id") %>&action=edit"><% = status  %></a></span>
				</li>
                <% objRs.movenext
                    loop
                    End if
                    CloseDB(objRs) %>
			</ul>
			<div><a href="admin_contacts.asp">לרשימה המלאה</a></div>
		</div>
		<div class="rightbox2">
			<h1> נתוני האתר - <% = Getconfig("Sitename") %>-- <% = SiteID %></p></h1> 
            <%Set objRspages = OpenDB("SELECT COUNT(*) AS pages FROM [Content] Where SiteId= " & SiteId & " AND Contenttype=1")
                If objRspages.recordcount <> 0 then
                    pages = objRspages("pages")
                Else
                    pages=o
                End if
                CloseDB(objRspages)
                Set objRspages = OpenDB("SELECT COUNT(*) AS pages FROM [Content] Where SiteId= " & SiteId & " AND Contenttype=2")
                If objRspages.recordcount <> 0 then
                    products = objRspages("pages")
                Else
                    products=o
                End if
                CloseDB(objRspages)
                
                Set objRsusers = OpenDB("SELECT COUNT(*) AS users FROM [users] Where SiteId= " & SiteId)
                If objRsusers.recordcount <> 0 then
                    users = objRsusers("users")
                Else
                    users = 0
                End If
                CloseDB(objRsusers)
               
             %>
			<ul>
				<li>
					<p><b>כותרת</b></p>
					<span><b>פרטים</b></span>
				</li>
				<% If GetConfig("Shop")  <> 1 OR  GetConfig("Shop") = NULL Then%>
                <li>
					<p>דפים באתר</p>
					<span><% = pages %></span>
				</li>
                <% Else %>
                <li>
					<p>מוצרים באתר</p>
					<span><% = products %></span>
				</li>
                <% End if %>
				<li>
					<p>משתמשים רשומים</p>
					<span><% = users %></span>
				</li>
				<li>
					<p>נפח מקסימלי</p>
					<span><% = ConvertBytes(Getconfig("maxfoldersize")) %></span>
				</li>
				<li>
					<p>נפח קבצים</p>
					<span><% = ConvertBytes(SiteSize) %></span>
				</li>
				<li>
					<p>סה"כ כניסות לאתר</p>
					<span><% = Getconfig("Clicks") %></span>
				</li>
				<li>
					<p>קרדיט SMS</p>
					<span><% = Getconfig("smscredit") %></span>
				</li>
			</ul>
		</div>
	</div>