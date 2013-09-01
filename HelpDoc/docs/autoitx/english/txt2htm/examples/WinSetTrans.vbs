Set oAutoIt = WScript.CreateObject("AutoItX3.Control")

oAutoIt.Run("notepad.exe", "", oAutoIt.SW_MINIMIZE)
oAutoIt.WinWaitActive("Untitled - Notepad")
oAutoIt.WinSetTrans "Untitled - Notepad","", 50