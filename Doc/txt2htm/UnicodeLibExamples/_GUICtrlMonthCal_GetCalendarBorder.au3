#include <GuiConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$Debug_MC = False ; 检查传递给 MonthCal 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $iMemo

_Main()

Func _Main()
	Local $hMonthCal

	; 创建 GUI
	GUICreate("Month Calendar", 400, 300)
	$hMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 4, 168, 392, 128, 0)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUISetState()

	; 获取/设置日历边框
	MemoWrite("Border in pixels: " & _GUICtrlMonthCal_GetCalendarBorder($hMonthCal))
	Sleep(3000)
	GUISetState(@SW_LOCK)
	_GUICtrlMonthCal_SetCalendarBorder($hMonthCal, 2)
	MemoWrite("Border in pixels: " & _GUICtrlMonthCal_GetCalendarBorder($hMonthCal))
	GUISetState(@SW_UNLOCK)
	Sleep(3000)
	GUISetState(@SW_LOCK)
	_GUICtrlMonthCal_SetCalendarBorder($hMonthCal, 0, False)
	MemoWrite("Border in pixels: " & _GUICtrlMonthCal_GetCalendarBorder($hMonthCal))
	GUISetState(@SW_UNLOCK)


	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

; 写入消息到 memo
Func MemoWrite($sMessage)
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
