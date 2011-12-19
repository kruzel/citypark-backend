<%
Option Explicit
Response.Buffer				= True
%>
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
 * File Name: connector.asp
 * 	This is the File Manager Connector for ASP.
 * 
 * File Authors:
 * 		Frederico Caldeira Knabben (fredck@fckeditor.net)
 *		NetRube (netrube@gmail.com)
-->
<!--#include file="config.asp"-->
<!--#include file="util.asp"-->
<!--#include file="io.asp"-->
<!--#include file="basexml.asp"-->
<!--#include file="commands.asp"-->
<!--#include file="class_upload.asp"-->
<%
' Check permissions.
If Not IsPermission Then
	SendError 1, "You have no permissions to use filemanager."
End If

' Get the "UserFiles" path.
Dim sUserFilesPath

If ( Not IsEmpty( ConfigUserFilesPath ) ) Then
	sUserFilesPath				= ConfigUserFilesPath

	If ( Right( sUserFilesPath, 1 ) <> "/" ) Then
		sUserFilesPath			= sUserFilesPath & "/"
	End If
Else
	sUserFilesPath				= "/Content/"
End If

' Map the "UserFiles" path to a local directory.
Dim sUserFilesDirectory
sUserFilesDirectory = Server.MapPath( sUserFilesPath )

If ( Right( sUserFilesDirectory, 1 ) <> "\" ) Then
	sUserFilesDirectory = sUserFilesDirectory & "\"
End If

DoResponse

ConfigAllowedExtensions.RemoveAll
ConfigDeniedExtensions.RemoveAll
Set ConfigAllowedExtensions		= Nothing
Set ConfigDeniedExtensions		= Nothing

Sub DoResponse()
	Dim sCommand, sResourceType, sCurrentFolder
	
	' Get the main request information.
	sCommand = Request.QueryString("Command")
	If ( sCommand = "" ) Then Exit Sub

	sResourceType = Request.QueryString("Type")
	If ( sResourceType = "" ) Then Exit Sub
	
	sCurrentFolder = Request.QueryString("CurrentFolder")
	If ( sCurrentFolder = "" ) Then Exit Sub

	' Check if it is an allower resource type.
	if ( Not IsAllowedType( sResourceType ) ) Then Exit Sub

	' Check the current folder syntax (must begin and start with a slash).
	If ( Right( sCurrentFolder, 1 ) <> "/" ) Then sCurrentFolder = sCurrentFolder & "/"
	If ( Left( sCurrentFolder, 1 ) <> "/" ) Then sCurrentFolder = "/" & sCurrentFolder

	' Check for invalid folder paths (..)
	If ( InStr( 1, sCurrentFolder, ".." ) <> 0 OR InStr( 1, sResourceType, ".." ) <> 0 ) Then
		SendError 102, ""
	End If 

	' File Upload doesn't have to Return XML, so it must be intercepted before anything.
	If ( sCommand = "FileUpload" ) Then
		FileUpload sResourceType, sCurrentFolder
		Exit Sub
	End If

	SetXmlHeaders
	
	CreateXmlHeader sCommand, sResourceType, sCurrentFolder

	' Execute the required command.
	Select Case sCommand
		Case "GetFolders"
			GetFolders sResourceType, sCurrentFolder
		Case "GetFoldersAndFiles"
			GetFoldersAndFiles sResourceType, sCurrentFolder
		Case "CreateFolder"
			CreateFolder sResourceType, sCurrentFolder
		Case "DeleteFolder"
			DeleteFolder sResourceType, sCurrentFolder
		Case "DeleteFile"
			DeleteFile sResourceType, sCurrentFolder
		Case "RenameFolder"
			RenameFolder sResourceType, sCurrentFolder
		Case "RenameFile"
			RenameFile sResourceType, sCurrentFolder
	End Select

	CreateXmlFooter
End Sub

Function IsAllowedType( resourceType )
	Dim oRE
	Set oRE	= New RegExp
	oRE.IgnoreCase	= True
	oRE.Global		= True
	oRE.Pattern		= "^(File|Images|Flash|Media)$"

	IsAllowedType = oRE.Test( resourceType )
	
	Set oRE	= Nothing
End Function
%>