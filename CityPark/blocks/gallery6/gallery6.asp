<!--#include file="../../config.asp"-->
		<!-- scriptaculous -->
		<script type="text/javascript" src="/blocks/gallery6/js/prototype.js"></script>
		<script type="text/javascript" src="/blocks/gallery6/js/scriptaculous.js"></script>
		<script type="text/javascript" src="/blocks/gallery6/js/behaviour.js"></script>
		<script type="text/javascript" src="/blocks/gallery6/js/soundmanager.js"></script>
		
<head>
		<link rel="stylesheet" href="/blocks/gallery6/css/master.css?nov282005" type="text/css" media="screen" />
		<script type="text/javascript">

// get current photo id from URL
var thisURL = document.location.href;
var splitURL = thisURL.split("#");
var photoId = splitURL[1] - 1;

// if no photoId supplied then set default
var photoId = (!photoId)? 0 : photoId;

// CSS border size x 2
var borderSize = 10;
<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
If objRsGallery("galleryfromdatabase") = 1 Then
	Set objRs = OpenDB("SELECT * FROM photo WHERE galleryID=" & GetSession("galleryid") & " AND SiteID=" & SiteID & " ORDER BY photoorder ASC")
%>
// Photo directory for this gallery
var photoDir = "/<% = Application(ScriptName & "UploadPath") & "/" & objRsGallery("gallerydirectory")%>/";

