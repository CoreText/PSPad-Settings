const module_name   = "EditText"
const module_ver    = "1.0"
const module_title  = "&Edit"

'Here you can adjust your keys, but first remap your original keymap
Sub Init
    addMenuItem "Smart Paste" , module_title , "SmartPaste"  , "Ctrl+V"
'     addMenuItem "Duplicate"   , module_title , "HorizontalDuplicate"  , "Ctrl+Alt+D"

    addMenuItem "Selection to &Right" , module_title , "SelectToRight"  , "Ctrl+Alt+Right"
    addMenuItem "Selection to &Left"  , module_title , "SelectToLeft"   , "Ctrl+Alt+Left"
    addMenuItem "Select Line &Down"   , module_title , "SelectLineDown" , "Ctrl+L"
    addMenuItem "Select Line &Up"     , module_title , "SelectLineUp"   , "Shift+Ctrl+L"
    addMenuItem "Select Line & Copy"  , module_title , "SelectLine"     , "Ctrl+Alt+L"
    addMenuItem "Select Scope"        , module_title , "SelectScopeUp"  , "Shift+Ctrl+Alt+Up"
    addMenuItem "Select Scope"        , module_title , "SelectScopeDown", "Shift+Ctrl+Alt+Down"

    addMenuItem "&Join Line"  , module_title , "JoinLine"  , "Shift+Ctrl+J"
    addMenuItem "&Split Line" , module_title , "SplitLine" , "Shift+Ctrl+K"

    addMenuItem "New Line &After"          , module_title , "CtrlEnter"                  , "Ctrl+Enter"
    addMenuItem "New Line Between Smth"    , module_title , "InsertLineBetween"          , "Shift+Enter"
    addMenuItem "New Line &Before Current" , module_title , "InsertNewLineBeforeCurrent" , "Shift+Ctrl+Enter"

    addMenuItem "Tab &Next"     , module_title , "NextTab" , "Alt+Right"
    addMenuItem "Tab &Previous" , module_title , "PrivTab" , "Alt+Left"

    addMenuItem "&1. Add '' Single Quotes To Selection"   , module_title , "AddSingleQuotesToSelection"      , "Ctrl+'"
    addMenuItem "&2. Add """" Double Quotes To Selection" , module_title , "AddSlashesToSelectionn"          , "Shift+Ctrl+'"

    addMenuItem "&3. Add [] Brackets To Selection"        , module_title , "AddBracketsToSelection"          , "Ctrl+["
    addMenuItem "&4. Add {} Braces To Selection"          , module_title , "AddBracesToSelection"            , "Shift+Ctrl+["

    addMenuItem "&5. Add () Round Brackets To Selection"  , module_title , "AddBracsToSelection"             , "Ctrl+9"
    addMenuItem "&6. Add () Round Brackets To Selection"  , module_title , "AddBracsToSelection"             , "Shift+Ctrl+9"

    addMenuItem "&7. Add `` Apostrophes To Selection"     , module_title , "AddApostrophesToSelection" , ""
    addMenuItem "&8. Add %% Procents To Selection"        , module_title , "AddProcentsToSelection"    , ""

    addMenuItem "&9. List With '' Single Quotes To Selection"   , module_title , "AddSingleQuotesToSelectionList"  , "Alt+'"
    addMenuItem "&0. List With """" Double Quotes To Selection" , module_title , "AddDoubleQuotesToSelectionnList" , "Shift+Alt+'"

    addMenuItem "Selected HTML Block To String For JavaScript"  , module_title , "SelectedHTMLBlockToStringForJavaScript" , "Shift+Ctrl+Alt+'"
    addMenuItem "Add Slashes To Selection"                      , module_title , "AddSlashesToSelection"                  , "Ctrl+Alt+'"
    addMenuItem "console.log()"                                 , module_title , "consoleLog"                             , "Alt+J"
    addMenuItem "Pretty print_r()"                              , module_title , "prettyPrinter"                          , "Shift+Ctrl+I"

    addMenuItem "List Selected Items In ()"      , module_title , "ListSelectedItems"   , "Ctrl+0"
    addMenuItem "List Selected Strings ('')" , module_title , "ListSelectedStrings" , "Shift+Ctrl+0"

    addMenuItem "List Selected Items In []" , module_title , "ListSelectedItemsToArr"    , "Ctrl+]"
    addMenuItem "List Selected Items In {}" , module_title , "ListSelectedStringsToSmth" , "Shift+Ctrl+]"

    addMenuItem "List Selected Items In ['']"   , module_title , "ListSelectedItemsToArrQ"    , "Ctrl+Alt+]"
    addMenuItem "List Selected Items In {''}" , module_title , "ListSelectedStringsToSmthQ" , "Shift+Ctrl+Alt+]"

    addMenuItem "List Selected Items In [""]"   , module_title , "ListSelectedItemsToArrDoubleQ"    , "Alt+]"
    addMenuItem "List Selected Items In {""}" , module_title , "ListSelectedStringsToSmthDoubleQ" , "Shift+Alt+]"

    addMenuItem "Open &TODO.txt"                  , module_title , "OpenFileBlank"   , "Shift+Ctrl+Alt+Space"
    addMenuItem "Open Current &Folder"            , module_title , "OpenFolder"      , "Alt+O"
    addMenuItem "Create Floder In Current Dir"    , module_title , "CreateFolder"    , "Ctrl+Alt+N"
    addMenuItem "&Copy Current Full Path"         , module_title , "CopyPath"        , "Alt+C"

    addMenuItem "Focus Move" , module_title, "FocusMove" , "Alt+D"

    addMenuItem "Shift Tab"      , module_title, "ShiftTab"           , "Shift+Tab"
    addMenuItem "Block Indent"   , module_title, "TabSelBlockIn"      , "Shift+Ctrl+Alt+Right"
    addMenuItem "Block Unindent" , module_title, "ShiftTabSelBlockUn" , "Shift+Ctrl+Alt+Left"

    addMenuItem "Goto Matching Tag"         , module_title, "GotoTag" , "Ctrl+W"
