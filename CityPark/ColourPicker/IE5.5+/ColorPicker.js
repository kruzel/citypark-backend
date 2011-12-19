/*
 * -----------------------------------------------------
 * Author: Lewis E. Moten III
 * Date: May, 16, 2004
 * Homepage: http://www.lewismoten.com
 * Email: lewis@moten.com
 * -----------------------------------------------------
 * 
 * This code is Copyright (c) 2004 Lewis Moten, all rights reserved. 
 * In order to receive the right to license this code for use on your 
 * site the original code must be downloaded from lewismoten.com.
 * License is granted to user to reuse this code on their own Web
 * site if and only if this entire copyright notice is included. 
 * Code written by Lewis Moten.
 */
var ColorMode = 1;
var GradientPositionDark = new Boolean(false);
var frm = new Object();

window.onload = window_load;

function initialize()
{
	frm.btnCancel.onclick = btnCancel_Click;
	frm.btnOK.onclick = btnOK_Click;
	frm.txtHSB_Hue.onkeyup = Hsb_Changed;
	frm.txtHSB_Hue.onkeypress = validateNumber;
	frm.txtHSB_Saturation.onkeyup = Hsb_Changed;
	frm.txtHSB_Saturation.onkeypress = validateNumber;
	frm.txtHSB_Brightness.onkeyup = Hsb_Changed;
	frm.txtHSB_Brightness.onkeypress = validateNumber;
	frm.txtRGB_Red.onkeyup = Rgb_Changed;
	frm.txtRGB_Red.onkeypress = validateNumber;
	frm.txtRGB_Green.onkeyup = Rgb_Changed;
	frm.txtRGB_Green.onkeypress = validateNumber;
	frm.txtRGB_Blue.onkeyup = Rgb_Changed;
	frm.txtRGB_Blue.onkeypress = validateNumber;
	frm.txtHex.onkeyup = Hex_Changed;
	frm.txtHex.onkeypress = validateHex;
	frm.btnWebSafeColor.onclick = btnWebSafeColor_Click;
	frm.rdoHSB_Hue.onclick = rdoHsb_Hue_Click;
	frm.rdoHSB_Saturation.onclick = rdoHsb_Saturation_Click;
	frm.rdoHSB_Brightness.onclick = rdoHsb_Brightness_Click;
	frm.rdoRGB_Red.onclick = rdoRgb_Red_Click;
	frm.rdoRGB_Green.onclick = rdoRgb_Green_Click;
	frm.rdoRGB_Blue.onclick = rdoRgb_Blue_Click;
	frm.btnAbout.onclick = btnAbout_Click;

	pnlGradient_Top.onclick = pnlGradient_Top_Click;
	pnlGradient_Top.onmousemove = pnlGradient_Top_MouseMove;
	pnlGradient_Top.onmousedown = pnlGradient_Top_MouseDown;
	pnlGradient_Top.onmouseup = pnlGradient_Top_MouseUp;
	
	pnlVertical_Top.onclick = pnlVertical_Top_Click;
	pnlVertical_Top.onmousemove = pnlVertical_Top_MouseMove;
	pnlVertical_Top.onmousedown = pnlVertical_Top_MouseDown;
	pnlVertical_Top.onmouseup = pnlVertical_Top_MouseUp;
	pnlWebSafeColor.onclick = btnWebSafeColor_Click;
	pnlWebSafeColorBorder.onclick = btnWebSafeColor_Click;
	pnlOldColor.onclick = pnlOldClick_Click;

	lblHSB_Hue.onclick = rdoHsb_Hue_Click;
	lblHSB_Saturation.onclick = rdoHsb_Saturation_Click;
	lblHSB_Brightness.onclick = rdoHsb_Brightness_Click;
	lblRGB_Red.onclick = rdoRgb_Red_Click;
	lblRGB_Green.onclick = rdoRgb_Green_Click;
	lblRGB_Blue.onclick = rdoRgb_Blue_Click;

	pnlGradient_Top.focus();
}
function formatString(format)
{
	for(var i = 1; i < arguments.length; i++)
		format = format.replace(new RegExp("\\{" + (i-1) + "\\}"), arguments[i]);
	return format;
}
function AddValue(o, value)
{
	value = value.toLowerCase();
	for(var i = 0; i < o.length; i++)
		if(o[i] == value) return;
	o[o.length] = value;
}
function SniffLanguage(l)
{
	if(GetCookie("lang") != "") AddValue(l, GetCookie("lang"));
	AddValue(l, window.navigator.userLanguage);
	if(window.navigator.userLanguage.indexOf("-") != -1) 
		AddValue(l, window.navigator.userLanguage.substr(0, window.navigator.userLanguage.indexOf("-")));

	AddValue(l, window.navigator.browserLanguage);
	if(window.navigator.userLanguage.indexOf("-") != -1) 
		AddValue(l, window.navigator.browserLanguage.substr(0, window.navigator.browserLanguage.indexOf("-")));

	AddValue(l, window.navigator.systemLanguage);
	if(window.navigator.userLanguage.indexOf("-") != -1) 
		AddValue(l, window.navigator.systemLanguage.substr(0, window.navigator.systemLanguage.indexOf("-")));
}
function LoadLanguage()
{
	var l = new Array();
	if(window.dialogArguments)
	{
		if(window.dialogArguments.LanguageDetection != null)
		{
			if(window.dialogArguments.LanguageDetection)
				SniffLanguage(l);
		}
		if(window.dialogArguments.DefaultLanguage)
		{AddValue(l, window.dialogArguments.DefaultLanguage);}
		else{AddValue(l, "en-us");}
	}
	else
	{
		SniffLanguage(l);
		AddValue(l, "en-us");
	}

	var xml = null;

	try{xml = new ActiveXObject("Msxml2.DOMDocument");}
	catch (e){xml = new ActiveXObject("Msxml.DOMDocument");}

	xml.async = false;

	for(var i = 0; i < l.length; i++)
		if(xml.load("../localization/" + l[i] + ".xml"))
		{
			SetCookie("lang", l[i]);
			break;
		}

	var node;

	node = xml.selectSingleNode("/language/BadNumber"); 
		msg.BadNumber = node.text;
	node = xml.selectSingleNode("/language/Title"); 
		msg.Title = node.text;
	node = xml.selectSingleNode("/language/SelectAColor"); 
		msg.SelectAColor = node.text;
	node = xml.selectSingleNode("/language/Buttons/OK"); 
		msg.OKButton = node.text;
	node = xml.selectSingleNode("/language/Buttons/Cancel"); 
		msg.CancelButton = node.text;
	node = xml.selectSingleNode("/language/Buttons/About"); 
		msg.AboutButton = node.text;
	node = xml.selectSingleNode("/language/Recent"); 
		msg.Recent = node.text;
	node = xml.selectSingleNode("/language/WebSafe/Image"); 
		msg.WebSafeWarning = node.getAttribute("tooltip");
	node = xml.selectSingleNode("/language/WebSafe/Color"); 
		msg.WebSafeClick = node.getAttribute("tooltip");
	node = xml.selectSingleNode("/language/HSB/Hue"); 
		msg.HsbHue = node.text;
		msg.HsbHueTooltip = node.getAttribute("tooltip");
		msg.HsbHueUnit = node.getAttribute("measurement");
	node = xml.selectSingleNode("/language/HSB/Saturation"); 
		msg.HsbSaturation = node.text;
		msg.HsbSaturationTooltip = node.getAttribute("tooltip");
		msg.HsbSaturationUnit = node.getAttribute("measurement");
	node = xml.selectSingleNode("/language/HSB/Brightness"); 
		msg.HsbBrightness = node.text;
		msg.HsbBrightnessTooltip = node.getAttribute("tooltip");
		msg.HsbBrightnessUnit = node.getAttribute("measurement");
	node = xml.selectSingleNode("/language/RGB/Red"); 
		msg.RgbRed = node.text;
		msg.RgbRedTooltip = node.getAttribute("tooltip");
	node = xml.selectSingleNode("/language/RGB/Green"); 
		msg.RgbGreen = node.text;
		msg.RgbGreenTooltip = node.getAttribute("tooltip");
	node = xml.selectSingleNode("/language/RGB/Blue"); 
		msg.RgbBlue = node.text;
		msg.RgbBlueTooltip = node.getAttribute("tooltip");
	node = xml.selectSingleNode("/language/Hex"); 
		msg.Hex = node.text;
	node = xml.selectSingleNode("/language/RGB"); 
		msg.RecentTooltip = node.getAttribute("tooltip");
	node = xml.selectSingleNode("/language/About");
		msg.About = node.text;
}
function localize()
{
	SetHTML(
		lblSelectColorMessage, msg.SelectAColor,
		lblRecent, msg.Recent,
		lblHSB_Hue, msg.HsbHue,
		lblHSB_Saturation, msg.HsbSaturation,
		lblHSB_Brightness, msg.HsbBrightness,
		lblRGB_Red, msg.RgbRed,
		lblRGB_Green, msg.RgbGreen,
		lblRGB_Blue, msg.RgbBlue,
		lblHex, msg.Hex,
		lblUnitHSB_Hue, msg.HsbHueUnit,
		lblUnitHSB_Saturation, msg.HsbSaturationUnit,
		lblUnitHSB_Brightness, msg.HsbBrightnessUnit
	);
	SetValue(
		frm.btnCancel, msg.CancelButton,
		frm.btnOK, msg.OKButton,
		frm.btnAbout, msg.AboutButton
	);
	SetTitle(
		frm.btnWebSafeColor, msg.WebSafeWarning,
		pnlWebSafeColor, msg.WebSafeClick,
		pnlHSB_Hue, msg.HsbHueTooltip,
		pnlHSB_Saturation, msg.HsbSaturationTooltip,
		pnlHSB_Brightness, msg.HsbBrightnessTooltip,
		pnlRGB_Red, msg.RgbRedTooltip,
		pnlRGB_Green, msg.RgbGreenTooltip,
		pnlRGB_Blue, msg.RgbBlueTooltip
	);
	
}
function window_load()
{
	frm = frmColorPicker;
	localize();
	initialize();

	var hex = new String(window.dialogArguments.Color).toUpperCase();
	
	//var hex = new String(window.dialogArguments).toUpperCase();
	if(hex == "UNDEFINED") hex = "FFFFFF";
	if(hex.length == 7) hex = hex.substr(1,6);
	frm.txtHex.value = hex;
	Hex_Changed();
	hex = Form_Get_Hex();
	SetBg(pnlOldColor, hex);
	
	frm.ColorType[new Number(GetCookie("ColorMode"))].checked = true;
	ColorMode_Changed();
	
	var recent = GetCookie("Colors")
	//if(recent.length == 0)
	//	Hide(lblRecent);
	var RecentTooltip = msg.RecentTooltip;
	for(var i = 1; i < 33; i++)
		if(recent.length / 6 >= i)
		{
			hex = recent.substr((i-1) * 6, 6);
			var rgb = HexToRgb(hex);
			var title = formatString(msg.RecentTooltip, hex, rgb[0], rgb[1], rgb[2]);
			SetBg(document.all["pnlRecent" + i], hex);
			SetTitle(document.all["pnlRecent" + i], title);
			document.all["pnlRecent" + i].onclick = pnlRecent_Click;
		}
		else
			document.all["pnlRecent" + i].style.border = "0px";
			//Hide(document.all["pnlRecent" + i]);
}
function btnAbout_Click()
{
	if(confirm(msg.About)) ;
}
function pnlRecent_Click()
{
	frm.txtHex.value = event.srcElement.style.backgroundColor.substr(1, 6).toUpperCase();
	Hex_Changed();
}
function pnlOldClick_Click()
{
	frm.txtHex.value = pnlOldColor.style.backgroundColor.substr(1, 6).toUpperCase();
	Hex_Changed();
}
function rdoHsb_Hue_Click()
{
	frm.rdoHSB_Hue.checked = true;
	ColorMode_Changed();
}
function rdoHsb_Saturation_Click()
{
	frm.rdoHSB_Saturation.checked = true;
	ColorMode_Changed();
}
function rdoHsb_Brightness_Click()
{
	frm.rdoHSB_Brightness.checked = true;
	ColorMode_Changed();
}
function rdoRgb_Red_Click()
{
	frm.rdoRGB_Red.checked = true;
	ColorMode_Changed();
}
function rdoRgb_Green_Click()
{
	frm.rdoRGB_Green.checked = true;
	ColorMode_Changed();
}
function rdoRgb_Blue_Click()
{
	frm.rdoRGB_Blue.checked = true;
	ColorMode_Changed();
}
function Hide()
{
	for(var i = 0; i < arguments.length; i++)
		arguments[i].style.display = "none";
}
function Show()
{
	for(var i = 0; i < arguments.length; i++)
		arguments[i].style.display = "";
}
function SetValue()
{
	for(var i = 0; i < arguments.length; i+=2)
		arguments[i].value = arguments[i+1];
}
function SetTitle()
{
	for(var i = 0; i < arguments.length; i+=2)
		arguments[i].title = arguments[i+1];
}
function SetHTML()
{
	for(var i = 0; i < arguments.length; i+=2)
		arguments[i].innerHTML = arguments[i+1];
}
function SetBg()
{
	for(var i = 0; i < arguments.length; i+=2)
		arguments[i].style.backgroundColor = "#" + arguments[i+1];
}
function SetBgPosition()
{
	for(var i = 0; i < arguments.length; i+=3)
		arguments[i].style.backgroundPosition = arguments[i+1] + "px " + arguments[i+2] + "px";
}
function ColorMode_Changed()
{
	for(var i = 0; i < 6; i++)
		if(frm.ColorType[i].checked) ColorMode = i;
	SetCookie("ColorMode", ColorMode);

	Hide(
		pnlGradientHsbHue_Hue,
		pnlGradientHsbHue_Black,
		pnlGradientHsbHue_White,
		pnlVerticalHsbHue_Background,
		pnlVerticalHsbSaturation_Hue,
		pnlVerticalHsbSaturation_White,
		pnlVerticalHsbBrightness_Hue,
		pnlVerticalHsbBrightness_Black,
		pnlVerticalRgb_Start,
		pnlVerticalRgb_End,
		pnlGradientRgb_Base,
		pnlGradientRgb_Invert,
		pnlGradientRgb_Overlay1,
		pnlGradientRgb_Overlay2
	);

	switch(ColorMode)
	{
		case 0:
			Show(
				pnlGradientHsbHue_Hue,
				pnlGradientHsbHue_Black,
				pnlGradientHsbHue_White,
				pnlVerticalHsbHue_Background
			);
			Hsb_Changed();
			break;
		case 1:
			Show(
				pnlVerticalHsbSaturation_Hue,
				pnlVerticalHsbSaturation_White,
				pnlGradientRgb_Base,
				pnlGradientRgb_Overlay1,
				pnlGradientRgb_Overlay2
			);
			SetBgPosition(pnlGradientRgb_Base, 0, 0);
			SetBg(
				pnlGradientRgb_Overlay1, "FFFFFF",
				pnlGradientRgb_Overlay2, "000000"
			)
			pnlGradientRgb_Overlay1.style.zIndex = 5;
			pnlGradientRgb_Overlay2.style.zIndex = 6;
			Hsb_Changed();
			break;
		case 2:
			Show(
				pnlVerticalHsbBrightness_Hue,
				pnlVerticalHsbBrightness_Black,
				pnlGradientRgb_Base,
				pnlGradientRgb_Overlay1,
				pnlGradientRgb_Overlay2
			);
			SetBgPosition(pnlGradientRgb_Base, 0, 0);
			SetBg(
				pnlGradientRgb_Overlay1, "000000",
				pnlGradientRgb_Overlay2, "FFFFFF"
			);
			pnlGradientRgb_Overlay1.style.zIndex = 6;
			pnlGradientRgb_Overlay2.style.zIndex = 5;
			Hsb_Changed();
			break;
		case 3:
			Show(
				pnlVerticalRgb_Start,
				pnlVerticalRgb_End,
				pnlGradientRgb_Base,
				pnlGradientRgb_Invert
			);
			SetBgPosition(
				pnlGradientRgb_Base, 256, 0, 
				pnlGradientRgb_Invert, 256, 0
			);
			Rgb_Changed();
			break;
		case 4:
			Show(
				pnlVerticalRgb_Start,
				pnlVerticalRgb_End,
				pnlGradientRgb_Base,
				pnlGradientRgb_Invert
			);
			SetBgPosition(
				pnlGradientRgb_Base, 0, 256,
				pnlGradientRgb_Invert, 0, 256
			);
			Rgb_Changed();
			break;
		case 5:
			Show(
				pnlVerticalRgb_Start,
				pnlVerticalRgb_End,
				pnlGradientRgb_Base,
				pnlGradientRgb_Invert
			);
			SetBgPosition(
				pnlGradientRgb_Base, 256, 256,
				pnlGradientRgb_Invert, 256, 256
			);
			Rgb_Changed();
			break;
		default:
			break;
	}
}
function btnWebSafeColor_Click()
{
	var rgb = HexToRgb(frm.txtHex.value);
	rgb = RgbToWebSafeRgb(rgb);
	frm.txtHex.value = RgbToHex(rgb);
	Hex_Changed();
}
function checkWebSafe()
{
	var rgb = Form_Get_Rgb();
	if(RgbIsWebSafe(rgb))
	{
		Hide(
			frm.btnWebSafeColor,
			pnlWebSafeColor,
			pnlWebSafeColorBorder
		);
	}
	else
	{
		rgb = RgbToWebSafeRgb(rgb);
		SetBg(pnlWebSafeColor, RgbToHex(rgb));
		Show(
			frm.btnWebSafeColor,
			pnlWebSafeColor,
			pnlWebSafeColorBorder
		);
	}
}
function validateNumber()
{
	var key = String.fromCharCode(event.keyCode);
	if(IgnoreKey()) return;
	if("01234567879".indexOf(key) != -1) return;
	event.keyCode = 0;	
}
function validateHex()
{
	if(IgnoreKey()) return;
	var key = String.fromCharCode(event.keyCode);
	if("abcdef".indexOf(key) != -1)
	{
		event.keyCode = key.toUpperCase().charCodeAt(0);
		return;
	}
	if("01234567879ABCDEF".indexOf(key) != -1) return;
	event.keyCode = 0;	
}
function IgnoreKey()
{
	var key = String.fromCharCode(event.keyCode);
	var keys = new Array(0, 8, 9, 13, 27);
	if(key == null) return true;
	for(var i = 0; i < 5; i++)
		if(event.keyCode == keys[i]) return true;
	return false;
}
function btnCancel_Click()
{
	window.close();
}
function btnOK_Click()
{
	var hex = new String(frm.txtHex.value);
	try
	{
		window.returnValue = hex;
	}
	catch(e)
	{
	}
	recent = GetCookie("Colors");
	for(var i = 0; i < recent.length; i += 6)
		if(recent.substr(i, 6) == hex)
		{
			recent = recent.substr(0, i) + recent.substr(i + 6);
			i -= 6;
		}
	if(recent.length > 31 * 6)
		recent = recent.substr(0, 31 * 6);
	recent = frm.txtHex.value + recent;
	SetCookie("Colors", recent);
	window.close();
}
function SetGradientPosition(x, y)
{
	x -= 7;
	y -= 27;
	x=x<0?0:x>255?255:x;
	y=y<0?0:y>255?255:y;

	SetBgPosition(pnlGradientPosition, x - 5, y - 5);
	switch(ColorMode)
	{
		case 0:
			var hsb = new Array(0, 0, 0);
			hsb[1] = x / 255;
			hsb[2] = 1 - (y / 255);
			frm.txtHSB_Saturation.value = Math.round(hsb[1] * 100);
			frm.txtHSB_Brightness.value = Math.round(hsb[2] * 100);
			Hsb_Changed();
			break;
		case 1:
			var hsb = new Array(0, 0, 0);
			hsb[0] = x / 255;
			hsb[2] = 1 - (y / 255);
			frm.txtHSB_Hue.value = hsb[0] == 1 ? 0 : Math.round(hsb[0] * 360);
			frm.txtHSB_Brightness.value = Math.round(hsb[2] * 100);
			Hsb_Changed();
			break;
		case 2:
			var hsb = new Array(0, 0, 0);
			hsb[0] = x / 255;
			hsb[1] = 1 - (y / 255);
			frm.txtHSB_Hue.value = hsb[0] == 1 ? 0 : Math.round(hsb[0] * 360);
			frm.txtHSB_Saturation.value = Math.round(hsb[1] * 100);
			Hsb_Changed();
			break;
		case 3:
			var rgb = new Array(0, 0, 0);
			rgb[1] = 255 - y;
			rgb[2] = x;
			frm.txtRGB_Green.value = rgb[1];
			frm.txtRGB_Blue.value = rgb[2];
			Rgb_Changed();
			break;
		case 4:
			var rgb = new Array(0, 0, 0);
			rgb[0] = 255 - y;
			rgb[2] = x;
			frm.txtRGB_Red.value = rgb[0];
			frm.txtRGB_Blue.value = rgb[2];
			Rgb_Changed();
			break;
		case 5:
			var rgb = new Array(0, 0, 0);
			rgb[0] = x;
			rgb[1] = 255 - y;
			frm.txtRGB_Red.value = rgb[0];
			frm.txtRGB_Green.value = rgb[1];
			Rgb_Changed();
			break;
	}
}
function Hex_Changed()
{
	var hex = Form_Get_Hex();
	var rgb = HexToRgb(hex);
	var hsb = RgbToHsb(rgb);
	Form_Set_Rgb(rgb);
	Form_Set_Hsb(hsb);
	SetBg(pnlNewColor, hex);
	SetupCursors();
	SetupGradients();
	checkWebSafe();
}
function Rgb_Changed()
{
	var rgb = Form_Get_Rgb();
	var hsb = RgbToHsb(rgb);
	var hex = RgbToHex(rgb);
	Form_Set_Hsb(hsb);
	Form_Set_Hex(hex);
	SetBg(pnlNewColor, hex);
	SetupCursors();
	SetupGradients();
	checkWebSafe();
}
function Hsb_Changed()
{
	var hsb = Form_Get_Hsb();
	var rgb = HsbToRgb(hsb);
	var hex = RgbToHex(rgb);
	Form_Set_Rgb(rgb);
	Form_Set_Hex(hex);
	SetBg(pnlNewColor, hex);
	SetupCursors();
	SetupGradients();
	checkWebSafe();
}
function Form_Set_Hex(hex)
{
	frm.txtHex.value = hex;
}

