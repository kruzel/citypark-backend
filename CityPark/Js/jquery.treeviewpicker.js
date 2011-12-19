jQuery.treeviewpicker = function(input, results, options) {
	// Create a link to self
	var me = this;

	// Create jQuery object for input element
	var $input = $(input).attr("treeviewpicker", "off");

	// Apply inputClass if necessary
	if (options.inputClass) $input.addClass(options.inputClass);

	// Create jQuery object for results
	var $results = $(results);
	$results.hide().addClass(options.resultsClass).css("position", "absolute");
	if (options.width > 0)
		$results.css("width", options.width);

	input.treeviewpicker = me;

	var timeout = null;
	var cache = {};
	var keyb = false;
	var hasFocus = false;
	var IsHover = false;
	var lastKeyPressCode = null;

	$input.keydown(function(e) {
		// track last key pressed
		lastKeyPressCode = e.keyCode;
		switch (e.keyCode) {
			case 38: // up
				e.preventDefault();
				onChange()
				break;
			case 40: // down
				e.preventDefault();
				onChange()
				break;
			case 9:  // tab
			default:
				onChange()
				break;
		}
	})
	.click(function() {
		hasFocus = true;
		onChange();
	})
	.focus(function() {
		// track whether the field has focus, we shouldn't process any results if the field no longer has focus
		hasFocus = true;
	})
	.blur(function(e) {
		if (!IsHover) {
			// track whether the field has focus
			hasFocus = false;
			hideResults();
		}
	});

	$results
	.click(function(e) {
		var $obj = $(e.target);
		if (!!$obj) {
			$results.find("li>span.selected").removeClass("selected");
			var $parent = $obj.parent("li");
			$parent.find(">span").addClass("selected")
		}
	})
	.hover(
		function() {
			IsHover = true;
		},
		function() {
			hasFocus = false;
			IsHover = false;
			hideResults();
		})
	.dblclick(function(e) {
		var $obj = $(e.target);
		if (!!$obj) {
			var $parent = $obj.parent("li");
			var span = $parent.find(">span").get(0);
			if (!!span) {
				var value = span.innerHTML;
				var code = $(span).attr("code");
				$input.val(value);
				if (options.onItemSelect) {
					options.onItemSelect(code);
				}
				hideResults();
				$input.change();
			}
		}
	})
	.blur(function() {
		hasFocus = false;
		hideResults();
	});

	function onChange() {
		// ignore if the following keys are pressed: [del] [shift] [capslock]
		if (lastKeyPressCode == 46 || (lastKeyPressCode > 8 && lastKeyPressCode < 32))
			return $results.hide();
		var v = $input.val();
		showResults();
	};

	function showResults() {
		// get the position of the input field right now (in case the DOM is shifted)
		var pos = findPos(input);
		// either use the specified width, or autocalculate based on form element
		var iWidth = (options.width > 0) ? options.width : $input.width();
		// reposition
		$results.css({
			width: parseInt(iWidth) + "px",
			top: (pos.y + input.offsetHeight) + "px",
			left: pos.x + "px"
		}).show();
	};

	function hideResults() {
		if ($results.is(":visible")) {
			$results.hide();
		}
	};

	this.setExtraParams = function(p) {
		options.extraParams = p;
	};

	function findPos(obj) {
		var curleft = obj.offsetLeft || 0;
		var curtop = obj.offsetTop || 0;
		while (obj = obj.offsetParent) {
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
		}
		return { x: curleft, y: curtop };
	}
}
jQuery.fn.treeviewpicker = function(results, options) {
	// Make sure options exists
	options = options || {};
	// Set default values for required options
	options.inputClass = options.inputClass || "tv_input";
	options.resultsClass = options.resultsClass || "tv_results";
	options.lineSeparator = options.lineSeparator || "\n";
	options.cellSeparator = options.cellSeparator || "|";
	options.extraParams = options.extraParams || {};
	options.width = parseInt(options.width, 10) || 0;

	this.each(function() {
		var input = this;
		new jQuery.treeviewpicker(input, results, options);
	});

	// Don't break the chain
	return this;
}
jQuery.fn.indexOf = function(e) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == e) return i;
	}
	return -1;
};