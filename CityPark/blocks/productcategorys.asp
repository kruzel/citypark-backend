<!--#include file="../config.asp"-->
<%
'Header
PageType="Product"	
	If Request.Querystring("ID") = "" then
	SQL="SELECT * FROM ProductCategory WHERE  CategoryFatherID=0 AND SiteID = " & SiteID & " Order By ProductCategoryID ASC"
	Else
	SQL="SELECT * FROM ProductCategory WHERE  CategoryFatherID=" & GetSession("ProductCategoryID") & " AND SiteID = " & SiteID & " Order By ProductCategoryID ASC"
	
	End If
	TemplateURL = templatelocation & "categories.html" 
	Set objRs = OpenDB(SQL)
	objRs.PageSize = 10
	If objRs.PageCount <> 1 Then
	%>
		      	<table width=100% cellspacing="0" cellpadding="4">
		  		<% If Not objRs.PageCount = 0 Then
				If Len(Request.QueryString("page")) > 0 Then
				objRs.AbsolutePage = Request.QueryString("page")
				Else
				objRs.AbsolutePage = 1
				End If %>
				<% 	End If%>
					<div align="center">
					<table border="0" width="250" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="166">
							<img border="0" src="../../images/right.png" width="16" height="16" align="left"></td>
							<td width="177"><font size="2" face="Arial">
							<div align="center">
	<% If objRs.AbsolutePage > 1 Then %>
					<a href="Sc.asp?ID=<% = Request.querystring("ID") %>&page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					<font color="#808080"><% = SysLang("prevpage") %></font></a>
	
				
					</td>
					<td width="25">
					<font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					</td>
					<td width="155">
					<font size="2" face="Arial">
					<div align="center">
	<% If objRs.AbsolutePage < objRs.PageCount Then %>
					<a href="Sc.asp?ID=<% = Request.querystring("ID") %>&page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
					<font color="#808080"><% = SysLang("nextpage") %></font></a>
	
					</font></td>
							<td width="167"><font size="2" face="Arial">
							<img border="0" src="../../images/left.png" width="16" height="16" align="right"></font></td>
						</tr>
					</table>
	
<%End If
	
	If objRs.RecordCount = 0 Then
		  If Session("SiteLang") = 1 Then
		  	    print("<p align='center'>אין מוצרים בקטגוריה זאת <a href='javascript:history.go(-1)'> לחזרה לחץ כאן</a>!</p>")
	      Else
	            print("<p align='center'>No products in this category <a href='javascript:history.go(-1)'> press here to back</a>!</p>")
       End If
	Else
		HowMany = 0
		Do While Not objRs.EOF And HowMany < objRs.PageSize

			Template = GetURL(TemplateURL)
			
			For Each Field In objRs.Fields
				value = objRs(Field.Name)
				
				If Len(value) > 0 Then
					Template = Replace(Template, "[" & Field.Name & "]", value)
				End If
			Next
						Response.Write Template
			SQL2="SELECT * FROM ProductCategory WHERE  CategoryFatherID= " & objRs("ProductCategoryID") & " Order By ProductCategoryID ASC"
			Set objRs2 = OpenDB(SQL2)
			categorys=objRs2.Recordcount
			CloseDB(objRs2)
			If categorys > 0 then
			print "<a href=ProductCategorys.asp?ID=" & objRs("ProductCategoryID")& ">ישנם"&" " & categorys & " " & "תת קטגוריות </a>"
			Else
			SQL2="SELECT * FROM Product WHERE  ProductCategoryID= " & objRs("ProductCategoryID") & " Order By ProductID ASC"
			Set objRs2 = OpenDB(SQL2)
			products=objRs2.Recordcount
			CloseDB(objRs2)
			If products > 0 then
			print "<a href=ProductCategory.asp?ID=" & objRs("ProductCategoryID")& ">ישנם"&" " & products & " " & "מוצרים </a>"
			Else
			print "ישנם"&" " & products & " " & "מוצרים "
			End If

			end if
			print "</td></tr></table></form></div>"

			HowMany = HowMany + 1
			objRs.MoveNext
		Loop
	End If	

	objRs.Close  
'Bottom
%>