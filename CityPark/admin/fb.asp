<div id="fblogin" ><span class="fb" onclick="FB.Connect.requireSession();">התחבר/י עם פייסבוק</span><br /><fb:login-button size="medium" background="white" length="long" onlogin="onConnected()" ></fb:login-button></div>
				<script type="text/javascript">  
	
		function onConnected(user_id) { 
			alert("התחברות");

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
							alert("updated");
						}
					});
				}
			);
			
		}  
		
		function fb_logout() {
	alert("התנתקות");
		 
  			FB.Connect.logout();


		}
		
		function onNotConnected() { 
	alert("לא מחובר");			
		} 
		   
 function update_userbox(name, image, url,uid) {  
   
   $('#userbox').html( "<a target='_blank' href='"+url+"'>"  
                     + "<img alt='"+name+"' src='"+image+"' />"  
                     + "מחובר כ " + name + "</a> "  
                     + "(<span class='link' onclick='fb_logout();return false;'>התנתק</span>)" ).show(); 
				 
   }  
      FB_RequireFeatures(['XFBML', 'Connect'], function() {
            FB.Facebook.init('<%=getConfig("APIKey")%>', 'xd_receiver.htm', { 
				permsToRequestOnConnect: 'email' , 
				"ifUserConnected":onConnected,		
				"ifUserNotConnected":onNotConnected
			});
        });
		//FB.init('<%=getConfig("APIKey")%>', "xd_receiver.htm", {permsToRequestOnConnect : "email"},
		//{"ifUserConnected":onConnected,
		//"ifUserNotConnected":onNotConnected}); 
		</script>
		<div id="userbox">טוען...</div>