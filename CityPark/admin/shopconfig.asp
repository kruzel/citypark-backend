<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<!--#include file="../config.asp"-->
<!--#include file="inc_admin_icons.asp"-->


<%
CheckSecuirty "config"
Set objRs = OpenDB("SELECT * FROM ShopConfig WHERE SiteID = " & SiteID)	

If Request.QueryString("mode") = "doit" Then
			 
						objRs("shopproductsOrder") = Trim(Request.Form("shopproductsOrder"))
					objRs.Update 

					
					Application.Lock 
				
						Application(ScriptName & "ConfigLoaded") = ""
				
					Application.UnLock 
						
					Response.Write("<br><br><div align='center'>הגדרות נערכו בהצלחה. <a href='default.asp?'>לחץ להמשך</a>!</p>")
					Response.Write("<meta http-equiv='Refresh' content='1; URL=default.asp'>")
					
				
	
		Else

Set objRs = OpenDB("SELECT * FROM ShopConfig Where SiteID= " & SiteID)	
%>
			<form action="shop_config.asp?mode=doit" method="post">
	<div align="center" style="margin-top:20px;">
<table style="border: 1px solid #ddd" width="700" border="0" dir="rtl" cellspacing="0" cellpadding="0">
	<tr>
		<td width="0">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
		<td background="/images/menuin.jpg" height="30" width="700">
	<div align="right">
	<b><font color="#FFFFFF" face="Arial" size="2">&nbsp;<span lang="he">הגדרות 
	מתקדמות</span></font></b></td>
				</tr></table>
	<table cellpadding="0" cellspacing="0" dir=rtl width="700">
	 			  <tr valign=top>
			    <td>
			    <table border="0" width="100%" cellspacing="0" cellpadding="4">
			      <tr>
				  
				    <td valign="middle" align="right" nowrap width="19%">
					 
					  <div align="right"><font size="2" face="Arial">סדר הופעת כתבות?
						</font>
					</td>
					<td valign="middle" width="78%" align="right">
					  <font face="Arial">
					  <select name="shopproductsOrder">
					    <option value="ProductID Desc" <% If objRs("shopproductsOrder") = "ProductID Desc" Then Response.Write(" selected") %>>אחרון שהוכנס מופיע ראשון</option>
					    <option value="ProductID ASC" <% If objRs("shopproductsOrder") = "ProductID ASC" Then Response.Write(" selected") %>>ראשון שהוכנס מופיע ראשון</option>
					    <option value="Productorder" <% If objRs("shopproductsOrder") = "Productorder" Then Response.Write(" selected") %>>מיון ידני לפי סדר מיון</option>
					  </select></font><font size="2" face="Arial"> </font>					  
					</td>
				  </tr>
			      <tr>			
					<td valign="top" align="center" colspan="2" bgcolor="#DDDDDD">
					
					  <input type="submit" value="שמור הגדרות">
							
				    </td>
				  </tr>
				  </table>
			    </td>
			  </tr>
			</table>
			</div>
			</td></tr></table>
			</div>
			</form>

<%
	End if
 CloseDB(objRs)
%>