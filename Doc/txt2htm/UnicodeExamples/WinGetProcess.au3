Run("notepad.exe")
WinWait("[CLASS:Notepad]")
Local $pid = WinGetProcess("[CLASS:Notepad]")
MsgBox(0, "进程 PID 为", $pid)
