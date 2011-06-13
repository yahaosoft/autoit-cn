#include <SQLite.au3>
#include <SQLite.dll.au3>

_SQLite_Startup()
ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
_SQLite_SafeMode(False)
_SQLite_Exec(-1, "CREATE tblTest (a,b,c);"); 没有打开数据库, 由于 SafeMode = false 所以这里将使脚本崩溃
_SQLite_Shutdown()
