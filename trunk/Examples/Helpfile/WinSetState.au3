Run("notepad.exe")
WinWaitActive("无标题 - 记事本")


WinSetState("无标题 - 记事本", "", @SW_HIDE)
Sleep(3000)
WinSetState("无标题 - 记事本", "", @SW_SHOW)
