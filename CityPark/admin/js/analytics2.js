	var vr;
Raphael.fn.drawGrid = function (x, y, w, h, wv, hv, color) {
    color = color || "#000";
    var path = ["M", Math.round(x) + .5, Math.round(y) + .5, "L", Math.round(x + w) + .5, Math.round(y) + .5, Math.round(x + w) + .5, Math.round(y + h) + .5, Math.round(x) + .5, Math.round(y + h) + .5, Math.round(x) + .5, Math.round(y) + .5],
        rowHeight = h / hv,
        columnWidth = w / wv;
    for (var i = 1; i < hv; i++) {
        path = path.concat(["M", Math.round(x) + .5, Math.round(y + i * rowHeight) + .5, "H", Math.round(x + w) + .5]);
    }
    for (i = 1; i < wv; i++) {
        path = path.concat(["M", Math.round(x + i * columnWidth) + .5, Math.round(y) + .5, "V", Math.round(y + h) + .5]);
    }
    return this.path(path.join(",")).attr({stroke: color});
};

Raphael.fn.pieChart = function (cx, cy, r, values, labels, stroke) {
    var paper = this,
        rad = Math.PI / 180,
        chart = this.set();
    function sector(cx, cy, r, startAngle, endAngle, params) {
        var x1 = cx + r * Math.cos(-startAngle * rad),
            x2 = cx + r * Math.cos(-endAngle * rad),
            y1 = cy + r * Math.sin(-startAngle * rad),
            y2 = cy + r * Math.sin(-endAngle * rad);
        return paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"]).attr(params);
    }
    var angle = 0,
        total = 0,
        start = 0,
        process = function (j) {
            var value = values[j],
                angleplus = 360 * value / total,
                popangle = angle + (angleplus / 2),
                color = "hsb(" + start + ", 1, .5)",
                ms = 500,
                delta = 30,
                bcolor = "hsb(" + start + ", 1, 1)",
                p = sector(cx, cy, r, angle, angle + angleplus, {gradient: "90-" + bcolor + "-" + color, stroke: stroke, "stroke-width": 3}),
                txt = paper.text(cx + (r) * Math.cos(-popangle * rad), cy + (r) * Math.sin(-popangle * rad), labels[j]).attr({fill: "#000", stroke: "none", opacity: 0, "font-family": 'Fontin-Sans, Arial', "font-size": "16px;"});
            p.mouseover(function () {
                p.animate({scale: [1.1, 1.1, cx, cy]}, ms, "elastic");
                txt.animate({opacity: 1}, ms, "elastic");
            }).mouseout(function () {
                p.animate({scale: [1, 1, cx, cy]}, ms, "elastic");
                txt.animate({opacity: 0}, ms);
            });
            angle += angleplus;
            chart.push(p);
            chart.push(txt);
            start += .1;
        };
    for (var i = 0, ii = values.length; i < ii; i++) {
        total += values[i];
    }
    for (var i = 0; i < ii; i++) {
        process(i);
    }
    return chart;
};

$(function () {
    $("#data").css({
        position: "absolute",
        left: "-9999em",
        top: "-9999em"
    });
});


