#include <GUIConstantsEx.au3>

Global $gX = 0, $gY = 0

Example()

Func Example()
	HotKeySet("{ESC}", "GetPos")

	GUICreate("Press Esc to Get Pos", 400, 400)
	$gX = GUICtrlCreateLabel("0", 10, 10, 50)
	$gY = GUICtrlCreateLabel("0", 10, 30, 50)
	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

		EndSwitch
	WEnd

	GUIDelete()
EndFunc   ;==>Example

Func GetPos()
	Local $a = GUIGetCursorInfo()
	GUICtrlSetData($gX, $a[0])
	GUICtrlSetData($gY, $a[1])
EndFunc   ;==>GetPos
