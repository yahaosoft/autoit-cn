; ------------------------------------------------------------------------------
; Function List:
;               _accessCreateDB()
;               _accessCreateTable()
;               _accessDeleteTable()
;               _accessListTables()
;               _accessCountTables()
;               _accessAddRecord()
;               _accessUpdateRecord()
;               _accessDeleteRecord()
;               _accessClearTable()
;               _accessCountRecords()
;               _accessCountFields()
;               _accessListFields()
;               _accessQueryLike()
;               _accessQueryStr()
; To Do List:
;               _accessAppendField()
;               _accessDeleteMulti()
;               _accessNumSearch()
; ------------------------------------------------------------------------------
#include-once
Global Const $adoProvider = 'Microsoft.Jet.OLEDB.4.0; '
Global Const $adOpenDynamic = 2
Global Const $adOpenStatic = 3
Global Const $adLockReadOnly =1
Global Const $adLockPessimistic = 2
Global Const $adLockOptimistic = 3
Global Const $adLockBatchOptimistic = 4
Global Const $adPersistXML = 1
Global Const $adUseClient = 3
Global Const $adSchemaTables = 20
Global Const $adVarChar = 200
Global Const $MaxCharacters = 255


;===============================================================================
; Function Name:        _accessCreateDB ()
; Description:            Create a MS Access database (*.mdb) file
; Syntax:                 _accessCreateDB ($adSource)
; Parameter(s):           $adSource  - The full path/filename of the database to be created
; Requirement(s):         
; Return Value(s):        
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessCreateDB ($adSource)
   If StringRight($adSource, 4) <> '.mdb' Then $adSource &= '.mdb'
   If FileExists($adSource) Then
      Local $Fe = MsgBox ( 262196, 'File Exists', 'The file ' & $adSource & ' already exists.' & @CRLF & '' & @CRLF & 'Do you want to replace the existing file?')
      If $Fe = 6 Then
         FileDelete($adSource)
      Else
         Return
      EndIf
   EndIf
   $dbObj = ObjCreate('ADOX.Catalog')
   If IsObj($dbObj) Then
      $dbObj.Create ('Provider = ' & $adoProvider & 'Data Source = ' & $adSource)
   Else
      MsgBox ( 262160, 'Error', 'Unable to create the requested object')
   EndIf
EndFunc    ;<===> _accessCreateDB ()

;===============================================================================
; Function Name:        _accessCreateTable()
; Description:            Create a table in an existing MS Access database
; Syntax:                 _accessCreateTable($adSource, $adTable, $adCol)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - The name of the table to create
;                               $adCol - An array (or a '|' separated list) of column header names and field types (see notes)
; Requirement(s):         
; Return Value(s):        Success - Creates the table and sets @error = 0
;                               Failure - Sets @error 1 -Table already exists
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               3 = table already exists
; Author(s):              GEOSoft
; Note(s):                The field type is not case sensitive. I use upper for clarity.
;                               Current types that work are; TEXT, MEMO, COUNTER, INTEGER, YESNO, DATETIME, CURRENCY and OLEOBJECT
;                               The header name can NOT include spaces but must be separated from the field type with a space
;                               To set a maximum number of characters in a TEXT field use (<number>) as shown in the second example
;                               TEXT (0) will set the field to the maximum allowable (255 characters). In the second example Category1 is 50 characters
;                               and Category4 is 255 characters.
; Modification(s):        
; Example(s):             _accessCreateTable($adSource,$adTable,$aArray)
;===============================================================================

