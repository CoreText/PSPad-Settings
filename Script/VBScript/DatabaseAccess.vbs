Option Explicit

' PSPad database routines.
const module_name = "DatabaseAccess"
const module_desc = "Database routines"
const module_ver = "0.3" 'Added multi-command SQL support and separated language-dependent strings.

Private cstrCaptionNoTableNamesFound, cstrCaptionSqlLommand, cstrErrCannotConnect
Private cstrErrNoConnection, cstrErrNumber, cstrErrSource, cstrMenuAddSlashes
Private cstrMenuSplitSql, cstrMenuSqlToCsv, cstrMenuSqlToHtml, cstrMenuSqlToTabs
Private cstrMenuExtractNames, cstrMenuOpenLog, cstrMenuEditMe, cstrCaptionDatabaseSelector
Private cstrTitleDatabaseSelector

'-----------------------------
' SETTINGS. ADAPT TO YOUR NEED.

' If you have enabled the SQL log of your (localhost) database server, give the full path here:
Const SERVER_LOG = ""
'Example: "C:\Program Files\MySQL\MySQL Server 4.1\data\YourSqlLog.sql"

' Your standard ODBC connection. Leave empty if you don't have any
Const ODBC_CONNECTION = ""
'Example: "ODBC;DRIVER={MySQL ODBC 3.51 Driver};SERVER=localhost;PORT=3306;DATABASE=YourDefaultDatabase;UID=YourUserName;PWD=YourPassword;OPTION=18475;"

'If True, the "Edit this script" option is added to the menu. Handy when debugging.
Const ADD_EDIT_ME_TO_MENU = True

'Language strings
cstrCaptionNoTableNamesFound = "No table names were found."
cstrCaptionSqlLommand = "Command"
cstrErrCannotConnect = "Cannot connect to ODBC with "
cstrErrNoConnection = "Please connect first."
cstrErrNumber = "Number"
cstrErrSource = "Source"
cstrMenuAddSlashes= "Add &slashes"
cstrMenuSplitSql = "Sho&w Split SQL"
cstrMenuSqlToCsv = "Execute SQL to &Csv"
cstrMenuSqlToHtml = "Execute SQL to &HTML"
cstrMenuSqlToTabs = "Execute SQL to &tabs"
cstrMenuExtractNames = "Extract table &names"
cstrMenuOpenLog = "Open SQL &log"
cstrMenuEditMe = "&Edit this script"
cstrCaptionDatabaseSelector = "Database"
cstrTitleDatabaseSelector = "Please state a database"
'    (END OF SETTINGS.)
'-----------------------------

' The manual
' ----------
' This script is designed for accessing a database through ODBC. It is tested with
' MySQL databases, local and remote, with and without a system DSN. It tries to use
' DAO (Data Access Objects, one of Microsoft's many database libraries) or, failing
' that, ADO (Yet another one). If one of these is installed on your system, the
' script should work. If it does not, you may have to install Microsoft's MDAC.
' If ODBC_CONNECTION is left empty, the database access commands will not be shown
' in the menu.
' When asked for a database, you can either give a database name or a connect string
' like in the example above. When you want to use a system DSN (stored ODBC
' connection on your OS), Use a string like "DSN=SomeDsnName;". Don't forget the
' trailing semicolon.
' When you develop on a localhost database server, it is handy to set it to logging
' all SQL. This way, you can always find what you or your database management
' program has done, so you can repeat it on the live database server. If you put
' the full path of this log in SERVER_LOG, it will be accessible through the
' database menu.
' As this script uses classes, VBScript version 5 is needed to run it. It comes
' with Internet Explorer 5.

Const vbTextCompare = 1
const ERR_INVALID_CURSOR = 3670
const ERR_OPERATION_NOT_ALLOWED = 3704
Const dbOpenForwardOnly = 8
Const dbUseODBC = 1
Const adOpenForwardOnly = 0
Const adUseClient = 3
Dim LINE_END 'Not a real constant, because functions are called
LINE_END = Chr(13) & Chr(10)

Private mstrCurrentDatabase
Private mobjConnection