'     addMenuItem "SelectWord" , module_title, "SelectWord" , "Ctrl+W"
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

Sub CreateFolder
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

    setClipboardText(currentDir)

    Set SA = CreateObject("Shell.Application")
    Set oFolder = SA.BrowseForFolder(0, "Current Directory:", BIF_EDITBOX Or BIF_NEWDIALOGSTYLE Or BIF_STATUSTEXT Or BIF_VALIDATE, currentDir )

    While (Not oFolder Is Nothing)
        Set SA = CreateObject("Shell.Application")
        Set oFolder = SA.BrowseForFolder(0, "Current Directory:", BIF_EDITBOX Or BIF_NEWDIALOGSTYLE Or BIF_STATUSTEXT Or BIF_VALIDATE, oFolder )
    Wend

    Set obj = Nothing
    Set SA  = Nothing
    Set oFolder = Nothing
    Set currentDir = Nothing
End Sub


Sub consoleLog()
    Dim selTxt, new_selTxt, s
    Set obj = newEditor()
        obj.assignActiveEditor()
        selTxt = obj.selText()

    If selTxt <> "" Then
        CtrlEnter()
        s = "console.log( """ & Trim(selTxt) & ": "", " & Trim(selTxt) & " );" & vbCrLf
        obj.selText(s)
        obj.command("ecUp")
        obj.command("ecLineEnd")
        obj.command("ecLeft")
        runPSPadAction("aSelMatchBracket")

    ElseIf GetTagAtCursor() <> "" Then
        runPSPadAction("aFindWord")
        new_selTxt = obj.selText()
        CtrlEnter()
        s = "console.log( """ & Trim(new_selTxt) & ": "", " & Trim(new_selTxt) & " );" & vbCrLf
        obj.selText(s)
        obj.command("ecUp")
        obj.command("ecLineEnd")
        obj.command("ecLeft")
        runPSPadAction("aSelMatchBracket")

    Else
        s = "console.log(  );" & vbCrLf
        obj.selText(s)
        obj.command("ecUp")
        obj.command("ecLineEnd")
        obj.command("ecLeft")
        runPSPadAction("aSelMatchBracket")

    End If
    Set obj = Nothing
End Sub

