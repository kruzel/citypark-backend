<!--#include file="../config.asp"-->

<%
Header

    ModeName = Request.QueryString("m")
    TableName = LCase(Request.QueryString("t"))
    CustomForm = Int(Request.QueryString("f"))
    
    If Not CustomForm = 0 Then
        'TableName = 
    End If  
    
    Set objRs = OpenDB("Select * From [" & TableName & "] Where [" & TableName & "].SiteID = " & SiteID)
    
    If Mode = "add" Then
    
    Else
    %>
            <table style="width: 98%">
                <tr>
                    <th>שם (<a href="table.asp?<% = Request.QueryString %>">הוסף</a>)</th>
                    <th>עריכה</th>
                    <th>מחיקה</th>
                </tr>
                
                <% Do Until objRs.Eof %>
                
                <tr>
                    <td><% = objRs(1) %></td>
                    <td></td>
                    <td></td>
                </tr>
                
                <% 
                    objRs.MoveNext
                Loop
                %>
            </table>
        <%
    End If
    
Bottom
%>