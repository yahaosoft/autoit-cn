$msg = ""
$szName = InputBox(Default, "请输入......", "", " M", Default, Default, Default, Default, 10)
Switch @error
Case 2
	$msg = "超时 "
	ContinueCase
Case 1; 继续上一事件
	$msg &= "注销"
Case 0
	Switch $szName
	Case "a", "e", "i", "o", "u"
		$msg = "这是字符"
	Case "258"
		$msg = "这是数字"
	Case "Q" to "QZ"
		$msg = "Science"
	Case Else
		$msg = "其它类"
	EndSwitch
Case Else
	$msg = "Something went horribly wrong."
EndSwitch

MsgBox(0, Default, $msg)
