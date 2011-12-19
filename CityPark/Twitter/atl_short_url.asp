<%
'************************************************************************
'* Copyright (c) <2009> Ariel G. Saputra <webmaster@asp.web.id>
'*  this file is part of AspTwitterLib
'*
'*	AspTwitterLib is free software: you can redistribute it and/or modify
'*  it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
'*  the Free Software Foundation, either version 3 of the License, or
'*  any later version.

'*  This program is distributed in the hope that it will be useful,
'*  but WITHOUT ANY WARRANTY; without even the implied warranty of
'*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'*  GNU General Public License for more details.

'*  You should have received a copy of the GNU General Public License
'*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
'*
'* @TITLE:			ATLShortUrl
'* @PACKAGE:		AspTwitterLib
'* @AUTHOR: 		Ariel G. Saputra <webmaster@asp.web.id>
'* @DESCRIPTION:	Shorten url class, currently support tinyurl, is.gd, bit.ly, hex.io
'* @DATE:			May 15 2009
'* @TODO:			add more short url services
'************************************************************************

class ATLShortUrl
	
	private m_StrProvider,m_StrApiUrl,m_StrUserName,m_StrApiKey
	
	public property let aspSetProvider(strProvider)
		m_StrProvider = Lcase(strProvider)
		select case m_StrProvider
			case "bitly"
				m_StrApiUrl = "http://api.bit.ly/shorten?version=2.0.1&format=xml&longUrl=[:URL:]&login=[:LOGIN:]&apiKey=[:API:]"
			case "isgd"
				m_StrApiUrl = "http://is.gd/api.php?longurl=[:URL:]"
			case "hexio"
				m_StrApiUrl = "http://hex.io/api-create.php?url=[:URL:]"
			case else
				m_StrApiUrl = "http://tinyurl.com/api-create.php?url=[:URL:]"
		end select
	end property
	
	public property let aspSetUser(strUser)
		m_StrUserName = strUser
	end property
	
	public property let aspSetApi(strApi)
		m_StrApiKey = strApi
	end property
	
	sub class_initialize()
		me.aspSetProvider = "tinyurl"
		m_StrUserName = m_StrApiKey = ""
	end sub
	
	sub class_terminate()
	end sub
	
	private function aspGrabUrl(strUrl)
		select case m_StrProvider
			case "bitly"
				Dim oXmlDom,strGrabUrl
				set oXmlDom = Server.CreateObject("Microsoft.XMLDOM")
				oXmlDom.async = false
				oXmlDom.setProperty "SelectionLanguage", "XPath"
				oXmlDom.loadxml(strUrl)
				strGrabUrl = oXmlDom.selectSingleNode("/bitly/results/nodeKeyVal/shortUrl").Text
				Set oXmlDom = Nothing
				aspGrabUrl = strGrabUrl
			case else
				aspGrabUrl = strUrl
		end select
	end function
	
	public function aspShortUrlExec(strUrl)
		if Len(m_StrApiUrl) > 0 then
			Dim oXml,strRealUrl,strShortUrl
			strRealUrl = Replace(m_StrApiUrl, "[:URL:]", strUrl, 1, -1, 1)
			strRealUrl = Replace(strRealUrl, "[:LOGIN:]", m_StrUserName, 1, -1, 1)
			strRealUrl = Replace(strRealUrl, "[:API:]", m_StrApiKey, 1, -1, 1)
			set oXml = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
			oXml.Open "GET", strRealUrl, false
			oXml.Send null
			strShortUrl = oXml.responseText
			Set oXml = nothing
			aspShortUrlExec = aspGrabUrl(strShortUrl)
		else
			aspShortUrlExec = false
		end if
	end function
	
end class
%>