Class clsAdoConnection
 Private mERRBASE, mERR_NOT_CONNECTED, mcon, mstrSql

 Private Sub Class_Initialize()
    mERRBASE = -2147220750'AC
    mERR_NOT_CONNECTED = mERRBASE + 3
    mstrSql = ""
 End Sub

 Public Sub ExecuteSql(strSql, objRecordWriter)
    Dim rst
    If mcon Is Nothing Then
      Err.Raise mERR_NOT_CONNECTED, module_name & ".clsAdoConnection.ExecuteSql", cstrErrNoConnection
    End If
    mstrSql = strSql
    Set rst = CreateObject("ADODB.Recordset")
    Set rst.ActiveConnection = mcon
    On Error Resume Next
    rst.Open strSql, , adOpenForwardOnly
    If Err.Number<>0 Then ShowErrors objRecordWriter, Err.Description
    If ReturnsOutput(rst) Then
      OutputRecordset rst, objRecordWriter
    End If
    On Error Goto 0
 End Sub

 Private Sub OutputRecordset(rst, objRecordWriter)
    Dim fld
    objRecordWriter.WriteTableStart
    With rst
        On Error Resume Next
        While Not .EOF
             objRecordWriter.WriteRecordStart
             For Each fld In .Fields
                objRecordWriter.WriteField fld.Name, fld.Value
             Next
             objRecordWriter.WriteRecordEnd
             .MoveNext
             If Err.Number<>0 Then ShowErrors objRecordWriter, Err.Description
        Wend
        .Close
        On Error Goto 0
    End With
    objRecordWriter.WriteTableEnd
 End Sub

 Private Function RepairConnectString(strConnect)
    Dim numPos
    numPos = InStr(1, strConnect, "ODBC;")'NOT allowed in ADO connection!
    If numPos>0 Then
      strConnect = Left(strConnect, numPos - 1) & Mid(strConnect, numPos + 5)
    End If
    RepairConnectString = strConnect
 End Function

 Private Function ReturnsOutput(rst)
    Dim numError, blnDummy
    numError = 0
    On Error Resume Next
    blnDummy = rst.EOF
    numError = Err.Number
    On Error Goto 0
    ReturnsOutput = (numError <> ERR_OPERATION_NOT_ALLOWED)
 End Function

 Private Sub ShowErrors(objRecordWriter, strDescription)
    Dim objError
    objRecordWriter.WriteMessage strDescription & "/" & Err.Source
    MsgBox strDescription
    For Each objError In mcon.Errors
       objRecordWriter.WriteMessage objError.Description & " (" &  cstrErrNumber & " " & objError.Number & ", " & cstrErrSource & ": " & objError.Source & ")"
    Next
    If mstrSql<>"" Then
      objRecordWriter.WriteMessage cstrCaptionSqlLommand & ": " & mstrSql
    End If
 End Sub

 Public Function TryToConnect(strConnect)
    Set mcon = CreateObject("ADODB.Connection")
    mstrSql = ""
    If Not (mcon Is Nothing) Then
      On Error Resume Next
      mcon.Open RepairConnectString(strConnect)
      If Err.Number<>0 Then
        Set mcon = Nothing
      End If
      On Error Goto 0
    End If
    TryToConnect = Not (mcon Is Nothing)
 End Function
End Class

