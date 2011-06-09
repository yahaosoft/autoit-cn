#include <GuiConstantsEx.au3>
#include <GuiDateTimePicker.au3>

$Debug_DTP = False ; 检查传递给 DTP 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hDTP

	; 创建 GUI
	GUICreate("DateTimePick Set Format", 400, 300)
	$hDTP = GUICtrlGetHandle(GUICtrlCreateDate("", 2, 6, 190))

	GUISetState()

	; 设置显示的格式
	_GUICtrlDTP_SetFormat($hDTP, "ddd MMM dd, yyyy hh:mm ttt")

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