$(document).ready(function() {
$(window).load(function() {
$.ajax({
		type: "GET",
		url: "report2.php",
		success: function(jsdata){
		function getAnchors(p1x, p1y, p2x, p2y, p3x, p3y) {
        var l1 = (p2x - p1x) / 2,
            l2 = (p3x - p2x) / 2,
            a = Math.atan((p2x - p1x) / Math.abs(p2y - p1y)),
            b = Math.atan((p3x - p2x) / Math.abs(p2y - p3y));
        a = p1y < p2y ? Math.PI - a : a;
        b = p3y < p2y ? Math.PI - b : b;
        var alpha = Math.PI / 2 - ((a + b) % (Math.PI * 2)) / 2,
            dx1 = l1 * Math.sin(alpha + a),
            dy1 = l1 * Math.cos(alpha + a),
            dx2 = l2 * Math.sin(alpha + b),
            dy2 = l2 * Math.cos(alpha + b);
        return {
            x1: p2x - dx1,
            y1: p2y + dy1,
            x2: p2x + dx2,
            y2: p2y + dy2
        };
    }
	vr = eval("("+jsdata+")");
	
	var	labels = [],
        data = [];
	var pielabels =[],
				piedata=[];
			var sumx = 0;
	$.each(vr.pie, function(i,row){
	sumx += parseInt(row.val);
	});	
if ($.browser.msie) {
//$("#holderpie").html("<table><thead><tr><th>Percent</th><th>Sources</th></tr><tbody></tbody></table>");
    
	$.each(vr.pie, function(i,row){
			$("table#tablepie tbody").append("<tr><td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+(i+1)+"</td><td style='border-bottom:1px dotted #ccc;background:#eee;line-height:25px;'>"+row.name+"</td>"+"<td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+row.val+"</td>"+"<td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+Math.round((row.val*100)/sumx)+"</td></tr>");

		//$("#holderpie table tbody").append("<tr><td>"+((row.val*100)/sumx).toFixed(1)+"</td><td>"+row.name+"</td></tr>");
	});
	}
else 
	{
    $.each(vr.pie, function(i,row){
		piedata.push(Math.round((row.val*100)/sumx));
		pielabels.push(row.name+" "+Math.round((row.val*100)/sumx)+"% ("+row.val+")");
		$("table#tablepie tbody").append("<tr><td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+(i+1)+"</td><td style='border-bottom:1px dotted #ccc;background:#eee;line-height:25px;'>"+row.name+"</td>"+"<td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+row.val+"</td>"+"<td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+Math.round((row.val*100)/sumx)+"</td></tr>");

	});

	Raphael("holderpie", 485, 387).pieChart(100, 100, 100, piedata, pielabels, "#fff");
}

	
  
	//raphael("holderpie", 500, 350).pieChart(200, 200, 100, piedata, pielabels, "#fff");
		
		
    $("#data tfoot th").each(function () {
        labels.push($(this).html());
    });
	
	$.each(vr.visits, function(i,row){
		data.push(row.sum);
	});
		data.reverse();
	


    //$("#data tbody td").each(function () {
        //data.push($(this).html());
    //});
    // Draw
    var width = $(".analytics").width(),
		height = 280,
		leftgutter = 0,
        bottomgutter = 20,
        topgutter = 20,
        colorhue = .6 || Math.random(),
        color = "#00CCFF",
        r = Raphael("holder", width, height),
        txt = {font: '13px Helvetica, Arial', fill: "#000"},
        txt1 = {font: '13px Helvetica, Arial', fill: "#fff"},
        txt2 = {font: '13px Helvetica, Arial', fill: "#000"},
        X = (width - leftgutter) / labels.length,
        max = Math.max.apply(Math, data),
        Y = (height - bottomgutter - topgutter) / max;
		

	
    r.drawGrid(leftgutter + X * .5 + .5, topgutter + .5, width - leftgutter - X, height - topgutter - bottomgutter, 10, 10, "#ddd");
    var path = r.path().attr({stroke: color, "stroke-width": 4, "stroke-linejoin": "round"}),
        bgp = r.path().attr({stroke: "none", opacity: .3, fill: color}),
        label = r.set(),
        is_label_visible = false,
        leave_timer,
        blanket = r.set();
   
	label.push(r.text(60, 12, "24 hits").attr(txt));
    label.push(r.text(60, 27, "22 September 2008").attr(txt1).attr({fill: color}));
    label.hide();
    var frame = r.popup(100, 100, label, "right").attr({fill: "#fff", stroke: "#ddd", "stroke-width": 2, "fill-opacity": .8}).hide();

    var p, bgpp;
    for (var i = 0, ii = labels.length; i < ii; i++) {
        var y = Math.round(height - bottomgutter - Y * data[i]),
            x = Math.round(leftgutter + X * (i + .5)),
            t = "";
        if (!i) {
            p = ["M", x, y, "C", x, y];
            bgpp = ["M", leftgutter + X * .5, height - bottomgutter, "L", x, y, "C", x, y];
        }
        if (i && i < ii - 1) {
            var Y0 = Math.round(height - bottomgutter - Y * data[i - 1]),
                X0 = Math.round(leftgutter + X * (i - .5)),
                Y2 = Math.round(height - bottomgutter - Y * data[i + 1]),
                X2 = Math.round(leftgutter + X * (i + 1.5));
            var a = getAnchors(X0, Y0, x, y, X2, Y2);
            p = p.concat([a.x1, a.y1, x, y, a.x2, a.y2]);
            bgpp = bgpp.concat([a.x1, a.y1, x, y, a.x2, a.y2]);
        }
        var dot = r.circle(x, y, 5).attr({fill: color, stroke: "#000"});
        blanket.push(r.rect(leftgutter + X * i, 0, X, height - bottomgutter).attr({stroke: "none", fill: "#fff", opacity: 0}));
        var rect = blanket[blanket.length - 1];
        (function (x, y, data, lbl, dot) {
            var timer, i = 0;
            rect.hover(function () {
                clearTimeout(leave_timer);
                var side = "right";
                if (x + frame.getBBox().width > width) {
                    side = "left";
                }
                var ppp = r.popup(x, y, label, side, 1);
                frame.show().animate({path: ppp.path}, 200 * is_label_visible);
                label[0].attr({text: data + " hit" + (data == 1 ? "" : "s")}).show().animateWith(frame, {translation: [ppp.dx, ppp.dy]}, 200 * is_label_visible);
                label[1].attr({text: lbl }).show().animateWith(frame, {translation: [ppp.dx, ppp.dy]}, 200 * is_label_visible);
                dot.attr("r", 7);
                is_label_visible = true;
            }, function () {
                dot.attr("r", 5);
                leave_timer = setTimeout(function () {
                    frame.hide();
                    label[0].hide();
                    label[1].hide();
                    is_label_visible = false;
                }, 1);
            });
        })(x, y, data[i], labels[i], dot);
    }
    p = p.concat([x, y, x, y]);
    bgpp = bgpp.concat([x, y, x, y, "L", x, height - bottomgutter, "z"]);
    path.attr({path: p});
    bgp.attr({path: bgpp});
    frame.toFront();
    label[0].toFront();
    label[1].toFront();
    blanket.toFront();
	// map
	
	
	    
	

//tables 
$("#analoading").hide();
$.each(vr.keywords[1].words, function(i,row){
			$("table#topkeywords tbody").append("<tr><td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+(i+1)+"</td><td style='border-bottom:1px dotted #ccc;background:#eee;line-height:25px;'>"+row.word+"</td>"+"<td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+row.val+"</td></tr>");
			//alert("<tr><td>"+row.word+"</td>"+"<td>"+row.val+"</td></tr>");
	});
$.each(vr.pages, function(i,row){
			$("table#toppages tbody").append("<tr><td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+(i+1)+"</td><td style='border-bottom:1px dotted #ccc;background:#eee;line-height:25px;'>"+row.name+"</td>"+"<td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+row.val+"</td></tr>");
			//alert("<tr><td>"+row.word+"</td>"+"<td>"+row.val+"</td></tr>");
	});
	gaChartMapOverlay()
	function gaChartMapOverlay(){
var gaData = new google.visualization.DataTable();
	    gaData.addColumn('string', 'מדינה');
	    gaData.addColumn('number', 'כניסות');
		gaData.addRows(parseInt(vr.map[0].count));
		
		$.each(vr.map[1].countries, function(i,row){
			gaData.setValue(i,0,row.name);
			gaData.setValue(i,1,parseInt(row.val));
			$("table#worldmap tbody").append("<tr><td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+(i+1)+"</td><td style='border-bottom:1px dotted #ccc;background:#eee;line-height:25px;'>"+row.name+"</td>"+"<td style='border-bottom:1px dotted #ccc;background:#eee;text-align:center;line-height:25px;'>"+parseInt(row.val)+"</td></tr>");
			});

	var chartOptions = {};

	chartOptions['dataMode'] = 'regions';
			chartOptions['region'] = 'world';
			var chartMap = new google.visualization.GeoMap(document.getElementById('chartWorldMap'));
		chartMap.draw(gaData,chartOptions);
      }
	}
});
});
});



