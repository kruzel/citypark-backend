<!--#include file="../config.asp"-->

<%
Set objRsForum = OpenDB("Select * From [Forums] Where ID = " & Request.QueryString("ID"))

CheckSecurity_Level Int(objRsForum("ReadAccessLevel"))

SetSession "BackURL", Request.ServerVariables("URL") & "?" & Request.QueryString
			SetPageTitle ""
			SetPageTitle objRsForum("Title")
			SetPageDesc ""
			SetPageDesc objRsForum("Description")
			SetPagekeywords ""
			SetPagekeywords objRsForum("keywords")

Header

Sub ViewTopics_Header()
		
	Template = GetURL(templatelocation   & "forum/viewtopics_header.html")


	For Each Field In objRsForum.Fields
		value = objRsForum(Field.Name)
			
		If Len(value) > 0 Then
			Template = Replace(Template, "[" & Field.Name & "]", value)
		End If
	Next
		
	ProcessLayout Template
End Sub
	
Sub ViewTopics_Footer()
	ProcessLayout GetURL(templatelocation   & "forum/viewtopics_footer.html")
End Sub

ViewTopics_Header

NormalTemplate = GetURL(templatelocation   & "forum/viewtopics_message.html")
NormalContentTemplate = GetURL(templatelocation   & "forum/viewtopics_content.html")

Color = 1

Sub PrintComments(Father, Level)
	
	SQL = "Select * From [ForumMessage] Where Father = " & Father & " And ForumID = " & Request.QueryString("ID") & " And Active = 1 And SiteID = " & SiteID & " ORDER BY date DESC"
	
	Set objRsMessage = OpenDB(sql)	
	
	Do Until objRsMessage.Eof	
		Template = NormalTemplate
		ContentTemplate = NormalContentTemplate
			
		For Each Field In objRsMessage.Fields
			value = objRsMessage(Field.Name)
			
			If Len(value) > 0 Then
				Template = Replace(Template, "[" & Field.Name & "]", value)
				ContentTemplate = Replace(ContentTemplate , "[" & Field.Name & "]", value)
			End If
		Next
		
		If Father = 0 Then
			If Color = 1 Then Color = 2 Else Color = 1
			
			Template = Replace(Template, "[FatherClass]", "ForumMessageFather")
		Else
			Template = Replace(Template, "[FatherClass]", "ForumMessageComment")

		End If
		
		Template = Replace(Template, "[RowID]", Color)
		ContentTemplate = Replace(ContentTemplate, "[RowID]", Color)

		Template = Replace(Template, "[Space]", Level * 10)
		
		If Father = 0 Then
			Template = Replace(Template, "[GetFatherID]", objRsMessage(0))
		Else
			Template = Replace(Template, "[GetFatherID]", objRsMessage("Father"))
		End If
		
		Print Template
		Print ContentTemplate
		
		PrintComments objRsMessage(0), Level + 1
		
		objRsMessage.MoveNext

	Loop
	
End Sub

PrintComments 0, 0

ViewTopics_Footer
	CloseDB(objRsForum)
Bottom

%>