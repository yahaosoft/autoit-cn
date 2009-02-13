$size = DirGetSize(@HomeDrive)
Msgbox(0,"","大小(MB) :" & Round($size / 1024 / 1024))

$size = DirGetSize(@WindowsDir, 2)
Msgbox(0,"","大小(MB) :" & Round($size / 1024 / 1024))

$timer	= TimerInit()
$size	= DirGetSize("\\10.0.0.1\h$",1);试试填入一个真实地址
$diff	= Round(TimerDiff($timer) / 1000)	; 计时
If IsArray($size) Then
	Msgbox(0,"目录文件信息","尺寸(B) :" & $size[0] & @LF _
		& "文件:" & $size[1] & @LF & "文件夹:" & $size[2] & @LF _
		& "用时(秒):" & $diff)
EndIf