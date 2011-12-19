<!--#include file="../config.asp"-->
<div id="newsticker-demo">    
    <div class="newsticker-jcarousellite">
		<ul>

 <%
     SQL = "SELECT TOP 10 * FROM Parkingtweets WHERE SiteID=" & SiteID & " Order By Id Desc"
     Set objRsg = OpenDB(SQL)
	    If objRsg.RecordCount = 0 Then
               print "אין רשומות"
	     Else
            Do While Not objRsg.EOF
                print " <li>" & vbCrLf
                print "<div class=""info_tweet"">" & vbCrLf 
                print  "<p class=""infoDate"">" &objRsg("Date") & "</p><p class=""infoCity"">" & objRsg("City") & " </p><p class=""infoStreet"">" &  objRsg("Street") & " </p><p class=""infoHouse_Number"">" & objRsg("House_Number")  & "</p><p class=""infoText"">" &objRsg("Text") & "</p>"
                print  " </div>"& vbCrLf
                print "</li>"  & vbCrLf
            objRsg.MoveNext
		        Loop
        End if
      CloseDB(objRsg)

%>
        </ul>
    </div>
    
</div>

