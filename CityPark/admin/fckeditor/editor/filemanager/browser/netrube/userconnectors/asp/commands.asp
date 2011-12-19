<!--
 * FCKeditor - The text editor for internet
 * Copyright (C) 2003-2006 Frederico Caldeira Knabben
 * 
 * Licensed under the terms of the GNU Lesser General Public License:
 * 		http://www.opensource.org/licenses/lgpl-license.php
 * 
 * For further information visit:
 * 		http://www.fckeditor.net/
 * 
 * "Support Open Source software. What about a donation today?"
 * 
 * File Name: commands.asp
 * 	This file include the functions that handle the Command requests
 * 	in the ASP Connector.
 * 
 * File Authors:
 * 		Frederico Caldeira Knabben (fredck@fckeditor.net)
 *		NetRube (netrube@gmail.com)
-->
<%
Sub GetFolders( resourceType, currentFolder )
	On Error Resume Next
	
	' Map the virtual path to the local server path.
	Dim sServerDir
	sServerDir					= ServerMapFolder( resourceType, currentFolder )

	' Open the "Folders" node.
	Response.Write "<Folders>"

	Dim oFSO, oFolders, oFolder
	Set oFSO					= Server.CreateObject( "Scripting.FileSystemObject" )
	Set oFolders				= oFSO.GetFolder( sServerDir ).SubFolders

	For Each oFolder in oFolders
		Response.Write "<Folder name=""" & ConvertToXmlAttribute( oFolder.name ) & """ />"
	Next
	
	Set oFolders				= Nothing
	Set oFSO					= Nothing
	
	' Close the "Folders" node.
	Response.Write "</Folders>"
	
	If Err.Number <> 0 Then
		SendError 1, "You have no permissions to use filemanager."
	End If
	
	Err.Clear
End Sub

Sub GetFoldersAndFiles( resourceType, currentFolder )
	On Error Resume Next
	
	' Map the virtual path to the local server path.
	Dim sServerDir
	sServerDir					= ServerMapFolder( resourceType, currentFolder )

	Dim oFSO, oCurrentFolder, oFolders, oFolder, oFiles, oFile
	Set oFSO					= Server.CreateObject( "Scripting.FileSystemObject" )
	Set oCurrentFolder			= oFSO.GetFolder( sServerDir )
	Set oFolders				= oCurrentFolder.SubFolders
	Set oFiles					= oCurrentFolder.Files
	
	' Open the "Folders" node.
	Response.Write "<Folders>"
	
	For Each oFolder In oFolders
		Response.Write "<Folder name=""" & ConvertToXmlAttribute( oFolder.Name ) & """ size=""" & oFolder.Size & """ />"
	Next
	
	Set oFolders				= Nothing
	
	' Close the "Folders" node.
	Response.Write "</Folders>"
		
	' Open the "Files" node.
	Response.Write "<Files>"
	
	For Each oFile In oFiles
		Response.Write "<File name=""" & ConvertToXmlAttribute( oFile.name ) & """ size=""" & oFile.Size & """ />"
	Next
	
	' Close the "Files" node.
	Response.Write "</Files>"
	
	If Err.Number <> 0 Then
		SendError 1, "You have no permissions to use filemanager."
	End If
	
	Err.Clear
End Sub

Sub CreateFolder( resourceType, currentFolder )
	Dim sErrorNumber

	Dim sNewFolderName
	sNewFolderName				= Request.QueryString( "NewFolderName" )

	If ( sNewFolderName = "" OR InStr( 1, sNewFolderName, ".." ) > 0  ) Then
		sErrorNumber			= "102"
	Else
		On Error Resume Next

		' Map the virtual path to the local server path of the current folder.
		Dim sServerDir
		sServerDir				= ServerMapFolder( resourceType, currentFolder & "/" & sNewFolderName )
		
		CreateServerFolder sServerDir
		
		Dim iErrNumber, sErrDescription
		iErrNumber				= Err.number
		sErrDescription			= Err.Description
		
		Err.Clear
		
		Select Case iErrNumber
			Case 0
				sErrorNumber = "0"
			Case 52
				sErrorNumber = "102"	' Invalid Folder Name.
			Case 70
				sErrorNumber = "103"	' Security Error.
			Case 76
				sErrorNumber = "102"	' Path too long.
			Case Else
				sErrorNumber = "110"
		End Select
	End If

	' Create the "Error" node.
	Response.Write "<Error number=""" & sErrorNumber & """ originalNumber=""" & iErrNumber & """ originalDescription=""" & ConvertToXmlAttribute( sErrDescription ) & """ />"
End Sub

Sub DeleteFolder( resourceType, currentFolder )
	Dim sErrorNumber, iErrNumber, sErrDescription

	Dim sFolderName
	sFolderName					= Request.QueryString( "FolderName" )

	If ( sFolderName = "" ) Then
		sErrorNumber			= "202"
	Else
		On Error Resume Next
		
		' Map the virtual path to the local server path of the current folder.
		Dim sServerDir
		sServerDir				= ServerMapFolder( resourceType, currentFolder & "/" & sFolderName )

		Dim oFSO
		Set oFSO				= Server.CreateObject("Scripting.FileSystemObject")
		oFSO.DeleteFolder sServerDir
		Set oFSO				= Nothing
		
		iErrNumber				= Err.Number
		sErrDescription			= Err.Description
		
		Err.Clear
		
		Select Case iErrNumber
			Case 0
				sErrorNumber	= "0"
			Case 52
				sErrorNumber	= "203"	' Folder not exists.
			Case 70
				sErrorNumber	= "201"	' Security Error.
			Case 76
				sErrorNumber	= "202"	' Invalid Folder Name.
			Case Else
				sErrorNumber	= "210"
		End Select
	End If

	' Create the "Error" node.
	Response.Write "<Error number=""" & sErrorNumber & """ originalNumber=""" & iErrNumber & """ originalDescription=""" & ConvertToXmlAttribute( sErrDescription ) & """ />"
End Sub

Sub DeleteFile( resourceType, currentFolder )
	Dim sErrorNumber

	Dim sFileName
	sFileName					= Request.QueryString( "FileName" )

	If ( sFileName = "" ) Then
		sErrorNumber			= "302"
	Else
		On Error Resume Next
		
		' Map the virtual path to the local server path of the current file.
		Dim sServerDir
		sServerDir				= ServerMapFolder( resourceType, currentFolder & "/" & sFileName )

		Dim oFSO
		Set oFSO				= Server.CreateObject("Scripting.FileSystemObject")
		oFSO.DeleteFile sServerDir
		Set oFSO				= Nothing
		
		Dim iErrNumber, sErrDescription
		iErrNumber				= Err.Number
		sErrDescription			= Err.Description
		
		Err.Clear
		
		Select Case iErrNumber
			Case 0
				sErrorNumber	= "0"
			Case 52, 76
				sErrorNumber	= "302"	' Invalid File Name.
			Case 53
				sErrorNumber	= "303"	' File not exists.
			Case 70
				sErrorNumber	= "301"	' Security Error.
			Case Else
				sErrorNumber	= "310"
		End Select
	End If

	' Create the "Error" node.
	Response.Write "<Error number=""" & sErrorNumber & """ originalNumber=""" & iErrNumber & """ originalDescription=""" & ConvertToXmlAttribute( sErrDescription ) & """ />"
End Sub

Sub RenameFolder( resourceType, currentFolder )
	Dim sErrorNumber

	Dim sFolderName, sNewName
	sFolderName					= Request.QueryString( "FolderName" )
	sNewName					= Request.QueryString( "NewName" )

	If ( sFolderName = "" Or sNewName = "" ) Then
		sErrorNumber			= "402"
	Else
		On Error Resume Next
		
		' Map the virtual path to the local server path of the current file.
		Dim sServerDir, sNewDir
		sServerDir				= ServerMapFolder( resourceType, currentFolder & "/" & sFolderName )
		sNewDir					= ServerMapFolder( resourceType, currentFolder & "/" & sNewName )

		Dim oFSO
		Set oFSO				= Server.CreateObject("Scripting.FileSystemObject")
		oFSO.MoveFolder sServerDir, sNewDir
		Set oFSO				= Nothing
		
		Dim iErrNumber, sErrDescription
		iErrNumber				= Err.Number
		sErrDescription			= Err.Description
		
		Err.Clear
		
		Select Case iErrNumber
			Case 0
				sErrorNumber	= "0"
			Case 52
				sErrorNumber	= "403"	' Folder not exists.
			Case 70
				sErrorNumber	= "401"	' Security Error.
			Case 76
				sErrorNumber	= "402"	' Invalid Folder Name.
			Case Else
				sErrorNumber	= "410"
		End Select
	End If

	' Create the "Error" node.
	Response.Write "<Error number=""" & sErrorNumber & """ originalNumber=""" & iErrNumber & """ originalDescription=""" & ConvertToXmlAttribute( sErrDescription ) & """ />"
End Sub

Sub RenameFile( resourceType, currentFolder )
	Dim sErrorNumber

	Dim sFileName, sNewName
	sFileName					= Request.QueryString( "FileName" )
	sNewName					= Request.QueryString( "NewName" )

	If ( sFileName = "" Or sNewName = "" ) Then
		sErrorNumber			= "502"
	Else
		On Error Resume Next
		
		' Map the virtual path to the local server path of the current file.
		Dim sServerDir, sNewDir
		sServerDir				= ServerMapFolder( resourceType, currentFolder & "/" & sFileName )
		sNewDir					= ServerMapFolder( resourceType, currentFolder & "/" & sNewName )

		Dim oFSO
		Set oFSO				= Server.CreateObject("Scripting.FileSystemObject")
		oFSO.MoveFile sServerDir, sNewDir
		Set oFSO				= Nothing
		
		Dim iErrNumber, sErrDescription
		iErrNumber				= Err.Number
		sErrDescription			= Err.Description
		
		Err.Clear
		
		Select Case iErrNumber
			Case 0
				sErrorNumber	= "0"
			Case 52, 76
				sErrorNumber	= "502"	' Invalid File Name.
			Case 53
				sErrorNumber	= "503"	' File not exists.
			Case 70
				sErrorNumber	= "501"	' Security Error.
			Case Else
				sErrorNumber	= "510"
		End Select
	End If

	' Create the "Error" node.
	Response.Write "<Error number=""" & sErrorNumber & """ originalNumber=""" & iErrNumber & """ originalDescription=""" & ConvertToXmlAttribute( sErrDescription ) & """ />"
End Sub

Sub FileUpload( resourceType, currentFolder )
	Dim oUploader
	Set oUploader				= New NetRube_Upload
	oUploader.MaxSize			= 0
	oUploader.Allowed			= ConfigAllowedExtensions.Item( resourceType )
	oUploader.Denied			= ConfigDeniedExtensions.Item( resourceType )
	oUploader.GetData

	Dim sErrorNumber
	sErrorNumber				= "0"
	
	Dim sFileName, sOriginalFileName, sExtension
	sFileName = ""

	If oUploader.ErrNum > 1 Then
		sErrorNumber			= "202"
	Else
		' Map the virtual path to the local server path.
		Dim sServerDir
		sServerDir				= ServerMapFolder( resourceType, currentFolder )

		Dim oFSO
		Set oFSO				= Server.CreateObject( "Scripting.FileSystemObject" )
	
		' Get the uploaded file name.
		sFileName				= oUploader.File( "NewFile" ).Name
		sExtension				= oUploader.File( "NewFile" ).Ext
		sOriginalFileName		= sFileName

		Dim iCounter
		iCounter				= 0

		Do While ( True )
			Dim sFilePath
			sFilePath			= sServerDir & sFileName

			If ( oFSO.FileExists( sFilePath ) ) Then
				iCounter		= iCounter + 1
				sFileName		= RemoveExtension( sOriginalFileName ) & "(" & iCounter & ")." & sExtension
				sErrorNumber	= "201"
			Else
				oUploader.SaveAs "NewFile", sFilePath
				If oUploader.ErrNum > 0 Then sErrorNumber = "202"
				Exit Do
			End If
		Loop
	End If

	Set oUploader				= Nothing

	Response.Clear

	Response.Write "<script type=""text/javascript"">"
	Response.Write "window.parent.frames['frmUpload'].OnUploadCompleted(" & sErrorNumber & ",'" & Replace( sFileName, "'", "\'" ) & "') ;"
	Response.Write "</script>"

	Response.End
End Sub
%>