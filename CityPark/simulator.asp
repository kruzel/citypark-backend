<!--#include file="config.asp"-->

<%header%>
<script language="JavaScript">



<!-- Begin
var alutHanayaTosavHoutzTime;
var alutDelek;
var alutBluy;
var zmanMesuarHanayaMyadit;

var answers = new Array(7);

// Insert answers to questions

answers[0] = "בחר עיר";

answers[1] = "בחר איזור בעיר";

answers[2] = "בחר קבוצת רישוי";

answers[3] = "בחר קבוצת רכב";

answers[4] = "בחר שעת החניה";

answers[5] = "בחר זמן חניה משוער";

answers[6] = "בחר ממוצע סיורי פקחים ברחוב בשעה";



function hasChecked(radGroup){

  var len=radGroup.length;

  for (var i=0; i<len; i++){

     if (radGroup[i].checked) return radGroup[i].value;

  }

}





// Do not change anything below here ...

function getScore(form) {  

	var inputs = document.getElementsByTagName("input");

	var j=0;

	for (var i=0; i < inputs.length; i++) {

		if (inputs[i].getAttribute('type') == 'radio') {

		if (inputs[i].checked){

			answers[j]= inputs[i].getAttribute('value');

			j++;

			}

		}

	}

  

	var correctAnswers = ""; 
		                                             

	zmanMesuarHanayaMyadit =(Math.ceil((2+(1.48*1*(answers[1]*answers[4])))));

	var HistabrutHanaya=Math.round(100*(Math.abs(1-(answers[1]*answers[4]))))

	var SetachHanaya=(answers[3])

	alutDelek=Math.round(100*(7.05*0.25*zmanMesuarHanayaMyadit/9.5))/100

	alutBluy =Math.round(100*(zmanMesuarHanayaMyadit * 0.25 *2.016))/100

	alutHanayaTosavHoutzTime=Math.round(100*(answers[0]*answers[5]))/100;

	var alutKolelet=Math.round(100*(alutDelek+alutBluy+alutHanayaTosavHoutzTime))/100

	var histabrutKnas=Math.round(100*((60*answers[5])/(60/answers[6])));

	var zihumAvir=Math.round(100*(0.25*answers[2]*answers[5]))/100;

	var alutHanayaKnas=Math.round(100*(100/(answers[5]*60)))/100;

    var HefreshHanayot=Math.ceil(answers[0]*answers[5]*(answers[4]*answers[1]+1));
		

		if ( histabrutKnas>0.5 && alutHanayaKnas>5 ) {
			correctAnswers+="עדיף לך לחנות ברחוב"+"\r\n";
		} else {   
			correctAnswers+="עדיף לך לחנות בחניון"+"\r\n"; 
		}
	
       correctAnswers+="עלות כוללת לחניה ברחוב ₪" + alutKolelet+ "\r\n";
       correctAnswers+="עלות חניה ברחוב לתושב חוץ ₪" + alutHanayaTosavHoutzTime+ "\r\n";
       correctAnswers+="עלות צריכת דלק ₪" + alutDelek+ "\r\n";
       correctAnswers+="עלות אחזקת רכב ₪" + alutBluy+ "\r\n";
       correctAnswers+="עלות דקת חניה - במקרה של קנס ₪" + alutHanayaKnas+ "\r\n";
       correctAnswers+="זמן למציאת חניה ברחוב בסיבוב אחד(בדקות) " + zmanMesuarHanayaMyadit+ "\r\n";
       correctAnswers+="הסתברות למציאת חניה מיידית ברחוב %" + HistabrutHanaya+ "\r\n";
       correctAnswers+="הסתברות לקנס לרכב ללא תו אזורי %" + histabrutKnas+ "\r\n";
       correctAnswers+="שטח חניה דרוש לפי מספר אבני שפה כחול לבן " + SetachHanaya+ "\r\n";
       correctAnswers+="פליטת זיהום אוויר עד מציאת החניה (בגרם) " + zihumAvir+ "\r\n";
       correctAnswers+="הפרש מומלץ בין מחיר שעת חניה ברחוב לחניה פרטית ₪" + HefreshHanayot+ "\r\n";
       form.solutions.value = correctAnswers;

}

//  End -->

</script>



</HEAD>



<!-- STEP TWO: Copy this code into the BODY of your HTML document  -->



