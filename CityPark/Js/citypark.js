var ajaxvar,hideTimeout;

$(window).load(function() {
			$(".btn-slide2").click(function(){//advanced search
				$("#panel").slideToggle("slow");
				$(this).toggleClass("active2"); return false;
			});

			$("._date").datepicker({ dateFormat: 'dd/mm/yy', isRTL: false });

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
				$("#searchtext").keyup(function(e) {
				lastKeyPressCode = e.keyCode;
		switch(e.keyCode) {
			case 38: // up
				e.preventDefault();
				moveSelect(-1);
				break;
			case 40: // down
				e.preventDefault();
				moveSelect(1);
				break;
			case 9:  // tab
			case 13: // return
				$("#ac span.active").click();
				return false;
				break;  
			default:
					 
					if ($("#searchtext").val().length > 1) {
						if (ajaxvar)ajaxvar.abort();
						var str = $("#searchtext").val().replace(","," ").split(" ");
						var city = str[0];
						var housenum = (str.length>0)?(isnum(str[1])?str[1]:0):0;
						var city = (str.length>1)?str[2]:0;
						ajaxvar = $.ajax({
							type: 'POST',
							url: "parkcore.asp",
							// data: {m:"ac",search:$("#searchtext").val()},
							data: {m:"ac",city:city,housenum:housenum,city:city},
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
									acover();
								
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
					break;
					}
				}).blur(function() { 	
					clearTimeout(hideTimeout);
					//hideTimeout = setTimeout('$("#ac").empty().hide()',1000);
					}
				);
				
				
				
				//onInit();
				initOptions();
				MapInit();
}); //document ready
function isnum(val){return(parseFloat(val,10)==(val*1)
function moveSelect(m) {
switch (m) {
	case 1:
		if ($("#ac span.active").length>0 && ($("#ac span.active").nextAll("span:visible:first").length>0)) 
		{
			//
			n = $("#ac span.active").nextAll("span:first"); // save the next span to var
			$("#ac span").removeClass("active"); //remove all active class from all spans
			$(n).addClass("active"); // add active class to n
		} else {
		$("#ac span").removeClass("active");
		$("#ac span:eq(0)").addClass("active"); //if nothing selected. or no mouse over then select the first span.
		$('#ac').animate({scrollTop: $("#ac span.active").offset().top}, 100);
		}
		break;
	case -1:
		if ($("#ac span.active").length>0 && ($("#ac span.active").prevAll("span:visible:first").length>0)) 
		{
		//	
			n =$("#ac span.active").prevAll("span:first");
			$("#ac span").removeClass("active");
			$(n).addClass("active");
		} else
		 {
		 $("#ac span").removeClass("active");
		 $("#ac span:last-child").addClass("active");
		 $('#ac').animate({scrollTop: $("#ac span.active").offset().top}, 100);
		 }
		break;
	}

}
function acover () {
$("#ac span").mouseover( function() {
				//alert("a");
				$("#ac span").removeClass("active");
				$(this).addClass("active");
				});
}
function createrestulsdiv(res) {
	$(".text .intext").load("/sites/cityp/layout/he-il/park_search.html?rnd=" + String((new Date()).getTime()).replace(/\D/gi, '')	,function() {
	//map.render("map");
	//alert("rendered");
	//if (!rendered) 
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
/*
$(".options a, table.icons a").each(function() {
if ($(this).attr("rel")!='1') {
	$(this).find('img').attr('src',$(this).find('img').attr('src').split(".")[0]+"1.gif")
	$(this).attr("href","");
	}
	$(this).show();
});*/
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
//clearLayer();
var parkName,pid,latitude,longitude,lat_total=0,long_total=0,c,temp;
	$("#results .parkme").each(function(i,p) {
		pid = $(this).attr("id").replace("park","");
		latitude = parseFloat($(this).find("div.info").text().split(",")[0]);
		longitude = parseFloat($(this).find("div.info").text().split(",")[1]);
		parkName = $(this).find("div.info").text().split(",")[2];
		// lat_total = lat_total + latitude;
		// long_total = long_total + longitude;
		lat_total = latitude;
		long_total = longitude;
		putMarker(longitude,latitude,parkName,pid);
		c = i;
		});
	//console.log(lat_total,long_total,c);
	//	long_total = long_total/(c+1);
	//	lat_total = lat_total/(c+1);
	//	console.log(lat_total,long_total);
		map.setCenter(new CM.LatLng(lat_total, long_total), 15);
	//	map.setCenter(new OpenLayers.LonLat(long_total,lat_total),9);
}

function parkPage() {
//clearLayer();
var parkName,pid,latitude,longitude,lat_total=0,long_total=0,c,temp;
		that = $(".infopage");
		pid = $(that).attr("id").replace("i","");
		latitude = parseFloat($(that).text().split(",")[0]);
		longitude = parseFloat($(that).text().split(",")[1]);
		parkName = $(that).text().split(",")[2];
		putMarker(longitude,latitude,parkName,pid);
		map.setCenter(new CM.LatLng(latitude, longitude), 19);

	//	map.setCenter(new OpenLayers.LonLat(longitude,latitude),10);
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
	return false;
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
	validfancy($("#fancybox-wrap form"));
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
		validfancy($("#fancybox-wrap form"));

return false;
}
  var fancyrules = {
            selectone: {
                required: function (element) {
                    // alert($(element).val() + "  != " + 0);
                    return $(element).val() != 0;
                }
            }
        };
function validfancy(f) {
 jQuery(f).validate({
		
            rules: fancyrules,
            submitHandler: function (form) {

                var p = $(form);

                var c = true;

                p.find(":text").each(function () {
                    if ($(this).hasClass("e"))
                        c = false;
                });

                if (c == false)
                    return false;

                //alert(p.attr("action")  + p.serialize());

                jQuery.ajax({
                    type: jQuery(form).attr('method'),
                    url: p.attr('action'),
                    data: p.serialize(),
                    success: function (html) {
                        p.parent().html(html);
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert(XMLHttpRequest.responseText);
                    }
                });

                return false;
            }
        });
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

var myMarkerLatLng = new CM.LatLng(y,x);
	var myMarker = new CM.Marker(myMarkerLatLng, {
			title:n
		});
	map.setCenter(myMarkerLatLng, 17);
	map.addOverlay(myMarker);

//	var markers; 
	// for (layername in map.layers) { 
		// //alert(map.layers[layername].CLASS_NAME);
		// if (map.layers[layername].CLASS_NAME == 'OpenLayers.Layer.Markers') { 
			// markers=map.layers[layername]; 
		// } 
	// } 
	// var size = new OpenLayers.Size(20, 30); 
	// var offset = new OpenLayers.Pixel(-(size.w / 2), -size.h); 
	// var icon = new OpenLayers.Icon('http://www.villalucia.com/images/parking.gif', size, offset); 
	// var marker1 = new OpenLayers.Marker(new OpenLayers.LonLat(x, y), icon.clone()); 
	
	// marker1.id = "park"+parkid;
	// markers.addMarker(marker1); 
	// marker1.events.register("click", marker1, function(marker) { 
		// putPopup(x,y,n); 
	// }); 
	
}
	// function clearLayer() {
	// for (layername in map.layers) { 
		// if (map.layers[layername].CLASS_NAME == 'OpenLayers.Layer.Markers') { 
			// markers=map.layers[layername]; 
		// } 
	// } 
	// markers.clearMarkers();
// }	
function putPopup(x,y,html){

	var popup =new OpenLayers.Popup.FramedCloud("popups",
		new OpenLayers.LonLat(x,y),
 		null,
		html,
		null,
		true,
		function() { popup.destroy(); }
	);

	map.addPopup(popup); 
} 
	var map,markers;		
// function MapInit(){
	// map = map;
	// markers = new OpenLayers.Layer.Markers("Markers"); 
	// map.addLayer(markers); 
	// if($(".infopage").length)
		// parkPage();
// };
var rendered = false;
function MapInit() {
if ($("#map").length) {
	rendered = true;
	//var mapnik = new CM.Tiles.OpenStreetMap.Mapnik();
	var mapnik = new CM.Tiles.CloudMade.Web({key: '27c7fb1e0df44dc9bc0dcd4f515a0247'});
	map = new CM.Map('map', mapnik);   
    map.setCenter(new CM.LatLng(32.059925, 34.785126), 8);
	map.addControl(new CM.SmallMapControl());
	map.addControl(new CM.ScaleControl());
	//map.addControl(new CM.OverviewMapControl());
	if($(".infopage").length)
		parkPage();
	
	}
	}
	
		function changetype(e,i) {
			ajaxvar = $.ajax({
						type: 'POST',
						url: "parkcore.asp",
						data: {id:i,type:$(e).val(),m:"attr"},
						success: function(data) {
							
						$("#attraction").html(data);

							
						},
						beforeSend:function() {
						$("#loader").show();
						},
						complete:function() {
						$("#loader").hide();
						}
						
					});
		
	}
// g_waze_config = {
	// div_id:"map",
	// locale : "israel",
	// center_lon:34.74133,
	// center_lat:32.02667,
	// zoom:8,
	// token:"87f28775-1f6c-4fd7-9239-6ebc9b1e9a72",
	// alt_base_layer:"israel_colors",
	// alt_map_servers:"http://ymap1.waze.co.il/wms-c/",
	// callback:MapInit,
	// framed_cloud_image_url:"http://www.waze.co.il/test_api/cloud.png"
	// };
			