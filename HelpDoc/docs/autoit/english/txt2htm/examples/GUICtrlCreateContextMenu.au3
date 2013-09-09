; right click on gui to bring up context Menu.
; right click on the "ok" button to bring up a controll specific context menu.

#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>

Example()

Func Example()
	GUICreate("My GUI Context Menu", 300, 200)

	Local $contextmenu = GUICtrlCreateContextMenu()

	Local $button = GUICtrlCreateButton("OK", 100, 100, 70, 20)
	Local $buttoncontext = GUICtrlCreateContextMenu($button)
	GUICtrlCreateMenuItem("About button", $buttoncontext)

	Local $newsubmenu = GUICtrlCreateMenu("new", $contextmenu)
	GUICtrlCreateMenuItem("text", $newsubmenu)

	GUICtrlCreateMenuItem("Open", $contextmenu)
	GUICtrlCreateMenuItem("Save", $contextmenu)
	GUICtrlCreateMenuItem("", $contextmenu) ; separator

	GUICtrlCreateMenuItem("Info", $contextmenu)

	GUISetState()

	; Run the GUI until the dialog is closed
	While 1
		Local $msg = GUIGetMsg()

		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
	GUIDelete()
EndFunc   ;==>Example
