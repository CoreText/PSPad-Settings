const module_name	= "Open With"
const module_ver	= "1.0"
const module_title	= "Open With"

Sub Init
  addMenuItem "&Akelpad"       , module_name, "OpenAkelPad"    , "Shift+Ctrl+Alt+0"
  addMenuItem "&Notepad++"     , module_name, "OpenNpp"        , "Shift+Ctrl+Alt+9"
  addMenuItem "S&ublime Text 2", module_name, "OpenSublimeText", "Shift+Ctrl+Alt+8"
  addMenuItem "E&mEditor"      , module_name, "OpenEmEditor"   , "Ctrl+Shift+Alt+7"
  addMenuItem "&TotalCommander", module_name, "OpenInTotalCMD" , "Alt+T"
  addMenuItem "&Cubi Explorer" , module_name, "OpenInCubiEx"   , "Ctrl+Alt+O"
  addMenuItem "&Metapath"      , module_name, "RunMetapath"    , "Alt+M"

  addMenuItem "Run &CMD In Current Dir"     , module_name, "RunCMD"     , "Shift+Ctrl+Alt+C"
  addMenuItem "Run &GitBash In Current Dir" , module_name, "RunGitBash" , "Ctrl+Alt+C"
End Sub

Sub OpenAkelPad
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()
  cmdArgs = Chr(34) & activeEditor.fileName() & Chr(34)
  Set wshShell = CreateObject( "WScript.Shell" )
  wshShell.Run "notepad " & cmdArgs
  Set wshShell = Nothing
  Set activeEditor = Nothing
End Sub

Sub OpenNpp
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()
  cmdArgs = Chr(34) & activeEditor.fileName() & Chr(34)
  Set wshShell = CreateObject( "WScript.Shell" )
  wshShell.Run "npp.bat " & cmdArgs , False
  Set wshShell = Nothing
  Set activeEditor = Nothing
End Sub

Sub OpenSublimeText
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()
  cmdArgs = Chr(34) & activeEditor.fileName() & Chr(34)
  Set wshShell = CreateObject( "WScript.Shell" )
  wshShell.Run "Sublime_Text.exe " & cmdArgs , False
  Set wshShell = Nothing
  Set activeEditor = Nothing
End Sub

Sub OpenEmEditor
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()
  cmdArgs = Chr(34) & activeEditor.fileName() & Chr(34)
  Set wshShell = CreateObject( "WScript.Shell" )
  wshShell.Run "EmEditor.exe " & cmdArgs , False
  Set wshShell = Nothing
  Set activeEditor = Nothing
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


Sub OpenInTotalCMD
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()
  cmdArgs = Chr(34) & ExtractFilePath( activeEditor.fileName() ) & Chr(34)
  Set wshShell = CreateObject( "WScript.Shell" )
  wshShell.Run "TOTALCMD64.EXE /O /T /L=" & cmdArgs & " /I=""E:\Program Files\TC\Wincmd64.ini"" " , False
  Set wshShell = Nothing
  Set activeEditor = Nothing
End Sub

Sub OpenInCubiEx
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()
  cmdArgs = Chr(34) & ExtractFilePath( activeEditor.fileName() ) & Chr(34)
  Set wshShell = CreateObject( "WScript.Shell" )

  wshShell.Run "E:\Temp\GoogleDrive\CubicExplorer\CubicExplorer.exe /n  " & cmdArgs , False

  Set wshShell = Nothing
  Set activeEditor = Nothing
End Sub

Sub RunMetapath
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()
  fileN = Chr(34) & activeEditor.fileName() & Chr(34)
  Set wshShell = CreateObject( "WScript.Shell" )
  wshShell.Run "Metapath.exe " & fileN 
  Set wshShell = Nothing
  Set activeEditor = Nothing
End Sub



Sub RunCMD
  Set activeEditor = newEditor()
  activeEditor.assignActiveEditor()

    cmdArgs = Chr(34) & ExtractFilePath(activeEditor.fileName()) & Chr(34)
    'NOTE: cmdArgs can contain multiple commands by separating them with && like this: cmdArgs = "cd\php && php.exe"

    Set wshShell = CreateObject( "WScript.Shell" )
    wshShell.Run "cmd.exe /K cd /d " & cmdArgs , 1, False
     'NOTE:                               1 = show dos window
     '                                    0 = hide dos window
     '                    /K = keep dos window open when application terminates
     '                    /C = close dos window when application terminates

    Set wshShell = Nothing
    Set editor = Nothing
End Sub

Sub RunGitBash
    Set activeEditor = newEditor()
    activeEditor.assignActiveEditor()
    cmdArgs = Chr(34) & ExtractFilePath(activeEditor.fileName()) & Chr(34)
    Set wshShell = CreateObject( "WScript.Shell" )
    wshShell.Run "cmd.exe /K cd /d """ & cmdArgs & """ & sh --login -i"
    Set wshShell = Nothing
    Set editor = Nothing
End Sub




