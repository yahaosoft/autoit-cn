Local $var = DriveGetLabel("c:\")
If $var='' Then
	MsgBox(4096,"错误","C 盘卷标未设置")
Else
	MsgBox(4096,"C 盘卷标: ",$var)
EndIf