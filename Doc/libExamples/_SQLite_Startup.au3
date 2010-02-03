#include <SQLite.au3>
#include <SQLite.dll.au3>

Local $sSQliteDll
$sSQliteDll = _SQLite_Startup ()
If @error Then
    MsgBox(16, "错误", "SQLite.dll加载失败!")
    Exit - 1
EndIf
ConsoleWrite("SQLite_LibVersion=" &_SQLite_LibVersion() & @CR);SQLite版本号
MsgBox(0,"SQLite3.dll 加载路径：",$sSQliteDll)
_SQLite_Shutdown ()