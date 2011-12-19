<%
 
Dim IsHeaderCalled : IsHeaderCalled = False
Set objFSO = CreateObject("Scripting.FileSystemObject")   

Sub PrintCustomizedTemplate(strTemplate, Recordset, BlockFunctionName)
	StartBlockPosition = InStr(strTemplate, "[")
	EndBlockPosition = InStr(strTemplate, "]")
			
	If StartBlockPosition = 0 Then
		Print Mid(strTemplate, 1) 
	Else
		Print Mid(strTemplate, 1, StartBlockPosition - 1)
		
		s = Replace(Mid(strTemplate, StartBlockPosition + 1, EndBlockPosition - (StartBlockPosition + 1)), """", """""")
		
		If Mid(s, 1, 1) = "/" Then
			Print Mid(s, 2)
		Else
			CommandCall = BlockFunctionName & "	""" & s & """"
		
			If Not IsNull(Recordset) Then
				CommandCall = CommandCall & ", RecordSet"
			End If
			
			Execute CommandCall
		End If
		
		PrintCustomizedTemplate Mid(strTemplate, EndBlockPosition + 1), Recordset, BlockFunctionName
	End If
End Sub
 
Function GetCustomizedTemplate(strTemplate, Recordset, BlockFunctionName)
	StartBlockPosition = InStr(strTemplate, "[")
	EndBlockPosition = InStr(strTemplate, "]")
			
	If StartBlockPosition = 0 Then
		GetCustomizedTemplate = Mid(strTemplate, 1) 
	Else
		GetCustomizedTemplate = Mid(strTemplate, 1, StartBlockPosition - 1)

		s = Replace(Mid(strTemplate, StartBlockPosition + 1, EndBlockPosition - (StartBlockPosition + 1)), """", """""")
		
		If Mid(s, 1, 1) = "/" Then
			GetCustomizedTemplate = GetCustomizedTemplate & "[" & Mid(s, 2) & "]"
		Else		
		CommandCall = "GetCustomizedTemplate = GetCustomizedTemplate & " & BlockFunctionName & "(""" & s & """"
		
		If Not IsNull(Recordset) Then
			CommandCall = CommandCall & ", RecordSet"
		End If
		
		CommandCall = CommandCall & ")"
		Execute CommandCall
		End If
		GetCustomizedTemplate = GetCustomizedTemplate & GetCustomizedTemplate(Mid(strTemplate, EndBlockPosition + 1), Recordset, BlockFunctionName)
	End If
End Function 

Function GetPostTemplate(strTemplate)
	GetPostTemplate = GetCustomizedTemplate(strTemplate, Null, "GetPostBlock")
End Function

Function GetPostBlock(strCommand)
	GetPostBlock = Request.Form(strCommand)
End Function

Function GetRecordSetTemplate(strTemplate, RecordSet)
	GetRecordSetTemplate = GetCustomizedTemplate(strTemplate, RecordSet, "GetRecordSetBlock")
End Function

Function GetRecordSetBlock(strCommand, Recordset)
	Contains = False
	
	For Each x in Recordset.Fields
		If LCase(x.Name) = LCase(strCommand) Then
			Contains = True
			Exit For
		End If
	Next
	
	If Contains Then
		GetRecordSetBlock = RecordSet(strCommand)
	Else
		GetRecordSetBlock = "[" & strCommand & "]"
	End If
End Function

Sub ProcessLayout(strTemplate)
	PrintCustomizedTemplate strTemplate, Null, "ProcessBlock"
End Sub

Sub ProcessParameters(dictionary, input) 
	equal = InStr(input, "=")
	ends = InStr(equal + 2, input, """")
	
	dictionary.Add Mid(input, 1, equal - 1), Mid(input, equal + 2, ends - (equal + 2))
	
	nextk = Mid(input, ends + 2)
	
	If Not nextk = "" Then ProcessParameters dictionary, nextk
End Sub

Function FieldExists(name, rs)
	FieldExists = False
	
	For Each x In rs.Fields
		If LCase(x.Name) = LCase(name) Then
			FieldExists = True
			Exit For
		End If
	Next
End Function

Sub ProcessBlock(strCommand)
	If IsNumeric(Replace(strCommand, "block", "")) Then
		ProcessLayout GetNewsText(Int(Replace(strCommand, "block", "")))
	ElseIf IsNumeric(Replace(strCommand, "blockimage", "")) Then
		ProcessLayout GetBlockImage(Int(Replace(strCommand, "blockimage", "")))
	ElseIf IsNumeric(Replace(strCommand, "blocktitle", "")) Then
		ProcessLayout GetBlocktitle(Int(Replace(strCommand, "blocktitle", "")))
	ElseIf IsNumeric(Replace(strCommand, "category", "")) Then
		ProcessLayout GetCategory(Int(Replace(strCommand, "category", "")))
	ElseIf IsNumeric(Replace(strCommand, "categoryperday", "")) Then
		ProcessLayout GetCategoryPerDay(Int(Replace(strCommand, "categoryperday", "")))
	ElseIf IsNumeric(Replace(strCommand, "menus", "")) Then
		ProcessLayout GetMenu(Int(Replace(strCommand, "menus", "")))
	ElseIf IsNumeric(Replace(strCommand, "gallerys", "")) Then
		ProcessLayout Getgallerys(Int(Replace(strCommand, "gallerys", "")))
	ElseIf IsNumeric(Replace(strCommand, "forms", "")) Then
		PrintFormBlock(Int(Replace(strCommand, "forms", ""))), "add"
	ElseIf IsNumeric(Replace(strCommand, "toolbar", "")) Then
		PrintFormBlock(Int(Replace(strCommand, "toolbar", ""))), ""
	ElseIf IsNumeric(Replace(strCommand, "ProductCategorys", "")) Then
		ProcessLayout GetProductCategorys(Int(Replace(strCommand, "ProductCategorys", "")))
	ElseIf IsNumeric(Replace(strCommand, "ProductCategory", "")) Then
		ProcessLayout GetProductCategory(Int(Replace(strCommand, "ProductCategory", "")))
	ElseIf IsNumeric(Replace(strCommand, "videocategory", "")) Then
		ProcessLayout GetvideoCategory(Int(Replace(strCommand, "videocategory", "")))
	ElseIf IsNumeric(Replace(strCommand, "Campaign", "")) Then
		ProcessLayout GetCampaign(Int(Replace(strCommand, "Campaign", "")))
	ElseIf IsNumeric(Replace(strCommand, "Rss", "")) Then
		ProcessLayout GetRss(Int(Replace(strCommand, "Rss", "")))
	ElseIf IsNumeric(Replace(strCommand, "Showreviews", "")) Then
		ProcessLayout GetShowreviews(Int(Replace(strCommand, "Showreviews", "")))
	ElseIf IsNumeric(Replace(strCommand, "News", "")) Then
		ProcessLayout GetNews(Int(Replace(strCommand, "News", "")))
	ElseIf IsNumeric(Replace(strCommand, "calendar", "")) Then
		ProcessLayout GetCalendar(Int(Replace(strCommand, "calendar", "")))
	ElseIf IsNumeric(Replace(strCommand, "sitemapcategory", "")) Then
		ProcessLayout Getsitemapcategory(Int(Replace(strCommand, "sitemapcategory", "")))
	ElseIf LCase(Mid(strCommand, 1, Len("_Image"))) = "_image" Then
		Set parameters = CreateObject("Scripting.Dictionary")
		parameters.CompareMode = vbTextCompare

		ProcessParameters parameters, Mid(strCommand, Len("_Image") + 2)
		Print "<img src=""resize.ashx?path=" & Server.URLEncode(parameters("src")) & "&width=" & parameters("width") & """ />"

	ElseIf LCase(Mid(strCommand, 1, Len("Combo"))) = "combo" Then
		Set d = CreateObject("Scripting.Dictionary")
		d.CompareMode = vbTextCompare
		
		ProcessParameters d, Mid(strCommand, Len("Combo") + 2)

		sql = Replace(d("sql"), "{SiteId}", SiteId) 
		
		Print "<select"
		
		If d.Exists("name") Then Print " id=""" & d("name") & """ name=""" & d("name") & """"
		If d.Exists("class") Then Print " class=""" & d("class") & """"
		If d.Exists("style") Then Print " style=""" & d("style") & """"
		
		Print ">"
		
		If d.Exists("titleText") Then
			Print "<option value=""" 
			If d.Exists("titleValue") Then Print d("titleValue") Else Print d("titleText")
			Print """>" & d("titleText") & "</option>"
		End If
		
		Set rs = OpenDB(sql)
		
		Do Until rs.Eof
			Print "<option value="""
			If FieldExists("Value", rs) Then Print rs("Value") Else Print rs("Text")
			Print """>" & rs("Text") & "</option>"
			
			rs.MoveNext
		Loop
		
		CloseDB(rs)
		
		Print "</select>"

	ElseIf LCase(Mid(strCommand, 1, Len("rating"))) = "rating" Then

		Parameters = Split(Mid(strCommand, Len("rating") + 2))
		
		Stars = False
		Reviews = False
		RReadOnly = False
		ShowAverage = False
		ShowReviews = False
		grade = False
        Showemail = False
		For Each Parameter In Parameters
			If LCase(Mid(Parameter, 1, Len("table:"))) = "table:" Then
				TableName = Mid(Parameter, Len("Table:") + 1)
			ElseIf LCase(Mid(Parameter, 1, Len("id:"))) = "id:" Then
				EntityId = Mid(Parameter, Len("id:") + 1)
			ElseIf LCase(Mid(Parameter, 1, Len("stars:"))) = "stars:" Then
				Stars = True
				StarsCount = Mid(Parameter, Len("stars:") + 1)				
			ElseIf Parameter = "Reviews" Then
				Reviews = True
            ElseIf Parameter = "Showemail" Then 
                    Showemail = True
			ElseIf Parameter = "ShowAverage" Then
				ShowAverage = True	
			ElseIf Parameter = "grade" Then
				grade = True	
			ElseIf Parameter = "ShowReviews" Then
				ShowReviews = True	
			ElseIf Parameter = "ReadOnly" Then
				RReadOnly = True
				ShowAverage = True
			End If
		Next

		If RReadonly And Stars And Reviews Then
			Print "Only stars OR reviews can be if in read only mode"
		Else
		
		If ShowAverage Then
			Set s = OpenDB("SELECT AVG(Rating) as avg FROM Rating WHERE EntityId = " & EntityID & " AND TableName = '" & TableName & "'")
			
			Average = s("avg")
			
			CloseDb(S)
		End If

		If grade Then
            If Average = 1 Then  AveregeTag = "רע!"  
            If Average = 2 Then  AveregeTag = "לא משהו"  
            If Average = 3 Then  AveregeTag = "בסדר"  
            If Average = 4 Then  AveregeTag = "טוב"  
            If Average = 5 Then  AveregeTag = "מצויין!" 
            print "<div class=""AveregeTag"">" &  AveregeTag & "</div>"
		End If

	If Not ShowReviews then
	Randomize
			random = Int((100) * Rnd + 1)
			%>
			<div id="addreview">
			<% If Request.Cookies("vote" & EntityID) <> "" And Not ReadOnly And Reviews Then %>
			<div class="rur">לא ניתן להצביע יותר מפעם אחת.</div>
			<% End if %>
				<% If Request.Cookies("vote" & EntityID) <> "1" Then %>
				<script>

					function validate(form) {
						var v = true;
						$("#rate_title_validation").text("");
						$("#rate_email_validation").text("");
						$("#rate_text_validation").text("");
						
						if ($("#rate_title").val().trim() == "")
						{
							$("#rate_title_validation").text("שדה זה חובה.");
							v = false;
						}
						if ($("#rate_text").val().length < 10)
						{
							$("#rate_text_validation").text("יש להכניס בהודעה מינימום 10 תווים.");
							v = false;
						}


                        
					<% If Showemail Then %>
						if ($("#rate_email").val().trim() == "")
						{
							$("#rate_email_validation").text("שדה זה חובה.");
							v = false;
						}
						else if (!isValidEmail($("#rate_email").val()))
						{
							$("#rate_email_validation").text("כתובת האימייל לא חוקית.");
							v = false;						
						}
                    <% End If  %>

												return v;
					}
					
					function isValidEmail(strEmail){
  validRegExp = /^[^@]+@[^@]+.[a-z]{2,}$/i;

   // search email text for regular exp matches
    if (strEmail.search(validRegExp) == -1) 
   {

      return false;
    } 
    return true; 
}



				</script>
				<form action="/SubmitRating.asp?EntityID=<% = EntityID %>&TableName=<% = TableName %>&redirect=<% = Server.urlencode(Url)%>" method="post" onsubmit="return validate(this);">
				<% end If %>
				<% If Reviews Then %>
					<% If Stars And Not RReadOnly And Request.Cookies("vote" & EntityID) <> "1"  Then%> 
					<input type="hidden" name="Rating" id="RatingInput<% = random %>" />
					<% End IF  %>
					<% If Request.Cookies("vote" & EntityID) <> "1" then %>
					<div class="rate_label"><% = SysLang("name") %>:</div><input id="rate_name" type="text" name="Name" size="30"/>
					<span id="rate_name_validation" class="error"></span>
					<div class="rate_label"><% = SysLang("Title") %>:</div><input id="rate_title" type="text" name="Title" size="30"/>
					<span id="rate_title_validation" class="error"></span>
					<% If Showemail Then %>
					<div class="rate_label"><% = SysLang("email") %>:</div><input id="rate_email" type="text" name="Email" size="30" class="required">
								<span id="rate_email_validation" class="error"></span>		
					<% End if %>
					<div class="rate_label"><% = SysLang("Message") %>:</div><textarea id="rate_text" rows="7" name="Text" cols="40"  onKeyDown="formTextCounter(this.form.Text,this.form.remLen_Text,300);" onKeyUp="formTextCounter(this,$('remLen_Text'),300);" wrap="soft"></textarea><span id="rate_text_validation" class="error" style="width:300px"></span><br><input readonly="readonly" type="text" name="remLen_Text" size="1" maxlength="3" value="300">
							
                   <div class="rate_label" style="width:400px">  <input type=radio value="1" name="Rating" />רע!  <input  type=radio value="2" name="Rating" />לא משהו  <input  type=radio value="3" name="Rating" />בסדר  <input  type=radio value="4" name="Rating" />טוב  <input type=radio value="5" name="Rating" checked />מצויין!</div>
					<% End If %>
					<% End If %>   
					<%C = True
						
						if   Request.Cookies("vote" & EntityID) = "1" and  not rreadonly then
						c = false
						end if 
					%>
					<% If Stars and c Then %>
					<p class="_rating">
						<script type="application/json">
							{
								mode: [<% If Not Reviews And Not RREadOnly And Request.Cookies("vote" & EntityID) <> "1" Then %>"Ajax"<% If RReadOnly Or ShowAverage Then %>, <% End If %><% End If %><% If RReadOnly Then %>"ReadOnly"<% If ShowAverage Then %>, <% End If %><% End If %><% If ShowAverage Then %>"ShowAverage"<% End If %>]
								<% If Not RReadOnly and Not Reviews Then %>
								,tableName: "<% = TableName %>",
								entityId: <% = EntityID %>
								<% End If %>
								,starsCount: <% = StarsCount %>
								<% If Reviews Then %>
								,input: "RatingInput<% = random %>"
								<% End If %>
								<% If ShowAverage And Average <> "" Then %>
								,average: <% = Average %>
								<% End IF %>
							}
						</script>
					</p>
					<% End If %>
					
					<% If Reviews and Request.Cookies("vote" & EntityID) <> "1" Then %>
					<p><input type="submit" value="שלח" /></p>
				<% End If %>
		<% If Request.Cookies("vote" & EntityID) <> "1" Then %>				
				</form>

				<% End If %>
			</div>
			<% End If %>
			
			<% If ShowReviews Then %>
				<%
                    sqlReviews = "SELECT * FROM Rating WHERE EntityId = " & EntityID & " AND TableName = '" & TableName & "'"
                If Request.QueryString("") = "new" Then
                    sqlReviews = sqlReviews & " order by date DESC"
                ElseIf Request.QueryString("") = "old" Then
                    sqlReviews = sqlReviews & " order by date Asc"
                End If

				Set objRsReviews = OpenDB(sqlReviews)
				
				Do Until objRsReviews.EOF
					If objRsReviews("Review") <> "" Then
				%>
                <div class="reviews">
			    <div class="reviews_title"><% = objRsReviews("Title") %></div>
                <div class="reviews_name"><% = objRsReviews("CName") %></div>
			    <div class="reviews_date"><% = FormatDate(objRsReviews("date"),"dd/mm/yyyy") %></div>
				<div class="reviews_email"><% = objRsReviews("Mail") %></div>
                <div class="reviews_review"><% = objRsReviews("Review") %></div>
				<div class="reviews_rate">
					<p class="_rating">
						<script type="application/json">
							{
								mode: ["ReadOnly", "ShowAverage"]
								,starsCount: <% = StarsCount %>
								,average: <% = objRsReviews("Rating") %>
							}
						</script>
					</p>				
				</div>
				</div>
				
				<%
					End If
					objRsReviews.MoveNext
				Loop
				%>
			<% End If %>
		<%
		End If
	Else
		ProcessLayoutBlock strCommand
	End If

End Sub

Sub ProcessFormLayout(strTemplate, SQL, Mode)
	StartBlockPosition = InStr(strTemplate, "[")
	EndBlockPosition = InStr(strTemplate, "]")
	
	If StartBlockPosition = 0 Then
		Print Mid(strTemplate, 1) 
	Else
		Print Mid(strTemplate, 1, StartBlockPosition - 1)
		b = Mid(strTemplate, StartBlockPosition + 1, EndBlockPosition - (StartBlockPosition + 1))
		
		If Mid(b,1,1) = "/" Then
			Print "[" & Mid(b,2) & "]"
		Else
			Print ProcessFormBlock(b, SQL, Mode)
		End If
		
		ProcessFormLayout Mid(strTemplate, EndBlockPosition + 1), SQL, Mode
	End If
End Sub

Function GetFormLayout(strTemplate, SQL, Mode)
	StartBlockPosition = InStr(strTemplate, "[")
	EndBlockPosition = InStr(strTemplate, "]")
	
	If StartBlockPosition = 0 Then
		GetFormLayout = Mid(strTemplate, 1) 
	Else
		
		b = Mid(strTemplate, StartBlockPosition + 1, EndBlockPosition - (StartBlockPosition + 1))
		
		If Mid(b,1,1) = "/" Then
			b =  "[" & Mid(b,2) & "]"
		Else
			b = ProcessFormBlock(b, SQL, Mode)
		End If
		
		GetFormLayout = Mid(strTemplate, 1, StartBlockPosition - 1) & b & GetFormLayout(Mid(strTemplate, EndBlockPosition + 1), SQL, Mode)
	End If
End Function

Function ProcessFormBlock(strCommand, SQL, Mode)
	If Mid(strCommand, 1, 1) = "=" Then
		Execute("ProcessFormBlock = " & Mid(strCommand, 2))
		Exit Function
	End If
	'print Mid(strCommand, 1, 1)
	If Mid(strCommand, 1, 1) = "/" Then
		print  "ProcessFormBlock = " & Mid(strCommand, 2)
		Exit Function
	End If	
	CommandArray = Split(strCommand)
	
	Command = CommandArray(0)
	
	InputType = Null
	Value = Null
	Name = Null
	Style = Null
	CSSClass = Null
	ToolbarSet = Null
	Table = Null
	Headline = Null
	Options = Null
	Son = Null
	OnChange = Null
	Save = Null
	Maxlength = Null
	Rows = Null
	Columns = Null
	Format = Null
	Mail = Null
	Sendattachment = Null
	Mask = Null
	CheckAvailable = Null
	TakeFromFile = Null
	
	'Special Parameters
	Range = Null
	
	If Mode = "edit" Then
		Set objFormRS = OpenDB(SQL)
	End If
	
	If UBound(CommandArray) > 0 Then
		FirstTime = True
		
		For I = 1 To UBound(CommandArray)
			If FirstTime Then
				FirstTime = False
			Else
				ParamString = ParamString & " "
			End If
			
			ParamString = ParamString & CommandArray(i)		
		Next
		Parameters = Split(ParamString, ",")
	
		For Index = 0 To UBound(Parameters)
'print md5("abc")
			ParameterArray = Split(Parameters(Index), "=")
	
			Key = ParameterArray(0)
			
			Temp = Replace(ParameterArray(1), "~", ",")
	
			Execute("KeyValue = " & Temp)
			
			
			Select Case LCase(Key)
				Case "type"
					InputType = KeyValue 
				
				Case "value"
					Value = KeyValue 
					
				Case "name"
					Name = KeyValue 
					
				Case "style"
					Style = KeyValue
				
				Case "class"
					CSSClass = KeyValue
					
				Case "toolbarset"
					ToolbarSet = KeyValue
					
				Case "table"
					Table = KeyValue
				
				Case "headline"
					Headline = KeyValue
				
				Case "options"
					Options = KeyValue
					
				Case "son"
					Son = KeyValue
		
				Case "onchange"
					OnChange = KeyValue

				Case "range"
					Range = KeyValue
				
				Case "save"
					Save = KeyValue
				
				Case "maxlength"
					Maxlength = KeyValue
				
				Case "rows"
					Rows = KeyValue
				
				Case "columns"
					Columns = KeyValue
					
				Case "format"
					Format = KeyValue
			
				Case "mail"
				    Mail = KeyValue

				Case "mask"
					Mask = KeyValue
					
				Case "checkavailable"
				    CheckAvailable = KeyValue
				    
				Case "takefromfile"
				    TakeFromFile = KeyValue
			End Select
		Next
	End If
	
	If IsNull(InputType) Then
		InputType = "text"
	End If
	
	If IsNull(Name) Then
		Name = Command
	End If

	If Not IsNull(Range) Then
		Name = LCase(Range) & "_" & Name
	End If
	
	If IsNull(Value) And LCase(Name) <> "captcha" Then
		If Mode = "edit" Then
			Value = objFormRs(Command)
		ElseIf Mode = "" Or Mode = "admin" Then
			If Request(Name) <> "" And Request(Name) <> "0" Then Value = Request(Name)				
		End If
	End If

	If IsNull(Columns) Then
		Columns = 47
	End If
	
	If IsNull(Rows) Then
		Rows = 10
	End If
	 
	If IsNull(ToolbarSet) Then
		ToolbarSet = "Default"
	End If
	
	If IsNull(Format) And LCase(InputType) = "date" Then
		Format = "Date"
	End If
	
	If LCase(Format) = "date" Then
		Value = FormatDate(Value, "yyyymmdd")
	End If
    	If LCase(Format) = "now" Then
		Value = FormatDate(Value, "yyyymmdd")&" " & Time()
	End If

		If LCase(Format) = "showdate" Then
		Value = FormatDate(Value, "dd/mm/yyyy")
		Value = Replace(Value,"0/0/","")
	End If

	
	If Mode = "edit" Then
		CloseDB(objFormRS)
	End If
	
	If Mode = "add" Then
		If LCase(Save) = "session" Then
			Name = "_" & Name
		End If
		If LCase(Save) = "Cookies" Then
			Name = "_" & Name
		End If

	End If
	
	If Not IsNull(Mask) Then
		CSSClass = CSSClass & " _mask "
	End If
		
	ProcessFormBlock = GetInput(InputType, Name, Value, Style, CSSClass, ToolbarSet, Table, Headline, Options, Son, Mode, OnChange, Maxlength, Rows, Columns, Format, Mail, Mask, CheckAvailable, TakeFromFile)
End Function

Function GetInput(InputType, Name, Value, Style, CSSClass, ToolbarSet, Table, Headline, Options, Son, Mode, OnChange, Maxlength, Rows, Columns, Format, Mail, Mask, CheckAvailable, TakeFromFile)
	If LCase(Name) = "captcha" Then
		GetInput = "<input type=""text"" name=""CaptchaCode"" class=""" & CSSClass & """ /><img id=""imgCaptcha"" src=""captcha.asp"" />"
		Exit Function
	End If
	
	Select Case LCase(InputType)
		Case "editor"
			Dim editor : Set editor = New FCKeditor
			editor.BasePath = "/admin/FCKeditor/"
			editor.ToolbarSet = ToolbarSet
			
			editor.Value = Value
				
			GetInput = GetInput & editor.CreateHtml_Template(Name, Style)
		
		Case "image"
		Value = "/sites/" & Getconfig("ScriptPath") & "/Content/images/noimage.jpg"
			GetInput = GetInput & "<img id=""_" & Name & """ src=""resize.asp?mappath=true&path=" & Value & "&width=80""/><input type=""hidden"" name=""" & Name & """ id=""" & Name & """ value=""" & Value & """ /><input id=""upload_button_" & Name & """ type=""button"" onclick=""AjaxUpload('" & Name & "', 'img', 'image', 'images')"" value="""
			
			If Mode = "edit" Then
				GetInput = GetInput & "ערוך קובץ"
			Else
				GetInput = GetInput & "הוספת קובץ"
			end if 
			GetInput = GetInput & """ />"

		Case "file"
		
		Value = "/sites/" & Getconfig("Sitename") & "/Content/file/noimage.jpg"
			GetInput = GetInput & "<img id=""_" & Name & """ src=""" & Value & """/><input type=""hidden"" name=""" & Name & """ id=""" & Name & """ value=""" & Value & """ /><input id=""upload_button_" & Name & """ type=""button"" onclick=""AjaxUpload('" & Name & "', 'img', 'file', 'File')"" value="""
			
			If Mode = "edit" Then
				GetInput = GetInput & "ערוך קובץ"
			Else
				GetInput = GetInput & "הוספת קובץ"
			end if 
			GetInput = GetInput & """ />"
		Case "combo"
			GetInput = GetInput & "<select id=""" & Name & """ name=""" & Name & """"
			
			If IsNull(Son) Then
				GetInput = GetInput & " onchange=""" & OnChange & """"
			End If
			
			GetInput = GetInput & " style=""" & Style & """ class=""" & CSSClass & """"
			
			If Not IsNull(Son) Then
				GetInput = GetInput & " onchange=""javascript:EnableAjax('" & Son & "', '" & Name & "');"""
			End If
			
			GetInput = GetInput & ">" & vbCrLf
			
			If Not IsNull(HeadLine) Then
				GetInput = GetInput & "<option value=""0"""
				
				If Not IsNull(Value) Then
					GetInput = GetInput & " selected=""selected"""
				End If
					
				GetInput = GetInput & ">" & HeadLine & "</option>"
			End If
			
			If Not IsNull(TakeFromFile) Then
			    For Each opt In Split(GetUrl(TemplateLocation & "forms/" & TakeFromFile), vbCrLf)
					KeyValuePair = Split(opt, ";")
					If UBound(KeyValuePair) = 0 Then
						GetInput = GetInput & "<option value=""" & opt & """"
						If Mode = "edit" Or Mode = "" Or Mode = "admin" Then
							If IsNumeric(opt) And IsNumeric(Value) Then
								If Int(opt) = Int(value) Then
									GetInput = GetInput & " selected=""selected"""
								End If
							ElseIf opt = value Then
								GetInput = GetInput & " selected=""selected"""
							End If
						End If
												
						GetInput = GetInput & ">" & opt & "</option>"

					Else	
						GetInput = GetInput & "<option value=""" & KeyValuePair(0) & """"
						if (Not IsNull(VAlue)) then
						If IsNumeric(Value) Then
						    If  Mode = "edit" Or Mode = "" Or Mode = "admin" And Int(KeyValuePair(0)) = Int(Value) Then
    							GetInput = GetInput & " selected=""selected"""
						    End If
						Else
						    If  Mode = "edit" Or Mode = "" Or Mode = "admin" And KeyValuePair(0) = Value Then
    							GetInput = GetInput & " selected=""selected"""
						    End If
					End If
						end if
						GetInput = GetInput & ">" & KeyValuePair(1) & "</option>"
					End If			       
			    Next
			End If
			
			If Not IsNull(Options) Then
				For Each opt In Split(Options, "|")
					KeyValuePair = Split(opt, ";")
					If UBound(KeyValuePair) = 0 Then
						GetInput = GetInput & "<option value=""" & opt & """"
						If Mode = "edit" Or Mode = "" Or Mode = "admin" Then
							If IsNumeric(opt) And IsNumeric(Value) Then
								If Int(opt) = Int(value) Then
									GetInput = GetInput & " selected=""selected"""
								End If
							ElseIf opt = value Then
								GetInput = GetInput & " selected=""selected"""
							End If
						End If
												
						GetInput = GetInput & ">" & opt & "</option>"

					Else	
						GetInput = GetInput & "<option value=""" & KeyValuePair(0) & """"
						if (Not IsNull(VAlue)) then
						If IsNumeric(Value) Then
						    If  Mode = "edit" Or Mode = "" Or Mode = "admin" And Int(KeyValuePair(0)) = Int(Value) Then
    							GetInput = GetInput & " selected=""selected"""
						    End If
						Else
						    If  Mode = "edit" Or Mode = "" Or Mode = "admin" And KeyValuePair(0) = Value Then
    							GetInput = GetInput & " selected=""selected"""
						    End If
					End If
						end if
						GetInput = GetInput & ">" & KeyValuePair(1) & "</option>"
					End If
				Next
			ElseIf Not IsNull(Table) Then
				Set objRsCategory = OpenDB("Select * From [" & Table & "] Where SiteID = " & SiteID)
	 
				Do Until objRsCategory.Eof
					GetInput = GetInput & "<option value=""" & objRsCategory(0) & """"
					
					If Mode = "edit" Or Mode = "" Or Mode = "admin" Then
						If Int(objRsCategory(0)) = Int(Value) Then GetInput = GetInput & " selected=""selected"""
					ElseIf Mode="add" Then
						If Int(Request.QueryString(Name)) = Int(objRsCategory(0)) Then 
							   If Request.QueryString("EnableAjax") = "True" Then
							        abcdefghijklmnopqrstuvwxyz = "<script>EnableAjaxB('" & Son & "', '" & Name & "', " & Request.QueryString(Son) & ");</script>"
							   Else
							        abcdefghijklmnopqrstuvwxyz = ""
							   End If
							GetInput = GetInput & " selected=""selected"""
						End If 
					End If										
					GetInput = GetInput & ">" & objRsCategory(Table & "Name") & "</option>"
					objRsCategory.MoveNext
				Loop
			
				CloseDB(objRsCategory)
				    If Request.QueryString("EnableAjax") = "True" Then
				             GetInput = GetInput & abcdefghijklmnopqrstuvwxyz
				    End if
			End If
						
			GetInput = GetInput & "</select>"
			
			If (Not IsNull(Son)) And (Mode = "edit" Or Mode = "" Or Mode = "admin") Then
				GetInput = GetInput & "<script type=""text/javascript"">EnableAjax('" & Son & "', '" & Name & "');</script>"
			End If
		Case "date"
		GetInput = GetInput & "<input id=""" & Name & """ type=""" & InputType & """ name=""" & Name & """ value=""" & Value & """ style=""" & Style & """ class=""" & CSSClass & """ /><script type=""text/javascript"">jQuery(function() { jQuery(""#" & Name & """).datepicker({dateFormat: 'dd/mm/yy', isRTL: false}); });</script>"
		
		Case "splitedcheckbox"
			Set s_objRs = OpenDB("SELECT * FROM " & Table & " WHERE SiteId = " & SiteID)
			
			GetInput = GetInput & "<ul class=""" & CSSClass & """ style=""" & Style & """>"
			
			Do Until s_objRs.Eof
				GetInput = GetInput & "<li><input type=""checkbox"" name=""" & Name & """ value=""" & s_objRs(0) & """ /><span>" & s_objRs(1) & "</span></li>"
				s_objRs.MoveNext
			Loop
			
			GetInput = GetInput & "</ul>"
			
			CloseDB(s_objRs)
		Case "submit"
            GetInput = GetInput & "<input type=""" & InputType & """ value=""" & Value & """ style=""" & Style & """ class=""" & CSSClass& """ />"
	        SetSession "Mail", Mail

		case "hidden_add"
			
			GetInput = GetInput & "<input type="""
			
			If Mode = "add" Or Mode = "" Then
				GetInput = GetInput & "hidden"
			Else
				GetInput = GetInput & "text"
			End If
			
			GetInput = GetInput & """ name=""" & Name & """ id=""" & Name & """ value=""" & Value & """ readonly=""readonly"" />"
			
		Case "checkbox"
			GetInput = "<input id=""" & Name & """ type=""" & InputType & """ name=""" & Name & """ "
			
			If Int(Value) = 1 OR Value = "True" Then GetInput = GetInput & "checked=""checked"" "						
		
		    GetInput=GetInput&"/>"
		Case "radio"
			GetInput = "<input id=""" & Name & """ type=""" & InputType & """ value=""" & 0 & """ name=""" & Name & """ "
			
	    	GetInput = GetInput & "style=""" & Style & """ class=""" & CSSClass & """ />"
	    Case "imagebutton"
			GetInput = "<input type=""submit"" value="""" style=""background: transparent url(" & Value & ") no-repeat center top;" & Style & """ class=""" & CSSClass & """ />"
		Case "textarea"
	
			GetInput = "<textarea rows=""" & Rows & """ name=""" & Name & """ cols=""" & Columns &  """ style=""" & Style & """ class=""" & CSSClass & """ onKeyDown=""formTextCounter(this.form." & Name & ",this.form.remLen_" & Name & "," & MaxLength & ");"" onKeyUp=""formTextCounter(this,$('remLen_" & Name & "')," & MaxLength & ");"" wrap=""soft"">" & value & "</textarea><br><input readonly=""readonly"" type=""text"" name=""remLen_" & Name & """ size=""1"" maxlength=""3"" value=""" & MaxLength & """>"
		If Not IsNull(Value) Then
				GetInput = GetInput & "<script type=""text/javascript"">jQuery(document).ready(function($){ formTextCounter(this,$('#remLen_" & Name & "')," & MaxLength & ");});</script>"
			end if
		Case "multiradio"
			m_options = Split(Options, "|")
			
			For Each m_option in m_options
				m_key = Split(m_option, ";")(0)
				m_value = Split(m_option, ";")(1)
				
				GetInput = GetInput & "<input type=""radio"" name=""" & Name & """ value=""" & m_key & """"
				

				If Mode = "edit" And (m_key = Value Or (Value = "True" And m_key = "1") Or (Value = "False" and m_key = "0")) Then
					GetInput = GetInput & " checked=""checked"""
				End If
				
				GetInput = GetInput & ">" & m_value & " "
			Next
 		Case Else
			GetInput = "<input id=""" & Name & """ type=""" & InputType & """ name=""" & Name & """ onchange=""" & OnChange & """ maxlength=""" & Maxlength & """ value=""" & Value & """ style=""" & Style & """ class=""" & CSSClass & """ format=""" & Format & """ alt=""" & Mask & """/>"
		
			If LCase(CheckAvailable) = "true" And Not IsNull(Table) Then
			    GetInput = GetInput & "<div id=""ddd" & Name & """></div><script type=""text/javascript"">(function($) { $().ready(function() { var ddd= $('#ddd" & Name & "');var bbb = $('#" & Name & "').blur(function() { $.getJSON('/checkavailable.asp?value=' + $(this).val() + '&table=" & Table & "&field=" & Name & "', function(data) { if (data.isAvailable) { bbb.removeClass('e'); ddd.text(''); } else { bbb.addClass('e'); ddd.text('שם המשתמש תפוס כבר'); } });}); }); })(jQuery);</script>"
			End If
			
		End Select
