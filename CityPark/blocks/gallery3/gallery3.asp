<!--#include file="../../config.asp"-->
<head>

<link rel="stylesheet" href='/blocks/gallery3/css/galleriffic-2.css' type="text/css" media="screen, projection" />
<script type="text/javascript" src="/blocks/gallery3/js/jquery.galleriffic.js"></script>

<script type="text/javascript" src="/blocks/gallery3/js/jquery.opacityrollover.js"></script>
<script type="text/javascript">
	document.write('<style>.noscript { display: none; }</style>');
</script>

</head>

<!-- Start Advanced Gallery Html Containers -->
				<div id="gallery" class="content">
					<div id="controls" class="controls"></div>
					<div class="slideshow-container">
						<div id="loading" class="loader"></div>
						<div id="slideshow" class="slideshow"></div>
					</div>
					<div id="caption" class="caption-container"></div>
				</div>
				<div id="thumbs" class="navigation">
					<ul class="thumbs noscript">


<% 
Set objRsGallery = OpenDB("SELECT * FROM gallery WHERE galleryID=" & GetSession("galleryid"))
Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
Set MyFolder=MyFileObject.GetFolder(phisicalpath &  Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\")
Set d=Server.CreateObject("Scripting.Dictionary")

Path = phisicalpath  & Application(ScriptName & "ScriptPath") & "\content\images\" & objRsGallery("gallerydirectory") & "\photo_info.txt"

If MyFileObject.FileExists(Path) Then
PhotoInfoFile = MyFileObject.GetFile(Path).OpenAsTextStream(1,0).ReadAll() 
End If		
				
	SplittedInfoFile = Split(PhotoInfoFile, vbCrLf)

For Each f In SplittedInfoFile 
Splitted2 = Split(f, ",")
					
PictureName = Splitted2(0)
PictureDescription = Splitted2(1)
					
d.Add PictureName , PictureDescription 
	Next
%>
<%	i=0
FOR EACH thing in MyFolder.Files
FileName=thing.Name
imagelink=MyFolder & "\" & FileName
If MyFileObject.GetExtensionName(imagelink) <> "txt" Then
image = "/Sites/" &  Application(ScriptName & "ScriptPath") & "/Content/images/" & objRsGallery("gallerydirectory") & "/" & FileName 
%>

<li>
							<a class="thumb" name="leaf" href="<% = image %>" title="Title #0">
								<img src="<% = image %>" width="80" alt="Title #0" />
							</a>
						</li>

<%  
	end if 
	NEXT 
%>
</ul>
				</div>
                				<div style="clear: both;"></div>

		
		<script type="text/javascript">
		    jQuery(document).ready(function ($) {
		        // We only want these styles applied when javascript is enabled
		        $('div.navigation').css({ 'width': '200px', 'float': 'left' });
		        $('div.content').css('display', 'block');

		        // Initially set opacity on thumbs and add
		        // additional styling for hover effect on thumbs
		        var onMouseOutOpacity = 0.67;
		        $('#thumbs ul.thumbs li').opacityrollover({
		            mouseOutOpacity: onMouseOutOpacity,
		            mouseOverOpacity: 1.0,
		            fadeSpeed: 'fast',
		            exemptionSelector: '.selected'
		        });

		        // Initialize Advanced Galleriffic Gallery
		        var gallery = $('#thumbs').galleriffic({
		            delay: 2500,
		            numThumbs: 10,
		            preloadAhead: 10,
		            enableTopPager: true,
		            enableBottomPager: true,
		            maxPagesToShow: 7,
		            imageContainerSel: '#slideshow',
		            controlsContainerSel: '#controls',
		            captionContainerSel: '#caption',
		            loadingContainerSel: '#loading',
		            renderSSControls: true,
		            renderNavControls: true,
		            playLinkText: 'הפעל מצגת',
		            pauseLinkText: 'עצור מצגת',
		            prevLinkText: 'תמונה קודמת',
		            nextLinkText: 'תמונה הבאה',
		            nextPageLinkText: 'הבא',
		            prevPageLinkText: 'הקודם',
		            enableHistory: false,
		            autoStart: false,
		            syncTransitions: true,
		            defaultTransitionDuration: 900,
		            onSlideChange: function (prevIndex, nextIndex) {
		                // 'this' refers to the gallery, which is an extension of $('#thumbs')
		                this.find('ul.thumbs').children()
							.eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end()
							.eq(nextIndex).fadeTo('fast', 1.0);
		            },
		            onPageTransitionOut: function (callback) {
		                this.fadeTo('fast', 0.0, callback);
		            },
		            onPageTransitionIn: function () {
		                this.fadeTo('fast', 1.0);
		            }
		        });
		    });
		</script>
