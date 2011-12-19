<script language="javascript">
// =================================== //
// Popup Calendar Date Capture         //
// v1.0 - Jun 15, 2006                 //
// ----------------------------------- //
// Created by Lloyd Hassell            //
// Website: lloydhassell.brinkster.net //
// Email: lloydhassell@hotmail.com     //
// =================================== //

// INITIALIZATION:

popupCalendar = new Object();

// CONFIGURATION:

popupCalendar.windowWidth = 230;
popupCalendar.windowHeight = 260;
popupCalendar.windowBgColor = '#FFFFFF';

popupCalendar.dayCellFontColor = '#000000';
popupCalendar.dayCellFontFace = 'verdana,arial';
popupCalendar.dayCellFontSize = 2;
popupCalendar.dayCellBgColor = '#FFFFFF';

popupCalendar.dateCellFontColor = '#000000';
popupCalendar.dateCellFontFace = 'verdana,arial';
popupCalendar.dateCellFontSize = 2;
popupCalendar.dateCellWeekdayBgColor = '#CCCCCC';
popupCalendar.dateCellWeekendBgColor = '#BBBBBB';
popupCalendar.dateCellTodayBgColor = '#FF0000';

popupCalendar.firstYear = 1970;
popupCalendar.lastYear = 2050;
popupCalendar.firstDayOfWeek = 0;

popupCalendar.dateFormat = 0; // 0 = dd/mm/yyyy
                              // 1 = mm/dd/yyyy
                              // 2 = July 15, 1976
                              // 3 = Thursday, July 15, 1976

// MAIN:

popupCalendar.monthList = new Array('ינואר','פברואר','מרץ','אפריל','מאי','יוני','יולי','אוגוסט','ספטמבר','אוקטובר','נובמבר','דצמבר');
popupCalendar.dayList = new Array("א","ב","ג","ד","ה","ו","ש");
popupCalendar.isOpen = false;
popupCalendar.formName = '';
popupCalendar.inputFieldName = '';

function popupCalendarDateCapture(FORMNAME,INPUTFIELDNAME) {
   popupCalendar.formName = FORMNAME;
   popupCalendar.inputFieldName = INPUTFIELDNAME;
   var currentDate = new Date();
   var startYear = currentDate.getFullYear();
   var startMonth = currentDate.getMonth();
   if (!popupCalendar.isOpen) popupCalendar.winObj = window.open('','popupCalendarWin','width=' + popupCalendar.windowWidth + ',height=' + popupCalendar.windowHeight + ',location=no,menubar=no,resizable=yes,scrollbars=no,status=1,toolbar=no,left=100,screenX=100,top=100,screenY=100');
   popupCalendar.winObj.document.bgColor = popupCalendar.windowBgColor;
   writeCalendar(startYear,startMonth);
   }

