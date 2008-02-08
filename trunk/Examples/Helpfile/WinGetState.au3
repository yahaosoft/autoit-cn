Run("notepad.exe")
WinWaitActive("无标题 - 记事本")
WinSetState("无标题 - 记事本","",@SW_MINIMIZE)

; Check if a new notepad window is minimized
$state = WinGetState("无标题 - 记事本", "")

; Is the "minimized" value set?
If BitAnd($state, 16) Then
	MsgBox(0, "例子", "记事本窗口是最小化的")
Else
	MsgBox(0, "例子", "记事本窗口不是最小化的")	
EndIf

