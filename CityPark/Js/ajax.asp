<% 
Response.ContentType = "text/javascript"
%>
jQuery(function ($) {

    function star(object, starsCount, input, callback, readOnly, average) {

        var stars = [];
        var current = 0;

        if (average) {
            current = average;

            if (input != null)
                input.val(average);
        }
        for (var x = 1; x <= starsCount; x++) {
            stars[x] =
				$("<img></img>")
					.data("index", x)
					.attr("src", average && x <= average ? "/<%= Session("SiteFiles") %>/staron.png" : "/<%= Session("SiteFiles") %>/staroff.png")
					.hover(function () {
					    if (!readOnly) {
					        $(this).css("cursor", "pointer");

					        for (var y = 1; y <= starsCount; y++) {
					            off(stars[y]);
					        }

					        for (var y = 1; y <= $(this).data("index"); y++) {
					            on(stars[y]);
					        }
					    }
					}, function () {
					    if (!readOnly) {
					        $(this).css("cursor", "default");

					        for (var y = 1; y <= $(this).data("index"); y++) {
					            off(stars[y]);
					        }

					        if (current > 0) {
					            for (var y = 1; y <= current; y++) {
					                on(stars[y]);
					            }
					        }
					    }
					})
					.click(function () {
					    if (!readOnly) {
					        current = $(this).data("index");

					        for (var y = 1; y <= current; y++) {
					            on(stars[y]);
					        }

					        if (input != null)
					            input.val(current);

					        if (callback != null)
					            callback(current);
					    }
					})
					.appendTo(object);
        }

        function on(star) {
            star.attr("src", "/<%= Session("SiteFiles") %>/staron.png");
            return star;
        }

        function off(star) {
            star.attr("src", "/<%= Session("SiteFiles") %>/staroff.png");
            return star;
        }
    }

    $(document).ready(function () {
        $("._rating").each(function () {
            var data = $(this).mmetadata({ type: 'elem', name: 'script' });

            star($(this), data.starsCount, data.input != null ? $("#" + data.input) : null, $.inArray("Ajax", data.mode) > -1 ? function (stars) {
                $.post("/SubmitRating.asp?TableName=" + data.tableName + "&EntityID=" + data.entityId, { Rating: stars });
            } : null, $.inArray("ReadOnly", data.mode) > -1, $.inArray("ShowAverage", data.mode) > -1 ? data.average : false);
        });

		
        var nullText = "^"

        $(".inlinetext").each(function () {
            if ($(this).text() == "")
                $(this).text(nullText)
        }).dblclick(function () {
            var p = $(this).hide();

            $(this).parent().append($("<input type=\"text\"></input>")
				.val($(this).text() == nullText ? "" : $(this).text())
				.blur(function () {


				    var isValueEmpty = ($(this).val().replace(/^\s\s*/, '').replace(/\s\s*$/, '') == "") | ($(this).val() == nullText);

				    $.post(document.URL + "?inline=true&id=" + p.attr("id") + "&value="
						+ (isValueEmpty ? "" : escape($(this).val())));

				    p.text(isValueEmpty ? nullText : $(this).val()).show();

				    $(this).remove();
				})
			).find(":text").focus();

        });

        var r = {
            selectone: {
                required: function (element) {
                    // alert($(element).val() + "  != " + 0);
                    return $(element).val() != 0;
                }
            }
        };
    
    jQuery.validator.addClassRules("selectone", { required: true });

        $("._dialog").click(function() {
            $("<div></div>")
                .load($(this).attr("href"))
                .appendTo("body")
                .dialog($(this).mmetadata())
  
            return false;
        });

        jQuery('._validate').each(function() { $(this).validate({
            rules: r
        })});

        jQuery('._ajax_form').validate({
		
            rules: r,
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
		
		//alert("Abc");
    });


	});

function formTextCounter(field, countfield, maxlimit) {
    if (field.value.length > maxlimit)
        field.value = field.value.substring(0, maxlimit);
    else
        countfield.value = maxlimit - field.value.length;
}

function EnableAjax(son, field) {

    jQuery(function ($) {
        //alert("Abc");
        $.get('/ajax_combo.asp?son=' + son + '&field=' + field + '&value=' + $("#" + field).val(), function (data, textStatus) {
            $("#" + son).empty();

            var options = data.split(';');

            for (var i = 0; i < options.length; i++) {
                var keyValue = options[i].split(',');

                var option = $("<option></option>")
                    .val(keyValue[0])
                    .text(keyValue[1]);

                if (keyValue[0] == querySt("son"))
                    option.attr("selected", "selected");

                $("#" + son).append(option);

            }
        });
    });
}

function EnableAjaxB(son, field, q) {
    jQuery(function ($) {
        //alert("Abc");
        $.get('/ajax_combo.asp?son=' + son + '&field=' + field + '&value=' + $("#" + field).val(), function (data, textStatus) {
            $("#" + son).empty();

            var options = data.split(';');

            for (var i = 0; i < options.length; i++) {
                var keyValue = options[i].split(',');

                var option = $("<option></option>")
                    .val(keyValue[0])
                    .text(keyValue[1]);

                if (keyValue[0] == q)
                    option.attr("selected", "selected");

                $("#" + son).append(option);

            }
        });
    });
}

function querySt(ji) {
    hu = window.location.search.substring(1);
    gy = hu.split("&");
    for (i = 0; i < gy.length; i++) {
        ft = gy[i].split("=");
        if (ft[0].toLowerCase() == ji.toLowerCase()) {
            return ft[1];
        }
    }
}

function formTextCounter(field, countfield, maxlimit) {
    if (field.value.length > maxlimit)
        field.value = field.value.substring(0, maxlimit);
    else
        countfield.value = maxlimit - field.value.length;
}

function validatePoll(oform) {

    var isChecked = false;

    for (i = 0; i < oform.optiontoselect.length; i++) {
        if (oform.optiontoselect[i].checked) {
            isChecked = true;
            break;
        }
    }

    return isChecked;
}

function AjaxUpload(objectName, type, typeAllowed, folder) {
    window.open('upload.asp?typeAllowed=' + typeAllowed + '&object=' + objectName + '&folder=' + folder + '&type=' + type, "fileUploadWindow", "status = 1, height = 300, width = 300, resizable = 0");
}

function SetFile(objectName, filePath, fileType) {

    if (fileType == "jpg" | fileType == "jpeg")
        jQuery('#_' + objectName).attr('src', 'resize.asp?mappath=true&width=80&path=' + filePath);
    else if (fileType == "gif" | fileType == "png")
        jQuery('#_' + objectName).attr('src', filePath);
    else
        jQuery('#_' + objectName).attr('src', "/images/icons/" + fileType + ".gif");

    jQuery("#v" + objectName+",#" + objectName).val(filePath);
    jQuery("#upload_button_" + objectName).val("שנה קובץ");
}

function getFromArray(arr, n) {
    return arr[n];
}

returnMoney = function (number) {
    var nStr = '' + Math.round(parseFloat(number) * 100) / 100;
    var x = nStr.split('.');
    var x1 = x[0];
    var x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
};

//* jquery accordion menu */
jQuery.fn.initMenu = function () {
    return this.each(function () {
        var theMenu = $(this).get(0);
        $('.acitem', this).hide();
        $('li.expand > .acitem', this).show();
        $('li.expand > .acitem', this).prev().addClass('active');
        $('li a', this).click(
            function (e) {
                e.stopImmediatePropagation();
                var theElement = $(this).next();
                var parent = this.parentNode.parentNode;
                if ($(parent).hasClass('noaccordion')) {
                    if (theElement[0] === undefined) {
                        window.location.href = this.href;
                    }
                    $(theElement).slideToggle('normal', function () {
                        if ($(this).is(':visible')) {
                            $(this).prev().addClass('active');
                        }
                        else {
                            $(this).prev().removeClass('active');
                        }
                    });
                    return false;
                }
                else {
                    if (theElement.hasClass('acitem') && theElement.is(':visible')) {
                        if ($(parent).hasClass('collapsible')) {
                            $('.acitem:visible', parent).first().slideUp('normal',
                            function () {
                                $(this).prev().removeClass('active');
                            }
                        );
                            return false;
                        }
                        return false;
                    }
                    if (theElement.hasClass('acitem') && !theElement.is(':visible')) {
                        $('.acitem:visible', parent).first().slideUp('normal', function () {
                            $(this).prev().removeClass('active');
                        });
                        theElement.slideDown('normal', function () {
                            $(this).prev().addClass('active');
                        });
                        return false;
                    }
                }
            }
    );
    });
};


//* End jquery accordion menu */
