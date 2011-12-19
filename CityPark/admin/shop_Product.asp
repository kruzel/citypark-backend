<!--#include file="../config.asp"-->
<!--#include file="../$db.asp"-->
<!--#include file="inc_admin_icons.asp"-->
<head>
    <style type="text/css">
        .style1
        {
            width: 6px;
        }
    </style>
</head>
<%	
CheckSecuirty "Product"
		URL = "SELECT * FROM Product WHERE SiteID=" & SiteID & " ORDER BY ProductID DESC"
	If Request.QueryString("mode") = "search" then
			URL = "SELECT * FROM Product WHERE SiteID=" & SiteID & " AND ProductName LIKE '%" & Request.form("search") & "%'" & " ORDER BY ProductID DESC"
	End If
	Set objRs = OpenDB(URL)
	objRs.PageSize=20

%>
<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td background="/images/menuin.jpg" height="30" width="360">
	<div align="right">
	<font color="#FFFFFF" face="Arial" size="2">
	<b>&nbsp;<span lang="he">ניהול 
	מוצרים</span> </b>(<span lang="he"> 
	<a href="shop_product_add.asp" style="text-decoration: none">
	<font color="#FFFFFF">הוסף מוצר</font></a> )</span></font></td>
		<td background="/images/menuin.jpg" height="30" width="338">
	<table align="left" border="0" border="0" dir="rtl" cellspacing="0" cellpadding="0">
<form style="margin:0px; width:200px;" action="shop_Product.asp?mode=search&S="<% = SiteID %> method="post">
  	<tr valign="top">
  		<td align="left">
  		<font face="Arial">
  		<input type="text" dir="rtl" name="search" style="width:100px;"><font size="2">
		</font>
  		<input type="submit" value="חפש" name="searchbtn"><font size="2"> </font>
		</font>
  		</td>
  	</tr>
</form>
</table></td></tr>
  	<tr valign="top">
		<td colspan="2">
	      	<table width=100% cellspacing="0" cellpadding="4">
		  		<% If Not objRs.PageCount = 0 Then
				If Len(Request.QueryString("page")) > 0 Then
				objRs.AbsolutePage = Request.QueryString("page")
				Else
				objRs.AbsolutePage = 1
				End If %>
				<% 	End If%>
				<tr>
					<td align="left" colspan="9">
					<font size="2" face="Arial">
					<div align="center">
					<table border="0" width="250" cellspacing="0" cellpadding="0">
						<tr>
							<td width="166">
							<font size="2">
							<img border="0" src="../images/right.png" width="16" height="16" align="left"></font></td>
							<td width="177"><font size="2" face="Arial">
							<div align="center">
	<% If objRs.AbsolutePage > 1 Then %>
					<a href="shop_Product.asp?page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none"><% End If%>
					<font color="#808080">דף קודם</font></a>
	
				
					</td>
					<td width="25">
					<font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font><font size="2">
					</font>
					</td>
					<td width="155">
					<font size="2" face="Arial">
					<div align="center">
	<% If objRs.AbsolutePage < objRs.PageCount Then %>
					<a href="shop_Product.asp?page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
					<font color="#808080">דף הבא</font></a>
	
					</font></td>
							<td width="167"><font size="2" face="Arial">
							<img border="0" src="../images/left.png" width="16" height="16" align="right"></font></td>
						</tr>
					</table>
					</div>
			    	</font></td>
		  		</tr>

	     		<tr>
	        			<td valign="top" width="56%" bgcolor="#eeeeee" align="right">
						<font face="Arial" size="2"><b>כותרת</b></td>
	        			<td valign="top" colspan="8" bgcolor="#eeeeee" align="right"><font face="Arial" size="2"><b>פעולות</b></font></td>
	      		</tr>		  
				<% HowMany = 0
		  		Do While Not objRs.EOF And HowMany < objRs.PageSize
				%>
				<tr align="right" onmouseover="Mark(this);" onmouseout="Unmark(this);">
			  		<td font face="Arial" size="2" ><a href="shop_Product_edit.asp?ID=<% = objRS("ProductID") %>&S=<% = SiteID %>" style="text-decoration: none">	
					<font size="2" color="#808080"><% = objRs("ProductName") %></a></font></td>
			 		<td width="30">
					<font face="Arial" size="2">
					<a href="shop_Product_edit.asp?ID=<% = objRS("ProductID") %>&S=<% = SiteID %>" style="text-decoration: none">	
					<font color="#808080">ערוך</font></a></font></td>
			 		<td width="16">
					<font face="Arial" size="2"><a href="shop_Menu_add.asp?src=Sc.asp?ID=<% = objRs("ProductID") %>&Headline=<% =objRs("ProductName") %>&S=<% = SiteID %>" style="text-decoration: none">
					<img border="0" src="/images/link.jpg" width="16" height="16"></a></font></td>
			 		<td width="60">
					<font face="Arial" size="2">
					<a href="shop_Menu_add.asp?src=Sc.asp?ID=<% = objRs("ProductID") %>&Headline=<% =objRs("ProductName") %>&S=<% = SiteID %>" style="text-decoration: none">
					<font color="#808080">צור כפתור</font></a></font></td>
			 		<td class="style1">	
					<font face="Arial" size="2">	<a href="shop_Product_copy.asp?ID=<% = objRs("ProductID") %>&Headline=<% =objRs("ProductName") %>&S=<% = SiteID %>" style="text-decoration: none">
					<img border="0" src="/images/copy.jpg" width="16" height="16"></a></font></td>
			 		<td width="50">
					<font face="Arial" size="2">
					<a href="shop_Product_copy.asp?ID=<% = objRs("ProductID") %>&Headline=<% =objRs("ProductName") %>&S=<% = SiteID %>" style="text-decoration: none">
					<font color="#808080">שכפל מוצר</font></a></font></td>
			 		<td width="16">
					<font face="Arial" size="2"><a href="shop_Product_delete.asp?ID=<% = objRS("ProductID") %>&S=<% = SiteID %>&St=No&Sb=No&Sr=No&Sl=No&Menu=Product" style="text-decoration: none">
					<img border="0" src="/images/delete.jpg" width="16" height="16"></a></font></td>
			 		<td width="35">
					<font face="Arial" size="2">
					<a href="shop_Product_delete.asp?ID=<% = objRS("ProductID") %>&S=<% = SiteID %>&St=No&Sb=No&Sr=No&Sl=No&Menu=Product" style="text-decoration: none">
					<font color="#808080">מחק</font></a>&nbsp;	</font></td>
				</tr>		      
				<% HowMany = HowMany + 1
				objRs.MoveNext
		  		Loop
				%>
		  		<tr>
					<td class="Head" align="left" colspan="9" bgcolor="#eeeeee">
					<font size="2" face="Arial">
					<div align="center">
					<table border="0" width="100%" cellspacing="0" cellpadding="0">
						<tr>
							<td width="165">
							&nbsp;</td>
							<td width="355">&nbsp;</td>
							<td width="165">&nbsp;</td>
						</tr>
					</table>
					</div>
			    	</font></td>
		  		</tr>

			</table>
		</td>
	</tr>
</table>
</div><font face="Arial" size="2"><br>
</font>
<%	objRs.Close %>