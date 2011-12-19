<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type="text/javascript">


var ajaxvar;
var pm,hr,dl,wl,ml,yl;
var parkid = '<%=request("ID")%>';

    $(document).ready(function () {
			$('#contentTable').tablesorter({ sortForce: [[0, 0]] });
			$("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });
			
			citychange();
			
			loadstreets($("#city").val());
			
			
	});
	
	
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

</script>
<%

CheckSecuirty "Parking"
    if request("inline") = "true" Then
        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [Parking] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
    Response.Clear
    Response.CodePage = "1255" 
    Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=poi.csv"
		SQL = "SELECT * FROM poi WHERE SiteID=" & SiteID & " ORDER BY Name ASC"
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

If Request.QueryString("p")= "" AND Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then

%>
<!--#include file="right.asp"-->
	<div id="incontent">
	<div class="incontentboxgrid">
   

<center>
<%
	If Request.QueryString("records") = "" Then
	Session("records") = 10000
	Else 
	Session("records") = Request.QueryString("records")
	End If

CheckSecuirty "parking"
 %>   
    <div class="formtitle">
        <h1>ניהול קישורים אוטומטים</h1>
		<div class="admintoolber">
        <form action="admin_poi.asp?action=show&mode=search&records=<%=Request.Querystring("records") %>&category=<%=Request.form("category") %>&string=<%=Request.form("search") %>&lang=<%=Request.form("lang") %>" method="post">
               <p>חיפוש:</p>
               <input type="text" dir="rtl" name="search" value="" class="freetext">
               <input type="submit" value="חפש" name="searchbtn" class="submit">
        </form>
		</div>
		<div class="adminicons">
			<p><a href="admin_poi.asp?action=add"><img src="images/addnew.gif" border="0" alt="הוספת דף חדש" title="הוספת דף חדש" /></a></p>
			<p><a href="admin_poi.asp?format=xls&<%Request.Querystring %>"><img src="images/excel.gif" border="0" alt="יצוא לאקסל" title="יצוא לאקסל" /></a></p>
			<p>
				<select name="records" onchange="location.href='admin_poi.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
					<option value="10" <%if Session("records") = 10 then print "selected" End if%>>10</option>
					<option value="20" <%if Session("records") = 20 then print "selected" End if%>>20</option>
					<option value="50" <%if Session("records") = 50 then print "selected" End if%>>50</option>
					<option value="100" <%if Session("records") = 100 then print "selected" End if%>>100</option>
					<option value="1000" <%if Session("records") = 1000 then print "selected" End if%>>1000</option>
					<option value="10000" <%if Session("records") = 10000 then print "selected" End if%>>10000</option>
				</select>
			</p>
			<p class="reshumot">רשומות לדף:</p>

	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th style="width:8%;" class="recordid">ID</th>
		<th style="width:36%;text-align:right;padding-right:40px;cursor:pointer;">שם נקודת עניין</th>
		<th style="width:8%;">ערוך</th>
        <th style="width:8%;">שכפל</th>
        <th style="width:8%;">מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If  Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
                SQL = "SELECT * FROM [Poi] WHERE SiteID=" & SiteID
     If Request.QueryString("mode") = "search" then
            If Request.form("search") <> "" Then
                SQL = SQL & " AND Name LIKE '%" & Request.form("search") & "%'"
             End If
    End If
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	            objRsg.PageSize = Session("records")
                HowMany = 0
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize
			response.flush

            	%>
    <tr style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td><%= objRsg("id")  %></td>
		<td class="editlocalbig" style="padding:0 32px 0 0;text-align:right;"><div class="inlinetext" id="<% = objRsg("id") %>_Name"><% = objRsg("Name") %></div></td>
        <td><a href="admin_poi.asp?ID=<% = objRsg("id") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_poi.asp?ID=<% = objRsg("id") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל דף" /></a></td>
        <td><a href="admin_poi.asp?ID=<% = objRsg("id") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק דף זה');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
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
					                        <a href="admin_poi.asp?page=<% = objRsg.AbsolutePage - 1 %>&records=<% = Session("records")  %>" style="text-decoration: none"><% End If%>
					                        <font color="#808080">דף קודם</font></a>
					                    </td>
					                        <td width="25">
					                        <font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
					                    </td>
					                    <td width="166"><font size="2" face="Arial">
					        	            <div align="center">
	                        <% If objRsg.AbsolutePage < objRsg.PageCount Then %>
					                         <a href="admin_poi.asp?page=<% = objRsg.AbsolutePage + 1 %>&records=<%= Session("records")  %>" style="text-decoration: none"><% 	End If%>
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

			        Sql = "SELECT * FROM poi WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				              objRs("SiteID") = SiteID
	                           objRs("name") = Request.Form("name")
	                           objRs("urltext") = Request.Form("urltext")
	                           objRs("city") = Request.Form("city")
                               objRs("street_name") = Request.Form("street_name")
	                           objRs("house_number") = Request.Form("house_number")
	                           objRs("type") = Request.Form("type")
	                           objRs("sub_type") = Request.Form("sub_type")
	                           objRs("tel1") = Request.Form("tel1")
	                           objRs("tel2") = Request.Form("tel2")
	                           objRs("comment") = Request.Form("comment")
	                           objRs("fee") = Request.Form("fee")
	                           objRs("latitude") = Request.Form("latitude")
	                           objRs("longitude") = Request.Form("longitude")
	                           objRs("Image") = Request.Form("Image")

							   objRs.Update
								objRs.Close
									Response.Redirect("admin_poi.asp?notificate=נקודה נוספה בהצלחה")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM poi WHERE id=" & Request.QueryString("ID") & " AND SiteID= " & SiteID
			            Set objRs = OpenDB(sql)
	                           objRs("name") = Request.Form("name")
	                           objRs("urltext") = Request.Form("urltext")
	                           objRs("city") = Request.Form("city")
                               objRs("street_name") = Request.Form("street_name")
	                           objRs("house_number") = Request.Form("house_number")
	                           objRs("type") = Request.Form("type")
	                           objRs("sub_type") = Request.Form("sub_type")
	                           objRs("tel1") = Request.Form("tel1")
	                           objRs("tel2") = Request.Form("tel2")
	                           objRs("comment") = Request.Form("comment")
	                           objRs("fee") = Request.Form("fee")
	                           objRs("latitude") = Request.Form("latitude")
	                           objRs("longitude") = Request.Form("longitude")
	                           objRs("Image") = Request.Form("Image")

							   objRs.Update
								objRs.Close
									Response.Redirect("admin_poi.asp?notificate=נקודה נערכה בהצלחה")
	        Case "copy"
	        	Editmode = "True"
				    Sql = "SELECT * FROM poi WHERE id=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
    			             objRs.Addnew
				             objRs("SiteID") = SiteID
	                           objRs("name") = Request.Form("name")
	                           objRs("urltext") = Request.Form("urltext")
	                           objRs("city") = Request.Form("city")
                               objRs("street_name") = Request.Form("street_name")
	                           objRs("house_number") = Request.Form("house_number")
	                           objRs("type") = Request.Form("type")
	                           objRs("sub_type") = Request.Form("sub_type")
	                           objRs("tel1") = Request.Form("tel1")
	                           objRs("tel2") = Request.Form("tel2")
	                           objRs("comment") = Request.Form("comment")
	                           objRs("fee") = Request.Form("fee")
	                           objRs("latitude") = Request.Form("latitude")
	                           objRs("longitude") = Request.Form("longitude")
	                           objRs("Image") = Request.Form("Image")
								objRs.Update
								objRs.Close
									Response.Redirect("admin_poi.asp?notificate=נקודה נוספה בהצלחה")
	        
	        Case "delete"
				    Sql = "SELECT * FROM poi WHERE id=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
			            objRs.Delete
			            objRs.Close
									Response.Redirect("admin_poi.asp?notificate=נקודה נמחקה בהצלחה")
	        

	            End Select
		Else
			If Request.QueryString("action") ="edit" OR  Request.QueryString("action") ="copy" Then
				SQL = "SELECT * FROM poi WHERE id=" & Request.QueryString("ID") & " And SiteID=" & SiteID
			End If
			If Request.QueryString("action") = "add" Then
			 SQL = "SELECT * FROM poi WHERE SiteID=" & SiteID   
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

<form action="admin_poi.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("id")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספה</h1>
				<% ELSE 
				%>
					<h1>עריכה</h1>
				<% End If %>
				</div>
			    <div class="rightform">
					<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
<table class="addpark" style="text-align:right;" cellspacing="0" cellpadding="0" border="0" dir="rtl" width="100%">
    <tr>

		<th colspan="3">כתובת</th>
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
		<th colspan="6">כותרת</th>
	</tr>
	<tr>
		<td colspan="6" valign="top">
			<input id="Text1" type="text" name="name" value="<% If Editmode = "True" Then print objRs("name") End If %>" style="width:500px;" class="required" />
		</td>
	</tr>
    <tr>
		<th colspan="6">קישור</th>
	</tr>
	<tr>
		<td colspan="6" valign="top">
			<input id="Text4" type="text" name="Urltext" dir="ltr" value="<% If Editmode = "True" Then print objRs("Urltext") End If %>" style="width:500px;" />
		</td>
	</tr>
	<tr>
		<th colspan="6">תיאור</th>
	</tr>
	<tr>
		<td colspan="6">
			<textarea rows="3" name="comment" cols="47" style="width:500px;" class="" onKeyDown="formTextCounter(this.form.comment,this.form.remLen_comment,200);" onKeyUp="formTextCounter(this,$('remLen_comment'),200);" wrap="soft"><% If Editmode = "True" Then print objRs("comment") End If %></textarea><br>
		</td>
	</tr>
    <tr>
	<th colspan="6">פרטים נוספים</th>
	</tr>
    <tr>
    	<td colspan="6">
        סוג:
        <select id="type" name="type" class="required"  >
        <%
		set objrtype= OpenDB("SELECT DISTINCT type FROM poi") %>
        <option value="null">בחר</option>
        <%do while not objrtype.eof %>
				<option value="<%=objrtype("type")%>"<% if objrtype("type") = objRs("type")  then %> selected="selected" <% End if %>><%=objrtype("type") %></option>
        <%objrtype.movenext
                loop %>
			</select>
            <% closeDB(objrtype) %>
		
		תת סוג:
        <select id="sub_type" name="sub_type" class="required"  >
        <%
		set objrsub_type= OpenDB("SELECT DISTINCT sub_type FROM poi") %>
        <option value="null">בחר</option>
        <%do while not objrsub_type.eof %>
				<option value="<%=objrsub_type("sub_type")%>"<% if objrsub_type("sub_type") = objRs("sub_type")  then %> selected="selected" <% End if %>><%=objrsub_type("sub_type") %></option>
        <%objrsub_type.movenext
                loop %>
			</select>
            <% closeDB(objrsub_type) %>
		</td>
   </tr>
   <tr>
    	<td colspan="6">
		latitude	<input id="Text2" type="text" name="latitude"  value="<% If Editmode = "True" Then print objRs("latitude") End If %>" style="width:100px;" class="required"  />
        longitude  <input id="Text3" type="text" name="longitude" value="<% If Editmode = "True" Then print objRs("longitude") End If %>" style="width:100px;" class="required"  />
		תשלום:
        <select id="fee" name="fee" >
				<option value="">בחר</option>
				<option value="חינם"<% if objRs("fee") = "חינם"  then %> selected="selected" <% End if %>>חינם</option>
				<option value="בתשלום"<% if objRs("fee") ="בתשלום"  then %> selected="selected" <% End if %>>בתשלום</option>
			</select>

        </td>

    </tr>
	<tr>
		<th>פרטי התקשרות</th>
		<th></th>
		<th></th>
	</tr>
	<tr>
		<td colspan="6">
			טלפון 1:<input  type="text" name="tel1" onchange="" maxlength="" value="<% If Editmode = "True" Then print objRs("tel1") End If %>"/>
        	טלפון 2:<input  type="text" name="tel2" onchange="" maxlength="" value="<% If Editmode = "True" Then print objRs("tel2") End If %>"/>
        </td>
	</tr>
	<tr>
		<th>תמונה</th>
		<th></th>
		<th></th>
	</tr>
	<tr>
		<td colspan="6">
		<input dir="ltr"  id="Image" name="Image" <%If Editmode = "True" Then %> value="<% =objRs("Image")%>"<%End If %> type="text" style="width:300px" />
		<input type="button" value="חפש בשרת" onclick="BrowseServer('Image');"/>
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