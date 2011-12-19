<!--#include file="../config.asp"-->
 <!--#include file="UserHeader.asp"-->

					<link href="/sandbox/uploadify/uploadify.css" rel="stylesheet" type="text/css" />
					<script type="text/javascript" src="/sandbox/uploadify/swfobject.js"></script>
					<script type="text/javascript" src="/sandbox/uploadify/jquery.uploadify.v2.1.0.min.js"></script>
					<script type="text/javascript">
					$(document).ready(function() {
						$("#uploadify").uploadify({
							'uploader'       : '/sandbox/uploadify/uploadify.swf',
							'script'         : '/sandbox/uploadify/upload.ashx?S=<% = SiteID %>',
							'cancelImg'      : '/sandbox/uploadify/cancel.png',
							'queueID'        : 'fileQueue',
							'auto'           : true,
							'multi'          : true,
							fileExt: "*.jpg;*.jpeg;*.png;*.gif;*.doc;*.docx;*.zip;*.pdf;*.swf;*.flv",
'onComplete': function(a, b, c, d, e){
                    if (d !== '1')
                        {
                        alert(d);
                        }
                    else
                        {
                        alert('Filename: ' + c.name + ' was uploaded');
                        }
                  }
							
						});
					});
					</script>
					<div id="fileQueue"></div>
					<input type="file" name="uploadify" id="uploadify" />
					<p><a href="javascript:jQuery('#uploadify').uploadifyClearQueue()">Cancel All Uploads</a></p>