End Function

' Processes template and prints it.
' NOTE: Currently this procedure isn't active.
Sub ProcessTemplate(TemplateURL, SQL)
	Set objRs = OpenDB(SQL)
	
	For Each Field In objRs.Fields
	response.write field.name & " - " & objrs(field.name) & "<br>"
	Next
	
	Print strTemplate
End Sub

' Prints text to the output.
Sub Print(text)
	Response.Write text
End Sub

'Getting a Remote URI and response it as text	
Function GetURL(strURL)
             If Request.QueryString("vafel")="true" then
                response.Write strURL
             End if
	set fs=Server.CreateObject("Scripting.FileSystemObject")
    if fs.FileExists(Server.MapPath(strURL))=true then		 
		Dim oIn : Set oIn = CreateObject("ADODB.Stream")        
		oIn.Open      
		oIn.CharSet = "Windows-1255"        
		oIn.LoadFromFile Server.MapPath(strURL)     
		oIn.Position = 0        
		oIn.CharSet = "UTF-8"        
		GetURL = oIn.ReadText        
		oIn.Close
	Else
		Print strURL & "  לא נמצא "
	End If
	set fs=nothing
End Function

' Sets session value.
Sub SetSession(key, value)
	Session(SiteID & key) = value
End Sub

' Gets session value.
Function GetSession(key)
	GetSession = Session(SiteID & key)
