<%
'const xencryptkey="aueuksnrhr"              ' put here for more security
'**************************************************************************
' Jan 2, 2003
' modified to return plain looking text 
' VP-ASP 6.50
'*************************************************************************
const XConvertPlainText="Yes"
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   ':::                                                             :::
   ':::  This script performs 'RC4' Stream Encryption               :::
   ':::  (Based on what is widely thought to be RSA's RC4           :::
   ':::  algorithm. It produces output streams that are identical   :::
   ':::  to the commercial products)                                :::
   ':::                                                             :::
   ':::  This script is Copyright © 1999 by Mike Shaffer            :::
   ':::  ALL RIGHTS RESERVED WORLDWIDE 
   ':::  Used with permission of the Author
   ':::  mshaffer@nkn.net at www.noumenonlabs.com
   ':::                                                             :::
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   Dim sbox(255)
   Dim keyx(255)
  
   Sub EnDeCryptInit(strPwd)
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   ':::  This routine called by EnDeCrypt function. Initializes the :::
   ':::  sbox and the key array)                                    :::
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

      dim tempSwap
      dim a
      dim b, intLength

      intLength = len(strPwd)
      For a = 0 To 255
         keyx(a) = asc(mid(strpwd, (a mod intLength)+1, 1))
         sbox(a) = a
      next

      b = 0
      For a = 0 To 255
         b = (b + sbox(a) + keyx(a)) Mod 256
         tempSwap = sbox(a)
         sbox(a) = sbox(b)
         sbox(b) = tempSwap
      Next
   
   End Sub
   
   Function EnDeCrypt(plaintxt, psw)
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   ':::  This routine does all the work. Call it both to ENcrypt    :::
   ':::  and to DEcrypt your data.                                  :::
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
      dim pos, dotchar, plainflag
      plainflag=false
      If len(plaintxt)>20 then
           pos=Instr(plaintxt,".")
           If pos>0 then
               plaintxt=Convertfromplain(plaintxt)
               plainflag=true        
           end if
      end if         
      dim temp
      dim a
      dim i
      dim j
      dim k
      dim cipherby
      dim cipher

      i = 0
      j = 0
      EnDecryptInit psw

      For a = 1 To Len(plaintxt)
         i = (i + 1) Mod 256
         j = (j + sbox(i)) Mod 256
         temp = sbox(i)
         sbox(i) = sbox(j)
         sbox(j) = temp
   
         k = sbox((sbox(i) + sbox(j)) Mod 256)

         cipherby = Asc(Mid(plaintxt, a, 1)) Xor k
         cipher = cipher & Chr(cipherby)
      Next
      EnDeCrypt = cipher
End Function

Function PrintHex (idata)
dim fieldvalue, i, txt
txt=idata
for x = 1 to len(txt)
      Fieldvalue=Fieldvalue & right(string(2,"0") & hex(asc(mid(idata, x, 1))),2) 
'      debugwrite "fieldvalue=" & fieldvalue
'      if x mod 26 = 0 then response.write vbCRLF
next
Printhex=fieldvalue
end function

Function PrintBrowser (idata)
   PrintBrowser=server.urlencode(idata)
end function   

Function GetEncryptKey
If xencryptkey="" then
  GetEncryptKey=getconfig("xencryptkey")
else
    GetEncryptKey=xencryptkey
end if    
end Function

'Base 64 Encoding
'Horizyn
'April 2002
'This algorithm is used for converting binary data into ASCII format so it is able to be
'transmitted and viewed in a simple manner. 
' The algorithm may then decode the data back
'into its binary form.  In this way encrypted data may be easily stored in databases/text files/XML
'etc.

