<!--#include file="../config.asp"-->
<% 

Response.ContentType = "text/javascript"  

If Request.QueryString("ID") = "" Then
    If Request.QueryString("p") = "" Then
        m_ID = Session(SiteID & "HomeQSID")
    Else
        Set objRs = OpenDB("SELECT id FROM [Content] WHERE UrlText = '" & Trim(Replace(Request.QueryString("p"),"-"," ")) & "' And SiteID = " & SiteID )
        
        m_ID = objRs("id")
        
        CloseDB(objRS)
    End If
Else
    m_ID = Request.QueryString("ID")
End If 

%>

(function($) {
    jQuery.fn.vscontext = function(options) {
        var defaults = {
            menuBlock: null,
            offsetX: 8,
            offsetY: 8,
            speed: 'fast'
        };
        var options = $.extend(defaults, options);

        return this.each(function() {
            $(this).bind("contextmenu", function(e) {
                return false;
            });
            $(this).mousedown(function(e) {
                var offsetX = e.pageX + options.offsetX;
                var offsetY = e.pageY + options.offsetY;
                if (e.button == "2") {

                    options.menuBlock.show(options.speed);
                    options.menuBlock.css('display', 'block');
                    options.menuBlock.css('top', offsetY);
                    options.menuBlock.css('left', offsetX);
                } else {
                    options.menuBlock.hide(options.speed);
                }
            });
            options.menuBlock.hover(function() { }, function() { options.menuBlock.hide(options.speed); })

        });
    };

    $(document).ready(function() {
        $('._content').vscontext({
            menuBlock: $("<div></div>")
                .addClass("vs-context-menu")
                .append($("<ul></ul>")
	                .append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin_content_local_edit.asp?ID=<% = m_ID %>").text("עריכת דף זה")))
                    .append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/admin_content.asp?action=edit&ID=<% = m_ID %>").text("הגדרות עמוד")))
                    .append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/admin_content.asp?action=copy&ID=<% = m_ID %>").text("שכפל עמוד")))
                    .append($("<li></li>").addClass("seprator").addClass("cut").append($("<a></a>").attr("href", "admin/admin_content.asp?action=add").text("הוספת עמוד")))
					.append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/admin_menu.asp?action=add").text("הוספת כפתור")))
                    .append($("<li></li>").addClass("seprator").addClass("cut").append($("<a></a>").attr("href", "admin/admin_menu.asp").text("ניהול כפתורים")))
                    .append($("<li></li>").addClass("seprator").addClass("cut").append($("<a></a>").attr("href", "admin/admin_site.asp?action=edit&ID=<% = SiteID %>").text("הגדרות אתר כלליות")))
					.append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "http://82.80.235.16/app/forms.asp?mode=add&formid=111&s=143").text("פנה לתמיכה")))								
					.append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/default.asp?mode=logout").text("התנתק")))							
                 ).appendTo("body")
        });
		
        $('._menu').vscontext({
            menuBlock: $("<div></div>")
                .addClass("vs-context-menu")
                .append($("<ul></ul>")
					.append($("<li></li>").addClass("cut").addClass("seprator").append($("<a></a>").attr("href", "admin/admin_menu.asp?action=add").text("הוספת כפתור")))
                    .append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/admin_menu.asp").text("ניהול כפתורים")))							
                ).appendTo("body")
        });		
        $('._news').vscontext({
            menuBlock: $("<div></div>")
                .addClass("vs-context-menu")
                .append($("<ul></ul>")
					.append($("<li></li>").addClass("cut").addClass("seprator").append($("<a></a>").attr("href", "admin/admin_news.asp?action=add").text("הוספת חדשות")))
                    .append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/admin_news.asp").text("ניהול חדשות")))							
                ).appendTo("body")
        });		
        $('._poll').vscontext({
            menuBlock: $("<div></div>")
                .addClass("vs-context-menu")
                .append($("<ul></ul>")
                    .append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/poll.asp").text("ניהול סקרים")))							
                ).appendTo("body")
        });		
        $('._block').vscontext({
            menuBlock: $("<div></div>")
                .addClass("vs-context-menu")
                .append($("<ul></ul>")
                    .append($("<li></li>").addClass("cut").append($("<a></a>").attr("href", "admin/admin_block.asp").text("ניהול בלוקים")))							
                ).appendTo("body")
        });		
		
    });
})(jQuery);
