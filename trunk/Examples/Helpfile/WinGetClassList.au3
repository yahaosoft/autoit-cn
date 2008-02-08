
Run("notepad.exe")
WinWaitActive("无标题 - 记事本")





$text = WinGetClassList("无标题 - 记事本", "")
MsgBox(0, "类列表为:", $text)
