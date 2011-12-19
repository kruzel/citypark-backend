<!--#include file="../config.asp"-->
<!--#include file="inc_form_includes.asp"-->
<!--#include file="inc_admin_icons.asp"-->

<%

'----------------------------------Settings------------------------------
PageName = "shop_shipping_a.asp"
Table = "Shipping"
ModeName = "m"
'--------------------------------End Settings-----------------------------



CheckSecuirty Table

Mode = LCase(Request.QueryString(ModeName))
ID = Request("ID")

If Request.Form("IsSubmitted") = "true" Or Mode = "delete" Then
	ExecuteRs GetSQL(Table, Mode, ID)
Else

	If Mode = "update" Then	
		Set objRsSelected = OpenDB("Select * From [" & Table & "] Where [" & Table & "]." & Table & "ID = " & ID)
	End If
%>

<form method="post" action="<% = PageName %>?<% = ModeName %>=<% = Mode %>">
	<% = GetHiddenFields(Mode, ID) %>
	
	<table>
		<tr>
			<th>שם:</th>
			<td><input type="text" name="ShippingName" value="<% = GetValue("ShippingName", objRsSelected, Mode) %>" /></td>
		</tr>
		
		<tr>
			<th>מחיר:</th>
			<td><input type="text" name="ShippingCost" value="<% = GetValue("ShippingCost", objRsSelected, Mode) %>" /></td>
		</tr>
		
		<tr>
			<td colspan="2" style="text-align: left;"><input type="submit" value="אישור" /></td>
		</tr>
	</table>
</form>

<% End If %>