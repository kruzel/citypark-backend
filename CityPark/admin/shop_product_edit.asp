<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<SCRIPT LANGUAGE="JavaScript">
 
function textCounter(field, countfield, maxlimit) {
if (field.value.length > maxlimit) // if too long...trim it!
field.value = field.value.substring(0, maxlimit);
// otherwise, update 'characters left' counter
else 
countfield.value = maxlimit - field.value.length;
}
</script>

<script language="javascript" type="text/javascript">
// <!CDATA[

function newrecord_onclick() {

}

// ]]>
</script>
<!--#include file="../config.asp"-->

<!--#include file="inc_admin_icons.asp"-->

<% 
CheckSecuirty "Product"

		If Request.QueryString("mode") = "doit" Then

			If Trim(Request.Form("ProductName")) = ""  Or Trim(Request.Form("Price")) = "" Then
			
				Response.Write("<br><br><p align='center'>לא מלאת אחד או יותר מן השדות הנחוצים. השתמש מלחצן חזרה בדפדפן על מנת לתקן זאת או לחץ <a href='javascript:history.go(-1)'>כאן</a>!</p>")
				
			Else
			If  Request.Form("ProductCategory") = 0 Then
			
				Response.Write("<br><br><p align='center'>לא בחרת  קטגוריה. השתמש מלחצן חזרה בדפדפן על מנת לתקן זאת או לחץ <a href='javascript:history.go(-1)'>כאן</a>!</p>")

			Else

						
						Set objRs = OpenDB("SELECT * FROM Product WHERE ProductID= " & Request.Querystring("ID"))	
								
								objRs("ProductCode") = Request.Form("ProductCode")
								objRs("ProductName") = Trim(Request.Form("ProductName"))
								objRs("ProductCategoryID") = CInt(Request.Form("ProductCategory"))
								objRs("ShortDescription") = Trim(Request.Form("ProductShortText"))	
								objRs("Description") = Request.Form("FCKeditor1")
								objRs("ProductImage1") = Trim(Request.Form("ProductImage1"))
								objRs("ProductImage2") = Trim(Request.Form("ProductImage2"))
								objRs("Price") = Request.Form("Price")	
								objRs("RetailPrice") = Request.Form("RetailPrice")
								objRs("CostPrice") = Request.Form("CostPrice")	
								objRs("Qty") = Request.Form("Qty")
								objRs("Unit") = Request.Form("Unit")
								objRs("Template") = Trim(Request.Form("ProductTemplate"))
								objRs("ProductHeader") = Trim(Request.Form("ProductHeader"))
								objRs("ProductFooter") = Trim(Request.Form("ProductFooter"))
								objRs("ProductTitle") = Trim(Request.Form("ProductTitle"))
								objRs("ProductDescription") = Trim(Request.Form("ProductDescription"))
								objRs("ProductKeywords") = Trim(Request.Form("ProductKeywords"))
								objRs("User9Level") = Cint(Request.Form("User9Level"))

								objRs.Update

							objRs.Close
								Response.Write("<br><br><p align='center'>מוצר נערך בהצלחה. <a href='shop_Product.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							Response.Write("<meta http-equiv='Refresh' Product='1; URL=shop_Product.asp?S=" & SiteID & "'>")
							
						End If
					
					
					
							
			End If
		Else
		
						Set objRs = OpenDB("SELECT * FROM Product WHERE ProductID= " & Request.Querystring("ID"))	
			 	
%>
<form name="Product" action="shop_Product_edit.asp?mode=doit&amp;ID=<% = Request.QueryString("ID") %>&S=<% = SiteID %>" method="post">
<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td width="0">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp;<span lang="he">הוספת 
	מוצר</span></font></b></td>
				</tr></table>
			<table border="0" width="100%" cellspacing="0" cellpadding="4">
			    <tr>
					<td valign="top" align="right" height="20" width="18%">
					<font face="Arial" size="2">קטגוריה:
					</font>
					</td>
					<td valign="top" height="20" width="83%" align="right">
					<font face="Arial"><font size="2">
					<%
						Set objRsCategory= OpenDB("SELECT * FROM ProductCategory WHERE CategoryFatherID = 0 AND SiteID = " & SiteID & "  ORDER BY ProductCategoryPosition")
					%>					  
					</font>
					<select style="width: 150px;" name="ProductCategory" size="1">
						<option value="0">בחר קטגוריה</option>

					<%
					Do While Not objRsCategory.EOF
						%>
						<option value="<% = objRsCategory("ProductCategoryID") %>" <% If objRsCategory("ProductCategoryID") = objRs("ProductCategoryID") Then Response.Write(" selected") %>><% = objRsCategory("ProductCategoryName") %></option>
	<%
						Set objRsCategory2 = OpenDB("SELECT * FROM ProductCategory Where CategoryFatherID = " & objRsCategory("ProductCategoryID"))
					Do While Not objRsCategory2.EOF
					%>
						<option value="<% = objRsCategory2("ProductCategoryID") %>" <% If objRsCategory2("ProductCategoryID") = objRs("ProductCategoryID") Then Response.Write(" selected") %>>--<% = objRsCategory2("ProductCategoryName") %></option>
					<%	
					objRsCategory2.MoveNext 
					Loop
					objRsCategory.MoveNext 
					Loop
					%>
					</select><font size="2">
					<% 
					'objRsCategory2.Close
					objRsCategory.Close
					%>
					</font></font>
					</td>				
				</tr>
				<tr>
				    <td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">שם מוצר:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 300px;" type="text" 
     name="ProductName" size="50" maxlength="100" 
     value="<% = objRS("ProductName") %>"><font size="2">
					</font></font>
					</td>
			    </tr>
				<tr>
				    <td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">מספר קטלוגי:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 300px;" type="text" name="ProductCode" size="50" maxlength="100" value="<% = objRS("ProductCode") %>"><font size="2">
					</font></font>
					</td>
			    </tr>
			    <tr>
					<td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">תאור קצר:</font></td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
					<textarea style="width: 300px;" rows="6" name="ProductShortText" cols="43" onKeyDown="textCounter(this.form.ProductShortText,this.form.remLen,200);" onKeyUp="textCounter(this.form.ProductShortText,this.form.remLen,200);"><% = objRS("ShortDescription") %></textarea></font>
			   <br>
			   		<font size="1">
			   <input readonly type=text name=remLen size=1 maxlength=3 value="200"> תווים (מקסימום 200)</font>
					</font>
				</td>
 					</tr>
 								    			      				<tr>
				    <td valign="top" align="right" colspan="2">
				  	  <div align="right"><span lang="he">
						<font face="Arial" size="2">תאור:</font></span></td>
								      </tr>	
	
			    <tr>
			    	<td colspan="2" align="right">
				<font face="Arial" size="2">
				<% '----------START-RTE----------------------------- %>
<%
Dim oFCKeditor
Set oFCKeditor = New FCKeditor
oFCKeditor.BasePath = "FCKeditor/"
oFCKeditor.width="100%"
oFCKeditor.Value=objRs("Description")
oFCKeditor.height="370px"
oFCKeditor.Create "FCKeditor1"

%>
  <% '----------END RTE ----------------------------------------------- %></font></font></tr> 
					</td>
				</tr>

			    <tr>
				    <td valign="top" align="right" height="29" width="18%">
				  	<font face="Arial" size="2">תמונה:
					</font>
					</td>				
					<td valign="top" height="29" align="right">
					<font face="Arial"><font size="2">
					<% '---------------- %>
					</font>		
					<input style="width: 419px;" id="xFilePath" name="ProductImage1" type="text" 
                            size="60" value="<% = objRS("ProductImage1") %>" /><font size="2">
					</font>
					<input type="button" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/><font size="2">
					<% '---------------- %>
					</font></font>					  
					</td>			      
			    </tr>
			    <tr>
				    <td valign="top" align="right" height="29" width="18%">
				  	<font face="Arial" size="2">תמונה:
					</font>
					</td>				
					<td valign="top" height="29" align="right">
					<font face="Arial"><font size="2">
					<% '---------------- %>
					</font>		
					<input style="width: 418px;" id="xFilePath2" name="ProductImage2" type="text" 
                            size="60" value="<% = objRS("ProductImage2") %>" /><font size="2">
					</font>
					<input type="button" value="חפש בשרת" onclick="BrowseServer('xFilePath2');"/><font size="2">
					<% '---------------- %>
					</font></font>					  
					</td>			      
			    </tr>
				<tr>
					<td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">מחיר מכירה:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 112;height:19" type="text" name="Price" size="20" maxlength="100" value="<% = objRS("Price") %>"></font><font size="2" face="Arial">
					</font>
					</td>
			    </tr>
				<tr>
					<td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">מחיר קמעונאי:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 112;height:19" type="text" name="RetailPrice" size="20" maxlength="100" value="<% = objRS("RetailPrice") %>"></font><font size="2" face="Arial">
					</font>
					</td>
			    </tr>
				<tr>
					<td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">מחיר קנייה:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 112;height:19" type="text" name="CostPrice" size="20" maxlength="100" value="<% = objRS("CostPrice") %>"><font size="2">
					</font></font>
					</td>
			    </tr>
				<tr>
					<td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">כמות במלאי:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 72;height:19" type="text" name="Qty" size="15" maxlength="100" value="<% = objRS("Qty") %>"><font size="2">
					</font></font>
					</td>
			    </tr>
				<tr>
					<td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">כיתוב בכותרת האתר:
					</font>
					</td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
						<input style="width: 300px;" type="text" name="ProductTitle" size="50" maxlength="100" value="<% = objRS("ProductTitle") %>"><font size="2">
					</font></font>
					</td>
			    </tr>
				<tr>
				    <td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">מילות מפתח:</font></td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
					  <textarea style="width: 300px;" rows="6" name="ProductKeywords" cols="46"><% = objRS("ProductKeywords") %></textarea></font></td>
			    </tr>
				<tr>
				    <td valign="top" align="right" height="20" width="18%">
				  	<font face="Arial" size="2">תאור <span lang="he">לקידום</span>:</font></td>
					<td valign="top" height="20" align="right">
					<font face="Arial">
					  <textarea style="width: 300px;" rows="6" name="ProductDescription" cols="46"><% = objRS("ProductDescription") %></textarea></font></td>
			    </tr>
			    <tr>
			        <td valign="top" align="right" height="20" width="18%">
			        <font face="Arial" size="2">רמת הרשאה:</font></td>
			        <td valign="top" height="20" align="right">				  					  
					<font face="Arial">					  					  
					<select style="width: 40px;" name="Product9Level" ID="Product9Level" size="1">
						<%
							i=1	
				 			Do Until i > 8
				 		 %>
							<option value="<% = i %>"><% = i %></option>
							<% i=i+1
							Loop
							%>
							<option value="9" selected>9</option>

					</select></td>
			    </tr>
                <tr>
				    <td valign="top" align="right">
				  	<div align="right"><font face="Arial" size="2">תבנית עיצוב:</font></td>
					<td valign="top" align="right">
					<font face="Arial">
					<select style="width: 150px;" name="ProductTemplate" size="1">
					<% 
Whichfolder=server.mappath("../Sites/" & Application(ScriptName & "ScriptPath") & "/layout") &"/"  
Set fs = CreateObject("Scripting.FileSystemObject") 
Set f = fs.GetFolder(Whichfolder) 
Set fc = f.files

For Each f1 in fc 
 %>
 						<option value="<% = f1.name %>" <% If f1.name = objRs("Template") Then Response.Write(" selected") %>><% = f1.name %></option>

 <%
Next 
%>
					</select></font></td>
				</tr>
				<tr>
				    <td valign="top" align="right">
				  	<div align="right"><font face="Arial" size="2">Header:</font></td>
					<td valign="top" align="right">
					<font face="Arial">
					<select style="width: 150px;" name="ProductHeader" size="1">
					<% 
Whichfolder=server.mappath("../Sites/" & Application(ScriptName & "ScriptPath") & "/layout") &"/"  
Set fs = CreateObject("Scripting.FileSystemObject") 
Set f = fs.GetFolder(Whichfolder) 
Set fc = f.files
 	
 	If Session("SiteLang") <> 1 Then
			headertemplate = "headerltr.html"
			footertemplate = "footerltr.html"
	Else
			headertemplate = "header.html"
			footertemplate = "footer.html"
	End If
For Each f1 in fc 
 %>
 						<option value="<% = f1.name %>" <% If f1.name = headertemplate  Then Response.Write(" selected") %>><% = f1.name %></option>
 
 <%
Next 
%>
					</select></font></td>
				</tr>
                <tr>
				    <td valign="top" align="right">
				  	<div align="right"><font face="Arial" size="2">Footer:</font></td>
					<td valign="top" align="right">
					<font face="Arial">
					<select style="width: 150px;" name="ProductFooter" size="1">
					<% 
Whichfolder=server.mappath("../Sites/" & Application(ScriptName & "ScriptPath") & "/layout") &"/"  
Set fs = CreateObject("Scripting.FileSystemObject") 
Set f = fs.GetFolder(Whichfolder) 
Set fc = f.files
For Each f1 in fc 
 %>
 						<option value="<% = f1.name %>" <% If f1.name = footertemplate  Then Response.Write(" selected") %>><% = f1.name %></option>
 <%
Next 
%>
					</select></font></td>
				</tr>
			    <tr>			
					<td valign="top" align="center" colspan="2" height="22" bgcolor="#DDDDDD">
					<font face="Arial">
					<input type="submit" id="save" value="עדכן מוצר"></font></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>
</form>
<br />
<%			
End if
%>