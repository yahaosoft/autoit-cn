#include <SQLite.au3>
#include <SQLite.dll.au3>

Local $sSQliteDll
$sSQliteDll = _SQLite_Startup ()
If @error Then
    MsgBox(16, "错误", "SQLite.dll加载失败!")
	Exit - 1
EndIf
ConsoleWrite("_SQLite_LibVersion=" &_SQLite_LibVersion() & @CRLF);SQLite版本号
MsgBox(0,"SQLite3.dll 已载入",$sSQliteDll)
_SQLite_Shutdown ()