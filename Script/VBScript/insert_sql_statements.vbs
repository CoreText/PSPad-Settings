'*******************************************************************************
'    FILENAME        : insert_sql_statements.vbs

'    DESCRIPTION     : This script is designed to connect to a database and insert
'                      a code block (ASP/VBScript syntax) based on the selected  
'                      table's column names into the active document.

'                      It takes a connection string (text if selected in the active document) 
'                      and a table name and returns either:
'                      - an SQL statement string (INSERT, UPDATE, DELETE or SELECT)
'                      - a data retrieval code block for Request.QueryString or Request.Form
'                      - a variable declaration code block
'                      - a "GetRows" array loop
'                      If no preference is entered all options are written to the 
'                      active document

'                      Column info (Field Name, Data Type, Size, IsNullable)
'                      is also returned in the log window if an x is typed after 
'                      the selected code option.

'    CREATED         : 18 July 2006
'    CREATED BY      : James Swan

'    NOTE            : A default connection string can be entered on line 49
'                      as can an SQL string variable name on line 52.
'                      Since this script uses Regular Expressions VBScript  
'                      version 5 is needed to run it. This is the version of the 
'                      VBScript scripting engine released with Internet Explorer 5.
'                      This script has only been tested on Windows 2000 and XP
'                      connecting to MS SQL Server and MS Access databases.

'    You may distribute this script freely, but please keep this header intact.

