  <!--#include file="../config.asp"-->
  <%
  Function Langname(langID)
select case langID
case "en-US"
case "he-IL"
Langname= "He-עברית"
case "ru-RU"
Langname= "Rusian-Ru"
case "en-GB"
Langname= "English-Gb"
case "de-DE"
Langname= "Dautch-De"
End Select
Langname = "<img src=""/admin/flags/" & langID & ".png"" width=""20"" height=""13"" style=""float:none"" />"
End Function


if request.querystring("ajax") = "4" then %>
   <%
  Function buildtree4(id,x,i)
		If Request.QueryString("action") = "edit" then
        SQLw = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype != 2) AND (Content.Id !=" & Request.QueryString("id") & ")  ORDER By LangID ASC,ItemOrder ASC"
  Else      
         SQLw = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype != 2)  ORDER By LangID ASC,ItemOrder ASC"
  End if 
   Set objRsw = OpenDB(SQLw)
        Do while Not objRsw.EOF
        
        actives = " "
        If Request.QueryString("id") <> "" Then
         SQLt = "SELECT  Categorys FROM [Users]  WHERE Id = " & Request.QueryString("id")
         Set objRst = OpenDB(SQLt)
            If objRst("Categorys") <> "" Then
				For Each r In Split(objRst("Categorys"), ",")
					If Int(objRsw("Id")) = int(r) Then
						actives = True
						Exit For
					End If
				Next
			end if
        CloseDB(objRst)
        End If
		   
           
            print vbCrLf & "  <li id=""phtml_" & x &""""  & "><a href=""#""><input type=""checkbox"" name=""Uategory_" & x & objRSw("id") & """"
             if actives = "True"  then
             print  " checked=""checked"""
             End If
             print   " />" & Langname(objRSw("LangID")) & "&nbsp;" & objRSw("Name") & "</a>"

         SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRSw("id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)  ORDER By ItemOrder ASC"
   Set objRsSon = OpenDB(SQL2)
         If objRsSon.Recordcount > 0 Then
            print  vbCrLf & "    <ul>" 
                buildtree4 objRSw("id"),x,i+1 
            print "</li>" & vbCrLf
         Else
            print "</li>" & vbCrLf
         End If 
    i=1
    x=x+1
   objRsw.MoveNext
	  Loop
print "</ul>" & vbCrLf
	'CloseDB(objRsSon)		
	CloseDB(objRsw)		
    End Function


 %>
<div id="tree" style="margin:0 0 10px;padding:0 0 5px;">
<ul>
<%        If Request.QueryString("id") <> "" Then
         SQLt = "SELECT  * FROM [Contentfather]  WHERE ContentID = " & Request.QueryString("id")
         Set objRst = OpenDB(SQLt)
             Do while Not objRst.EOF
            If int(objRst("FatherID")) = 0  then
                actives = "True"
            End If
          objRst.movenext
            loop
        CloseDB(objRst)
        End If
 %>
<li id="phtml_0"><a href="#"><input type="checkbox"<% if  actives = "True"  Or Request.QueryString("action") = "add" then%> checked="1" <% End If %>" name="category_10000000" />ראשי</a>
<ul>
	<% buildtree4 0,100000,1  %>
</li>
</ul>
                   
</div>
<% end if %>
		  					  