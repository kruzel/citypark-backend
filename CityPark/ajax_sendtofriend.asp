<!--#include file="config.asp"-->

<form id="send" action="sendtofriend.asp?mode=doit" method="post">
<div id="sendtofriendform" style="padding-top:10px" align="center">
<table id="contactform" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2"><input id="cff" name="Name" style="float: right">
</td>
<td align="right">:<span lang="he"><% = SysLang("name")%></span></td>
</tr>
<tr>
<td colspan="2">
<input id="cff" name="eMail" style="float: right" class="required email"></td>
<td align="right">:Email</td>
</tr>
<tr>
<tr>
<td colspan="2">
<textarea style="float: right" rows="6" id="cff" name="Message"></textarea></td>
<td align="right" valign="top">:<span lang="he"><% = SysLang("Message") %></span>
</td>
</tr>
<tr>
<td colspan="2">
<p>הקישור לכתבה יתווסף באופן אוטומטי</p>
<input id="send" type="submit" value="<% = SysLang("send")%>" name="B2"></td>
<td></td>
</tr>
</table>
</div>
</form>

<script>
 jQuery('#send').validate({
		            rules: {
		            selectone: {
		                required: function (element) {
		                    // alert($(element).val() + "  != " + 0);
		                    return $(element).val() != 0;
		                }
		            }
		        },
		            submitHandler: function (form) {

		                var p = $(form);

		                var c = true;

		                p.find(":text").each(function () {
		                    if ($(this).hasClass("e"))
		                        c = false;
		                });

		                if (c == false)
		                    return false;

		                //alert(p.attr("action")  + p.serialize());

		                jQuery.ajax({
		                    type: jQuery(form).attr('method'),
		                    url: p.attr('action'),
		                    data: p.serialize(),
		                    success: function (html) {
		                        p.parent().html(html);
		                    },
		                    error: function (XMLHttpRequest, textStatus, errorThrown) {
		                        alert(XMLHttpRequest.responseText);
		                    }
		                });

		                return false;
		            }
		        });
		

</script>