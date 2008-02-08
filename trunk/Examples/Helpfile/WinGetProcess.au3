
Run("notepad.exe")
WinWaitActive("无标题 - 记事本")




$pid = WinGetProcess("无标题 - 记事本")
MsgBox(0, "进程 PID 为", $pid)
