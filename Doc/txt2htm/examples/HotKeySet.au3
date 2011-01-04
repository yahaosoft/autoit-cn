; 按Esc键终止运行脚本, 按Pause/Break键暂停或继续运行

Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("+!d", "ShowMessage")  ;Shift-Alt-d

;;;; 保持脚本运行状态，直到用户关闭它 ;;;;
While 1
	Sleep(100)
WEnd
;;;;;;;;

Func TogglePause()
	$Paused = NOT $Paused
	While $Paused
		sleep(100)
		ToolTip('脚本已经暂停了',0,0)
	WEnd
	ToolTip("")
EndFunc

Func Terminate()
	Exit 0
EndFunc

Func ShowMessage()
	MsgBox(4096,"标题","我是一个消息框.")
EndFunc
