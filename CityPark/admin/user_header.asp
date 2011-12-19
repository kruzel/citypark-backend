<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>dooble cms v 4.0</title>
    <meta name="keywords" content="dooble cms v 4.0" />
    <meta name="description" content="dooble cms v 4.0" />
    <meta http-equiv="Content-Language" content="he" />
    <meta name="ROBOTS" content="NOINDEX,NOFOLLOW" />
    <meta name="copyright" content="dooble.co.il" />
    <meta name="Author" content="dooble.co.il" />
    <meta name="rating" content="General" />
	<link rel="stylesheet" type="text/css" href="style.css" />
	<link rel="stylesheet" type="text/css" href="adminmenu.css" />
    <link href="/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="/CSS/treeview.css" />
	<link rel="stylesheet" type="text/css" href="/CSS/treeviewpicker.css" />
	<link rel="stylesheet" type="text/css" href="/CSS/tipsy.css" />
	<link rel="stylesheet" type="text/css" href="CSS/jquery-ui-1.8.2.custom.css" />
	<link rel="stylesheet" type="text/css" href="CSS/ui.notify.css" />
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="/js/jquery.metadata.js"></script>
	<script type="text/javascript" src="js/raphael.js"></script>

	<script type="text/javascript" src="js/jquery-ui-1.8.2.custom.min.js"></script>	
    <script type="text/javascript" src="/js/jquery.confirm.js"></script>
    <script type="text/javascript" src="/js/jquery.treeTable.js"></script>
    <script type="text/javascript" src="/js/jquery.tablesorter.js"></script> 
	<script type="text/javascript" src="/JS/jquery.treeview.js"></script>
	<script type="text/javascript" src="/JS/jquery.treeviewpicker.js"></script>
    <script type="text/javascript" src="/js/validate.asp" ></script>
    <script type="text/javascript" src="/js/ajax.asp" ></script>
    <script type="text/javascript" src="/js/filemanager.asp" ></script>
    <script type="text/javascript" src="/js/jquery.tipsy.js" ></script>
    <script type="text/javascript" src="js/ui.notify.js" ></script>
	<script type="text/javascript" src="js/cookies.js" ></script>
	<script type="text/javascript" src="jquery.jstree.js"></script>
	
    <script type="text/javascript">
		var sa = false;
		var sb = false;
		var sc = false;
		$(document).ready(function() {
			
			initTree();
			$("#accordion").accordion({ autoHeight: false, active: false, collapsible: true });
			
			$("#tabs").tabs({
				cookie: {
					// store cookie for a day, without, it would be a session cookie		
				}

			});
				$("#header").show();
			$("#tabs2").tabs({
				cookie: {
					// store cookie for a day, without, it would be a session cookie		
				}
			});
		});
		function initTree() {
		$("#tree").jstree({ 
				"plugins" : [ "themes", "html_data" ],
				"core" : { rtl: true },
				"themes" : {
					"theme" : "default-rtl",
					"dots" : false,
					"icons" : false
				},
				"callback":
				{
					"onclick": function (node, tree) {
						alert("abc");
					}
				}
			});
			

				submitstate();
		}
		function l(a) {
	if (window.console)
		console.log(a);
	}
		function submitstate() {
		l(sa&&sb&&sc);
		if (sa&&sb&&sc) 
			$("input.saveform").attr("disabled","").css("cursor","");
		}
		function initTree2() {
		$("#categorylist").jstree({ 
				"plugins" : [ "themes", "json_data", "checkbox" ],
				"json_data": {
					"ajax": {
						"url": function(node) { var id = $(node).attr("id"); if (id == undefined) id = 0; return "admin_ajax.asp?ajax=4&id=" + id; },
						"progressive_render": true
					}
				},
				"core" : { rtl: true },
				"themes" : {
					"theme" : "default-rtl",
					"dots" : false,
					"icons" : false
				},
				"callback":
				{
					"onclick": function (node, tree) {
						alert("abc");
					}
				}
			});
		
		}
		function start() {
		var email,tmpl,attach;
		$("#mailist tbody tr").each(function() {
		email = $(this).find(".email").text();
		attach = $("#attachment").val();
		tmpl = $("#template").val();
			$.ajax({
				type: "POST",
				url: "ajax_mailer.php",
				data: "type=type&template="+tmpl+"&attachment="+attach+"&email="+email,
				success: function(msg){
					$(this).find(".sent").text(msg);
				}
			});
	
		});
		}
	</script>
</head>
<body>
	<% 
	If Request.QueryString("notificate") <> "" Then
	%>
	<div id="notifications">
		<div id="default">
			<h1>#{title}</h1>
		</div>
	</div>
	
	<script>
	    $(document).ready(function () {
	        var $notifications = $("#notifications").notify();

	        $notifications.notify("create", "default", {
	            title: '<% = Request.QueryString("notificate") %>'
	        });
	    });
	</script>
	<%
	End If 
	%>
<div id="header" style="display:none">
</div>
<div id="container">
<div id="content">