Sub prettyPrinter()
    Dim selTxt, new_selTxt, s
    Set obj = newEditor()
        obj.assignActiveEditor()
        selTxt = obj.selText()
    If selTxt <> "" Then
        CtrlEnter()
        s = vbCrLf & "print  ('<pre style=""color: lawngreen ;background-color: black ;padding:12px;overflow:auto;font:.8em Consolas;"">');" & vbCrLf & "print_r( " & Trim(selTxt) & " );" & vbCrLf & "print  (""\r\n</pre>"");" & vbCrLf
        obj.selText(s)
        obj.command("ecUp")
        obj.command("ecUp")
        obj.command("ecLineEnd")
        obj.command("ecRight")
        runPSPadAction("aSelMatchBracket")

    ElseIf GetTagAtCursor() <> "" Then
        runPSPadAction("aFindWord")
        new_selTxt = obj.selText()
        CtrlEnter()
        s = vbCrLf & "print  ('<pre style=""color: lawngreen ;background-color: black ;padding:12px;overflow:auto;font:.8em Consolas;"">');" & vbCrLf & "print_r( " & Trim(new_selTxt) & " );" & vbCrLf & "print  (""\r\n</pre>"");" & vbCrLf
        obj.selText(s)
        obj.command("ecUp")
        obj.command("ecUp")
        obj.command("ecLineEnd")
        obj.command("ecRight")
        runPSPadAction("aSelMatchBracket")

    Else
        s = vbCrLf & "print  ('<pre style=""color: lawngreen ;background-color: black ;padding:12px;overflow:auto;font:.8em Consolas;"">');" & vbCrLf & "print_r(  );" & vbCrLf & "print  (""\r\n</pre>"");" & vbCrLf
        obj.selText(s)
        obj.command("ecUp")
        obj.command("ecUp")
        obj.command("ecLineEnd")
        obj.command("ecRight")
        runPSPadAction("aSelMatchBracket")
    End If
    Set obj = Nothing
End Sub

Function GetFileName()
   On Error Resume Next
   Set editor = newEditor()
   editor.assignActiveEditor
   GetFileName = editor.fileName
End Function

Sub openFolder
   Set FS     = CreateObject("Scripting.FileSystemObject")
   Set Shell  = CreateObject("Shell.Application")
   Set File   = FS.GetFile(GetFileName())
   folderName = File.ParentFolder
   Shell.Explore folderName
End Sub

' under custruction
Sub write2Log()
    Dim selTxt, msgToCmd
    Set obj = NewEditor()
        obj.assignActiveEditor()
        obj.AssignLog()
        msgToCmd = Trim(obj.selText())

      cmdArgs = msgToCmd
      Set wshShell = CreateObject( "WScript.Shell" )
      wshShell.Run "cmd " & cmdArgs , False

        logAddLine(wshShell.Echo)

    Set wshShell = Nothing
    Set obj = Nothing
End Sub


Sub SmartPaste
    Dim sel, clipboard
    Set obj = newEditor()
    obj.assignActiveEditor()
    sel = obj.selText()

    If obj.caretX() = 1 Then
        obj.command("ecPaste")
    Else
        clipboard = LTrim(getClipboardText())
        obj.selText(clipboard)
    End If

    Set obj = Nothing
End Sub

' Sub HorizontalDuplicate
'     Dim sel, clipboard
'     Set obj = newEditor()
'     obj.assignActiveEditor()
'     sel = obj.selText()
'
'     If sel <> "" Then
'         x = obj.caretX()
'         xb = obj.blockBeginX()
'         xe = obj.blockEndX()
'         yb = obj.blockBeginY()
'         ye = obj.blockEndY()
'         MsgBox xe
'         setBlockEnd(xe, ye)
'         setBlockBegin(xb, yb)
'         obj.command("ecCopy")
'         obj.command("ecRight")
'         runPSPadAction("aPasteNoMove")
'
'     End If
'
'     Set obj = Nothing
' End Sub


