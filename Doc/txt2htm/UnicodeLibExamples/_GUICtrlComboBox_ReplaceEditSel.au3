#include <GUIComboBox.au3>
#include <GuiConstantsEx.au3>

$Debug_CB = False ; 检查传递给 ComboBox/ComboBoxEx 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hCombo

	; 创建 GUI
	GUICreate("ComboBox Replace Edit Sel", 400, 296)
	$hCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	GUISetState()

	; 设置编辑的文本
	_GUICtrlComboBox_SetEditText($hCombo, "Old Edit Text")

	; 添加文件
	_GUICtrlComboBox_BeginUpdate($hCombo)
	_GUICtrlComboBox_AddDir($hCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($hCombo)

	Sleep(500)

	; 设置编辑框中的选中文本
	_GUICtrlComboBox_SetEditSel($hCombo, 0, -1)

	Sleep(500)

	; 限制编辑框中的文本
	_GUICtrlComboBox_ReplaceEditSel($hCombo, "New Edit Text")

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
