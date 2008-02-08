Run("notepad.exe")
WinWaitActive("无标题 - 记事本")



$title = WinGetTitle("无标题 - ", "")
MsgBox(0, "完整的标题为:", $title)