Function GetTagAtCursor()

  Dim strLine, strChar, strReturn
  Dim i, intPosX, intStartPos, intEndPos
  Dim objEditor

  Set objEditor = newEditor()
  With objEditor
    .assignActiveEditor()
    strLine = .lineText()
    intPosX = .caretX()
  End With
  intStartPos = 1
  intEndPos = Len(strLine)
  For i = intPosX To Len(strLine) Step 1
    strChar = (Mid(strLine, i, 1))
    If (strChar = ">" AND strLastChar <> "%") or strChar = " " or strChar = "}" or strChar = """" or strChar = "'" Then
      if strLastChar = "}" then
        intEndPos = i - 2
      elseif strChar = "}" or strChar = " " or strChar = """" or strChar = "'" then
        intEndPos = i - 1
      else
        intEndPos = i
      End If
      Exit For
    End If
    strLastChar = strChar
  Next
  For i = intEndPos To 1 Step -1
    strChar = (Mid(strLine, i, 1))
    If (strChar = "<" AND strLastChar <> "%") or strChar = " " or strChar = "{" or strChar = """" or strChar = "'" Then
      if strLastChar = "{" then
        intStartPos = i + 2
      elseif strChar = "{" or strChar = " " or strChar = """" or strChar = "'" then
        intStartPos = i + 1
      else
        intStartPos = i
      End If
      Exit For
    End If
    strLastChar = strChar
  Next
  GetTagAtCursor = Mid(strLine, intStartPos, intEndPos - intStartPos + 1)
End Function

Sub GotoTag
    Dim currentTag, selTxt, counter
    Set obj = NewEditor()
    obj.assignActiveEditor()

    runPSPadAction "aHTMLSelTag"

    If obj.blockEndX() = obj.caretX Then
        obj.command("ecRight")
        obj.command("ecLeft")
    ElseIf obj.blockBeginX() = obj.caretX Then
        obj.command("ecLeft")
        obj.command("ecRight")
    End If

    Set obj = Nothing
End Sub



' under construction
Sub SelectWord
    Dim line, leng, curx, cury, cursmb, i, begPos, endPos
    Set ed = NewEditor()
    ed.assignActiveEditor()

    line = ed.lineText()
    curx = ed.caretX()
    cury = ed.caretY()
    leng = Len(line)

    i = curx - 1
'     While Mid( line, i, leng ) And i < leng
'     	i = i + 1
'     Wend

'     endPos = i - 1
'      i = curx - 1

    MsgBox TypeName(ed.caretY)
    MsgBox ed.caretY

End Sub


Sub ShiftTab
    Set obj = newEditor()
    obj.assignActiveEditor()

' TPSSynEdit
    If obj.selText() = "" Then
        obj.command("ecPageRight")
        obj.command("ecSelLineStart")
        obj.command("ecBlockUnindent")
        runPSPadAction "ecNormalSelect"
        obj.command("ecPageLeft")
        obj.command("ecLineStart")
    Else
        obj.command("ecBlockUnindent")
    End If

    Set obj = Nothing
End Sub

Sub TabSelBlockIn
    Set obj = newEditor()
    obj.assignActiveEditor()

    If obj.selText() = "" Then
        obj.command("ecPageRight")
        obj.command("ecSelLineStart")
        obj.command("ecBlockIndent")
        runPSPadAction "ecNormalSelect"
        obj.command("ecLeft")
    Else
        obj.command("ecBlockIndent")
    End If

    Set obj = Nothing
End Sub

Sub ShiftTabSelBlockUn
    Set obj = newEditor()
    obj.assignActiveEditor()

    If obj.selText() = "" Then
        obj.command("ecPageRight")
        obj.command("ecSelLineStart")
        obj.command("ecBlockUnindent")
        runPSPadAction "ecNormalSelect"
        obj.command("ecPageLeft")
        obj.command("ecLineStart")
    Else
        obj.command("ecBlockUnindent")
    End If

    Set obj = Nothing
End Sub


' List of items
Sub ListSelectedItems
    Dim item, selTxt, objSelTxt, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & Trim(item) & ", "
            End If
        Next
        s = "( " & Left(s, len(s)-2) & " )" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "( " & s & " )"
        obj.selText(s)
        obj.command("ecLeft")
        obj.command("ecLeft")
    End If

    Set obj = Nothing
End Sub


' List selected items wrap with strings
Sub ListSelectedStrings
	Dim item, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & "'" & Trim(item) & "', "
            End If
        Next
        s = "( " & Left(s, len(s)-2) & " )" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "(" & s & ")"
        obj.selText(s)
        obj.command("ecLeft")
    End If

    Set obj = Nothing
