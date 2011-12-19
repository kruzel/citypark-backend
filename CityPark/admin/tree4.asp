<!--#include file="../config.asp"-->
<!--#include file="header.asp"-->


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/js/jquery.cookie.js"></script>
	<script type="text/javascript" src="/js/jquery.hotkeys.js"></script>
	<script type="text/javascript" src="jquery.jstree.js"></script>
	
	<script src="http://www.kelvinluck.com/assets/jquery/jScrollPane/scripts/jScrollPane.js"></script>
	<script src=""></script>
	<script>
		$(function() {
			$("#a").jstree({ 
				"plugins" : [ "themes", "html_data", "checkbox" ],
				core : { rtl: true },
				"themes" : {
					"theme" : "default-rtl",
					"dots" : false,
					"icons" : false
				},
			});
		});
		
	</script>

</head>
<%
  Function buildtree(id,x,i)
   SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)  ORDER By ItemOrder ASC"
   Set objRs = OpenDB(SQL)
        Do while Not objRs.EOF
		    print vbCrLf & "  <li id=""phtml_" & x & """><a href=""#"">" & objRS("Name") & "</a>"
         SQL2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & objRS("id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)  ORDER By ItemOrder ASC"
   Set objRsSon = OpenDB(SQL2)
         If objRsSon.Recordcount > 0 Then
            print  vbCrLf & "    <ul>" 
                buildtree objRS("id"),x,i+1 
            print "</li>" & vbCrLf
         Else
            print "</li>" & vbCrLf
         End If 
    i=1
    x=x+1
   objRs.MoveNext
	  Loop
print "</ul>" & vbCrLf
	CloseDB(objRsSon)		
	CloseDB(objRs)		
    End Function


 %>
<body>
<input type="text" />
<div id="b">
asdfasdf
</div>

<div id="a">
<ul>
	<% buildtree 0,1,1  %>
</div>

</body>
</html>

