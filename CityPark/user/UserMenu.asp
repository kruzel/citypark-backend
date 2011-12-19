<head>
<link href="/admin/menu.css" type="text/css" media="all" rel="stylesheet"/>
<script src="/js/dropdown.js" type="text/javascript"></script>
</head>
<div width="98%" height="40" style="background:url(../images/menu.jpg) repeat-x;">
<table id="nav">
	<tbody>
		<tr>
			<td class="first"><a href="/user/default.asp">ראשי</a></td>
			<td class="btn2"><a href="">ניהול מיניסייט</a>
				<ul>
						<li><a href="../admin/admin_content.asp?action=add">הוספת דף</a></li>
						<li style="border-bottom:1px solid #57A5EC;"><a href="../admin/admin_content.asp">ניהול דפים</a></li>
						<li><a href="../admin/admin_category.asp?action=add">הוספת מיניסייט</a></li>
						<li style="border-bottom:1px solid #57A5EC;"><a href="../admin/admin_category.asp">ניהול מיניסייט</a></li>
				</ul>
            </td>
			<td class="btn3"><a href="">ניהול בלוגים</a>
			<ul>
						<li><a href="../admin/admin_news.asp?action=add">הוספת בלוג</a></li>
						<li style="border-bottom:2px solid #57A5EC;"><a href="../admin/admin_news.asp">ניהול חדשות</a></li>
						<li style="border-bottom:2px solid #57A5EC;"><a href="../admin/admin_calendar.asp">ניהול אירועים</a></li>
				</ul></td>
			<td class="btn4"><a href="">ניהול כפתורים</a>
				<ul>
					<li><a href="../admin/admin_menu.asp?action=add">הוספת כפתורים</a></li>
					<li style="border-bottom:2px solid #57A5EC;"><a href="../admin/admin_Menu.asp">ניהול כפתורים</a></li>
				</ul></td>
			<td class="btn4"><a href="">מולטימדיה</a>
				<ul>
					<li><a href="../admin/admin_gallery.asp">ניהול גלריות</a></li>
					<li style="border-bottom:1px solid #57A5EC;"><a href="../admin/admin_photo.asp">ניהול תמונות</a></li>
					<li><a href="../admin/admin_videocategory.asp">ניהול גלריות וידאו</a></li>
					<li style="border-bottom:1px solid #57A5EC;"><a href="../admin/admin_video.asp">ניהול סרטונים</a></li>
					<li style="border-bottom:2px solid #57A5EC;"><a target="_blank" href="../admin/FCKeditor/editor/filemanager/browser/netrube/browser.html?Type=Images&Connector=connectors/asp/connector.asp">ניהול קבצים</a></li>
				</ul></td>	
				
				
			<td class="last"><a href="../<%=getconfig("WebPageUrl") %>" target="_blank">עריכה מהירה</a></td>
		</tr>
	</tbody>
</table>	
</div>