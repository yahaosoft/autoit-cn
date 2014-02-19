#include <MsgBoxConstants.au3>
#include <WinAPI.au3>

Example()

Func Example()
	Local $hwnd
	$hwnd = GUICreate("test")
	MsgBox($MB_SYSTEMMODAL, "Client", "Client Width: " & _WinAPI_GetClientWidth($hwnd))
EndFunc   ;==>Example
