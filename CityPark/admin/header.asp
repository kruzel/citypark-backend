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
	<link rel="stylesheet" type="text/css" media="all" href="style.css" />
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
		var sd = false;
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
		l(sa&&sb&&sc&&sd);
		if (sa&&sb&&sc&&sd) 
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
	<a href="http://www.dooble.co.il"><img alt="dooble cms v 4.0" src="/admin/images/logo.gif" id="logo"></a>
<div id="tabs">
	<ul>
		<li style="-moz-border-radius:0;"><a href="#tabs-1">ראשי</a></li>
		<li style="-moz-border-radius:0;"><a href="#tabs-2">ניהול תוכן</a></li>
		<li style="-moz-border-radius:0;"><a href="#tabs-3">קשרי לקוחות</a></li>
		<li style="-moz-border-radius:0;"><a href="#tabs-4">הגדרות כלליות</a></li>
		<li style="-moz-border-radius:0;"><a href="#tabs-5">קידום ושיווק</a></li>
		<li style="-moz-border-radius:0;"><a href="#tabs-6">מודולים</a></li>
    <% Set LinkRs = OpenDB("SELECT Name, URL FROM PrivateLink WHERE SiteID=" & SiteID)		
         If LinkRs.Recordcount > 0 Then %>
         <li style="-moz-border-radius:0;"><a href="#tabs-7">תוספות</a></li>
    <% End if %>

	</ul>
	<div id="tabs-1">
		<p>
			<a href="default.asp">פאנל ניהול ראשי</a>|
			<a href="#">פנייה לתמיכה</a>|
			<a href="default.asp?mode=logout">התנתק</a>
		</p>
	</div>
	<div id="tabs-2">
		<p>
			<a href="/admin/admin_content.asp">ניהול דפי תוכן</a>|
            <a href="/admin/admin_block.asp">ניהול בלוקים</a>|
			<a href="/admin/admin_Menu.asp">ניהול כפתורים</a>|
			<a href="/admin/admin_news.asp">חדשות ועדכונים</a>|
			<a href="/admin/admin_gallery.asp">ניהול גלריות</a>|
			<a href="/admin/admin_photos.asp">ניהול תמונות</a>
			<a href="/admin/admin_videogallery.asp">גלריות וידאו</a>|
			<a href="/admin/admin_videos.asp">ניהול סרטונים</a>
		</p>
	</div>
	<div id="tabs-3">
		<p>
			<a href="/admin/admin_contacts.asp">ניהול פניות</a>|
			<a href="/admin/admin_userscategory.asp">ניהול קבוצות משמשים</a>|
			<a href="/admin/admin_users.asp">ניהול משתמשים</a>|
			<a href="/admin/admin_users.asp?type=preparemail">שליחת ניוזלטר</a>|
			<a href="/admin/admin_users.asp?type=preparesms">שליחת אס אמ אס</a>|
			<a href="/admin/admin_response.asp">ניהול תגובות</a>
		</p>
	</div>
	<div id="tabs-4">
		<p>
			<% If Session(SiteID & "AdminLevel") = 0 Then %>
			<a href="/admin/admin_forms.asp">ניהול טפסים</a>|
			<a href="/admin/admin_template.asp">ניהול תבניות</a>|
			<a href="/admin/admin_Menucategory.asp">ניהול תפריטים</a>|
			<a href="/admin/admin_Newscategory.asp">ניהול בלוקי חדשות</a>
			<a href="/admin/admin_cal.asp">ניהול יומנים</a>
			
			<% End If %>|
			<a href="/admin/admin_admin.asp">ניהול הרשאות</a>|
			<a href="/admin/admin_site.asp?ID=<%=getconfig("SiteID") %>&action=edit">הגדרות אתר</a>|
			<a href="/admin/admin_footer.asp?ID=<%=getconfig("SiteID") %>&action=edit">תוכן חלק תחתון</a>
		</p>
	</div>
	<div id="tabs-5">
		<p>
			<a href="admin_seo.asp?ID=<%=getconfig("SiteID") %>&action=edit">הגדרות SEO</a>|
			<a href="admin_bannerscategory.asp">ניהול קמפיינים</a>|
			<a href="admin_banners.asp">ניהול באנרים</a>|
			<a href="#">חיבור לרשתות חברתיות</a>|
			<a href="/admin/admin_clicks.asp">ניהול קליקים</a>
			<a href="/admin/admin_autolinks.asp">ניהול קישורים אוטומטים</a>
		</p>
	</div>
	<div id="tabs-6">
		<p>
		<% if SiteID=58 then %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_orderspicpazz.asp">ניהול הזמנות</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_coupons.asp">ניהול קופונים</a>|<% End If %>
		<% else %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_orders.asp">ניהול הזמנות</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_product.asp">ניהול מוצרים</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_productfuturescategory.asp">קבוצות מאפיינים</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_productfutures.asp">ניהול מאפיינים</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_shiping.asp">ניהול משלוחים</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_productshiping.asp">ניהול משלוח לפי פריט</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_coupons.asp">ניהול קופונים</a>|<% End If %>
			<% If Getconfig("shop") = 1 Then %><a href="admin_productprice.asp">ניהול מחירונים</a>|<% End If %>
			
			<% If Getconfig("forum") = 1 Then %><a href="admin_forums.asp">ניהול פורומים</a>|<% End If %>
			<% If Getconfig("forum") = 1 Then %><a href="admin_Forummessage.asp">ניהול הודעות בפורום</a><% End If %>
			<a href="admin_Customform.asp">ניהול טפסים</a>|
		   <a href="admin_calendarevents.asp">ניהול אירועים</a>
		  <% End if%>
		</p>
	</div>




         <% If LinkRs.Recordcount > 0 Then %>
      <div id="tabs-7">
		<p>
            <%	do while not LinkRs.Eof
				%><a href="<%=LinkRs("URL")%>"><%=LinkRs("Name")%></a><%
				LinkRs.movenext
				    loop	
				%>
         </p>
	</div>
			<%	
			end if %>

</div>
</div>
<div id="container">
<div id="content">