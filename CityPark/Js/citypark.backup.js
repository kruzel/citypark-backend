var ajaxvar,hideTimeout;

$(window).load(function() {
$(".btn-slide2").click(function(){//advanced search
				$("#panel").slideToggle("slow");
				$(this).toggleClass("active2"); return false;
			});

			
			
			    $("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });

		//	$('._date').datepick();
	$("#searchaction").click(function() { //trigger for clicking the submit button
		initPark();
		if (ajaxvar)ajaxvar.abort();
			if ( $("#searchtext").val().split(",").length > 1) {
				var streetvar = $("#searchtext").val().split(",")[0].replace(/^\s+|\s+$/g,"");
				var cityvar = $("#searchtext").val().split(",")[1].replace(/^\s+|\s+$/g,"");
			}
				else 
			{
				var streetvar = $("#searchtext").val();
				var cityvar = '';
			}
			var dpayment = $("#panel input:checkbox[name=free]").is(":checked");
			var dlimit = $("#panel input:checkbox[name=limit]").is(":checked");
			var dbarrier = $("#panel input:checkbox[name=barrier]").is(":checked");
			var dunderground = $("#panel input:checkbox[name=underground]").is(":checked");
			var dwalls = $("#panel input:checkbox[name=walls]").is(":checked");
			var ddisabled = $("#panel input:checkbox[name=disabled]").is(":checked");
			var ddistance = $("#distance").val();
			var dstartdate = "";
			var denddate = "";
	if ($("#start_date").val()!='' && $("#end_date").val() !='') {
			var dstartdatetemp = $("#start_date").val().split("/");
			var denddatetemp = $("#end_date").val().split("/");
			dstartdate = dstartdatetemp[2]+"-"+dstartdatetemp[1]+"-"+dstartdatetemp[0];
			denddate = denddatetemp[2]+"-"+denddatetemp[1]+"-"+denddatetemp[0];
		}
			
		ajaxvar = $.ajax({
			type: 'POST',
			url: "parkcore.asp",
			data: {startdate:dstartdate,enddate:denddate,distance:ddistance,street:streetvar,city:cityvar,payment:dpayment,limit:dlimit,barrier:dbarrier,underground:dunderground,walls:dwalls,disabled:ddisabled,m:"srch"},
			success: function(data) {
				if (!$("#results").length) 
					createrestulsdiv(data);
				else {
				$("#results").html(data);
				initParking();
			

				}
				//}
			},
			beforeSend:function() {
			$("#loader").show();
			},
			complete:function() {
			$("#loader").hide();
			}
			
		});
	return false;
	});

	$("#panel input:checkbox").click(function () {
		$("#searchaction").click();
	});
	$("#distance").change(function() {
		$("#searchaction").click();
	});
$("#searchtext").focus(function() {
	$(this).val('');
});
	$("#searchtext").keyup(function() {
		if ($("#searchtext").val().length > 1) {
			if (ajaxvar)ajaxvar.abort();
			ajaxvar = $.ajax({
				type: 'POST',
				url: "parkcore.asp",
				data: {m:"ac",search:$("#searchtext").val()},
				success: function(data) {
					$("#ac").empty().show();
					if (data.length == 1) {
						$("#searchtext").val(data[0].name);
						$("#searchaction").click();
						
					} 
					else {
						$.each(data, function(i,park){
							$("#ac").append("<span onclick='autocomp(this)'>"+park.name+"</span>");
						});
					}
				},
				dataType: "json",
				beforeSend:function() {
					$("#searchtext").addClass("ininputac");
				},
				complete:function() {
					$("#searchtext").removeClass("ininputac");
				}
				
			});
		}
	}).blur(function() { 	
		clearTimeout(hideTimeout);
		hideTimeout = setTimeout('$("#ac").empty().hide()',1000);}
	);
	
	//onInit();
	initOptions();
}); //document ready

function createrestulsdiv(res) {
	$(".text .intext").load("/sites/cityp/layout/he-il/park_search.html?rnd=" + String((new Date()).getTime()).replace(/\D/gi, '')	,function() {
	map.render("map");
	//alert("rendered");
	MapInit();
	$("#results").html(res);
	$("#attraction").remove();
	initParking();
	});
}
//search functions
function initParking() {
	pager();
	addParking();
	initOptions();
	
}

function initOptions() {
$(".options a, table.icons a").each(function() {
if ($(this).attr("rel")!='1') {
	$(this).find('img').attr('src',$(this).find('img').attr('src').split(".")[0]+"1.gif")
	$(this).attr("href","");
	}
	$(this).show();
});
}
function autocomp(that) {
	$("#searchtext").val($(that).text());
	$("#ac").empty().hide();
	$("#searchaction").click();
	}

function initPark() {
$("#hp").show();
$("#changeBG").addClass("searchBottom2");
	$("#results").empty();
	$("#ac").empty().hide();
	}


function pager() {
	//alert(Math.ceil(($("#results .parkme").size())/5));
	if (Math.ceil(($("#results .parkme").size())/5) == 0) {
		setTimeout("pager()",1000);
	} else {
			$("#pager").paginate({
				count 		: Math.ceil(($("#results .parkme").size())/5),
				start 		: 1,
				display     : 7,
				border					: false,
				text_color  			: '#79B5E3',
				background_color    	: 'none',	
				text_hover_color  		: '#2573AF',
				background_hover_color	: 'none', 
				images		: false,
				mouse		: 'press',
				onChange     			: function(page){
				$('._current').removeClass('_current').hide();
				$('#results #parks'+page).addClass('_current').show();
				}
			});
	}
}

function addParking() {
clearLayer();
var parkName,pid,latitude,longitude,lat_total=0,long_total=0,c,temp;
	$("#results .parkme").each(function(i,p) {
		pid = $(this).attr("id").replace("park","");
		latitude = parseFloat($(this).find("div.info").text().split(",")[0]);
		longitude = parseFloat($(this).find("div.info").text().split(",")[1]);
		parkName = $(this).find("div.info").text().split(",")[2];
		lat_total = lat_total + latitude;
		long_total = long_total + longitude;
		putMarker(longitude,latitude,parkName,pid);
		c = i;
		});
		long_total = long_total/(c+1);
		lat_total = lat_total/(c+1);
		g_waze_map.map.setCenter(new OpenLayers.LonLat(long_total,lat_total),9);
}

function parkPage() {
clearLayer();
var parkName,pid,latitude,longitude,lat_total=0,long_total=0,c,temp;
		that = $(".infopage");
		pid = $(that).attr("id").replace("i","");
		latitude = parseFloat($(that).text().split(",")[0]);
		longitude = parseFloat($(that).text().split(",")[1]);
		parkName = $(that).text().split(",")[2];
		putMarker(longitude,latitude,parkName,pid);
	
		g_waze_map.map.setCenter(new OpenLayers.LonLat(longitude,latitude),10);
}

function calcu() {
	$.fancybox(
	$("#calc").html(),
			{
        		'autoDimensions'	: false,
			'width'         		: 500,
			'height'        		: 'auto',
			'transitionIn'		: 'none',
			'transitionOut'		: 'none',
			//'href':	'/sites/cityp/layout/he-il/Lightbox_contact.html'
		}
	);
	}

function contact(id,tmp) {

if (tmp=='True') {
	$.fancybox(
	$("#contact"+id).html(),
			{
        		'autoDimensions'	: false,
			'width'         		: 500,
			'height'        		: 'auto',
			'transitionIn'		: 'none',
			'transitionOut'		: 'none',
			//'href':	'/sites/cityp/layout/he-il/Lightbox_contact.html'
		}
	);
	}
	else {
		$.fancybox(
	$("#contact"+id).html(),
		{
        		'autoDimensions'	: false,
			'width'         		: 500,
			'height'        		: 'auto',
			'transitionIn'		: 'none',
			'transitionOut'		: 'none',
			//'href':	'/sites/cityp/layout/he-il/Lightbox_contact2.html'
		}
	);
	}
return false;
}
function order(id) {
	$.fancybox(
	$("#order"+id).html(),
		{
        		'autoDimensions'	: false,
			'width'         		: 500,
			'height'        		: 'auto',
			'transitionIn'		: 'none',
			'transitionOut'		: 'none',
			// 'href':	'/sites/cityp/layout/he-il/Lightbox_order.html'
		}
	);
		$("#fancybox-wrap .dateselect").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });

