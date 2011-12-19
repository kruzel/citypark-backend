<%
If Request.ServerVariables("HTTP_HOST") = "www.babystuff.co.il" then Predirect "http://www.babystav.co.il"

If Request.ServerVariables("HTTP_HOST") = "www.dermalosophy.com" then Predirect "http://www.dermalosophy.co.il"

If Request.ServerVariables("HTTP_HOST") = "www.mazor-robotics.com" then Predirect "http://www.mazorrobotics.com"
If Request.ServerVariables("HTTP_HOST") = "www.mazorrobtics.com" then Predirect "http://www.mazorrobotics.com"
If Request.ServerVariables("HTTP_HOST") = "www.mazorobotics.com" then Predirect "http://www.mazorrobotics.com"

If Request.ServerVariables("HTTP_HOST") = "www.mazorst.com" then Predirect "http://www.mazorrobotics.com"

If Request.ServerVariables("HTTP_HOST") = "www.mazor-robotics.us" then Predirect "http://www.mazorrobotics.com/home-page-usa"
If Request.ServerVariables("HTTP_HOST") = "www.mazorrobtics.us" then Predirect "http://www.mazorrobotics.com/home-page-usa"
If Request.ServerVariables("HTTP_HOST") = "www.mazorobotics.us" then Predirect "http://www.mazorrobotics.com/home-page-usa"

'If Request.ServerVariables("HTTP_HOST") = "www.mazor-robotics.de" then Predirect "hhttp://www.mazorrobotics.com/home-page-german"
'If Request.ServerVariables("HTTP_HOST") = "www.mazorrobtics.de" then Predirect "http://www.mazorrobotics.com/home-page-german"
'If Request.ServerVariables("HTTP_HOST") = "www.mazorobotics.de" then Predirect "http://www.mazorrobotics.com/home-page-german"

