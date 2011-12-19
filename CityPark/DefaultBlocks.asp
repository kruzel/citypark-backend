<%

DefaultBlocks.Add "block", CreateDelegate("GetNewsText")
DefaultBlocks.Add "includes", CreateDelegate("Block_HeaderIncludes")
DefaultBlocks.Add "Menu", CreateDelegate("GetMenu")

' Sub ProcessBlock(strCommand)
	' ElseIf IsNumeric(Replace(strCommand, "blockimage", "")) Then
		' ProcessLayout GetBlockImage(Int(Replace(strCommand, "blockimage", "")))
	' ElseIf IsNumeric(Replace(strCommand, "blocktitle", "")) Then
		' ProcessLayout GetBlocktitle(Int(Replace(strCommand, "blocktitle", "")))
	' ElseIf IsNumeric(Replace(strCommand, "category", "")) Then
		' ProcessLayout GetCategory(Int(Replace(strCommand, "category", "")))
	' ElseIf IsNumeric(Replace(strCommand, "gallerys", "")) Then
		' ProcessLayout Getgallerys(Int(Replace(strCommand, "gallerys", "")))
	' ElseIf IsNumeric(Replace(strCommand, "forms", "")) Then
		' PrintFormBlock(Int(Replace(strCommand, "forms", ""))), "add"
	' ElseIf IsNumeric(Replace(strCommand, "toolbar", "")) Then
		' PrintFormBlock(Int(Replace(strCommand, "toolbar", ""))), ""
	' ElseIf IsNumeric(Replace(strCommand, "ProductCategorys", "")) Then
		' ProcessLayout GetProductCategorys(Int(Replace(strCommand, "ProductCategorys", "")))
	' ElseIf IsNumeric(Replace(strCommand, "ProductCategory", "")) Then
		' ProcessLayout GetProductCategory(Int(Replace(strCommand, "ProductCategory", "")))
	' ElseIf IsNumeric(Replace(strCommand, "videocategory", "")) Then
		' ProcessLayout GetvideoCategory(Int(Replace(strCommand, "videocategory", "")))
	' ElseIf IsNumeric(Replace(strCommand, "Campaign", "")) Then
		' ProcessLayout GetCampaign(Int(Replace(strCommand, "Campaign", "")))
	' ElseIf IsNumeric(Replace(strCommand, "Rss", "")) Then
		' ProcessLayout GetRss(Int(Replace(strCommand, "Rss", "")))
	' ElseIf IsNumeric(Replace(strCommand, "News", "")) Then
		' ProcessLayout GetNews(Int(Replace(strCommand, "News", "")))
	' ElseIf IsNumeric(Replace(strCommand, "sitemapcategory", "")) Then
		' ProcessLayout Getsitemapcategory(Int(Replace(strCommand, "sitemapcategory", "")))
	' ElseIf LCase(Mid(strCommand, 1, Len("ratingcount"))) = "ratingcount" Then
			' Parameters = Split(Mid(strCommand, Len("ratingcount") + 2))
		' For Each Parameter In Parameters
			' If LCase(Mid(Parameter, 1, Len("table:"))) = "table:" Then
				' TableName = Mid(Parameter, Len("Table:") + 1)
			' ElseIf LCase(Mid(Parameter, 1, Len("id:"))) = "id:" Then
				' EntityId = Mid(Parameter, Len("id:") + 1)
			' End If
		' Next
		
		' Set u = OpenDB("SELECT COUNT(*) as c FROM Rating WHERE EntityId = " & EntityID & " AND TableName = '" & TableName & "'")
		' print u("c")
		' CloseDB(u)
		
	' ElseIf LCase(Mid(strCommand, 1, Len("rating"))) = "rating" Then
		' Parameters = Split(Mid(strCommand, Len("rating") + 2))
		
		' Stars = False
		' Reviews = False
		' RReadOnly = False
		' ShowAverage = False
		' ShowReviews = False
		' grade = False
        ' Showemail = False
		' For Each Parameter In Parameters
			' If LCase(Mid(Parameter, 1, Len("table:"))) = "table:" Then
				' TableName = Mid(Parameter, Len("Table:") + 1)
			' ElseIf LCase(Mid(Parameter, 1, Len("id:"))) = "id:" Then
				' EntityId = Mid(Parameter, Len("id:") + 1)
			' ElseIf LCase(Mid(Parameter, 1, Len("stars:"))) = "stars:" Then
				' Stars = True
				' StarsCount = Mid(Parameter, Len("stars:") + 1)				
			' ElseIf Parameter = "Reviews" Then
				' Reviews = True
            ' ElseIf Parameter = "Showemail" Then 
                    ' Showemail = True
			' ElseIf Parameter = "ShowAverage" Then
				' ShowAverage = True	
			' ElseIf Parameter = "grade" Then
				' grade = True	
			' ElseIf Parameter = "ShowReviews" Then
				' ShowReviews = True	
			' ElseIf Parameter = "ReadOnly" Then
				' RReadOnly = True
				' ShowAverage = True
			' End If
		' Next
		
		' If RReadonly And Stars And Reviews Then
			' Print "Only stars OR reviews can be if in read only mode"
		' Else
		
		' If ShowAverage Then
			' Set s = OpenDB("SELECT AVG(Rating) as avg FROM Rating WHERE EntityId = " & EntityID & " AND TableName = '" & TableName & "'")
			
			' Average = s("avg")
			
			' CloseDb(S)
		' End If

		' If grade Then
            ' If Average = 1 Then  AveregeTag = "רע!"  
            ' If Average = 2 Then  AveregeTag = "לא משהו"  
            ' If Average = 3 Then  AveregeTag = "בסדר"  
            ' If Average = 4 Then  AveregeTag = "טוב"  
            ' If Average = 5 Then  AveregeTag = "מצויין!" 
            ' print "<div class=""AveregeTag"">" &  AveregeTag & "</div>"
		' End If

	' If Not ShowReviews then
	' Randomize
			' random = Int((100) * Rnd + 1)
			' 
			' <div id="addreview">
			'  If Request.Cookies("vote" & EntityID) <> "" And Not ReadOnly And Reviews Then 
			' <div class="rur">לא ניתן להצביע יותר מפעם אחת.</div>
			'  End if 
				'  If Request.Cookies("vote" & EntityID) <> "1" Then 
				' <script>

					' function validate(form) {
						' var v = true;
						' $("#rate_title_validation").text("");
						' $("#rate_email_validation").text("");
						' $("#rate_text_validation").text("");
						
						' if ($("#rate_title").val().trim() == "")
						' {
							' $("#rate_title_validation").text("שדה זה חובה.");
							' v = false;
						' }
						' if ($("#rate_text").val().length < 10)
						' {
							' $("#rate_text_validation").text("יש להכניס בהודעה מינימום 10 תווים.");
							' v = false;
						' }


                        
					'  If Showemail Then 
						' if ($("#rate_email").val().trim() == "")
						' {
							' $("#rate_email_validation").text("שדה זה חובה.");
							' v = false;
						' }
						' else if (!isValidEmail($("#rate_email").val()))
						' {
							' $("#rate_email_validation").text("כתובת האימייל לא חוקית.");
							' v = false;						
						' }
                    '  End If  

												' return v;
					' }
					
					' function isValidEmail(strEmail){
  ' validRegExp = /^[^@]+@[^@]+.[a-z]{2,}$/i;

   ' // search email text for regular exp matches
    ' if (strEmail.search(validRegExp) == -1) 
   ' {

      ' return false;
    ' } 
    ' return true; 
