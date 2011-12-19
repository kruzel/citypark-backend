<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type="text/javascript">
    $(document).ready(function () {
		jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
        $("#contentTable").treeTable();
		$("#loadcategories").load("admin_ajax.asp?ajax=5&id=<%=Request.QueryString("id")%>&action=<%=Request.QueryString("action")%>",function() {sa = true;initTree();});
		  });
		function bringproduct(id,p,e) {
		//if ($("table#t"+id).text() == '') 
			if ($("#h"+id).is(":visible")) {
					$("#h"+id).hide();
				} else {
					$("#h"+id).css("display","table-row");
				}
			
		if (!$(e).hasClass("ajaxed")) {//first time open
			$("table#t"+id).load("admin_ajax.asp?ajax=p&id="+id+"&p="+p,function() { dialogit(); });
			$(e).addClass("ajaxed");
			
		}
			
	//$(e).parent().parent().toggleClass("expanded");
	$(e).find("img").attr("src",($(e).find("img").attr("src").indexOf("plus")>0)?$(e).find("img").attr("src").replace("plus","minus"):$(e).find("img").attr("src").replace("minus","plus"));
	
	}
	function dialogit() {
	$("._dialog").click(function() {
            $("<div></div>")
                .load($(this).attr("href"))
                .appendTo("body")
                .dialog($(this).mmetadata())
  
            return false;
        });
	}
  
</script>
<%

CheckSecuirty "Content"
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
    'Response.ContentType = "text/csv"
    Response.AddHeader "Content-Disposition", "filename=users.csv"
		SQL = "SELECT * FROM Content WHERE SiteID=" & SiteID & " ORDER BY Name ASC"
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


%>
<!--#include file="right.asp"-->
	<div id="incontent">
	<div class="incontentboxgrid">
   

<center>
<%
	If Request.QueryString("records") = "" Then
	Session("records") = 1000
	Else 
	Session("records") = Request.QueryString("records")
	End If

CheckSecuirty "Content"
 %>   
    <div class="formtitle">
        <h1>ניהול מחירים</h1>
		<div class="admintoolber">
		</div>
	</div>
<table id="productTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th class="recordid">ID</th>
		<th style="width:35%;text-align:right;padding-right:40px;cursor:pointer;">שם מוצר</th>
        <th style="width:8%;">מחיר</th>
        <th style="width:8%;">מחיר מחירון</th>
        <th style="width:8%;">עלות המשלוח</th>
		<th style="width:8%;">קוד קופון</th>
        <th style="width:8%;">אחוז הנחה</th>
        <th style="width:8%;"></th>
		
    </tr>
</thead>
<tbody>
<%
            SQL = "SELECT * FROM Content WHERE SiteID=" & SiteID & " AND  (Contenttype = 2)  ORDER By Name ASC"
		If Request.QueryString("mode") = "search" then
            SQL = "SELECT * FROM Content WHERE "
            SQL = SQL & "(Content.SiteID=" & SiteID & ") "
	   If Request.QueryString("category") <> "*" then
			SQL = SQL & " AND (Contentfather.FatherID = " & Request.QueryString("category") & ")"
		end If
		If Request.QueryString("text") <> "" Then
			SQL = SQL & " AND Name LIKE '%" & Request.QueryString("text") & "%'"
		End If
		SQL = SQL & " AND Active=" & Int(Request.QueryString("Active"))
		SQL = SQL &  " AND (Contenttype = 2)   ORDER By ItemOrder ASC"
   
    End If
		Set objRsg = OpenDB(SQL)
	                If objRsg.RecordCount = 0 Then
                        print "אין רשומות"
	                 Else
	        objRsg.PageSize = Session("records")
                HowMany = 0
                fatherID =  objRsg("Id")
			
				
            Do While Not objRsg.EOF And HowMany < objRsg.PageSize

%>
     <tr id="node-<%= objRsg("Id") %>" <% if id <> 0 Then %>class="child-of-node-<%= id %>"<% end if %> style="background-color: <% if color then %>#fff<% Else %>#f5f5f5<%End If %>;">
        <td   style="width:12%;"><%= objRsg("Id")  %></td>
		
		<td style="width:36%;text-align:right;" class="editlocalbig">	
			<div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_Name"><% = objRsg("Name") %></div>
		</td>  
		<td class="editlocal"  style="width:9%;"><div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_other1"><% = objRsg("other1") %></div></td>
        <td style="border-left:0px;width:9%;"><div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_other2"><% = objRsg("other2") %></div></td>
        <td  class="editlocal"  style="width:9%;"><div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_other9"><% = objRsg("other9") %></div></td>
        <td  style="width:9%;"><div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_Couponcode"><% = objRsg("Couponcode") %></div></td>
        <td  style="width:6%;"><div class="inlinetext" style="text-align:right;position:relative;" id="<% = objRsg("Id") %>_Coupondiscount"><% = objRsg("Coupondiscount") %></div></td> 
        <td  style="width:6%;"><div class="inlinetext" style="text-align:right;position:relative;" id=""></div></td> 
    </tr>	
	<tr id="h<%=objRsg("Id")%>" style="display:none">
	<td colspan="8" cellpadding="0"><table id="t<%=objRsg("Id")%>" width="100%" border="0" cellspacing="0" cellpadding="0"><td>טוען...</td></table></td>
	
	</tr>
	<%
	if not stay then color = not color
				
                 HowMany = HowMany + 1
                objRsg.MoveNext
		  		Loop
                objRsg.Close
                End If
				%>
</tbody>
</table></div>

<!--#include file="footer.asp"-->