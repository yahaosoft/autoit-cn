$file = FileOpen("test.txt", 1)

; 检查文件属性是否为写
If $file = -1 Then
	MsgBox(0, "错误", "不能打开文件.")
	Exit
EndIf

FileWrite($file, "Line1")
FileWrite($file, "Still Line1" & @CRLF)
FileWrite($file, "Line2")

FileClose($file)
