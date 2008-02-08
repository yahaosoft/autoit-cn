; flashes the window 4 times with a break in between each one of 1/2 second
Run("notepad.exe")
WinWaitActive("无标题 - 记事本")



WinFlash('无标题 - 记事本',"", 4, 500) 