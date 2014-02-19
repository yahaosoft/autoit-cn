#include <Array.au3>
#include <WinAPISys.au3>

Local $Data = _WinAPI_EnumPageFiles()

_ArrayDisplay($Data, '_WinAPI_EnumPageFiles')
