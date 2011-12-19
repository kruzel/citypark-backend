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


 if request.querystring("ajax") = "1" then 
  Function buildtree(id,x,i)
   If Request.QueryString("action") = "edit" then
        SQLw = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 2) AND (Content.Id !=" & Request.QueryString("id") & ")  ORDER By LangID ASC,ItemOrder ASC"
  Else      
         SQLw = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 2)  ORDER By LangID ASC,ItemOrder ASC"
  End if 
   Set objRsw = OpenDB(SQLw)
        Do while Not objRsw.EOF
        
        actives = " "
        If Request.QueryString("id") <> "" Then
         SQLt = "SELECT  * FROM [Contentfather]  WHERE ContentID = " & Request.QueryString("id")
         Set objRst = OpenDB(SQLt)
             Do while Not objRst.EOF
            If int(objRst("FatherID")) = objRSw("id")  then
                actives = "True"
            End If
          objRst.movenext
            loop
        CloseDB(objRst)
        End If
		   
           
            print vbCrLf & "  <li id=""phtml_" & x &""""  & "><a href=""#""><input type=""checkbox"" name=""category_" & x & objRSw("id") & """"
             if actives = "True"  then
             print  " checked=""checked"""
             End If
             print   " />" & objRSw("Name") & "</a>"

         SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRSw("id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 2)  ORDER By ItemOrder ASC"
   Set objRsSon = OpenDB(SQL2)
         If objRsSon.Recordcount > 0 Then
            print  vbCrLf & "    <ul>" 
                buildtree objRSw("id"),x,i+1 
            print "</li>" & vbCrLf
         Else
            print "</li>" & vbCrLf
           CloseDB(objRsSon)		

         End If 
    i=1
    x=x+1
   objRsw.MoveNext
	  Loop
print "</ul>" & vbCrLf
	CloseDB(objRsw)		
    End Function


 %>
<div id="tree">
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
<li id="phtml_0"><a href="#"><input type="checkbox"<% if  actives = "True"  Or request.querystring("editmode") = "False" then%> checked="1" <% End If %>" name="category_10000000" />ראשי</a></li>
	<% buildtree 0,100000,1  %>
</div>
<% end if %>

<% if request.querystring("ajax") = "2" then %>
  <%
							Set objRsr = OpenDB("SELECT * FROM Content Where Contenttype = 2 AND SiteID= " & SiteID & " ORDER BY Name")			
							Do Until objRsr.Eof
								Selected = False
								If request.querystring("editmode") = "True" Then
									If request.querystring("objrs") <> "" Then
										IDArray = Split(request.querystring("objrs"), ",")
										
									For Each TheID In IDArray 							
										If Int(TheID) = objRsr(0) Then
											Selected = True
										End If
									Next
								End If
								End If
								
								%>
								<p><input type="checkbox" name="other8<% = objRsr(0) %>"<% If request.querystring("editmode") = "True" AND Selected Then%> checked="1"<% End If %> />
									<% = objRsr("Name") %></p>
												
								<%
								objRsr.MoveNext
							Loop						
											
						  objRsr.Close
						  Set objRsr= Nothing
						  end if
						  %>
						  
<% if request.querystring("ajax") = "3" then %>
  <%
							Set objRsMenuCategory = OpenDB("SELECT * FROM ProductFeaturesGroup Where SiteID= " & SiteID)			
							Do Until objRsMenuCategory.Eof
								Selected = False
								If request.querystring("editmode") = "True" Then
									If request.querystring("objrs") <> "" Then
										IDArray = Split(request.querystring("objrs"), ",")
										
									For Each TheID In IDArray 							
										If Int(TheID) = objRsMenuCategory(0) Then
											Selected = True
										End If
									Next
								End If
								End If
								
								%>
								<tr>
									<td><input type="checkbox" name="other7<% = objRsMenuCategory(0) %>"<% If request.querystring("editmode") = "True" AND Selected Then%> checked="1"<% End If %> /></td>
									<td><% = objRsMenuCategory("ProductFeaturesGroupName") %></td>
								</tr>				
								<%
								objRsMenuCategory.MoveNext
							Loop						
											
						  objRsMenuCategory.Close
						  Set objRsMenuCategory= Nothing
						  end if
						  %>
<% if request.querystring("ajax") = "4" then %>
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
         SQLt = "SELECT  * FROM [Contentfather]  WHERE ContentID = " & Request.QueryString("id")
         Set objRst = OpenDB(SQLt)
             Do while Not objRst.EOF
            If int(objRst("FatherID")) = objRSw("id")  then
                actives = "True"
            End If
          objRst.movenext
            loop
        CloseDB(objRst)
        End If
		   
           
            print vbCrLf & "  <li id=""phtml_" & x &""""  & "><a href=""#""><input type=""checkbox"" name=""category_" & x & objRSw("id") & """"
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
<%
 if request.querystring("ajax") = "5" then 
  Function buildtree5(id,x,i)
   If Request.QueryString("action") = "edit" then
   sqlx = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = 0) AND Content.SiteID=28 AND (Contenttype != 2) AND (Content.Id !=1244)  ORDER By LangID ASC,ItemOrder ASC"

        SQLw = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 2) AND (Content.Id !=" & Request.QueryString("id") & ")  ORDER By LangID ASC,ItemOrder ASC"
  Else      
         SQLw = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 2)  ORDER By LangID ASC,ItemOrder ASC"
  End if 
