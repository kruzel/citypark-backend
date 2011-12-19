<!--#include file="../config.asp"-->
<!--#include file="../inc_cart.asp"-->


<%	sTotal = 0
    sQty = 0
If Request.Cookies(SiteID & "cartID") ="" Then ' האם העגלה לא קיימת
	    print SysLang("thecartisempty")
	    
Else
	  	  SqlDetails="Select * From Cartdetails Where cartID=" & Request.Cookies(SiteID & "cartID")
	      Set objRsDetails = OpenDB(SqlDetails)
	      If objRsDetails.Recordcount = 0 Then 
	            print SysLang("thecartisempty")
	      Else
	        Do Until objRsDetails.EOF
	         If  objRsDetails("CartdetailsQty") > 0 Then
		            sTotal = sTotal + (objRsDetails("CartdetailsQty") * CSng(objRsDetails("CartdetailsPrice")))
		            sQty = sQty + objRsDetails("CartdetailsQty") 
            End if
                 objRsDetails.movenext
                    loop
		           

          End if
          Set objRsConfig=OpenDB("SELECT * FROM ShopConfig Where SiteID= " & SiteID)
          If sQty > 0 then
            print "<a href=""/cart.asp?mode=viewcart"">ישנם " & sQty & " מוצרים בסכום של " &  sTotal & " " & objRsConfig("CurrencySymbol")& "</a>"
          End if
            Closedb(objRsConfig)
End if
%>
