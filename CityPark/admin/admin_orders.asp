<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
    });
</script>
<script type='text/javascript'>
    $(function () {
        $('#east').tipsy({ html: true });
        $('#east2').tipsy({ html: true });
        $('#east3').tipsy({ html: true });
    });
</script>
<script type="text/javascript">
    function toggleDiv(reference_object) {
        if (reference_object.style.display == 'none')
            reference_object.style.display = 'block';
        else
            reference_object.style.display = 'none';
    }

    function toggleAllItems(ID) {
        var items = document.getElementsByTagName('tr');

        for (i = 0; i < items.length; i++) {
            if (items[i].id.indexOf('_') > 0) {
                var x = items[i].id.indexOf('_');

                if (items[i].id.substring(0, x) == 't' + ID)
                    toggleDiv(items[i]);
            }
        }
    }
</script>

<%
'If Request.ServerVariables("HTTPS") = "off" then
 '   Response.Redirect "https://" & Request.ServerVariables("HTTP_HOST")	 &"/" & Request.ServerVariables("Url") & "?" & Request.Querystring
'End If

CheckSecuirty "orders"
    if request("inline") = "true" Then
        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Content] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
    Response.Clear
    Response.CodePage = "1255" 
    Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=users.csv"
		SQL = "SELECT * FROM orders WHERE SiteID=" & SiteID & " ORDER BY OrdersID DESC"
	Set objRs = OpenDB(SQL)
	    Do While Not objRs.EOF
            for each f in objRs.Fields
                print(f.Value & ",")
            next
                print  vbCrLf
     objRs.MoveNext
		Loop
    CloseDB(objRs)
    response.end
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "Content-Disposition", "attachment;filename=content-"&filedate&".doc"
        Response.ContentType = "application/vnd.ms-word"
     End If

If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then

%>
<!--#include file="right.asp"-->
	<div id="incontent">
	<div class="incontentboxgrid">
   

<center>
<%
	If Request.QueryString("records") = "" Then
	Session("records") = 50
	Else 
	Session("records") = Request.QueryString("records")
	End If

CheckSecuirty "Content"
 %>   
    <div class="formtitle">
        <h1>ניהול הזמנות</h1>
		<div class="admintoolber">
        <form action="admin_orders.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %>&string=<%=Request.form("search") %>&lang=<%=Request.form("lang") %>" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value=" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_orders.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_orders.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_orders.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_orders.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
					<option value="10" <%if Session("records") = 10 then print "selected" End if%>>10</option>
					<option value="20" <%if Session("records") = 20 then print "selected" End if%>>20</option>
					<option value="50" <%if Session("records") = 50 then print "selected" End if%>>50</option>
					<option value="100" <%if Session("records") = 100 then print "selected" End if%>>100</option>
					<option value="1000" <%if Session("records") = 1000 then print "selected" End if%>>1000</option>
				</select>
			</p>
			<p class="reshumot">רשומות לדף:</p>

	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th style="width:8%;" class="recordid">ID</th>
		<th style="width:36%;text-align:right;padding-right:40px;cursor:pointer;">שם</th>
		<th style="width:8%;">תאריך הזמנה</th>
		<th style="width:8%;">סטאטוס</th>
        <th style="width:8%;">ערוך</th>
        <th style="width:8%;">מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
Function statuse(code)
    Select case code
    case 1
        statuse="<b>הזמנה חדשה</b>"
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
If  Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
                SQL = "SELECT * FROM [orders] WHERE SiteID=" & SiteID & " ORDER BY OrdersStatus ASC,OrdersID DESC"
     If Request.QueryString("mode") = "search" then
            If Request.form("text") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("text") & "%'"
             End If
    End If
	'print sql
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	            objRsg.PageSize = Session("records")
                HowMany = 0
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize
			If objRsg("UsersID") <> "" Then
				SQLuser = "SELECT * FROM users WHERE Id = " & objRsg("UsersID") & " AND SiteID=" & SiteID
					Set objRsuser = OpenDB(SQLuser)
            End if              
			
            	%>
    <tr style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td><%= objRsg("OrdersID")  %></td>
		<% If objRsuser.recordcount>0 Then %>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("OrdersID") %>_Name"><% = objRsuser("Name")& " " & objRsuser("Familyname") %></div></td>
        <% else %>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("OrdersID") %>_Name"><% = objRsg("shipName")& " " & objRsg("shipFailyName") %></div></td>
	
	<% End if %>
		<td><% = objRsg("date") %></td>
        <td><% = statuse(objRsg("OrdersStatus")) %></td>
        <td><a href="admin_orders.asp?ID=<% = objRsg("OrdersID") %>&action=edit"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td><a href="admin_orders.asp?ID=<% = objRsg("OrdersID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
    </tr>
    	
