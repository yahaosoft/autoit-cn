#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <File.au3>

_SQLite_Startup()
ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)

Local $sDatabase, $hDB_a, $hDB_b, $iTimer, $iRval
$sDatabase = _TempFile()
$hDB_a = _SQLite_Open($sDatabase)
$hDB_b = _SQLite_Open($sDatabase)

_SQLite_Exec($hDB_a, "BEGIN EXCLUSIVE;")
_SQLite_Exec($hDB_a, "CREATE TABLE test (a,b,c);")
_SQLite_Exec($hDB_a, "INSERT INTO test VALUES (1,2,3);")
; 'test' 现在正忙...

_SQLite_SetTimeout($hDB_b, 0)
$iTimer = TimerInit()
$iRval = _SQLite_Exec($hDB_b, "SELECT * FROM test") ; 此操作将失败
MsgBox(4096, "_SQLite_SetTimeout Example No Timeout", "Time: " & TimerDiff($iTimer) & @CRLF _
		 & "Error: " & _SQLite_ErrMsg($hDB_b) & @CRLF)
_SQLite_SetTimeout($hDB_b, 5000)
$iTimer = TimerInit()
$iRval = _SQLite_Exec($hDB_b, "SELECT * FROM test") ; 此操作将失败
MsgBox(4096, "_SQLite_SetTimeout Example 5 Sec Timeout", "Time: " & TimerDiff($iTimer) & @CRLF _
		 & "Error: " & _SQLite_ErrMsg($hDB_b) & @CRLF)
_SQLite_Exec($hDB_a, "END;")
_SQLite_Close($hDB_a)
_SQLite_Close($hDB_b)
_SQLite_Shutdown()
FileDelete($sDatabase)
