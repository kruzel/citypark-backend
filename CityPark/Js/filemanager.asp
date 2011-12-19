<% 
Response.ContentType = "text/javascript"
%>
var urlobj;

function BrowseServer(obj)
{
	urlobj = obj;
	
	OpenServerBrowser(
		'/admin/FCKeditor/editor/filemanager/browser/netrube/browser.html?Type=Images&Connector=connectors/asp/connector.asp',
		screen.width * 0.7,
		screen.height * 0.7 ) ;
}
function BrowseVideo(obj)
{
	urlobj = obj;
	
	OpenServerBrowser(
		'/admin/FCKeditor/editor/filemanager/browser/netrube/browser.html?Type=Flash&Connector=connectors/asp/connector.asp',
		screen.width * 0.7,
		screen.height * 0.7 ) ;
}
function BrowseFile(obj) {
    urlobj = obj;

    OpenServerBrowser(
		'/admin/FCKeditor/editor/filemanager/browser/netrube/browser.html?Type=File&Connector=connectors/asp/connector.asp',
		screen.width * 0.7,
		screen.height * 0.7);
}


function BrowseUserFile(obj) {
    urlobj = obj;

    OpenServerBrowser(
		'/admin/FCKeditor/editor/filemanager/browser/netrube/browser.html?Type=File&Connector=userconnectors/asp/connector.asp',
		screen.width * 0.7,
		screen.height * 0.7);
}
function BrowseLayout(obj) {
    urlobj = obj;

    OpenServerBrowser(
		'/admin/FCKeditor/editor/filemanager/browser/netrube/browser.html?Type=Layout&Connector=connectors/layout/connector.asp',
		screen.width * 0.7,
		screen.height * 0.7);
}

function OpenServerBrowser( url, width, height )
{
	var iLeft = (screen.width  - width) / 2 ;
	var iTop  = (screen.height - height) / 2 ;

	var sOptions = "toolbar=no,status=no,resizable=yes,dependent=yes" ;
	sOptions += ",width=" + width ;
	sOptions += ",height=" + height ;
	sOptions += ",left=" + iLeft ;
	sOptions += ",top=" + iTop ;

	var oWindow = window.open( url, "BrowseWindow", sOptions ) ;
}

function SetUrl( url, width, height, alt )
{
	if (urlobj.substring(0, 'xFileName'.length) == 'xFileName')
		document.getElementById(urlobj).value = getFileName(url) ;
	else
		document.getElementById(urlobj).value = url ;
		
	oWindow = null;
}

function getFileName(path) {
	return path.substr(path.lastIndexOf("/")+1,path.length);
}