#include <GUIConstantsEx.au3>

Example()

Func Example()
	GUICreate(" My GUI Icons", 250, 250)

	GUICtrlCreateIcon("shell32.dll", 10, 20, 20)
	GUICtrlCreateIcon(@ScriptDir & '\Extras\horse.ani', -1, 20, 40, 32, 32)
	GUICtrlCreateIcon("shell32.dll", 7, 20, 75, 32, 32)
	GUISetState()

	; Run the GUI until the dialog is closed
	While 1
		Local $msg = GUIGetMsg()

		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
	GUIDelete()
EndFunc   ;==>Example
