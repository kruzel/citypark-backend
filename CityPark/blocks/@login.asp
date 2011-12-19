<!--#include file="../config.asp"-->
<form action="/user/login.asp?mode=LetMeIn" method="post" class="_validate">
    
    <table align="center" >
		<tr>
<% If Request.Cookies(SiteID & "LoginName") = "" Then text = "התחברות מאובטחת" Else text ="החשבון שלי" End if %>
			<td id="login-secure" colspan="2"><%=text%></td>
		</tr>
<% If Request.Cookies(SiteID & "LoginName") = "" Then %>
		<tr>
			<td id="login-user">שם משתמש:</td>			
			<td><input type="text" dir="ltr"  name="LoginName" class="required"></td>	
		</tr>
		
		<tr>
			<td id="login-password">סיסמא:</td>
			<td><input type="password" dir="ltr" name="Password"></font></td>
		</tr>
		</tr>
        <tr>
            <td colspan="2">
<!--fb1-->
<script type="text/javascript">
    window.fbAsyncInit = function () {
        FB.init({ appId: '4d844ddbadfc1b925158ada87d26b537', status: true, cookie: true, xfbml: true });
    };
    (function () {
        var e = document.createElement('script');
        e.type = 'text/javascript';
        e.src = document.location.protocol +
            '//connect.facebook.net/en_US/all.js';
        e.async = true;
        document.getElementById('fb-root').appendChild(e);
    } ());

</script>






<!--fb1-->

<fb:profile-pic uid="loggedinuser" size="square" facebook-logo="true"></fb:profile-pic>
<fb:name uid="loggedinuser" useyou="false" linked="false"></fb:name>
<fb:login-button autologoutlink="true" perms="email,name,user_birthday,status_update,publish_stream"></fb:login-button>
<div id="me"></div>

<script>
    var 
  div = document.getElementById('me'),
  showMe = function (response) {
      if (!response.session) {
          div.innerHTML = '<em>Not Connected</em>';
      } else {
          FB.api('/me', function (response) {
              var html = '<table>';
              for (var key in response) {
                  html += (
            '<tr>' +
              '<th>' + key + '</th>' +
              '<td>' + response[key] + '</td>' +
            '</tr>'
          );
              }
              div.innerHTML = html;
          });
      }
  };
    FB.getLoginStatus(function (response) {
        showMe(response);
        FB.Event.subscribe('auth.sessionChange', showMe);
    });
</script>
               <script type="text/javascript">
                   FB.init("4d844ddbadfc1b925158ada87d26b537", "xd_receiver.htm");  
               </script>  

        </td>
        </tr>
		<tr>
			<td align="right"><a href="/user/login.asp">הירשם</a></td>
			<td id="login-connect"  align="left"><input type="submit" value="התחבר"></td>
<% Else %>
<td><div id="login-message">שלום לך <% = Request.Cookies(SiteID & "LoginName") %>, <a href="/user/login.asp?mode=logout">התנתק</a>.</div></td>
<% End If %>	
	</table>
</form>