End Sub


' List of items
Sub ListSelectedItemsToArr
    Dim item, selTxt, objSelTxt, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & Trim(item) & ", "
            End If
        Next
        s = "[ " & Left(s, len(s)-2) & " ]" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "[" &  s & "]"
        obj.selText(s)
        obj.command("ecLeft")
        InsertLineBetween()
    End If

    Set obj = Nothing
End Sub


' List selected items wrap with strings
Sub ListSelectedStringsToSmth
	Dim item, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & Trim(item) & ", "
            End If
        Next
        s = "{ " & Left(s, len(s)-2) & " }" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "{" & s & "}"
        obj.selText(s)
        obj.command("ecLeft")
        InsertLineBetween()
    End If

    Set obj = Nothing
End Sub


' List of items
Sub ListSelectedItemsToArrQ
    Dim item, selTxt, objSelTxt, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & "'" & Trim(item) & "', "
            End If
        Next
        s = "[ " & Left(s, len(s)-2) & " ]" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "[" &  s & "]"
        obj.selText(s)
        obj.command("ecLeft")
        InsertLineBetween()
    End If

    Set obj = Nothing
End Sub


' List selected items wrap with strings
Sub ListSelectedStringsToSmthQ
	Dim item, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & "'" & Trim(item) & "', "
            End If
        Next
        s = "{ " & Left(s, len(s)-2) & " }" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "{" & s & "}"
        obj.selText(s)
        obj.command("ecLeft")
        InsertLineBetween()
    End If

    Set obj = Nothing
End Sub


' List of items
Sub ListSelectedItemsToArrDoubleQ
    Dim item, selTxt, objSelTxt, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & """" & Trim(item) & """, "
            End If
        Next
        s = "[ " & Left(s, len(s)-2) & " ]" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "[" &  s & "]"
        obj.selText(s)
        obj.command("ecLeft")
        InsertLineBetween()
    End If

    Set obj = Nothing
End Sub


' List selected items wrap with strings
Sub ListSelectedStringsToSmthDoubleQ
	Dim item, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & """" & Trim(item) & """, "
            End If
        Next
        s = "{ " & Left(s, len(s)-2) & " }" & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = obj.selText()
        s = "{" & s & "}"
        obj.selText(s)
        obj.command("ecLeft")
        InsertLineBetween()
    End If

    Set obj = Nothing
End Sub


Sub AddSingleQuotesToSelectionList
	Dim item, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & "'" & Trim(item) & "', "
            End If
        Next
        s = Left(s, len(s)-2)  & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = "'" & obj.selText() & "'"
        obj.selText(s)
    End If

    Set obj = Nothing
End Sub


Sub AddDoubleQuotesToSelectionnList
	Dim item, s
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & """" & Trim(item) & """, "
            End If
        Next
        s = Left(s, len(s)-2)  & vbCrLf
        obj.selText(s)
        obj.command("ecLeft")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = """" & obj.selText() & """"
        obj.selText(s)
    End If

    Set obj = Nothing
End Sub


Function AddSlashes(strInput)
 Dim strOutput, blnBinary, numCount, strChr
 strOutput = ""
 blnBinary = False
 For numCount = 1 To Len(strInput)
    strChr = Mid(strInput, numCount, 1)
    Select Case strChr
          Case chr(13): strChr = "\n"
          Case chr(10): strChr = "\r"
          Case chr(9) : strChr = "\t"
          Case chr(8) : strChr = "\b"
          Case "'"    : strChr = "''" ' ANSI Syntax
          Case "\"    : strChr = "\\"
          Case chr(0) : strChr = "\0"
          Case chr(26): strChr = "\Z"
          Case Else:
              If Asc(strChr)<32 Or Asc(strChr)>126 Then
                blnBinary = True
              End If
    End Select
    strOutput = strOutput & strChr
 Next
    If blnBinary Then
      strOutput = ToHex(strInput)
    Else
      strOutput = strOutput
    End If
 AddSlashes = strOutput
End Function

