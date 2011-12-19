<!--#include file="../config.asp"-->

<%

Header
Sub Forums_Header()
	Print GetURL(templatelocation  & "forum/forums_header.html")
End Sub
	
Sub Forums_Footer()
	Print GetURL(templatelocation & "forum/forums_footer.html")
End Sub

Forums_Header

NormalTemplate = GetURL(templatelocation & "forum/forums_content.html")

Set objRsForum = OpenDB("Select * From [Forums] Where SiteID = " & SiteID)	
	
Do Until objRsForum.Eof	
	Template = NormalTemplate
			
	For Each Field In objRsForum.Fields
		value = objRsForum(Field.Name)
		
		If Len(value) > 0 Then
			Template = Replace(Template, "[" & Field.Name & "]", value)
		End If
	Next
		
	Print Template
				
	objRsForum.MoveNext
Loop

CloseDB(objRsForum)

Forums_Footer
Bottom

%>