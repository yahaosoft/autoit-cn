$sum = 0
While 1 ;从 ExitLoop 之后获取调用无限循环
	$ans = InputBox("运行计数=" & $sum, _
		"	输入一个正数.  (负数将退出)")
	If $ans < 0 Then ExitLoop
	$sum = $sum + $ans
WEnd
MsgBox(0,"总数是：", $sum)