Func _accessCreateTable($adSource, $adTable, $adCol = '')
   Local $F_Out = ''
   If StringInStr(_accessListTables($adSource), $adTable & '|') Then Return SetError(3,0,0)
   If $adCol <> '' Then
      If NOT IsArray($adCol) Then
         $adCol = StringSplit($adCol,'|')
      EndIf
      For $I = 1 To $adCol[0]
         If $I <> $adCol[0] Then $adCol[$I] = $adCol[$I] & ' ,'
         $F_Out &= $adCol[$I]
      Next
   EndIf
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   If $F_Out <> '' Then
      $oADO.Execute ("CREATE TABLE " & $adTable & '(' & $F_Out & ')');;<<=== Create the table and the columns specified by $adCol
   Else
      $oADO.Execute ("CREATE TABLE " & $adTable);;  <<==== No columns were specified so just create an empty table
   EndIf
   $oADO.Close()
EndFunc    ;<===> _accessCreateTable()

;===============================================================================
; Function Name:        _accessListTables()
; Description:            List the tables in an MSAccess (*.mdb) file
; Syntax:                 adoListTables ($adSource)
; Parameter(s):           $adSource  - The full path/filename of the database to be listed
; Requirement(s):         
; Return Value(s):        Success - Returns a "|" delimited string of table names
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               3 = no matching tables located (returns a blankString)
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessListTables($adSource)
   Local $oList = ''
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = $oADO.OpenSchema($adSchemaTables)
   While NOT $oRec.EOF
      If StringLen( $oRec("TABLE_TYPE").value) > 5 Then;; Skip the hidden internal tables
         $oRec.movenext
         ContinueLoop
      EndIf
      $oList = $oList & $oRec("TABLE_NAME").value & '|'
      $oRec.movenext
   Wend
   If $oList <> '' Then
      $oADO.close
      Return '|' & StringTrimRight($oList,1)
   Else
      SetError(3, 0, 0)
      $oADO.close
      Return $oList
   EndIf
EndFunc    ;<===> _accessListTables()

;===============================================================================
; Function Name:        _accessClearTable()
; Description:            Clear all records in an MS Access database table
; Syntax:                 _accessClearTable($adSource, $adTable)
; Parameter(s):           $adSource  - The full path/filename of the database to be accessed
;                               $adTable - the name of the table to clear
; Requirement(s):         
; Return Value(s):        Sucess - all records are removed from table
;                               Failure - Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                This will only clear the records, not remove the table (see _accessDeleteTable())
; Modification(s):
;===============================================================================

Func _accessClearTable($adSource, $adTable)
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   If _accessCountRecords($adSource, $adTable) > 0 Then
      $oRec.CursorLocation = $adUseClient
      $oRec.Open ("Delete * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
   EndIf
   $oADO.Close()
EndFunc    ;<===> _accessClearTable()

;===============================================================================
; Function Name:        _accessDeleteTable()
; Description:            Delete a table from an MSAccess (*.mdb) file
; Syntax:                 _accessDeleteTable($adSource, $adTable)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to be deleted
; Requirement(s):         
; Return Value(s):        Success - Deletes the table and returns 0
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessDeleteTable($adSource, $adTable)
   $oADO = ObjCreate("ADODB.Connection")
   $oADO.Provider = $adoProvider
   $oADO.Open ($adSource)
   $oADO.execute ("DROP TABLE " & $adTable)
   $oADO.Close
EndFunc    ;<===> _accessDeleteTable()

;===============================================================================
; Function Name:        _accessTableCount()
; Description:            Count the tables in an MSAccess (*.mdb) file
; Syntax:                 _accessTableCount($adSource)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
; Requirement(s):         
; Return Value(s):        Success - returns the number of tables
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):        
; Example(s):             MsgBox(4096, 'Tables', 'There are ' & _accessTableCount("C:\My_Database.mdb") & ' tables in the database')
;===============================================================================

Func _accessTableCount($adSource)
   $T_Count = StringSplit(_accessListTables($adSource), '|')
   Return $T_Count[0]
EndFunc    ;<===> _accessTableCount()

