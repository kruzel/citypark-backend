/*
	jQuery One Show Hide v1.0 - http://www.onerutter.com/oneshowhide
	Copyright (c) 2010 Jake Rutter
	This plugin available for use in all personal or commercial projects under both MIT and GPL licenses.
*/

(function($){  
    $.fn.extend({
        oneShowHide: function(options) {  
        
            //Set the default values, use comma to separate the settings 
            var defaults = {  
                numShown: 10,  
                showText : 'Show More Links',  
                hideText : 'Hide Links'  
            }  
            
            var options =  $.extend(defaults, options);  
                        
            return this.each(function() {  
                var o = options;  
                var obj = $(this);

                // Determine the length of items here and calculate the number hidden
                var pLength = obj.children().length;
                var numHidden = pLength - o.numShown;
                var pList = obj.children();
                
                // Setup Show/Hide Link
                var shLink = "<a href='#' class='view'>" + o.showText + "</a>";
                
                if (pLength > o.numShown) {
                    jQuery(shLink).insertBefore(obj); 
                }
                
                pList.each(function(index){
				    if (index < o.numShown) {
				        //alert('test');
				        jQuery(pList[index]).show(); 
				    }		
				    else {
				        jQuery(pList[index]).hide();
                        jQuery(pList[index]).addClass('hidden');
				    }    
				});

                
                // This is where I toggle the text
                jQuery("a.view").live("click", function(e){
    
                    if (jQuery(this).text()==o.showText) {
                    jQuery(this).text(o.hideText);
                }
                else {
                    jQuery(this).text(o.showText);
                }
                    jQuery('.hidden').toggle();
                    return false;
               });                
              
            });  
        } 
    }); 
})(jQuery);