#include <APILocaleConstants.au3>
#include <Array.au3>
#include <WinAPILocale.au3>

Local $Data = _WinAPI_EnumSystemLocales($LCID_INSTALLED)

_ArrayDisplay($Data, '_WinAPI_EnumSystemLocales')
