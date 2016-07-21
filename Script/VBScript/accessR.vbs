Const module_name  = "accessR"
Const module_desc  = "Use R with PSPad"
Const module_ver   = "0.002a"

pspath = getVarValue("%PSPath%")

Sub SendCurrentLineToR(params)
  
' get selection content
  Const qt=""""
  sSourceFile = qt + pspath + "Script\clipboardtor.exe " + qt + params

  Set editor = newEditor()
  editor.assignActiveEditor
  handleSelText = editor.lineText()

' copy content to clipboard
  contentOld = getClipboardText()
  
  setClipboardText(handleSelText & vbNewLine)
  
  Set WshShell = CreateObject("WScript.Shell")
  intReturn = WshShell.run(sSourceFile,,true)

' clean up
  Set WshShell = nothing
  setClipboardText(contentOld)

End Sub

Sub SendFileToR(params)

' init
  contentOld = getClipboardText()
  fullFileName = getVarValue("%FullFileName%")
  filePath = getVarValue("%FilePath%")
  Const qt=""""
  sSourceFile = qt + pspath + "Script\clipboardtor.exe" + qt + params

' execute commands
  command = "pspad_dummy = getwd();" 
  command = command + "setwd('" + makeLinuxFs(filePath) + "');"
  command = command + "source('" + makeLinuxFs(fullFileName) + "');"
  command = command + "setwd(pspad_dummy);"
  setClipboardText(command & vbNewLine)

  Set WshShell = CreateObject("WScript.Shell")
  intReturn = WshShell.run(sSourceFile,,true)

' clean up
  Set WshShell = nothing
  setClipboardText(contentOld)
End Sub

Function makeLinuxFs(fileOrPath)
' replace backslashes  
  Set regEx = New RegExp
  
  regEx.Pattern = "\\" 
  regEx.Global = true
  fileOrPath = regEx.Replace(fileOrPath, "/")

  Set regEx = nothing
  
  makeLinuxFs = fileOrPath
End Function

Sub SendSelectionToR(params)
  
' get selection content
  Const qt=""""
  sSourceFile = qt + pspath + "Script\clipboardtor.exe " + qt + params

  Set editor = newEditor()
  editor.assignActiveEditor
  handleSelText = editor.selText

' copy content to clipboard
  contentOld = getClipboardText()
  
  setClipboardText(handleSelText & vbNewLine)
  
  Set WshShell = CreateObject("WScript.Shell")
  intReturn = WshShell.run(sSourceFile,,true)

' clean up
  Set WshShell = nothing
  setClipboardText(contentOld)
End Sub


Sub OpenRWithPutty
End Sub


Sub SendFileToR1
  SendFileToR(" 1")
End Sub

Sub SendFileToR2
  SendFileToR(" 2")
End Sub


Sub SendSelectionToR1
  SendSelectionToR(" 1")
End Sub

Sub SendSelectionToR2
  SendSelectionToR(" 2")
End Sub


Sub SendCurrentLineToR1
  SendCurrentLineToR(" 1")
End Sub

Sub SendCurrentLineToR2
  SendCurrentLineToR(" 2")
End Sub

Sub Init
  addMenuItem "Send file to R (refocus to PSPad)"        , "Access R", "SendFileToR1"       , ""
  addMenuItem "Send current line to R (refocus to PSPad)", "Access R", "SendCurrentLineToR1", ""
  addMenuItem "Send selection to R (refocus to PSPad)"   , "Access R", "SendSelectionToR1"  , ""
  addMenuItem "Send file to R"                           , "Access R", "SendFileToR2"       , ""
  addMenuItem "Send current line to R"                   , "Access R", "SendCurrentLineToR2", ""
  addMenuItem "Send selection to R"                      , "Access R", "SendSelectionToR2"  , ""
End Sub