Class clsDaoConnection
 Private mERRBASE, mERR_NOT_CONNECTED, mobjRoot, mwsp, mcon, mstrSql

 Private Sub Class_Initialize()
    mERRBASE = -2147218722'DC
    mERR_NOT_CONNECTED = mERRBASE + 3
    mstrSql = ""
 End Sub

 Public Sub ExecuteSql(strSql, objRecordWriter)
    Dim rst, qry
    If mcon Is Nothing Then
      Err.Raise mERR_NOT_CONNECTED, module_name & ".clsDaoConnection.ExecuteSql", cstrErrNoConnection
    End If
    On Error Resume Next
    Set qry = mcon.CreateQueryDef("PSPadScript", strSql)
    If Err.Number<>0 Then ShowErrors objRecordWriter, Err.Description
    Set rst = qry.OpenRecordset(dbOpenForwardOnly)
    If Err.Number<>0 Then ShowErrors objRecordWriter, Err.Description
    If ReturnsOutput(rst) Then
      OutputRecordset rst, objRecordWriter
    End If
    On Error Goto 0
 End Sub

 Private Sub OutputRecordset(rst, objRecordWriter)
    Dim fld
    objRecordWriter.WriteTableStart
    With rst
        On Error Resume Next
        While Not .EOF
             objRecordWriter.WriteRecordStart
             For Each fld In .Fields
                objRecordWriter.WriteField fld.Name, fld.Value
             Next
             objRecordWriter.WriteRecordEnd
             .MoveNext
             If Err.Number<>0 Then ShowErrors objRecordWriter, Err.Description
        Wend
        .Close
        On Error Goto 0
    End With
    objRecordWriter.WriteTableEnd
 End Sub

 Private Function RepairConnectString(strConnect)
    Dim numPos
    numPos = InStr(1, strConnect, "ODBC;")'MUST be present in DAO ODBC connection
    If numPos<1 Then
      strConnect = "ODBC;" & strConnect
    End If
    RepairConnectString = strConnect
 End Function

 Private Function ReturnsOutput(rst)
    Dim numError, blnDummy
    numError = 0
    On Error Resume Next
    blnDummy = rst.EOF
    numError = Err.Number
    On Error Goto 0
    ReturnsOutput = (numError <> ERR_INVALID_CURSOR)
 End Function

 Private Sub ShowErrors(objRecordWriter, strDescription)
    Dim objError
    objRecordWriter.WriteMessage Err.Description
    For Each objError In mobjRoot.Errors
       objRecordWriter.WriteMessage objError.Description & " (" & Number & " " & objError.Number & ", " & cstrErrSource & ": " & objError.Source & ")"
    Next
    If mstrSql<>"" Then
      objRecordWriter.WriteMessage cstrCaptionSqlLommand & ": " & mstrSql
    End If
 End Sub

 Public Function TryToConnect(strConnect)
    Set mcon = Nothing
    mstrSql = ""
    Set mobjRoot = CreateObject("DAO.DBEngine.35") ' DAO 3.51
    If mobjRoot Is Nothing Then
      Set mobjRoot = CreateObject("DAO.DBEngine.36") ' DAO 3.6
    End If
    If Not (mobjRoot Is Nothing) Then
      Set mwsp = mobjRoot.CreateWorkspace("PSPad", "", "", dbUseODBC)
      If Not (mwsp Is Nothing) Then
        On Error Resume Next
        Set mcon = mwsp.OpenConnection("", , , RepairConnectString(strConnect))
        On Error Goto 0
      End If
    End If
    TryToConnect = Not (mcon Is Nothing)
 End Function
End Class

