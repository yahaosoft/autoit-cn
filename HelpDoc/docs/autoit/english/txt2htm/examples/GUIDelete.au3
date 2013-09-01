#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $iMsg = 0

	GUICreate("My GUI") ; will create a dialog box that when displayed is centered

	GUISetState() ; will display an empty dialog box

	; Run the GUI until the dialog is closed
	While 1
		$iMsg = GUIGetMsg()

		If $iMsg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd

	GUIDelete();	; will return 1
EndFunc   ;==>Example
