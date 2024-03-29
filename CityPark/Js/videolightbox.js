jQuery(function(){
	var $=jQuery;

	if(!document.getElementById("vcontainer")){
		$("body").append($("<div id='voverlay'></div>"));
		$("#voverlay").append($("<div id = 'vcontainer'></div>"));
	}

	$("#videogallery a[rel]").overlay({
		api:true,

		expose: (0?{
			color:'#151410',
			loadSpeed:400,
			opacity:0
		}:null),

		onClose: function(){
			swfobject.removeSWF("video_overlay");
		},


		// create video object for overlay
		onBeforeLoad: function(){
			// check and create overlay contaner
			var c = document.getElementById("video_overlay");
			if(!c){
				var d = $("<div></div>");
				d.attr({id: "video_overlay"});
				$("#vcontainer").append(d);
			};
			
			var wmkText="VideoLightBox.com";
			var wmkLink="http://videolightbox.com";
			c = wmkText? $('<div></div>'):0;
			if (c) {
				c.css({
					position:'absolute',
					right:'38px',
					top:'38px',
					padding:'0 0 0 0'
				});
				$("#vcontainer").append(c);
			};

			// for IE use iframe
			if (c && document.all){
				var f = $('<iframe src="javascript:false"></iframe>');
				f.css({
					position:'absolute',
					left:0,
					top:0,
					width:'100%',
					height:'100%',
					filter:'alpha(opacity=0)'
				});
				
				f.attr({
					scrolling:"no",
					framespacing:0,
					border:0,
					frameBorder:"no"
				});
				
				c.append(f);
			};
			
			var d = c? $(document.createElement("A")):c;
			if(d){
				d.css({
					position:'relative',
					display:'block',
					'background-color':'#E4EFEB',
					color:'#837F80',
  					'font-family':'Lucida Grande,Arial,Verdana,sans-serif',
					'font-size':'11px',
					'font-weight':'normal',
  					'font-style':'normal',
					padding:'1px 5px',
					opacity:.7,
					filter:'alpha(opacity=70)',
					width:'auto',
					height:'auto',
					margin:'0 0 0 0',
					outline:'none'
				});
				d.attr({href:wmkLink});
				d.html(wmkText);
				d.bind('contextmenu', function(eventObject){
					return false;
				});
				
				c.append(d);
			}
			
			// create SWF
			var src = this.getTrigger().attr("href");
			
			if (typeof(d)!='number' && (!c || !c.html || !c.html())) return;
			
			swfobject.createSWF(
				{ data:src, width:"100%", height:"100%", wmode:"opaque" },
				{ allowScriptAccess: "always", allowFullScreen: true },
				"video_overlay");
		}
	});
});