;===============================================================================
; Function Name:        _accessSaveXML()
; Description:            Save a table in an MS Access (*.mdb) file as an *.XML File
; Syntax:                 _accessSaveXML($adSource, $adTable[,$oFile])
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to save as XML
;                               $oFile - the path & filename of the XML File (default is the table name with .xml added)
; Requirement(s):         
; Return Value(s):        
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessSaveXML($adSource,$adTable, $oFile = '')
   If $oFile = '' Then $oFile = StringLeft($adSource, StringInStr($adSource,'\',0,-1)) & $adTable & '.xml'
   If Not StringInStr($oFile, '\') Then $oFile = StringLeft($adSource, StringInStr($adSource,'\',0,-1)) & $oFile
   If StringRight($oFile, 4) <> '.xml' Then $oFile &= '.xml'
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset()
   $oRec.Open ("SELECT * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
   $oRec.MoveFirst ()
   $oRec.Save ($oFile, $adPersistXML)
   $oRec.Close()
   $oADO.Close()
EndFunc

;===============================================================================
; Function Name:        _accessAddRecord()
; Description:            Add a new record (single or multiple fields) in an existing MS Access database table
; Syntax:                 _accessAddRecord($adSource, $adTable)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to add the record to
;                               $rData - Data to be added to field (to add data to multiple fields this must be an array) see notes
;                               $adCol - the name or 0 based index of the field to add the data to when $rData is not an array (default is first field)
; Requirement(s):         
; Return Value(s):        Success - @Error = 0 and record is added to table
;                               Failure - Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessAddRecord($adSource, $adTable, $rData,$adCol = 0)
   If NOT IsArray($rData) Then
      $rData = StringSplit($rData,'|')
   EndIf
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   If Not IsObj($oADO) Then Return SetError(2, 0, 0)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   With $oRec
      .Open ("SELECT * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
      .AddNew
      If IsArray($rData) Then
         For $I = 1 To Ubound($rData) -1;$rData[0]
            $rData[$I] = StringStripWs($rData[$I],1)
            .Fields.Item($I -1) = $rData[$I]
         Next
      Else
         .Fields.Item($adCol) = $rData
      EndIf
      .Update
      .Close
   EndWith
   $oADO.Close()
EndFunc    ;<===> _accessAddRecord()

;===============================================================================
; Function Name:        _accessUpdateRecord()
; Description:            Searches for a record in an MS Access database table and updates that record with new data
; Syntax:                 _accessUpdateRecord($adSource,$adTable,$adCol,$adQuery,$adcCol,$adData)
; Parameter(s):           $adSource  - The full path/filename of the database to be accessed
;                               $adTable - the name of the table to update
;                               $adCol - The field (column) to search
;                               $adQuery - the string to find
;                               $adcCol - The field to update
;                               $adData - the new string to be placed in $adcCol
; Requirement(s):         
; Return Value(s):        Success - Updates the field
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
;                               3 = unable to open the record for updating
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessUpdateRecord($adSource,$adTable,$adCol,$adQuery,$adcCol,$adData)
   $adQuery = Chr(39) & $adQuery & Chr(39)
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   $oRec.CursorLocation = $adUseClient
   $oRec.Open ("SELECT * FROM " & $adTable, $oADO,  $adOpenStatic, $adLockOptimistic)
   If @Error = 0 Then
      $strSearch = $adCol & ' = ' & $adQuery
      $oRec.Find ($strSearch)
      $oRec($adcCol) = $adData
      $oRec.Update
      $oRec.Close()
   Else
      $aADO.Close()
      Return SetError(3,0,0)
   EndIf
   $oADO.Close()
EndFunc    ;<===> _accessUpdateRecord()

;===============================================================================
; Function Name:        _accessDeleteRecord()
; Description:            Searches a database for all records where the specified field contains a specified string
; Syntax:                 adoDeleteRecord($adSource,$adTable, $adCol,$Find,[$adOcc])
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to search
;                               $adCol - The name of the field to search (DO NOT use the index number)
;                               $Find - The string to locate
;                               $adOcc - If = 1 Delete the first matching record (Default)
;                               If <> 1 Delete all matching records
; Requirement(s):         _accessCountFields()
; Return Value(s):        Success - Record(s) deleted from table
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
;                               ; Author(s):        GEOSoft
; Author(s):              
; Note(s):                Chr(28) is a non-printable character and is used to avoid a clash with characters that may be found in the string
; Modification(s):
;===============================================================================

Func _accessDeleteRecord($adSource,$adTable, $adCol,$Find,$adOcc = 1)
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   $Search = $adCol & " = '" & $Find & Chr(39)
   With $oRec
      .CursorLocation = $adUseClient
      If $adOcc = 1 Then
         .Open ("SELECT * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
         .find($Search)
         .Delete()
         .close
      Else
         .Open("DELETE * FROM " & $adTable & " WHERE " & $adCol & " = '" & $Find & Chr(39), $oADO, $adOpenStatic, $adLockOptimistic)
      EndIf
   EndWith
   $oADO.Close()
EndFunc    ;<===> _accessDeleteRecord()

;===============================================================================
; Function Name:        _accessCountRecords()
; Description:            Count the records in an MS Access database table
; Syntax:                 _accessCountRecords($adSource, $adTable)
; Parameter(s):           $adSource  - The full path/filename of the database to be accessed
;                               $adTable - the name of the table to count
; Requirement(s):         
; Return Value(s):        The number of records in the table
;                               Failure - Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                Typical usage would be :
; Modification(s):
;===============================================================================

Func _accessCountRecords($adSource, $adTable)
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   $oRec.open ("SELECT * FROM " & $adTable , $oADO, $adOpenStatic, $adLockOptimistic)
   If $oRec.recordcount <> 0 Then $oRec.MoveFirst
   $Rc = $oRec.recordcount
   $oRec.Close
   $oADO.Close
   Return $Rc
EndFunc    ;<===> _accessCountRecords()

;===============================================================================
; Function Name:        _accessCountFields()
; Description:            Count the fields in an MS Access database table
; Syntax:                 _accessCountFields($adSource, $adTable)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to count
; Requirement(s):         
; Return Value(s):        The number of fields in the table
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                Typical usage would be:
;                               MsgBox(0,'Number of fields', 'There are ' & _accessCountFields($adSource, $adTable) & ' fields in this table')
; Modification(s):
;===============================================================================

Func _accessCountFields($adSource,$adTable)
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   $oRec.open ($adTable , $oADO, $adOpenStatic, $adLockOptimistic)
   $Fc = $oRec.fields.count
   $oRec.Close
   $oADO.Close
   Return $Fc
EndFunc    ;<===> _accessCountFields()

;===============================================================================
; Function Name:        _accessListFields()
; Description:            List the names of fields in an MS Access database table
; Syntax:                 adoColNames($adSource, $adTable)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to check
; Requirement(s):         
; Return Value(s):        Success - A "|" delimited list of the field names.
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessListFields($adSource,$adTable)
   Local $Rtn = ''
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   ;With $oRec
      $oRec.Open ($adTable , $oADO, $adOpenStatic, $adLockOptimistic)
      $Fc = $oRec.fields.count
      If $Fc > 0 Then
         For $I = 0 to $Fc-1
            $Rtn &= $oRec.fields($I).name & '|'
         Next
      EndIf
      $oRec.Close
   ;EndWith
   $oADO.Close
   If $Rtn Then
      Return StringTrimRight($Rtn, 1)
   EndIf
EndFunc    ;<===> _accessListFields()

;===============================================================================
; Function Name:        _accessQueryLike()
; Description:            Searches a database for all records where the specified field contains a specified string
; Syntax:                 _accessQueryLike($adSource,$adTable, $adCol,$Find, [$adFull])
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to search
;                               $adCol - The name of the field to search (DO NOT use the index number)
;                               $Find - The string to locate
;                               $adFull - If = 1 Returns an array containing a Chr(28) delimited list of the records field values. (Default)
;                               If <> 1 Returns an array of the specified field values for each record.
; Requirement(s):         _accessCountFields()
; Return Value(s):        Success - An Array containing a Chr(28) delimited list of the records field values.(Default --- see $adFull above)
;                               Failure Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                Chr(28) is a non-printable character and is used to avoid a clash with characters that may be found in the string
; Modification(s):
;===============================================================================

Func _accessQueryLike($adSource,$adTable, $adCol,$Find, $adFull = 1)
   Local $I, $Rtn
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   $oRec.Open ("SELECT * FROM "& $adTable & " WHERE " & $adCol & " Like '%" & $Find & "%'", $oADO, $adOpenStatic, $adLockOptimistic)
   If $oRec.RecordCount < 1 Then
      Return SetError(1)
   Else
      SetError(0)
      $oRec.MoveFirst()
      ;;MsgBox(0,'TEST', "Number of records: " & $oRec.RecordCount);;<<======  For testing only
      Do
         If $adFull = 1 Then
            For $I = 0 To _accessCountFields($adSource,$adTable)-1
               ;;MsgBox(0,'TEST 2 ', "Value of field " & $oRec.Fields($I).Name & ' is:' & @CRLF & @CRLF & $oRec.Fields($I).Value);;<<======  For testing only
               $Rtn = $Rtn & $oRec.Fields($I).Value & Chr(28);;<<====== Separate the fields with a non-printable character
            Next
         EndIf
         $Rtn = $Rtn & Chr(29);;<<====== Separate the records with a non-printable character
         $oRec.MoveNext()
      Until $oRec.EOF
      $oRec.Close()
      $oADO.Close()
      If $adFull = 1 Then Return StringSplit(StringTrimRight($Rtn, 2),Chr(29))
      Return StringSplit(StringTrimRight($Rtn, 1),Chr(29))
   EndIf
EndFunc    ;<===> _accessQueryLike()

;===============================================================================
; Function Name:        _accessQueryStr()
; Description:            Searches a database for the first record  that matches a specified string
; Syntax:                 _accessQueryStr($adSource,$adTable, $adCol,$Find)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to search
;                               $adCol - The name of the field to search (DO NOT use the index number)
;                               $Find - The string to locate
; Requirement(s):         
; Return Value(s):        Success - Returns the value of the specified field
;                               Failure Returns a Blank String and Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessQueryStr($adSource,$adTable, $adCol,$Find)
   $Find = Chr(34) & String($Find) & Chr(34)
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset();ObjCreate("ADODB.Recordset")
   If IsObj($oRec) = 0 Then Return SetError(2)
   $oRec.Open ("SELECT * FROM " & $adTable & " Where " & $adCol & " = " & $Find , $oADO, $adOpenStatic, $adLockOptimistic)
   If $oRec.RecordCount > 0 Then
      $oRec.MoveFirst()
      Return $oRec.Fields($adCol).Value
   EndIf
   Return ''
EndFunc   ;<==> _accessQueryStr($adSource,$adTable, $adCol,$Find)

;===============================================================================
; Function Name:        _accessGetVal()
; Description:            Searches a database for the first record  that matches a specified string
; Syntax:                 _accessGetVal($adSource,$adTable, $adCol)
; Parameter(s):           $adSource  - The full path/filename of the database to be opened
;                               $adTable - the name of the table to search
;                               $adCol - The name or 0 based index of the field to search
; Requirement(s):         
; Return Value(s):        Success - Returns the value of the specified field
;                               Failure Returns a Blank String and Sets @Error
;                               1 = unable to create connection
;                               2 = unable to create recordset
; Author(s):              GEOSoft
; Note(s):                
; Modification(s):
;===============================================================================

Func _accessGetVal($adSource,$adTable, $adCol)
   Local $Val
   $oADO = 'ADODB.Connection'
   If IsObj($oADO) Then
      $oADO = ObjGet('',$oADO)
   Else
      $oADO = _accessOpen($adSource)
   EndIf
   If IsObj($oADO) = 0 Then Return SetError(1)
   $oRec = _accessOpenRecordset()
   If IsObj($oRec) = 0 Then Return SetError(2)
   $oRec.Open ("SELECT * FROM " & $adTable, $oADO, $adOpenStatic, $adLockOptimistic)
   $Val = $oRec.Fields($adCol).Value
   $oRec.Close
   $oADO.Close()
   Return $Val
EndFunc

;; Undocumented
;; The following are from 2tim3_16.  I'll add the headers later


;;_adoSQLSelect for Select queries

Func _adoSQLSelect($adSource, $adTable, $adCol, $adCriteria, $adFull = 1)
    Local $I, $Rtn
    $oADO = 'ADODB.Connection'
    If IsObj($oADO) Then
        $oADO = ObjGet('',$oADO)
    Else
        $oADO = _adoOpen($adSource)
    EndIf
    If IsObj($oADO) = 0 Then Return SetError(1)
    $oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
    If IsObj($oRec) = 0 Then Return SetError(2)
    
    If $adCriteria = "" Then
        $adSQL = "SELECT " & $adCol & " FROM " & $adTable
    Else
        $adSQL = "SELECT " & $adCol & " FROM " & $adTable & " WHERE " & $adCriteria
    EndIf
    
    $oRec.Open ($adSQL, $oADO, $adOpenStatic, $adLockOptimistic)
    If $oRec.RecordCount < 1 Then
        Return SetError(1)
    Else
        SetError(0)
        $oRec.MoveFirst()
        Do
            If $adFull = 1 Then
                
                For $I = 0 To _adoCountFields($adSource,$adTable)-1
                    $Rtn = $Rtn & $oRec.Fields($I).Value & Chr(28);;<<====== Separate the fields with a non-printable character
                Next
                
            EndIf
            $Rtn = $Rtn & Chr(29);;<<====== Separate the records with a non-printable character
            $oRec.MoveNext()
        Until $oRec.EOF
        
        $oRec.Close()
        $oADO.Close()
        If $adFull = 1 Then Return StringSplit(StringTrimRight($Rtn, 2),Chr(29))
        Return StringSplit(StringTrimRight($Rtn, 1),Chr(29))
    EndIf
EndFunc   ;<===> _adoSQLSelect()


;;_adoExecuteSQL for Make Table, Append, Update, or Delete queries

Func _adoExecuteSQL($adSource,$adSQL)
    $oADO = 'ADODB.Connection'
    If IsObj($oADO) Then
        $oADO = ObjGet('',$oADO)
    Else
        $oADO = _adoOpen($adSource)
    EndIf
    If IsObj($oADO) = 0 Then Return SetError(1)
    $oRec = _adoOpenRecordset();ObjCreate("ADODB.Recordset")
    If IsObj($oRec) = 0 Then Return SetError(2)
    
    $oRec.CursorLocation = $adUseClient
    $oRec.Open ($adSQL, $oADO,  $adOpenStatic, $adLockOptimistic)
    
    If @Error = 0 Then
    Else
        $oADO.Close()
        Return SetError(3,0,0)
    EndIf
    $oADO.Close()
EndFunc   ;<===> _adoExecuteSQL()

;Private Functions
Func _accessOpen($adSource)
   $oADO = ObjCreate("ADODB.Connection")
   $oADO.Provider = $adoProvider
   $oADO.Open ($adSource)
   Return $oADO
EndFunc    ;<===> _accessOpen()

Func _accessOpenRecordset()
   $oRec = ObjCreate("ADODB.Recordset")
   Return $oRec
EndFunc    ;<===> _accessOpenRecordset()