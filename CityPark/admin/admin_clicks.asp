<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery('#contentTable').tablesorter({ sortForce: [[0, 0]] });
    });
</script>
<%
CheckSecuirty "Content"
%>
<!--#include file="right.asp"-->
	<div id="incontent">
	<div class="incontentboxgrid">
   

<center>
<%
	If Request.QueryString("mode") = "deleteallclicks" Then
    
        Set objRscontent = OpenDB("SELECT * FROM  Clicks WHERE SiteId =" & SiteID)
        Do While Not objRscontent.EOF
            objRscontent.delete
        objRscontent.movenext
            loop
        objRscontent.close
   		Response.Redirect("admin_clicks.asp?notificate=הנתונים אופסו")

    Else

	If Request.QueryString("records") = "" Then
	Session("records") = 50
	Else 
	Session("records") = Request.QueryString("records")
	End If

CheckSecuirty "Content"
 %>   
    <div class="formtitle">
        <h1>ניהול קליקים</h1>
		<div class="admintoolber">
        <a href="admin_clicks.asp?mode=deleteallclicks" onclick="return confirm('?האם אתה בטוח שברצונך לאפס את כל הנתונים');">איפוס</a>
		</div>
		<div class="adminicons">
	</div>
	</div>
<table id="contentTable" class="tablesorter" cellpadding="0" cellspacing="0" border="0" width="100%">
<thead>
    <tr>
        <th class="recordid">שם</th>
		<th class="recordid"><% = SiteTranslate("other1") %></th>
        <th class="recordid"><% = SiteTranslate("other2") %></th>
        <th class="recordid"><% = SiteTranslate("other3") %></th>
        <th class="recordid"><% = SiteTranslate("other4") %></th>
		
    </tr>
</thead>
<tbody>
<%       Set objRscontent = OpenDB("SELECT DISTINCT Contentid FROM  Clicks WHERE SiteId =" & SiteID)
            Do While Not objRscontent.EOF
        Set objRs = OpenDB("SELECT Name FROM [Content] WHERE ID= " & objRscontent("Contentid") & "AND SiteID =" & SiteID)
        Name = objRs("Name")
        Set objRs = OpenDB("SELECT COUNT(id) AS other1 FROM [Clicks] WHERE ContentID= " & objRscontent("Contentid") & " AND Fieldname = 'other1' AND SiteID =" & SiteID)
        other1 =  objRs("other1")

        Set objRs = OpenDB("SELECT COUNT(id) AS other2 FROM [Clicks] WHERE ContentID=" & objRscontent("Contentid") & " AND Fieldname ='other2' AND SiteID =" & SiteID)
        other2 =  objRs("other2")
        
        Set objRs = OpenDB("SELECT COUNT(id) AS other3 FROM [Clicks] WHERE ContentID=" & objRscontent("Contentid") & " AND Fieldname ='other3' AND SiteID =" & SiteID)
        other3 =  objRs("other3")

        Set objRs = OpenDB("SELECT COUNT(id) AS other4 FROM [Clicks] WHERE ContentID=" & objRscontent("Contentid") & " AND Fieldname ='other3' AND SiteID =" & SiteID)
        other4 =  objRs("other4")
        
        objRs.Close
            	%>
    <tr>
        <td><%= Name %></td>
        <td><%= other1 %></td>
        <td><%= other2 %></td>
        <td><% = other3 %></td>
        <td><%= other4 %></td>
    </tr>	
 <%		
				
                 HowMany = HowMany + 1
                objRscontent.MoveNext
		  		Loop
                objRscontent.Close
                End if
    %>
</tbody>
</table></div>

<!--#include file="footer.asp"-->