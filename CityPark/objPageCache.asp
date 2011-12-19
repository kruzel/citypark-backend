<%
'response.write "a"
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Page:				objPageCache.asp
'Copyright			2002 Joe Audette
'Last Modified:		3/17/2002
'
'You may use this code freely as long as you leave my copyright notice in the code.
'You may modify and extend this code to suit your needs as long as you indicate 
'in your code that it is based on my copyrighted code.
'
'Summary:			This file can be included on any dynamic page and will
'					implement caching of the page for the configured time duration
'					(24 hours by default). 
'					You can also manually force the cache to update by adding 
'					"cachecommand=create" to the query string. The cached 
'					version will be displayed until it expires and is 
'					re-created. 
'					To bypass the cached page and see the dynamic 
'					version, add "cachecommand=bypass" to the query string.
'					To clear the cach for the current page add cachecommand=clear
'					To clear the cach for ALL pages add cachecommand=clearall
'					Note cachecommand=clearall only works when caching to files.
'
'					To use this on a page that posts back to itself you must 
'					include an element within the form like this:
'					<INPUT type="hidden" id="IsPostback" name="IsPostback" value="true">
'					This will bypass the cache and let the dynamic page
'					handle the post back.
'					
'					To set up caching on a page, include this file on the page 
'					and then use code something like this:
'
'					Dim objCache
'					Set objCache = New CPageCache
'
'					**OPTIONAL*************************************
'					if you don't set these properties the cache will 
'					expire in 24 hours
'					objCache.CacheIntervalUnit = CI_MINUTES  
'					'oter choices are CI_HOURS or CI_DAYS
'					objCache.CacheIntervalLength = 10 'how many units
'					***********************************************
'					

'					objCache.AutoCacheToMemory() 'or objCache.AutoCacheToFile()
'					Set objCache = Nothing
'
'					You will also need an Application variable in the global.asa file
'					called Application("CachedContentFolder"), indicating the path to 
'					a folder where the cached pages will be kept when you use AutoCacheToFile. 
'					For example you could put a line in the global.asa file like this:
'					Application("CachedContentFolder") = "c:\CachedContent\"
'					This folder must allow write permission to the IUSER_MACHINENAME user.
'					For best practice this folder should be outside the web site folder
'					structure.
'
'					You will also need an application variable called Application("Root") 
'					indicating the root of your site. For example:
'					Application("Root") = "http://myWEBServer"
'					This helps the object figure out what page its on.
'
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Const	CI_MINUTES = 0
Const	CI_HOURS = 1
Const	CI_DAYS = 2

Class CPageCache

Private mstrCacheFileExt
Private mobjFSO						'FileSystem object
Private mstrCacheFileQualifiers
Private mstrCachedFileName
Private mstrScriptFileName
Private mstrScriptBaseName
Private mstrCachedMemoryName
Private mstrCreateMemoryTime
Private mstrCacheCommand
Private mstrCacheFolder
Private mstrDynURL
Private bIsPostBack
Private mintCacheIntervalUnit
Private mintCacheIntervalLength

