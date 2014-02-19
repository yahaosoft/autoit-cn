#include <APIRegConstants.au3>
#include <WinAPIReg.au3>
#include <WinAPIShPath.au3>

Local $Path = _WinAPI_AssocQueryString('.txt', $ASSOCSTR_COMMAND)

ConsoleWrite('Command: ' & $Path & @CRLF)
ConsoleWrite('Path: ' & _WinAPI_PathRemoveArgs($Path) & @CRLF)
ConsoleWrite('Arguments: ' & _WinAPI_PathGetArgs($Path) & @CRLF)
