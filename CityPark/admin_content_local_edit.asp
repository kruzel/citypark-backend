<!--#include file="config.asp"-->

 <% 
CheckSecuirty "Content"
Header
	If Request.QueryString("mode") = "doit" Then
	  SQL = "SELECT [Content].id,[Content].Text, [Content].EditadminID, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.ContentID = " & Request.Querystring("ID") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1) ORDER By ItemOrder ASC"

			Set objRs = OpenDB(SQL)	

		
				objRs("Text") = Request.Form("Text")
				objRs("EditadminID") = Session(SiteID & "AdminID")
				objRs.Update
			objRs.Close
Response.Status="301 Moved Permanently"
Response.AddHeader "Location",  Replace(Getsession("backURL")," ","-")& "&notificate=" & Server.UrlEncode("הדף נערך בהצלחה")

    '	Response.Write("<br><br><p align='center'>תוכן נערך בהצלחה. <a href='/" & Replace(Getsession("backURL")," ","-") & "'>לחץ להמשך</a>!</p>")
	'	Response.Write("<meta http-equiv='Refresh' content='1; URL=/" & Replace(Getsession("backURL")," ","-")  & "'>")
	
	Else
	  SQL = "SELECT [Content].id,[Content].Text, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.Contentid = " & Request.Querystring("ID") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1) ORDER By ItemOrder ASC"

	Set objRs = OpenDB(SQL)	
	    Set objRssecurity = OpenDB("select * from Contentfather where ContentId=" & Request.Querystring("ID"))	
	    Do while not objRssecurity.eof
       if objRssecurity("FatherID") = 0 then
            CheckCategorySecuirty(objRssecurity("ContentID"))
        else
            CheckCategorySecuirty(objRssecurity("FatherID"))
       End if
		objRssecurity.movenext
            loop				    		
    CloseDB(objRssecurity)

			If 	objRs.recordcount = 0 then
		print "אין אפשרות לעריכה במצב הזה ניתן לערוך דרך מערכת הניהול"
	Else
 %>
<form name="News" action="admin_Content_local_edit.asp?mode=doit&ID=<%= Request.Querystring("ID")%>&S=<% = SiteID %>" method="post">
<%
					Dim oFCKeditor
					Set oFCKeditor = New FCKeditor
					oFCKeditor.BasePath = "admin/FCKeditor/"
					oFCKeditor.Value= objRs("Text")
					oFCKeditor.width="100%"
					if Session("SiteLang") = "he-IL" Then
                        oFCKeditor.config("DefaultLanguage")= "he"
                        oFCKeditor.config("ContentLangDirection")= "rtl"
                    Else
                        oFCKeditor.config("DefaultLanguage")= "en"
                        oFCKeditor.config("ContentLangDirection")= "ltr"
                    End If
					oFCKeditor.Create "Text"
				%>
				<p align="center"><input type="submit" value="שמור" name="B1"></p>

			</form>
<%		objRs.Close
	End if
bottom
	End if

%>