'Usage: Include the shop_base64 file into your ASP file, call the initCodecs function before
'       calling any encode/decode functions, then 

     const BASE_64_MAP_INIT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
     ' zero based arrays
     dim Base64EncMap(63)
     dim Base64DecMap(127)

     ' must be called before using anything else
     Public Sub initCodecs()
          ' init vars
          ' setup base 64
          dim max, idx
             max = len(BASE_64_MAP_INIT)
          for idx = 0 to max - 1
               ' one based string
               Base64EncMap(idx) = mid(BASE_64_MAP_INIT, idx + 1, 1)
          next
          for idx = 0 to max - 1
               Base64DecMap(ASC(Base64EncMap(idx))) = idx
          next
     End Sub

     ' encode base 64 encoded string
     Function base64Encode(plain)

          if len(plain) = 0 then
               base64Encode = ""
               exit function
          end if

          dim ret, ndx, by3, first, second, third
          by3 = (len(plain) \ 3) * 3
          ndx = 1
          do while ndx <= by3
               first  = asc(mid(plain, ndx+0, 1))
               second = asc(mid(plain, ndx+1, 1))
               third  = asc(mid(plain, ndx+2, 1))
               ret = ret & Base64EncMap(  (first \ 4) AND 63 )
               ret = ret & Base64EncMap( ((first * 16) AND 48) + ((second \ 16) AND 15 ) )
               ret = ret & Base64EncMap( ((second * 4) AND 60) + ((third \ 64) AND 3 ) )
               ret = ret & Base64EncMap( third AND 63)
               ndx = ndx + 3
          loop
          ' check for stragglers
          if by3 < len(plain) then
               first  = asc(mid(plain, ndx+0, 1))
               ret = ret & Base64EncMap(  (first \ 4) AND 63 )
               if (len(plain) MOD 3 ) = 2 then
                    second = asc(mid(plain, ndx+1, 1))
                    ret = ret & Base64EncMap( ((first * 16) AND 48) + ((second \ 16) AND 15 ) )
                    ret = ret & Base64EncMap( ((second * 4) AND 60) )
               else
                    ret = ret & Base64EncMap( (first * 16) AND 48)
                    ret = ret & "="
               end if
               ret = ret & "="
          end if

          base64Encode = ret
     End Function

     ' decode base 64 encoded string
     Function base64Decode(scrambled)

          if len(scrambled) = 0 then
               base64Decode = ""
               exit function
          end if

          ' ignore padding
          dim realLen
          realLen = len(scrambled)
          do while mid(scrambled, realLen, 1) = "="
               realLen = realLen - 1
          loop
          dim ret, ndx, by4, first, second, third, fourth
          ret = ""
          by4 = (realLen \ 4) * 4
          ndx = 1
          do while ndx <= by4
               first  = Base64DecMap(asc(mid(scrambled, ndx+0, 1)))
               second = Base64DecMap(asc(mid(scrambled, ndx+1, 1)))
               third  = Base64DecMap(asc(mid(scrambled, ndx+2, 1)))
               fourth = Base64DecMap(asc(mid(scrambled, ndx+3, 1)))
               ret = ret & chr( ((first * 4) AND 255) +   ((second \ 16) AND 3))
               ret = ret & chr( ((second * 16) AND 255) + ((third \ 4) AND 15) )
               ret = ret & chr( ((third * 64) AND 255) +  (fourth AND 63) )
               ndx = ndx + 4
          loop
          ' check for stragglers, will be 2 or 3 characters
          if ndx < realLen then
               first  = Base64DecMap(asc(mid(scrambled, ndx+0, 1)))
               second = Base64DecMap(asc(mid(scrambled, ndx+1, 1)))
               ret = ret & chr( ((first * 4) AND 255) +   ((second \ 16) AND 3))
               if realLen MOD 4 = 3 then
                    third = Base64DecMap(asc(mid(scrambled,ndx+2,1)))
                    ret = ret & chr( ((second * 16) AND 255) + ((third \ 4) AND 15) )
               end if
          end if

          base64Decode = ret
     End Function
     
'***********************************************************************
' Convert to plain text
'***********************************************************************    
Function Converttoplain(Message)
'If xconvertplaintext<>"Yes" then
   Converttoplain=Message
   exit function
'end if
   
dim temp, char, i, num
		Temp=""
		For i = 1 to Len(Message)
			Char = Mid(Message,i,1)
			Num = Asc(Char)
			If i <> 1 Then
				Temp = Temp & "." & Num
			Else
				Temp = Temp & Num
			End If
		Next
		Converttoplain=Temp
End Function
Function Convertfromplain(Message)
If xconvertplaintext<>"Yes" then
   Convertfromplain=Message
   exit function
end if

	Dim Nums
	Dim i
	Dim Temp
	Temp=""

	Nums = Split(Message,".",-1,1)
	For i = 0 to uBound(Nums)
		Temp = Temp & chr(Nums(i))
	Next
	Convertfromplain = temp
End Function
 
%>

