<div class="_dialog" style="display: none;" title="שלח לחבר">
	<iframe src="sendtofriend.asp" frameborder="0" height="300" scrolling="no" style="margin: 0;" ></iframe>
</div>
<script>
	$(document).ready(function() {
		$(".a > *").click(function() {
			$('._dialog').dialog({
				bgiframe: true,
				height: 350,
				width: 350,
				modal: true});
			
			return false;
		});
	});
</script>
<div class="a" 
    style="background: #fff url(/sites/mdc/layout/images/contact.gif) no-repeat right; padding: 0px 20px 0px 20px; height: 40px; float: right; line-height: 40px;">
    <a href="#">שלח לחבר</a>
</div>
