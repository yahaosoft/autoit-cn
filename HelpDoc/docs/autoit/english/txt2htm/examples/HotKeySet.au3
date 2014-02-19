#include <MsgBoxConstants.au3>

; Press Esc to terminate script, Pause/Break to "pause"

Global $gbPaused = False

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

While 1
	Sleep(100)
WEnd

Func TogglePause()
	$gbPaused = Not $gbPaused
	While $gbPaused
		Sleep(100)
		ToolTip('Script is "Paused"', 0, 0)
	WEnd
	ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
	Exit
EndFunc   ;==>Terminate

Func ShowMessage()
	MsgBox($MB_SYSTEMMODAL, "", "This is a message.")
EndFunc   ;==>ShowMessage
