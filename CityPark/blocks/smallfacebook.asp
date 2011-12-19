 <!--#include file="../config.asp"-->

<div id="fblogin" class="fblogin" style="display:none"><fb:login-button size="medium" background="white" length="long"  ></fb:login-button></div>
				<script type="text/javascript">  
	var notconnected =true;
		function onConnected(user_id) {
			var viewer  = FB.Facebook.apiClient.fql_query(  
				'SELECT uid,name ,first_name,last_name,  pic_square,profile_url,email FROM user WHERE uid='+FB.Facebook.apiClient.get_session().uid,  
				function(results) {  

					update_userbox( 
					     results[0].name,  
                         results[0].pic_square,  
                         results[0].profile_url,  
						 results[0].uid	 );
						 
						 
					$.ajax({
						type: 'POST',
						url: "/fbapi.asp",  
						data: { 
							name:  results[0].name, 
							fname:  results[0].first_name, 
							lname:  results[0].last_name, 
							pic:  results[0].pic_square, 
							fbid:results[0].uid	,
							email:results[0].email	,
							mode: "fbc"},
						success: function(data) {
							logmein();
							$("#fblogin").hide();
						}
					});
				}
			);
		}  
		
		function logmein() {
		$.ajax({
			type: 'POST',
			url: "/fbapi.asp",  
			data: { fbid:FB.Facebook.apiClient.get_session().uid	,mode: "lmi"},
			success: function(data) {
			$(".enter").hide();
				$("#knisa").css("backgroundImage","url(/sites/sale/layout/he-IL/images/connected.gif)");
			}
		});
		}
		
			function logmeout() {
		$.ajax({
			type: 'POST',
			url: "/fbapi.asp",  
			data: { fbid:FB.Facebook.apiClient.get_session().uid	,mode: "lmo"},
			success: function(data) {
				
			}
		});
		}
		
		function fb_logout() {
		 $("#fblogin").show();
		 $("#userbox").hide();
  			FB.Connect.logout();
			logmeout();
			//$("#knisa").css("backgroundImage","url(/sites/sale/layout/he-IL/images/login.gif)")
			//.prepend('<div class="enter">של1ום אורח, <a href="/user/login.asp?t=login">התחבר !</a></div>');
			//console.log("logout");

		}
		
		function onNotConnected() { 
			 notconnected = true;
			 $("#fblogin").show();
			 $("#userbox").hide();
		} 
		   
 function update_userbox(name, image, url,uid) {  
   
   $('#userbox').html( "<a target='_blank' href='"+url+"'>"  
                     + "<img alt='"+name+"' src='"+image+"' /><p>"  
                     + "מחובר כ " + name + "</p></a> "  
                     + "<span style='cursor:pointer;' onclick='fb_logout();return false;'>(התנתק)</span>" ).show(); 
				 
   }  
      FB_RequireFeatures(['XFBML', 'Connect'], function() {
            FB.Facebook.init('<%=getConfig("ApplicationID")%>', '/xd_receiver.htm', { 
				permsToRequestOnConnect: 'email' , 
				"ifUserConnected":onConnected,		
				"ifUserNotConnected":onNotConnected
			});
        });
		
		</script>
		<div id="userbox"></div>