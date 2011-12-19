
<!--#include file="../config.asp"-->
<% 
   'Set objRs = OpenDB("SELECT tags FROM content WHERE  id=" &Getsession("contentiD"))
   if application(SiteID & "tags") = "" then
   If SiteID = 53 then
      SQL = "SELECT [Content].*, Contentfather.FatherID FROM [Content] INNER JOIN Contentfather ON [Content].Id = Contentfather.Contentid WHERE (Contentfather.FatherID = 3587) AND Content.SiteID=" & SiteID & " AND (Contenttype = 1)  AND (Showinsitemap = 1) ORDER By ItemOrder ASC"

        Set objRs = OpenDB(SQL)
   Else
        Set objRs = OpenDB("SELECT tags FROM content WHERE  siteid=" &siteid)
   End if

	If objRs.RecordCount = 0 Then
		Print(SysLang("No_Records_In_This_Category"))
	Else
		Dim str,arr
	    Do while Not objRs.EOF
			if objrs("tags") <> "" then str = str &","&objRs("tags")
			objRs.MoveNext
		Loop
		CloseDB(objrs)
		'response.write str
		arr = split(str,",")
		For i=0 to UBound(arr) 
			arr(i) = ltrim(arr(i))
			arr(i) = rtrim(arr(i))
		Next
		application(SiteID & "tags") = GenerateTagCloud(arr)
		'response.write GenerateTagCloud(arr)
	End If	


Function GenerateTagCloud(arrAllTags)
  Dim strReturn
  Dim strUrlPrefix
  Dim intLoop
  Dim objDictionary
  Dim strTag
  Dim colKeys
  Dim strKey
  Dim strStyleSize1
  Dim strStyleSize2
  Dim strStyleSize3
  Dim strStyleSize4
  Dim strStyleSize5
  Dim strStyleSize6
  Dim strStyleSize7
  Dim lngHighestTagCount
  Dim lngLowestTagCount
  Dim dblDiff
  Dim dblStep
  Dim dblOffset
  Dim dblBorder1
  Dim dblBorder2
  Dim dblBorder3
  Dim dblBorder4
  Dim dblBorder5
  Dim dblBorder6
  strUrlPrefix = "/search.asp?mode=search&searchstring="
  strStyleSize1 = "font-size: 9px;"
  strStyleSize2 = "font-size: 10px;"
  strStyleSize3 = "font-size: 12px;"
  strStyleSize4 = "font-size: 14px;"
  strStyleSize5 = "font-size: 14px; font-weight: bold;"
  strStyleSize6 = "font-size: 16px; font-weight: bold;"
  strStyleSize7 = "font-size: 18px; font-weight: bold;"
  Set objDictionary = Server.CreateObject("Scripting.Dictionary")
  For intLoop = 0 to Ubound(arrAllTags)
    strTag = arrAllTags(intLoop)
    If objDictionary.Exists(strTag) = True Then
      objDictionary.Item(strTag) = objDictionary.Item(strTag) + 1
    Else
      objDictionary.Add strTag, 1
    End If
  Next
  lngHighestTagCount = 1
  lngLowestTagCount = 2147483647
  colKeys = objDictionary.Keys
  For Each strKey in colKeys
    If objDictionary.Item(strKey) > lngHighestTagCount Then
      lngHighestTagCount = objDictionary.Item(strKey)
    End If
    If objDictionary.Item(strKey) < lngLowestTagCount Then
      lngLowestTagCount = objDictionary.Item(strKey)
    End If
  Next
  dblDiff = (lngHighestTagCount-lngLowestTagCount)
  dblStep = (dblDiff-(dblDiff/7))/5
  dblOffset = dblDiff/14
  dblBorder1 = lngLowestTagCount+(dblstep*0)+dblOffset
  dblBorder2 = lngLowestTagCount+(dblstep*1)+dblOffset
  dblBorder3 = lngLowestTagCount+(dblstep*2)+dblOffset
  dblBorder4 = lngHighestTagCount-(dblstep*2)-dblOffset
  dblBorder5 = lngHighestTagCount-(dblstep*1)-dblOffset
  dblBorder6 = lngHighestTagCount-(dblstep*0)-dblOffset
  For Each strKey in colKeys
    If objDictionary.Item(strKey) < dblBorder1 Then
      objDictionary.Item(strKey) = strStyleSize1
    ElseIf objDictionary.Item(strKey) > dblBorder1 And _
        objDictionary.Item(strKey) < dblBorder2 Then
      objDictionary.Item(strKey) = strStyleSize2
    ElseIf objDictionary.Item(strKey) > dblBorder2 And _
        objDictionary.Item(strKey) < dblBorder3 Then
      objDictionary.Item(strKey) = strStyleSize3
    ElseIf objDictionary.Item(strKey) > dblBorder3 And _
        objDictionary.Item(strKey) < dblBorder4 Then
      objDictionary.Item(strKey) = strStyleSize4
    ElseIf objDictionary.Item(strKey) > dblBorder4 And _
        objDictionary.Item(strKey) < dblBorder5 Then
      objDictionary.Item(strKey) = strStyleSize5
    ElseIf objDictionary.Item(strKey) > dblBorder5 And _
        objDictionary.Item(strKey) < dblBorder6 Then
      objDictionary.Item(strKey) = strStyleSize6
    ElseIf objDictionary.Item(strKey) > dblBorder6 Then
      objDictionary.Item(strKey) = strStyleSize7
    End If
  Next
  For Each strKey in colKeys
    strReturn = strReturn & "<a href=""" & strUrlPrefix & _
      strKey & """ style=""" & objDictionary.Item(strKey) & _
      """>" & strKey & "</a> " & vbcrlf
  Next
  Set objDictionary = Nothing
  GenerateTagCloud = strReturn
End Function
end if
response.write application(SiteID & "tags")
%>
