<!--#include file="$functions.asp"-->
<%

templatelocation = "/sites/" & Application(ScriptName & "SiteName") & "/layout/" & Session("SiteLang") & "/"

Sub ProcessLayoutBlock(strCommand)
	Select Case LCase(strCommand)

		Case "mostviewcontent"
	    	mostview 1,10
		Case "mostviewproducts"
	    	mostview 2,10
		
        Case "getsonperday"
	    	GetSonPerDay(Getsession("contentiD"))

		Case "minicalendar"
	    	ExecutePage "/blocks/minicalendar.asp"
		
		Case "calendar"
	    	ExecutePage "/blocks/calendar.asp"

			Case "getsonmenu"
	    	getsonmenu(Getsession("contentiD"))
        
        Case "getsononlymenu"
	    	getsononlymenu(Getsession("contentiD"))
 
        Case "getsonsamelevelmenu"
	    	getsonsamelevelmenu(Getsession("contentiD"))
     
        Case "getfathermenu"
	    	getfathermenu(Getsession("contentiD"))
   

        Case "getsonaccmenu"
	    	getsonaccmenu(Getsession("contentiD"))
       
	   Case "getsamelevelaccmenu"
	    	getsamelevelaccmenu(Getsession("contentiD"))
            
        Case "getsons"
	    	Showallsons(Getsession("contentiD"))
       
        Case "breadcrumb"
	    	getbreadcrumb(Getsession("contentiD"))
       
        Case "loginblock"
	    	ExecutePage "/blocks/login.asp"
	  
        Case "easyphotos"
	    	ExecutePage "/easy_bring_images.asp"
	   
        Case "allcategory"
	    	ExecutePage "/blocks/Allcategory.asp"
   
        Case "3mivtzahotel"
	    	ExecutePage "/blocks/3MivtzaHotel.asp"
	   
	   Case "searchresult"
	   	   ExecutePage "/blocks/searchresult.asp"
	   	    
	  Case "minicart"
	    	ExecutePage "/blocks/minicart.asp"
	    
	    Case "shortloginblock"
	    	ExecutePage "/blocks/shortlogin.asp"
	    Case "shortlogitouser"
	    	ExecutePage "/blocks/shortlogintouser.asp"
	    
	    
	    Case "allnews"
			ExecutePage "/blocks/allnews.asp"
						
    	Case "search"
    	    ExecutePage "/blocks/search_box.asp"
    	    
    	Case "contactform"
	        ExecutePage "/blocks/contactformblock.asp"
    	
    	Case "contacttemplate"
	        ExecutePage "/blocks/contectformtamplate.asp"
    	
    	Case "contactformpage"
	        ExecutePage "/blocks/contactformpage.asp"
	    
	    Case "mailinglist"
	        ExecutePage "/blocks/mailinglistblock.asp"  
	    
	    Case "poll"
	        ExecutePage "/poll.asp"  
	   
		Case "maraqueimages"
	        ExecutePage "/blocks/gallerymarquee/marquee.asp"  
		
		Case "categorycontent"
	        ExecutePage "/blocks/categoryblock.asp"  
		
		Case "categorysdomark"
	        ExecutePage "/blocks/categorysdomark.asp"  
		
		
		Case "lastvideo"
	        ExecutePage "/blocks/lastvideo.asp"  
		
		Case "last3video"
	        ExecutePage "/blocks/last3video.asp"  
		
        Case "last8zuk"
	        ExecutePage "/blocks/last8zuk.asp"  
			
		Case "last10nativ"
	        ExecutePage "/blocks/last10nativ.asp"  
		
        Case "lastnews"
	        ExecutePage "/blocks/last_news.asp"  
	
	   	Case "logos"
	        ExecutePage "/blocks/logosblock.asp"  
	   
	   	Case "question"
	        ExecutePage "/blocks/question.asp"  
	 
	  	Case "sitemap"
	        ExecutePage "/blocks/sitemap.asp"  
	  	
        Case "gallery"
	        ExecutePage "/user/gallery.asp"  
	  	
	  	Case "last_ads"
	        ExecutePage "/blocks/last_ads.asp"  
	    
	    Case "last_ads_jobcity"
	        ExecutePage "/blocks/last_ads_jobcity.asp"    
	     
		Case "last_ads_viewpoint"
	        ExecutePage "/blocks/last_ads_viewpoint.asp"   
		 
		Case "title"
	    	Print GetPageTitle()
	    
	    Case "description"
	    	Print GetPageDesc()
	    
	    Case "keywords"
	    	Print GetPagekeywords()
	    	
    	Case "layout"
    		Print Block_Layout()
    		    
		Case "comments"
			ExecutePage "/comments.asp"
		
        Case "soncomments"
			ExecutePage "/soncomments.asp"
		
		Case "blogcomments"
			ExecutePage "/blogcomments.asp"
	
		Case "faq"
		ExecutePage "/faq.asp"
		
		Case "sendtofriend"
	      ExecutePage "/blocks/sendtofriend.asp"
	
		Case "tagcloud"
		  ExecutePage "/blocks/tagcloud.asp"
		
        Case "contenttagcloud"
		  ExecutePage "/blocks/contenttagcloud.asp"
		
        Case "smallfacebook"
			ExecutePage "/blocks/smallfacebook.asp"
			
         Case "imagevideo"
         SQLa = "SELECT * FROM [Content] Where ID=" &  Getsession("contentiD")
         Set objRsa = OpenDB(SQLa)
         print "<link rel=""stylesheet"" type=""text/css"" href=""/css/shadowbox.css"">"
         print "<script type=""text/javascript"" src=""/js/shadowbox.js""></script>"
         print "<script type=""text/javascript"">"
         print "Shadowbox.init();"
         print "</script>"

         If objRsa("flv") <> "" Then
        ' print "<link rel=""stylesheet"" href=""/css/videolightbox.css"" type=""text/css"" />" &vbCrLf
		' print "<style type=""text/css"">#videogallery a#videolb{display:none}</style>" &vbCrLf
		 'print "<link rel=""stylesheet"" type=""text/css"" href=""/css/overlay-minimal.css""/>" &vbCrLf
		 'print "<script src=""/js/jquery.tools.min.js"" type=""text/javascript""></script>"&vbCrLf
        ' print "<script type=""text/javascript"" src=""/js/swfobject.js""></script>" &vbCrLf
		' print "<script src=""/js/videolightbox.js"" type=""text/javascript""></script>" &vbCrLf
        ' print "<script type=""text/javascript"">"&vbCrLf
        ' print "   function onYouTubePlayerReady(playerId) { "&vbCrLf
        ' print  " ytplayer = document.getElementById(""video_overlay"");" &vbCrLf
        ' print  " ytplayer.setVolume(100); "&vbCrLf
        ' print "} "&vbCrLf
        ' print "</script> "
        ' print "<div id=""videogallery"">"&vbCrLf
	   ' print  "<a rel=""#voverlay"" href=""/lightplayer.swf?url=" & objRsa("flv") & "&volume=100"" title=""CarensTVC""><img src=" & objRsa("Image") &" alt="& objRsa("Name") &" /><span></span></a>"&vbCrLf
	   ' print "</div>"&vbCrLf

        
        
         Elseif objRsa("Youtube") <> "" Then
            ' print "<script type=""text/javascript"" src=""/js/jquery.youtubin.js""></script>"&vbCrLf
            ' print "<script type=""text/javascript"">"&vbCrLf

           ' print "$(function () {"&vbCrLf
           ' print "     $('a.youtubin').youtubin();"&vbCrLf
           ' print " $('a.youtubin-click').youtubin({"&vbCrLf
          '  print "replaceTime: 'click'"&vbCrLf
           ' print " });"&vbCrLf

            'print " });"&vbCrLf
           ' print "</script>"&vbCrLf
           ' print "<a href=""" & objRsa("Youtube")  & """ rel=""nofollow"" class=""youtubin""></a>"&vbCrLf
            print "<a rel=""shadowbox;width=405;height=340;player=swf"" title=""Ebon Coast"" href="& objRsa("Youtube")  &"><img src="& objRsa("Image")&" alt="" class=""border""></a>"
        
         Else ' image
         	'print "<img src=""" & objRsa("Image") & """ width=""425"" height=""344"" border=""0"" />"&vbCrLf
            print "<a href=" & objRsa("Image") & " rel=""shadowbox""><img src=""" & objRsa("Image") & """ width=""200"" height=""120"" border=""0"" /></a>"

         End If
         CloseDB(objRsa)

        
        
        Case "fathername"
         SQLf = "SELECT [Content].Name As FName, Contentfather.ContentID, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.FatherID WHERE [Contentfather].ContentID=" &  Getsession("contentiD")
         Set objRsf = OpenDB(SQLf)
         If objRsf.recordcount > 0  Then
           Print objRsf("fName")
           CloseDB(objRsf)
        Else
        SQLq = "Select Name From Content Where id=" & Getsession("contentiD")
         Set objRsq = OpenDB(SQLq)
         Print objRsq("Name")
         CloseDB(objRsq)
        End If
       
        Case "fatherurl"
         SQLf = "SELECT [Content].Urltext As Furl, Contentfather.ContentID, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.FatherID WHERE [Contentfather].ContentID=" &  Getsession("contentiD")
         Set objRsf = OpenDB(SQLf)
         If objRsf.recordcount > 0  Then
           Print ReplaceSpaces(objRsf("Furl"))
           CloseDB(objRsf)
        Else
        SQLq = "Select Urltext From Content Where id=" & Getsession("contentiD")
         Set objRsq = OpenDB(SQLq)
         Print ReplaceSpaces(objRsq("Urltext"))
         CloseDB(objRsq)
        End If
		

		Case "galleryname"
        SQLg = "Select Name From Content Where id=" & Getsession("contentiD")
        print GaleeryName
         Set objRsg = OpenDB(SQLg)
         Print objRsg("Name")
         CloseDB(objRsg)

		
		Case "forums"
			ExecutePage "/forum/block/default.asp"
		
		Case "lastforums"
			Set objRsf = OpenDB("SELECT TOP 5 * FROM Forummessage WHERE SiteID = " & SiteID & "Order By Id desc")
            n=0
            Do While Not objRsf.eof AND n <= 4
			Template= Geturl(Templatelocation & "lastforums.html")
            For Each Field In objRsf.Fields
					value = objRsf(Field.Name)
						If Len(value) > 0 Then
							    Template = Replace(Template, "[" & Field.Name & "]", value)
							    Template = Replace(Template, "[/" & Field.Name & "]", ReplaceSpaces(value))
						Else
							    Template = Replace(Template, "[" & Field.Name & "]", "")
						End If
					Next
							 ProcessLayout(Template)
            n=n+1
            objRsf.Movenext
                loop
			CloseDB(objRsf)

		Case "parkranges"
		
			Set objRng = OpenDB("select * from parking_shortrange where parkid = "&request("id"))
			Do while NOT objRng.EOF
            print " מיום "&objRng("fromday")&" ליום "&objRng("today")& " משעה "&objRng("fromhour")&" לשעה "&objRng("tohour")&" המחיר לשעה ראשונה "&objRng("firstHourPrice")&" ולכל רבע שעה נוספת, "&objRng("extraQuarterPrice")&", מחיר ליום שלם "&objRng("allDayPrice")&"<hr/>"
            objRng.Movenext
                loop
			CloseDB(objRng)
			
        Case "simulator"
		  ExecutePage "/blocks/simulator.asp"

        Case "parkingtweet"
		  ExecutePage "/blocks/parkingtweet.asp"

        Case "allproductcategorys"
			ExecutePage "/blocks/allproductcategorys.asp"
			
		Case "allgallerys"
			ExecutePage "/blocks/allgallerys.asp"
	    
	    Case "header-includes"
	    	Print Block_HeaderIncludes()
			         
	    Case "contenttop"
			Set objRs = OpenDB("SELECT Contenttop FROM Site WHERE SiteID = " & SiteID)
			ProcessLayout objRs("Contenttop")
			objRs.Close
			
	    Case "contentbuttom"
			Set objRs = OpenDB("SELECT ContentButtom FROM Site WHERE SiteID = " & SiteID)
			ProcessLayout objRs("ContentButtom")
			objRs.Close
			
			
	   
	    Case "gal"
			ExecutePage "/blocks/gal.asp"
	   
	   
		 Case "rightmenu"
		  If GetSession("Type") = "Admin" then 
				print "<link rel=""stylesheet"" type=""text/css"" href=""/css/vscontext.css"" />"
				print "<script type=""text/javascript"" src=""/js/vscontext.jquery.asp?" & request.QueryString & """></script>" & vbCrLf    
	       End If
	    

		Case "printpage"
		print "<a href=""javascript:window.print()"">גרסא להדפסה</a>"

		
		Case Else
			Print "[" & strCommand & "]"
	End Select