'    Version History : 0.2 (2006-08-21) - fixed minor formatting bugs
'                      0.3 (2006-11-01) - improved ADO data type recovery
'                                       - added an adaption of Scott Greenberg's
'                                         align columns procedure to format the
'                                         column info in the log window
'                      0.4 (2008-02-22) - replaced obsolete assignLog function
'                                         with logAddLine function
'*******************************************************************************
    
    Option Explicit

    Const MODULE_NAME = "InsertSQL_Statements"
    Const MODULE_VER = "0.4"
    Const MODULE_TITLE = "Insert SQL Statements"
    
    '**************************** CONFIGURE ************************************
    ' the default connection string entered in the input box
    Const DEFAULT_CONN_STR = "" '"Provider=Microsoft.Jet.OLEDB.4.0;User ID=;Password=;Data Source="
    
    ' the variable name used when writing an SQL statement string to the document
    Const VARIABLE_NAME = ""
    '***************************************************************************
    
    Sub Init
        addMenuItem MODULE_TITLE, "ASP", MODULE_NAME, ""
    End Sub

    Sub InsertSQL_Statements()
        
        Const vbCritical = 16
        
        ' ----- ADO constants for VBScript -----
        '---- SchemaEnum Values ----
        Const adSchemaColumns = 4
        Const adSchemaTables  = 20
        '---- FieldAttributeEnum Values ----
        Const adFldIsNullable = &H00000020
        '----------------------------------------
        '---- DataTypeEnum Values ----
		Const adTinyInt          = 16
		Const adSmallInt         = 2
		Const adInteger          = 3
		Const adBigInt           = 20
		Const adUnsignedTinyInt  = 17
		Const adUnsignedSmallInt = 18
		Const adUnsignedInt      = 19
		Const adUnsignedBigInt   = 21
		Const adSingle           = 4
		Const adDouble           = 5
		Const adCurrency         = 6
		Const adDecimal          = 14
		Const adNumeric          = 131
		Const adBoolean          = 11
		Const adVariant          = 12
		Const adGUID             = 72
		Const adDate             = 7
		Const adDBDate           = 133
		Const adDBTime           = 134
		Const adDBTimeStamp      = 135
		Const adChar             = 129
		Const adVarChar          = 200
		Const adLongVarChar      = 201
		Const adWChar            = 130
		Const adVarWChar         = 202
		Const adLongVarWChar     = 203
		Const adBinary           = 128
		Const adVarBinary        = 204
		Const adLongVarBinary    = 205
		Const adFileTime         = 64
        
        Dim objEditor, objConn, objRS, field, objDict
        Dim strConn, strSQL, strInput, strTableName, strPageOutput, strFieldName
        Dim strTableNames, strQueryString, strForm, strDataType, strInsert
		Dim strInsert2, strUpdate, strDelete, strSelect, strFieldNameCaps
		Dim strDim_Str, strDim_Int, strNullable, strArray, strPrefix, strWhere
        Dim strLogOutput, strLogLine, strWhichOutPut, strOptions
        Dim i, intCount, intFieldType, intFieldSize
        Dim blnShowColInfo
        Dim arrLogOutput

        Set objEditor = newEditor()
        
        With objEditor
            .assignActiveEditor()
            strInput = .selText()
        End With
        
        blnShowColInfo = False
        
        If Len(strInput) = 0 Then
            strConn = InputBox("Enter the connection string", MODULE_TITLE, DEFAULT_CONN_STR)
        Else
            strConn = strInput
        End If
        
        If Len(strConn) = 0 Then
            MsgBox "Aborting..." & vbCrLf & vbCrLf & "No connection string entered." &vbTab, vbCritical, MODULE_TITLE
        Else
            
            Set objDict = CreateObject("Scripting.Dictionary")
	        
			With objDict
		        If RegExpTest("(sql server|sqloledb|sql native client|sqlncli|sqlconnection)", strConn) Then
		            .Add "2",   "SmallInt"
		            .Add "3",   "Integer"
		            .Add "4",   "Real"
		            .Add "5",   "Float"
		            .Add "6",   "Money"
		            .Add "7",   "Datetime"
		            .Add "11",  "Bit"
		            .Add "12",  "sql_variant"
		            .Add "14",  "Decimal"
		            .Add "16",  "TinyInt"
		            .Add "17",  "TinyInt"
		            .Add "18",  "UnsignedSmallInt"
		            .Add "19",  "UnsignedInt"
		            .Add "20",  "BigInt"
		            .Add "21",  "UnsignedBigInt"
		            .Add "64",  "FileTime"
		            .Add "72",  "GUID"
		            .Add "128", "Binary"
		            .Add "129", "Char"
		            .Add "130", "nChar"
		            .Add "131", "Numeric"
		            .Add "133", "Smalldatetime"
		            .Add "134", "DBTime"
		            .Add "135", "DBTimeStamp"
		            .Add "200", "VarChar"
		            .Add "201", "LongVarChar"
		            .Add "202", "nVarChar"
		            .Add "203", "nText"
		            .Add "204", "VarBinary"
		            .Add "205", "image"
		        ElseIf RegExpTest("(microsoft access driver|microsoft.jet.oledb)", strConn) Then    
		            .Add "2",   "Number(Integer)"
		            .Add "3",   "Number(Long-Integer)"
		            .Add "4",   "Number(Single)"
		            .Add "5",   "Number(Double)"
		            .Add "6",   "Currency"
		            .Add "7",   "Date/Time"
		            .Add "11",  "Yes/No"
		            .Add "12",  "Variant"
		            .Add "14",  "Decimal/Numeric"
		            .Add "16",  "Number(Byte)"
		            .Add "17",  "Byte"
		            .Add "18",  "UnsignedSmallInt"
		            .Add "19",  "UnsignedInt"
		            .Add "20",  "BigInt"
		            .Add "21",  "UnsignedBigInt"
		            .Add "64",  "FileTime"
		            .Add "72",  "GUID"
		            .Add "128", "Binary"
		            .Add "129", "Char"
		            .Add "130", "Text"
		            .Add "131", "Decimal/Numeric"
		            .Add "133", "Date/Time"
		            .Add "134", "DBTime"
		            .Add "135", "DBTimeStamp"
		            .Add "200", "Text"
		            .Add "201", "LongVarChar"
		            .Add "202", "Text"
		            .Add "203", "Memo"
		            .Add "204", "ReplicationID"
		            .Add "205", "OLEObject"
		        Else
		            .Add "2",   "SmallInt"
		            .Add "3",   "Integer"
		            .Add "4",   "Single"
		            .Add "5",   "Double"
		            .Add "6",   "Currency"
		            .Add "7",   "Date"
		            .Add "11",  "Boolean"
		            .Add "12",  "Variant"
		            .Add "14",  "Decimal"
		            .Add "16",  "TinyInt"
		            .Add "17",  "UnsignedTinyInt"
		            .Add "18",  "UnsignedSmallInt"
		            .Add "19",  "UnsignedInt"
		            .Add "20",  "BigInt"
		            .Add "21",  "UnsignedBigInt"
		            .Add "64",  "FileTime"
		            .Add "72",  "GUID"
		            .Add "128", "Binary"
		            .Add "129", "Char"
		            .Add "130", "WChar"
		            .Add "131", "Numeric"
		            .Add "133", "DBDate"
		            .Add "134", "DBTime"
		            .Add "135", "DBTimeStamp"
		            .Add "200", "VarChar"
		            .Add "201", "LongVarChar"
		            .Add "202", "VarWChar"
		            .Add "203", "LongVarWChar"
		            .Add "204", "VarBinary"
		            .Add "205", "LongVarBinary"
		        End If
			End With 
            
            On Error Resume Next
            
            Set objConn = CreateObject("ADODB.Connection")
                objConn.Open strConn
            
            If Err.Number <> 0 Then
                MsgBox "Aborting..." & vbCrLf & vbCrLf & "Connection Error: " & Err.Description & vbTab, vbCritical, MODULE_TITLE
                Err.Clear
            Else
                
                
                Set objRS = objConn.OpenSchema(adSchemaTables)
                With objRS
                    .Filter = "TABLE_TYPE='TABLE'"
                    Do While Not .EOF
                        strTableNames = strTableNames & objRS.Fields("TABLE_NAME").Value & vbCRLf
                        .MoveNext
                    Loop
                End With
                
                strTableName = InputBox(strTableNames & vbCRLf & "Please enter the table name", MODULE_TITLE, "")
                
                If Len(strTableName) = 0 Then
                    MsgBox "Aborting..." & vbCrLf & vbCrLf & "No table name entered." &vbTab, vbCritical, MODULE_TITLE
                Else
                    
                    strSQL = "SELECT * FROM " & strTableName
                    intCount = 0
                    strQueryString = "With Request" & vbCrLf
                    strForm = "With Request" & vbCrLf
                    strArray = "For i = 0 To UBound(arrRecords,2)" & vbCrLf
                    
                    Set objRS = objConn.Execute(strSQL)
                    
                    If Err.Number <> 0 Then
                         MsgBox "Aborting..." & vbCrLf & vbCrLf & "Execute Error: " & Err.Description & vbTab, vbCritical, MODULE_TITLE
                         Err.Clear
                     Else
                    
                        If NOT objRS.EOF Then 
                            
                            strLogOutput = "Field Name" & vbTab & "Data Type" &_
                            vbTab & "Size" & vbTab & "Nullable" & vbCrLf & vbCrLf
                            
                            For Each field In objRS.Fields
                        
                                strFieldName = Field.Name
                                strFieldNameCaps = CapitaliseFirstLetter(strFieldName)
                                intFieldType = Field.Type
                                
                                Select Case intFieldType
                                    
                                    Case adSmallInt, adInteger, adSingle, adDouble, adDecimal, adNumeric, adBoolean, adTinyInt, adUnsignedTinyInt, adUnsignedSmallInt, adUnsignedInt, adBigInt, adUnsignedBigInt, adGUID
                                        
                                        strPrefix = "int"
                                        strQueryString = strQueryString & vbTab & strPrefix & strFieldNameCaps & vbTab & "= .QueryString(""" & strFieldName & """)" & vbCrLf & ""
                                        strForm = strForm & vbTab & strPrefix & strFieldNameCaps & vbTab & "= .Form(""" & strFieldName & """)" & vbCrLf & ""
                                        strArray = strArray & vbTab & strPrefix & strFieldNameCaps & vbTab & "= arrRecords(" & intCount & ",i)" & vbCrLf & ""
                                        
                                        If intCount = 0 Then
                                            strInsert = "INSERT INTO " & strTableName & " (" & strFieldName
                                            strInsert2 = " VALUES ("" & " & strPrefix & strFieldNameCaps & " & """
                                            strUpdate = "UPDATE " & strTableName & " SET " & strFieldName & " = "" & " & strPrefix & strFieldNameCaps & " & """
                                            strDelete = "DELETE FROM " & strTableName
                                            strSelect = "SELECT " & strFieldName
                                            strDim_Int = strPrefix & strFieldNameCaps
                                            strWhere = " WHERE " & strFieldName & " = "" & " & strPrefix & strFieldNameCaps & " & "";"""
                                        Else
                                            strInsert = strInsert & ", " & strFieldName
                                            strInsert2 = strInsert2 & ", "" & " & strPrefix & strFieldNameCaps & " & """
                                            strUpdate = strUpdate & ", " & strFieldName & " = "" & " & strPrefix & strFieldNameCaps & " & """
                                            strSelect = strSelect & ", " & strFieldName
                                            strDim_Int = strDim_Int & ", " & strPrefix & strFieldNameCaps
                                        End if
                                        
                                        intCount = intCount + 1
                                    
                                    Case adVarChar, adLongVarChar, adVarWChar, adLongVarWChar, adChar, adWChar, adVariant
                                        
                                        strPrefix = "str"
                                        strQueryString = strQueryString & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.QueryString(""" & strFieldName & """))" & vbCrLf & ""
                                        strForm = strForm & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.Form(""" & strFieldName & """))" & vbCrLf & ""
                                        strArray = strArray & vbTab & strPrefix & strFieldNameCaps & vbTab & "= arrRecords(" & intCount & ",i)" & vbCrLf & ""
                                        
                                        If intCount = 0 Then
                                            strInsert = "INSERT INTO " & strTableName & " (" & strFieldName
                                            strInsert2 = " VALUES ('"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = "UPDATE " & strTableName & " SET " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strDelete = "DELETE FROM " & strTableName
                                            strDim_Str = strPrefix & strFieldNameCaps
                                            strWhere = " WHERE " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""';"""
                                        Else
                                            strInsert = strInsert & ", " & strFieldName
                                            strInsert2 = strInsert2 & ", '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = strUpdate & ", " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strSelect = strSelect & ", " & strFieldName
                                            strDim_Str = strDim_Str & ", " & strPrefix & strFieldNameCaps
                                        End if
                                        
                                        intCount = intCount + 1
                                    Case adDate, adDBDate, adDBTime, adDBTimeStamp
                                        
                                        strPrefix = "dat"
                                        strQueryString = strQueryString & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.QueryString(""" & strFieldName & """))" & vbCrLf & ""
                                        strForm = strForm & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.Form(""" & strFieldName & """))" & vbCrLf & ""
                                        strArray = strArray & vbTab & strPrefix & strFieldNameCaps & vbTab & "= arrRecords(" & intCount & ",i)" & vbCrLf & ""
                                        
                                        If intCount = 0 Then
                                            strInsert = "INSERT INTO " & strTableName & " (" & strFieldName
                                            strInsert2 = " VALUES ('"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = "UPDATE " & strTableName & " SET " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strDelete = "DELETE FROM " & strTableName
                                            strDim_Str = strPrefix & strFieldNameCaps
                                            strWhere = " WHERE " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""';"""
                                        Else
                                            strInsert = strInsert & ", " & strFieldName
                                            strInsert2 = strInsert2 & ", '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = strUpdate & ", " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strSelect = strSelect & ", " & strFieldName
                                            strDim_Str = strDim_Str & ", " & strPrefix & strFieldNameCaps
                                        End if
                                        
                                        intCount = intCount + 1
                                        
                                    Case adCurrency
                                        
                                        strPrefix = "cur"
                                        strQueryString = strQueryString & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.QueryString(""" & strFieldName & """))" & vbCrLf & ""
                                        strForm = strForm & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.Form(""" & strFieldName & """))" & vbCrLf & ""
                                        strArray = strArray & vbTab & strPrefix & strFieldNameCaps & vbTab & "= arrRecords(" & intCount & ",i)" & vbCrLf & ""
                                        
                                        If intCount = 0 Then
                                            strInsert = "INSERT INTO " & strTableName & " (" & strFieldName
                                            strInsert2 = " VALUES ('"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = "UPDATE " & strTableName & " SET " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strDelete = "DELETE FROM " & strTableName
                                            strDim_Str = strPrefix & strFieldNameCaps
                                            strWhere = " WHERE " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""';"""
                                        Else
                                            strInsert = strInsert & ", " & strFieldName
                                            strInsert2 = strInsert2 & ", '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = strUpdate & ", " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strSelect = strSelect & ", " & strFieldName
                                            strDim_Str = strDim_Str & ", " & strPrefix & strFieldNameCaps
                                        End if
                                        
                                        intCount = intCount + 1
                                    
									Case Else
                                        
                                        strPrefix = ""
                                        strQueryString = strQueryString & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.QueryString(""" & strFieldName & """))" & vbCrLf & ""
                                        strForm = strForm & vbTab & strPrefix & strFieldNameCaps & vbTab & "= CleanString(.Form(""" & strFieldName & """))" & vbCrLf & ""
                                        strArray = strArray & vbTab & strPrefix & strFieldNameCaps & vbTab & "= arrRecords(" & intCount & ",i)" & vbCrLf & ""
                                        
                                        If intCount = 0 Then
                                            strInsert = "INSERT INTO " & strTableName & " (" & strFieldName
                                            strInsert2 = " VALUES ('"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = "UPDATE " & strTableName & " SET " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strDelete = "DELETE FROM " & strTableName
                                            strDim_Str = strPrefix & strFieldNameCaps
                                            strWhere = " WHERE " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""';"""
                                        Else
                                            strInsert = strInsert & ", " & strFieldName
                                            strInsert2 = strInsert2 & ", '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strUpdate = strUpdate & ", " & strFieldName & " = '"" & " & strPrefix & strFieldNameCaps & " & ""'"
                                            strSelect = strSelect & ", " & strFieldName
                                            strDim_Str = strDim_Str & ", " & strPrefix & strFieldNameCaps
                                        End if
                                        
                                        intCount = intCount + 1
                                        
                                End Select
                                
                                If (Field.Attributes AND adFldIsNullable) = adFldIsNullable Then
                                    strNullable = "Yes"
                                Else
                                    strNullable = "No"
                                End if
                            
                                intFieldSize = field.DefinedSize
								strDataType = objDict.Item(CStr(intFieldType)) 
                                
                                If Err.Number <> 0 Then
									strDataType = "Unkown"
								End If
                                
                                strLogOutput = strLogOutput & strFieldName & vbTab &_
                                strDataType & vbTab & intFieldSize & vbTab & strNullable & vbCrLf
                                
                            Next
                            
                            strInsert = strInsert & ")"
                            strInsert2 = strInsert2 & ")"
                            strUpdate = strUpdate & strWhere
                            strDelete = strDelete & strWhere
                            strSelect = strSelect & " FROM " & strTableName & strWhere
                            strQueryString = AlignColumns(strQueryString) & "End With"
                            strForm = AlignColumns(strForm) & "End With" 
                            
                            If Left(strDim_Str,1) = "," Then strDim_Str = Mid(strDim_Str,3) End if
                            If Left(strDim_Int,1) = "," Then strDim_Int = Mid(strDim_Int,3) End if
                            
                            
                            strOptions = vbCrLf & vbCrLf &_
                            "SELECT STATEMENT:" & vbTab & vbTab & "S" & vbCrLf &_
                            "INSERT STATEMENT:" & vbTab & vbTab & "I" & vbCrLf &_
                            "UPDATE STATEMENT:" & vbTab & vbTab & "U" & vbCrLf &_
                            "DELETE STATEMENT:" & vbTab & vbTab & "D" & vbCrLf &_
                            "GETROWS ARRAY LOOP:" & vbTab & "A" & vbCrLf &_
                            "REQUEST QUERYSTRING:" & vbTab & "Q" & vbCrLf &_ 
                            "REQUEST FORM:" & vbTab & vbTab & "F" & vbCrLf &_
                            "DIM VARIABLES:" & vbTab & vbTab & "DIM" & vbCrLf & vbCrLf &_
                            "(leave the option blank in order to insert all code blocks)" & vbCrLf & vbCrLf &_
                            "(include x after the option in order to display the table's column info in the log window)" & vbCrLf
                            
                            strWhichOutPut = InputBox("Which code block do you want" & strOptions, MODULE_TITLE, "S")
                            
                            If Right(strWhichOutPut,1) = "x" Then
                                strWhichOutPut = Left(strWhichOutPut, Len(strWhichOutPut)-1)
                                blnShowColInfo = True
                            End If
                            
                            Select Case UCase(strWhichOutPut)
                                Case "S"    ' SELECT STATEMENT
                                    strPageOutput = VARIABLE_NAME & " = """ & strSelect
                                Case "A"    ' GETROWS ARRAY LOOP
                                    strPageOutput = AlignColumns(strArray)  & "Next"
                                Case "I"    ' INSERT STATEMENT
                                    strPageOutput = VARIABLE_NAME & " = """ & strInsert & " " & strInsert2 & ";"""
                                Case "U"    ' UPDATE STATEMENT
                                    strPageOutput = VARIABLE_NAME & " = """ & strUpdate
                                Case "D"    ' DIM VARIABLES
                                    strPageOutput = VARIABLE_NAME & " = """ & strDelete
                                Case "DIM"    ' DELETE STATEMENT
                                    strPageOutput = "Dim " & strDim_Str & vbCrLf & "Dim " & strDim_Int
                                Case "Q"    ' REQUEST QUERYSTRING
                                    strPageOutput = strQueryString
                                Case "F"    ' REQUEST FORM
                                    strPageOutput = strForm
                                Case Else    ' 
                                    strPageOutput = "' REQUEST QUERYSTRING" & vbCrLf & vbCrLf & "Dim " & strDim_Str & vbCrLf & "Dim " & strDim_Int & vbCrLf & vbCrLf & strQueryString & vbCrLf & vbCrLf & vbCrLf &_
                                    "' REQUEST FORM" & vbCrLf & vbCrLf & "Dim " & strDim_Str & vbCrLf & "Dim " & strDim_Int & vbCrLf & vbCrLf & strForm & vbCrLf & vbCrLf & vbCrLf &_
                                    "' INSERT STATEMENT" & vbCrLf & vbCrLf & VARIABLE_NAME & " = """ & strInsert & " " & strInsert2 & ";""" & vbCrLf & vbCrLf & vbCrLf &_
                                    "' UPDATE STATEMENT" & vbCrLf & vbCrLf & VARIABLE_NAME & " = """ & strUpdate & vbCrLf & vbCrLf & vbCrLf &_
                                    "' DELETE STATEMENT" & vbCrLf & vbCrLf & VARIABLE_NAME & " = """ & strDelete & vbCrLf & vbCrLf & vbCrLf &_
                                    "' SELECT STATEMENT" & vbCrLf & vbCrLf & VARIABLE_NAME & " = """ & strSelect & vbCrLf & vbCrLf & AlignColumns(strArray)  & "Next"    
                            End Select
                            
                            If blnShowColInfo AND Len(strLogOutput) Then    
                                
                                strLogOutput = AlignColumns(strLogOutput)
                                arrLogOutput = Split(strLogOutput, vbCrLf)
                                logClear
                                
                                For i = 0 To UBound(arrLogOutput)
                                    strLogLine = arrLogOutput(i)
                                    logAddLine(strLogLine)
                                Next
                                    
                            End If
                            
                            objEditor.selText(strPageOutput)
                                        
                        End If    ' NOT objRS.EOF
                        
                        objRS.Close
                                        
                    End If    ' Err.Number <> 0 (Execute)
                    
                    Set objRS = nothing 
                
                End If    ' Len(strTableName) = 0
                
                objConn.Close
                    
            End if    ' Err.Number <> 0 (Connection)
            
            Set objConn = nothing
            Set objDict = nothing
            
        End if    ' Len(strConn) = 0
        
        Set objEditor = nothing
        
    End Sub
    
    Function CapitaliseFirstLetter(str)
        CapitaliseFirstLetter = UCase(Mid(str,1, 1)) & Mid(str,2, Len(str))
    End Function
    
    ' an adaption of Scott Greenberg's procedure
    Function AlignColumns(str)
        Dim Columns(100)
        Dim i, lines, regSearch, Matches, Match
        Dim Column, Length, Line, newLine
        Dim foundstr, extrastr, Spaces
        
        ' Get lines
        lines = Split(str, vbCrLf)

        Set regSearch = New RegExp
        
        With regSearch
            .Global     = True
            .IgnoreCase = True
            .Pattern    = "([^" & vbTab & "]*)(\s*)" & vbTab
        End With

        ' Get all column's max width
        For Each Line in lines
            Set Matches = regSearch.Execute(Line)
            ' Initialize column index
            Column = 0
            For Each Match in Matches
                Length = Len(Match.SubMatches(0))
                If Length > Columns(Column) Then
                    Columns(Column) = Length
                End If
                Column = Column + 1
            Next
        Next

        ' Initialize line index
        i = -1

        ' Added spacing
        For Each Line in lines
            Column = 0
            newLine = ""
            i = i + 1
            
            Set Matches = regSearch.Execute(Line)

            ' Sum matches and remove from orignal line
            ' Match should catch everything before Tab
            foundstr = ""
            
            For Each Match in Matches
                foundstr = foundstr & Match.SubMatches(0) & Match.SubMatches(1) & vbTab
            Next
            
            extrastr = Replace(Line, foundstr, "")
            
            For Each Match in Matches
                Spaces  = Columns(Column) - Len(Match.SubMatches(0))
                newLine = newLine & Match.SubMatches(0) & String(Spaces, " ") & vbTab
                Column  = Column + 1
            Next
            
            If Len(newLine) Then
                lines(i) = newLine & extrastr
            End If
            
        Next

        AlignColumns = Join(lines, vbCrLf)
    End Function
    
    Function RegExpTest(patrn, str)
        Dim objRegEx
        
        Set objRegEx = New RegExp
        
        With objRegEx
            .Pattern = patrn
            .IgnoreCase = False
            RegExpTest = .Test(str)
        End With
        
        Set objRegEx = Nothing
    End Function