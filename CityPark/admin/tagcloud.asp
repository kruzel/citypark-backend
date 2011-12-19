﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
</head>
<body>
<%

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
  strUrlPrefix = "/?"
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
dim str,arr
str = "היה היה אז יום שני (השֵׁד אותי פיתה) יוסלה וגם אני ירדנו למטע.       הכול בגלל צינור אחד,      הכול בגלל צינור."
 arr = split(str," ")
response.write GenerateTagCloud(arr)
%>
</body>
</html>