<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>JavaScript Slideshow - TinySlideshow</title>
<link rel="stylesheet" href="../style.css" />
</head>
<body>
	<ul id="slideshow">
		<li>
			<h3>TinySlideshow v1</h3>
			<span>photos/orange-fish.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<a href="#"><img src="../thumbnails/orange-fish-thumb.jpg" alt="Orange Fish" width="125" height="75" /></a>
		</li>
		<li>
			<h3>Sea Turtle</h3>
			<span>photos/sea-turtle.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<img src="../thumbnails/sea-turtle-thumb.jpg" alt="Sea Turtle" width="125" height="75" />
		</li>
		<li>
			<h3>Red Coral</h3>
			<span>photos/red-coral.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<a href="#"><img src="../thumbnails/red-coral-thumb.jpg" alt="Red Coral" width="75" height="75" /></a>
		</li>
		<li>
			<h3>Coral Reef</h3>
			<span>photos/coral-reef.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<a href="#"><img src="../thumbnails/coral-reef-thumb.jpg" alt="Coral Reef" width="125" height="75" /></a>
		</li>
		<li>
			<h3>Blue Fish</h3>
			<span>photos/blue-fish.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<img src="../thumbnails/blue-fish-thumb.jpg" alt="Blue Fish" width="125" height="75" />
		</li>
		<li>
			<h3>TinySlideshow v.2</h3>
			<span>photos/yellow-fish.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<a href="#"><img src="../thumbnails/yellow-fish-thumb.jpg" alt="Yellow Fish" width="125" height="75" /></a>
		</li>
		<li>
			<h3>Squid</h3>
			<span>photos/squid.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<a href="#"><img src="../thumbnails/squid-thumb.jpg" alt="Squid" width="125" height="75" /></a>
		</li>
		<li>
			<h3>Small Fish</h3>
			<span>photos/small-fish.jpg</span>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut urna. Mauris nulla. Donec nec mauris. Proin nulla dolor, bibendum et, dapibus in, euismod ut, felis.</p>
			<a href="#"><img src="../thumbnails/small-fish-thumb.jpg" alt="Small Fish" width="125" height="75" /></a>
		</li>
	</ul>
	<div id="wrapper">
		<div id="fullsize">
			<div id="imgprev" class="imgnav" title="Previous Image"></div>
			<div id="imglink"></div>
			<div id="imgnext" class="imgnav" title="Next Image"></div>
			<div id="image"></div>
			<div id="information">
				<h3></h3>
				<p></p>
			</div>
		</div>
		<div id="thumbnails">
			<div id="slideleft" title="Slide Left"></div>
			<div id="slidearea">
				<div id="slider"></div>
			</div>
			<div id="slideright" title="Slide Right"></div>
		</div>
	</div>
<script type="text/javascript" src="../compressed.js"></script>
<script type="text/javascript">
	$('slideshow').style.display='none';
	$('wrapper').style.display='block';
	var slideshow=new TINY.slideshow("slideshow");
	window.onload=function(){
		slideshow.auto=true;
		slideshow.speed=5;
		slideshow.link="linkhover";
		slideshow.info="information";
		slideshow.thumbs="slider";
		slideshow.left="slideleft";
		slideshow.right="slideright";
		slideshow.scrollSpeed=4;
		slideshow.spacing=5;
		slideshow.active="#fff";
		slideshow.init("slideshow","image","imgprev","imgnext","imglink");
	}
</script>
</body>
</html>