function writeCalendar(STARTYEAR,STARTMONTH) {
   if (arguments[2] != null) {
      var yearMonthStr = arguments[2];
      STARTYEAR = parseInt(yearMonthStr.substring(0,yearMonthStr.indexOf(',')));
      STARTMONTH = parseInt(yearMonthStr.substring(yearMonthStr.indexOf(',') + 1));
      }
   popupCalendar.nextMonthMonth = STARTMONTH + 1;
   popupCalendar.nextMonthYear = STARTYEAR;
   if (popupCalendar.nextMonthMonth == 12) {
      popupCalendar.nextMonthMonth = 0;
      popupCalendar.nextMonthYear = STARTYEAR + 1;
      }
   popupCalendar.previousMonthMonth = STARTMONTH - 1;
   popupCalendar.previousMonthYear = STARTYEAR;
   if (popupCalendar.previousMonthMonth == -1) {
      popupCalendar.previousMonthMonth = 11;
      popupCalendar.previousMonthYear = STARTYEAR - 1;
      }
   var todayDateTime = new Date();
   var todayYear = todayDateTime.getFullYear();
   var todayMonth = todayDateTime.getMonth();
   var todayDate = todayDateTime.getDate();
   var calendarMonthDateTime = new Date(STARTYEAR,STARTMONTH);
   var calendarMonthStartDay = calendarMonthDateTime.getDay();
   var calendarMonthStartDayOffset = calendarMonthStartDay - popupCalendar.firstDayOfWeek;
   if (calendarMonthStartDayOffset < 0) calendarMonthStartDayOffset += 7;
   var calendarMonthDays = 31;
   if (STARTMONTH == 3 || STARTMONTH == 5 || STARTMONTH == 8 || STARTMONTH == 10) calendarMonthDays = 30;
   if (STARTMONTH == 1 && STARTYEAR % 4 == 0) calendarMonthDays = 29;
   if (STARTMONTH == 1 && STARTYEAR % 4 != 0) calendarMonthDays = 28;
   var dateCellText = new Array();
   for (var dateCellPos = 0; dateCellPos < calendarMonthStartDayOffset; dateCellPos++) dateCellText[dateCellPos] = '&nbsp;';
   for (var dateCellPos = calendarMonthStartDayOffset; dateCellPos < calendarMonthDays + calendarMonthStartDayOffset; dateCellPos++) dateCellText[dateCellPos] = dateCellPos - calendarMonthStartDayOffset + 1;
   for (var dateCellPos = calendarMonthStartDayOffset + calendarMonthDays; dateCellPos < 42; dateCellPos++) dateCellText[dateCellPos] = '&nbsp;';
   var windowHtml = '<html><head><title>' + popupCalendar.monthList[STARTMONTH] + ' ' + STARTYEAR + '</title></head>\r';
   windowHtml += '<body bgcolor="' + popupCalendar.windowBgColor + '" link="' + popupCalendar.dateCellFontColor + '" vlink="' + popupCalendar.dateCellFontColor + '" alink="' + popupCalendar.dateCellFontColor + '" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">\r';
   windowHtml += '<form>\r';
   windowHtml += '<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%"><tr><td align="center" valign="middle">\r';
   windowHtml += '<table cellpadding="3" cellspacing="0" border="0"><tr>\r';
   windowHtml += '<td valign="middle"><input type="button" value="&nbsp;&lt;&nbsp;" onClick="javascript:window.opener.writeCalendar(' + popupCalendar.previousMonthYear + ',' + popupCalendar.previousMonthMonth + ');"></td>\r';
   windowHtml += '<td valign="middle"><select onChange="javascript:window.opener.writeCalendar(null,null,this.value);">\r';
   var monthOptionLength = (popupCalendar.lastYear - popupCalendar.firstYear + 1) * 12;
   for (var monthOption = 0; monthOption < monthOptionLength; monthOption++) {
      var optionYear = Math.floor(monthOption / 12) + popupCalendar.firstYear;
      var optionMonth = monthOption % 12;
      windowHtml += (optionYear == STARTYEAR && optionMonth == STARTMONTH) ? '<option selected ' : '<option ';
      windowHtml += 'value="' + optionYear + ',' + optionMonth + '">' + popupCalendar.monthList[optionMonth] + ' ' + optionYear + '</option>\r';
      }
   windowHtml += '</select></td>\r';
   windowHtml += '<td valign="middle"><input type="button" value="&nbsp;&gt;&nbsp;" onClick="javascript:window.opener.writeCalendar(' + popupCalendar.nextMonthYear + ',' + popupCalendar.nextMonthMonth + ');"></td>\r';
   windowHtml += '</tr></table>\r';
   windowHtml += '<table cellpadding="5" cellspacing="1" border="0">\r';
   windowHtml += '<tr>\r';
   for (var posLoop = popupCalendar.firstDayOfWeek; posLoop < 7 + popupCalendar.firstDayOfWeek; posLoop++) {
      var dayLoop = posLoop;
      if (dayLoop > 6) dayLoop -= 7;
      windowHtml += '<td bgcolor="' + popupCalendar.dayCellBgColor + '" align="center" valign="middle"><font color="' + popupCalendar.dayCellFontColor + '" face="' + popupCalendar.dayCellFontFace + '" size="' + popupCalendar.dayCellFontSize + '"><b>' + popupCalendar.dayList[dayLoop].charAt(0) + '</b></font></td>\r';
      }
   windowHtml += '</tr>\r';
   for (var posLoop = 0; posLoop < 42; posLoop++) {
      if (posLoop % 7 == 0) windowHtml += '<tr>\r';
      var cellBgColor = posLoop % 7 + popupCalendar.firstDayOfWeek;
      if (cellBgColor > 6) cellBgColor -= 7;
      cellBgColor = (cellBgColor == 0 || cellBgColor == 6) ? popupCalendar.dateCellWeekendBgColor : popupCalendar.dateCellWeekdayBgColor;
      var dayStr = dateCellText[posLoop];
      if (dayStr != '&nbsp;') dayStr = '<a href="javascript:window.opener.returnDateValue(\'' + dayStr + ',' + STARTMONTH + ',' + STARTYEAR + '\');">' + dayStr + '</a>';
      if (todayYear == STARTYEAR && todayMonth == STARTMONTH && todayDate == dateCellText[posLoop]) cellBgColor = popupCalendar.dateCellTodayBgColor;
      windowHtml += '<td bgcolor="' + cellBgColor + '" align="center" valign="middle"><font color="' + popupCalendar.dateCellFontColor + '" face="' + popupCalendar.dateCellFontFace + '" size="' + popupCalendar.dateCellFontSize + '">\r';
      windowHtml += dayStr + '</font></td>\r';
      if (posLoop % 7 == 6) windowHtml += '</tr>\r';
      }
   windowHtml += '</tr>\r';
   windowHtml += '</table>\r';
   windowHtml += '</td></tr></table>\r';
   windowHtml += '</form></body></html>\r';
   popupCalendar.winObj.document.write(windowHtml);
   popupCalendar.winObj.document.close();
   popupCalendar.winObj.focus();
   }

function returnDateValue(DATEVALUE) {
   DATEVALUE = DATEVALUE.split(',');
   var dateDay = parseInt(DATEVALUE[0]);
   var dateMonth = parseInt(DATEVALUE[1]);
   var dateYear = parseInt(DATEVALUE[2]);
   var dateObj = new Date(dateYear,dateMonth,dateDay);
   var dateStr;
   if (popupCalendar.dateFormat == 0) dateStr = dateDay + '/' + (dateMonth + 1) + '/' + dateYear;
   else if (popupCalendar.dateFormat == 1) dateStr = (dateMonth + 1) + '/' + dateDay + '/' + dateYear;
   else if (popupCalendar.dateFormat == 2) dateStr = popupCalendar.monthList[dateMonth] + ' ' + dateDay + ', ' + dateYear;
   else if (popupCalendar.dateFormat == 3) dateStr = popupCalendar.dayList[dateObj.getDay()] + ', ' + popupCalendar.monthList[dateMonth] + ' ' + dateDay + ', ' + dateYear;
   if (popupCalendar.winObj) popupCalendar.winObj.close();
   document.forms[popupCalendar.formName][popupCalendar.inputFieldName].value = dateStr;
   }
   </script>