Private Sub Class_Initialize()
	On Error Resume Next
	
	' Create File System Object
	Set mobjFSO = CreateObject("Scripting.FileSystemObject")
	
	'this determines whether to show the cached content or let the page render dynamically
	mstrCacheCommand = Request("cachecommand")
	'the default is to pass nothing, in which case the cached page is used
	
	'Set the default cache interval
	mintCacheIntervalUnit = CI_DAYS
	mintCacheIntervalLength = 10
	
	' This is the folder name where the cached content will be stored
	mstrCacheFolder = phisicalpath&getconfig("sitename")&"\cache\"
	'"D:\domains\CityPark\citypark.co.il\wwwroot\cache\"
	'Application("CachedContentFolder")
	dim fs
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	if fs.FolderExists(mstrCacheFolder)=false then
		set f=fs.CreateFolder(mstrCacheFolder)
		set f=nothing
	end if
	set fs=nothing
	
	
	'thes next few lines initialize variables that will determine the cached file
	'name based on the ASP page and any querystring params
	mstrScriptFileName = server.MapPath(Request.ServerVariables("PATH_INFO")) 
	mstrScriptBaseName = mobjFSO.GetBaseName(mstrScriptFileName) & "_"
	mstrCacheFileQualifiers = GetCacheFileQualifiers()
	mstrCacheFileExt = ".htm" 'this could be any extension
	
	'determine name for output cache file
	mstrCachedFileName = mstrCacheFolder & siteid&"-"&mstrScriptBaseName _
		& mstrCacheFileQualifiers & mstrCacheFileExt
	'determine the name for application variables to cache in memory
	mstrCachedMemoryName = CStr(mstrScriptBaseName & mstrCacheFileQualifiers)
	mstrCreateMemoryTime = mstrCachedMemoryName & "_Created"
	
	'If this object is used on a form that posts back to itself
	'include an element within the form like this:
	'<INPUT type="hidden" id="IsPostback" name="IsPostback" value="true">
	'This will bypass the cache and let the dynamic page
	'handle the post back.
	bIsPostBack = false
	If Request("IsPostback") = "true" Then
		bIsPostBack = true
	End If
	'get the URL for the current dynamic asp page
	mstrDynURL = Application("Root") & CStr(Request.ServerVariables("URL"))
	If Cstr(Request.QueryString) <> vbNullString Then
		mstrDynURL = mstrDynURL & "?" & Cstr(Request.QueryString)
	End If	
	
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Sub Class_Terminate()
	On Error Resume Next
	' Clean up module-level objects
	If Not mobjFSO Is Nothing Then
		Set mobjFSO = Nothing
	End If
	
End Sub

' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PRIVATE MEMBER METHODS
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Function GetCacheFileQualifiers() 'As String
	'this creates a unique file name portion for
	'each unique query string passed to the ASP page
	On Error Resume Next
	Dim strResults
	Dim var
	Dim strSeparator
	strResults = vbNullString
	strSeparator = vbNullString
	For Each var In Request.QueryString
		If var <> "cachecommand" Then
			strResults = strResults & strSeparator & var & "_" & Request.QueryString(var)
			strSeparator = "_"
		End If
	
	Next
	
	GetCacheFileQualifiers = strResults

End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Function CachedFileExists() 'As Boolean
	On Error Resume Next
	CachedFileExists = mobjFSO.FileExists(mstrCachedFileName)
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Function CacheExistsInMemory() 'As Boolean
	On Error Resume Next	
	
	'Check to see if the application variable has been created.
	If IsEmpty(Application(mstrCachedMemoryName)) OR IsNull(Application(mstrCachedMemoryName)) Then
		CacheExistsInMemory = false
	Else
		CacheExistsInMemory = true
	End If
	
	If err.number <> 0 Then
		'Response.Write err.Description & " CacheExistsInMemory2"
		err.Clear
		CacheExistsInMemory = false
	End If
	
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Function CacheFileIsExpired() 'As Boolean
	On Error Resume Next
	Dim objFile
	Dim strDate
	Dim strUnit
	
	'Get the modified date from the file.
	Set objFile = mobjFSO.GetFile(mstrCachedFileName)
	strDate = objFile.DateLastModified
	Set objFile = nothing	
	
	'Determine the cache interval unit that was selected.
	'and set the datediff unit of measurement.
	Select Case mintCacheIntervalUnit
		Case CI_MINUTES
			strUnit = "n"	'minutes
			
		Case CI_HOURS
			strUnit = "h"	'hours
			
		Case CI_DAYS
			strUnit = "d"	'days
	End Select
	
	'Return the boolean from the comparison utilizing the datediff function.
	CacheFileIsExpired = (DateDiff(strUnit,CDate(strDate), Now()) > mintCacheIntervalLength)

	'Error checking
	If err.Number <> 0 Then
		err.Clear
		CacheFileIsExpired = true
	End If
	
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Function CacheInMemoryIsExpired() 'As Boolean
	'On Error Resume Next
	
	Dim strUnit
	strUnit = "d"	'Default to days.
	
	If IsEmpty(Application(mstrCreateMemoryTime)) OR IsNull(Application(mstrCreateMemoryTime)) _
		OR Application(mstrCreateMemoryTime) = vbNullString Then
		CacheInMemoryIsExpired = true
	Else
		Select Case mintCacheIntervalUnit
			Case CI_MINUTES
				strUnit = "n"	'minutes
				
			Case CI_HOURS
				strUnit = "h"	'hours
			
			Case CI_DAYS
				strUnit = "d"	'days			
		End Select
		
		If CInt(DateDiff(strUnit,CDate(Application(mstrCreateMemoryTime)), Now())) > mintCacheIntervalLength Then
			CacheInMemoryIsExpired = true
		Else
			CacheInMemoryIsExpired = false
		End If		
	End If
	
	If err.number <> 0 Then
		err.Clear
		CacheInMemoryIsExpired = true
	End If
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Sub RenderCacheFromFile()
	'On Error Resume Next
	Dim objfile
	Set objfile = mobjFSO.OpenTextFile(mstrCachedFileName,1,false,-1)
	
	'If error happens the dynamic page will handle
	'the request.
	If err.number <> 0 Then
	'	Response.Write err.Description
		Exit Sub
	End If
	
	'Write the cached file to the 
	'Response and end the response.
	Response.write objfile.ReadAll
	Response.end
	Set objfile = nothing
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Sub RenderCacheFromMemory()
	Response.write(Application(mstrCachedMemoryName))	
	Response.end
