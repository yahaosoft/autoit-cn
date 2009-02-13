Run("notepad.exe")
WinWait("无标题 - 记事本")
ControlSetText("无标题 - 记事本", "", "Edit1", "这里是新文本" )
