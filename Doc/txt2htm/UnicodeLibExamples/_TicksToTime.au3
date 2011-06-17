; *** 显示计时器窗口的演示
#include <GUIConstantsEx.au3>
#include <Date.au3>

Opt("TrayIconDebug", 1)

Global $timer, $Secs, $Mins, $Hour, $Time

_Main()

Func _Main()
	;创建 GUI
	GUICreate("Timer", 120, 50)
	GUICtrlCreateLabel("00:00:00", 10, 10)
	GUISetState()
	;开始计时
	$timer = TimerInit()
	AdlibRegister("Timer", 50)
	;
	While 1
		;FileWriteLine("debug.log",@min & ":" & @sec & " ==> before")
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
		;FileWriteLine("debug.log",@min & ":" & @sec & " ==> after")
	WEnd
EndFunc   ;==>_Main
;
Func Timer()
	_TicksToTime(Int(TimerDiff($timer)), $Hour, $Mins, $Secs)
	Local $sTime = $Time ; 保存当前时间以测试和避免不稳定..
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	If $sTime <> $Time Then ControlSetText("Timer", "", "Static1", $Time)
EndFunc   ;==>Timer