End Function

' Execute a page and prints it.
Sub ExecutePage(URL)
	Server.Execute URL
End Sub

Function GetNewsText(ID)
	Set objRsb = OpenDB("Select Text From [Block] Where [Block].id= " & ID)
	GetNewsText = objRsb("Text")
	CloseDB(objRsb)
End Function

Function GetBlockImage(ID)
	Set objRsi = OpenDB("Select image From [Block] Where [Block].ID= " & ID)
	GetBlockImage =  objRsi("image") 
	CloseDB(objRsi)
End Function

Function GetBlocktitle(ID)
	Set objRstt = OpenDB("Select Name From [Block] Where [Block].ID= " & ID)
	GetBlocktitle = objRstt("Name")
	CloseDB(objRstt)
End Function

Function PostTo(Data, URL)
  Dim objXMLHTTP, xml
  On Error Resume Next
  Set xml = Server.CreateObject("MSXML2.ServerXMLHTTP.3.0")
  xml.Open "POST", URL, False
  xml.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
  xml.Send Data
  If xml.readyState <> 4 then
    xml.waitForResponse 10
  End If
  If Err.Number = 0  AND http.Status = 200 then
    PostTo = xml.responseText
  else
    PostTo = "Failed"
  End If
  Set xml = Nothing
End Function