Class clsCsvRecordWriter
 Private mblnIsGatheringHeaders, mstrHeaders, mstrValues, medtLog, mstrQuote

 Private Sub Class_Initialize()
    Set medtLog = newEditor
    medtLog.assignLog
    medtLog.text ""
    mstrQuote = """"
 End Sub

 Public Sub WriteField(strName, varValue)
    mstrValues = mstrValues & "," & mstrQuote & varValue & mstrQuote
    If mblnIsGatheringHeaders Then
      mstrHeaders = mstrHeaders & "," & mstrQuote & strName & mstrQuote
    End If
 End Sub

 Public Sub WriteMessage(strMessage)
    medtLog.appendText LINE_END & strMessage & LINE_END & LINE_END
 End Sub

 Public Sub WriteRecordStart()
    mstrValues = ""
 End Sub

 Public Sub WriteRecordEnd()
    If mblnIsGatheringHeaders Then
      medtLog.appendText Mid(mstrHeaders, 2) & LINE_END
      mblnIsGatheringHeaders = False
    End If
    medtLog.appendText Mid(mstrValues, 2) & LINE_END
 End Sub

 Public Sub WriteTableStart()
    mblnIsGatheringHeaders = True
    mstrHeaders = ""
 End Sub

 Public Sub WriteTableEnd()
 End Sub
End Class

Class clsTabbedRecordWriter
 Private mblnIsGatheringHeaders, mstrHeaders, mstrValues, medtLog, mstrTab

 Private Sub Class_Initialize()
    Set medtLog = newEditor
    medtLog.assignLog
    medtLog.text ""
    mstrTab = chr(9)
 End Sub

 Public Sub WriteField(strName, varValue)
    mstrValues = mstrValues & mstrTab & varValue
    If mblnIsGatheringHeaders Then
      mstrHeaders = mstrHeaders & mstrTab & strName
    End If
 End Sub

 Public Sub WriteMessage(strMessage)
    medtLog.appendText LINE_END & strMessage & LINE_END & LINE_END
 End Sub

 Public Sub WriteRecordStart()
    mstrValues = ""
 End Sub

 Public Sub WriteRecordEnd()
    If mblnIsGatheringHeaders Then
      medtLog.appendText Mid(mstrHeaders, 2) & LINE_END
      mblnIsGatheringHeaders = False
    End If
    medtLog.appendText Mid(mstrValues, 2) & LINE_END
 End Sub

 Public Sub WriteTableStart()
    mblnIsGatheringHeaders = True
    mstrHeaders = ""
 End Sub

 Public Sub WriteTableEnd()
 End Sub
End Class

Class clsTableRecordWriter
 Private mblnIsGatheringHeaders, mstrHeaders, mstrValues, medtLog

 Private Sub Class_Initialize()
    Set medtLog = newEditor
    medtLog.assignLog
    medtLog.text ""
 End Sub

 Public Sub WriteField(strName, varValue)
    mstrValues = mstrValues & "    <td>" & varValue & "</td>" & LINE_END
    If mblnIsGatheringHeaders Then
      mstrHeaders = mstrHeaders & "    <th>" & strName & "</th>" & LINE_END
    End If
 End Sub

 Public Sub WriteMessage(strMessage)
    medtLog.appendText LINE_END & "<strong>" & strMessage & "</strong><br>" & LINE_END & LINE_END
 End Sub

 Public Sub WriteRecordStart()
    mstrValues = "  <tr>" & LINE_END
 End Sub

 Public Sub WriteRecordEnd()
    mstrValues = mstrValues & "  </tr>" & LINE_END
    If mblnIsGatheringHeaders Then
      medtLog.appendText mstrHeaders & "  </tr>" & LINE_END
      mblnIsGatheringHeaders = False
    End If
    medtLog.appendText mstrValues
 End Sub

 Public Sub WriteTableStart()
    mblnIsGatheringHeaders = True
    mstrHeaders = "<table>" & LINE_END & "  <tr>" & LINE_END
 End Sub

 Public Sub WriteTableEnd()
    medtLog.appendText "</table>" & LINE_END
 End Sub
End Class

Class clsArrayWriter
 Private medtLog

 Private Sub Class_Initialize()
    Set medtLog = newEditor()
    medtLog.assignLog()
    medtLog.text ""
 End Sub

 Public Sub WriteLine(strLine)
    medtLog.appendText(strLine & chr(13) & chr(10))
 End Sub
End Class

Class clsDefaultMatchProcessor
 Function Process(strInput)
    Process = strInput
 End Function
End Class

Class clsDeleteMatchProcessor
 Function Process(strInput)
    Dim numPos
    strInput = Trim(strInput)
    numPos = InStr(1, strInput, "FROM", vbTextCompare)
    If numPos>0 Then
      strInput = Trim(Mid(strInput, numPos + 5))
    End If
    Process = strInput
 End Function
End Class

Class clsFirstWordMatchProcessor
 Function Process(strInput)
    Dim numPos
    strInput = Trim(strInput)
    numPos = InStr(1, strInput, " ")
    If numPos>0 Then
      strInput = Rtrim(Left(strInput, numPos - 1))
    End If
    Process = strInput
 End Function
End Class

Class clsHandlerMatchProcessor
 Function Process(strInput)
    Process = Trim(Mid(strInput,8,Len(strInput)-11))
 End Function
End Class

Class clsJoinMatchProcessor
 Function Process(strInput)
    Process = Trim(Mid(Trim(strInput),6))
 End Function
End Class

Class clsLastWordMatchProcessor
 Function Process(strInput)
    Dim numPos
    strInput = Trim(strInput)
    numPos = InStrRev(strInput, " ")
    If numPos>0 Then
      strInput = Mid(strInput, numPos + 1)
    End If
    Process = strInput
 End Function
End Class

Class clsUpdateMatchProcessor
 Function Process(strInput)
    Dim numPos
    strInput = Trim(strInput)
    numPos = InStr(1, strInput, "UPDATE", vbTextCompare)
    If numPos>0 Then
      strInput = Ltrim(Mid(strInput, numPos + 6))
    End If
    numPos = InStrRev(strInput, "SET", -1, vbTextCompare)
    If numPos>0 Then
      strInput = Rtrim(Left(strInput, numPos - 1))
    End If
    Process = strInput
 End Function
End Class

Class clsResultGatherer
 Dim marrResult()
 Private medtCurrent

 Private Sub Add(strResult)
    Dim numCount
    If strResult<>"" Then
      If Not AlreadyPresent(strResult) Then
        numCount = UBound(marrResult)
        marrResult(numCount) = strResult
        Redim Preserve marrResult(numCount + 1)
      End If
    End If
 End Sub

 Private Property Get AlreadyPresent(strText)
    Dim blnFound, numCount
    blnFound = False
    numCount = UBound(marrResult)-1
    While numCount>=0
         If marrResult(numCount)=strText Then
           blnFound = True
           numCount = -5
         End If
         numCount = numCount-1
    Wend
    AlreadyPresent = blnFound
 End Property

 Private Sub Class_Initialize()
    Redim marrResult(0)
    Set medtCurrent = newEditor()
    medtCurrent.assignActiveEditor()
 End Sub

 Public Sub Process(strRegExp, objProcessor)
    Dim objMatch
    With New RegExp
        .Pattern = strRegExp
        .IgnoreCase = True
        .Global = True
        For Each objMatch In .Execute(medtCurrent.text())
           Add objProcessor.Process(objMatch.Value)
        Next
    End With
 End Sub

 Public Sub WriteTo(objWriter)
    Dim numCount
    For numCount = 0 To UBound(marrResult)-1
       objWriter.WriteLine(marrResult(numCount))
    Next
    If UBound(marrResult)=0 Then
      objWriter.WriteLine(cstrCaptionNoTableNamesFound)
    End If
 End Sub
End Class

Class clsSqlSplitter
 Private marrLines()

 Private Sub Class_Initialize()
    Redim marrLines(0)
 End Sub

 Private Sub Add(strSql)
    Dim numCount
    numCount = UBound(marrLines)
    If Left(strSql, 3)="-- " Then
      strSql = "" ' Comment: effectively an empty line
    End If
    If strSql<>"" Then
      marrLines(numCount) = strSql
      Redim Preserve marrLines(numCount + 1)
    End If
 End Sub

 Public Sub AddSql(strSql)
    Dim numPosition, strCurrentQuote, strChr
    strCurrentQuote = ""
    strSql = WithoutLeadingLineEnd(strSql)
    numPosition = 1
    While numPosition<=Len(strSql)
         strChr = Mid(strSql, numPosition, 1)
         Select Case strChr
               Case "'", """":
                   If strCurrentQuote="" Then
                     strCurrentQuote = strChr
                   Else
                     If strCurrentQuote=strChr Then
                       strCurrentQuote = ""
                     End If
                   End If
               Case ";":
                   If strCurrentQuote="" Then
                     Add Left(strSql, numPosition - 1)
                     strSql = WithoutLeadingLineEnd(Mid(strSql, numPosition + 1))
                     numPosition = 0
                   End If
               Case Chr(13), Chr(10):
                   If numPosition=1 Then
                     strSql = WithoutLeadingLineEnd(Mid(strSql, 2))
                   Else
                     If Left(strSql, 3)="-- " Then
                       strSql = WithoutLeadingLineEnd(Mid(strSql, numPosition + 1))
                       numPosition = 0
                     End If
                   End If
         End Select
         numPosition = numPosition + 1
    Wend
    Add strSql
 End Sub

 Public Sub Execute(objConnection, objRecordWriter)
    Dim numCount
    For numCount = 0 To UBound(marrLines) - 1
       objConnection.ExecuteSql marrLines(numCount), objRecordWriter
    Next
 End Sub

 Private Function WithoutLeadingLineEnd(strLine)
  While (Left(strLine,1)=Chr(13)) OR (Left(strLine,1)=Chr(10))
       strLine = Trim(Mid(strLine, 2))
  Wend
  WithoutLeadingLineEnd = Trim(strLine)
 End Function

 Public Sub WriteResults(objRecordWriter)
    Dim numCount
    With objRecordWriter
        .WriteTableStart
        For numCount = 0 To UBound(marrLines)
           .WriteRecordStart
           .WriteField cstrCaptionSqlLommand, marrLines(numCount) & ";"
           .WriteRecordEnd
        Next
        .WriteTableEnd
    End With
 End Sub
