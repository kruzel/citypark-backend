<!--#include file="config.asp"-->
 <% 
    If Int(Request.QueryString("header")) = 1 Then
		Header
	End If
 %>
<body id="videobody">
<%	

	SQL = "SELECT * FROM video WHERE videoID = " & Request.QueryString("ID") & " And SiteID=" & SiteID

			Set objRs = OpenDB(SQL)
			If objRs.RecordCount = 0 Then
				header
				Response.Write("<div id=""errormeseage"">����� ���� ���� !</div>")
				bottom
				response.end
			End If
			
			SQLCategory = "SELECT videocategoryID, videocategorytemplate FROM videocategory WHERE videocategoryID = " & objRs("videoCategoryID") & " And SiteID=" & SiteID
			Set objRsCategory = OpenDB(SQLCategory)



			If objRs.BOF And objRs.EOF Then 
							Response.write("<div id=""errormeseage"">")
							Response.write("����� ���� ���� ������ ���� ����� ���� ��� ����!")
							Response.write("</div>")
							Response.write("</div>")
			 Else
					TemplateURL = templatelocation  & "videotemplates/" & objRs("template") 
					ProcessLayout GetRecordSetTemplate(GetURL(TemplateURL), objRs)
							
 				End If
 			
		'	objRs.Close
			objRsCategory.Close

    If Int(Request.QueryString("bottom")) = 1 Then
		bottom
	End If
 %>