; Check if a new notepad window is minimized
Local $state = WinGetState("[CLASS:Notepad]", "")

; Is the "minimized" value set?
If BitAnd($state, 16) Then
	MsgBox(0, "Example", "Window is minimized")
EndIf

