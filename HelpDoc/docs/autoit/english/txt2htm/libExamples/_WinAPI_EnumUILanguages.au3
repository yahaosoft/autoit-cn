#include <Array.au3>
#include <WinAPILocale.au3>

Local $Data = _WinAPI_EnumUILanguages()

_ArrayDisplay($Data, '_WinAPI_EnumUILanguages')