function Form_Get_Hex()
{
	var hex = new String(frm.txtHex.value);
	for(var i = 0; i < hex.length; i++)
		if("0123456789ABCDEFabcdef".indexOf(hex.substr(i, 1)) == -1)
		{
			hex = "000000";
			frm.txtHex.value = hex;
			alert(formatString(msg.BadNumber, "000000", "FFFFFF"));
			break;
		}
	while(hex.length < 6)
		hex = "0" + hex;
	return hex;
}
function Form_Get_Hsb()
{
	var hsb = new Array(0, 0, 0);
	hsb[0] = new Number(frm.txtHSB_Hue.value) / 360;
	hsb[1] = new Number(frm.txtHSB_Saturation.value) / 100;
	hsb[2] = new Number(frm.txtHSB_Brightness.value) / 100;
	if(hsb[0] > 1 || isNaN(hsb[0]))
	{
		hsb[0] = 1;
		frm.txtHSB_Hue.value = 360;
		alert(formatString(msg.BadNumber, 0, 360));
	}
	if(hsb[1] > 1 || isNaN(hsb[1]))
	{
		hsb[1] = 1;
		frm.txtHSB_Saturation.value = 100;
		alert(formatString(msg.BadNumber, 0, 100));
	}
	if(hsb[2] > 1 || isNaN(hsb[2]))
	{
		hsb[2] = 1;
		frm.txtHSB_Brightness.value = 100;
		alert(formatString(msg.BadNumber, 0, 100));
	}
	return hsb;
}
function Form_Set_Hsb(hsb)
{
	SetValue(
		frm.txtHSB_Hue, Math.round(hsb[0] * 360),
		frm.txtHSB_Saturation, Math.round(hsb[1] * 100),
		frm.txtHSB_Brightness, Math.round(hsb[2] * 100)
	)
}
function Form_Get_Rgb()
{
	var rgb = new Array(0, 0, 0);
	rgb[0] = new Number(frm.txtRGB_Red.value);
	rgb[1] = new Number(frm.txtRGB_Green.value);
	rgb[2] = new Number(frm.txtRGB_Blue.value);
	
	if(rgb[0] > 255 || isNaN(rgb[0]) || rgb[0] != Math.round(rgb[0]))
	{
		rgb[0] = 255;
		frm.txtRGB_Red.value = 255;
		alert(formatString(msg.BadNumber, 0, 255));
	}
	if(rgb[1] > 255 || isNaN(rgb[1]) || rgb[1] != Math.round(rgb[1]))
	{
		rgb[1] = 255;
		frm.txtRGB_Green.value = 255;
		alert(formatString(msg.BadNumber, 0, 255));
	}
	if(rgb[2] > 255 || isNaN(rgb[2]) || rgb[2] != Math.round(rgb[2]))
	{
		rgb[2] = 255;
		frm.txtRGB_Blue.value = 255;
		alert(formatString(msg.BadNumber, 0, 255));
	}
	return rgb;
}
function Form_Set_Rgb(rgb)
{
	frm.txtRGB_Red.value = rgb[0];
	frm.txtRGB_Green.value = rgb[1];
	frm.txtRGB_Blue.value = rgb[2];
}
function SetupCursors()
{
	var hsb = Form_Get_Hsb();
	var rgb = Form_Get_Rgb();
	if(RgbToYuv(rgb)[0] >= .5) SetGradientPositionDark();
	else SetGradientPositionLight();
	if(event.srcElement != null)
	{
		if(event.srcElement.id == "pnlGradient_Top") return;
		if(event.srcElement.id == "pnlVertical_Top") return;
	}
	var x;
	var y;
	var z;

	if(ColorMode >= 0 && ColorMode <= 2)
		for(var i = 0; i < 3; i++)
			hsb[i] *= 255;

	switch(ColorMode)
	{
		case 0:
			x = hsb[1];
			y = hsb[2];
			z = hsb[0] == 0 ? 1 : hsb[0];
			break;
		case 1:
			x = hsb[0] == 0 ? 1 : hsb[0];
			y = hsb[2];
			z = hsb[1];
			break;
		case 2:
			x = hsb[0] == 0 ? 1 : hsb[0];
			y = hsb[1];
			z = hsb[2];
			break;
		case 3:
			x = rgb[2];
			y = rgb[1];
			z = rgb[0];
			break;
		case 4:
			x = rgb[2];
			y = rgb[0];
			z = rgb[1];
			break;
		case 5:
			x = rgb[0];
			y = rgb[1];
			z = rgb[2];
			break;
	}

	y = 255 - y;
	z = 255 - z;
	
	SetBgPosition(pnlGradientPosition, x - 5, y - 5);
	pnlVerticalPosition.style.top = (z+27) + "px";
}
function SetupGradients()
{
	var hsb = Form_Get_Hsb();
	var rgb = Form_Get_Rgb();
	switch(ColorMode)
	{
		case 0:
			SetBg(pnlGradientHsbHue_Hue, RgbToHex(HueToRgb(hsb[0])));
			break;
		case 1:
			var b = new Array();
			for(var i = 0; i < 3; i++)
				b[i] = Math.round(hsb[2] * 255);

			SetBg(
				pnlGradientHsbHue_Hue, RgbToHex(HueToRgb(hsb[0])),
				pnlVerticalHsbSaturation_Hue, RgbToHex(HsbToRgb(new Array(hsb[0], 1, hsb[2]))),
				pnlVerticalHsbSaturation_White, RgbToHex(b)
			);
			
			pnlGradientRgb_Overlay1.filters[0].opacity = (100 - Math.round(hsb[1] * 100));
			break;
		case 2:
			SetBg(pnlVerticalHsbBrightness_Hue, RgbToHex(HsbToRgb(new Array(hsb[0], hsb[1], 1))));
			pnlGradientRgb_Overlay1.filters[0].opacity = (100 - Math.round(hsb[2] * 100));
			break;
		case 3:
			pnlGradientRgb_Invert.filters[3].opacity = 100 - Math.round((rgb[0] / 255) * 100);
			SetBg(
				pnlVerticalRgb_Start, RgbToHex(new Array(0xFF, rgb[1], rgb[2])),
				pnlVerticalRgb_End, RgbToHex(new Array(0x00, rgb[1], rgb[2]))
			);
			break;
		case 4:
			pnlGradientRgb_Invert.filters[3].opacity = 100 - Math.round((rgb[1] / 255) * 100);
			SetBg(
				pnlVerticalRgb_Start, RgbToHex(new Array(rgb[0], 0xFF, rgb[2])),
				pnlVerticalRgb_End, RgbToHex(new Array(rgb[0], 0x00, rgb[2]))
			);
			break;
		case 5:
			pnlGradientRgb_Invert.filters[3].opacity = 100 - Math.round((rgb[2] / 255) * 100);
			SetBg(
				pnlVerticalRgb_Start, RgbToHex(new Array(rgb[0], rgb[1], 0xFF)),
				pnlVerticalRgb_End, RgbToHex(new Array(rgb[0], rgb[1], 0x00))
			);
			break;
		default:
	}
}
function SetGradientPositionDark()
{
	if(GradientPositionDark) return;
	GradientPositionDark = true;
	pnlGradientPosition.style.backgroundImage = "url(GradientPositionDark.gif)";
}
function SetGradientPositionLight()
{
	if(!GradientPositionDark) return;
	GradientPositionDark = false;
	pnlGradientPosition.style.backgroundImage = "url(GradientPositionLight.gif)";
}
function pnlGradient_Top_Click()
{
	event.cancelBubble = true;
	SetGradientPosition(event.clientX - 5, event.clientY - 5);
	pnlGradient_Top.className = "GradientNormal";
}
function pnlGradient_Top_MouseMove()
{
	event.cancelBubble = true;
	if(event.button != 1) return;
	SetGradientPosition(event.clientX - 5, event.clientY - 5);
}
function pnlGradient_Top_MouseDown()
{
	event.cancelBubble = true;
	SetGradientPosition(event.clientX - 5, event.clientY - 5);
	pnlGradient_Top.className = "GradientFullScreen";
}
function pnlGradient_Top_MouseUp()
{
	event.cancelBubble = true;
	SetGradientPosition(event.clientX - 5, event.clientY - 5);
	pnlGradient_Top.className = "GradientNormal";
}
function Document_MouseUp()
{
	event.cancelBubble = true;
	pnlGradient_Top.className = "GradientNormal";
}
function SetVerticalPosition(z)
{
	if(z < 27) z = 27;
	if(z > 282) z = 282;
	pnlVerticalPosition.style.top = z + "px";
	z = 1 - ((z - 27) / 255);

	switch(ColorMode)
	{
		case 0:
			if(z == 1) z = 0;
			frm.txtHSB_Hue.value = Math.round(z * 360);
			Hsb_Changed();
			break;
		case 1:
			frm.txtHSB_Saturation.value = Math.round(z * 100);
			Hsb_Changed();
			break;
		case 2:
			frm.txtHSB_Brightness.value = Math.round(z * 100);
			Hsb_Changed();
			break;
		case 3:
			frm.txtRGB_Red.value = Math.round(z * 255);
			Rgb_Changed();
			break;
		case 4:
			frm.txtRGB_Green.value = Math.round(z * 255);
			Rgb_Changed();
			break;
		case 5:
			frm.txtRGB_Blue.value = Math.round(z * 255);
			Rgb_Changed();
			break;
	}
}
function pnlVertical_Top_Click()
{
	SetVerticalPosition(event.clientY - 5);
	event.cancelBubble = true;
}
function pnlVertical_Top_MouseMove()
{
	if(event.button != 1) return;
	SetVerticalPosition(event.clientY - 5);
	event.cancelBubble = true;
}
function pnlVertical_Top_MouseDown()
{
	SetVerticalPosition(event.clientY - 5);
	event.cancelBubble = true;
}
function pnlVertical_Top_MouseUp()
{
	SetVerticalPosition(event.clientY - 5);
	event.cancelBubble = true;
}
function SetCookie(name, value)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 0x9A7EC800);
	document.cookie = name + "=" + escape(value) + "; expires=" + expires.toUTCString();
}
function GetCookie(name)
{
	var i = 0;
	while(document.cookie.indexOf(name + "=", i) != -1)
	{
		var value = document.cookie.substr(document.cookie.indexOf(name + "=", i));
		value = value.substr(name.length + 1);
		if(value.indexOf(";") != -1)
			if(value.indexOf(";") == 0)
				value = "";
			else
				value = value.substr(0, value.indexOf(";"));
		return unescape(value);
	}
	return "";
}
function RgbIsWebSafe(rgb)
{
	var hex = RgbToHex(rgb);
	for(var i = 0; i < 3; i++)
		if("00336699CCFF".indexOf(hex.substr(i*2, 2)) == -1) return false;
	return true;
}
function RgbToWebSafeRgb(rgb)
{
	var safeRgb = new Array(rgb[0], rgb[1], rgb[2]);
	if(RgbIsWebSafe(rgb)) return safeRgb;
	var safeValue = new Array(0x00, 0x33, 0x66, 0x99, 0xCC, 0xFF);	
	for(var i = 0; i < 3; i++)
		for(var j = 1; j < 6; j++)
			if(safeRgb[i] > safeValue[j-1] && safeRgb[i] < safeValue[j])
			{
				if(safeRgb[i] - safeValue[j-1] > safeValue[j] - safeRgb[i]) 
					safeRgb[i] = safeValue[j];
				else
					safeRgb[i] = safeValue[j-1];
				break;
			}
	return safeRgb;
}
function RgbToYuv(rgb)
{
	var yuv = new Array();
	
	yuv[0] = (rgb[0] * 0.299 + rgb[1] * 0.587 + rgb[2] * 0.114) / 255;
	yuv[1] = (rgb[0] * -0.169 + rgb[1] * -0.332 + rgb[2] * 0.500 + 128) / 255;
	yuv[2] = (rgb[0]* 0.500 + rgb[1] * -0.419 + rgb[2] * -0.0813 + 128) / 255;
	
	return yuv;
}
function RgbToHsb(rgb)
{
	var sRgb = new Array(rgb[0], rgb[1], rgb[2]);
	var min = new Number(1);
	var max = new Number(0);
	var delta = new Number(1);
	var hsb = new Array(0, 0, 0);
	var deltaRgb = new Array();

	for(var i = 0; i < 3; i++)
	{
		sRgb[i] = rgb[i] / 255;
		if(sRgb[i] < min) min = sRgb[i];
		if(sRgb[i] > max) max = sRgb[i];
	}

	delta = max - min;
	hsb[2] = max;

	if(delta == 0) return hsb;

	hsb[1] = delta / max;

	for(var i = 0; i < 3; i++)
		deltaRgb[i] = (((max - sRgb[i]) / 6) + (delta / 2)) / delta;

	if (sRgb[0] == max)
		hsb[0] = deltaRgb[2] - deltaRgb[1];
	else if (sRgb[1] == max)
		hsb[0] = (1 / 3) + deltaRgb[0] - deltaRgb[2];
	else if (sRgb[2] == max)
		hsb[0] = (2 / 3) + deltaRgb[1] - deltaRgb[0];

	if(hsb[0] < 0)
		hsb[0] += 1;
	else if(hsb[0] > 1)
		hsb[0] -= 1;
	return hsb;
}
function HsbToRgb(hsb)
{
	var rgb = HueToRgb(hsb[0]);
	var s = hsb[2] * 255;

	for(var i = 0; i < 3; i++)
	{
		rgb[i] = rgb[i] * hsb[2];
		rgb[i] = ((rgb[i] - s) * hsb[1]) + s;
		rgb[i] = Math.round(rgb[i]);
	}
	return rgb;
}
function RgbToHex(rgb)
{
	var hex = new String();
	
	for(var i = 0; i < 3; i++)
	{
		rgb[2 - i] = Math.round(rgb[2 - i]);
		hex = rgb[2 - i].toString(16) + hex;
		if(hex.length % 2 == 1) hex = "0" + hex;
	}
	
	return hex.toUpperCase();
}
function HexToRgb(hex)
{
	var rgb = new Array();
	for(var i = 0; i < 3; i++)
		rgb[i] = new Number("0x" + hex.substr(i * 2, 2));
	return rgb;	
}
function HueToRgb(hue)
{
	var degrees = hue * 360;
	var rgb = new Array(0, 0, 0);
	var percent = (degrees % 60) / 60;
	
	if(degrees < 60)
	{
		rgb[0] = 255;
		rgb[1] = percent * 255;
	}
	else if(degrees < 120)
	{
		rgb[1] = 255;
		rgb[0] = (1 - percent) * 255;
	}
	else if(degrees < 180)
	{
		rgb[1] = 255;
		rgb[2] = percent * 255;
	}
	else if(degrees < 240)
	{
		rgb[2] = 255;
		rgb[1] = (1 - percent) * 255;
	}
	else if(degrees < 300)
	{
		rgb[2] = 255;
		rgb[0] = percent * 255;
	}
	else if(degrees < 360)
	{
		rgb[0] = 255;
		rgb[2] = (1 - percent) * 255;
	}
	
	return rgb;
}