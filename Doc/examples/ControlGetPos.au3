Run("notepad.exe")
$pos = ControlGetPos("[CLASS:Notepad]", "", "Edit1")
MsgBox(0, "窗口状态:", "位置: " & $pos[0] & "," & $pos[1] & " 大小: " & $pos[2] & "," & $pos[3] )
;译注：脚本不能出现提示消息框！下面“结果输出”栏提示错误！