return false;
}
function coupon(id) {
	$.fancybox(
	$("#coupon"+id).html(),
		{
        		'autoDimensions'	: false,
			'width'         		: 500,
			'height'        		: 'auto',
			'transitionIn'		: 'none',
			'transitionOut'		: 'none',
			// 'href':	'/sites/cityp/layout/he-il/Lightbox_coupon.html'
		} 
	);
return false;
}

// Waze Maps functions

function putMarker(x,y,n,parkid){
	var markers; 
	for (layername in g_waze_map.map.layers) { 
		//alert(g_waze_map.map.layers[layername].CLASS_NAME);
		if (g_waze_map.map.layers[layername].CLASS_NAME == 'OpenLayers.Layer.Markers') { 
			markers=g_waze_map.map.layers[layername]; 
		} 
	} 
	var size = new OpenLayers.Size(20, 30); 
	var offset = new OpenLayers.Pixel(-(size.w / 2), -size.h); 
	var icon = new OpenLayers.Icon('http://www.villalucia.com/images/parking.gif', size, offset); 
	var marker1 = new OpenLayers.Marker(new OpenLayers.LonLat(x, y), icon.clone()); 
	
	marker1.id = "park"+parkid;
	markers.addMarker(marker1); 
	marker1.events.register("click", marker1, function(marker) { 
		putPopup(x,y,n); 
	}); 
}
	function clearLayer() {
	for (layername in g_waze_map.map.layers) { 
		if (g_waze_map.map.layers[layername].CLASS_NAME == 'OpenLayers.Layer.Markers') { 
			markers=g_waze_map.map.layers[layername]; 
		} 
	} 
	markers.clearMarkers();
}	
function putPopup(x,y,html){

	var popup =new OpenLayers.Popup.FramedCloud("popups",
		new OpenLayers.LonLat(x,y),
 		null,
		html,
		null,
		true,
		function() { popup.destroy(); }
	);

	g_waze_map.map.addPopup(popup); 
} 
	var map,markers;		
function MapInit(){
	map = g_waze_map.map;
	markers = new OpenLayers.Layer.Markers("Markers"); 
	g_waze_map.map.addLayer(markers); 
	if($(".infopage").length)
		parkPage();
};


g_waze_config = {
	div_id:"map",
	locale : "israel",
	center_lon:34.74133,
	center_lat:32.02667,
	zoom:8,
	token:"87f28775-1f6c-4fd7-9239-6ebc9b1e9a72",
	alt_base_layer:"israel_colors",
	alt_map_servers:"http://ymap1.waze.co.il/wms-c/",
	callback:MapInit,
	framed_cloud_image_url:"http://www.waze.co.il/test_api/cloud.png"
	};
			