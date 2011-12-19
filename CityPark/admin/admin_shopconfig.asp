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

<%

CheckSecuirty "shopconfig"
    if request("inline") = "true" Then
        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [shopconfig] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
    Response.Clear
    Response.CodePage = "1255" 
    'Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=users.csv"
		SQL = "SELECT * FROM shopconfig WHERE SiteID=" & SiteID & " ORDER BY Name ASC"
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
        <h1>הגדרות חנות</h1>
		<div class="admintoolber">
        <form action="admin_shopconfig.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %>&string=<%=Request.form("search") %>&lang=<%=Request.form("lang") %>" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_shopconfig.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="admin_shopconfig.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_shopconfig.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		<th style="width:36%;text-align:right;padding-right:40px;cursor:pointer;">מילה</th>
		<th style="width:8%;">ערוך</th>
        <th style="width:8%;">שכפל</th>
        <th style="width:8%;">מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If  Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
                SQL = "SELECT * FROM [shopconfig] WHERE SiteID=" & SiteID
     If Request.QueryString("mode") = "search" then
            If Request.form("text") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("text") & "%'"
             End If
    End If
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	            objRsg.PageSize = Session("records")
                HowMany = 0
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize

            	%>
    <tr style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("ShopConfigID") %>_Name"><% = objRsg("ShopConfigName") %></div></td>
        <td><a href="admin_shopconfig.asp?ID=<% = objRsg("ShopConfigID") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_shopconfig.asp?ID=<% = objRsg("ShopConfigID") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td><a href="admin_shopconfig.asp?ID=<% = objRsg("ShopConfigID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
    </tr>	
<%        objRsg.MoveNext
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

			        Sql = "SELECT * FROM shopconfig WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				            objRs("SiteID") = SiteID
                            objRs("ShopConfigName") = Request.Form("ShopConfigName")
	                        objRs("DefaultCurrency") = Request.Form("DefaultCurrency")
	                        objRs("CurrencySymbol") = Request.Form("CurrencySymbol")
	                        objRs("Address") = Request.Form("Address")
	                        objRs("ordersemail") = Request.Form("ordersemail")
	                        objRs("sendemailtomanager") = Request.Form("sendemailtomanager")
	                        objRs("sendemailtocastomer") = Request.Form("sendemailtocastomer")
	                        objRs("OnlyRegisterdUsers") = Request.Form("OnlyRegisterdUsers")
	                        objRs("textundercart") = Request.Form("textundercart")
	                        objRs("OrderdetailsText") = Request.Form("OrderdetailsText")
	                        objRs("AprooveDetailsText") = Request.Form("AprooveDetailsText")
	                        objRs("OrderdetailsText") = Request.Form("OrderdetailsText")
                            objRs("showcontinueurl") = Request.Form("showcontinueurl")
                            objRs("homepage") = Request.Form("homepage")
	                        objRs("showcontinueshoping") = Request.Form("showcontinueshoping")
	                        objRs("checkoutURL") = Request.Form("checkoutURL")
	                        objRs("paypalemail") = Request.Form("paypalemail") 
	                        objRs("tranzilausername") = Request.Form("tranzilausername") 
	                        objRs("tranzilapassword") = Request.Form("tranzilapassword") 
	                        objRs("CardTypes") = Request.Form("CardTypes")
	                        objRs("AprooveDetailsText") = Request.Form("AprooveDetailsText") 
	                        objRs("ThankYouText") = Request.Form("ThankYouText")
	                        objRs("OrderdetailsText") = Request.Form("OrderdetailsText")
	                        objRs("SendMailToCust") = Request.Form("SendMailToCust") 
	                        objRs("SendMailToMerch") = Request.Form("SendMailToMerch")
	                        objRs("ShowFamilyName") = Request.Form("ShowFamilyName")
	                        objRs("ShowAddress2") = Request.Form("ShowAddress2") 
	                        objRs("ShowCity") = Request.Form("ShowCity")
	                        objRs("ShowCountry") = Request.Form("ShowCountry")
	                        objRs("ShowZipcode") = Request.Form("ShowZipcode") 
	                        objRs("ShowPhone") = Request.Form("ShowPhone")
	                        objRs("Showcellular") = Request.Form("Showcellular") 
	                        objRs("ShowEmail") = Request.Form("ShowEmail") 
	                        objRs("ShowShippingForm") = Request.Form("ShowShippingForm")
	                        objRs("Showshipaddress") = Request.Form("Showshipaddress") 
	                        objRs("Showshipcompany") = Request.Form("Showshipcompany") 
	                        objRs("ShowPaymentForm") = Request.Form("ShowPaymentForm") 
	                        objRs("ShowPaymentMethod") = Request.Form("ShowPaymentMethod") 
	                        objRs("ShowCAddress") = Request.Form("ShowCAddress") 
	                        objRs("ShowIdNumber") = Request.Form("ShowIdNumber") 
	                        objRs("ShowCnv") = Request.Form("ShowCnv") 
	                        objRs("ShowComments") = Request.Form("ShowComments")
	                        objRs("ShowCartContents") = Request.Form("ShowCartContents") 
	                        objRs("shopproductsOrder") = Request.Form("shopproductsOrder") 
	                        objRs("Shipingmethod") = Request.Form("Shipingmethod") 
	                        objRs("NumberofPayments") = Request.Form("NumberofPayments") 
	                        'objRs("shopshowhowmanyprodincategories") = Request.Form("shopshowhowmanyprodincategories") 
	                       ' objRs("cartheader") = Request.Form("cartheader") 
	                       ' objRs("cartfooter") = Request.Form("cartfooter")
								objRs.Update
								objRs.Close
									Response.Redirect("admin_shopconfig.asp?notificate=קישור נוסף בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM shopconfig WHERE ShopConfigID=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)

                            objRs("ShopConfigName") = Request.Form("ShopConfigName")
	                        objRs("DefaultCurrency") = Request.Form("DefaultCurrency")
	                        objRs("CurrencySymbol") = Request.Form("CurrencySymbol")
	                        objRs("Address") = Request.Form("Address")
	                        objRs("ordersemail") = Request.Form("ordersemail")
	                        objRs("sendemailtomanager") = Request.Form("sendemailtomanager")
	                        objRs("sendemailtocastomer") = Request.Form("sendemailtocastomer")
	                        objRs("OnlyRegisterdUsers") = Request.Form("OnlyRegisterdUsers")
	                        objRs("textundercart") = Request.Form("textundercart")
	                        objRs("OrderdetailsText") = Request.Form("OrderdetailsText")
	                        objRs("AprooveDetailsText") = Request.Form("AprooveDetailsText")
	                        objRs("OrderdetailsText") = Request.Form("OrderdetailsText")
                            objRs("showcontinueurl") = Request.Form("showcontinueurl")
                            objRs("homepage") = Request.Form("homepage")
	                        objRs("showcontinueshoping") = Request.Form("showcontinueshoping")
	                        objRs("checkoutURL") = Request.Form("checkoutURL")
	                        objRs("paypalemail") = Request.Form("paypalemail") 
	                        objRs("tranzilausername") = Request.Form("tranzilausername") 
	                        objRs("tranzilapassword") = Request.Form("tranzilapassword") 
                            objRs("CardTypes") = Request.Form("CardTypes")
	                        objRs("AprooveDetailsText") = Request.Form("AprooveDetailsText") 
	                        objRs("ThankYouText") = Request.Form("ThankYouText")
	                        objRs("OrderdetailsText") = Request.Form("OrderdetailsText")
	                        objRs("SendMailToCust") = Request.Form("SendMailToCust") 
	                        objRs("SendMailToMerch") = Request.Form("SendMailToMerch")
	                        objRs("ShowFamilyName") = Request.Form("ShowFamilyName")
                            objRs("ShowAddress2") = Request.Form("ShowAddress2") 
	                        objRs("ShowCity") = Request.Form("ShowCity")
	                        objRs("ShowCountry") = Request.Form("ShowCountry")
	                        objRs("ShowZipcode") = Request.Form("ShowZipcode") 
	                        objRs("ShowPhone") = Request.Form("ShowPhone")
	                        objRs("Showcellular") = Request.Form("Showcellular") 
	                        objRs("ShowEmail") = Request.Form("ShowEmail") 
	                        objRs("ShowShippingForm") = Request.Form("ShowShippingForm")
	                        objRs("Showshipaddress") = Request.Form("Showshipaddress") 
	                        objRs("Showshipcompany") = Request.Form("Showshipcompany") 
	                        objRs("ShowPaymentForm") = Request.Form("ShowPaymentForm") 
	                        objRs("ShowPaymentMethod") = Request.Form("ShowPaymentMethod") 
	                        objRs("ShowCAddress") = Request.Form("ShowCAddress") 
	                        objRs("ShowIdNumber") = Request.Form("ShowIdNumber") 
	                        objRs("ShowCnv") = Request.Form("ShowCnv") 
	                        objRs("ShowComments") = Request.Form("ShowComments")
	                        objRs("ShowCartContents") = Request.Form("ShowCartContents") 
	                        objRs("shopproductsOrder") = Request.Form("shopproductsOrder") 
	                        objRs("Shipingmethod") = Request.Form("Shipingmethod") 
	                        objRs("NumberofPayments") = Request.Form("NumberofPayments") 
                           ' objRs("shopshowhowmanyprodincategories") = Request.Form("shopshowhowmanyprodincategories") 
	                       ' objRs("cartheader") = Request.Form("cartheader") 
	                       ' objRs("cartfooter") = Request.Form("cartfooter")
								objRs.Update
								objRs.Close
									Response.Redirect("admin_shopconfig.asp?notificate=הגדרות נערכו בהצלחה")
	       
	        
	       

	            End Select
		Else
			If Request.QueryString("action") ="edit" OR  Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM shopconfig WHERE ShopConfigID=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM shopconfig WHERE SiteID=" & SiteID   
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

 
<form action="admin_shopconfig.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("ShopConfigID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת קישור</h1>
				<% ELSE 
				%>
					<h1>עריכת קישור</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="20%" align="right"><p>שם:</p><img src="images/ask22.png" id="east" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					  <textarea name="ShopConfigName" cols="3" class="goodinputlong required"><%If Editmode = "True" Then print objRs("ShopConfigName") End If %></textarea>
					  </td>
					</tr>
					<tr>
						<td width="15%" align="right"><p>מטבע ברירית מחדל:</p><img src="images/ask22.png" id="east4" original-title="הדף יופיע רק שהאתר בשפה שתבחר" /></td>
						<td width="35%" align="right"><%
                        SQLc = "SELECT * FROM Currency WHERE SiteID=" & SiteID
							Set objRsc = OpenDB(SQLc)
						%>					  					
						<select class="goodselectshort"  name="DefaultCurrency">
						<%
						If Editmode = "True" Then
							Do While Not objRsc.EOF	%>
							<option value="<% = objRsc("Code") %>"<% If objRsc("Code") = objRs("DefaultCurrency") Then Response.Write(" selected") End if %>><% = objRsc("Name") %></option>
						<%	objRsc.MoveNext 
								Loop
						Else
							Do While Not objRsc.EOF
						%><option value="<% = objRsc("Code") %>"<% If Trim(objRsc("Code")) = Session("DefaultCurrency") Then Response.Write(" selected") End if %>><% = objRsc("Name") %></option>
						<%	
							objRsc.MoveNext 
								Loop
						End If
						%>
						</select>
						
						<% 
						objRsc.Close
						%></td>
					</tr>

                    <tr>
						<td width="20%" align="right"><p>סימון מטבע</p><img src="images/ask22.png" id="Img1" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					  <input name="CurrencySymbol" class="goodinputshort" style="width:25px;" <%If Editmode = "True" Then%> value="<%= objRs("CurrencySymbol") %>"<%End If %> />
					  </td>
					</tr>

					<tr>
						<td width="20%" align="right"><p>כתובת</p><img src="images/ask22.png" id="Img2" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					  <input name="Address" class="goodinputshort" <%If Editmode = "True" Then%> value="<%= objRs("Address") %>"<%End If %> />
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>קנייה למשתמשים רשומים בלבד?</p><img src="images/ask22.png" id="Img5" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
					 <td align="right"><input id="OnlyRegisterdUsers"  type="checkbox" dir="ltr" name="OnlyRegisterdUsers" value="1" <%If Editmode = "True" Then %><% If objRs("OnlyRegisterdUsers")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					  </td>
					</tr>
                    <tr>
				    <td width="20%" align="right">הפניית המשך בקנייה:</td>
					<td valign="middle" width="72%">
   					<select class="goodselect" name="showcontinueurl">
						<% Set objRsNews = OpenDB("SELECT Urltext, Name FROM Content WHERE Contenttype < 3 AND SiteID= " & SiteID)						  
					       Do While Not objRsNews.EOF %>											    
							<option value="<% =objRsNews("Urltext")%>"<% If objRs("showcontinueurl") = objRsNews("Urltext") Then Response.Write(" selected") %> ><% = objRsNews("Name") %></option>
						<%	objRsNews.MoveNext 
								Loop
							objRsNews.Close	%>
					</select>
					</td>
				  </tr>
					<tr>
						<td width="20%" align="right"><p>הפנייה בסיום הקנייה</p><img src="images/ask22.png" id="Img6" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
						<td width="80%" align="right">
					<div style="position:relative;">
   					<select class="goodselect" name="homepage">
						<% Set objRsNews = OpenDB("SELECT Urltext, Name FROM Content WHERE Contenttype < 3 AND SiteID= " & SiteID)						  
					       Do While Not objRsNews.EOF %>											    
							<option value="<% =objRsNews("Urltext")%>"<% If objRs("homepage") = objRsNews("Urltext") Then Response.Write(" selected") %> ><% = objRsNews("Name") %></option>
						<%	objRsNews.MoveNext 
								Loop
							objRsNews.Close	%>
					</select>
					  </div>
					  </td>
					</tr>
					<tr>
						<td width="20%" align="right"><p>להציג המשך בקנייה</p><img src="images/ask22.png" id="Img7" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
					 <td align="right"><input id="showcontinueshoping"  type="checkbox" dir="ltr" name="showcontinueshoping" value="1" <%If Editmode = "True" Then %><% If objRs("showcontinueshoping")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					</tr>

					<tr>
						<td width="20%" align="right"><p>להציג סל בטופס מילוי פרטים</p><img src="images/ask22.png" id="Img14" original-title="" /></td>
					 <td align="right"><input id="ShowCartContents"  type="checkbox" dir="ltr" name="ShowCartContents" value="1" <%If Editmode = "True" Then %><% If objRs("ShowCartContents")= 1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					</tr>


                    
					<tr>
						<td align="left" colspan="2"><input type="submit" value="שמור" class="saveform"  /></td>
					</tr>
				</table>
				</div>
			</div>
<div id="left">
<div id="formcontainer">
<center>
    <div id="formcontent">
        <div id="formleftfields">
		    <div style="width:100%;" id="accordion">
            <h3><a style="background:url(images/template.png) no-repeat right;" href="#">טקסטים</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table2">
                         <tr><td align="right">טקסט מתחת לעגלת קניות</td>
                         </tr>
                         <tr>
                            <td align="right"><textarea name="textundercart" rows="3" cols="10" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("textundercart") End If %></textarea></td>
                        </tr>
                         <tr><td align="right">טקסט לפני אישור הקנייה</td>
                         </tr>
                         <tr>
                            <td align="right"><textarea name="AprooveDetailsText" rows="3" cols="10" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("AprooveDetailsText") End If %></textarea></td>
                        </tr>
                         <tr><td align="right">טקסט תודה על קנייתך</td>
                         </tr>
                         <tr>
                            <td align="right"><textarea name="ThankYouText" rows="3" cols="10" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("ThankYouText") End If %></textarea></td>
                        </tr>
                         <tr><td align="right">טקסט פרטי ההזמנה</td>
                         </tr>
                         <tr>
                            <td align="right"><textarea name="OrderdetailsText" rows="3" cols="10" class="goodinputlongbig"><%If Editmode = "True" Then print objRs("OrderdetailsText") End If %></textarea></td>
                        </tr>
                        
                    </table>
			</div>

			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">שליחת Email</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                    					<tr>
						<td width="40%" align="right"><img src="images/ask22.png" id="Img8" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /><p>כתובת מנהל לשליחת Email</p></td>
						<td width="60%" align="right">
					  <input name="ordersemail" class="goodinputshort" <%If Editmode = "True" Then%> value="<%= objRs("ordersemail") %>"<%End If %> />
					  </td>
					</tr>
                    <tr>
						<td width="40%" align="right"><p>האם לשלוח מייל למנהל?</p><img src="images/ask22.png" id="Img9" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
					 <td align="right"><input id="Checkbox1"  type="checkbox" dir="ltr" name="sendemailtomanager" value="1" <%If Editmode = "True" Then %><% If objRs("sendemailtomanager")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					  </td>
					</tr>
                    <tr>
						<td width="40%" align="right"><p>האם לשלוח מייל ללקוח?</p><img src="images/ask22.png" id="Img10" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /></td>
					 <td align="right"><input id="sendemailtocastomer"  type="checkbox" dir="ltr" name="sendemailtocastomer" value="1" <%If Editmode = "True" Then %><% If objRs("sendemailtocastomer")= True Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					  </td>
					</tr>

                    </table>
            </div>
			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">ממשקי תשלום</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table1">
                     <tr>
						<td width="40%" align="right"><img src="images/ask22.png" id="Img3" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /><p>קישור לדף מאובטח</p></td>
						<td width="60%" align="right">
					  <input name="checkoutURL" class="goodinputlong" style="width:300px;direction:ltr;" <%If Editmode = "True" Then%> value="<%= objRs("checkoutURL") %>"<%End If %> />
					  </td>
					</tr>
                     <tr>
						<td width="40%" align="right"><img src="images/ask22.png" id="Img4" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /><p>סוגי כרטיסי אשראי</p></td>
						<td width="60%" align="right">
					  <input name="CardTypes" class="goodinputlong" style="width:300px;" <%If Editmode = "True" Then%> value="<%= objRs("CardTypes") %>"<%End If %> />
					  </td>
					</tr>
                     <tr>
						<td width="40%" align="right"><img src="images/ask22.png" id="Img15" original-title="כותרת הדף כמו שתופיע באתר<br />חשוב לקידום האתר בגוגל" /><p>תשלומים</p></td>
						<td width="60%" align="right">
					  <input name="NumberofPayments" class="goodinputlong" style="width:50px;" <%If Editmode = "True" Then%> value="<%= objRs("NumberofPayments") %>"<%End If %> />
					  </td>
					</tr>
                    
                     <tr>
						<td width="40%" align="right"><img src="images/ask22.png" id="Img11" original-title="123" /><p>חשבון PayPal</p></td>
						<td width="60%" align="right">
					  <input name="CardTypes" class="goodinputlong" style="width:300px;" <%If Editmode = "True" Then%> value="<%= objRs("paypalemail") %>"<%End If %> />
					  </td>
					</tr>
                     <tr>
						<td width="40%" align="right"><img src="images/ask22.png" id="Img12" original-title="123" /><p>שם משתמש טרנזילה</p></td>
						<td width="60%" align="right">
					  <input name="CardTypes" class="goodinputlong" style="width:300px;" <%If Editmode = "True" Then%> value="<%= objRs("tranzilausername") %>"<%End If %> />
					  </td>
					</tr>
                     <tr>
						<td width="40%" align="right"><img src="images/ask22.png" id="Img13" original-title="123" /><p>סיסמא טרנזילה</p></td>
						<td width="60%" align="right">
					  <input name="CardTypes" class="goodinputlong" style="width:300px;" <%If Editmode = "True" Then%> value="<%= objRs("tranzilapassword") %>"<%End If %> />
					  </td>
					</tr>
                    </table>
            </div>
			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">אפשרויות טופס תשלום</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table3">
                        <tr>
                        <td width="30%" align="right"><p>להציג טופס תשלום</p></td>
                        <td align="right"><input id="ShowPaymentForm"  type="checkbox" dir="ltr" name="ShowPaymentForm" value="1" <%If Editmode = "True" Then %><% If objRs("ShowPaymentForm")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג אמצעי תשלום</p></td>
                        <td align="right"><input id="ShowPaymentMethod"  type="checkbox" dir="ltr" name="ShowPaymentMethod" value="1" <%If Editmode = "True" Then %><% If objRs("ShowPaymentMethod")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג כתובת בתשלום</p></td>
                        <td align="right"><input id="ShowCAddress"  type="checkbox" dir="ltr" name="ShowCAddress" value="1" <%If Editmode = "True" Then %><% If objRs("ShowCAddress")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג מספר ת.ז</p></td>
                        <td align="right"><input id="ShowIdNumber"  type="checkbox" dir="ltr" name="ShowIdNumber" value="1" <%If Editmode = "True" Then %><% If objRs("ShowIdNumber")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג קוד אימות</p></td>
                        <td align="right"><input id="ShowCnv"  type="checkbox" dir="ltr" name="ShowCnv" value="1" <%If Editmode = "True" Then %><% If objRs("ShowCnv")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>

                    </table>
            </div>
			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">טופס פרטי לקוח</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table4">
                        <tr>
                        <td width="30%" align="right"><p>להציג שם משפחה?</p></td>
                        <td align="right"><input id="ShowFamilyName"  type="checkbox" dir="ltr" name="ShowFamilyName" value="1" <%If Editmode = "True" Then %><% If objRs("ShowFamilyName")=1 Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג כתובת2?</p></td>
                        <td align="right"><input id="ShowAddress2"  type="checkbox" dir="ltr" name="ShowAddress2" value="1" <%If Editmode = "True" Then %><% If objRs("ShowAddress2")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג עיר?</p></td>
                        <td align="right"><input id="ShowCity"  type="checkbox" dir="ltr" name="ShowCity" value="1" <%If Editmode = "True" Then %><% If objRs("ShowCity")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג מדינה?</p></td>
                        <td align="right"><input id="ShowCountry"  type="checkbox" dir="ltr" name="ShowCountry" value="1" <%If Editmode = "True" Then %><% If objRs("ShowCountry")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג מיקוד?</p></td>
                        <td align="right"><input id="ShowZipcode"  type="checkbox" dir="ltr" name="ShowZipcode" value="1" <%If Editmode = "True" Then %><% If objRs("ShowZipcode")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג טלפון?</p></td>
                        <td align="right"><input id="ShowPhone"  type="checkbox" dir="ltr" name="ShowPhone" value="1" <%If Editmode = "True" Then %><% If objRs("ShowPhone")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג סלולאר?</p></td>
                        <td align="right"><input id="Showcellular"  type="checkbox" dir="ltr" name="Showcellular" value="1" <%If Editmode = "True" Then %><% If objRs("Showcellular")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג Email?</p></td>
                        <td align="right"><input id="ShowEmail"  type="checkbox" dir="ltr" name="ShowEmail" value="1" <%If Editmode = "True" Then %><% If objRs("ShowEmail")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>

                    </table>
            </div>
			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">הגדרות טופס משלוח</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table5">
                    <tr>  
                       <td width="20%" align="right">שיטת משלוח:</td>
					        <td valign="middle" width="72%">
   					<select class="goodselect" name="Shipingmethod">
							<option value="types"<% If objRs("Shipingmethod") = "types" Then Response.Write(" selected") %> >בחירה מתוך רשימה</option>
							<option value="product"<% If objRs("Shipingmethod") = "product" Then Response.Write(" selected") %> >לפי מוצרים</option>
					</select>
					</td>
				  </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג טופס משלוח?</p></td>
                        <td align="right"><input id="ShowShippingForm"  type="checkbox" dir="ltr" name="ShowShippingForm" value="1" <%If Editmode = "True" Then %><% If objRs("ShowShippingForm")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג כתובת למשלוח?</p></td>
                        <td align="right"><input id="Showshipaddress"  type="checkbox" dir="ltr" name="Showshipaddress" value="1" <%If Editmode = "True" Then %><% If objRs("Showshipaddress")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג חברה במשלוח?</p></td>
                        <td align="right"><input id="Showshipcompany"  type="checkbox" dir="ltr" name="Showshipcompany" value="1" <%If Editmode = "True" Then %><% If objRs("Showshipcompany")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>
                        <tr>
                        <td width="30%" align="right"><p>להציג תיבת הערות?</p></td>
                        <td align="right"><input id="ShowComments"  type="checkbox" dir="ltr" name="ShowComments" value="1" <%If Editmode = "True" Then %><% If objRs("ShowComments")= "1" Then print " checked=""yes""" %><% Else %> checked="yes"<% End If %>"  /></td>
					    </tr>

                    </table>
            </div>
			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">הגדרות שליחת Email</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table6">
                    </table>
            </div>
			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">הגדרות שליחת Email</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table7">
                    </table>
            </div>
			<h3><a style="background:url(images/seo.png) no-repeat right;" href="#">הגדרות שליחת Email</a></h3>
			<div>
                    <table class="leftstuff" dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="Table8">
                    </table>
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