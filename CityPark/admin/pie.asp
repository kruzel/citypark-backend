<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
    <head>
    <script type="text/javascript" src="js/raphael.js"></script>
    <script type="text/javascript" src="js/popup.js"></script>
    <script type="text/javascript" src="js/jquery2.js"></script>
	<script type="text/javascript" src="js/pie.js" charset="utf-8"></script>
    <script type="text/javascript" src="js/analytics.js"></script>
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.7.1.custom.min.js"></script>
<!--<script type="text/javascript" src="js/jquery-ui.js"></script>-->
    <script type="text/javascript" src="js/ui.tabs.js"></script>
    <script type="text/javascript">
        $(function() {
            $('#container-1 > ul').tabs();
        });
		$(function() {
            $('#container-2 > ul').tabs();
        });
	</script>
	<script type="text/javascript">
		$(document).ready(function(){ 
			$(function() {
				$("#contentLeft ul").sortable({ opacity: 0.6, cursor: 'move', update: function() {
					var order = $(this).sortable("serialize") + '&action=updateRecordsListings';}								  
				});
			});
		});	
	</script>
		<script>
	$(document).ready(function() {
		$("#accordion").accordion();
	});
	</script>
		
		
		
		
		
		
<style>
#holder{
width:500px;
height:235px;
margin:-90px 0 0 -90px;
}

</style>
        
    </head>
    <body>
       <table>
					<tr>
						<th>Google</th>

						<td>40%</td>
					</tr>
					<tr>
						<th>Direct Traffic</th>
						<td>37%</td>
					</tr>
					<tr>

						<th>Refering Sites</th>
						<td>23%</td>
					</tr>
				</table>
				<div id="holder"></div> 
    </body>
</html>
