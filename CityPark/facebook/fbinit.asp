<!--#include file= "../config.asp"-->
 FB_RequireFeatures(['XFBML', 'Connect'], function() {
            FB.Facebook.init('<%=getConfig("ApplicationID")%>', '/xd_receiver.htm', { 
				permsToRequestOnConnect: 'email' 
			});
        });