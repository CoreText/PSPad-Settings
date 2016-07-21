' ------------------------------------------------------------------------------
' file:     FileSystem.vbs
' date:     07/28/2005 - 05/04/2006
' author:   Scott Greenberg <me@gogogadgetscott.com>
' link:     http://gogogadgetscott.info/computers/cc/snippet.php?sid=55
' requires: GoGo 1.03 or greater <http://gogogadgetscott.info/computers/cc/snippet.php?sid=54>
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
' Available functions:
'
' Execute - Same as menu File > Open file appointed by selection.
' Execute File - Same as menu Start > Run.
' Open folder - Open file's parent folder with default file manager. i.e. explorer
' Create Folder
' Open in New Window - Open current tab in new window overriding
'  "Only One Program Instance" setting.
' ------------------------------------------------------------------------------
Const module_name  = "FileSystem"
Const module_ver   = "1.05"

' ------------------------------------------------------------------------------
'                          File system subroutines.
' ------------------------------------------------------------------------------

Sub openFolder
    Set FS     = CreateObject("Scripting.FileSystemObject")
    Set Shell  = CreateObject("Shell.Application")
    Set File   = FS.GetFile(getActiveFilename())
    folderName = File.ParentFolder
    Shell.Explore folderName
End Sub

'// Uses shell to execute selected text.
Sub Execute
    On Error Resume Next
    Set SH = Wscript.CreateObject("WScript.Shell")
    SH.Run GoGo.handleSelText("")
End Sub

'// Executed current file using shell.
Sub executeFile
    On Error Resume Next
    Set SH = Wscript.CreateObject("WScript.Shell")
    SH.Run """" & getActiveFilename & """"
End Sub

'Gets ParentFolder?
Function ExtractFilePath ( strPath )
    If Len(strPath) = 0 Then
      Exit Function                                    ' input string is empty
    Else
      strPath = Replace(strPath, Chr(47), Chr(92))     ' convert backslashes to forward slashes
      If InStr(1, strPath, Chr(92)) = 0 Then
        Exit Function                                  ' string contains no forward slashes
      End If
    End If
    ExtractFilePath = Left(strPath, InStrRev(strPath, Chr(92)))
End Function

Sub createFolder
    Const BIF_BROWSEFORCOMPUTER  = &H1000
    Const BIF_BROWSEFORPRINTER   = &H2000
    Const BIF_BROWSEINCLUDEFILES = &H4000
    Const BIF_BROWSEINCLUDEURLS  = &H80
    Const BIF_DONTGOBELOWDOMAIN  = &H2
    Const BIF_EDITBOX            = &H10
    Const BIF_NEWDIALOGSTYLE     = &H40
    Const BIF_RETURNFSANCESTORS  = &H8
    Const BIF_RETURNONLYFSDIRS   = &H1
    Const BIF_SHAREABLE          = &H8000
    Const BIF_STATUSTEXT         = &H4
    Const BIF_USENEWUI           = &H40
    Const BIF_VALIDATE           = &H20

  Set obj = newEditor()
  obj.assignActiveEditor()
  currentDir = ExtractFilePath( obj.fileName() )


    Set SA = CreateObject("Shell.Application")
    'sselText = handleSelText("")

    Set oFolder = SA.BrowseForFolder(0, "My Computer:", BIF_EDITBOX Or BIF_NEWDIALOGSTYLE Or BIF_STATUSTEXT Or BIF_VALIDATE, currentDir )

    If (Not oFolder Is Nothing) Then
        MsgBox "Wat?! oFolder Is Nothing"
    End If

    Set obj = Nothing
    Set SA = Nothing
    Set oFolder = Nothing
End Sub

' ------------------------------------------------------------------------------
'                               Active file functions.
' ------------------------------------------------------------------------------

Public Function getActiveFilename()
    On Error Resume Next
    Set editor = newEditor()
    editor.assignActiveEditor
    getActiveFilename = editor.fileName
End Function

Public Function getActiveDir()
    getActiveDir = getDir(getActiveFilename())
End Function

Public Sub reloadActiveFile()
    With newEditor()
        .assignActiveEditor
        y = .caretY
        x = .caretX
        .openFile .fileName
        .caretY y
        .caretX x
    End With
End Sub

Public Sub reloadAllFiles()
    For intCount = 0 To projectFilesCount - 1
        With newEditor()
            .assignEditorByIndex(intCount)
            y = .caretY
            x = .caretX
            .openFile .fileName
            .caretY y
            .caretX x
        End With
    Next
End Sub

Sub ForceNewWindow
    Set FS = CreateObject("Scripting.FileSystemObject")
    sConfig = FileSystem.getPSPadDir() & "\PSPad"
    sApp = sConfig & ".exe"
    sConfig = sConfig & "_MU.ini"
    sData = FS.OpenTextFile(sConfig).ReadAll

    '// Get setting
    If InStr(sData, "MultiInstanc=0") > 0 Then
        '// Set setting
        MultiInstanc = 0
        sData = Replace(sData, "MultiInstanc=0", "MultiInstanc=1")
        Set F = FS.OpenTextFile(sConfig, 2, TRUE)
        F.Write sData
        F.Close
    Else
        MultiInstanc = 1
    End If

    Set SH = Wscript.CreateObject("WScript.Shell")
    sCmd = """" & sApp & """ """ & FileSystem.getActiveFilename & """"
    SH.Run sCmd

    '// Close tab
    Set editor = newEditor()
    editor.assignActiveEditor
    editor.closeFile

    '// Reset setting
    If MultiInstanc = 0 Then

        Sleep 2500

        sData = Replace(sData, "MultiInstanc=1", "MultiInstanc=0")
        Set F = FS.OpenTextFile(sConfig, 2, TRUE)
        F.Write sData
        F.Close
    End If

End Sub

' ------------------------------------------------------------------------------
'                           Info functions.
' ------------------------------------------------------------------------------

Public Function getDir(sFullPath)
    numPos = InStrRev(sFullPath, "\")
    getDir = Left(sFullPath, numPos)
End Function

Public Function getPSPadDir
    Set FS     = CreateObject("Scripting.FileSystemObject")
    getPSPadDir = FS.GetParentFolderName(FS.GetParentFolderName(modulePath()))
End Function

' ------------------------------------------------------------------------------
'                           Default module subroutines.
' ------------------------------------------------------------------------------

' "Init" is required
' It is called automatically during initialization to create menu items.
Sub Init
    menuName = "&" & module_name
    addMenuItem "&Execute"              , menuName, "execute", "CTRL+F5"
    addMenuItem "Execute &File"         , menuName, "executeFile", "ALT+F5"
    addMenuItem "Open fol&der"          , menuName, "openFolder"
    addMenuItem "&Create Folder"        , menuName, "createFolder"
    addMenuItem "Open in New &Window"   , menuName, "ForceNewWindow"
End Sub
