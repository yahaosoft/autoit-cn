﻿BlockInput(1)

Run("notepad.exe")
WinWaitActive("[CLASS:Notepad]")
Send("{F5}") ;粘贴当前时间和日期

BlockInput(0)
