#include <GUIConstantsEx.au3>

Global $giIDC = -1, $giNewIDC = 0

Example()

Func Example()
	HotKeySet("{ESC}", "Increment")

	GUICreate("Press ESC to Increment", 400, 400, 0, 0)

	GUISetState(@SW_SHOW)

	While GUIGetMsg() <> $GUI_EVENT_CLOSE
		If $giNewIDC <> $giIDC Then
			$giIDC = $giNewIDC
			GUISetCursor($giIDC)
		EndIf
		ToolTip("GUI Cursor #" & $giIDC)
	WEnd

	GUIDelete()
EndFunc   ;==>Example

Func Increment()
	$giNewIDC = $giIDC + 1
	If $giNewIDC > 15 Then $giNewIDC = 0
EndFunc   ;==>Increment