Sub SendSMS(Recipients, Message,sender)
	if sender = "" Then
        SenderNumber = "3333"
    Else
        SenderNumber = sender
    End If
	xml = "<Inforu><User><Username>Username</Username><Password>Password</Password></User><Content Type=""sms""><Message>" & Message & "</Message></Content><Recipients><PhoneNumber>" & Recipients & "</PhoneNumber></Recipients><Settings><SenderNumber>" & SenderNumber & "</SenderNumber></Settings></Inforu>"
    
	PostTo "InforuXML=" & Server.URLEncode(xml), "http://sms.inforu.co.il/Interfaces/SendMessageXml.aspx"
	If UBound(Split(Recipients, ";"))> 0 Then
	    ExecuteRS("Update Site Set smscredit = smscredit - " & UBound(Split(Recipients, ";")) & " Where SiteID = " & SiteID)
	Else
	    ExecuteRS("Update Site Set smscredit = smscredit - 1 Where SiteID = " & SiteID)
	End If
End Sub

Sub PrintFormBlock(ID, Mode)


Set objRsForm = OpenDB("Select * From [Forms] Where [Forms].Id = " &  ID)
Dim Action : Action = LCase(objRsForm("Action"))
If objRsForm("IsAjax") = "True" Then
	IsAjax = True
Else
	IsAjax = False
End If
			If IsAjax = True Then
			%>
			<div>
			<%
			End If 
			%>
				<form class="<% If objRsForm("IsAjax") = "True" Then %>_ajax_form<% Else %>_validate<% End if %>" method="<% If Mode = "add" Then %>post<% Else %>get<% End If %>" action="<% = Action %>">
				<input type="hidden" name="FormID" value="<% = ID %>" />
				<% If objRsForm("IsAjax") = "True" Then %><input type="hidden" name="Ajax" value="True" /><% End if %>

				
				<% If Mode = "add" Then %>
				<input type="hidden" name="IsSubmitted" value="true" />
				<input type="hidden" name="m" value="add" />
				<% End If %>
			
				<% ProcessFormLayout GetURL(objRsForm("TemplateURL")), SQL, Mode %>
			</form>
			<% If IsAjax = True Then %></div><% End If %>
		<%
End Sub



Function NewPager
 %>
	<link rel="stylesheet" href="<% = Templatelocation %>style/pager.css" type="text/css"  />
	<%
If Request.QueryString("p")<>"" Then
    Action = ReplaceSpaces(Request.QueryString("p"))
    
			QS = Request.QueryString
			QS = Replace(QS, QS, "")
Else
    If Request.querystring("type") ="" Then 
        
        Stype = 1
    else
        Stype = Request.querystring("type")
    End If
            Action = ReplaceSpaces(Request.ServerVariables(URL))
