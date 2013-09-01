#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Global $oMyError

Example()

Func Example()
	Local $myedit, $msg

	GUICreate("My GUI edit") ; will create a dialog box that when displayed is centered

	$myedit = GUICtrlCreateEdit("First line" & @CRLF, 176, 32, 121, 97, $ES_AUTOVSCROLL + $WS_VSCROLL)

	GUISetState()

	Send("{END}")

	; will be append dont' forget 3rd parameter
	GUICtrlSetData($myedit, "Second line", 1)

	; Run the GUI until the dialog is closed
	While 1
		$msg = GUIGetMsg()

		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
	GUIDelete()
EndFunc   ;==>Example