<%     
If objRsg("UsersID") <> "" Then   CloseDB(objRsuser) 
objRsg.MoveNext
		 Loop

      objRsg.Close
    End If
End If
%>
</tbody>
</table></div>
<% Else 
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	        Case "add"
	        Editmode= "False"

			        Sql = "SELECT * FROM orders WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				             objRs("SiteID") = SiteID
				                objRs("Name") = Request.Form("Name")
								objRs("Url") = Request.Form("Url")
								objRs("Count") = Request.Form("Count")
								objRs.Update
								objRs.Close
									Response.Redirect("admin_orders.asp?notificate=קישור נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"
                SQL = "SELECT * FROM Orders WHERE ordersID = " & Request.Querystring("ID") & " AND SiteID= " & SiteID
                Set objRs = OpenDB(SQL)
		            objRs("OrdersStatus") = Request.Form("status")
		            objRs("Total") = Request.Form("Total") 
		            objRs("ShipMethod") =	Request.Form("ShipMethod") 
		            objRs("ShipCost") =	Request.Form("ShipCost") 
		            objRs("shipName") = Request.Form("shipName") 
		            objRs("shipFailyName") = Request.Form("shipFailyName") 
		            objRs("shipaddress") = Request.Form("shipaddress") 
		            objRs("shipaddress2") = Request.Form("shipaddress2") 
		            objRs("shipCity") = Request.Form("shipCity") 
		            objRs("shipCountry") = Request.Form("shipCountry") 
		            objRs("shipZipcode") = Request.Form("shipZipcode") 
		            objRs("shipCompany") = Request.Form("shipCompany")
		            objRs("giftcardnumber") = Request.Form("giftcardnumber")
		


		            objRs("PaymentMethod") = Request.Form("PaymentMethod")
		            objRs("NumberofPayments") = Request.Form("NumberofPayments")
		            objRs("CName") = Request.Form("CName")
		            objRs("IdNumber") = Request.Form("IdNumber")
		            objRs("CAddress") = Request.Form("CAddress")
		            objRs("CardNumber") = EnDecrypt(Request.Form("CardNumber"),encryptkey )
		            objRs("Month") = Request.Form("Month")
		            objRs("year") = Request.Form("year")
		            objRs("Cnv") = Request.Form("Cnv")
		            objRs("Comments") = Request.Form("Comments")
		        objRs.Update
		    CloseDB(objRs)
									Response.Redirect("admin_orders.asp?notificate=ההזמנה עודכנה בהצלחה")
	        
	        Case "delete"
				    Sql = "SELECT * FROM orders WHERE OrdersID=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
									Response.Redirect("admin_orders.asp?notificate=ההזמנה נמחקה בהצלחה")
	        

	            End Select
		Else
			If Request.QueryString("action") ="edit" OR  Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM orders WHERE OrdersID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM orders WHERE SiteID=" & SiteID   
			End If	
				Set objRs = OpenDB(SQL)
					If Session("Level") > 3 Then 
						Response.Write("<br><br><p align='center'>אין לך הרשאה לבצע פעולה זאת <a href='user_home.asp'>נסה שנית</a>!</p>")
				
		Else
		
		If Request.QueryString("action")<> "add" then
		    Editmode = "True"
		Else
		    Editmode = "False"
        End If	

 %>
 <div id="incontentform">

 
<form action="admin_orders.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("OrdersID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
				<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת הזמנה</h1>
				<% ELSE 
				%>
					<h1>עריכת הזמנה</h1>
				<% End If %>
                <a class="print" href="javascript:window.print()">הדפס</a>
				</div>
			    <div class="rightform">
					<table style="margin:0 auto;" dir="rtl" cellpadding="3" cellspacing="0" border="1" width="95%">
                      <tr><td align="right">הזמנה מספר:</td><td align="right" colspan="4"><% =objRs("OrdersID") %></td></tr>
                      <tr><td align="right">תאריך ושעת ההזמנה:</td><td align="right" colspan="4"><%= objRs("date")%></td></tr>
	                <% Set objRsstatus = OpenDB("Select * From Orderstatus") %>
                        <tr><td align="right">סטטוס ההזמנה:</td><td align="right" colspan="4">
                            <select name="status">
	                            <% Do While NOT objRsstatus.EOF %>
                                    <option value="<% = objRsstatus("OrderStatusID")%>" <% if objRsstatus("OrderStatusID")= objRs("OrdersStatus") then %> selected="selected"<% End if %>><% =objRsstatus("OrderStatusName")%></option>
	                             <% objRsstatus.MoveNext
		                            Loop
                                        CloseDB(objRsstatus) %>
                            </select>
                            </td>
                         <tr>
                        <tr><td align="right" style="width:400px;">מספר</td><td align="right">תאור</td><td>כמות</td><td>מחיר יחידה</td><td>סהכ</td></tr>
			            <% SQLSub = "SELECT * FROM SubOrders WHERE ordersID = " & Request.Querystring("ID")
			                Set objRsSub = OpenDB(SQLSub)
			                Do While NOT objRsSub.EOF %>
					            <tr><td align="right"><% = objRsSub("ProductID")%></td>
					                <td align="right" width="200"><% = objRsSub("ProductName")%> </td>
					                <td align="center"><% =  objRsSub("Qty")%></td>
					                <td align="right">₪<% = objRsSub("ProductPrice")%></td>
					                <td align="right">₪ <% = FormatNumber(objRsSub("Qty") * objRsSub("ProductPrice"), 2)%></td>
                                 <tr>
			                <% objRsSub.MoveNext
				                Loop
			                        CloseDB(objRSSub)%>
                                <tr><td colspan="5"></td></tr>
                                <tr><td  align="right"><b>סהכ:</b></td><td align="Left"colspan="4">₪<input  type="text" name="Total" value="<% = objRs("Total")%>" size="6" </td></tr>
                                <tr><td  align="right"><b>הנחה:</b></td><td align="right">קוד קופון</td><td><% = objRs("Couponcode")%></td><td align="Left"colspan="2">%<input disabled  type="text" name="Discount" value="<% = objRs("Discount")%>" size="6" </td></tr>
                                <tr><td  align="right"><b>משלוח:</b></td><td align="Left"colspan="4">₪<input type="text" name="ShipCost" value="<% = objRs("ShipCost")%>" size="6"</td></tr>
                                <tr><td  align="right"><b>סה"כ כולל משלוח:</b></td><td align="Left"colspan="4">₪<input type="text" name="total3" value="<% = objRs("ShipCost")+ objRs("Totalafterdiscount")%>" size="6"</td></tr>
                                <tr><td  align="right"><b>איסוף עצמי?:</b></td><td align="Left"colspan="4"><input readonly type="text" name="total3" value="<% If objRs("selfshipping")= True then print "כן" else print "לא" end if%>" size="6"</td></tr>
                                <tr><td  align="right"><b>הזמנה טלפונית?:</b></td><td align="Left"colspan="4"><input readonly type="text" name="total3" value="<% If objRs("TelephoneOrder")= "1" then print "כן" else print "לא" end if%>" size="6"</td></tr>
                                <tr><td  align="right"><b>סה"כ כרטיס אשראי:</b></td><td align="Left"colspan="4"><input readonly type="text" name="total3" value="<%=objRs("TotalCreditCard")%>" size="6"</td></tr>
                                <tr><td  align="right"><b>סה"כ גיפטקארד:</b></td><td align="Left"colspan="4"><input readonly type="text" name="total3" value="<%=objRs("TotalGiftCard")%>" size="6"</td></tr>
                           <% SQLuser = "SELECT * FROM users WHERE Id = " & objRs("UsersID") & " AND SiteID=" & SiteID
			                Set objRsuser = OpenDB(SQLuser)
							 If objRsuser.recordcount>0 Then 

                            %>
                                <tr><td colspan="5"></td></tr>
                                <tr><th colspan="5" align="right" style="background:none repeat scroll 0 0 #000000;color:#FFFFFF;font-size:20px;padding:10px;">פרטי הלקוח</td></tr>
                                <tr><th  align="right"><b>שם:</b></th><td align="right"colspan="4"><input type="text" name="Name" value="<% = objRsuser("Name")%>" size="30"</td></tr>
                                <tr><th  align="right"><b>משפחה:</b></th><td align="right"colspan="4"><input  type="text" name="Familyname" value="<% = objRsuser("Familyname")%>" size="30" </td></tr>
                                <tr><th  align="right"><b>כתובת:</b></th><td align="right"colspan="4"><input type="text" name="Address" value="<% = objRsuser("Address")%>" size="50"</td></tr>
                                <tr><th  align="right">כתובת2:</th><td colspan="4" align="right"><input type="text" name="Address2" value="<% =objRsuser("Address2")%>" size="50"</td></tr>
                                <tr><th  align="right">עיר:</th><td colspan="4" align="right"><input type="text" name="City" value="<% = objRsuser("City")%>" size="30"</td></tr>
                                <tr><th   align="right">מדינה:</th><td align="right" colspan="4"><input type="text" name="Country" value="<% = objRsuser("Country")%>" size="30"</td></tr>
                                <tr><th   align="right">מיקוד:</th><td align="right" colspan="4"><input type="text" name="Zipcode" value="<%=objRsuser("Zipcode")%>" size="30"</td></tr>
                                <tr><th   align="right">טלפון:</th><td align="right" colspan="4"><input type="text" name="Phone" value="<%=objRsuser("Phone")%>" size="30"</td></tr>
                                <tr><th   align="right">סלולאר:</th><td align="right" colspan="4"><input type="text" name="cellular" value="<%=objRsuser("cellular")%>" size="30"</td></tr>
                                <tr><th   align="right">דואל:</th><td align="right" colspan="4"><input type="text" name="Email" value="<%=objRsuser("Email")%>" size="30"</td></tr>
                                 <% CloseDB(objRsuser)
								 End if
								 %>
                                <tr><td colspan="5" align="right" style="background:none repeat scroll 0 0 #000000;color:#FFFFFF;font-size:20px;padding:10px;">פרטי המשלוח</td></tr>
                                <tr><th  align="right">צורת המשלוח:</th><td colspan="4" align="right"><input type="text" name="ShipMethod" value="<% =objRs("ShipMethod")%>" size="30"</td></tr>
                                <tr><th  align="right">שם פרטי:</th><td colspan="4" align="right"><input type="text" name="shipName" value="<% = objRs("shipName")%>" size="30"</td></tr>
                                <tr><th   align="right">שם משפחה:</th><td align="right" colspan="4"><input type="text" name="shipFailyName" value="<% = objRs("shipFailyName")%>" size="30"</td></tr>
                                <tr><th   align="right">כתובת:</th><td align="right" colspan="4"><input type="text" name="shipAddress" value="<%=objRs("shipAddress")%>" size="30"</td></tr>
                                <tr><th   align="right">כתובת 2:</th><td align="right" colspan="4"><input type="text" name="shipAddress2" value="<%=objRs("shipAddress2")%>" size="30"</td></tr>
                                <tr><th   align="right">עיר:</th><td align="right" colspan="4"><input type="text" name="shipCity" value="<%= objRs("shipCity")%>" size="30"</td></tr>
                                <tr><th   align="right">מיקוד:</th><td align="right" colspan="4"><input type="text" name="shipZipcode" value="<%= objRs("shipZipcode")%>" size="30"</td></tr>
                                <tr><th   align="right">מדינה:</th><td align="right" colspan="4"><input  type="text" name="shipCountry" value="<%= objRs("shipCountry")%>" size="30"</td></tr>
                                <tr><th   align="right">חברה:</th><td align="right" colspan="4"><input type="text" name="shipCompany" value="<%= objRs("shipCompany")%>"size="30"</td></tr>
                                <tr><td colspan="5" align="right" style="background:none repeat scroll 0 0 #000000;color:#FFFFFF;font-size:20px;padding:10px;">Gift Card</td></tr>
                                <tr><th align="right">מספר GIFTCARD</th><td align="right" colspan="4"><input type="text" name="giftcardnumber" value="<%=  objRs("giftcardnumber")%>" size="30"</td></tr>
                                <tr><td colspan="5" align="right" style="background:none repeat scroll 0 0 #000000;color:#FFFFFF;font-size:20px;padding:10px;">פרטי התשלום</td></tr>
                                <tr><th align="right">אמצעי תשלום:</th><td align="right" colspan="4"><input type="text" name="PaymentMethod" value="<%=  objRs("PaymentMethod")%>" size="30"</td></tr>
                                <tr><th align="right">מספר תשלומים:</th><td align="right" colspan="4"><input type="text" name="NumberofPayments" value="<%=  objRs("NumberofPayments")%>" size="30"</td></tr>
                                <tr><th align="right">שם בעל הכרטיס:</th><td align="right" colspan="4"><input type="text" name="CName" value="<%=  objRs("CName")%>" size="30"</td></tr>
                                <tr><th align="right">מספר תעודת זהות:</th><td align="right" colspan="4"><input type="text" name="IdNumber" value="<%=  objRs("IdNumber")%>" size="30"</td></tr>
                                <tr><th align="right">כתובת:</th><td align="right" colspan="4"><input type="text" name="CAddress" value="<%=  objRs("CAddress")%>" size="30"</td></tr>
                                <tr><th align="right">מספר כרטיס אשראי:</th><td align="right" colspan="4"><input type="text" name="CardNumber" <% If objRs("CardNumber") <> "" then %>value="<%=  EnDecrypt(objRs("CardNumber"),encryptkey)%>" <% End if %>size="30"</td></tr>
                                <tr><th align="right">תוקף הכרטיס</th><td colspan="4" align="right"> חודש  
                                <select name="Month" style="width: 60px;">
	                            <% for x=1 to 12 %>
                                   <option value="<% = int(x) %>"<% if int(x)= int(objRs("Month")) then%> selected="selected" <% End If %>><% =  x %></option>
		                        <% Next %>
                                 </select>שנה  
                                 <select name="Year" style="width: 60px;">
	                            <% for y=11 to 18 %>
                                    <option value="<% =int(y) %>"<%if int(y) = int(objRs("Year")) then %> selected="selected" <% End If %>>20<% = y %></option>
		                        <% Next %> 
                                    </select></td>"
                                 <tr><th align="right">קוד אימות בגב כרטיס:</th><td align="right" colspan="4"><input type="text" name="Cnv" value="<%= objRs("Cnv")%>" size="30"</td></tr>
                                 <tr><th align="right">הערות:</th><td align="right" colspan="4"><textarea rows="6" name="Comments" cols="40"><%=objRs("Comments")%></textarea>
                                 <tr><td colspan="5" align="left"><input type="submit" value="עדכן" /></td></tr> 	
                                    <% Print strMessageBody %>
</td>
				</table>
				</div>
			</div>
<div id="left">
<div id="formcontainer">
<center>
    <div id="formcontent">
        <div id="formleftfields">
		    <div style="width:100%;" id="accordion">
				<h3><a style="background:url(images/link_img.png) no-repeat right;" href="#">-</a></h3>
			        <div>
                 </div>

            </div>
            <div id="formsubmit">
            <input type="submit" style="margin:10px 0 0;" value="שמור" class="saveform"  />
            </div>
        </div>
        <div id="clearboth"></div>
    </div>
</center>
</div>
</div>
</div>
</form>


<%	
End if
End if
End if

%>

<!--#include file="footer.asp"-->