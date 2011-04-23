$pos = WinGetPos("[CLASS:Notepad]")
If IsArray($pos) Then
	MsgBox(0, "Window height", $pos[3])
EndIf
