#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsConstants.au3>

$Debug_MC = False ; Check ClassName being passed to MonthCal functions, set to True and use a handle to another control to see it work

Global $iMemo

_Main()

Func _Main()
	Local $tTime, $hMonthCal

	; 创建 GUI
	GUICreate("Month Calendar Set Cur Sel", 400, 300)
	$hMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 4, 168, 392, 128, 0)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUISetState()

	; Get/Set current selection
	_GUICtrlMonthCal_SetCurSel($hMonthCal, @YEAR, 8, 19)
	$tTime = _GUICtrlMonthCal_GetCurSel($hMonthCal)
	MemoWrite("Current selection : " & StringFormat("%02d/%02d/%04d", DllStructGetData($tTime, "Month"), _
			DllStructGetData($tTime, "Day"), _
			DllStructGetData($tTime, "Year")))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

; 写入消息到 memo
Func MemoWrite($sMessage)
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
