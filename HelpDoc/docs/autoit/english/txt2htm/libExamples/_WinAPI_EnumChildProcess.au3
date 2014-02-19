#include <Array.au3>
#include <WinAPIProc.au3>

Local $Data = _WinAPI_EnumChildProcess(_WinAPI_GetParentProcess())

_ArrayDisplay($Data, '_WinAPI_EnumChildProcess')
