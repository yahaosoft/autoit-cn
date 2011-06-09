#include <GUIComboBox.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

$Debug_CB = False ; 检查传递给 ComboBox/ComboBoxEx 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hCombo

	; 创建 GUI
	GUICreate("ComboBox Reset Content", 400, 296)
	$hCombo = GUICtrlCreateCombo("", 2, 2, 396, 296, BitOR($CBS_SIMPLE, $CBS_DISABLENOSCROLL, $WS_VSCROLL))
	GUISetState()

	; 设置编辑的文本
	_GUICtrlComboBox_SetEditText($hCombo, "Edit Text")

	; 添加文件
	_GUICtrlComboBox_BeginUpdate($hCombo)
	_GUICtrlComboBox_AddDir($hCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($hCombo)

	Sleep(500)

	; 清空内容
	_GUICtrlComboBox_ResetContent($hCombo)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