' }



				' </script>
				' <form action="/SubmitRating.asp?EntityID= = EntityID &TableName= = TableName &redirect= = Server.urlencode(Url)" method="post" onsubmit="return validate(this);">
				'  end If 
				'  If Reviews Then 
					'  If Stars And Not RReadOnly And Request.Cookies("vote" & EntityID) <> "1"  Then 
					' <input type="hidden" name="Rating" id="RatingInput = random " />
					'  End IF  
					'  If Request.Cookies("vote" & EntityID) <> "1" then 
					' <div class="rate_label"> = SysLang("name") :</div><input id="rate_name" type="text" name="Name" size="30"/>
					' <span id="rate_name_validation" class="error"></span>
					' <div class="rate_label"> = SysLang("Title") :</div><input id="rate_title" type="text" name="Title" size="30"/>
					' <span id="rate_title_validation" class="error"></span>
					'  If Showemail Then 
					' <div class="rate_label"> = SysLang("email") :</div><input id="rate_email" type="text" name="Email" size="30" class="required">
								' <span id="rate_email_validation" class="error"></span>		
					'  End if 
					' <div class="rate_label"> = SysLang("Message") :</div><textarea id="rate_text" rows="7" name="Text" cols="40"  onKeyDown="formTextCounter(this.form.Text,this.form.remLen_Text,300);" onKeyUp="formTextCounter(this,$('remLen_Text'),300);" wrap="soft"></textarea><span id="rate_text_validation" class="error" style="width:300px"></span><br><input readonly="readonly" type="text" name="remLen_Text" size="1" maxlength="3" value="300">
							
                   ' <div class="rate_label" style="width:400px">  <input type=radio value="1" name="Rating" />רע!  <input  type=radio value="2" name="Rating" />לא משהו  <input  type=radio value="3" name="Rating" />בסדר  <input  type=radio value="4" name="Rating" />טוב  <input type=radio value="5" name="Rating" checked />מצויין!</div>
					'  End If 
					'  End If    
					' C = True
						
						' if   Request.Cookies("vote" & EntityID) = "1" and  not rreadonly then
						' c = false
						' end if 
					' 
					'  If Stars and c Then 
					' <p class="_rating">
						' <script type="application/json">
							' {
								' mode: [ If Not Reviews And Not RREadOnly And Request.Cookies("vote" & EntityID) <> "1" Then "Ajax" If RReadOnly Or ShowAverage Then ,  End If  End If  If RReadOnly Then "ReadOnly" If ShowAverage Then ,  End If  End If  If ShowAverage Then "ShowAverage" End If ]
								'  If Not RReadOnly and Not Reviews Then 
								' ,tableName: " = TableName ",
								' entityId:  = EntityID 
								'  End If 
								' ,starsCount:  = StarsCount 
								'  If Reviews Then 
								' ,input: "RatingInput = random "
								'  End If 
								'  If ShowAverage And Average <> "" Then 
								' ,average:  = Average 
								'  End IF 
							' }
						' </script>
					' </p>
					'  End If 
					
					'  If Reviews and Request.Cookies("vote" & EntityID) <> "1" Then 
					' <p><input type="submit" value="שלח" /></p>
				'  End If 
		'  If Request.Cookies("vote" & EntityID) <> "1" Then 				
				' </form>

				'  End If 
			' </div>
			'  End If 
			
			'  If ShowReviews Then 
				' 
                    ' sqlReviews = "SELECT * FROM Rating WHERE EntityId = " & EntityID & " AND TableName = '" & TableName & "'"
                ' If Request.QueryString("") = "new" Then
                    ' sqlReviews = sqlReviews & " order by date DESC"
                ' ElseIf Request.QueryString("") = "old" Then
                    ' sqlReviews = sqlReviews & " order by date Asc"
                ' End If

				' Set objRsReviews = OpenDB(sqlReviews)
				
				' Do Until objRsReviews.EOF
					' If objRsReviews("Review") <> "" Then
				' 
                ' <div class="reviews">
			    ' <div class="reviews_title"> = objRsReviews("Title") </div>
                ' <div class="reviews_name"> = objRsReviews("CName") </div>
			    ' <div class="reviews_date"> = FormatDate(objRsReviews("date"),"dd/mm/yyyy") </div>
				' <div class="reviews_email"> = objRsReviews("Mail") </div>
                ' <div class="reviews_review"> = objRsReviews("Review") </div>
				' <div class="reviews_rate">
					' <p class="_rating">
						' <script type="application/json">
							' {
								' mode: ["ReadOnly", "ShowAverage"]
								' ,starsCount:  = StarsCount 
								' ,average:  = objRsReviews("Rating") 
							' }
						' </script>
					' </p>				
				' </div>
				' </div>
				
				' 
					' End If
					' objRsReviews.MoveNext
				' Loop
				' 
			'  End If 
		' 
		' End If
	' Else
		' ProcessLayoutBlock strCommand
	' End If

' End Sub

%>
