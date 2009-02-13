; 对 "ConsoleRead.exe" 编译一个脚本.
; 对 ConsoleRead.exe 常驻的目录打开一个命令提示.
; 命令行上输入: echo 哈罗 ! | ConsoleRead.exe
; 在调用一个控制台窗口时, 上述命令回送文本 "哈罗 !"
; but instead of dispalying it,  | 告诉控制台对 ConsoleRead.exe 进程的 STDIN 串以管道输送它.
If Not @Compiled Then
	MsgBox(0, "", "这个脚本在命令中示范它的功能性.")
	Exit -1
EndIf

Local $data
While True
	$data &= ConsoleRead()
	If @error Then ExitLoop
	Sleep(25)
WEnd
MsgBox(0, "", "接收: " & @CRLF & @CRLF & $data)
