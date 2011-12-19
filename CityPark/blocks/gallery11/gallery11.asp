<!--#include file="../../config.asp"-->
<script src='/blocks/gallery11/jquery-1.3.2.min.js' type='text/javascript'></script>
<script src='/blocks/gallery11/jquery.cross-slide.js' type='text/javascript'></script>

<style type="text/css">
  #test3 {
    margin: 1em auto;
    border: 2px solid #555;
    width: 400px;
    height: 250px;
  }
</style><% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))

Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoorder ASC")
%>
<script type="text/javascript">
    $(function() {
        $('#test3').crossSlide({
            fade: 1
        }, [
<%	i=1
	Do While Not objRs.EOF
	if  i = 1 Then
	froms = "100% 80% 1x"
	tos = "100% 0% 1.7x" 
	End If
	if  i = 2 Then
	 froms = "top left" 
	 tos = "bottom right 1.5x"
	End If
	if  i mod 2 = 0 then
	 from = "100% 80% 1.5x" 
	 tos = "80% 0% 1.1x"
	End If
	if  i mod 3 = 0 then
	froms = "100% 50%"  
	tos = "30% 50% 1.5x"
	End If

	imagelink = "/sites/" & Application(ScriptName & "ScriptPath") & "/content/images/" & objRsGallery("gallerydirectory") & "/" & objRS("image")

print imagelink
%>	{
          src: '<% = imagelink %>',
          from: '<% =froms %>',
          to: '<%=tos %>',
          time: 5
<% if objRs.Recordcount = i then        
     print "}"
    else
     print "},"
    End if
%>


<%
 	objRs.MoveNext
	i=i+1
		Loop
%>
	]);
    });
</script>
<% objRs.close %>
<div id="test3">Loading…</div>
<script type='text/javascript' id='display-test3'>    displaySource('test3'); </script>