End if
			
			nPage = Int(Request.QueryString("Page"))
			If nPage <= 0 Then
				nPage = 1
			End If
            print "<Div id=""pager""><ul class=""pages"">"
			If nPage > 1 Then
				print "<li class=""first""><a href=""" & Action & "" & QS & """>" &  SysLang("first") & "</a>"
				print "<li class=""prev""><a href=""" & Action & "" & QS & "&Page=" & (nPage - 1) & """>" &  SysLang("prevpage") & "</a>"
						for a=nPage-5 to nPage -1
						    if a > 0 then
			  	                If a = 1 then
                                    print "<li class=""page-number""><a href=""" & Action & "" & QS & """> " & a & " </a>"
                                Else
                                    print "<li class=""page-number""><a href=""" & Action & "" & QS & "&Page=" & (a) &  """> " & a & " </a>"
                                End if
                            end if
                        next
			End If
				print "<li class=""page-number pgCurrent""><a href=""" & Action & "" & QS & "&Page=" & (nPage) &  """> " & nPage & " </a></li>"
		
			            for b=nPage+1 to Int(GetSession("PageCount"))
			                if b < nPage+5 then
				              print "<li class=""page-number""><a href=""" & Action & "" & QS & "&Page=" & (b) &  """> " & b & " </a></li>"
                            end if
                        next
			
			If nPage < Int(GetSession("PageCount")) Then
				print"<li class=""next""><a href=""" & Action & "" & QS & "&Page=" & (nPage + 1)  & """>" & SysLang("nextpage") & "</a>"  
				print "<li class=""last""><a href=""" & Action & "" & QS & "&Page=" & (Int(GetSession("PageCount")))  & """>" &  SysLang("last") & "</a>"  
			End If	
            print  "</ul></Div>"


End Function

Function GetCategory(ID)
SQLt= "Select Categorytemplate, Sonsrecords, Sonsshowpager, Sonsorder, Sonscategoryrecords, Categoryorder From content where Id =" & ID
Set objRt = openDB(SQLt)
Categorytemplate = objRt("Categorytemplate")
Sonsrecords = objRt("Sonscategoryrecords")
Sonsshowpager = objRt("Sonsshowpager")
Sonsorder = objRt("Sonsorder")
Categoryorder = objRt("Categoryorder")
CloseDB(objRt)
                SQLsons = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & ID & ") AND Content.SiteID=" & SiteID & " AND ((Contenttype < 3) OR (Contenttype = 4)) Order By " & Categoryorder 
                Set objRssons = openDB(SQLsons)
               
               If objRssons.recordcount > 0 then
                    objRssons.PageSize = Sonsrecords
                    SetSession "PageCount", objRssons.PageCount
				    nPage = Int(Request.QueryString("Page"))
					    If nPage <= 0 Then
						    nPage = 1
					    End If
			       objRssons.AbsolutePage = nPage
                   CatTemplateURL = Categorytemplate
                   print  sonTemplateURL
                   z = 0
                    Do While NOT objRssons.eof AND z < Sonsrecords
                    sontemplate = GetURL(CatTemplateURL)
                        SQLson = "Select * From Content Where id=" & objRssons("id") & " And SiteID=" & SiteID
                        Set objRsson = openDB(SQLson)
                       if z mod 2 = 0 then
                            zebraclass = "odd"
                        else
                            zebraclass = "even"
                        end if

                        SQLf = "SELECT [Content].Name FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.FatherID WHERE (Contentfather.ContentID = " & objRsson("Id") & ") AND Content.SiteID=" & SiteID & " AND (Contenttype < 3 )  ORDER By ItemOrder ASC"
                        Set objRf = openDB(SQLf)
                            If objRf.Recordcount>0 then
                                father = objRf("Name")
                            End if
                        CloseDB(objRf)




					        For Each Field In objRsson.Fields
					             value = objRsson(Field.Name)
						        If Len(value) > 0 Then
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", value)
							        sontemplate = Replace(sontemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
							        sontemplate = Replace(sontemplate, "[zebraclass]", zebraclass)
							        sontemplate = Replace(sontemplate, "[father]", father)
						        Else
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(sontemplate)
                        CloseDB(objRsson)
                     z =z +1
                    objRssons.MoveNext
                        loop
                    If Sonsshowpager = True Then
                        Newpager
                    End if
                 End if
                CloseDB(objRssons)
End Function


'///////////GetCategoryPerDay//////////////////////
Function GetCategoryPerDay(ID)
    set fs = CreateObject("Scripting.FileSystemObject")
    n = -1
    i=0
    If fs.FileExists(Server.MapPath(templatelocation & "data/tipoftoday.txt")) Then
		set f = fs.OpenTextFile(Server.MapPath(templatelocation & "data/tipoftoday.txt"), 1, false)
		If not f.AtEndOfStream then
			k = Split(f.ReadAll(), ",")
			f.close

			if ubound(k) >= 1 then
                i = k(2)
				if cdate(k(0)) = date() then
					SQLPerDay = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE [Content].Id = " & k(1) & " AND (Contentfather.FatherID = " & ID & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)  ORDER By ItemOrder ASC"
					n = -2
				else
					
				end if
			end if
		end if
    ENd If

    if n = -1 then
					SQLPerDay = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & ID & ") AND (Content.Itemorder = " & i & ") AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)"
    end if
    
                Set objRsPerDay = openDB(SQLPerDay)
	                Maxrecords = objRsPerDay.Recordcount
			        If i = Maxrecords then i=0
                    if n <> -2 then
					
                        set g = fs.OpenTextFile(Server.MapPath(templatelocation & "data/tipoftoday.txt"), 2, true)
                        g.Write(Date() & "," & objRsPerDay(0) & "," & i+1)
                        g.close
                    end if

                    PerDaytemplate = GetURL(Templatelocation & "CategoryPerDay.html")
                            For Each Field In objRsPerDay.Fields
					             value = objRsPerDay(Field.Name)
						        If Len(value) > 0 Then
							        PerDaytemplate = Replace(PerDaytemplate, "[" & Field.Name & "]", value)
							        PerDaytemplate = Replace(PerDaytemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
						        Else
							        PerDaytemplate = Replace(PerDaytemplate, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(PerDaytemplate)
                        CloseDB(objRsPerDay)
End Function
'///////////GetCategoryPerDay//////////////////////

Function GetCampaign(ID)
		Set objRscamp = OpenDB("SELECT TOP 1 * FROM banners WHERE bannerscategoryID = " & ID & " AND ((floor(convert(real,GetDate())) >= floor(convert(real,startdate)) And startdate IS NOT NULL) OR startdate IS NULL) AND ((floor(convert(real,GetDate())) <= floor(convert(real,enddate)) And enddate IS NOT NULL) OR enddate IS NULL) And SiteID = " & SiteID & " Order By NEWID()")
	        Set objRsCategory = OpenDB("SELECT Width, Height ,active FROM bannerscategory WHERE ID=" & ID)
	
	If objRscamp.RecordCount > 0 Then
		if objRsCategory("active") = True then
    print "<div>"
	    if objRscamp("Type") = 1 then
	        if objRscamp("Link") <> "" Then  print "<a href=/redirect.asp?ID=" & objRscamp("ID")& " target=" & objRscamp("target") & ">"
	        print "<img src=""" & objRscamp("Src") & """ width="& objRsCategory("Width") &" height=" & objRsCategory("Height") &" border=""0"" />"
	        if objRscamp("Link") <> "" Then
	        print "</a>"
	        End If
	    Elseif objRscamp("Type") = 2 then
	         print "<embed  height=" & objRsCategory("Height") &" width=" & objRsCategory("width") & " align=""middle"" type=""application/x-shockwave-flash"" pluginspage=""http://www.macromedia.com/go/getflashplayer"" allowscriptaccess=""sameDomain"" wmode=""opaque"" quality=""high"" src=" & objRscamp("Video") & " name=" & objRscamp("Video") & "/>"
	    Elseif objRscamp("Type") = 3 then
	         print  objRscamp("Html") 
		Elseif objRscamp("Type") = 4 then
	   print "<div style=""position: relative; width: 160px; height: 600px;"">"
	   print "<a target=""_blank"" href=""" & objRscamp("Link") & """ style=""display: block;"">"
	   print "<img height="& objRsCategory("Height") & " width="& objRsCategory("width") &" src=""/images/space.gif""  style=""position: absolute; right: 0px;"" /></a>"
	   print "<embed height="& objRsCategory("Height") &" width="& objRsCategory("width") &" align=""middle"" type=""application/x-shockwave-flash"" pluginspage=""http://www.macromedia.com/go/getflashplayer"" allowscriptaccess=""sameDomain"" wmode=""opaque"" quality=""high"" src="& objRscamp("Video")& " name="  & " name=" & objRscamp("Video") & "></embed></div>"
	   End If 
	print "</div>"
	End If 

	objRscamp("Shows") = objRscamp("Shows") + 1
	objRscamp.Update
	End If	

	objRsCategory.Close  
	objRscamp.Close  
End Function



Function Getgallerys(ID)
	Set objRsgal = OpenDB("Select * From [Content] Where [Content].ID= " & ID)
    ProcessLayout GetURL(objRsgal("other3"))
    If objRsgal("other5") = 1 then  ' להציג את כל הספרייה
        Set MyFileObject=Server.CreateObject("Scripting.FileSystemObject")
        Set MyFolder=MyFileObject.GetFolder(phisicalpath & Getconfig("Sitename") & "\content\images\" & objRsgal("other1") & "\" )
             FOR EACH thing in MyFolder.Files
			        FileName=thing.Name
			        imagelink= "sites/" & Getconfig("Sitename") & "/content/images/" & objRsgal("other1") & "/" & FileName
					    Template = GetURL(objRsgal("other2"))
                        Template = Replace(Template, "[Image]", imagelink)
						Template = Replace(Template, "[Name]", FileName)
			 		ProcessLayout(Template)
                Next
    Else
        SQLp = "SELECT * FROM [Photos] WHERE PhotosgalleryID=" & ID & " Order By " & objRsgal("other6")
        Set objRsP = OpenDB(SQLp)
			If objRsP.RecordCount = 0 Then
				print "אין תמונות"
            Else
			            Do While NOT objRsP.Eof
                                            Template = GetURL(objRsgal("other2"))
            		            For Each Field In objRsP.Fields
					                value = objRsP(Field.Name)
                    	                If Len(value) > 0 Then
							                Template = Replace(Template, "[" & Field.Name & "]", value)
							                Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
						                Else
							                Template = Replace(Template, "[" & Field.Name & "]", "")
						                End If
					            Next
							 ProcessLayout(Template)
                        objRsP.movenext
                            loop
            End If
    End If


	ProcessLayout GetURL(objRsgal("other4"))
End Function





Function GetProductCategorys(ID)
	Set objRs = OpenDB("Select * From [ProductCategory] Where [ProductCategory].ProductCategoryID= " & ID)
	SetSession "ProductCategoryID", ID
	ExecutePage "/blocks/productcategorys.asp"  
	CloseDB(objRs)
End Function

Function GetvideoCategory(ID)
	Set objRs = OpenDB("Select * From [videocategory] Where [videocategory].videocategoryID= " & ID)
	SetSession "videocategoryID", ID
	ExecutePage "/blocks/videocategory.asp"  
	CloseDB(objRs)
End Function

Function GetRss(ID)
	SetSession "rssID", ID
	ExecutePage "/blocks/rss.asp"  
End Function

Function Autolink(Text)
	TempText = Text
	Set alRS= OpenDB("SELECT * FROM Autolink Where SiteID=" & SiteID)
	Do Until alRS.Eof
		TempText = replace(TempText,alRS("Name"),"<a href='"&alRS("Url")&"'>"&alRS("Name")&"</a>",1,alRS("Count"))
		alRS.MoveNext
	Loop
	Autolink = TempText
End Function

Function GetNews(ID)
 
    Set objRsCategory = OpenDB("SELECT * FROM NewsCategory Where ID = " & ID & " AND SiteID=" & SiteID)
    	print GetURL(objRsCategory("Header"))
    	NewsTemplateURL = objRsCategory("Template") 
    	NewsBottomTemplate = GetURL(objRsCategory("footer"))
        LangID = objRsCategory("LangID")
        OrderType = objRsCategory("ordertype")
        
    CloseDB(objRsCategory)
    SQLNews = "SELECT * FROM News Where SiteID = " & SiteID & " AND ((floor(convert(real,GetDate())) >= floor(convert(real,FromDate))"
    SQLNews = SQLNews & " And FromDate IS NOT NULL) OR FromDate IS NULL) AND ((floor(convert(real,GetDate())) <= floor(convert(real,ToDate))"
     SQLNews = SQLNews & " And ToDate IS NOT NULL) OR ToDate IS NULL) AND LangID = '" & Session("SiteLang") & "' ORDER BY " & OrderType
    Set objRsNews = OpenDB(SQLNews)
	    If objRsNews.RecordCount = 0 Then
		    GetNews = "אין חדשות לתצוגה"
		    CloseDB(objRsNews)
		    Exit Function
	    End If
	Do While Not objRsNews.EOF
	
		If Not IsNull(Trim(objRsNews("CategoryID"))) Then
			IDArray = Split(objRsNews("CategoryID"), ",")
			
			Continue = False
			
			For Each TheID In IDArray
				If Int(TheID) = ID Then Continue = True
		    Next
			
			If Continue Then
	
	            If Not objRsNews("Link")= "" then
		            thelink=objRsNews("Link")
	            Elseif Not objRsNews("ContentLink")= "" then
		            thelink="Sc.asp?ID=" & objRsNews("ContentLink")
	            Else
		            thelink=""
	            End if
			        Template = GetURL(NewsTemplateURL)
			
			        For Each Field In objRsNews.Fields
				      
						value = objRsNews(Field.Name)
				
				        If Len(value) > 0 Then
					        Template = Replace(Template, "[" & Field.Name & "]", value)
					        Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
					            If thelink <> "" Then
					                Template = Replace(Template, "[link_" & Field.Name & "]","<a href=" &  thelink & ">" & value & "</a>")
					            else
								
					                 Template = Replace(Template, "[link_" & Field.Name & "]", value)
					            End If

				        End If
			        Next
			
			Response.Write Template
			End If
		End If

			
	objRsNews.MoveNext

Loop

    	print NewsBottomTemplate

CloseDB(objRsNews)

End Function




Function GetProductCategory(ID)
	Set objRs = OpenDB("Select * From [ProductCategory] Where [ProductCategory].ProductCategoryID= " & ID)
	SetSession "ProductCategoryID", ID
	ExecutePage "/blocks/productcategory.asp"  
	CloseDB(objRs)
End Function

Function Getsitemapcategory(ID)
	SetSession "SiteMapCategory", ID
	ExecutePage "/blocks/SiteMap.asp"  
End Function


Function GetMenu(ID)
	Set objRsMenuCategory = OpenDB("Select * From [Menu] Where ID = " & ID)
	Session("menutype") = objRsMenuCategory("Type")
	If objRsMenuCategory.RecordCount = 0 Then
		print  "תפריט  " & ID & " לא נמצא במערכת."
		Exit Function
	End If
	    If Int(objRsMenuCategory("Type")) = 1 Then
           print vbcrlf &  "<ul class=""sf-menu" & ID & """>"& vbcrlf
        End If
        If Int(objRsMenuCategory("Type")) = 2 Then
            print vbcrlf &  "<ul class=""sf-menu" & ID & " sf-vertical"">"& vbcrlf
        End If
        If Int(objRsMenuCategory("Type")) =3 Then 'from template
            ProcessLayout(GetURL(objRsMenuCategory("Header")))
            ' ProcessLayout(GetURL(objRsMenuCategory("Template")))
                     buildtree 0, ID,0,objRsMenuCategory("Maxmenulevel")
            ProcessLayout(GetURL(objRsMenuCategory("Footer")))
     ' response.end
        End If
        If Int(objRsMenuCategory("Type")) <> 3 Then 'from template
             buildtree 0, ID,0,objRsMenuCategory("Maxmenulevel")
             'print "</ul>"
        End if
	CloseDB(objRsMenuCategory)
End Function

