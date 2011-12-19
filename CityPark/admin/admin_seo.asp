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
    });
</script>

<%
CheckSecuirty "site"
    if request("inline") = "true" Then

        fieldName = Split(Request.QueryString("id"), "_")(1)
        rowId = Split(Request.QueryString("id"), "_")(0)
	    value = UrlDecode2(Request.QueryString("value"))
        ExecuteRS "UPDATE [block] Set " & fieldName & " = '" & value & "' WHERE Id = " & rowId
	    Response.End
    end if
 format = Request.QueryString("format")
    If  format  = "xls" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "block-Disposition", "attachment;filename=block-"&filedate&".xls"
        Response.blockType = "application/ms-excel" 
     End If
         If  format  = "doc" Then
        Response.Buffer = True
        filedate = day(now())&"-"&month(now())&"-"&year(now())&"_"&Siteid
        Response.AddHeader "block-Disposition", "attachment;filename=block-"&filedate&".doc"
        Response.blockType = "application/vnd.ms-word"
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

CheckSecuirty "site"
 %>   
    <div class="formtitle">
        <h1> הגדרות SEO</h1>
		<div class="admintoolber">
		</div>
		<div class="adminicons">
			<p>
				<select name="records" onchange="location.href='admin_seo.asp?records='+escape(this.options[this.selectedIndex].value)+'&SiteID=<%=SiteID%>';">
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
        <th style="width:10%;" class="recordid">ID</th>
		<th style="width:60%;text-align:right;padding:0 10px 0 0">שם</th>
        <th>ערוך</th>
        <th>שכפל</th>
        <th>מחק</th>
		
    </tr>
</thead>
<tbody>
<% 
If Request.QueryString("ID")= "" AND Request.QueryString("action")<> "add" Then
		SQL = "SELECT * FROM site WHERE SiteID=" & SiteID
	Set objRs = OpenDB(SQL)
	If objRs.RecordCount = 0 Then
           print "אין רשומות"
	Else
	    objRs.PageSize = Session("records")
        HowMany = 0
Do While Not objRs.EOF And HowMany < objRs.PageSize
 
   
            	%>
    <tr>
        <td><%= objRs("SiteID")  %></td>
		<td style="text-align:right;"><span class="inlinetext" id="<% = objRs("SiteID") %>_Name"><% = objRs("Sitename") %></span></td>
        <td><a href="admin_seo.asp?ID=<% = objRs("SiteID") %>&action=edit"><img src="images/edit.gif" border="0" alt="ערוך" /></a></td>
        <td><a href="admin_seo.asp?ID=<% = objRs("SiteID") %>&action=copy"><img src="images/copy.gif" border="0" alt="שכפל " /></a></td>
        <td style="border-left:0px;"><a href="admin_seo.asp?ID=<% = objRs("SiteID") %>&mode=doit&action=delete" onclick="return confirm('?האם אתה בטוח שברצונך למחוק ');"><img src="images/delete.gif" border="0" alt="מחק" /></a></td>
	</tr>	
 <%	 HowMany = HowMany + 1
       objRs.MoveNext
		 Loop

      objRs.Close
    End If
End If
%>
</tbody>
</table></div>
<%	 
Else
	If Request.QueryString("mode") = "doit" Then
	    Select Case Request.QueryString("action")
	       Case "edit"
	       	 Editmode= "True"

				    Sql = "SELECT * FROM Site WHERE SiteID=" & Request.QueryString("ID")
			            Set objRs = OpenDB(sql)
                        objRs("Title") = Trim(Request.Form("Title"))
						objRs("Keywords") = Request.Form("Keywords")
						objRs("Description") = Trim(Request.Form("Description"))	
                        		objRs.Update
								objRs.Close
									Response.Write("<br><br><p align='center'>נערך בהצלחה. <a href='default.asp?S=" & SiteID & "'>לחץ להמשך</a>!</p>")
							        Response.Write("<meta http-equiv='Refresh' content='0; URL=default.asp?S=" & SiteID & "'>")

	            End Select
		Else
				SQL = "SELECT * FROM Site WHERE SiteID=" & Request.QueryString("ID") 
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
<form action="admin_seo.asp?mode=doit<% If Editmode="True" Then %>&ID=<% = objRs("SiteID")%><% ENd IF %>&action=<%=Request.Querystring("action") %>" method="post" id="block2" name="block2" class="_validate">
			<div class="incontentboxgrid2">
				<div class="formtitle2">
					<% If  Request.QueryString("action") = "add" Then %>
					<h1>הוספת</h1>
				<% ELSE 
				%>
					<h1>עריכת הגדרות SEO</h1>
				<% End If %>
				</div>
			    <div class="rightform">
				<table class="tableform" dir="rtl" cellpadding="0" cellspacing="0" width="100%">
                 <tr>
                            <td valign="top" width="20%" align="right">כותרת הדף (Title)</td>
                            <td align="right"><textarea name="title" id="title" cols="3" class="goodinputlong"><%If Editmode = "True" Then print objRs("Title") End If %></textarea>
							</td>
                        </tr>
                        <tr>
                            <td valign="top" width="20%" align="right">תיאור (Description)</td>
                            <td align="right"><textarea rows="3" name="Description" cols="10" class="goodinputlongbig" onKeyDown="formTextCounter(this.form.Description,this.form.remLen_Description,200);" onKeyUp="formTextCounter(this,$('remLen_Description'),200);" wrap="soft"><%If Editmode = "True" Then print objRs("Description") End If %></textarea><input readonly="readonly" type="text" class="goodinputlong" style="width:25px;clear:both" name="remLen_Description" size="1" maxlength="3" value="200">
							</td>
                        </tr>
                        <tr>
                            <td valign="top" width="20%" align="right">מילות מפתח (KeyWords)</td>
                            <td align="right"><textarea rows="3" name="Keywords" cols="10" class="goodinputlongbig" onKeyDown="formTextCounter(this.form.Keywords,this.form.remLen_Keywords,200);" onKeyUp="formTextCounter(this,$('remLen_Keywords'),200);" wrap="soft"><% If Editmode = "True" Then print objRs("Keywords") End If %></textarea><input readonly="readonly" type="text" class="goodinputlong" style="width:25px;clear:both" name="remLen_Keywords" size="1" maxlength="3" value="200">
							</td>
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
				<h3><a style="background:url(images/descshort.png) no-repeat right;" href="#">אופציונאלי</a></h3>
			        <div>
                    <table dir="rtl" cellpadding="3" cellspacing="0" border="0" width="100%" id="formleftfieldstable">
                        <tr>
                            <td align="right">אופציונאלי</td>
                        </tr>
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