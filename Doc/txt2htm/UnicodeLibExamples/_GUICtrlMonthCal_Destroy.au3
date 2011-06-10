#include <GuiConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsConstants.au3>

$Debug_MC = False ; 检查传递给 MonthCal 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hGUI, $HandleBefore, $hMonthCal

	; 创建 GUI
	$hGUI = GUICreate("Month Calendar Destroy", 400, 300)
	$hMonthCal = _GUICtrlMonthCal_Create($hGUI, 4, 4, $WS_BORDER)
	GUISetState()

	$HandleBefore = $hMonthCal
	MsgBox(4160, "Information", "Destroying the Control for Handle: " & $hMonthCal)
	MsgBox(4160, "Information", "Control Destroyed: " & _GUICtrlMonthCal_Destroy($hMonthCal) & @LF & _
			"Handel Before Destroy: " & $HandleBefore & @LF & _
			"Handle After Destroy: " & $hMonthCal)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
