Run("notepad.exe")
WinWaitActive("无标题 - 记事本")


If WinExists("无标题 - 记事本") Then
	MsgBox(0, "", "记事本窗口存在")
EndIf
