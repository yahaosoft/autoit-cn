Run("notepad.exe")
WinWaitActive("无标题 - 记事本")
ControlSend("无标题 - 记事本","","[CLASSNN:Edit1]","text")
Sleep(500)

WinClose("无标题 - 记事本", "")