<div class="search4"></div>

<div class="text">

	<div class="intext">

		<div class="right_sim">

<h3>סימולטור החניה</h3>



<form name="simulator">

<ul class="sim_ul">

<h3 class="sim_h1">בחר עיר</h3>

  <li><input type="radio" name="q1" value="5.2" checked>תל אביב-יפו</li>

  <li><input type="radio" name="q1" value="5.1">הרצליה</li>

  <li><input type="radio" name="q1" value="5.0">רעננה</li>

</ul>

<ul class="sim_ul">

<h3 class="sim_h2">בחר אזור בעיר</h3>

  <li><input type="radio" name="q2" value="0.8">צפון</li>

  <li><input type="radio" name="q2" value="0.9" checked>מרכז</li>

  <li><input type="radio" name="q2" value="0.7">דרום</li>

  <li><input type="radio" name="q2" value="0.75">מערב</li>

  <li><input type="radio" name="q2" value="0.65">מזרח</li>

  <li><input type="radio" name="q2" value="0.60">פריפריה</li>

</ul>

<ul class="sim_ul">

<h3 class="sim_h3">בחר קבוצת רישוי</h3>

  <li><input type="radio" name="q3" value="138.629">קבוצה 1</li>

  <li><input type="radio" name="q3" value="162.143">קבוצה 2</li>

  <li><input type="radio" name="q3" value="169.583" checked>קבוצה 3</li>

  <li><input type="radio" name="q3" value="177.468">קבוצה 4</li>

  <li><input type="radio" name="q3" value="192.475">קבוצה 5</li>

  <li><input type="radio" name="q3" value="217.97">קבוצה 6</li>

  <li><input type="radio" name="q3" value="246.525">קבוצה 7</li>

</ul>

<ul class="sim_ul">

<h3 class="sim_h4">בחר סוג רכב</h3>

  <li><input type="radio" name="q4" value="3.84">מיני</li>

  <li><input type="radio" name="q4" value="4.4" checked>משפחתי</li>

  <li><input type="radio" name="q4" value="4.79">מנהלים</li>

  <li><input type="radio" name="q4" value="4.45">היברידי</li>

  <li><input type="radio" name="q4" value="4.5">מיני וואן</li>

  <li><input type="radio" name="q4" value="4.25">פיקאפ</li>

  <li><input type="radio" name="q4" value="4.6">ג'יפ</li>

</ul>

</ul>

<ul class="sim_ul">

<h3 class="sim_h5">בחר שעת חניה</h3>

  <li><input type="radio" name="q5" value="0.92">לפנות בוקר</li>

  <li><input type="radio" name="q5" value="0.85" checked>בוקר</li>

   <li><input type="radio" name="q5" value="0.65">לפני הצהריים</li>

  <li><input type="radio" name="q5" value="0.6">צהריים</li>

  <li><input type="radio" name="q5" value="0.75">אחר הצהריים</li>

  <li><input type="radio" name="q5" value="0.9">ערב</li>

  <li><input type="radio" name="q5" value="0.95">לילה</li>





</ul>

</ul>

<ul class="sim_ul">

<h3 class="sim_h6">בחר זמן חניה משוער בדקות</h3>

  <li><input type="radio" name="q6" value="0.0833">15 דקות</li>

  <li><input type="radio" name="q6" value="0.25">15 דקות</li>

  <li><input type="radio" name="q6" value="0.5" checked>30 דקות</li>

  <li><input type="radio" name="q6" value="1">60 דקות</li>

  <li><input type="radio" name="q6" value="1.5">90 דקות</li>

  <li><input type="radio" name="q6" value="2">120 דקות</li>

  <li><input type="radio" name="q6" value="3">180 דקות</li>





</ul>

<ul class="sim_ul">

<h3 class="sim_h7">בחר מספר משוער של סיורי פקחים ברחוב</h3>

  <li><input type="radio" name="q7" value="0">0</li>

  <li><input type="radio" name="q7" value="1" checked>1</li>

  <li><input type="radio" name="q7" value="2">2</li>

  <li><input type="radio" name="q7" value="3">3</li>

  <li><input type="radio" name="q7" value="4">4</li>

</ul>

