<!--#include file="../config.asp"-->
<!--#include file="user_header.asp"-->
<%
SetSession "BackURL","/admin/user_parking.asp"
If Request.Cookies(SiteID & "UserLevel") = "" Then 
 Response.Redirect("/user/login.asp")
End If
    CheckUserSecurity_Level Request.Cookies(SiteID & "UserLevel"),GetSession("BackURL")



 %>
<script type="text/javascript">


var ajaxvar;
var pm,hr,dl,wl,ml,yl;
var parkid = '<%=request("ID")%>';

    $(document).ready(function () {
			$('#contentTable').tablesorter({ sortForce: [[0, 0]] });
			$("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });
			$('#east').tipsy({ html: true });
			$('#east2').tipsy({ html: true });
			$('#east3').tipsy({ html: true });
			
			citychange();
			
			loadstreets($("#city").val());
			loadparkranges();
			$("#checkboxim input").change(function() {
				checkboxim();
			});
			
			
	});
	
	function loadparkranges() {
	$.ajax({
				type: 'POST',
				url: "admin_park_json.asp",
				data: {m:"parkrange",id:parkid},
				success: function(data) {
				$("#parkrange tbody").html(data);
				checkboxim();
				$("table#katzar tbody").empty();
					}
				});

	}
	function checkboxim() {
		pm =  $("#checkboxim input:checkbox[id=payment]").is(":checked");
		hr =  $("#checkboxim input:checkbox[id=hourly]").is(":checked");
		dl =  $("#checkboxim input:checkbox[id=Daily]").is(":checked");
		wl =  $("#checkboxim input:checkbox[id=weekly]").is(":checked");
		ml =  $("#checkboxim input:checkbox[id=monthly]").is(":checked");
		yl =  $("#checkboxim input:checkbox[id=yearly]").is(":checked");
		if (hr || dl) {
		$("tr.shortrange").show();
		 } else {
		 $("tr.shortrange").hide();
		 }
		if (wl || ml || yl) {
		$("tr.longrange").show();
		} else {
		$("tr.longrange").hide();
		}
			
		
	}
	
	function citychange() {
		$("#city").change(function() {
			loadstreets($(this).val());
			});
		}

		
function loadstreets(streetname) {
if (ajaxvar)ajaxvar.abort();
			ajaxvar = $.ajax({
				type: 'POST',
				url: "admin_park_json.asp",
				data: {m:"city",city:streetname},
				success: function(data) {
				var output = [];
						$.each(data, function(i,park){
						if (park.street != null)
							output.push('<option value="'+ park.street +'"'
							+((park.street.replace("\'","").replace("\"","").replace("''","") == $("#defstreetv").val().replace("\'","").replace("\"","").replace("''","")) ? ' selected="selected" ':'')
							+'>'+ park.street +' </option>');
						
						});
						$('#street_name').html(output.join(''));
						$("#submi").attr("disabled","").css("cursor","");
					},

				dataType: "json",
				beforeSend:function() {
					$("#street_name").addClass("ajax");
				},
				complete:function() {
					$("#street_name").removeClass("ajax");
				}
				
			});
}

function addparkrange() {
var rand_no = Math.random();
rand_no = rand_no * 1000;
rand_no = Math.ceil(rand_no);


 $("table#katzar tbody").load("addparkrangerow.asp?rnd="+rand_no);
}
function addparkrangrow(i) {
var afromday = $("#afromday"+i).val();
var atoday = $("#atoday"+i).val();
var afromhour = $("#afromhour"+i).val();
var atohour = $("#atohour"+i).val();
var afirstHourPrice = $("#afirstHourPrice"+i).val();
var aextraQuarterPrice = $("#aextraQuarterPrice"+i).val();
var aallDayPrice = $("#aallDayPrice"+i).val();
var aonetimehour = $("#aonetimehour"+i).val();
var aonetimeprice = $("#aonetimeprice"+i).val();
if (aallDayPrice == '' || aextraQuarterPrice == ''||afirstHourPrice == '') {
alert("חסרים שדות");
return false;
}

if (ajaxvar)ajaxvar.abort();
	ajaxvar = $.ajax({
				type: 'POST',
				url: "admin_park_json.asp",
				data: {pid:parkid,m:"addparkrange",onetimeprice:aonetimeprice,onetimehour:aonetimehour,fromday:afromday,xtoday:atoday,fromhour:afromhour,tohour:atohour,firstHourPrice:afirstHourPrice,extraQuarterPrice:aextraQuarterPrice,allDayPrice:aallDayPrice},
				success: function(data) {
				if (data)
					loadparkranges()
					}
				
			});

}

function delrange(id) {

 $.ajax({
				type: 'POST',
				url: "admin_park_json.asp",
				data: {relid:id,m:"delrange"},
				success: function(data) {
				if (data)
					loadparkranges()
					}
				
			});

}
</script>
<%

'CheckSecuirty "Parking"


If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then

%>
	<div id="incontent">
	<div class="incontentboxgrid">
   

<center>
<%
	If Request.QueryString("records") = "" Then
	Session("records") = 50
	Else 
	Session("records") = Request.QueryString("records")
	End If

'CheckSecuirty "parking"
 %>   
    <div class="formtitle">
        <h1>ניהול קישורים אוטומטים</h1>
		<div class="admintoolber">
        <form action="user_Parking.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %>&string=<%=Request.form("search") %>&lang=<%=Request.form("lang") %>" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="user_Parking.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="user_Parking.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p><a href="user_Parking.asp?format=doc&<%Request.Querystring %>"><img src="images/word.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='user_Parking.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
		<th style="width:36%;text-align:right;padding-right:40px;cursor:pointer;">שם חניון</th>
		<th style="width:8%;">ערוך</th>
        <th style="width:8%;">שכפל</th>
        <th style="width:8%;">מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If  Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
                SQL = "SELECT * FROM [Parking] WHERE SiteID=" & SiteID
     If Request.QueryString("mode") = "search" then
            If Request.form("search") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("search") & "%'"
             End If
    End If
                 SQL = SQL & " AND UsersID =" & Request.Cookies(SiteID & "UserID")
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	            objRsg.PageSize = Session("records")
                HowMany = 0
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize

            	%>
    <tr style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td><%= objRsg("ParkingId")  %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("ParkingID") %>_Name"><% = objRsg("Name") %></div></td>
        <td><a href="user_Parking.asp?ID=<% = objRsg("ParkingId") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="user_Parking.asp?ID=<% = objRsg("ParkingId") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td><a href="user_Parking.asp?ID=<% = objRsg("ParkingId") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
    </tr>	
<%    HowMany = HowMany + 1
 objRsg.MoveNext
		 Loop
%>
  	            <tr valign="top">
		            <td style="border-bottom:1px solid #ccc;height:25px;vertical-align:middle;" align="center" colspan="8">
	      	            <table width="300" cellspacing="0" align="center">
		  		            <% If Not objRsg.PageCount = 0 Then
				                    If Len(Request.QueryString("page")) > 0 Then
				                        objRsg.AbsolutePage = Request.QueryString("page")
				                       Else
				                        objRsg.AbsolutePage = 1
				                    End If
					            End If
				            %>
					            <tr>
							            <td width="166"><font size="2">
							                <img border="0" src="../admin/images/rightadmin.gif" width="16" height="16" align="left"></font>
							             </td>
							            <td width="177"><font size="2" face="Arial">
							                <div align="center">
	                        <% If objRsg.AbsolutePage > 1 Then %>
					                        <a href="user_Parking.asp?page=<% = objRsg.AbsolutePage - 1 %>&records=<% = Session("records")  %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRsg.AbsolutePage < objRsg.PageCount Then %>
					                         <a href="user_Parking.asp?page=<% = objRsg.AbsolutePage + 1 %>&records=<%= Session("records")  %>" style="text-decoration: none"><% 	End If%>
					                         <font color="#808080">דף הבא</font></a></font>
					                     </td>
							                <td width="167"><font size="2" face="Arial">
							                <img border="0" src="../admin/images/leftadmin.gif" width="16" height="16" align="right"></font>
						                </td>
						            </tr>
					            </table>
			               </td>
		            </tr>

<%
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

			        Sql = "SELECT * FROM Parking WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				              objRs("SiteID") = SiteID
	                           objRs("name") = Request.Form("name")
	                           objRs("street_name") = Request.Form("street_name")
	                           objRs("house_number") = Request.Form("house_number")
	                           objRs("city") = Request.Form("city")
	                           objRs("numberofparks") = Request.Form("numberofparks")
	                           objRs("tel") = Request.Form("tel")
	                           objRs("fax") = Request.Form("fax")
	                           objRs("email") = Request.Form("email")
	                           objRs("onlymail") = Request.Form("onlymail")
	                           objRs("comment") = Request.Form("comment")
	                           objRs("payment") = Request.Form("payment")
	                         '  objRs("price") = Request.Form("price")
	                           objRs("pricefortime") = Request.Form("pricefortime")
	                           objRs("cartype") = Request.Form("cartype")
	                           objRs("latitude") = Request.Form("latitude")
	                           objRs("longitude") = Request.Form("longitude")
	                           objRs("Image") = Request.Form("Image")
	                           objRs("Image2") = Request.Form("Image2")
	                           objRs("StartDate") = Request.Form("StartDate")
	                           objRs("EndDate") = Request.Form("EndDate")
	                           objRs("Heniontype") = Request.Form("Heniontype")
	                           objRs("Lelohagbalatheshbon") = Request.Form("Lelohagbalatheshbon")
	                           objRs("majsom") = Request.Form("majsom")
	                           objRs("tatkarkait") = Request.Form("tatkarkait")
	                           ' Ran Brandes objRs("mekura") = Request.Form("mekura")
	                           objRs("toshav") = Request.Form("toshav")
	                           objRs("criple") = Request.Form("criple")
	                           objRs("Hourly") = Request.Form("Hourly")
	                           objRs("Daily") = Request.Form("Daily")
	                           objRs("Weekly") = Request.Form("Weekly")
	                           objRs("Monthly") = Request.Form("Monthly")
	                           objRs("yearly") = Request.Form("yearly")
	                           objRs("contactname") = Request.Form("contactname")
	                           objRs("parkingtype") = Request.Form("parkingtype")
	                           objRs("payments") = Request.Form("payments")
	                           objRs("nolimit") = Request.Form("nolimit")
	                           objRs("withlock") = Request.Form("withlock")
	                           objRs("underground") = Request.Form("underground")
	                           objRs("roof") = Request.Form("roof")
	                           objRs("criple") = Request.Form("criple")
	                           objRs("cc") = Request.Form("cc")
	                           objRs("cash") = Request.Form("cash")
	                           objRs("cheak") = Request.Form("cheak")
	                           objRs("paypal") = Request.Form("paypal")
	                           objRs("jenion") = Request.Form("jenion")
	                           objRs("manuytype") = Request.Form("manuytype")
	                           objRs("coupon") = Request.Form("coupon")
	                           objRs("coupon_text") = Request.Form("coupon_text")
	                           objRs("Current_Pnuyot") = Request.Form("Current_Pnuyot")
                               objRs("UsersID") = Request.Cookies(SiteID & "UserID")		
                               objRs("vip") = 0		
                                objRs.Update
								objRs.Close
								if GetSession("lid") <> ""   then
									print GetSession("lid") &"<HR>"
									sql = "select top 1 ParkingId from parking order by parkingid desc"
									print sql&"<hr>"
									set objrs = opendb(sql)
									lastid = objrs("parkingid")
									objrs.close
									Sql = "update parking_shortrange set parkId = '"&lastid&"' where parkId= '"&GetSession("lid")&"' and siteid = "& SiteID
									print sql&"<hr>"
									Set objRs = OpenDB(sql)
									SetSession "lid",""
								end if
							
								
									Response.Redirect("user_Parking.asp?notificate=חנייה נוספה בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM Parking WHERE ParkingId=" & Request.QueryString("ID") & " AND SiteID= " & SiteID & " AND UsersID =" & Request.Cookies(SiteID & "UserID")
			            Set objRs = OpenDB(sql)
	                           objRs("name") = Request.Form("name")
	                           objRs("street_name") = Request.Form("street_name")
	                           objRs("house_number") = Request.Form("house_number")
	                           objRs("city") = Request.Form("city")
	                           objRs("numberofparks") = Request.Form("numberofparks")
	                           objRs("tel") = Request.Form("tel")
	                           objRs("fax") = Request.Form("fax")
	                           objRs("email") = Request.Form("email")
	                           objRs("onlymail") = Request.Form("onlymail")
	                           objRs("comment") = Request.Form("comment")
	                           objRs("payment") = Request.Form("payment")
	                           objRs("pricefortime") = Request.Form("pricefortime")
	                           objRs("cartype") = Request.Form("cartype")
	                           objRs("latitude") = Request.Form("latitude")
	                           objRs("longitude") = Request.Form("longitude")
	                           objRs("Image") = Request.Form("Image")
	                           objRs("Image2") = Request.Form("Image2")
	                           objRs("StartDate") = Request.Form("StartDate")
	                           objRs("EndDate") = Request.Form("EndDate")
	                           objRs("Heniontype") = Request.Form("Heniontype")
	                           objRs("Lelohagbalatheshbon") = Request.Form("Lelohagbalatheshbon")
	                           objRs("majsom") = Request.Form("majsom")
	                           objRs("tatkarkait") = Request.Form("tatkarkait")
	                           ' Ran Brandes objRs("mekura") = Request.Form("mekura")
	                           objRs("toshav") = Request.Form("toshav")
	                           objRs("criple") = Request.Form("criple")
	                           objRs("Hourly") = Request.Form("Hourly")
	                           objRs("Daily") = Request.Form("Daily")
	                           objRs("Weekly") = Request.Form("Weekly")
	                           objRs("Monthly") = Request.Form("Monthly")
	                           objRs("yearly") = Request.Form("yearly")
	                           objRs("contactname") = Request.Form("contactname")
	                           objRs("parkingtype") = Request.Form("parkingtype")
	                           objRs("payments") = Request.Form("payments")
	                           objRs("nolimit") = Request.Form("nolimit")
	                           objRs("withlock") = Request.Form("withlock")
	                           objRs("underground") = Request.Form("underground")
	                           objRs("roof") = Request.Form("roof")
	                           objRs("criple") = Request.Form("criple")
	                           objRs("cc") = Request.Form("cc")
	                           objRs("cash") = Request.Form("cash")
	                           objRs("cheak") = Request.Form("cheak")
	                           objRs("paypal") = Request.Form("paypal")
	                           objRs("jenion") = Request.Form("jenion")
	                           objRs("manuytype") = Request.Form("manuytype")
	                           objRs("coupon") = Request.Form("coupon")
	                           objRs("coupon_text") = Request.Form("coupon_text")
	                           objRs("Current_Pnuyot") = Request.Form("Current_Pnuyot")
                               

							   objRs.Update
								objRs.Close
									Response.Redirect("user_Parking.asp?notificate=חנייה נערכה בהצלחה")
	        
	        Case "delete"
				    Sql = "SELECT * FROM Parking WHERE ParkingId=" & Request.QueryString("ID") & " AND UsersID =" & Request.Cookies(SiteID & "UserID") 
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
									Response.Redirect("user_Parking.asp?notificate=חנייה נמחקה בהצלחה")
	        

	            End Select
		Else
			If Request.QueryString("action") ="edit" OR  Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM parking WHERE parkingID=" & Request.QueryString("ID") & " And SiteID=" & SiteID & " AND UsersID =" & Request.Cookies(SiteID & "UserID")
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM parking WHERE SiteID=" & SiteID   
			End If	
				Set objRs = OpenDB(SQL)
					If Session("Level") > 3 Then 
						Response.Write("<br><br><p align='center'>אין לך הרשאה לבצע פעולה זאת <a href='user_home.asp'>נסה שנית</a>!</p>")
            If objRs.recordcount = 0 then
                print "ארעה שגיעה"
                response.End
            end if
				
		Else
		
		If Request.QueryString("action")<> "add" then
		    Editmode = "True"
		Else
		    Editmode = "False"
        End If	

 %>
 <div id="incontentform">
<style>
.addpark th{
background:#555;
font-size:16px;
height:25px;
line-height:25px;
padding:0 5px;
color:#fff;
}
.addpark td{
padding:5px;
height:25px;
line-height:25px;
}
</style>

<form action="user_Parking.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("parkingID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת חניון</h1>
				<% ELSE 
				%>
					<h1>עריכת חניון</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
<table class="addpark" style="text-align:right;" cellspacing="0" cellpadding="0" border="0" dir="rtl" width="100%">
    <tr>

		<th colspan="3">כתובת החניה</th>
	</tr>
	<tr>
        <td>
		עיר:
		<input type="hidden" id="defcityv" value="<%=trim(objRs("city"))%>">
		<input type="hidden" id="defstreetv" value="<%=trim(objRs("street_name"))%>">
        	<select id="city" name="city" >
        <%
		set objrcity= OpenDB("SELECT DISTINCT city FROM streets") %>
		<option value="null">בחר עיר</option>
        <%do while not objrcity.eof %>
				<option value="<%=objrcity("city")%>"<% if objrcity("city") = objRs("city")  then %> selected="selected" <% End if %>><%=objrcity("city") %></option>
        <%objrcity.movenext
                loop %>
			</select>
            <% closeDB(objrcity) %>
            </td>
            <td>
		רחוב:
        <select id="street_name" name="street_name" >
       
			</select>
       </td>
		<td width="175">
		מספר בית:	<input type="text" name="house_number" value="<% If Editmode = "True" Then print objRs("house_number") else print 0 End If %>" style="width:30px;"  />
		</td>
	</tr>
    <tr>
		<th colspan="6">כותרת עבור החניה</th>
	</tr>
	<tr>
		<td colspan="6" valign="top">
			<input id="Text1" type="text" name="name" value="<% If Editmode = "True" Then print objRs("name") End If %>" style="width:500px;" class="required" />
       

		</td>
	</tr>
	<tr>
		<th colspan="6">תיאור החניה</th>
	</tr>
	<tr>
		<td colspan="6">
			<textarea rows="3" name="comment" cols="47" style="width:500px;" class="" onKeyDown="formTextCounter(this.form.comment,this.form.remLen_comment,200);" onKeyUp="formTextCounter(this,$('remLen_comment'),200);" wrap="soft"><% If Editmode = "True" Then print objRs("comment") End If %></textarea><br>
		</td>
	</tr>
    <tr>

		<th colspan="3">פרטים נוספים</th>
	</tr>
    <tr>
    	<td width="280">
		סוג חניה:	<select id="Heniontype" name="Heniontype" onchange="" style="" class="">
				<option value="חניה פרטית"<% if objRs("Heniontype") = "חניה פרטית" then %>selected=" selected"<% End if %>>חניה פרטית</option>
				<option value="חניון"<% if objRs("Heniontype") = "חניון" then %>selected=" selected"<% End if %>>חניון</option>
			</select>
		</td>
    	<td>
			<input id="Text2" type="text" name="latitude"  value="<% If Editmode = "True" Then print objRs("latitude") End If %>" style="width:100px;" class="required"  />latitude
        </td>
        <td>
           <p><input id="Text3" type="text" name="longitude" value="<% If Editmode = "True" Then print objRs("longitude") End If %>" style="width:100px;" class="required"  />longitude</p>
		</td>

    </tr>
	<tr>
		<th>פרטי התקשרות</th>
		<th></th>
		<th>זמינות החניה</th>
	</tr>
	<tr>
		<td>
			Email:<input  type="text" name="email" onchange="" maxlength="" value="<% If Editmode = "True" Then print objRs("email") End If %>" class="required email"/><br />
		</td>
		<td>
			שם:<input  type="text" name="contactname" onchange="" maxlength="" value="<% If Editmode = "True" Then print objRs("contactname") End If %>"/>
		</td>
        <td></td>
        </tr>
        <tr>
        <td>
        	טלפון:<input  type="text" name="tel" onchange="" maxlength="" value="<% If Editmode = "True" Then print objRs("tel") End If %>"/>
        </td>
        <td>
			<input  type="radio" name="onlymail" value="1" <% If Editmode = "True" AND  objRs("onlymail") = True then%> checked <% end if %>  onclick="return onlymail_onclick()" /> הצג פרטי התקשרות 
			<input  type="radio" name="onlymail" value="0" <% If Editmode = "True" AND  objRs("onlymail") = False then%> checked <% end if %>  onclick="return onlymail_onclick()" /> הסתר פרטים
		</td>
        <td>
			מ:  <input id="Text4" type="text" name="StartDate" class="_date" value="<% If Editmode = "True" Then print objRs("StartDate") ELse print "1/1/2001" End If %>"  /><br />
            עד: <input id="Text5" type="text" name="EndDate" class="_date" value="<% If Editmode = "True" Then print objRs("EndDate") ELse print "31/12/2999" End If %>"  />

	    </td>
	</tr>
	<tr>
		<th>מספר חניות</th>
		<th>חניות פנויות</th>
		<th>תמונות החניה</th>
	</tr>
	<tr>
		<td>
        <input id="numberofparks" type="text" name="numberofparks"  value="<% If Editmode = "True" Then print objRs("numberofparks") else print 0 End If %>" style="width:100px;" class="" format="" alt=""/> 
		</td>
		<td>
        <input id="Current_Pnuyot" type="text" name="Current_Pnuyot"  value="<% If Editmode = "True" Then print objRs("Current_Pnuyot") else print 0 End If %>" style="width:100px;" class="" format="" alt=""/> 
		</td>
		<td>
		<input dir="ltr"  id="xFilePath" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" style="width:175px" />
		<input type="button" value="חפש בשרת" onclick="BrowseServer('xFilePath');"/>
		<input dir="ltr" id="xFilePath2" name="Image2" <%If Editmode = "True" Then %> value="<% =objRs("Image2")%>"<%End If %> type="text" style="width:175px" />
		<input type="button" value="חפש בשרת"  onclick="BrowseServer('xFilePath2');"/>
        </td>
	<tr>
		<th>בסיס השכרת חניה</th>
		<th></th>
		<th></th>
	</tr>
	<tr>
		<td colspan="2" id="checkboxim">
			<input id="payment" type="checkbox" value="1" name="payment" <% If Editmode = "True" AND  objRs("payment") = 1 then%> checked="checked" <% end if %>/> חינם 
			<input id="hourly" type="checkbox" value="1" name="hourly"<% If Editmode = "True" AND  objRs("hourly") = True then%> checked="checked" <% end if %> /> שעתי 
			<input id="Daily" type="checkbox" value="1" name="Daily"<% If Editmode = "True" AND  objRs("Daily") = True then%> checked="checked" <% end if %> /> יומי 
			<input id="weekly" type="checkbox" value="1" name="weekly"<% If Editmode = "True" AND  objRs("weekly") = True then%> checked="checked" <% end if %> /> 
			שבועי <input id="monthly" type="checkbox" value="1" name="monthly"<% If Editmode = "True" AND  objRs("monthly") = True then%> checked="checked" <% end if %> /> חודשי 
			<input id="yearly" type="checkbox" value="1" name="yearly"<% If Editmode = "True" AND  objRs("yearly") = True then%> checked="checked" <% end if %> /> שנתי
		</td>
		<td>
		</td>
	</tr>
<tr>
	<td colspan="3">
		<table	id="parkrange" width="100%">
			<tbody></tbody>
		</table>
	</td>
</tr>
	

<tr><td><span onclick="addparkrange()">הוספה+</span></td></tr>

<tr>
	<td colspan="3">
		<table id="katzar">
			<tbody></tbody>
		</table>
	</td>
</tr>

<div id="aroj">
    <tr  class="longrange">
		<th>טווח ארוך</th>
        <th></th>
        <th></th>
    </tr>

    <tr class="longrange">
		<td colspan="3">
			<input id="price" type="text" name="price"  value="<% If Editmode = "True" Then print objRs("price") else print 0 End If %>" style="width:30px;" class="" format="" alt=""/>ש"ח לכל 
			לכל
            <select id="pricefortime" name="pricefortime">
				<option value="שבוע"<% if objrs("pricefortime") = "שבוע" then %>selected=" selected"<% End if %>>שבוע</option>
				<option value="חודש"<% if objrs("pricefortime") = "חודש" then %>selected=" selected"<% End if %>>חודש</option>
				<option value="שנתי"<% if objrs("pricefortime") = "שנתי" then %>selected=" selected"<% End if %>>שנתי</option>
			</select>
             עבור
              <select id="cartype" name="cartype">
				<option value="רכב פרטי"<% if objrs("cartype") = "רכב פרטי" then %>selected=" selected"<% End if %>>רכב פרטי</option>
				<option value="רכב גדול"<% if objrs("cartype") = "רכב גדול" then %>selected=" selected"<% End if %>>רכב גדול</option>
                <option value="משאית"<% if objrs("cartype") = "משאית" then %>selected=" selected"<% End if %>>משאית</option>
			</select>
             סוג מנוי
              <select id="Select3" name="manuytype">
				<option value="רגיל"<% if objrs("manuytype") = "רגיל" then %>selected=" selected"<% End if %>>רגיל</option>
				<option value="vip"<% if objrs("manuytype") = "vip" then %>selected=" selected"<% End if %>>vip</option>
			</select>
             תשלומים 
			<select id="payments" name="payments" onchange="" style="" class="">
				<option value="1""<% if objrs("payments") = 1 then %>selected=" selected"<% End if %>>1</option>
				<option value="2""<% if objrs("payments") = 2 then %>selected=" selected"<% End if %>>2</option>
				<option value="3""<% if objrs("payments") = 3 then %>selected=" selected"<% End if %>>3</option>
			</select>
		</td>
    </tr>
</div>
	<tr>
		<th>מאפיינים</th>
		<th></th>
		<th></th>
	</tr>
	<tr>
		<td colspan="3">
			<input id="nolimit" type="checkbox" value="1" name="nolimit"<% If Editmode = "True" AND  objRs("nolimit") = True then%> checked="checked" <% end if %>  /> ללא הגבלת שעות 
			<input id="henion" type="checkbox" value="1" name="jenion"<% If Editmode = "True" AND  objRs("jenion") = True then%> checked="checked" <% end if %>  /> חניון
            <input id="withlock" type="checkbox" value="1" name="withlock"<% If Editmode = "True" AND  objRs("withlock") = True then%> checked="checked" <% end if %>  /> חניה עם מחסום 
			<input id="underground" type="checkbox" value="1" name="underground"<% If Editmode = "True" AND  objRs("underground") = True then%> checked="checked" <% end if %>  /> חניה תת-קרקעית 
			<input id="roof" type="checkbox" value="1" name="roof"<% If Editmode = "True" AND  objRs("roof") = True then%> checked="checked" <% end if %>  /> חניה מקורה 
			<input id="toshav" type="checkbox" value="1" name="toshav"<% If Editmode = "True" AND  objRs("toshav") = True then%> checked="checked" <% end if %>  /> הנחת תושב
			<input id="criple" type="checkbox" value="1" name="criple"<% If Editmode = "True" AND  objRs("criple") = True then%> checked="checked" <% end if %>  /> חניה מתאימה לנכים
		</td>
	</tr>
	<tr>
		<th colspan="3">אמצעי תשלום</th>
	</tr>
	<tr>
		<td colspan="2">
			<input id="cc" type="checkbox" value="1" name="cc"<% If Editmode = "True" AND  objRs("cc") = True then%> checked="checked" <% end if %>  /> אשראי
			<input id="cash" type="checkbox" value="1" name="cash"<% If Editmode = "True" AND  objRs("cash") = True then%> checked="checked" <% end if %>  /> מזומן
			<input id="cheak" type="checkbox" value="1" name="cheak"<% If Editmode = "True" AND  objRs("cheak") = True then%> checked="checked" <% end if %>  /> צ'קים
			<input id="paypal" type="checkbox" value="1" name="paypal"<% If Editmode = "True" AND  objRs("paypal") = True then%> checked="checked" <% end if %>  /> paypal
		</td>
		<td>
		</td>
	</tr>
    	<tr>
		<th>מאפיינים</th>
		<th></th>
		<th></th>
	</tr>
	<tr>
		<td colspan="3">
			<input id="coupon" type="checkbox" value="1" name="coupon"<% If Editmode = "True" AND  objRs("coupon") = True then%> checked="checked" <% end if %>  /> קופון 
            <br />
          טקסט קופון 
          <br /> <textarea rows="3" name="coupon_text" cols="47" style="width:500px;"><% If Editmode = "True" Then print objRs("coupon_text") End If %></textarea>   
           <input type="submit" value="המשך" style="padding:0 20px;float:left;" class="" />
        </td>
	</tr>
</table>
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
            <input type="submit" style="margin:10px 0 0;cursor:not-allowed;" value="שמור" class="saveform"   id="submi" disabled="disabled"/>
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