If Request.ServerVariables("HTTP_HOST") = "www.ofek-bar.co.il" then
	If Request.QueryString("CategoryID") = 157 Then Predirect "/שירותי-ייעוץ-עסקי"
	If Request.QueryString("CategoryID") = 158 Then Predirect "/כיצד-מגבשים-תכנית-עסקית"
	If Request.QueryString("CategoryID") = 182 Then Predirect "/הבראה-והתייעלות"
	If Request.QueryString("CategoryID") = 197 Then Predirect "/ניסוח-פורמט-תוכנית-עסקית"
	If Request.QueryString("CategoryID") = 20 Then Predirect "/צור-קשר"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 127 Then Predirect "/זקוק-לתוכנית-עסקית-לצורך-הקמת-עסק-או-פעילות-חדשה"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 175 Then Predirect "/תוכנית-עסקית-לסטארט-אפ"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 165 Then Predirect "/תזרים-מזומנים-זכות-או-חובה"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 109 Then Predirect "/תוכנית-עסקית"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 146 Then Predirect "/10-כללים-להכנת-תוכנית-עיסקית"
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 144 Then Predirect "/תוכנית-עסקית-למיזמי-אינטרנט"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 115 Then Predirect "/10-טיפים-בדרך-להקמת-עסק-חדש"
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 96 Then Predirect "/ליווי-ויצוג-בנקאי"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 83 Then Predirect "/כיצד-להתמודד-עם-עומס-העבודה-ביעילות"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 118 Then Predirect "/מפת-אתר"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 80 Then Predirect "/מהי-נקודת-האיזון-וכיצד-היא-מחושבת"
	If Request.QueryString("CategoryID") = 156 AND Request.QueryString("ArticleID") = 104 Then Predirect "/יניב-רוסו"
	
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 90 Then Predirect "/ליווי-פיננסי"
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 95 Then Predirect "/תוכניות-הבראה-לעסקים-בקשיים"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 108 Then Predirect "/אתרים-שימושיים"
	If Request.QueryString("CategoryID") = 156 AND Request.QueryString("ArticleID") = 169 Then Predirect "/פני-רוסו"
	If Request.QueryString("CategoryID") = 156 AND Request.QueryString("ArticleID") = 119 Then Predirect "/טל-כרמלי"
	If Request.QueryString("CategoryID") = 156 AND Request.QueryString("ArticleID") = 105 Then Predirect "/"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 136 Then Predirect "/"
	
	If Request.QueryString("CategoryID") = 189 Then Predirect "/בין-לקוחותינו"
	
	If Request.QueryString("CategoryID") = 155 AND Request.QueryString("ArticleID") = 106 Then Predirect "/"
	If Request.QueryString("CategoryID") = 159 Then Predirect "/עוד-דברים-שחשוב-לדעת"
	If Request.QueryString("CategoryID") = 156 Then Predirect "/מי-אנחנו"
	If Request.QueryString("CategoryID") = 196 Then Predirect "/עוד-דברים-שחשוב-לדעת"
	If Request.QueryString("CategoryID") = 70 Then Predirect "/מפת-אתר"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 117 Then Predirect "/ניהול-עסק-תמרורי-אזהרה"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 87 Then Predirect "/האם-מצב-ההתחייבויות-בבנק-משקף-את-מצב-העסק"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 134 Then Predirect "/זקוק-לתוכנית-עסקית-לצורך-הקמת-עסק-או-פעילות-חדשה"
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 97 Then Predirect "/השקעות-וגיוס-משקיעים"
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 94 Then Predirect "/הערכת-שווי-חברות"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 170 Then Predirect "/ייעוץ-עסקי-מתחיל-באבחון-מקצועי"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 86 Then Predirect "/מדוע-אני-צריך-תוכנית-תקציב"
	If Request.QueryString("CategoryID") = 156 AND Request.QueryString("ArticleID") = 168 Then Predirect "/"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 138 Then Predirect "/"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 112 Then Predirect "/"
         
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 143 Then Predirect "/"
	If Request.QueryString("CategoryID") = 156 AND Request.QueryString("ArticleID") = 167 Then Predirect "/בני-שפריר"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 82 Then Predirect "/אילו-סיכונים-עומדים-בפני-עסק-בצמיחה"
	If Request.QueryString("ArticleID") = 75 Then Predirect "/"
	If Request.QueryString("ArticleID") = 126 Then Predirect "/"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 81 Then Predirect "/הטעיית-תזרים-המזומנים-על-הרווח-והפסד-של-העסק"
	If Request.QueryString("CategoryID") = 20 Then Predirect "/צור-קשר"

	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 116 Then Predirect "/10-טיפים-בדרך-להקמת-עסק-חדש"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 135 Then Predirect "/האני-מאמין-שלנו"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 110 Then Predirect "/ניהול-עסק-תמרורי-אזהרה"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 114 Then Predirect "/ניהול-עסק-מזווית-אחרת"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 137 Then Predirect "/סיפור-מקרה-תוכנית-הבראה"
	
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 92 Then Predirect "/"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 85 Then Predirect "/איך-ניתן-לזהות-שהעסק-לקראת-משבר-פיננסי"
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 89 Then Predirect "/ליווי-עסקים"
	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 79 Then Predirect "/מהו-הסכום-הנדרש-להקמת-עסק-ומה-הם-הכלים-העומדים-לצורך-כך"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 128 Then Predirect "/זקוק-לתוכנית-עסקית-לצורך-הקמת-עסק-או-פעילות-חדשה"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 130 Then Predirect "/זקוק-לתוכנית-עסקית-לצורך-הקמת-עסק-או-פעילות-חדשה"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 129 Then Predirect "/זקוק-לתוכנית-עסקית-לצורך-הקמת-עסק-או-פעילות-חדשה"

	If Request.QueryString("CategoryID") = 159 AND Request.QueryString("ArticleID") = 113 Then Predirect "/"
	If Request.QueryString("CategoryID") = 157 AND Request.QueryString("ArticleID") = 101 Then Predirect "/יעוץ וליווי שיווקי"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 133 Then Predirect "/תוכנית-עסקית-מקצועית-הדרך-להצלחה-שלך"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 132 Then Predirect "/שירותי-יעוץ-עיסקי-למטרות-התייעלות"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 131 Then Predirect "/אתה-מרגיש-שהעסק-סוגר-עליך"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 111 Then Predirect "/נקודות-למחשבה"
	If Request.QueryString("CategoryID") = 175 AND Request.QueryString("ArticleID") = 110 Then Predirect "/תמרורי-אזהרה"

End If 'www.ofek-bar.co.il
If Request.ServerVariables("HTTP_HOST") = "www.yehuda-tal.com" then
    if Request.QueryString("id") = 52 Then Predirect "/מכשיר-קשר-נישא-מדגם-TC610"
End If 'www.yehuda-tal.com

%>