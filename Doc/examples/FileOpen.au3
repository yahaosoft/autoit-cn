$file = FileOpen("test.txt", 0)

; 检查是否文件属性是否可读，以便好打开
If $file = -1 Then
	MsgBox(0, "错误", "不能打开文件.")
	Exit
EndIf

FileClose($file)


; 自动产生目录结构的另外一个样本
$file = FileOpen("test.txt", 10) ; 类似 2 + 8 (清除 + 产生目录)

If $file = -1 Then
	MsgBox(0, "错误", "不能打开文件.")
	Exit
EndIf

FileClose($file)