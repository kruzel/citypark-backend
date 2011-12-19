<!--#include file="config.asp"-->

<%header%>
<div class="search4"></div>
<script type="text/javascript">


    var ajaxvar;
    var pm, hr, dl, wl, ml, yl;
    var parkid = '<%=request("ID")%>';

    $(document).ready(function () {
        citychange();

        loadstreets($("#city").val());  
		
		
		initTable();
    });


	var arr = Array("פנוייה","דקות","פקח","גרר","מצוקת");
function initTable() {
	$("#tweetable tbody tr").each(function() {
		for(var i=0; i<arr.length; i++) {
		//	 alert($(this).find("td:eq(2)").text()+"&&"+arr[i]+"=="+($(this).find("td:eq(2)").text().indexOf(arr[i])>=0));

			if($(this).find("td:eq(2)").text().indexOf(arr[i])>=0)  {
			var x = $("<img/>").attr({"src":"/sites/cityp/content/images/"+(i+1)+".gif"});
			$(this).find("td:eq(1)").html(x).addClass("a"+i);
			}
			
			
		}

	});


}

    function citychange() {
        $("#city").change(function () {
            loadstreets($(this).val());
        });
    }


    function loadstreets(streetname) {
        if (ajaxvar) ajaxvar.abort();
        ajaxvar = $.ajax({
            type: 'POST',
            url: "admin/admin_park_json.asp",
            data: { m: "city", city: streetname },
            success: function (data) {
                var output = [];
                $.each(data, function (i, park) {
                    if (park.street != null)
                        output.push('<option value="' + park.street + '"'
							+ ((park.street.replace("\'", "").replace("\"", "").replace("''", "") == $("#defstreetv").val().replace("\'", "").replace("\"", "").replace("''", "")) ? ' selected="selected" ' : '')
							+ '>' + park.street + ' </option>');

                });
                $('#street_name').html(output.join(''));

            },

            dataType: "json",
            beforeSend: function () {
                $("#street_name").addClass("ajax");
            },
            complete: function () {
                $("#street_name").removeClass("ajax");
            }

        });
    }

</script>
    <div align="right" >
	<div class="text">
	<div class="intext">
        <div style="margin:0px 10px 0px 0px;font-weight:bold;">דיווחי חנייה אחרונים</div>		
<table  id="tweetable" cellpadding="0" cellspacing="2" border="0">
<tbody>
<% 
If  Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
                SQL = "SELECT TOP 10 * FROM Parkingtweets WHERE SiteID=" & SiteID & " Order By Id Desc"
            Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
            Do While Not objRsg.EOF
            	%>
     <tr>
        <td>  <%= objRsg("Date")  %></td>
        <td class="ico"></td>
        <td>  <%= objRsg("Category")  %></td>
        <td>  <%= objRsg("City")  %></td>
        <td>  <%= objRsg("Street")  %></td>
        <td>  <%= objRsg("House_Number")  %></td>
        <td>  <%= objRsg("Text")  %></td>
    </tr>	

<%  objRsg.MoveNext
		 Loop %>
  	            <tr>
		            <td><br /></td>
		         </tr>

<%
      objRsg.Close
    End If
End If
%>

</tbody>
</table>
<%
	If Request.QueryString("mode") = "doit" Then
			        Sql = "SELECT * FROM Parkingtweets WHERE SiteID= " & SiteID
			        	Set objRs = OpenDB(sql)
				             objRs.Addnew
				              objRs("SiteID") = SiteID
                               objRs("Text") = Request.Form("Text")
	                           objRs("Category") = Request.Form("Category")
	                           objRs("City") = Request.Form("City")
	                           objRs("Street") = Request.Form("street_name")
	                           objRs("House_Number") = Request.Form("House_Number")
	                           objRs("Date") = Now()

							   objRs.Update
								objRs.Close
									Response.Redirect("Parkingtweet.asp?notificate=דיווח נוסף בהצלחה")
	        

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
<form action="parkingtweet.asp?mode=doit&action=add" method="post" id="content2" name="content2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
				
				</div>
			    <div class="rightform">
                <table  style="text-align:right;" cellspacing="0" cellpadding="0" border="0" dir="rtl" width="600px">
                    <tr>
		                <th>הוסף דיווח על</th>
                    <td>
                          <select id="Category" name="Category" >
                          <option value="חנייה פנוייה">חנייה פנוייה</option>
                          <option value="מפנה חניה עוד 5 דקות">מפנה חניה עוד 5 דקות</option>
                          <option value="פקח באזור">פקח באזור</option>
                          <option value="גרר באזור">גרר באזור</option>
                          <option value="מצוקת חניה באזור">מצוקת חניה באזור</option>
                        </select>
                        </td>
		                <th>ב-</th>
                        <td>
		<input type="hidden" id="defcityv" value="<%=trim(objRs("city"))%>">
		<input type="hidden" id="defstreetv" value="<%=trim(objRs("street"))%>">
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
        <select id="street_name" name="street_name" >
		</select>
       </td>
       	<th>מספר</th>

		<td width="175">
		<input type="text" name="house_number" value="<% If Editmode = "True" Then print objRs("house_number") else print 0 End If %>" style="width:30px;"  />
		</td>
	</tr>
    <tr>
        <td><br /></td>
    </tr>
	<tr>
		<th colspan="6">תיאור</th>
	</tr>
	<tr>
		<td colspan="6">
			<textarea rows="3" name="Text" cols="47" style="width:500px;" class="" onKeyDown="formTextCounter(this.form.comment,this.form.remLen_comment,200);" onKeyUp="formTextCounter(this,$('remLen_comment'),200);" wrap="soft"><% If Editmode = "True" Then print objRs("Text") End If %></textarea><br>
		</td>
	</tr>
    <tr>
	<tr>
		<td colspan="6">
		<input type="submit" value="הוסף"/>
        </td>
	</tr>
	
</table>

</div>
</div>
</div>
</form>

</div>
</div>
<div class="bottom"></div>
<%	
End if
End if
bottom
%>

