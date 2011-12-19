<!--#include file="../config.asp"-->

<% 
If Request.QueryString("mode") = "gethotels" Then
	SQL = "SELECT other3, NewsHeadline FROM [News] WHERE other2 > 0 AND"
	
	If Int(Request.QueryString("City")) > 0 Then
		SQL = SQL & " other2 = " & Request.QueryString("City") & " AND"
	Else
		SQL = SQL & " other2 = 9999999 AND"
	End If
	
	If Int(Request.QueryString("Star")) > 0 Then
		SQL = SQL & " other4 = " & Request.QueryString("Star") & " AND"
	End If
	
	SQL = SQL & " SiteID = " & SiteID & " order by NewsHeadline"
	
	'Print SQL & " <br/>"
	
	Set objRs = OpenDB(SQL)		
    
	Print "["
	
	Response.ContentType="text/html; charset=utf-8"
	
	Index = 0
	
	Do Until objRs.EOF
		Print "{""value"": """
		Print objRs(0)
		Print """, ""text"": """
		Print objRs(1) 
		Print """}"	
		
		If Index < objRs.RecordCount - 1 Then 
			Print ", "
		End If
		
		Index = Index + 1
		
		objRs.MoveNext
	Loop
	
	
	Print "]"
	
	Response.End 
End if
%>
	
    <script>
		$(document).ready(function() {
		
			$("#City").change(refresh);
			
			
			$("#stars2").change(refresh);

			refresh();
			
			function refresh() {		
				var url = "/blocks/easy_toolbar.asp?mode=gethotels&City=" + $("#City").find("option:selected").val() + "&Star=" + $("#stars2").find("option:selected").val();
				
				$.ajax({
					url: url,
					dataType: 'json',
					success: function(json) {
					
						var h = $("#Hotel").empty();
					
						h.append($("<option></option>")
							.val("0")
							.text("הכל")
						);
										
						$.each(json, function() {
							h.append($("<option></option>")
								.val(this["value"])
								.text(this["text"])
							);
						});
					}
			});

	//			$.getJSON(alert("), );
			}
		});
	</script>
	
</head>
<form name="easy" id="easy" action="hotels.asp" method="get" target="_parent">
   <div class="toolbat_text">בחר עיר:</div>
       <div class="toolbat_combo"><select id="City" name="CityID" class="combo" >
              <%
				'	Set objRs= OpenDB("SELECT DISTINCT other2, other1 FROM News Where other2 > 1 AND SiteID= " & SiteID & " order by other1 ASC")		
					Set objRs= OpenDB("SELECT * FROM Category Where CategoryFatherName = 218 AND SiteID= " & SiteID & " order by CategoryOrder ASC")		
						Do While Not objRs.EOF
						%>
						<option value="<% = objRs("other1") %>"><% = objRs("CategoryName") %></option>
						<% 		
					objRs.MoveNext
					loop
					CloseDB(objRs)				
					  %>
				</select>
			</div>
				 <div class="toolbat_text">דרגת המלון:</div>
		   <div class="toolbat_combo">
				<select id="stars2" name="Star" class="combo">
					<option value="0">הכל</option>
					<option value="3">3-כוכבים</option>
					<option value="4">4-כוכבים</option>
					<option value="5">5-כוכבים</option>
				</select>
			</div>
			   <div class="toolbat_text">מלון:</div>
       <div class="toolbat_combo"><select id="Hotel" name="HotelID" class="combo"></select></div>
		<div class="toolbat_submit"><input type="image" src="/sites/tour/layout/images/submit.gif" value="צא לנופש" /></div>
</form>
</body>