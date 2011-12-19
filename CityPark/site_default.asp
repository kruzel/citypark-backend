 <!--#include file="$connection.asp" -->
 
 <%
 
	
		Dim FSO 
		Dim TheFolder
		Set FSO = Server.CreateObject("Scripting.FileSystemObject") 
		Set ThisFolder = FSO.GetFolder(server.mappath("./")) 
		TheFolder=ThisFolder.name
		Set FSO=Nothing
		sPath = Request.ServerVariables("PATH_INFO")

		Set objConn = Server.CreateObject("ADODB.Connection")
		Set objRs = Server.CreateObject("ADODB.Recordset")
		objConn.Open strConn
    
    		objRs.Open "SELECT SiteID, LangID, homepageID, SiteName FROM Site WHERE SiteName='" & TheFolder & "'", objConn, 0, 1
		SiteID = objRs("SiteID")
        Session("SiteID") = objRs("SiteID")
		Session("SiteLang") = objRs("LangID") 
		Session(SiteID & "HomeQSID") = objRs("homepageID")
		objRs.Close
    		Response.Redirect "../../default.asp?s=" & SiteID
	    %>