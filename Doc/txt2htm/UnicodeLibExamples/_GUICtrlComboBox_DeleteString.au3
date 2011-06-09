#include <GUIComboBox.au3>
#include <GuiConstantsEx.au3>
#include <Constants.au3>

$Debug_CB = False ; 检查传递给 ComboBox/ComboBoxEx 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hCombo

	; 创建 GUI
	GUICreate("ComboBox Delete String", 400, 296)
	$hCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	GUISetState()

	; 添加目录
	_GUICtrlComboBox_AddDir($hCombo, "", $DDL_DRIVES, False)

	;删除字符串
	MsgBox(4160, "Information", "Deleting string at index 1")
	_GUICtrlComboBox_DeleteString($hCombo, 1)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
