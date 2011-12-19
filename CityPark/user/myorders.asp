<!--#include file="../config.asp"-->
<% 
Function statuse(code)
    Select case code
    case 1
        statuse="<b>הזמנה התקבלה</b>"
    case 2
        statuse="בטיפול"
    case 3
        statuse="בוצע"
    case 4
        statuse="הזמנה מבוטלת"
    case 5
        statuse="לא מאושרת"
    case 6
        statuse="הזמנה מאושרת"
    end select
End Function

header
Userheader = GetURL(Getconfig("Userheader"))
		 ProcessLayout(Userheader)

SetSession "BackURL","/user/user.asp"
If Request.Cookies(SiteID & "UserLevel") = "" Then 
 Response.Redirect("/userlogin.asp")
End If
    CheckUserSecurity_Level Request.Cookies(SiteID & "UserLevel"),GetSession("BackURL")
     Sql="Select * From Orders Where UsersID=" & Request.Cookies(SiteID & "UserID")
	 Set objRs = OpenDB(Sql)

%>
<h3>ההזמנות שלי</h3>
<table class="ordergrid" cellspacing="0" cellpadding="0" dir="rtl" border="0">
	<tr>
		<th width="15%">מספר הזמנה</th>
		<th width="15%">תאריך</th>
		<th width="40%">מפרט</th>
		<th width="20%">סטאטוס</th>
		<th width="10%">סכום</th>
	</tr>
    <% Do While NOT objRs.EOF  %>
	<tr>
		<td><% = objRS("OrdersID") %></td>
		<td><% = FormatDate(objRS("date"),"mm/dd/yyyy") %></td>
		<td>
			<%	SqlDetails="Select * From Suborders Where OrdersID=" & objRS("OrdersID") 
	            Total=0
                Set objRsDetails = OpenDB(SqlDetails)
                 Do While NOT objRsDetails.EOF %>
				<% = objRsDetails("ProductName") %>			
                <% total = total + (objRsDetails("Qty") * objRsDetails("ProductPrice"))
                objRsDetails.movenext
                    loop %>
		</td>
		<td><% = statuse(objRs("OrdersStatus"))%></td>
		<td><% = objRs("ShipCost")+ objRs("Totalafterdiscount")%></td>
	</tr>
    <% objRs.Movenext
        loop %>
</table>
<%
Userfooter = GetURL(Getconfig("Userfooter"))
							 ProcessLayout(Userfooter)
bottom
%>