End Class

Sub WriteSplitResults()
   Dim edtActive
   Set edtActive = newEditor
   edtActive.assignActiveEditor
   With new clsSqlSplitter
       .AddSql edtActive.text
       .WriteResults new clsTableRecordWriter
   End With
End Sub

Function AddSlashesTo(strInput)
 Dim strOutput, blnBinary, numCount, strChr
 strOutput = ""
 blnBinary = False
 For numCount = 1 To Len(strInput)
    strChr = Mid(strInput, numCount, 1)
    Select Case strChr
          Case chr(13): strChr = "\n"
          Case chr(10): strChr = "\r"
          Case chr(9): strChr = "\t"
          Case chr(8): strChr = "\b"
          Case "'": strChr = "''" ' ANSI Syntax
          Case "\": strChr = "\\"
          Case chr(0): strChr = "\0"
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
      strOutput = "'" & strOutput & "'"
    End If
 AddSlashesTo = strOutput
End Function

Sub AddSlashesToSelection()
 Dim edtCurrent, strInput
 Set edtCurrent = newEditor()
 edtCurrent.assignActiveEditor()
 strInput = AddSlashesTo(edtCurrent.selText())
 edtCurrent.selText(strInput)
End Sub

Function ConnectForDatabase(ByVal strConnect, ByVal strDatabase)
 Dim numStartPos, numEndPos
 If strDatabase<>"" Then
   numEndPos = 0
   numStartPos = InStr(1,strConnect,"DATABASE=")
   If numStartPos>0 Then
     numEndPos = InStr(numStartPos+1,strConnect,";")
   End If
   If numEndPos>0 Then
     strConnect = Left(strConnect, numStartPos - 1) & "DATABASE=" & strDatabase & Mid(strConnect, numEndPos)
   End If
 End If
 ConnectForDatabase = strConnect
