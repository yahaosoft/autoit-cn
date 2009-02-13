$file = FileOpen("test.txt", 0)

; 检查文件属性是否为读，以便好打开
If $file = -1 Then
	MsgBox(0, "错误", "不能打开文件.")
	Exit
EndIf

; 从 1 开始每次传送一个字符，直到文件结束 （译注：读中文必须设置为远大于1的值！）
While 1
	$chars = FileRead($file, 1)
	If @error = -1 Then ExitLoop
	MsgBox(0, "读出字符:", $chars)
Wend

FileClose($file)
