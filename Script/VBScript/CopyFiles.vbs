'*******************************************************************************
' Module      : Copy Files
' Author      : tlim
' Published   : 7/08/2008 2:09:46 PM
' Update      : 8/08/2008 11:49:50 AM
' Purpose     :
' Usage				: In a new editor window, for each file, list the file source 
'							: file destination and overwrite choice.
'							: False - DO NOT Overwrite, True - Overwrite   
'							: Delimited with "|"
'							: Source Full Path & Name | Destination Full Path (Name is 
'							: optional) | Overwrite
'		  Example	: 
'	     Line 1	: c:\some file 1.txt|c:\some folder\|false
'	   Result 1 : "c:\some file 1.txt" will be copied to "c:\some folder\" with
'							: its original name "some file 1.txt" 
'							: if there is a file present with the same name it won't be copied
'	     Line 2	: c:\some file 2.txt|c:\some other folder\copied file 2.txt|false	 
'	   Result 2 : "c:\some file 2.txt" will be copied to 
'							: "c:\some other folder\" with a new name of "copied file 2.txt"
'							: if there is a file present with the same name it won't be copied
'*******************************************************************************

Const module_name  = "Copy Files"
Const module_ver   = "1.00"   

Sub CopyFiles
Dim fso, bOverWrite
Dim sArrRow, i
dim sArrString, j
Dim sFileSource, sFileDestination, sFileOverwrite
    '// Clear Log
		logClear()
    
    '// Get working text
    text = handleSelText("")

		sArrRow = split(text, vbCRLF)
  	logAddLine("------ File Copy Start ------")
    logAddLine("Date and Time: " & Now())
		logAddLine("Line Count: " & ubound(sArrRow)+1)
		
		Set fso = CreateObject("Scripting.FileSystemObject")

On Error Resume Next	
    For i = lbound(sArrRow) to ubound(sArrRow)
				sArrString = split(sArrRow(i), "|")
				
				If ubound(sArrString) <= 0 Then 
						Exit Sub	
						Set fso = Nothing
					Else 
						sFileSource = sArrString(0)
						sFileDestination = sArrString(1)
						
						If Right(Trim(sFileDestination),1) <> "\" and Left(Right(Trim(sFileDestination),4),1) <> "." Then
							 sFileDestination = Trim(sFileDestination) & "\"
						End If
						
						sFileOverwrite = sArrString(2)		 														
						logAddLine("Copying File: " & sFileSource)
						fso.CopyFile sFileSource, sFileDestination, sFileOverwrite
				
						If Err.Number = 58  then   
							 sFileDestination = "File Already Exists - File Not Copied"
							 Err.Clear      ' Clear the error.
							 							 
						End If
						logAddLine("          To: " & sFileDestination)											
				End If					
    Next
    				
	  Set fso = Nothing   

		logAddLine("------ File Copy Complete ------")
		
End Sub

'///////////////////////////////////////////////////////////////////////////////
'//                      Global Procedures and Functions                      //
'///////////////////////////////////////////////////////////////////////////////

'// @param string Text to replace selected text
Private Function handleSelText(text)
dim BBX, BBY, BEX, BEY
    On Error Resume Next
    Set editor = newEditor()
    editor.assignActiveEditor

		editor.command "ecSelectAll"
		runPSPadAction "aRemoveBlankLines"	
    
    If text = "" Then
        '// Get selected text                
        handleSelText = editor.selText
        If handleSelText = "" Then
            '// No text was select. Get all text and select it.
            handleSelText  = editor.Text
            editor.command "ecSelectAll"
        End If
    Else
        '// Set selected text
        editor.selText text
    End If
End Function

Sub Init
		menuName = "&" & module_name
    addMenuItem "Copy Files", "", "CopyFiles", ""
End Sub