// Define each photo's name, height, width, and caption
var photoArray = new Array(
	// Source, Width, Height, Caption
<%
i=1
Do While Not objRs.EOF
imagelink = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\" & objRS("image")
%>
	new Array("<% =objRS("image")%>", "450", "350", "<% = objRS("photodesc") %>")<% If objRS.RecordCount <> i Then%>,<% End If %>
	<% 	objRs.MoveNext
	i=i+1
		Loop
objRs.close
Else	
			Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
				Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\")
			Set d=Server.CreateObject("Scripting.Dictionary")

				Path = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\photo_info.txt"

			If MyFileObject.FileExists(Path) Then
				PhotoInfoFile = MyFileObject.GetFile(Path).OpenAsTextStream(1,0).ReadAll() 
			End If		
				
			SplittedInfoFile = Split(PhotoInfoFile, vbCrLf)
%>
// Photo directory for this gallery
var photoDir = "/<% = Application(ScriptName & "UploadPath") & "/" & objRsGallery("gallerydirectory")%>/";

// Define each photo's name, height, width, and caption
var photoArray = new Array(
	// Source, Width, Height, Caption

<%			For Each f In SplittedInfoFile 
				Splitted2 = Split(f, ",")
					
				PictureName = Splitted2(0)
				PictureDescription = Splitted2(1)
					
				d.Add PictureName , PictureDescription 
			Next
		%>
			<%	x=0
			FOR EACH thing in MyFolder.Files
			x=x+1
			NEXT
			i=1
			FOR EACH thing in MyFolder.Files
			FileName=thing.Name
			imagelink=MyFolder & "\" & FileName
			 If MyFileObject.GetExtensionName(imagelink) <> "txt" Then
		%>
new Array("<% = FileName%>", "450", "350", "<% = FileName %>")<% If x <> i Then%>,<% End If %>
<% 	end if 
	i=i+1
	NEXT 
End If 
 %>
);


// Number of photos in this gallery
var photoNum = photoArray.length;

/*--------------------------------------------------------------------------*/

// Additional methods for Element added by SU, Couloir
Object.extend(Element, {
	getWidth: function(element) {
   	element = $(element);
   	return element.offsetWidth; 
	},
	setWidth: function(element,w) {
   	element = $(element);
    	element.style.width = w +"px";
	},
	setHeight: function(element,h) {
   	element = $(element);
    	element.style.height = h +"px";
	},
	setSrc: function(element,src) {
    	element = $(element);
    	element.src = src; 
	},
	setHref: function(element,href) {
    	element = $(element);
    	element.href = href; 
	},
	setInnerHTML: function(element,content) {
		element = $(element);
		element.innerHTML = content;
	}
});

/*--------------------------------------------------------------------------*/

var Slideshow = Class.create();

Slideshow.prototype = {
	initialize: function(photoId) {
		this.photoId = photoId;
		this.photo = 'Photo';
		this.photoBox = 'Container';
		this.prevLink = 'PrevLink';
		this.nextLink = 'NextLink';
		this.captionBox = 'CaptionContainer';
		this.caption = 'Caption';
		this.counter = 'Counter';
		this.loader = 'Loading';
	},
	getCurrentSize: function() {
		// Get current height and width, subtracting CSS border size
		this.wCur = Element.getWidth(this.photoBox) - borderSize;
		this.hCur = Element.getHeight(this.photoBox) - borderSize;
	},
	getNewSize: function() {
		// Get current height and width
		this.wNew = photoArray[photoId][1];
		this.hNew = photoArray[photoId][2];
	},
	getScaleFactor: function() {
		this.getCurrentSize();
		this.getNewSize();
		// Scalars based on change from old to new
		this.xScale = (this.wNew / this.wCur) * 100;
		this.yScale = (this.hNew / this.hCur) * 100;
	},
	setNewPhotoParams: function() {
		// Set source of new image
		Element.setSrc(this.photo,photoDir + photoArray[photoId][0]);
		// Set anchor for bookmarking
		Element.setHref(this.prevLink, "#" + (photoId+1));
		Element.setHref(this.nextLink, "#" + (photoId+1));
	},
	setPhotoCaption: function() {
		// Add caption from gallery array
		Element.setInnerHTML(this.caption,photoArray[photoId][3]);
		Element.setInnerHTML(this.counter,((photoId+1)+'/'+photoNum));
	},
	resizePhotoBox: function() {
		this.getScaleFactor();
		new Effect.Scale(this.photoBox, this.yScale, {scaleX: false, duration: 0.3, queue: 'front'});
		new Effect.Scale(this.photoBox, this.xScale, {scaleY: false, delay: 0.5, duration: 0.3});
		// Dynamically resize caption box as well
		Element.setWidth(this.captionBox,this.wNew-(-borderSize));
	},
	showPhoto: function(){
		new Effect.Fade(this.loader, {delay: 0.5, duration: 0.3});
		// Workaround for problems calling object method "afterFinish"
		new Effect.Appear(this.photo, {duration: 0.5, queue: 'end', afterFinish: function(){Element.show('CaptionContainer');Element.show('PrevLink');Element.show('NextLink');}});
	},
	nextPhoto: function(){
		// Figure out which photo is next
		(photoId == (photoArray.length - 1)) ? photoId = 0 : photoId++;
		this.initSwap();
	},
	prevPhoto: function(){
		// Figure out which photo is previous
		(photoId == 0) ? photoId = photoArray.length - 1 : photoId--;
		this.initSwap();
	},
	initSwap: function() {
		// Begin by hiding main elements
		Element.show(this.loader);
		Element.hide(this.photo);
		Element.hide(this.captionBox);
		Element.hide(this.prevLink);
		Element.hide(this.nextLink);
		// Set new dimensions and source, then resize
		this.setNewPhotoParams();
		this.resizePhotoBox();
		this.setPhotoCaption();
	}
}

/*--------------------------------------------------------------------------*/

// Establish CSS-driven events via Behaviour script
var myrules = {
	'#Photo' : function(element){
		element.onload = function(){
			var myPhoto = new Slideshow(photoId);
			myPhoto.showPhoto();
		}
	},
	'#PrevLink' : function(element){
		element.onmouseover = function(){
			soundManager.play('beep');
		}
		element.onclick = function(){
			var myPhoto = new Slideshow(photoId);
			myPhoto.prevPhoto();
			soundManager.play('select');
		}
	},
	'#NextLink' : function(element){
		element.onmouseover = function(){
			soundManager.play('beep');
		}
		element.onclick = function(){
			var myPhoto = new Slideshow(photoId);
			myPhoto.nextPhoto();
			soundManager.play('select');
		}
	},
	a : function(element){
		element.onfocus = function(){
			this.blur();
		}
	}
};

// Add window.onload event to initialize
Behaviour.addLoadEvent(init);
Behaviour.apply();
function init() {
	var myPhoto = new Slideshow(photoId);
	myPhoto.initSwap();
	soundManagerInit();
}
		
		</script>
		
		
	<body>		
		<!-- slideshow -->
		<div id="OuterContainer">
			<div id="Container">
				<img id="Photo" src="/blocks/gallery6/img/c.gif" alt="Photo: Couloir" />
				<div id="LinkContainer">
				    <a href="#" id="PrevLink" title="Previous Photo"><span>������ ������</span></a>
				    <a href="#" id="NextLink" title="Next Photo"><span>������ ����</span></a>
			    </div>
			    <div id="Loading"><img src="/blocks/gallery6/img/loading_animated2.gif" width="48" height="47" alt="Loading..." /></div>
			</div>
		</div>
		
		<div id="CaptionContainer">
		    <p><span id="Counter">&nbsp;</span> <span id="Caption">&nbsp;</span></p>
		</div>
		
		<script type="text/javascript">
 		// <![CDATA[
 		Behaviour.register(myrules);
 		// ]]>
 		</script>
	</body>
</html>
