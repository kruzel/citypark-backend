<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>מערכת ניהול</title>
    <meta name="keywords" content="מערכת ניהול" />
    <meta name="description" content="מערכת ניהול" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="Content-Language" content="he" />
    <meta name="ROBOTS" content="INDEX,FOLLOW" />
    <meta name="copyright" content="Dooble.co.il" />
    <meta name="Author" content="Dooble.co.il" />
    <meta name="rating" content="General" />
        <link rel="stylesheet" media="all" type="text/css" href="/sites/cms/layout/style/style.css" />
		<link href="/css/tablesorter.css" rel="stylesheet" type="text/css" />
<link type="text/css" media="screen" rel="stylesheet" href="/js/colorbox.css" />
<link href="/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />

<!--[if IE]>
<link type="text/css" media="screen" rel="stylesheet" href="/js/colorbox-ie.css" title="example" />
<![endif]-->
<link rel="stylesheet" href="/css/jquery-ui.css" type="text/css"  />
<link rel="stylesheet" href="/js/pager.css" type="text/css"  />

<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/ajax.js"></script>

<script type="text/javascript" src="/js/jquery.pager.js"></script>
<script type="text/javascript" src="/js/jquery.colorbox.js"></script>
<script type="text/javascript" src="/js/validate.asp"></script>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/filemanager.js"></script>
<script type="text/javascript" src="/js/jquery.confirm.js"></script>
<script type="text/javascript" src="/js/jquery.treeTable.js"></script>

<script type="text/javascript" src="/js/jquery.tablesorter.js"></script> 


 <script type="text/javascript">
     jQuery(document).ready(function() {
        jQuery("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });
     });
</script>
<script type="text/javascript">
    function Mark(object_reference) {
        object_reference.style.backgroundColor = "#FFF8DD";
    }

    function Unmark(object_reference) {
        object_reference.style.backgroundColor = "";
    }
</script>
	<script type="text/javascript">
	    function ShowHide(obj) {
	        obj.animate({ "height": "toggle" }, { duration: 1000 });
	    }
</script>
<script type="text/javascript">
	$(document).ready(function() {
    // First example
    $('.delete a').click(function() {
        alert('click');
        return false;
    });
 
    // The most simple use.
    $('a.delete').confirm();
});

</script>

</head>
<body id="body">
<% if Getconfig("maxinshortdescription") = "" Then
		maxchars = 200
	Else
		maxchars = Getconfig("maxinshortdescription")
	End if
%>
<div id="container">
<div id="header">
    <div style="width:100%;height:56px;">
        <div style="width:600px;float:right;height:56px;color:#fff;line-height:43px;margin-right:10px;font-weight:bold;">שלום <% = GetSession("UserName") %>, <a href="default.asp?S=<%=SiteID%>&mode=logout" style="text-decoration: none">התנתק</a>&nbsp;&nbsp;&nbsp;&nbsp;<% If Session(SiteID & "AdminLevel") = 0 Then %>ניהול מערכת: <a href="/admin/admin_formblock.asp">ניהול טפסים</a> | <a href="../admin/admin_template.asp">ניהול תבניות</a> | <a href="../admin/admin_Menucategory.asp">ניהול תפריטים</a> | <a href="../admin/admin_Newscategory.asp">ניהול בלוקי חדשות</a><%End If %></div>
        <% if SiteID = "7" Then %><div style="font-size:14px;font-weight:bold;width:200px;float:right;height:56px;color:#fff;line-height:43px;color:red;">גודל תמונות: 1006px על 527px</div><% End if %>
		<div style="width:200px;float:left;height:56px;"><a href="http://www.dooble.co.il"><img style="float:left;margin-left:10px;" src="/sites/cms/layout/images/logo.gif" border="0" alt="" /></a></div>  
    </div>
    <div style="width:100%;height:28px;">
        <div style="clear:both;width:780px;float:right;height:28px;"><!--#include file="adminmenu.asp"--></div>
        <div style="padding-left:10px;width:40px;float:left;line-height:28px;height:28px;"><a href="default.asp?S=<%=SiteID%>&mode=logout" style="color:#D10003;" href="#">התנתק</a></div>
        <div style="width:20px;float:left;line-height:28px;height:28px;"><a href="#"><img src="/sites/cms/layout/images/logout.gif" border="0" alt="" /></a></div>
    </div>
</div>
<div id="content">