End Sub


' ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' PUBLIC METHODS
' ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub AutoCacheToFile()
	On Error Resume Next
	
	If bIsPostBack Then
		'let the dynamic page handle the postback.
		Exit Sub
	End If
	
	Select Case mstrCacheCommand
	
		Case vbNullString 
		
			If Not CachedFileExists() Or CacheFileIsExpired() Then
				CreateCacheFile
			End If
			If err.number = 0 Then
				RenderCacheFromFile
			End If

		Case "bypass" 
			'display dynamic page - do nothing
			
		Case "clear"
			ClearCache
		
		Case "clearall"
			ClearAllCachedFiles
			
		Case "create" 
			'create and display cached page
			CreateCacheFile
			If err.number = 0 Then
				RenderCacheFromFile
			End If
				
	End Select
	
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub AutoCacheToMemory()
	On Error Resume Next
	
	If bIsPostBack Then
		'let the dynamic page handle the postback.
		Exit Sub
	End If
	
	Select Case mstrCacheCommand
	
		Case vbNullString 

			If Not CacheExistsInMemory() Or CacheInMemoryIsExpired() Then
				CreateCacheInMemory
			End If
			
			If err.number = 0 Then
				RenderCacheFromMemory
			Else
				'Response.Write err.Description
				'Response.end
				Exit Sub
			End If
			
		Case "bypass" 
			'display dynamic page - do nothing
			
		Case "clear"
			Application(mstrCachedMemoryName) = Null
		
		Case "create" 
			'create and display cached page
			CreateCacheInMemory
			If err.number = 0 Then
				RenderCacheFromMemory
			Else
				'Response.Write err.Description
				'Response.end
				Exit Sub
			End If
			
	End Select
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub CreateCacheFile()
	On Error Resume Next
	
	Dim strResponse
	Dim objTextStream
	Dim objHTTP
	Dim strDynURL
	
	'Get the URL of the current ASP request
	strDynURL = mstrDynURL
	
	'Add a querystring param that will bypass the cache
	'forcing a dynamic rendering of the page
	If Instr(1,strDynURL, "?") = 0 Then
		strDynURL = strDynURL & "?cachecommand=bypass"
	Else
		strDynURL = strDynURL & "&cachecommand=bypass"
	End If
	
	'Instantiate an HTTP object to request the dynamic page

	
	Set objHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP")
objHTTP.Open "GET", "http://"&getconfig("domains")&strDynURL, False
objHTTP.setRequestHeader "Content-Type","text/html; charset=utf-8"
objHTTP.Send
 response.charset = "utf-8"

