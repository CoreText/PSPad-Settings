' ------------------------------------------------------------------------------
' file:     GoGoModule.vbs
' date:     02/12/2006 - 03/03/2006
' author:   Scott Greenberg <me@gogogadgetscott.com>
' link:     http://gogogadgetscott.info/computers/cc/
'
' Copyright (c) 2006. SEG Technology. All rights reserved.
'
' This program is free software; you can redistribute it and/or
' modify it under the terms of the GNU General Public License
' as published by the Free Software Foundation; either version 2
' of the License, or (at your option) any later version.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU General Public License
' along with this program; if not, write to the Free Software
' Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
' ------------------------------------------------------------------------------
Const module_name  = "GoGo"
Const module_ver   = "1.03"

' ------------------------------------------------------------------------------
'                           Editor functions.
' ------------------------------------------------------------------------------

'// Get select text of active editor.
'//
'// @param string Text to replace selected text
'// @return string
'// @access public
Function handleSelText(text)
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

'// Get position of string within active editor.
'//
'// @param string  Search patten as plain text. RegEx is not supported on this one
'// @param integer Start caret y position or false if current caret y
'//                position should be used.
'// @param integer Start caret x position or false if current caret x
'//                position should be used.
'// @param bool    Whether to search forward or backward.
'// @return array/false On match array(x: integer, y: integer)
Function getStrPos(Pattern, startCaretY, startCaretX, searchForward)
    Set editor = newEditor()
    editor.assignActiveEditor
    
    '// Get all text
    allText  = editor.Text
    lines = Split(allText, Chr(13))

    '// Set default return value
    getStrPos = FALSE

    '// Set caret positions
    If startCaretY = FALSE Then
        startCaretY = editor.caretY
    End If
    If startCaretX = FALSE Then
        startCaretX = editor.caretX
    End If
    If searchForward = TRUE Then
        endCaretY = UBound(lines)
        iStep = 1
    Else
        endCaretY = 1
        iStep = -1
    End If

    If startCaretY = endCaretY Then
        '// Nothing to search
        Exit Function
    End If

    For currCaretY = startCaretY To endCaretY Step iStep
        Line = Replace(lines(currCaretY - 1), Chr(10), "")
        If searchForward = TRUE Then
            currCaretX = InStr(startCaretX, Line, Pattern, 1)
            If currCaretY = startCaretY Then
                startCaretX = 1
            End If
        Else
            currCaretX = InStrRev(Line, Pattern, startCaretX, 1)
            If currCaretY = startCaretY Then
                startCaretX = -1
            End If
        End If
        If currCaretX > 0 Then
            '// We found a match
            GetStrPos = array(currCaretX, currCaretY)
            Exit For
        End If
    Next
End Function

' ------------------------------------------------------------------------------
'                           Porject functions.
' ------------------------------------------------------------------------------

Function listProjectFiles()
    data = ""
    For i = 0 To projectFilesCount - 1
        data = data & projectFiles(i) & vbNewLine
    Next
    listProjectFiles = data
End Function

' ------------------------------------------------------------------------------
'                           Clipboard functions.
' ------------------------------------------------------------------------------

Function handleClip(text)
    'On Error Resume Next
    Set editor = newEditor()
    With editor
        .NewFile
        If text = "" Then
            '// Get clipboard.
            .command "ecClearAll"
            .command "ecPaste"
            handleClip = .Text
        Else
            '// Set clipboard.
            .command "ecClearAll"
            .selText text
            .command "ecSelectAll"
            .command "ecCopy"
        End If
        '// Hack to prevent save msgbox.
        tmpFile = "C:\temp\clipboard.tmp"
        .saveFileAs tmpFile
        .closeFile
        Set FS = Createobject("Scripting.FileSystemObject")
        FS.DeleteFile tmpFile
    End With
End Function

' ------------------------------------------------------------------------------
'                           Log functions.
' ------------------------------------------------------------------------------

Sub write2Log(msg)
    Set outputlog = NewEditor
    With outputlog
        .AssignLog
        .selText(msg)
    End With
    Set outputlog = Nothing
End Sub

Sub clearLog()
    Set outputlog = NewEditor
    With outputlog
        .AssignLog
        .command "ecClearAll"
    End With
    Set outputlog = Nothing
End Sub

' ------------------------------------------------------------------------------
'                           Output functions.
' ------------------------------------------------------------------------------

Sub displayHelp(msg)
    echo msg
End Sub

Sub displayVarInfo(var)
    msg = "Value: " & var & vbNewLine & _
    "Type: " & Typename(var) & vbNewLine
    echo msg
End Sub

' ------------------------------------------------------------------------------
'                           General module functions.
' ------------------------------------------------------------------------------

Sub modVersion
    displayHelp "Module (" & module_name & ") version: " & moduleVersion(module_name)
End Sub