Function buildtree(Fid, menu, level,Maxmenulevel)
   oldlevel = level

        SQLm = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE   LangID = '" & Session("SiteLang") & "' AND (Contentfather.FatherID = " & Fid & ") AND (Content.SiteID = " & SiteID & ") AND (Menus != '') ORDER By Menusorder ASC"
        
           Set objRsm = OpenDB(SQLm)
	If objRsm.RecordCount = 0 Then
		 print   "לא נמצאו כפתורים בתפריט בעל מספר יחודי  " & Fid
		   Exit Function
	End If
    v=1
        Do while Not objRsm.EOF
        If Not IsNull(Trim(objRsm("Menus"))) Then
			IDArray = Split(objRsm("Menus"), ",")
			
			Continue = False
			
			For Each TheID In IDArray
				If Int(TheID) = menu Then Continue = True
			Next
			If v = 1 Then
				x= "first"
			ElseIf objRsm.AbsolutePosition = objRsm.RecordCount Then
				x= "last"
			Else
				x= "btn" & v
			End If
            y=""
            If    Url ="/Default.asp" AND Getconfig("HomePageID") = objRsm("id") Or LCase(Request.QueryString("p")) = Replace(LCase(objRsm("Urltext")), " ", "-") Then
              
                If Session("menutype") = 3 Then
                    y =  " expand"
                Else
                    y =  " active"
                End if
			End If

			If Continue Then
            Urltext = objRsm("Urltext")
                        slash = ""
                    If Urltext <> "/" then
                        slash = "/"
                    End If 
                If Left(Urltext,4) = "http" then
                        slash = ""
                End if
                        If objRsm("Menuislink") = True Then
		                    print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & slash & ReplaceSpaces(Urltext) & """>" & objRsm("Menusname")  & "</a>"
                        Else
		                    print vbCrLf & "  <li class=""" & x &  y & """><a style=""cursor:default;"" href=""#"">" & objRsm("Menusname") & "</a>"
                        End If
            End If
        End If
                SQLson = "SELECT TOP 1 [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE LangID = '" & Session("SiteLang") & "' AND (Contentfather.FatherID = " & objRsm("id") & ") AND (Content.SiteID = " & SiteID & ")AND  (Menus != '') ORDER By Menusorder ASC"
               'print SQLson
                Set objRsSon = OpenDB(SQLson)
                     If objRsSon.Recordcount > 0 AND (level < Maxmenulevel) Then
                       If Continue Then
                                   If Session("menutype") = 3 Then
                                       If  GetSession("contentiD") <> "" Then
                                            Set objRsfa =  OpenDB("SELECT * FROM [Contentfather]  WHERE ContentID=" &  GetSession("contentiD"))
                                        Else
                                            Set objRsfa =  OpenDB("SELECT * FROM [Contentfather]  WHERE ContentID=" &  objRsSon("Id"))
                                        End if
                                          
                                            If objRsfa("FatherID")= objRsm("Id") then
                                                 actives = " expand" 
                                            Else
                                                 actives = " acitem" 
                                            End If
                                        CloseDB(objRsfa)  
                                        print  vbCrLf & "    <ul class=" & actives & ">" 
                                   Else
                                        print  vbCrLf & "    <ul>" 
                                    End if
                        End if
                             level= level +1
                            buildtree objRsm("id"), menu ,level,Maxmenulevel
                            level  = oldlevel
                            If Continue Then
                                print "</li>" & vbCrLf
                            End If  
                    Else
                            If Continue Then
                                print "</li>" & vbCrLf
                            End if
                    End if
			    If Continue Then
                    v=v+1
                End If
        objRsm.MoveNext
	        Loop

    If Continue Then
        print "</ul>" & vbCrLf
        level = oldlevel

	End If            		
	    CloseDB(objRsm)	

End Function

Function GetConfig(str)
	GetConfig = Application(ScriptName & str)
End Function

Function GetShopConfig(str)
	GetShopConfig = Application(ScriptName & str)
End Function


'Reading the content of a file
Function GetFile(path)
    GetFile = GetUrl(TemplateLocation & path)
End Function

Sub PrintTableCombo(TableName)
	Set objRsTable = OpenDB("Select * From [" & TableName & "] Where SiteID = '" & SiteID & "'")
	
	Print "<select class=""validate-selection"" name=""" & objRsTable.Fields(0).Name & """>" & vbCrLf
	Print "<option value=""0"" selected=""selected"">ללא</option>"

	Do Until objRsTable.Eof
		Print "<option value=""" & objRsTable(0) & """>" & objRsTable(1) & "</option>"
		objRsTable.MoveNext
	Loop
	
	Print "</select>"
	
	CloseDb(objRsTable)
End Sub

Function PrintTableComboFunction(TableName)
	Set objRsTable = OpenDB("Select * From [" & TableName & "] Where SiteID = '" & SiteID & "'")
	
	returnValue = returnValue & "<select name=""" & objRsTable.Fields(0).Name & """>" & vbCrLf
	returnValue = returnValue & "<option value=""0"" selected=""selected"">???</option>"

	Do Until objRsTable.Eof
		returnValue = returnValue & "<option value=""" & objRsTable(0) & """>" & objRsTable(1) & "</option>"
		objRsTable.MoveNext
	Loop
	
	returnValue = returnValue & "</select>"
	
	PrintTableComboFunction = returnValue
	CloseDb(objRsTable)
End Function

Function AsciiToUnicode(ByRef pstrAscii)
	For llngIndex = 1 To LenB(pstrAscii)
		lstrUnicode = lstrUnicode & Chr(AscB(MidB(pstrAscii, llngIndex,1)))
	Next

    AsciiToUnicode = lstrUnicode

End Function

Function getsonmenu(ID)

    SQLf = "Select FatherID From Contentfather Where ContentID=" & ID & " AND SiteID=" & SiteID
    Set objRsf = OpenDB(SQLf)
    If objRsf.Recordcount > 0 Then
        fFatherID = objRsf("FatherID")
    End If
    CloseDB(objRsf)
 SQLm = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & iD & ") AND (Contentfather.SiteID = " & SiteID & ") AND (Content.Active = 1) AND LangID = '" & Session("SiteLang") & "' ORDER By ItemOrder ASC"
    Set objRsm = OpenDB(SQLm)
	If objRsm.RecordCount = 0 Then
            getsonmenu(fFatherID)
               Exit Function
	End If
	    print vbcrlf &  "<ul class=""sf-menu2 sf-vertical"">"& vbcrlf

        Do while Not objRsm.EOF
		y = ""
        If   LCase(Request.QueryString("p")) = Replace(LCase(objRsm("Urltext")), " ", "-") Then
            y = " active"
        End if
			Continue = False
				If objRsm("Showinsonmenu") = True Then 
		            print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & ReplaceSpaces(objRsm("Urltext")) & """>" & objRsm("Menusname") & "</a></li>"
                End If
        objRsm.movenext
            loop
       print  vbCrLf & "</ul>" 
	    CloseDB(objRsm)		
End Function

Function getsononlymenu(ID)

    SQLf = "Select FatherID From Contentfather Where ContentID=" & ID & " AND SiteID=" & SiteID
    Set objRsf = OpenDB(SQLf)
    If objRsf.Recordcount > 0 Then
        fFatherID = objRsf("FatherID")
    End If
    CloseDB(objRsf)
 SQLm = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & iD & ") AND (Contentfather.SiteID = " & SiteID & ") AND (Content.Active = 1) AND LangID = '" & Session("SiteLang") & "' ORDER By ItemOrder ASC"
    Set objRsm = OpenDB(SQLm)
	'If objRsm.RecordCount = 0 Then
           ' getsononlymenu(fFatherID)
              ' Exit Function
	'End If
	    print vbcrlf &  "<ul class=""sf-menu2 sf-vertical"">"& vbcrlf

        Do while Not objRsm.EOF
		y = ""
        If   LCase(Request.QueryString("p")) = Replace(LCase(objRsm("Urltext")), " ", "-") Then
            y = " active"
        End if
        
        	Continue = False
				If objRsm("Showinsonmenu") = True Then 
		            print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & ReplaceSpaces(objRsm("Urltext")) & """>" & objRsm("Menusname") & "</a></li>"
                End If
        objRsm.movenext
            loop
       print  vbCrLf & "</ul>" 
	    CloseDB(objRsm)		
End Function


Function getsonsamelevelmenu(ID)

    SQLf = "Select FatherID From Contentfather Where ContentID=" & ID & " AND SiteID=" & SiteID
    Set objRsf = OpenDB(SQLf)
    If objRsf.Recordcount > 0 Then
        fFatherID = objRsf("FatherID")
    End If
    CloseDB(objRsf)
 SQLm = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & fFatherID & ") AND (Content.Active = 1) AND (Contentfather.SiteID = " & SiteID & ") AND LangID = '" & Session("SiteLang") & "' ORDER By ItemOrder ASC"
    Set objRsm = OpenDB(SQLm)
	If objRsm.RecordCount = 0 Then
            getsonsamelevelmenu(fFatherID)
               Exit Function
	End If
	    print vbcrlf &  "<ul class=""sf-menu2 sf-vertical"">"& vbcrlf

        Do while Not objRsm.EOF
		y = ""
        If   LCase(Request.QueryString("p")) = Replace(LCase(objRsm("Urltext")), " ", "-") Then
            y = " active"
        End if
			Continue = False
				If objRsm("Showinsonmenu") = True Then 
		            print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & ReplaceSpaces(objRsm("Urltext")) & """>" & objRsm("Menusname") & "</a></li>"
                End If
        objRsm.movenext
            loop
       print  vbCrLf & "</ul>" 
	    CloseDB(objRsm)		
End Function

Function getfathermenu(ID)
    
    SQLf = "Select FatherID From Contentfather Where ContentID=" & ID & " AND SiteID=" & SiteID
    Set objRsf = OpenDB(SQLf)
    If objRsf.Recordcount > 0 Then
        fFatherID = objRsf("FatherID")
    End If
    CloseDB(objRsf)

    SQLg = "Select FatherID From Contentfather Where ContentID=" & fFatherID & " AND SiteID=" & SiteID
    Set objRsg = OpenDB(SQLg)
    If objRsg.Recordcount > 0 Then
        gfFatherID = objRsg("FatherID")
    End If
    CloseDB(objRsg)

     SQLT = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & ID & ") AND (Contentfather.SiteID = " & SiteID & ") AND LangID = '" & Session("SiteLang") & "' ORDER By ItemOrder ASC"
      Set objRsT = OpenDB(SQLT)
      If objRsT.Recordcount > 0 then
            SQLu = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & gfFatherID & ") AND (Contentfather.SiteID = " & SiteID & ") AND LangID = '" & Session("SiteLang") & "' ORDER By ItemOrder ASC"
      Else
            SQLu = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & gfFatherID & ") AND (Contentfather.SiteID = " & SiteID & ") AND LangID = '" & Session("SiteLang") & "' ORDER By ItemOrder ASC"
	    End If
       Set objRsu = OpenDB(SQLu)
	    print vbcrlf &  "<ul class=""sf-menu2 sf-vertical"">"& vbcrlf

        Do while Not objRsu.EOF
					y = ""
        If   LCase(Request.QueryString("p")) = Replace(LCase(objRsu("Urltext")), " ", "-") Then
            y = " active"
        End if

			Continue = False
				If objRsu("Showinsonmenu") = True Then 
		            print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & ReplaceSpaces(objRsu("Urltext")) & """>" & objRsu("Menusname") & "</a></li>"
                End If
        objRsu.movenext 
            loop
       print  vbCrLf & "</ul>" 
	    CloseDB(objRsu)		
End Function
'acordion same level menu

Function getsamelevelaccmenu(ID)
 ProcessLayout(GetURL(templatelocation & "accordion/Header.html"))
    buildsamelevel ID
End Function

lastid = 0 
Function toplevel(dFid)
    SQLf = "Select FatherID,ContentID From Contentfather Where ContentID=" & dFid & " AND SiteID=" & SiteID
    Set objRsf = OpenDB(SQLf)
	If cint(objRsf("FatherID")) <> 0 Then
      lastid = objRsf("FatherID")
	  toplevel objRsf("FatherID")
	 End If
	 if lastid = 0 then lastid = dFid
	toplevel = lastId
   CloseDB(objRsf)
End function

Function buildsamelevel(Fid)
      idf =   toplevel(Fid)
 SQLm = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & idf & ") AND (Content.Active = 1) AND (Contentfather.SiteID = " & SiteID & ") AND LangID = '" & Session("SiteLang") & "' ORDER By ItemOrder ASC"
   Set objRsm = OpenDB(SQLm)
	If objRsm.RecordCount = 0 Then
            buildsamelevel(idf)
               Exit Function
	End If
    v=1
        Do while Not objRsm.EOF
			If v = 1 Then
				x= "first"
			ElseIf objRsm.AbsolutePosition = objRsm.RecordCount Then
				x= "last"
			Else
				x= "btn" & v
			End If
            y=""
            If    Url ="/Default.asp" AND Getconfig("HomePageID") = objRsm("id") Or LCase(Request.QueryString("p")) = Replace(LCase(objRsm("Urltext")), " ", "-") Then
                     y =  " expand"
   			End If
                Set objRsr = OpenDB("Select FatherID From Contentfather Where ContentID=" & Getsession("contentiD"))
                If  objRsr("FatherID") = objRsm("id")Then y =  " expand"
                CloseDB(objRsr)
            If objRsm("Showinsonmenu") = True Then
            Urltext = objRsm("Urltext")
                        slash = ""
                    If Urltext <> "/" then
                        slash = "/"
                    End If 
                If Left(Urltext,4) = "http" then
                        slash = ""
                End if
		                print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & slash & ReplaceSpaces(Urltext) & """>" & objRsm("Menusname") & "</a>"
            End If
                SQLson = "SELECT TOP 1 [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE LangID = '" & Session("SiteLang") & "' AND (Contentfather.FatherID = " & objRsm("id") & ") AND (Content.SiteID = " & SiteID & ")AND  (Menus != '') ORDER By Menusorder ASC"

                Set objRsSon = OpenDB(SQLson)
                     If objRsSon.Recordcount > 0 Then
                       If objRsm("Showinsonmenu") = True Then
                                        print  vbCrLf & "    <ul class=""acitem"">" 
                        End if
							buildsontree objRsm("id") 
                           If objRsm("Showinsonmenu") = True Then
                                print "</li>" & vbCrLf
                            End If  
                    Else
                            If objRsm("Showinsonmenu") = True Then
                                print "</li>" & vbCrLf
                            End if
                    End if
			    If objRsm("Showinsonmenu") = True Then
                    v=v+1
                End If
        objRsm.MoveNext
	        Loop
	    CloseDB(objRsm)	
         ProcessLayout(GetURL(templatelocation & "accordion/footer.html"))
	
