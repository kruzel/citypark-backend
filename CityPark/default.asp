<!--#include file="$db.asp"-->
<!--#include file="rewrite.asp"-->

<%	Function Predirect(target)
		Response.Status="301 Moved Permanently"
		Response.AddHeader "Location", target
     End Function


If Request.QueryString <> "" AND Left(Request.QueryString,5) <> "gclid" OR Request.QueryString <> "" AND Left(Request.QueryString,4) <> "?utm"  Then
	'Response.redirect("/" & cstr(request.querystring) & ".asp" )
	
End If
 
 
 
	DDomain = LCase(Request.ServerVariables("HTTP_HOST"))	
    
	IsTLK1 = EndsWith(DDomain, ".com") Or EndsWith(DDomain, ".net") Or EndsWith(DDomain, ".org") Or EndsWith(DDomain, ".info") Or EndsWith(DDomain, ".jobs")
	IsTLK2 = EndsWith(DDomain, ".co.il") Or EndsWith(DDomain, ".co.uk") Or EndsWith(DDomain, ".ac.il")  Or EndsWith(DDomain, ".org.il") Or EndsWith(DDomain, ".muni.il") Or EndsWith(DDomain, ".net.il")
	IsSubdomain = (IsTLK1 And UBound(Split(DDomain, ".")) = 2) Or (IsTLK2 And UBound(Split(DDomain, ".")) = 3)
	'REMOVE THIS FALSE RAN BRANDES
	If false And LCase(Request.ServerVariables("HTTPS")) = "off" And Not IsSubdomain  Then		
		Response.Status="301 Moved Permanently"
		Response.AddHeader "Location", "http://www." & DDomain 
		
	End If		
        
		Function EndsWith(str, str2)
			EndsWith = LCase(Mid(str, Len(str) + 1 - Len(str2))) = LCase(str2)
		End Function
		
	Set objRs = OpenDB("SELECT SiteID, LangID, HomePageID, Domains FROM Site WHERE (NOT Domains = '')")    
    
	Do While Not objRs.EOF

		Domains = Split(objRs("Domains"), ",")
		
		For Each Domain In Domains
       'Response.Write(objRs("WebPageURL"))
              '  Response.End()
			If (LCase(Domain) = DDomain) Then
				'DQueryString = Split(Split(objRs("WebPageURL"), "?")(1), "&")				

				Session("SiteID") = objRs("SiteID")
				SiteID = objRs("SiteID")
				Session("SiteLang") = objRs("LangID") 

				

				
				'Server.Execute(Split(objRs("WebPageURL"), "?")(0))
				Session(SiteID & "HomeQSID") = objRs("HomePageID") 
				Server.Execute("sc.asp")
				Exit Do
			End If
		Next
		
		objRs.MoveNext
	Loop
	
	CloseDB(objRs)

%>

