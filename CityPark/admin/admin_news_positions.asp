<!--#include file="../config.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
<head>
    <meta http-equiv="news-Type" news="text/html; charset=utf-8" />
<style type="text/css">

	#sortable { list-style-type: none; margin: 0; padding: 0; width: 100%; }
	#sortable li { text-align:right;cursor:move;margin: 0 3px 3px 3px; padding: 0.4em; padding-right: 1.5em; font-size: 1.4em; height: 18px; }
	#sortable li span { position: absolute; margin-right: -1.3em; margin-top: 2px; }

</style>

<% 
CheckSecuirty "News" 
If Request.QueryString("ID") = "" Then
    FatherPage = 0
Else
    FatherPage = Request.QueryString("ID")
End If
		SQLm = "SELECT * FROM News WHERE SiteID=" & SiteID & " ORDER BY Itemorder ASC"
Set objRs = OpenDB(SQLm)
If Request.QueryString("m") = "changeposition" Then
	For Index = 0 To UBound(Split(Request.QueryString("l[]"), ","))
		ExecuteRS "UPDATE news SET Itemorder = " & Index & " WHERE id = " & Request.QueryString("l[]")(Index + 1)
	Next
Else
%>
<script>
    (function($) {
        $(document).ready(function() {
            $("ul").sortable({
				update: function(event, ui) {
				    $.get("admin_news_positions.asp?m=changeposition&id=<% = FatherPage %>" + "&" + $(this).sortable('serialize'));
				}
			});
        });
    })(jQuery);
</script>
<form method="post" action="admin_news_positions.asp?m=changeposition">
    <ul id="sortable">
        <% Do Until objRs.Eof %>
        <li id="l_<% = objRs("id") %>" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><% = objRs("Name") %><input type="hidden" value="<% = objRs("id") %>" id="id"></li>
        <% 
        objRs.MoveNext
        Loop
        %>           
        
    </ul>
</form>
</div>

<script>
    (function ($) {
        $(document).ready(function () {
            $("ul").sortable({
                update: function (event, ui) {
                    $.get("admin_news_positions.asp?m=changeposition&type=menu&id=<% = FatherPage %>" + "&" + $(this).sortable('serialize'));
                }
            });
        });
    })(jQuery);
</script>
<form method="post" action="admin_news_positions.asp?m=changeposition&type=menu">
    <ul id="sortable">
        <% Do Until objRs.Eof %>
        <li id="l_<% = objRs("id") %>" class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><% = objRs("Menusname") %><input type="hidden" value="<% = objRs("id") %>" id="id"></li>
        <% 
        objRs.MoveNext
        Loop
        %>           
        
    </ul>
</form>


<% End If %>
