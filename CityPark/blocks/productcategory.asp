<!--#include file="../config.asp"-->
<%	
    Set objRsCategory = OpenDB("SELECT Template, ProductCategoryDesc, categoryblockrecords, shopproductsOrder, showNextPrevinblock FROM ProductCategory WHERE ProductCategoryID=" & GetSession("ProductCategoryID"))
		TemplateURL = templatelocation  & objRsCategory("Template") 
		PageSize = objRsCategory("categoryblockrecords")
		showPrevNext = objRsCategory("showNextPrevinblock")
	CloseDB(objRsCategory)
	Set objRsConfig = OpenDB("Select shopproductsOrder From ShopConfig WHERE SiteID= " & SiteID)
	SQL = "SELECT Product.*, ProductsPerCategory.categoryID AS ProductCategoryId, Product.SiteID FROM Product INNER JOIN ProductsPerCategory ON Product.ProductID = ProductsPerCategory.ProductID AND Product.SiteID = ProductsPerCategory.SiteID WHERE ProductsPerCategory.categoryID= " & GetSession("ProductCategoryID")& " AND Product.SiteID = " & SiteID & " ORDER BY " & objRsConfig("shopproductsOrder")
	CloseDB(objRsConfig)
	Set objRs = OpenDB(SQL)
	objRs.PageSize = int(PageSize)
	
	If objRs.RecordCount = 0 Then
		  If Session("SiteLang") = 1 Then
		  	    print("<p align='center'>אין מוצרים בקטגוריה זאת <a href='javascript:history.go(-1)'> לחזרה לחץ כאן</a>!</p>")
	      Else
	            print("<p align='center'>No products in this category <a href='javascript:history.go(-1)'> press here to back</a>!</p>")
       End If
	Else
	    If objRs.Recordcount > PageSize AND showPrevNext = 1 Then
	        pager()
        End If
    
    Do While Not objRs.EOF And HowMany < PageSize
	
	      Template = GetURL(TemplateURL)
			For Each Field In objRs.Fields
				value = objRs(Field.Name)
				
				If Len(value) > 0 Then
					Template = Replace(Template, "[" & Field.Name & "]", value)
					Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))

				End If
			Next
			
			Response.Write Template
		HowMany = HowMany + 1
	
        objRs.MoveNext
		    Loop
	 If objRs.Recordcount > PageSize AND showPrevNext = 1 Then
	        pager()
        End If
End If
	CloseDB(objRs)
	
 %>