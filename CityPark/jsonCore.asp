<!--#include file="config.asp"-->

<head>

	 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	<link href="/css/demo.css" rel="stylesheet" type="text/css" media="all" />
	
    <script type="text/javascript"> 
        $(document).ready(function() {
			$("ul#treeList li").has("ul").click(function() {
				if ($(this).hasClass("open")) {
					$(this).removeClass("open").addClass("close");
					$(this).find("ul").hide();
			}else {
			if ($(this).is(":parent")) {
				$("ul#treeList li:has(ul)").addClass("close");
				$(this).parent().find("ul").hide();
				$(this).find("ul").show().parent().removeClass("close").addClass("open");
				}
				}
				});
				
				 
		    $("ul#treeList li:has(ul)").addClass("close");
$("ul#treeList li span").click(function() {
$("#c").text($(this).attr("code"));
});
   
        });
 
       
    </script> 
	</head> 
	<body>
	<div id="c" style="float:left">aaa</div>
	<div class="treeListDemoContainer">
	<ul id="treeList">
<%

  Function buildtree(id,x,i)
   SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & id & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)  ORDER By ItemOrder ASC"
   Set objRs = OpenDB(SQL)
        Do while Not objRs.EOF
		    print vbCrLf & "  <li id='"&objRS("id")&"'><span code="& x &"." & i &">" & objRS("Name") & "</span>"
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
	   buildtree 0,0,1
%>
</ul>
</body> 
</html>
