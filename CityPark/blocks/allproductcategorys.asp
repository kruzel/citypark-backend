<!--#include file="../config.asp"-->
<%
PageType="Product"	
If Request.QueryString("ID") = "" Then
    bringproducts 0
Else
    bringproducts Request.QueryString("ID")
End If
Function bringproducts(Id)
        SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE LangID = '" & Session("SiteLang") & "' "
        SQL = SQL & " AND (Content.SiteID = " & SiteID & ")"
        SQL = SQL & " AND (Contentfather.FatherID = " & Id & ")" 
        SQL = SQL & " AND (Contenttype = 2) ORDER By Menusorder ASC"
	TemplateURL = templatelocation & "productcategorys.html" 
	Set objRs = OpenDB(SQL)
	objRs.PageSize = 10

	If objRs.RecordCount = 0 Then
	        print("<p align='center'>אין מוצרים בקטגוריה זאת <a href='javascript:history.go(-1)'> לחזרה לחץ כאן</a>!</p>")
	Else
		HowMany = 0
		Do While Not objRs.EOF And HowMany < objRs.PageSize
        SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE LangID = '" & Session("SiteLang") & "' "
        SQ2L = SQL2 & " AND (Content.SiteID = " & SiteID & ")"
        SQL2 = SQL2 & " AND (Contentfather.FatherID = " & objRs("Id") & ")" 
        SQL2 = SQL2 & " AND (Contenttype = 2) ORDER By Menusorder ASC"
        Set objRs2 = OpenDB(SQL2)
            If objRs2.Recordcount > 0 then
                Link = "productcategorys.asp?ID=" &  objRs("Id")
                Subcategory = "<a href=""productcategorys.asp?ID=" &  objRs("Id") & """>תת קטגוריות</a>"
            Else
            Link = "products.asp?ID=" &  objRs("Id")
                Subcategory = "<a href=""/" &  objRs("Urltext") & """>מוצרים</a>"
            End If
        CloseDB(objRs2)
				   Template = GetURL(TemplateURL)
					For Each Field In objRs.Fields
					value = objRs(Field.Name)
						If Len(value) > 0 Then
							Template = Replace(Template, "[" & Field.Name & "]", value)
							Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
							Template = Replace(Template, "[Adminname]", Adminname)
							Template = Replace(Template, "[Subcategory]", Subcategory)
						Else
							
							Template = Replace(Template, "[Subcategory]", Subcategory)
							Template = Replace(Template, "[urlfacebook]",urlfacebook)
							Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
					Next
							 ProcessLayout(Template)
			HowMany = HowMany + 1
			objRs.MoveNext
		Loop

	objRs.Close 
    End if
End Function
%>