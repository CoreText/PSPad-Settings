'*******************************************************************************
'	FILENAME		: multiple_search_and_replace.vbs
'	DESCRIPTION		: This script searchs & replaces a list of strings into
'					  the selected text. The list of strings to be replaced
'					  is stored into an external text file.

'	CREATED			: 18 March 2011
'	CREATED BY		: Andrea Cattaneo

'	NOTE			: Tested on Windows XP
'					  I take some part of code from the script save_snippet.vbs of
'					  James Swan, so thanks :)

'	You may distribute this script freely, but please keep this header intact.
'*******************************************************************************
Option Explicit

Const MODULE_NAME  = "MultipleSearchAndReplace"
Const MODULE_VER   = "0.1"
Const MODULE_TITLE = "Multiple search and replace"

Sub Init
    addMenuItem MODULE_TITLE, "Utilities", MODULE_NAME
End Sub

Sub MultipleSearchAndReplace()
	Dim objEditor, objSaveEditor, objFSO
	Dim strTestoEditor, strSostituzioni, strFilePath

	Set objEditor = newEditor()
	
	With objEditor
		.assignActiveEditor()
		
		'scrivo nella stringa "strTestoEditor" il testo dell'editor'
		strTestoEditor = .selText()
		If Len(strTestoEditor) = 0 Then
			strTestoEditor = .text()
		End If
	  
		'apro il file dove sono definite le stringhe da sostituire'
		Dim objEditor2
    strFilePath =BrowseForFile("Select the search and replace definitions file", strFilePath)
	  	If (NOT IsNull(strFilePath)) AND Len(strFilePath) Then
			Set objEditor2 = newEditor()
			With objEditor2
				.openFile(strFilePath)
				
				'Strivo le stringhe di sostituzione nella stringa "strSostituzioni" '
				strSostituzioni = .text()
				.closeFile()
			End With
		Else
			MsgBox "Aborting..." & vbCrLf & vbCrLf & "No files selected", 16, MODULE_TITLE
		End If
	  
		'suddivido le stringhe da sostituire in un array di righe'
		Dim righeSostituzioni
		righeSostituzioni = split(strSostituzioni,VbCrLf)
    'Le righe pari contengono la stringa da sostituire, le righe dispari la nuova stringa
    'Es. Riga 0 = a, Riga 1 = b --> a verrà sostituito da b"
    dim length, index
    length = UBound(righeSostituzioni)
    dim testo_conferma
    for index = 0 to length step 2
      testo_conferma = testo_conferma & "Replacing: " & righeSostituzioni(index) & " with: " &righeSostituzioni(index+1) & vbCrLf
    next
    Dim Conferma
    Conferma = InputBox(testo_conferma & vbCrLf & "Write 'YES' to confirm")
    If Conferma = "YES" then
      for index = 0 to length step 2
        strTestoEditor = replace(strTestoEditor,righeSostituzioni(index), righeSostituzioni(index+1))
      next
    .text(strTestoEditor)
    end if
    
	End With
End Sub

Function BrowseForFile(strPrompt, strRootPath)
	On Error Resume Next
	Dim objDialog 
    Set objDialog = CreateObject("UserAccounts.CommonDialog")
    
	' Only Windows XP can create this object, otherwise call BrowseForFolder
	If Err.Number > 0 Then
		MsgBox("Funzione 'browse' compatibile solo con Windows XP")
		BrowseForFile = InputBox("Inserisci il percorso del file di definizione delle stringhe da sostituire")
		Exit Function
	End If
  
	objDialog.Filter = "*.txt|All Files|*.*"
    objDialog.FilterIndex = 1
    objDialog.InitialDir = strRootPath
    objDialog.ShowOpen

	BrowseForFile = objDialog.FileName   
	If Err.Number > 0 Then
		MsgBox ("Error # " & CStr(Err.Number) & " " & Err.Description)
		BrowseForFile = Null
	End If
End Function