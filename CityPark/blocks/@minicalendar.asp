<!--#include file="../config.asp"-->
<!--#include file="../JSON.asp"-->

<% 
IsAdmin = False

Set objRsAdmin = OpenDB("SELECT * FROM Admin WHERE (Name='" & Session(SiteID & "Username") & "') And (Password='" & Session(SiteID & "Password") & "') And (SiteID=" & SiteID & ")")

If objRsAdmin.RecordCount > 0 Then
	Tables = Split(objRsAdmin("Tables"), ",")
    
    For Each x In Tables
        If x = "CalEvent" Then
            IsAdmin = True
        End If
	Next
End If
		
CloseDB(objRsAdmin)

Select Case LCase(Request.QueryString("m"))
    Case "getevents"
        Set Conn = SetConn()
        'Response.ContentType="application/json"
        QueryToJSON(Conn, "SELECT CalEventID As id, title, CONVERT(VARCHAR(MAX), StartDate, 126) As start, CONVERT(VARCHAR(MAX), EndDate, 126) As 'end', allDay, url FROM CalEvent where SiteID=" & SiteID).Flush
    
    Case "edit"
        ID = Request("id")
        Title = Request("title")
        StartDate = Request("start")
        EndDate = Request("end")
        AllDay = Request("allDay")
        Url = Request("url")
        
        SQL = "UPDATE CalEvent SET "
        
        If Not IsNull(Title) Then SQL = SQL & "Title = '" & Title & "', "
        If Not IsNull(StartDate) Then SQL = SQL & "StartDate = '" & StartDate & "', "
        If Not IsNull(EndDate) Then SQL = SQL & "EndDate = '" & EndDate & "', "
        If Not IsNull(AllDay) Then SQL = SQL & "AllDay = '" & AllDay & "', "
        If Not IsNull(Url) Then SQL = SQL & "Url = '" & Url & "'"
        
        SQL = SQL & " WHERE CalEventID = " & ID 
        
        Print SQL
        ExecuteRs(SQL)
    Case "info"
        ID = Request("id")
        Set objRs = OpenDB("SELECT * FROM CalEvent WHERE CalEventId = " & ID)
   		TemplateURL = templatelocation  & "calevent.html" 
			Do Until objRs.Eof
			Template = GetURL(TemplateURL)
				For Each Field In objRs.Fields
					value = objRs(Field.Name)
						If Len(value) > 0 Then
							Template = Replace(Template, "[" & Field.Name & "]", value)
							Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
						Else
							Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
				Next
										
					ProcessLayout(Template)
											 	
			objRs.MoveNext
				Loop
			CloseDB(objRs)
   
    Case Else
%>

<head>
<style type="text/css">
		label, input { display:block; }
		input.text { margin-bottom:12px; width:95%; padding: .4em; }
		fieldset { padding:0; border:0; margin-top:25px; }
		h1 { font-size: 1.2em; margin: .6em 0; }
		div#users-contain {  width: 350px; margin: 20px 0; }
		div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
		div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
		.ui-button { outline: 0; margin:0; padding: .4em 1em .5em; text-decoration:none;  !important; cursor:pointer; position: relative; text-align: center; }
		.ui-dialog .ui-state-highlight, .ui-dialog .ui-state-error { padding: .3em;  }
		
		
	</style>
<script type='text/javascript' src='/js/jquery.datetimepicker.js'></script>
<link rel='stylesheet' type='text/css' href='/calendar/redmond/theme.css' />
<link rel='stylesheet' type='text/css' href='/calendar/minicalendar.css' />
<script type='text/javascript' src='/calendar/minicalendar.js'></script>
<script type='text/javascript'>

    jQuery(function($) {
        $('#calendar').fullCalendar({
            theme: true,
            header: {
                left: '',
                center: '',
                right: ''
            },
            editable: <% = LCase(IsAdmin) %>,
            isRTL: true,
            events: "cal.asp?m=getevents",
            <% If IsAdmin Then %>
            eventDrop: function(calEvent, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
                $.post("cal.asp?m=edit",
                {
                    id: calEvent.id,
                    title: calEvent.title,
                    allDay: calEvent.allDay,
                    url: calEvent.url,
                    start: $.fullCalendar.formatDate(calEvent.start, "u"),
                    end: $.fullCalendar.formatDate(calEvent.end, "u")
                });
            },
            eventResize: function(calEvent, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view) {
                $.post("cal.asp?m=edit",
                {
                    id: calEvent.id,
                    title: calEvent.title,
                    allDay: calEvent.allDay,
                    url: calEvent.url,
                    start: $.fullCalendar.formatDate(calEvent.start, "u"),
                    end: $.fullCalendar.formatDate(calEvent.end, "u")
                });
            },
            <% End If %>
            eventClick: function(event, jsEvent, view) {
                $("#dialog").load("cal.asp?m=info&id=" + event.id).dialog({
                    bgiframe: true,
                    autoOpen: false,
                    height: 600,
                    width: 600,
                    modal: true,
                    buttons: {
                        'ביטול': function() {
                            $(this).dialog('close');
                        },
                        'אישור': function() {
                            $(this).dialog('close');
                        }
                    },
                    close: function() {
                        //allFields.val('').removeClass('ui-state-error');
                    }
                }).dialog('open');

              //  return false;
            }
        });
    });

</script>
</head>
<div id="dialog" style="display: none"></div>
<div id='calendar'></div>
<%
End Select
%>