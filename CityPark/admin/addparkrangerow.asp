<%
rn = request("rnd")
%>
<select id="afromday<%=rn%>" name="afromday">
				<option value="א">א</option>
				<option value="ב">ב</option>
				<option value="ג">ג</option>
				<option value="ד">ד</option>
				<option value="ה">ה</option>
				<option value="ו">ו</option>
				<option value="שבת">שבת</option>
		</select>
        עד יום 
        <select id="atoday<%=rn%>" name="atoday">
				<option value="א">א</option>
				<option value="ב">ב</option>
				<option value="ג">ג</option>
				<option value="ד">ד</option>
				<option value="ה">ה</option>
				<option value="ו">ו</option>
				<option value="שבת">שבת</option>
		</select>
        
        
        משעה: <select id="afromhour<%=rn%>" name="afromhour" onchange="" style="" class="">
				
                	<option value="1">1:00</option>
                
                	<option value="2">2:00</option>
                
                	<option value="3">3:00</option>
                
                	<option value="4">4:00</option>
                
                	<option value="5">5:00</option>
                
                	<option value="6">6:00</option>
                
                	<option value="7">7:00</option>
                
                	<option value="8">8:00</option>
                
                	<option value="9">9:00</option>
                
                	<option value="10">10:00</option>
                
                	<option value="11">11:00</option>
                
                	<option value="12">12:00</option>
                
                	<option value="13">13:00</option>
                
                	<option value="14">14:00</option>
                
                	<option value="15">15:00</option>
                
                	<option value="16">16:00</option>
                
                	<option value="17">17:00</option>
                
                	<option value="18">18:00</option>
                
                	<option value="19">19:00</option>
                
                	<option value="20">20:00</option>
                
                	<option value="21">21:00</option>
                
                	<option value="22">22:00</option>
                
                	<option value="23">23:00</option>
                
                	<option value="24">24:00</option>
                
				</select>
				 עד שעה: <select id="atohour<%=rn%>" name="atohour" onchange="" style="" class="">
				
                	<option value="1">1:00</option>
                
                	<option value="2">2:00</option>
                
                	<option value="3">3:00</option>
                
                	<option value="4">4:00</option>
                
                	<option value="5">5:00</option>
                
                	<option value="6">6:00</option>
                
                	<option value="7">7:00</option>
                
                	<option value="8">8:00</option>
                
                	<option value="9">9:00</option>
                
                	<option value="10">10:00</option>
                
                	<option value="11">11:00</option>
                
                	<option value="12">12:00</option>
                
                	<option value="13">13:00</option>
                
                	<option value="14">14:00</option>
                
                	<option value="15">15:00</option>
                
                	<option value="16">16:00</option>
                
                	<option value="17">17:00</option>
                
                	<option value="18">18:00</option>
                
                	<option value="19">19:00</option>
                
                	<option value="20">20:00</option>
                
                	<option value="21">21:00</option>
                
                	<option value="22">22:00</option>
                
                	<option value="23">23:00</option>
                
                	<option value="24">24:00</option>
                
				</select>
        
	    
        
        מחיר לשעה ראשונה: <input id="afirstHourPrice<%=rn%>" size="6" value="" type="text">
        מחיר לכל רבע שעה נוספת: <input id="aextraQuarterPrice<%=rn%>" value="" size="6" type="text">
        מחיר ליום: <input id="aallDayPrice<%=rn%>" size="6" value="" type="text"><br />
		חד פעמי משעה: <select id="aonetimehour<%=rn%>" name="aonetimehour" onchange="" style="" class="">
				
                	<option value="1">1:00</option>
                
                	<option value="2">2:00</option>
                
                	<option value="3">3:00</option>
                
                	<option value="4">4:00</option>
                
                	<option value="5">5:00</option>
                
                	<option value="6">6:00</option>
                
                	<option value="7">7:00</option>
                
                	<option value="8">8:00</option>
                
                	<option value="9">9:00</option>
                
                	<option value="10">10:00</option>
                
                	<option value="11">11:00</option>
                
                	<option value="12">12:00</option>
                
                	<option value="13">13:00</option>
                
                	<option value="14">14:00</option>
                
                	<option value="15">15:00</option>
                
                	<option value="16">16:00</option>
                
                	<option value="17">17:00</option>
                
                	<option value="18">18:00</option>
                
                	<option value="19">19:00</option>
                
                	<option value="20">20:00</option>
                
                	<option value="21">21:00</option>
                
                	<option value="22">22:00</option>
                
                	<option value="23">23:00</option>
                
                	<option value="24">24:00</option>
                
				</select>
מחיר לחד פעמי: <input id="aonetimeprice<%=rn%>" value="" size="6" type="text">        
		<span onclick="addparkrangrow(<%=rn%>)"style="color: rgb(255, 255, 255); cursor: pointer; background: none repeat scroll 0% 0% rgb(77, 174, 54); padding: 3px 5px; border: 1px solid rgb(255, 255, 255);">הוסף</span>
		<hr/>
    