'print sqlw
  Set objRsw = OpenDB(SQLw)
        Do while Not objRsw.EOF
        
        actives = " "
        If Request.QueryString("id") <> "" Then
         SQLt = "SELECT  * FROM [Contentfather]  WHERE ContentID = " & Request.QueryString("id")
         Set objRst = OpenDB(SQLt)
             Do while Not objRst.EOF
            If int(objRst("FatherID")) = objRSw("id")  then
                actives = "True"
            End If
          objRst.movenext
            loop
        CloseDB(objRst)
        End If
		   
           
            print vbCrLf & "  <li id=""phtml_" & x &""""  & "><a href=""#""><input type=""checkbox"" name=""category_" & x & objRSw("id") & """"
             if actives = "True"  then
             print  " checked=""checked"""
             End If
             print   " />" & objRSw("Name") & "</a>"


         SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRSw("id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 2)  ORDER By ItemOrder ASC"
'print sql2
		 Set objRsSon = OpenDB(SQL2)
         If objRsSon.Recordcount > 0 Then
            print  vbCrLf & "    <ul>" 
                buildtree5 objRSw("id"),x,i+1 
            print "</li>" & vbCrLf
         Else
            print "</li>" & vbCrLf
           CloseDB(objRsSon)		

         End If 
    i=1
    x=x+1
   objRsw.MoveNext
	  Loop
print "</ul>" & vbCrLf
	CloseDB(objRsw)		
    End Function


 %>
<div id="tree">
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
<li id="phtml_0"><a href="#"><input type="checkbox"<% if  actives = "True"  Or Request.QueryString("action") = "add" then%> checked="1" <% End If %>" name="category_10000000" />ראשי</a></li>
	<% buildtree5 0,100000,1  %>
</div>
<% end if %>


<% if request.querystring("ajax") = "c" then 
If Request.QueryString("lang") <> "" Then
               SQL = "SELECT [Content].*, Contentfather.FatherID, (SELECT count(*) as counter FROM Contentfather WHERE FatherID = [Content].id) AS COUNTER FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = "&request.querystring("id")&") AND Content.SiteID=" & SiteID & " AND  (Contenttype != 2)  AND (LangID LIKE '%" & Request.querystring("lang") & "%') ORDER By LangID ASC,ItemOrder ASC"
        Else
               SQL = "SELECT [Content].*, Contentfather.FatherID, (SELECT count(*) as counter FROM Contentfather WHERE FatherID = [Content].id) AS COUNTER FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = "&request.querystring("id")&") AND Content.SiteID=" & SiteID & " AND  (Contenttype != 2)  ORDER By LangID ASC,ItemOrder ASC"
        End If
		Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	        objRsg.PageSize = Session("records")
                HowMany = 0
                fatherID =  objRsg("Id")
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize

%>
<tr class="parent collapsed" style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td  style="width:8%;"><%= objRsg("Id")  %></td>
		<td style="width:36%;" class="editlocalbig" style="padding:0 32px 0 0;text-align:right;">	
	
				<% If objRsg("counter") > 0 Then%>
			<span onclick="bringcontent(<%= objRsg("Id")  %>,<%=(cint(request.querystring("p"))+1)%>,this)" style="float:right;cursor:pointer;text-align:left;width:<%=(cint(request.querystring("p"))+1)*5%>%;">
			<img src="/admin/images/plus.png" style="border:0">
			</span>
			<%else %>
			<span style="float:right;cursor:pointer;width:<%=(cint(request.querystring("p"))+1)*5%>%;">
		&nbsp;
			</span>
			<% end if %>
			<div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_Name">
				<% = objRsg("Name") %>
			</div>
		</td>
        <td style="width:8%;"><%= Langname(objRsg("LangID"))  %></td>
        <td class="editlocal" style="width:8%;">
		<div class="inlinetext" id="<% = objRsg("id") %>_Itemorder"><%= objRsg("Itemorder") %></div>
        </td>
		<td style="width:8%;" class="editlocal">
	<% If objRsg("counter") > 0 Then %>
        <a href="admin_content_positions.asp?type=content&ID=<% = objRsg("Id") %>&action=edit" class="_dialog { width: 500, title:'יש לגרור את הדפים לפי הסדר הרצוי',modal:true,position:top}"><img src="images/order.gif" border="0" alt="סדר בנים" /></a>
        <% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/order.gif" border="0" alt="סדר בנים" />
		<% End If %>
        </td>
          <% If  objRsg("Contenttype") = 1 Then %>  
                <td style="width:8%;"><a href="admin_content.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
          <% End if %>
          <% If  objRsg("Contenttype") = 4 Then %>  
                <td style="width:8%;"><a href="admin_gallery.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
          <%  End if %> 
          <% If  objRsg("Contenttype") = 6 Then %>  
                <td style="width:8%;"><a href="admin_videos.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
          <%  End if %> 
        <td style="width:8%;"><a href="admin_content.asp?ID=<% = objRsg("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td style="width:8%;"><% If objRsg("Active")= 1 Then %><img style="border:0px;" src="images/active.png" border="0" alt="" /><% Else %><img style="border:0px;" src="images/notactive.png" border="0" alt="" /><% End if %></td>
        <td style="border-left:0px;"><%If objRsg("counter") = 0 Then %><a href="admin_content.asp?ID=<% = objRsg("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a>
		<% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/delete.gif" border="0" alt="מחק" />
		<% End If %></td>

	</td>
       
    </tr>	
	<tr id="h<%=objRsg("Id")%>" style="display:none">
	<td colspan="9"><table id="t<%=objRsg("Id")%>" width="100%"><td>טוען...</td></table></td>
	
	</tr>
	<%
	if not stay then color = not color
				
                 HowMany = HowMany + 1
                objRsg.MoveNext
		  		Loop
                objRsg.Close
                End If
				%> 
<% end if %>
	<% if request.querystring("ajax") = "p" then 
If Request.QueryString("lang") <> "" Then
               SQL = "SELECT [Content].*, Contentfather.FatherID, (SELECT count(*) as counter FROM Contentfather WHERE FatherID = [Content].id) AS COUNTER FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = "&request.querystring("id")&") AND Content.SiteID=" & SiteID & " AND  (Contenttype = 2)  AND (LangID LIKE '%" & Request.querystring("lang") & "%') ORDER By LangID ASC,ItemOrder ASC"
        Else
               SQL = "SELECT [Content].*, Contentfather.FatherID, (SELECT count(*) as counter FROM Contentfather WHERE FatherID = [Content].id) AS COUNTER FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = "&request.querystring("id")&") AND Content.SiteID=" & SiteID & " AND  (Contenttype = 2)  ORDER By LangID ASC,ItemOrder ASC"
        End If
		Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	        objRsg.PageSize = Session("records")
                HowMany = 0
                fatherID =  objRsg("Id")
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize

%>
     <tr id="node-<%= objRsg("Id") %>" <% if id <> 0 Then %>class="child-of-node-<%= id %>"<% end if %> style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td  style="width:12%;"><%= objRsg("Id")  %></td>
		
		<td style="width:36%;text-align:right;" class="editlocalbig">	
			<% If objRsg("counter") > 0 Then%>
			<span onclick="bringproduct(<%= objRsg("Id")  %>,<%=(cint(request.querystring("p"))+1)%>,this)" style="text-align:left;float:right;cursor:pointer;width:<%=(cint(request.querystring("p"))+1)*5%>%;">
			<img src="/admin/images/plus.png" style="border:0">
			</span>
			<% else %>
			<span  style="float:right;cursor:pointer;width:<%=(cint(request.querystring("p"))+1)*5%>%;">
			&nbsp;
			</span>
			<% end if %>
			<div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_Name">
				<% = objRsg("Name") %>
			</div>
		</td>  
        <td class="editlocal"  style="width:9%;"><div class="inlinetext" id="<% = objRsg("id") %>_Itemorder"><%= objRsg("Itemorder") %></div>
        </td>
		<td class="editlocal"  style="width:9%;">
		<% If objRsg("counter") > 0 Then %>
        <a href="admin_product_positions.asp?type=product&ID=<% = objRsg("Id") %>&action=edit" class="_dialog { width: 500, title:'יש לגרור את הדפים לפי הסדר הרצוי',modal:true,position:top}"><img src="images/order.gif" border="0" alt="סדר בנים" /></a>
        <% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/order.gif" border="0" alt="סדר בנים" />
		<% End If %>
        </td>
        <td  style="width:9%;"><a href="admin_product.asp?ID=<% = objRsg("Id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td  style="width:9%;"><a href="admin_product.asp?ID=<% = objRsg("Id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td  style="width:9%;"><% If objRsg("Active")= 1 Then %><img style="border:0px;" src="images/active.png" border="0" alt="" /><% Else %><img style="border:0px;" src="images/notactive.png" border="0" alt="" /><% End if %></td>
        <td style="border-left:0px;width:6%;"><%If objRsg("counter") = 0 Then %><a href="admin_product.asp?ID=<% = objRsg("Id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a>
		<% Else %>
		<img style="opacity:0.30;-ms-filter:progid:DXImageTransform.Microsoft.Alpha(opacity=30);filter:alpha(opacity=30);zoom:1" src="images/delete.gif" border="0" alt="מחק" />
		<% End If %></td>
       
    </tr>	
	<tr id="h<%=objRsg("Id")%>" style="display:none">
	<td colspan="8"><table id="t<%=objRsg("Id")%>" width="100%"><td>טוען...</td></table></td>
	
	</tr>
	<%
	if not stay then color = not color
				
                 HowMany = HowMany + 1
                objRsg.MoveNext
		  		Loop
                objRsg.Close
                End If
				%> 
<% end if %>
						  					  
											  				
<% if request.querystring("ajax") = "7" then %>
  <%
							Set objRsr = OpenDB("SELECT * FROM Content Where Contenttype = 2 AND SiteID= " & SiteID & " ORDER BY Name")			
							Do Until objRsr.Eof
								Selected = False
								If request.querystring("editmode") = "True" Then
									If request.querystring("objrs") <> "" Then
										IDArray = Split(request.querystring("objrs"), ",")
										
									For Each TheID In IDArray 							
										If Int(TheID) = objRsr(0) Then
											Selected = True
										End If
									Next
								End If
								End If
								
								%>
								<p><input type="checkbox" name="nilvim<% = objRsr(0) %>"<% If request.querystring("editmode") = "True" AND Selected Then%> checked="1"<% End If %> />
									<% = objRsr("Name") %></p>
												
								<%
								objRsr.MoveNext
							Loop						
											
						  objRsr.Close
						  Set objRsr= Nothing
						  end if
						  %>		  					  