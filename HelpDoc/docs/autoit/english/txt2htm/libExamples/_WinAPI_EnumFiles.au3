#include <Array.au3>
#include <WinAPIFiles.au3>

Local $Data = _WinAPI_EnumFiles(@SystemDir, 1, '*.ax;*.cpl;*.dll;*.drv;*.exe;*.ocx;*.scr')

_ArrayDisplay($Data, '_WinAPI_EnumFiles')