End Function

Sub DoSql(strSql, strConnect, objOutput)
 Set mobjConnection = new clsAdoConnection
 If mobjConnection.TryToConnect(strConnect) Then
   SplitAndExecute mobjConnection, strSql, objOutput
 Else
   Set mobjConnection = new clsDaoConnection
   If mobjConnection.TryToConnect(strConnect) Then
     SplitAndExecute mobjConnection, strSql, objOutput
   Else
     MsgBox cstrErrCannotConnect & strConnect
   End If
 End If
End Sub

Sub EditMe()
 newEditor.openFile moduleFileName(module_name)
End Sub

Sub ExecuteHighlightedSqlToCsv()
 Dim strText, strConnect
 strText = SelectedText()
 strConnect = OdbcConnect()
 DoSql strText, strConnect, New clsCsvRecordWriter
End Sub

Sub ExecuteHighlightedSqlToHtml()
 Dim strText, strConnect
 strText = SelectedText()
 strConnect = OdbcConnect()
 DoSql strText, strConnect, New clsTableRecordWriter
End Sub

Sub ExecuteHighlightedSqlToTabs()
 Dim strText, strConnect
 strText = SelectedText()
 strConnect = OdbcConnect()
 DoSql strText, strConnect, New clsTabbedRecordWriter
End Sub

