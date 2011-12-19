<!--#include file="atl_short_url.asp" -->
<%
'************************************************************************
'* Copyright (c) <2009> Ariel G. Saputra <webmaster@asp.web.id>
'*
'*	This program is free software: you can redistribute it and/or modify
'*  it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
'*  the Free Software Foundation, either version 3 of the License, or
'*  any later version.

'*  This program is distributed in the hope that it will be useful,
'*  but WITHOUT ANY WARRANTY; without even the implied warranty of
'*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'*  GNU General Public License for more details.

'*  You should have received a copy of the GNU General Public License
'*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
'************************************************************************
 
'************************************************************************
'* @TITLE:			AspTwitterLib (VBScript Twitter API Class)
'* @PACKAGE:		AspTwitterLib
'* @AUTHOR: 		Ariel G. Saputra <webmaster@asp.web.id>
'* @DESCRIPTION:	Class to update, get, format and display twitter data with VBScript and Twitter API
'* @VERSION			0.1		
'* @DATE:			May 15 2009
'* @TODO:			Implement more twitter API
'************************************************************************
class AspTwitterLib
	'********************************
	'* Class Member Declaration
	'********************************
	private m_ObjXmlHttp			'[object] Microsoft.XMLHTTP Object
	private m_ObjParams				'[object] COM Object Scripting Dictionary (* hold params for each XMLHTTP Request)
	private m_ObjAccount			'[object] COM Object Scripting Dictionary (* hold detail account after cridential verifications)
	private m_StrFormat				'[string] Return Format (currently only support XML)
	private m_StrUser				'[string] Login Name
	private m_StrPassword			'[string] password
	private m_ObjUrl				'[object] Shortenize url object << twitter_short_url.asp
	private m_StrErrorMessage		'[string] current error message
	private m_StrLastErrorMessage	'[string] last error message
	private m_IntHttpStatus			'[integer] HTTP Response Status
	private m_StrLastHttpStatus		'[integer] Last HTTP Response Status
	
	'********************************
	'* Data format property assignment
	'* [current implementation] only XML allowed
	'********************************
	Public Property Let aspTwitterDataFormat(strFormat)
		'if not (strFormat="xml" or strFormat="json" or strFormat="rss" or strFormat="atom") then
			m_StrFormat = "xml"
		'else
		'	m_StrFormat = strFormat
		'end if
	End Property
	
	'********************************
	'* User property assignment
	'********************************
	Public Property Let aspTwitterLoginUser(strUser)
		m_StrUser = strUser
	End Property
	
	'********************************
	'* Password Property assignment
	'********************************
	Public Property Let aspTwitterLoginPass(strPass)
		m_StrPassword = strPass
	End Property
	
	'********************************
	'* get Error Status
	'********************************
	public property get aspTwitterError()
		aspTwitterError=m_StrErrorMessage
	end property
	
	'********************************
	'* get HTTP Status
	'********************************
	public property get aspTwitterHttp()
		aspTwitterHttp=m_IntHttpStatus
	end property
	
	'********************************
	'* Server Object Creations
	'* 1. m_ObjXmlHttp : Msxml2.ServerXMLHTTP.3.0
	'* 2. m_ObjParams : Scripting.Dictionary
	'********************************
	private sub createServerObject()
		if not isObject(m_ObjXmlHttp) then set m_ObjXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		if not isObject(m_ObjParams) then Set m_ObjParams=Server.CreateObject("Scripting.Dictionary")
		if not isObject(m_ObjAccount) then Set m_ObjAccount=Server.CreateObject("Scripting.Dictionary")
	end sub
	
	'********************************
	'* Destroy server objects
	'********************************
	private sub destroyServerObject()
		if isObject(m_ObjXmlHttp) then set m_ObjXmlHttp = nothing
		if isObject(m_ObjParams) then Set m_ObjParams = nothing
		if isObject(m_ObjAccount) then Set m_ObjAccount = nothing
		if isObject(m_ObjUrl) then Set m_ObjUrl = nothing
	end sub

	'********************************
	'* Autolink HTML text
	'* params: [string:html]
	'********************************
	private function aspTwitterAutolink(strHtml)
		Dim objRegex,strReturn
		set objRegex = new regexp
		objRegex.Pattern = "(\b(?:(?:https?|ftp|file)://|www\.|ftp\.)(?:\([-A-Z0-9+&@#/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#/%=~_|$?!:,.]*\)|[A-Z0-9+&@#/%=~_|$]))"
		objRegex.IgnoreCase = true
		objRegex.Global = true
		strReturn = objRegex.Replace(strHtml, "<a href=""$1"" rel = ""nofollow"" target = ""_blank"">$1</a>")
		set objRegex = nothing
		aspTwitterAutolink = strReturn
	end function

	'********************************
	'* Params assignment
	'* arrParams : array -> key_1=val_1, key_2=val_2 
	'********************************
	private sub aspTwitterSetParams(arrParams)
		m_ObjParams.removeAll
		if isArray(arrParams) then
			Dim tmpParam
			for each i in arrParams
				tmpParam = split(i,"=")
				if Ubound(tmpParam) = 1 then
					m_ObjParams.Add tmpParam(0),tmpParam(1)
				end if
			next
		end if
	end sub	
	
	'********************************
	'* Check Error Status Message
	'* param: [xml: twitter response]
	'********************************
	private function aspTwitterCheckError(strXmlResponse)
		Dim strErrorMsg:strErrorMsg  = ""
		' personalize error message
		select case m_IntHttpStatus
			case 400
				strErrorMsg = "Bad Request: The request was invalid. " & _ 
							  "It is may caused by bad internet connection or " & _ 
							  "<a href=""http://apiwiki.twitter.com/Rate-limiting"" target=""_blank"">Twitter's rate limiting</a>"
			case 401 
				strErrorMsg = "Not Authorized: Authentication credentials were missing or incorrect. Check your username &amp; password"
			case 403 
				strErrorMsg = "Forbidden: The request has been refused by twitter's server"
			case 404 
				strErrorMsg = "The URL requested is invalid or the resource requested, such as a user, does not exists."	
			case 406 
				strErrorMsg = "Not Acceptable: Invalid data format requested, check your data format option."
			case 500 
				strErrorMsg = "Internal Server Error: Something is broken.  Please <a href=""http://apiwiki.twitter.com/Support"">post to the group</a> so the Twitter team can investigate."
			case 502
				strErrorMsg = "Bad Gateway: Twitter is down or being upgraded."
			case 503
				strErrorMsg = "Service Unavailable: The Twitter servers are overloaded with requests. Try again later."
			case else
				if Len(strXmlResponse) > 0 then
					Dim objXmlDom:set objXmlDom = Server.CreateObject("Microsoft.XMLDOM")
					objXmlDom.async = false
					objXmlDom.loadxml(strXmlResponse)
					objXmlDom.setProperty "SelectionLanguage", "XPath"

					Dim objSingleNode
					Set objSingleNode = objXmlDom.selectSingleNode("//hash/error")
					if not objSingleNode is nothing then
						strErrorMsg= objSingleNode.Text
					end if
					Set objXmlDom = Nothing
				else	
					strErrorMsg  = "There was no data to return."
				end if
		end select
		aspTwitterCheckError = strErrorMsg
	end function
	
	'********************************
	'* instance initialization
	'********************************
	sub class_initialize()
		m_StrFormat = "xml"
		call createServerObject
		call aspTwitterShortUrlInit(false,false,false)
	end sub
	
	'********************************
	'* instance termination
	'********************************
	sub class_terminate()
		call destroyServerObject
	end sub
	
	'********************************
	'* verify your cridentials
	'********************************
	public sub aspTwitterVerifyCredentials()
		Dim strApiUrl:strApiUrl = "http://twitter.com/account/verify_credentials."&m_StrFormat
		Dim strXmlReturn:strXmlReturn = aspTwitterCall(strApiUrl,true,false)
		response.Write(strXmlReturn)
	end sub
	
	'********************************
	'* Write Error Status
	'********************************
	public sub aspTwitterWriteError(strBefore,strAfter)
		if len(strBefore) = 0 then strBefore = "<p class=""error"">"
		if len(strAfter) = 0 then strAfter = "</p>"
		Response.Write strBefore&m_StrErrorMessage&strAfter
	end sub
	
	'********************************
	'* Shorten Url Initialization
	'* params: [string:provider], [string:user login], [string:api key]
	'********************************
	public sub aspTwitterShortUrlInit(strProvider,strUser,strApi)
		if not isObject(m_ObjUrl) then Set m_ObjUrl= new ATLShortUrl
		m_ObjUrl.aspSetProvider = strProvider
		m_ObjUrl.aspSetUser = strUser
		m_ObjUrl.aspSetApi = strApi
	end sub
	
	'********************************
	'* Shorten Url execution
	'* params: [string:long url]
	'********************************
	public function aspTwitterShortUrlGet(strUrl)
		if Len(strUrl) > 0 then 
			aspTwitterShortUrlGet = m_ObjUrl.aspShortUrlExec(strUrl)
		end if
	end function
	
	'********************************
	'* Get User Detail
	'* Return : Dictionary Object
	'* Ref : http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-users show
	'********************************
	public function aspTwitterUserDetail()
		Dim strApiUrl:strApiUrl = "http://twitter.com/users/show."&m_StrFormat
		call aspTwitterSetParams(array("id="&m_StrUser))
		Dim xmlResult:xmlResult = aspTwitterCall(strApiUrl,false,false)
		Dim objDictionary:Set objDictionary = Server.CreateObject("Scripting.Dictionary")
		if Len(xmlResult)>0 then
			Dim objXmlDom
			set objXmlDom = Server.CreateObject("Microsoft.XMLDOM")
			objXmlDom.async = false
			objXmlDom.loadxml(xmlResult)
			objXmlDom.setProperty "SelectionLanguage", "XPath"
			
			Dim objRootNode,strNode
			Set objRootNode = objXmlDom.documentElement
			For Each strNode In objRootNode.childNodes 
				if not strNode.nodeName = "status" then
					objDictionary.Add strNode.nodeName,strNode.text
				end if
			Next
			Set objRootNode = nothing
			Set objXmlDom = nothing
		End if
		Set aspTwitterUserDetail = objDictionary
		Set objDictionary = Nothing
	end function
	
	
	'********************************
	'* Get User Timeline
	'* Return : Array(array(date_1,text_1,source_1,reply_screen_name_1),array(date_2,text_2,source_2,reply_screen_name_2))
	'* ref : http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline
	'********************************
	public function aspTwitterGetUserTimeline()
		Dim strApiUrl:strApiUrl = "http://twitter.com/statuses/user_timeline."&m_StrFormat
		call aspTwitterSetParams(array("id="&m_StrUser))
		Dim strXmlReturn:strXmlReturn = aspTwitterCall(strApiUrl,false,false)
		if Len(strXmlReturn) > 0 then strXmlReturn=aspTwitterFormatXml(strXmlReturn)
		aspTwitterGetUserTimeline = strXmlReturn
	end function
	
	'********************************
	'* Get Friends Timeline
	'* Return : Array(array(date_1,text_1,source_1,reply_screen_name_1),array(date_2,text_2,source_2,reply_screen_name_2))
	'* ref : http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-friends_timeline
	'********************************
	public function aspTwitterGetFriendsTimeline(count)
		Dim strApiUrl:strApiUrl = "http://twitter.com/statuses/friends_timeline."&m_StrFormat
		if count > 200 then 
			count = 200
		elseif count < 1 then 
			count = 1
		end if
		call aspTwitterSetParams(array("count="&count))
		Dim strXmlReturn:strXmlReturn = aspTwitterCall(strApiUrl,false,true)
		if Len(strXmlReturn) > 0 then strXmlReturn=aspTwitterFormatXml(strXmlReturn)
		aspTwitterGetFriendsTimeline = strXmlReturn
	end function

	'********************************
	'* Format user timeline
	'* param : XML
	'* Return : Array(array(date_1,text_1,source_1,reply_screen_name_1),array(date_2,text_2,source_2,reply_screen_name_2))
	'* ref : http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline
	'********************************
	private function aspTwitterFormatXml(strXml)
		Dim objXmlDom:set objXmlDom = Server.CreateObject("Microsoft.XMLDOM")
		With objXmlDom
			.async = false
			.setProperty "SelectionLanguage", "XPath"
			.loadxml(strXml)
		End With
		
		Dim objRootNode:Set objRootNode = objXmlDom.selectNodes("/statuses/status")
		
		Dim intCounter:intCounter = 0
		
		' date,text,source,reply_screen_name,author name, author screen name, author avatar url
		Dim arrUserStatus()
		
		Dim oStatusesNodes,oUserNodes
		Dim iHolders(7)
		For Each oStatusesNodes in objRootNode
			redim preserve arrUserStatus(intCounter+1)
			iHolders(0) = oStatusesNodes.selectSingleNode("created_at").Text
			iHolders(1) = aspTwitterAutolink(oStatusesNodes.selectSingleNode("text").Text)
			iHolders(2) = oStatusesNodes.selectSingleNode("source").Text
			iHolders(3) = oStatusesNodes.selectSingleNode("in_reply_to_screen_name").Text
			
			Set oUserNodes = oStatusesNodes.selectSingleNode("user")
			if oUserNodes.hasChildNodes() then
				iHolders(4) = oUserNodes.selectSingleNode("name").Text
				iHolders(5) = oUserNodes.selectSingleNode("screen_name").Text
				iHolders(6) = oUserNodes.selectSingleNode("profile_image_url").Text
			end if
			Set oUserNodes = Nothing
			
			arrUserStatus(intCounter) = iHolders
			intCounter = intCounter + 1
		Next
	
		Set objRootNode = Nothing
		Set objXmlDom = Nothing
		
		aspTwitterFormatXml=arrUserStatus 
	end function
	
	'********************************
	'* Update User Status
	'* strStatus : (string) status
	'* Return : XML
	'* Ref : http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0update
	'********************************
	public function aspTwitterUpdateStatus(strStatus)
		Dim strApiUrl:strApiUrl = "http://twitter.com/statuses/update."&m_StrFormat
		Dim arrTmpParams: arrTmpParams = array("status="&strStatus)
		call aspTwitterSetParams(arrTmpParams)
		Dim strXml
		strXml = aspTwitterCall(strApiUrl,true,true)
		Dim objXmlDom:set objXmlDom = Server.CreateObject("Microsoft.XMLDOM")
		With objXmlDom
			.async = false
			.setProperty "SelectionLanguage", "XPath"
			.loadxml(strXml)
		End With
		
		Dim objSingleNode,intReturnId
		Set objSingleNode = objXmlDom.selectSingleNode("//status/id")
		if not objSingleNode is nothing then
			intReturnId = objSingleNode.Text
		else
			intReturnId = 0
		end if
		Set objXmlDom = Nothing
		aspTwitterUpdateStatus = intReturnId
	end function
	
	'********************************
	'* Open Remote Page
	'* Return : Remote Page Content (XML?)
	'********************************
	private function aspTwitterCall(strUrl,bolPost,bolLogin)
		
		Dim strParameters,intTimeout
		intTimeout = 5000
		if isObject(m_ObjParams) then
			for each i in m_ObjParams
				if len(i) > 0 and len(m_ObjParams.Item(i)) > 0 then 
					strParameters = strParameters & "&"&i&"="&server.URLencode(m_ObjParams.Item(i))
				end if
			next
		end if
		
		m_StrErrorMessage = ""
		m_IntHttpStatus = 200
		
		if bolPost then
			if bolLogin then
				m_ObjXmlHttp.Open "POST", strUrl, false, m_StrUser, m_StrPassword
				m_ObjXmlHttp.setRequestHeader "Authorization", "Basic " & Base64Encode(m_StrUser&":"&m_StrPassword)
			else
				m_ObjXmlHttp.Open "POST", strUrl, false
			end if
			
			'm_ObjXmlHttp.setTimeouts intTimeout, intTimeout, intTimeout, intTimeout
			m_ObjXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			if len(strParameters) > 0 then 
				strParameters = Mid(strParameters,2)
				m_ObjXmlHttp.Send strParameters
			else
				m_ObjXmlHttp.Send null
			end if
		else
			if len(strParameters) > 0 then 
				strParameters = Mid(strParameters,2)
				Dim intStrPos
				intStrPos = Instr(strUrl, "?")
				if not IsNull(intStrPos) and intStrPos > 0 then 
					strUrl = strUrl & "&"
				else
					strUrl = strUrl & "?"
				end if
				strUrl = strUrl & strParameters
			end if
			if bolLogin then
				m_ObjXmlHttp.Open "GET", strUrl, false, m_StrUser, m_StrPassword
				m_ObjXmlHttp.setRequestHeader "Authorization", "Basic " & Base64Encode(m_StrUser&":"&m_StrPassword)
			else
				m_ObjXmlHttp.Open "GET", strUrl, false
			end if
			'm_ObjXmlHttp.setTimeouts intTimeout, intTimeout, intTimeout, intTimeout
			m_ObjXmlHttp.Send null
		end if
		
		m_IntHttpStatus = m_ObjXmlHttp.status
		
		Dim strXmlResponse:strXmlResponse = m_ObjXmlHttp.responseText
		
		Dim strRequestStatus:strRequestStatus = aspTwitterCheckError(strXmlResponse)
		if Len(strRequestStatus) > 0 then
			m_StrErrorMessage = strRequestStatus
			strXmlResponse = ""
		end if
		aspTwitterCall = strXmlResponse
	end function
	
	' Base64 Encoding
	' http://www.pstruh.cz/tips/detpg_Base64Encode.htm
	' rfc1521
	' 2001 Antonin Foller, PSTRUH Software, http://pstruh.cz
	Private Function Base64Encode(inData)
	  Const Base64 = _
	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	  Dim sOut, I
	  
	  'For each group of 3 bytes
	  For I = 1 To Len(inData) Step 3
		Dim nGroup, pOut
		
		'Create one long from this 3 bytes.
		nGroup = &H10000 * Asc(Mid(inData, I, 1)) + _
		  &H100 * MyASC(Mid(inData, I + 1, 1)) + _
		  MyASC(Mid(inData, I + 2, 1))
		
		'Oct splits the long To 8 groups with 3 bits
		nGroup = Oct(nGroup)
		
		'Add leading zeros
		nGroup = String(8 - Len(nGroup), "0") & nGroup
		
		'Convert To base64
		pOut = Mid(Base64, CLng("&o" & Mid(nGroup, 1, 2)) + 1, 1) + _
		  Mid(Base64, CLng("&o" & Mid(nGroup, 3, 2)) + 1, 1) + _
		  Mid(Base64, CLng("&o" & Mid(nGroup, 5, 2)) + 1, 1) + _
		  Mid(Base64, CLng("&o" & Mid(nGroup, 7, 2)) + 1, 1)
		
		'Add the part To OutPut string
		sOut = sOut + pOut
		
	  Next
	  Select Case Len(inData) Mod 3
		Case 1: '8 bit final
		  sOut = Left(sOut, Len(sOut) - 2) + "=="
		Case 2: '16 bit final
		  sOut = Left(sOut, Len(sOut) - 1) + "="
	  End Select
	  Base64Encode = sOut
	End Function

	Private Function MyASC(OneChar)
	  If OneChar = "" Then MyASC = 0 Else MyASC = Asc(OneChar)
	End Function
	
end class
%>