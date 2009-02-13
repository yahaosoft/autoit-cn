If FileExists("C:\autoexec.bat") Then
	MsgBox(4096, "C:\autoexec.bat File", "已存在")
Else
	MsgBox(4096,"C:\autoexec.bat File", "不存在")
EndIf

If FileExists("C:\") Then
	MsgBox(4096, "C:\ Dir ", "已存在")
Else
	MsgBox(4096,"C:\ Dir" , "不存在")
EndIf

If FileExists("D:") Then
	MsgBox(4096, "驱动器 D: ", "已存在")
Else
	MsgBox(4096,"驱动器 D: ", "不存在")
EndIf
