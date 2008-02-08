Opt("WinTitleMatchMode", 2) ; 匹配子字符串
Run("notepad.exe")
WinWaitActive("无标题 - 记事本")

WinSetTrans("无标题 - 记事本", "", 170) ; 让记事本半透明.