text = objHTTP.responseText
'print objHTTP.responseText
	
	
	' Set objHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP.4.0")

	'Depending on your firewall/proxy environment you may need to 
	'configure proxy settings for the HTTP object
	'If your webserver is behind a proxy uncomment the following line.
	'objHTTP.setProxy  SXH_PROXY_SET_PRECONFIG
	'You also need to the use WinHTTP Proxy configuration utility(proxycfg.exe)
	'on the server (see the readme for more details)
	
	
	'Request the dynamic ASP page
	' objHTTP.open "GET", strDynURL, false
	' objHTTP.setRequestHeader "charset", "UTF-8"

' objHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"

	' objHTTP.send()
	
	'Create a text file using the file system object
	Set objTextStream = mobjFSO.CreateTextFile(mstrCachedFileName, true, true)
	
	'Write the rendered content from the dynamic ASP page to the
	'text file to create the cached content. 
'	print "a-"&"<br>"
	' print strDynURL&"<br>"
'	print text&"<br>"
'	print "-b"&"<br>"
	' response.end
	objTextStream.Write(text)
	objTextStream.Close
	
	Set objHTTP = nothing
	Set objTextStream = nothing
	
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub CreateCacheInMemory()
	On Error Resume Next

	Dim objHTTP
	Dim strDynURL
	
	'Get the URL of the current ASP request
	strDynURL = mstrDynURL
	
	'Add a querystring param that will bypass the cache
	'forcing a dynamic rendering of the page
	If Instr(1,strDynURL, "?") = 0 Then
		strDynURL = strDynURL & "?" & "cachecommand=bypass"
	Else
		strDynURL = strDynURL & "&cachecommand=bypass"
	End If
	
	'Instantiate an HTTP object to request the dynamic page
	Set objHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP.4.0")
	
	If err.number <> 0 Then
		'Response.Write err.Description
		Exit Sub
	End If
	
	'Depending on your firewall/proxy environment you may need to 
	'configure proxy settings for the HTTP object
	'If your webserver is behind a proxy uncomment the following line.
	'objHTTP.setProxy  SXH_PROXY_SET_PRECONFIG
	'You also need to the use WinHTTP Proxy configuration utility(proxycfg.exe)
	'on the server (see the readme for more details)	
	
	'Request the dynamic ASP page
	objHTTP.open "GET", strDynURL, false
	objHTTP.send()
	
	If err.number <> 0 Then
'		Response.Write err.Description & "1"
		Exit Sub
	End If
	
	Application(mstrCachedMemoryName) = objHTTP.responseText
	
	If err.number <> 0 Then
'		Response.Write err.Description & "2"
		Exit Sub
	End If
	
	Application(mstrCreateMemoryTime) = cstr(now())
	
	If err.number <> 0 Then
'		Response.Write err.Description
		Exit Sub
	End If
	Set objHTTP = nothing
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub ClearCache()
	'Clears the current page from the cache
	On Error Resume Next
	If CachedFileExists() Then
		mobjFSO.DeleteFile(mstrCachedFileName)
	End If

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub ClearAllCachedFiles()

	On Error Resume Next
	Dim objFolder
	Dim colFiles
	Dim objFile
	
	'Get a reference to the folder containing cached content files
	Set objFolder = mobjFSO.GetFolder(Application("CachedContentFolder"))
	Set colFiles = objFolder.Files
	
	'Delete ALL cached pages
	For Each objFile In colFiles
		objFile.Delete()
	Next
	
	Set colFiles = nothing
	Set objFolder = nothing

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Property Get CacheIntervalUnit()
	CacheIntervalUnit = mintCacheIntervalUnit
End Property

Public Property Let CacheIntervalUnit(ByVal intNewValue)
	mintCacheIntervalUnit = CInt(intNewValue)
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Property Get CacheIntervalLength()
	CacheIntervalLength = mintCacheIntervalLength
End Property

Public Property Let CacheIntervalLength(ByVal intNewValue)
	mintCacheIntervalLength = CInt(intNewValue)
End Property

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Property Get DynURL()
	DynURL = mstrDynURL
End Property

Public Property Let DynURL(ByVal strNewValue)
	mstrDynURL = CStr(strNewValue)
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Property Get StaticFileName()
	CachedFileName = mstrCachedFileName
End Property

Public Property Let CachedFileName(ByVal strNewValue)
	mstrCachedFileName = CStr(strNewValue)
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
End Class
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
%>