Sub AddSlashesToSelection()
    Dim s
    Set obj = NewEditor()
    obj.assignActiveEditor()

    If obj.selText() <> "" Then

        s = AddSlashes(obj.selText())
        obj.selText(s)
    Else
        obj.command("ecPageLeft")
        obj.command("ecSelLineEnd")
        AddSlashes(obj.selText())
        s = AddSlashes(obj.selText())
        obj.selText(s)
    End If
    Set obj = Nothing
End Sub


Function AddSlashesToDoubleQuotes(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        Select Case strChr
              Case chr(13): strChr = "\n"
              Case chr(10): strChr = "\r"
              Case chr(9) : strChr = "\t"
              Case chr(8) : strChr = "\b"
              Case "'"    : strChr = "''" ' ANSI Syntax
              Case """"   : strChr = "\"""
              Case chr(0) : strChr = "\0"
              Case chr(26): strChr = "\Z"
              Case Else:
                  If Asc(strChr)<32 Or Asc(strChr)>126 Then
                    blnBinary = True
                  End If
        End Select
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = strOutput
    End If
    AddSlashesToDoubleQuotes = strOutput
End Function

Sub SelectedHTMLBlockToStringForJavaScript()
	Dim item, s, selTxt, arrLines
    Set obj = NewEditor()
    obj.assignActiveEditor()
    s = ""
    selTxt = obj.selText()
    arrLines = Split(selTxt, vbCrLf)
    If selTxt <> "" Then
        For Each item In arrLines
            If Trim(Item) <> "" Then
                s = s & """" & Trim(AddSlashesToDoubleQuotes(item)) & "\n"" + " & vbCrLf
            End If
        Next
        s = Left(s, len(s)-2)  & vbCrLf

        obj.selText(s)
        obj.command("ecLeft")
        obj.command("ecDeleteLastChar")
        obj.command("ecDeleteLastChar")
        setClipboardText(s)
    Else
        runPSPadAction "aFindWord"
        s = """" & AddSlashesToDoubleQuotes(obj.selText()) & """"
        obj.selText(s)
    End If

    Set obj = Nothing
End Sub


' Copy current full path
Sub CopyPath
    Set activeEditor = newEditor()
    activeEditor.assignActiveEditor()
    curPath = activeEditor.fileName()
    setClipboardText(curPath)
    Set activeEditor = Nothing
End Sub

Sub OpenFileBlank
    Set wshShell = CreateObject( "WScript.Shell" )
    wshShell.Run "PSPad.exe TODO.txt" , False
    Set wshShell = Nothing
    Set activeEditor = Nothing
End Sub


Function AddSingleQuotesTo(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = "'" & strOutput & "'"
    End If
    AddSingleQuotesTo = strOutput
End Function

Sub AddSingleQuotesToSelection()
    Dim strInput
    With newEditor()
        .assignActiveEditor()
        strInput = AddSingleQuotesTo(.selText())
        .selText(strInput)
        .command("ecLeft")
    End With
End Sub


Function AddBracketsTo(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = "[" & Trim(strOutput) & "]"
    End If
    AddBracketsTo = strOutput
End Function

Sub AddBracketsToSelection()
    Dim strInput
    With newEditor()
        .assignActiveEditor()
        strInput = AddBracketsTo(.selText())
        .selText(strInput)
        .command("ecLeft")
    End With
End Sub


Function AddBracesTo(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = "{" & Trim(strOutput) & "}"
    End If
    AddBracesTo = strOutput
End Function

Sub AddBracesToSelection()
    Dim strInput
    With newEditor()
        .assignActiveEditor()
        strInput = AddBracesTo(.selText())
        .selText(strInput)
        .command("ecLeft")
    End With
End Sub


Function AddBracsTo(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = "(" & Trim(strOutput) & ")"
    End If
    AddBracsTo = strOutput
End Function

Sub AddBracsToSelection()
    Dim strInput
    With newEditor()
         .assignActiveEditor()
         strInput = AddBracsTo(.selText())
         .selText(strInput)
         .command("ecLeft")
    End With
End Sub


Function AddApostrophesTo(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = "`" & Trim(strOutput) & "`"
    End If
    AddApostrophesTo = strOutput
End Function

Sub AddApostrophesToSelection()
    Dim strInput
    With newEditor()
         .assignActiveEditor()
         strInput = AddApostrophesTo(.selText())
         .selText(strInput)
        .command("ecLeft")
    End With
End Sub

Function AddProcentsTo(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = "%" & Trim(strOutput) & "%"
    End If
    AddProcentsTo = strOutput
End Function

Sub AddProcentsToSelection()
    Dim strInput
    With newEditor()
         .assignActiveEditor()
         strInput = AddProcentsTo(.selText())
         .selText(strInput)
        .command("ecLeft")
    End With
End Sub


Function AddSlashesToo(ByVal strInput)
    Dim strOutput, blnBinary, numCount, strChr
    strOutput = ""
    blnBinary = False
    For numCount = 1 To Len(strInput)
        strChr = Mid(strInput, numCount, 1)
        strOutput = strOutput & strChr
    Next
    If blnBinary Then
       strOutput = ToHex(strInput)
    Else
       strOutput = """" & strOutput & """"
    End If
    AddSlashesToo = strOutput
End Function

Sub AddSlashesToSelectionn()
    Dim strInput
    With newEditor()
        .assignActiveEditor()
        strInput = AddSlashesToo(.selText())
        .selText(strInput)
        .command("ecLeft")
    End With
End Sub


Sub NextTab()
    With newEditor()
        .assignActiveEditor()
        runPSPadAction "aSelectNext"
    End With
End Sub

Sub PrivTab()
    With newEditor()
        .assignActiveEditor()
        runPSPadAction "aSelectPrew"
    End With
End Sub

Sub SelectToRight()
    With newEditor()
        .assignActiveEditor()
        .command("ecSelLineEnd")
    End With
End Sub

Sub SelectToLeft()
    With newEditor()
        .assignActiveEditor()
        .command("ecSelLineStart")
    End With
End Sub


Sub SelectLineDown()
    Dim blockY, caretY
    Set obj = NewEditor()
    obj.assignActiveEditor()

    If obj.selText() <> "" Then
        obj.command("ecSelPageLeft")
        obj.command("ecSelDown")
    Else
        obj.command("ecNormalSelect")
        obj.command("ecPageLeft")
        obj.command("ecSelDown")
    End If

    Set obj = Nothing
End Sub

Sub SelectLineUp()
    Set obj = NewEditor()
    obj.assignActiveEditor()
    If obj.selText() <> "" Then
        obj.command("ecSelUp")
    Else
        obj.command("ecNormalSelect")
        obj.command("ecPageRight")
        obj.command("ecRight")
        obj.command("ecSelUp")
    End If

    Set obj = Nothing
End Sub

Sub SelectLine()
    Set obj = NewEditor()
    obj.assignActiveEditor()
    If obj.selText() <> "" Then
        obj.command("ecNormalSelect")
        obj.command("ecSelLineStart")
        obj.command("ecCopy")
    Else
        obj.command("ecNormalSelect")
        obj.command("ecPageRight")
        obj.command("ecSelLineStart")
        obj.command("ecCopy")
    End If

    Set obj = Nothing
End Sub

Sub SelectScopeDown()
    Set obj = NewEditor()
        obj.assignActiveEditor()
    If obj.selText() <> "" Then
        obj.command("ecScrollDown")
        SelectLineDown()

        line = obj.lineText()

        If Trim(line) = "" Or Trim(line) = "//"  Or Trim(line) = "*" Then
            obj.command("ecScrollDown")
            SelectLineDown()
            SelectLineDown()
            SelectLineDown()
'             obj.command("ecSelLineStart")

            SelectLineDown()
            obj.command("ecSelLineStart")
        End If

        If Trim(line) = "}" Then
            obj.command("ecSelLineStart")
            runPSPadAction "aSelMatchBracket"
'             MsgBox "hello"
'             SelectLineDown()
'             SelectLineDown()
        End If

        runPSPadAction "aSelMatchBracket"
        runPSPadAction "aSelMatchBracket"
        obj.command("ecSelLineStart")
        obj.command("ecScrollDown")

'         obj.command("ecSelLeft")
'         runPSPadAction ""
    Else
        SelectLineDown()
        obj.command("ecSelLineEnd")
        runPSPadAction "aSelMatchBracket"
        runPSPadAction "aSelMatchBracket"
        obj.command("ecSelLineStart")
    End If

    Set obj = Nothing
End Sub

Sub SelectScopeUp()
    Set obj = NewEditor()
        obj.assignActiveEditor()
    If obj.selText() <> "" Then
        runPSPadAction "aSelMatchBracket"
        runPSPadAction "aSelMatchBracket"
'         obj.command("ecLineEnd")
        obj.command("ecSelLineStart")


'         obj.command("ecScrollDown")
'         obj.command("ecSelLeft")
'         runPSPadAction ""
'         SelectLineDown()
    Else
        SelectLineDown()
        obj.command("ecSelLineEnd")
        runPSPadAction "aSelMatchBracket"
        runPSPadAction "aSelMatchBracket"
        obj.command("ecSelLineStart")
    End If

    Set obj = Nothing
End Sub

Sub JoinLine()
    Set obj = NewEditor()
        obj.assignActiveEditor()
    If obj.selText() <> "" Then
        obj.command("ecScrollDown")
        obj.command("ecSelLeft")
        runPSPadAction "aJoinLine"
        SelectLineDown()
    Else
        SelectLineDown()
        obj.command("ecSelLineEnd")
        runPSPadAction "aJoinLine"
    End If

    Set obj = Nothing
End Sub

Sub SplitLine()
    Dim s, line, selTxt, curx, cury, leng, count
    Set obj = NewEditor()
        obj.assignActiveEditor()

    line   = obj.lineText()
    selTxt = Trim(obj.selText())

    s = ""
    If obj.selText() <> "" Then
        obj.command("ecScrollDown")

        count = Len(selTxt) - Len( Replace( selTxt, " ", "" ) )
        s = Replace( selTxt, " ", vbCrLf )

        obj.selText(s)

        If line <> "" Then
            counter = 1
            While counter <= count
                counter = counter + 1
                SelectLineUp()
            Wend
            obj.command("ecSelWordLeft")
            obj.command("ecSelWordLeft")
        Else
            obj.command("ecSelWordLeft")
            counter = 1
            While counter <= count
                counter = counter + 1
                SelectLineUp()
            Wend
            obj.command("ecSelWordLeft")
        End If
    Else
        obj.command("ecSelLineEnd")
        selTxt_New = Trim(obj.selText())

        count = Len(selTxt_New) - Len( Replace( selTxt_New, " ", "" ) )
        s = Replace( selTxt_New, " ", vbCrLf )

        obj.selText(s)

        counter = 1
        While counter <= count
            counter = counter + 1
            SelectLineUp()
        Wend
        obj.command("ecSelWordLeft")
        obj.command("ecSelWordLeft")
    End If

    Set obj = Nothing
End Sub


Sub CtrlEnter()
    With newEditor()
        .assignActiveEditor()
        .command("ecPageRight")
        .command("ecLineBreak")
    End With
End Sub

Sub InsertNewLineBeforeCurrent()
    Set obj = newEditor()
        obj.assignActiveEditor()

    If obj.caretY < 2 And obj.selText() = "" Then
        obj.command("ecInsertLine")
    ElseIf obj.caretY < 2 And obj.selText <> "" Then
        obj.command("ecPageLeft")
        obj.command("ecInsertLine")
    Else
        obj.command("ecPageLeft")
        obj.command("ecUp")
        obj.command("ecPageRight")
        obj.command("ecPageRight")
        obj.command("ecLineBreak")
    End If
End Sub

Sub InsertLineBetween()
    Set obj = newEditor()
        obj.assignActiveEditor()

    If obj.selText() <> "" Then
        obj.command("ecCut")
        obj.command("ecLineBreak")
        obj.command("ecUp")
        obj.command("ecPageRight")
        obj.command("ecLineBreak")
        obj.command("ecTab")
        obj.command("ecPaste")
    Else
        obj.command("ecLineBreak")
        obj.command("ecUp")
        obj.command("ecPageRight")
        obj.command("ecLineBreak")
        obj.command("ecTab")
    End If

    Set obj = Nothing
End Sub

Sub FocusMove
    With newEditor()
        .assignActiveEditor()

        runPSPadAction "aSwitchLog"
    End With
End Sub

