#include <Array.au3>
#include <WinAPIProc.au3>

Local $Data = _WinAPI_EnumProcessWindows(0, 0)

_ArrayDisplay($Data, '_WinAPI_EnumProcessWindows')