Sub ExtractTables()
 With New clsResultGatherer
     .Process "\s(FROM|JOIN)\s+(\w+)", New clsJoinMatchProcessor
     .Process "HANDLER\s+(\w+)\s+OPEN", New clsHandlerMatchProcessor
     .Process "\b(ALTER|DROP|CREATE)\b.TABLE\b.(IF\b.EXISTS\b.){0,1}([a-z0-9_\-]){1,}", New clsLastWordMatchProcessor
     .Process "\b(INSERT|REPLACE)\b.INTO\b.([a-z0-9_\-])*", New clsLastWordMatchProcessor
     .Process "\bUPDATE\b.([a-z0-9_\-])*\b.SET\b", New clsUpdateMatchProcessor
     .Process "\bDELETE\b.FROM\b.([a-z0-9_\-]*)\b", New clsDeleteMatchProcessor
     .Process "\bTRUNCATE\b.([a-z0-9_\-]*)", New clsLastWordMatchProcessor
     .WriteTo New clsArrayWriter
 End With
End Sub

Sub Init
 addMenuItem cstrMenuAddSlashes, "&" & module_name, "AddSlashesToSelection"
 If ADD_EDIT_ME_TO_MENU Then
   addMenuItem cstrMenuSplitSql, "&" & module_name, "WriteSplitResults"' For debugging only.
 End If
 If ODBC_CONNECTION<>"" Then
   addMenuItem cstrMenuSqlToCsv, "&" & module_name, "ExecuteHighlightedSqlToCsv"
   addMenuItem cstrMenuSqlToHtml, "&" & module_name, "ExecuteHighlightedSqlToHtml"
   addMenuItem cstrMenuSqlToTabs, "&" & module_name, "ExecuteHighlightedSqlToTabs"
 End If
   addMenuItem cstrMenuExtractNames, "&" & module_name, "ExtractTables"
 If SERVER_LOG<>"" Then
   addMenuItem cstrMenuOpenLog, "&" & module_name, "OpenSqlLog"
 End If
 If ADD_EDIT_ME_TO_MENU Then
   addMenuItem "-", "&" & module_name, ""
   addMenuItem cstrMenuEditMe, "&" & module_name, "EditMe"
 End If
End Sub

Function OdbcConnect()
 Dim numPos
 If mstrCurrentDatabase="" Then
   numPos = InStr(1, ODBC_CONNECTION, "DATABASE=")'Read default from ODBC connect string
   If numPos>0 Then
     mstrCurrentDatabase = Mid(ODBC_CONNECTION, numPos + 9)
     numPos = InStr(1, mstrCurrentDatabase, ";")
     If numPos>0 Then
       mstrCurrentDatabase = Left(mstrCurrentDatabase, numPos - 1)
     End If
   End If
 End If
 mstrCurrentDatabase= InputBox(cstrCaptionDatabaseSelector & ":", cstrTitleDatabaseSelector, mstrCurrentDatabase)
 If (InStr(1, mstrCurrentDatabase, "=")<1) And (InStr(1, mstrCurrentDatabase, ";")<1) Then
   OdbcConnect = ConnectForDatabase(ODBC_CONNECTION, mstrCurrentDatabase)
 Else
   OdbcConnect = mstrCurrentDatabase
 End If
End Function

Sub OpenSqlLog()
 With newEditor()
     .openFile(SERVER_LOG)
     .setCaretPos 0, .linesCount()-1
 End With
End Sub

Function SelectedText()
 Dim strText
 With newEditor
     .assignActiveEditor
     strText = .selText
     If strText = "" Then
       strText = .text
     End If
 End With
 SelectedText = strText
End Function

Sub SplitAndExecute(objConnection, strSql, objOutput)
 With new clsSqlSplitter
     .AddSql strSql
     .Execute objConnection, objOutput
 End With
End Sub

Function ToHex(strInput)
 Dim strResult, numCount, strHex
 strResult = "0x" ' Giant hexadecimal string
 For numCount = 1 To Len(strInput)
    strHex = Hex(Asc(Mid(strInput, numCount, 1)))
    If (Len(strHex) Mod 2) = 1 Then
      strHex = "0" & strHex
    End If
    strResult = strResult & strHex
 Next
 ToHex = strResult
End Function
