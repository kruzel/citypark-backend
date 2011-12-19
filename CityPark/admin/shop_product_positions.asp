<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--#include file="../config.asp"-->
<%
CheckSecuirty "Product"
%>
<%
Response.Buffer = True
Server.ScriptTimeout = 150
%>
		<!--#include file="inc_admin_icons.asp"-->
<%		If Request.QueryString("mode") = "doit" Then
			SQL = "SELECT *, Product.*, ProductsPerCategory.categoryID AS categoryID FROM  Product INNER JOIN ProductsPerCategory ON Product.ProductID = ProductsPerCategory.ProductID INNER JOIN ProductCategory ON ProductsPerCategory.categoryID = ProductCategory.ProductCategoryID WHERE ProductsPerCategory.categoryID = " & Request.QueryString("ProductCategoryID")& " Order By Product.ProductOrder ASC"

			If Request.QueryString("ProductID") = "" Then
				Set objRs = OpenDB(SQL)
				'Set objRs = OpenDB("SELECT ProductID, Productorder FROM Product WHERE ProductCategoryID= " & Request.Querystring("ProductCategoryID"))
			Else	
			print OpenDB("SELECT ProductID, Productorder FROM Product WHERE ProductCategoryID = " & Request.QueryString("ProductID") & "AND ProductCategoryID= " & Request.Querystring("ProductCategoryID"))
				
				'Set objRs = OpenDB("SELECT ProductID, Productorder FROM Product WHERE ProductCategoryID = " & Request.QueryString("ProductID") & "AND ProductCategoryID= " & Request.Querystring("ProductCategoryID"))
			End If
			Do While Not objRs.EOF
			
				objRs("Productorder") = Request.Form("ID" & objRs("ProductID"))
				objRs.MoveNext
				
			
			Loop	
			
			objRs.Close		
			
			Application.Lock 
				
				Application(ScriptName & "ConfigLoaded") = ""
				
			Application.UnLock 			
				
			Response.Write("<br><br><p align='center'>מיקום שונה בהצלחה. <a href='shop_ProductCategory.asp'>לחץ להמשך</a>!</p>")
			Response.Write("<meta http-equiv='Refresh' content='1; URL=shop_ProductCategory.asp'>")
	
		Else
				SQL = "SELECT *, Product.*, ProductsPerCategory.categoryID AS categoryID FROM  Product INNER JOIN ProductsPerCategory ON Product.ProductID = ProductsPerCategory.ProductID INNER JOIN ProductCategory ON ProductsPerCategory.categoryID = ProductCategory.ProductCategoryID WHERE ProductsPerCategory.categoryID = " & Request.QueryString("ProductCategoryID")& " Order By Product.ProductOrder ASC"
				Set objRs = OpenDB(SQL)

			
			Positions = objRs.RecordCount
%>
			<form action="shop_product_positions.asp?mode=doit&ProductCategoryID=<% = Request.Querystring("ProductCategoryID")%>" method="post">
	<div align="center">
	<table width="500"  border="0" cellpadding="0" cellspacing="0" dir=rtl>
			  <tr valign=top>
			    <td>
			    <table class="Main" border="0" width="100%" cellspacing="1" cellpadding="4">
			      <tr>
			        <td class="Head" colspan="2">
			          <b>שינוי סדר הופעת כתבות</b>
			        </td>				        			        
			      </tr>
			      <tr>
			        <td valign="top">
			          <b>שם</b>
			        </td>
			        <td align="center" valign="top">
			          <b>מיקום</b>
			        </td>				        				        			        
			      </tr>			      
			      <%
			      Do While Not objRs.EOF
			        %>			  
					<tr>
						<td valign="top">
						  <% = objRs("ProductName") %>
						</td>
						<td valign="top" align="center">
						  <select name="ID<% = objRs("ProductID") %>">
						    
						    <% For pRun = 1 To Positions %>
							
								<option value="<% = pRun %>" <% If objRs("Productorder") = pRun Then Response.Write(" selected") %>><% = pRun %></option>
							
							<% Next %>
							
						  </select>
						</td>
					</tr>	
					<%
					Response.Flush 
					objRs.MoveNext
				  
				  Loop
				  %>
				  <tr>
				    <td align="center" colspan="2">
				      <input type="submit" value="הגדר מיקומים חדשים">
				    </td>
				  </tr>			  
				  <tr>
				    <td class="Head" align="left" colspan="2">
				      <a class="Head" href="admin_Product.asp">חזור</a>
				    </td>
				  </tr>				  			  		      
			    </table>
			    </td>
			  </tr>
			</table>
			</div>
			</form>
<%
			objRs.Close		
			
		End if
%>