End Sub



' Gets page header includes.
Function Block_HeaderIncludes()
    	Source =  "<link rel=""stylesheet"" type=""text/css"" href=""/CSS/ui.notify.css"" />"
    Source = Source & "<link rel=""stylesheet"" media=""all"" type=""text/css"" href=""" & Templatelocation & "style/style.css"" />" & vbCrLf
 '   Source = Source & "<link rel=""stylesheet"" media=""all"" type=""text/css"" href=""/css/jquery-ui.css"" />" & vbCrLf

    If GetSession("Type") = "Admin" Then 
        Source = Source & "<link rel=""stylesheet"" type=""text/css"" href=""/css/vscontext.css"" />" & vbCrLf
    End If
    
    Source = Source & "<script type=""text/javascript"" src=""/js/jquery.js""></script>" & vbCrLf
Source = Source & "<script type=""text/javascript"" src=""/js/jquery.metadata.js""></script>" & vbCrLf
    If GetSession("Type") = "Admin" Then 
        Source = Source & "<script type=""text/javascript"" src=""/js/vscontext.jquery.asp?" & request.QueryString & """></script>" & vbCrLf    
    End If
  
    Source = Source & "<script type=""text/javascript"" src=""/js/jquery-ui.js""></script>" & vbCrLf
   Source = Source & "<script type=""text/javascript"" src=""/js/ui.notify.js"" ></script>"
         Source = Source & "<script type=""text/javascript"" src=""/js/validate.asp"" ></script>" & vbCrLf
   Source = Source & "<script type=""text/javascript"" src=""/js/ajax.asp""></script>" & vbCrLf
	Source = Source & Config_Header_Includes
	
		If Request.QueryString("notificate") <> "" Then
	
	Source = Source & "<div id=""notifications""><div id=""default""><h1>#{title}</h1></div></div><script>$(document).ready(function () {var $notifications = $(""#notifications"").notify();$notifications.notify(""create"", ""default"", {title: '" & Request.QueryString("notificate") & "'});});</script>"

	End If 
	
	Block_HeaderIncludes = Source 

End Function

' Processes the header layout and prints it.
Sub Header()
	If Request.QueryString("h") = "" Then
	   ProcessLayout GetURL(templatelocation & "header.html")
	Else
		ProcessLayout GetURL(templatelocation & Request.QueryString("h") & ".html")
	End if
End Sub

' Processes the footer layout and prints it.
Sub Bottom()
if Request("Ajax") <> "True" Then
	    ProcessLayout GetURL(templatelocation   & "footer.html")
end if
End Sub

Sub AdminHeader()
	If Session("SiteLang") <> 1 Then
	ProcessLayout GetURL("/admin/layout/headerltr.html")
	Else
	ProcessLayout GetURL("/admin/layout/header.html")
	End If
	IsHeaderCalled = True
End Sub

' Processes the footer layout and prints it.
Sub AdminBottom()
	If Session("SiteLang") <> 1 Then
	'ProcessLayout GetURL(templatelocation   & "footerltr.html")
Print  GetURL("/admin/layout/footerltr.html")
	Else
	
	Print GetURL("/admin/layout/footer.html")

	End If

End Sub


' Gets the current page Description.
Function GetPageDesc()
	If GetSession("PageDesc") = ""  Then
		GetPageDesc = Application(ScriptName & "Description")
	Else
		GetPageDesc = GetSession("PageDesc")
	End If
End Function

' Gets the current page title.
Function GetPageTitle()
	If GetSession("PageTitle") = ""  Then
		GetPageTitle = Application(ScriptName & "Title")
	Else
		GetPageTitle = GetSession("PageTitle")
	End If
End Function

' Gets the current page Keywords.
Function GetPageKeywords()
	If GetSession("PageKeywords") = ""  Then
		GetPageKeywords = Application(ScriptName & "Keywords")
	Else
		GetPageKeywords = GetSession("PageKeywords")
	End If
End Function


' Sets the page title.
' NOTE: YOU SHOULD'NT CALL THIS PROCEDURE AFTER CALLING Header()
Sub SetPageTitle(value)
	If IsHeaderCalled = False Then
		SetSession "PageTitle", value 
	Else
		Response.Write "Error #1 occurd in $xmlblocks.asp (SetPageTitle)."
	End If
End Sub

' Sets the page Description.
' NOTE: YOU SHOULD'NT CALL THIS PROCEDURE AFTER CALLING Header()
Sub SetPageDesc(value)
	If IsHeaderCalled = False Then
		SetSession "PageDesc", value 
	Else
		Response.Write "Error #1 occurd in $xmlblocks.asp (SetPageDesc)."
	End If
End Sub

' Sets the page keywords.
' NOTE: YOU SHOULD'NT CALL THIS PROCEDURE AFTER CALLING Header()
Sub SetPagekeywords(value)
	If IsHeaderCalled = False Then
		SetSession "Pagekeywords", value 
	Else
		Response.Write "Error #1 occurd in $xmlblocks.asp (SetPagekeywords)."
	End If
End Sub

' Gets layout folder path.
Function Block_Layout()
	Block_Layout = "/sites/" & Application(ScriptName & "SiteName") & "/layout"
End Function

Function ReplaceSpaces(value)
	ReplaceSpaces = Replace(value, " ", "-")
End Function
%>