End Function

'end acordion same level menu



'acordion son menu

Function getsonaccmenu(ID)
 ProcessLayout(GetURL(templatelocation & "accordion/Header.html"))
    buildsontree ID
End Function

Function buildsontree(Fid)
        SQLm = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE   LangID = '" & Session("SiteLang") & "' AND (Contentfather.FatherID = " & Fid & ") AND (Content.SiteID = " & SiteID & ") AND (Menus != '') ORDER By Menusorder ASC"
        'print SQLm
           Set objRsm = OpenDB(SQLm)
	If objRsm.RecordCount = 0 Then
            SQLf = "SELECT [Content].Name As FName, Contentfather.ContentID, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.FatherID WHERE [Contentfather].ContentID=" & Fid
                    Set objRsf = OpenDB(SQLf)
                            fatherid1 = objRsf("FatherID")
                    CloseDB(objRsf)
		 buildsontree(fatherid1)
		   Exit Function
	End If
    v=1
        Do while Not objRsm.EOF
			If v = 1 Then
				x= "first"
			ElseIf objRsm.AbsolutePosition = objRsm.RecordCount Then
				x= "last"
			Else
				x= "btn" & v
			End If
            y=""
            If    Url ="/Default.asp" AND Getconfig("HomePageID") = objRsm("id") Or LCase(Request.QueryString("p")) = Replace(LCase(objRsm("Urltext")), " ", "-") Then
                If Session("menutype") = 3 Then
                    y =  " expand"
                Else
                    y =  " active"
                End if
			End If

            If objRsm("Showinsonmenu") = True Then
            Urltext = objRsm("Urltext")
                        slash = ""
                    If Urltext <> "/" then
                        slash = "/"
                    End If 
                If Left(Urltext,4) = "http" then
                        slash = ""
                End if
		                print vbCrLf & "  <li class=""" & x &  y & """><a href=""" & slash & ReplaceSpaces(Urltext) & """>" & objRsm("Menusname") & "</a>"
            End If
                SQLson = "SELECT TOP 1 [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE LangID = '" & Session("SiteLang") & "' AND (Contentfather.FatherID = " & objRsm("id") & ") AND (Content.SiteID = " & SiteID & ")AND  (Menus != '') ORDER By Menusorder ASC"

                Set objRsSon = OpenDB(SQLson)
                     If objRsSon.Recordcount > 0 Then
                       If objRsm("Showinsonmenu") = True Then
                                        print  vbCrLf & "    <ul class=""acitem"">" 
                        End if
                            buildsontree objRsm("id") 
                           If objRsm("Showinsonmenu") = True Then
                                print "</li>" & vbCrLf
                            End If  
                    Else
                            If objRsm("Showinsonmenu") = True Then
                                print "</li>" & vbCrLf
                            End if
                    End if
			    If objRsm("Showinsonmenu") = True Then
                    v=v+1
                End If
        objRsm.MoveNext
	        Loop
	    CloseDB(objRsm)	
         ProcessLayout(GetURL(templatelocation & "accordion/footer.html"))
	
End Function

' end acordion son menu
'///////////Mostview///////
	'	ProcessParameters parameters, Mid(strCommand, Len("_Image") + 2)
	'	Print "<img src=""resize.ashx?path=" & Server.URLEncode(parameters("src")) & "&width=" & parameters("width") & """ />"

  Function Mostview(Contenttype,Howmeny)
                        SQLm = "SELECT TOP " & Howmeny & "* FROM [Content] WHERE Contenttype=" & Contenttype & " AND (Content.Active=1) AND Content.SiteID=" & SiteID & " ORDER BY Count DESC"  
                       'print SQLm
                        Set objRsm = openDB(SQLm)
                            If objRsm.recordcount = 0 then
                                print "אין רשומות"
                            Else
                                     Do While NOT objRsm.eof
                                template = GetURL(Templatelocation & "mostview.html")
                                        For Each Field In objRsm.Fields
					                        value = objRsm(Field.Name)
						                        If Len(value) > 0 Then
							                        template = Replace(template, "[" & Field.Name & "]", value)
							                        template = Replace(template, "[/" & Field.Name & "]", ReplaceSpaces(value))
                                                Else
							                        template = Replace(template, "[" & Field.Name & "]", "")
						                        End If
					                   Next
							                     ProcessLayout(template) 
                                    objRsm.MoveNext
                                        loop
                            End if
                     CloseDB(objRsm)
            End Function	
'----------------------------------------------

