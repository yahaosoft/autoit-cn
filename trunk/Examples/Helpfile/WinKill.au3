
Run("notepad.exe")
WinWaitActive("无标题 - 记事本")
Sleep(1000)


WinKill("无标题 - 记事本", "")
