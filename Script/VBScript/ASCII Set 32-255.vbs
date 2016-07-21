'*******************************************************************************
' Module      : ASCII Set 32-255
' Author      : Terence Lim
' Created     : 7/08/2008 2:09:46 PM
' Last Update : 8/08/2008 4:53:18 PM
' Purpose     :
'*******************************************************************************

Const module_name  = "ASCII Set 32-255"
Const module_ver   = "1.01"   

'// Procedure to Create an ASCII Char Set 32-255 String
'// Useful as a Sample Character Set for testing in Font Viewing Programs 
Sub ASCIISetGenerator

'// Create New ASCII Char Set 32-255 Text File		
		newEditor().newFile("ASCII Char Set 32-255")

		For i = 32 To 255
				sASCII = sASCII & Chr(i)
		Next

'// Uncomment to Set Clipboard text		
'		setClipBoardText(sASCII)
		
    handleSelText sASCII

'// Uncomment to Set Clipboard notification				
'		msgbox "A copy has been sent to the clipboard.", vbOkOnly + vbInformation, "ASCII 32-255 Set"

End Sub

'///////////////////////////////////////////////////////////////////////////////
'//                      Global Procedures and Functions                      //
'///////////////////////////////////////////////////////////////////////////////

'// IIf vbscript work around
Private Function IIf(psdStr, trueStr, falseStr)
  If psdStr Then
    IIf = trueStr
  Else 
    IIf = falseStr
  End If
End Function

'// @param string Text to replace selected text
Private Function handleSelText(text)
    On Error Resume Next
    Set editor = newEditor()
    editor.assignActiveEditor
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
		menuName = "&TLUPS" 
		addMenuItem "Generate &ASCII Char Set 32-255", menuName, "ASCIISetGenerator", "CTRL+SHIFT+ALT+F10"
End Sub