<div class="sim_b">

	<input type="button" class="sim_calc" value="בצע חישוב" onClick="getScore(this.form)" class="floatLeft">

	<input type="reset" class="sim_reset" value="התחל מחדש">

</div>

<div class="clear"></div>

<div class="sim_res">



<h3>תוצאות</h3>

</div>

<textarea class="bgclr2" name="solutions" wrap="virtual" rows="12" cols="80" READONLY>

</textarea>

</form>

		</div>

	</div>

</div>

<div class="bottom"></div>

		</div>

	</div>

</div>

<div class="footer">

	<div class="infooter1"></div>

	<div class="infooter2">

		<div class="footer_links">

<table width="100%" cellspacing="0" cellpadding="0" border="0">

    <tbody>

        <tr>

            <td width="25%" valign="top">

            <div><span style="color: rgb(14, 100, 149);">&nbsp;<b>סיטיפארק</b>:</span></div>

            <ul>

                <li><a href="צור-קשר">צור קשר</a></li>

                <li><a href="http://www.citypark.co.il/תנאי-השימוש">תנאי שימוש</a></li>

                <li><a href="http://www.citypark.co.il/מדיניות פרטיות">מדיניות פרטיות</a></li>

                <li>מפת אתר</li>

            </ul>

            </td>

            <td width="25%" valign="top">

            <div><b><span style="color: rgb(14, 100, 149);">&nbsp;מידע נוסף:</span></b></div>

            <ul>

                <li><a href="http://www.citypark.co.il/faq">שאלות ותשובות</a></li>

                <li><a href="http://www.citypark.co.il/סיטיפארק בתקשורת">סיטיפארק בתקשורת</a></li>

                <li><a href="http://www.citypark.co.il/Sites/cityp/content/File/%D7%97%D7%95%D7%96%D7%94%20%D7%A9%D7%9B%D7%99%D7%A8%D7%95%D7%AA%20%D7%97%D7%A0%D7%99%D7%94.doc">חוזה שכירות חניה</a></li>

                <li><a href="http://www.citypark.co.il/user/login.asp">צרף חניון</a></li>

            </ul>

            </td>

            <td width="25%" valign="top">

            <div><span style="color: rgb(14, 100, 149);"><b>&nbsp;בעלי עסקים:</b></span></div>

            <ul>

                <li><a href="http://www.citypark.co.il/סיטיפארק לעסקים">סיטיפארק לעסקים</a></li>

                <li><a href="http://www.citypark.co.il/%D7%94%D7%A6%D7%98%D7%A8%D7%A3%20%D7%9C%D7%9E%D7%94%D7%A4%D7%99%D7%9B%D7%AA%20%D7%94%D7%97%D7%A0%D7%99%D7%94">בעל חניון?</a></li>

                <li><a href="http://www.citypark.co.il/%D7%94%D7%A6%D7%98%D7%A8%D7%A3%20%D7%9C%D7%9E%D7%94%D7%A4%D7%99%D7%9B%D7%AA%20%D7%94%D7%97%D7%A0%D7%99%D7%94">בעל חניה פרטית?</a></li>

                <li><a href="http://www.citypark.co.il/%D7%9C%D7%9E%D7%94%20%D7%A1%D7%99%D7%98%D7%99%D7%A4%D7%90%D7%A8%D7%A7">למה סיטיפארק</a></li>

            </ul>

            </td>

            <td width="25%" valign="top">

            <div><span style="color: rgb(14, 100, 149);"><b>&nbsp;עקוב אחרינו:</b></span></div>

            <ul>

                <li><a href="http://www.facebook.com/pages/CityPark/191230860928864">Facebook</a></li>

                <li><a href="http://twitter.com/cityparkltd">Twiitter</a></li>

            </ul>

            </td>

        </tr>

    </tbody>

</table>

		</div>

		<div class="copy">

			כל הזכויות שמורות ל - <span>סיטיפארק בע"מ</span>

		</div>

		<div class="dooble">

			d<span>oo</span>ble <a href="http://www.dooble.co.il" title="בניית אתרים">בניית אתרים</a>

		</div>

	</div>

</div>

<script type="text/javascript">



  var _gaq = _gaq || [];

  _gaq.push(['_setAccount', 'UA-23887576-1']);

  _gaq.push(['_trackPageview']);



  (function() {

    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;

    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';

    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);

  })();



</script>
