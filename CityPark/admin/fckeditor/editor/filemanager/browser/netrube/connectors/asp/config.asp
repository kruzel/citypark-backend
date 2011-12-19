
<%
Dim strDBPath, strConn, objConn, objRs, FolderName, SiteID
SiteID = Cint(Session("SiteID"))

strconn="Provider=SQLNCLI10;Server=DEC-DOOBL2\SQL2008;Database=citypark;Uid=citypark;Pwd=citypark1;"

		Set objConn = Server.CreateObject("ADODB.Connection")
		Set objRs= Server.CreateObject("ADODB.Recordset")
		objConn.Open strConn
 
		objRs.Open "SELECT SiteID ,Sitename FROM Site  Where SiteID = " & SiteID, objConn, 0, 1
            FolderName = objRs("Sitename")
	    objRs.Close		
		objConn.Close
		Set objConn = Nothing
		Set objRs = Nothing

' SECURITY: You must explicitelly custom the filemanager permission.
Dim IsPermission
IsPermission					= CheckPermission()

' You can custom this function.
Function CheckPermission()
	CheckPermission				= True
	
End Function

' Path to user files relative to the document root.
Dim ConfigUserFilesPath
		If Session(SiteID & "Type") = "Admin" Then
            ConfigUserFilesPath = "/Sites/" & FolderName & "/content"
        Else
            ConfigUserFilesPath = "/Sites/" & FolderName & "/users/" &  Request.Cookies(SiteID & "UserID")
      End If

Dim ConfigAllowedExtensions, ConfigDeniedExtensions
Set ConfigAllowedExtensions		= CreateObject( "Scripting.Dictionary" )
Set ConfigDeniedExtensions		= CreateObject( "Scripting.Dictionary" )

ConfigAllowedExtensions.Add	"File", ""
ConfigDeniedExtensions.Add	"File", "php(?=\d)?|phtml|pwml|inc|asp|aspx|ascx|jsp|cfm|cfc|pl|bat|exe|com|dll|vbs|js|reg|cgi"

ConfigAllowedExtensions.Add	"Images", "jpg|gif|jpeg|png|bmp"
ConfigDeniedExtensions.Add	"Images", ""

ConfigAllowedExtensions.Add	"Flash", "swf|fla|swi|flv|pdf|doc|docx|mp3"
ConfigDeniedExtensions.Add	"Flash", ""

ConfigAllowedExtensions.Add	"Media", "swf|fla|jpg|gif|jpeg|png|avi|mpg|mpeg|mp(?=1-4)|wma|wmv|wav|mid|midi|rmi|rm|ram|rmvb|mov|qt"
ConfigDeniedExtensions.Add	"Media", ""

%>