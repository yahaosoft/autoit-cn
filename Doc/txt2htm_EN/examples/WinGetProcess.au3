Run("notepad.exe")
$pid = WinGetProcess("[CLASS:Notepad]")
MsgBox(4096, "PID is", $pid)
