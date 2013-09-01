#include <GUIConstantsEx.au3>

Example()

Func Example()
	; Create a GUI with various controls.
	Local $hGUI = GUICreate("Example", 300, 200)

	; Create a label control.
	Local $iLabel = GUICtrlCreateLabel("A string of text", 10, 10, 185, 17)
	Local $iClose = GUICtrlCreateButton("Close", 210, 170, 85, 25)

	; Set the background color of the label control.
	GUICtrlSetBkColor($iLabel, 0xFF0000)

	; Display the GUI.
	GUISetState(@SW_SHOW, $hGUI)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iClose
				ExitLoop

		EndSwitch
	WEnd

	; Delete the previous GUI and all controls.
	GUIDelete($hGUI)
EndFunc   ;==>Example
