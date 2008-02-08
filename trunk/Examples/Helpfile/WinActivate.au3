Run("notepad.exe")
WinWaitActive("无标题 - 记事本")
Send("!{tab}")
Sleep(1000)


WinActivate("无标题 - 记事本", "")
