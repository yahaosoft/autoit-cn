$file = FileOpen("test.txt", 0)

; 检查文件属性是否为读，以便好打开
If $file = -1 Then
	MsgBox(0, "错误", "不能打开文件.")
	Exit
EndIf

; 读文本行直到文件结束
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	MsgBox(0, "读取的行:", $line)
Wend

FileClose($file)
