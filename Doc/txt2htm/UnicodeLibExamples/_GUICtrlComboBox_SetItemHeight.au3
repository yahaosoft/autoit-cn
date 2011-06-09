#include <GUIComboBox.au3>
#include <GuiConstantsEx.au3>

$Debug_CB = False ; 检查传递给 ComboBox/ComboBoxEx 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $iMemo

_Main()

Func _Main()
	Local $hCombo

	; 创建 GUI
	GUICreate("ComboBox Set Item Height", 400, 296)
	$hCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	$iMemo = GUICtrlCreateEdit("", 2, 32, 396, 266, 0)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUISetState()

	; 添加文件
	_GUICtrlComboBox_BeginUpdate($hCombo)
	_GUICtrlComboBox_AddDir($hCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($hCombo)

	; 获取项目高度 (选择区域)
	MemoWrite("Item Height (selection field): " & _GUICtrlComboBox_GetItemHeight($hCombo))

	; 获取项目高度 (列表项目)
	MemoWrite("Item Height (list items): " & _GUICtrlComboBox_GetItemHeight($hCombo, 0))

	; 设置项目高度 (选择区域)
	_GUICtrlComboBox_SetItemHeight($hCombo, 18)

	; 设置项目高度 (选择区域)
	_GUICtrlComboBox_SetItemHeight($hCombo, 20, 0)

	; 获取项目高度 (选择区域)
	MemoWrite("Item Height (selection field): " & _GUICtrlComboBox_GetItemHeight($hCombo))

	; 获取项目高度 (列表项目)
	MemoWrite("Item Height (list items): " & _GUICtrlComboBox_GetItemHeight($hCombo, 0))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

; 写入一行到 memo 控件
Func MemoWrite($sMessage)
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
