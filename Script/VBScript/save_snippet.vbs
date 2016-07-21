'*******************************************************************************
'	FILENAME		: save_snippet.vbs
'	DESCRIPTION		: Saves either the active document contents, or the selection
'					  if one has been made, as a text file in a directory
' 					  named "Snippets" directly under PsPad's root directory.

'	CREATED			: 22 September 2005
'	CREATED BY		: James Swan

'	NOTE			: This script has only been tested on Windows 2000 and XP

'	You may distribute this script freely, but please keep this header intact.
'*******************************************************************************
Option Explicit

Const MODULE_NAME  = "SaveSnippet"
Const MODULE_VER   = "0.1"
Const MODULE_TITLE = "Save Snippet"

Sub Init
    addMenuItem MODULE_TITLE, "Utilities", MODULE_NAME
End Sub

Sub SaveSnippet()
	Dim objEditor, objSaveEditor, objFSO
	Dim strSnippet, strSnippetPath, strFolderPath, strSnippetName

	Set objEditor = newEditor()

	With objEditor
		.assignActiveEditor()
		strSnippet = .selText()
		If Len(strSnippet) = 0 Then
			strSnippet = .text()
		End If
		strSnippetPath = AppPath() & "Snippets"
	End With

	Set objFSO = CreateObject("Scripting.FileSystemObject")

	If NOT objFSO.FolderExists(strSnippetPath) Then
		On error Resume next
			objFSO.CreateFolder(strSnippetPath)
		On error GoTo 0
		sleep(500)
	End if

	If objFSO.FolderExists(strSnippetPath) Then
		strFolderPath = BrowseForFolder("In which folder to you wish to save the snippet?", strSnippetPath)
		Set objFSO = Nothing
	Else
		MsgBox "Aborting..." & vbCrLf & vbCrLf & "Could not locate or create folder:" & strSnippetPath, 16, MODULE_TITLE
		Set objFSO = Nothing
		Exit Sub
	End if

	If NOT IsNull(strFolderPath) Then
		strSnippetName = Trim(InputBox("Enter a name for the snippet:", MODULE_TITLE, ""))

		If Len(strSnippetName) Then
			Set objSaveEditor = newEditor()
			With objSaveEditor
				.newFile()
				.text(strSnippet)
				.saveFileAs(strFolderPath & "\" & strSnippetName & ".txt")
				.closeFile()
			End With
		Else
			MsgBox "Aborting..." & vbCrLf & vbCrLf & "No name entered for the snippet.", 16, MODULE_TITLE
		End If
	Else
		MsgBox "Aborting..." & vbCrLf & vbCrLf & "No destination folder chosen for the snippet.", 16, MODULE_TITLE
	End If

End Sub

Function BrowseForFolder(strPrompt, strRootPath)
	On Error Resume Next
	Const BIF_NEWDIALOGSTYLE = &H40 		' Use the new user interface. Setting this flag provides the user with a larger dialog box that can be resized. The dialog box has several new capabilities including: drag-and-drop capability within the dialog box, reordering, shortcut menus, new folders, delete, and other shortcut menu commands. To use this flag, you must call OleInitialize or CoInitialize before calling SHBrowseForFolder.
	Dim objShell, objFolder, intColonPos, objWshShell
	Set objShell = CreateObject("Shell.Application")

	Set objFolder = objShell.BrowseForFolder(&H0, strPrompt, BIF_NEWDIALOGSTYLE, strRootPath)

	If Err.Number > 0 Then
		MsgBox ("Error # " & CStr(Err.Number) & " " & Err.Description)
	End If

	If objFolder is Nothing Then
		' User clicked Cancel
		BrowseForFolder = Null
	Else
		BrowseForFolder = objFolder.ParentFolder.ParseName(objFolder.Title).Path

		If Err.Number > 0 Then
			BrowseForFolder = Null
		End If
	End If
End Function

Function AppPath()
	Dim strPath
	strPath = modulePath()
	If Len(strPath) = 0 Then Exit Function
	AppPath = Left(strPath, InStrRev(strPath, "\Script\VBScript\"))
End Function
