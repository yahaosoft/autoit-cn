#include <MsgBoxConstants.au3>
#include <WinAPIDlg.au3>

Local $Result = _WinAPI_MessageBoxCheck($MB_ICONINFORMATION, 'MyProg', '_WinAPI_MessageBoxCheck()', 'MyProg')

ConsoleWrite('Return: ' & $Result & @CRLF)