'///////END////Mostview/////


  Function Showallsons(id)
                        Sqls = "SELECT Sonsvipmode, Snosshow FROM Content Where Id=" &  Getsession("contentiD")
                        Set objRss = openDB(Sqls)
                        Sonsvipmode = objRss("Sonsvipmode")
                        showsons = objRss("Snosshow")
                        CloseDB(objRss)
        If showsons = true then
                        SQLsons1 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & Getsession("contentiD") & ") AND (Content.Active=1) AND Content.SiteID=" & SiteID & " AND (Contenttype != 3)"  
                        If Sonsvipmode = True  Then SQLsons1 = SQLsons1 & " AND other6 = 'vip'"
                        SQLsons1 = SQLsons1 & " Order By " & objRs("Sonsorder") 
                       
                       
                        SQLsons2 = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & Getsession("contentiD") & ") AND (Content.Active=1) AND Content.SiteID=" & SiteID & " AND (Contenttype != 3)"  
                       If Sonsvipmode = True Then SQLsons2 = SQLsons2 & " AND other6 != 'vip'"
                        SQLsons2 = SQLsons2 & " Order By " & objRs("Sonsorder") 
               
                Set objRssons1 = openDB(SQLsons1)
                Set objRssons2 = openDB(SQLsons2)
              

                If objRssons1.recordcount > 0 then

                    objRssons1.PageSize = objRs("Sonsrecords")
                    SetSession "PageCount", objRssons1.PageCount
				    nPage = Int(Request.QueryString("Page"))
					    If nPage <= 0 Then
						    nPage = 1
					    End If
			       objRssons1.AbsolutePage = nPage
                   sonTemplateURL = objRs("Sonstemplate")
                   FirstTemplateURL = objRs("Sonsfirsttemplate")
                   z = 0
                     '-------------
                  If objRs("Sonsfirstrecords") > 0 Then
                         Do While NOT objRssons1.eof AND z < objRs("Sonsfirstrecords")
                          session(siteID & "Sonid") = objRssons1("Id")

			           FirstTemplate = GetURL(FirstTemplateURL )
                        SQLson = "Select * From Content Where id=" & objRssons1("id") & " And SiteID=" & SiteID
                        Set objRsson = openDB(SQLson)
                       if z mod 2 = 0 then
                            zebraclass = "odd"
                        else
                            zebraclass = "even"
                        end if
                            For Each Field In objRsson.Fields
					             value = objRsson(Field.Name)
						        If Len(value) > 0 Then
							        FirstTemplate = Replace(FirstTemplate, "[" & Field.Name & "]", value)
							        FirstTemplate = Replace(FirstTemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
							        FirstTemplate = Replace(FirstTemplate, "[zebraclass]", zebraclass)
                                Else
							        FirstTemplate = Replace(FirstTemplate, "[" & Field.Name & "]", "")
						        End If
					        Next
				            ProcessLayout(FirstTemplate) 
			                    z = z + 1
			                objRssons1.MoveNext
		                Loop
		           End If
                        '------------------------
       If Sonsvipmode = True  Then
                    Do While NOT objRssons2.eof AND z < objRs("Sonsrecords")
                    session(siteID & "Sonid") = objRssons2("Id")
                    sontemplate = GetURL(sonTemplateURL)
                        SQLson = "Select * From Content Where id=" & objRssons2("id") & " And SiteID=" & SiteID
                        Set objRsson = openDB(SQLson)
                       if z mod 2 = 0 then
                            zebraclass = "odd"
                        else
                            zebraclass = "even"
                        end if

                            For Each Field In objRsson.Fields
					             value = objRsson(Field.Name)
						        If Len(value) > 0 Then
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", value)
							        sontemplate = Replace(sontemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
							        sontemplate = Replace(sontemplate, "[zebraclass]", zebraclass)
                                Else
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(sontemplate) 
                        CloseDB(objRsson)
                     z =z +1
                    objRssons2.MoveNext
                        loop
                    If objRs("Sonsshowpager") = True Then
                        Newpager
                    End if

          Else
                     Do While NOT objRssons1.eof AND z < objRs("Sonsrecords")
                     session(siteID & "Sonid") = objRssons1("Id")
                    sontemplate = GetURL(sonTemplateURL)
                        SQLson = "Select * From Content Where id=" & objRssons1("id") & " And SiteID=" & SiteID & " Order By " & objRs("Sonsorder") 
                        Set objRsson = openDB(SQLson)
                       if z mod 2 = 0 then
                            zebraclass = "odd"
                        else
                            zebraclass = "even"
                        end if

                            For Each Field In objRsson.Fields
					             value = objRsson(Field.Name)
						        If Len(value) > 0 Then
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", value)
							        sontemplate = Replace(sontemplate, "[/" & Field.Name & "]", ReplaceSpaces(value))
							        sontemplate = Replace(sontemplate, "[zebraclass]", zebraclass)
                                Else
							        sontemplate = Replace(sontemplate, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(sontemplate) 
                        CloseDB(objRsson)
                     z =z +1
                    objRssons1.MoveNext
                        loop
                    If objRs("Sonsshowpager") = True Then
                        Newpager
                    End if
                 End if
          End if
                CloseDB(objRssons1)
                If Sonsvipmode = True Then CloseDB(objRssons2)
        End if
            End Function	
'----------------------------------------------

function getbreadcrumb(ID)
    Set stack = CreateObject("System.Collections.Stack")
    tmp = ID

    'stack.Push(ID)

    Do Until done
        tmp = GetFather(tmp)
        If tmp = 0 Then Exit Do

        stack.Push(tmp)
    Loop
    
    print "<div class=""breadcrumb"">"
    sqln = "Select Menuislink,Name From Content where ID=" & Getconfig("HomePageID")
       set objRsname= OpenDB(sqln)
       If objRsname("Menuislink") = True then Print " <a href=""http://" & Getconfig("domains") & """>" & objRsname("Name") & "</a> &#155; "
        CloseDB(objRsname)
    For i = 0 To stack.Count - 1
        p = stack.Pop()

        Set objRst = OpenDB("SELECT UrlText, Menuislink, MenusName FROM [Content] WHERE Id = " & p)
        If objRst("Menuislink") = True then  
            Print " <a href=""" & ReplaceSpaces(objRst("Urltext")) & """>" & objRst("Menusname") & "</a>"
        Else
            Print " <a class=""breadcrumb_a"" href=""#"">" & objRst("Menusname") & "</a>"
        End If

         Print " &#155;"

        CloseDB(objRsT)
    Next
        Set objRst = OpenDB("SELECT UrlText, Menuislink, MenusName FROM [Content] WHERE Id = " & ID)
        If objRst("Menuislink") = True then 
                Print " <a href=""" & ReplaceSpaces(objRst("Urltext")) & """>" & objRst("Menusname") & "</a>"
        Else
                Print " <a class=""breadcrumb_a"" href=""#"">" & objRst("Menusname") & "</a>"
        End if
        CloseDB(objRsT)
    print "</div>" 
end function

function getfather(ID)
    GetFather = OpenDB("SELECT FatherId FROM [Contentfather] WHERE ContentID=" & ID)(0)
end function


'----------------------------------------------







function TestCaptcha(byval valSession, byval valCaptcha)
	dim tmpSession
	valSession = Trim(valSession)
	valCaptcha = Trim(valCaptcha)
	if (valSession = vbNullString) or (valCaptcha = vbNullString) then
		TestCaptcha = false
	else
		tmpSession = valSession
		valSession = Trim(Session(valSession))
		Session(tmpSession) = vbNullString
		if valSession = vbNullString then
			TestCaptcha = false
		else
			valCaptcha = Replace(valCaptcha,"i","I")
			if StrComp(valSession,valCaptcha,1) = 0 then
				TestCaptcha = true
			else
				TestCaptcha = false
			end if
		end if		
	end if
end function

Function FormatDate(strDate, strDateFmt)
  dim strRet
  dim i  
  dim formatBlock
  dim formatLength
  dim charLast
  dim charCur
  
  formatLength = len(strDateFmt)
  
  for i = 1 to formatLength + 1
    ' grab the current character
    charCur = mid(strDateFmt, i, 1)
    
    if charCur = charLast then
        ' The block is not finished. 
        ' Continue growing the block and iterate to the next character.
        formatBlock = formatBlock & charCur
    else
        ' we have a change and need to handle the previous block
        select case formatBlock
        case "mmmm"
            strRet = strRet & MonthName(DatePart("m",strDate),False)
        case "mmm"
            strRet = strRet & MonthName(DatePart("m",strDate),True)
        case "mm"
            strRet = strRet & right("0" & DatePart("m",strDate),2)
        case "m"
            strRet = strRet & DatePart("m",strDate)
        case "dddd"
            strRet = strRet & WeekDayName(DatePart("w",strDate,1),False)
        case "ddd"
            strRet = strRet & WeekDayName(DatePart("w",strDate,1),True)
        case "dd"
            strRet = strRet & right("0" & DatePart("d",strDate),2)
        case "d"
            strRet = strRet & DatePart("d",strDate)
        case "o"
            strRet = strRet & intToOrdinal(DatePart("d",strDate))
        case "yyyy"
            strRet = strRet & DatePart("yyyy",strDate)
        case "yy"
            strRet = strRet & right(DatePart("yyyy",strDate),2)
        case "y"
            strRet = strRet & cInt(right(DatePart("yyyy",strDate),2))
        case else
            strRet = strRet & formatBlock
        end select
        ' Block handled.  
        ' Now reset the block and continue iterating to the next character.
        formatBlock = charCur
    end if
    
    charLast = charCur
  next 'i
 
  FormatDate = strRet
End Function



function pager()
%>
  <table width=100% cellspacing="0" cellpadding="4">
	<% If Not objRs.PageCount = 0 Then
		    If Len(Request.QueryString("page")) > 0 Then
			    objRs.AbsolutePage = Request.QueryString("page")
		    Else
			    objRs.AbsolutePage = 1
		    End If
        End If%>
    <div align="center">
	<table border="0" width="300" cellspacing="0" cellpadding="0">
		<tr>
			<td width="166"><img border="0" src="../images/<% = SysLang("previmage") %>" width="16" height="16" align="left"></td>
			<td width="177"><font size="2" face="Arial"><div align="center">
	<% If objRs.AbsolutePage > 1 Then %>
		<a href="<% = Replace(Request.querystring("p"),"-"," ") %>&page=<% = objRs.AbsolutePage - 1 %>" style="text-decoration: none">
	<% End If%>
		<font color="#808080"><% = SysLang("prevpage") %></font></a>
			</td>
			<td width="25"><font color="#808080" size="2" face="Arial">&nbsp;|&nbsp;</font>
			</td>
			<td width="155"><font size="2" face="Arial"><div align="center">
	           <% If objRs.AbsolutePage < objRs.PageCount Then %>
					<a href="<% = Replace(Request.querystring("p"),"-"," ") %>&page=<% = objRs.AbsolutePage + 1 %>" style="text-decoration: none"><% 	End If%>
					<font color="#808080"><% = SysLang("nextpage") %></font></a></font>
			</td>
			<td width="167"><font size="2" face="Arial">
			<img border="0" src="../images/<% = SysLang("nextimage") %>" width="16" height="16" align="right"></font></td>
		</tr>
	</table>
<% End function

Function idpager
 %>
	<link rel="stylesheet" href="<% = Templatelocation %>style/pager.css" type="text/css"  />
	<%
			QS = Request.ServerVariables ("URL") 
			QS = Replace(QS, "#", "")
			
			nPage = Int(Request.QueryString("Page"))
			If nPage <= 0 Then
				nPage = 1
			End If
            print "<Div id=""pager""><ul class=""pages"">"
			If nPage > 1 Then
				print "<li class=""first""><a href=""" &  QS & """>" &  SysLang("first") & "</a>"
				print "<li class=""prev""><a href=""" &  QS & "?Page=" & (nPage - 1) & """>" &  SysLang("prevpage") & "</a>"
						for a=nPage-5 to nPage -1
						    if a > 0 then
			  	                If a = 1 then
                                    print "<li class=""page-number""><a href=""" & QS & """> " & a & " </a>"
                                Else
                                    print "<li class=""page-number""><a href=""" & QS & "?Page=" & (a) &  """> " & a & " </a>"
                                End if
                            end if
                        next
			End If
				print "<li class=""page-number pgCurrent""><a href=""" & QS & "?Page=" & (nPage) &  """> " & nPage & " </a></li>"
		
			            for b=nPage+1 to Int(GetSession("PageCount"))
			                if b < nPage+5 then
				              print "<li class=""page-number""><a href="""  & QS & "?Page=" & (b) &  """> " & b & " </a></li>"
                            end if
                        next
			
			If nPage < Int(GetSession("PageCount")) Then
				print"<li class=""next""><a href=""" & QS & "?Page=" & (nPage + 1)  & """>" & SysLang("nextpage") & "</a>"  
				print "<li class=""last""><a href=""" & QS & "?Page=" & (Int(GetSession("PageCount")))  & """>" &  SysLang("last") & "</a>"  
			End If	
            print  "</ul></Div>"


End Function

Function deletecache(page)
mstrCacheFolder = phisicalpath&getconfig("sitename")&"\cache\"
	If Right(mstrCacheFolder, 1) = "\" Then
        mstrCacheFolder = Left(mstrCacheFolder, Len(mstrCacheFolder) - 1)
    End If
	dim fs
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	if fs.FolderExists(mstrCacheFolder)=true then
		If page = "all" then
		'print page
			fs.DeleteFolder(mstrCacheFolder)
		Else
			file=mstrCacheFolder & "\" & SiteID & "-sc_p_" & Replacespaces(page) & ".htm"
			print file
			If fs.FileExists (file) Then
				fs.DeleteFile(file)
			End If
		End if
	end if
	set fs=nothing
End Function


'///////////GetSonPerDay//////////////////////
Function GetSonPerDay(ID)
        SQLPerDay = "SELECT TOP 1 [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = " & ID & ")"
        SQLPerDay = SQLPerDay  & " AND ((floor(convert(real,GetDate())) >= floor(convert(real,Startdate)) And Startdate IS NOT NULL) OR Startdate IS NULL) AND ((floor(convert(real,GetDate())) < floor(convert(real,Enddate)) And Enddate IS NOT NULL) OR Enddate IS NULL)"       
        SQLPerDay = SQLPerDay  & " AND Content.SiteID=" & SiteID & "   ORDER By Id DESC"     
     '  print SQLPerDay
                Set objRSonPerDay = openDB(SQLPerDay)
               If objRSonPerDay.recordcount > 0 then
                    GetSonPerDay = GetURL(objRSonPerDay("Sonstemplate"))
                            For Each Field In objRSonPerDay.Fields
					             value = objRSonPerDay(Field.Name)
						        If Len(value) > 0 Then
							        GetSonPerDay = Replace(GetSonPerDay, "[" & Field.Name & "]", value)
							        GetSonPerDay = Replace(GetSonPerDay, "[/" & Field.Name & "]", ReplaceSpaces(value))
						        Else
							        GetSonPerDay = Replace(GetSonPerDay, "[" & Field.Name & "]", "")
						        End If
					        Next
							 ProcessLayout(GetSonPerDay)
                Else
                    Print "אין רשומות"
                End if
                        CloseDB(objRSonPerDay)
End Function
'///////////GetCategoryPerDay//////////////////////

Function GetShowreviews(Id)
'print Id
        SQLr = "Select TOP 4 * From Response Where ContentId=" &  Id & " AND SiteID=" & SiteID
        Set objRSr = openDB(SQLr)
        Do While Not objRSr.EOF
        GetShowreviews = GetShowreviews & "<div class=""showrevies""><p><b>" & objRSr("AuthorName") & "</b> - <small>" & objRSr("Date") & "</small></p><p>" & objRSr("Name") & " - " & objRSr("Text")& "</p></div>"
        objRSr.Movenext
        loop
                GetShowreviews = GetShowreviews & "<div class=""showreviesbutton""><a href=""reviews.asp?ID="&   Id  &""">לקריאת כל התגובות</a></div>"

        Closedb(objRSr)
     '   print GetShowreviews
End Function

Function GetCalendar(ID)
	Session(SiteID & "CalId") = ID
	ExecutePage "/blocks/calendar.asp"
End Function

 %>

