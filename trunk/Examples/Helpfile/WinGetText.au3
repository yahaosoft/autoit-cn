Run("notepad.exe")
WinWaitActive("无标题 - 记事本")
ControlSetText("无标题 - 记事本","","[CLASSNN:Edit1]",Random(0,1000))
Sleep(500)



$text = WinGetText("无标题 - 记事本", "")
MsgBox(0, "读取的文本为:","读取到的文本为: " & $text)
