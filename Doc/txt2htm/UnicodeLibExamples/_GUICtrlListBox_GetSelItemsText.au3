#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>

$Debug_LB = False ; 检查传递给 ListBox 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $sItems, $aItems, $hListBox

	; 创建 GUI
	GUICreate("List Box Get Sel Items Text", 400, 296)
	$hListBox = GUICtrlCreateList("", 2, 2, 396, 296, BitOR($LBS_STANDARD, $LBS_EXTENDEDSEL))
	GUISetState()

	; 添加字符串
	_GUICtrlListBox_BeginUpdate($hListBox)
	For $iI = 1 To 9
		_GUICtrlListBox_AddString($hListBox, StringFormat("%03d : Random string", Random(1, 100, 1)))
	Next
	_GUICtrlListBox_EndUpdate($hListBox)

	; 选择几项
	_GUICtrlListBox_SetSel($hListBox, 3)
	_GUICtrlListBox_SetSel($hListBox, 4)
	_GUICtrlListBox_SetSel($hListBox, 5)

	; 获取已选择项目的索引
	$aItems = _GUICtrlListBox_GetSelItemsText($hListBox)
	For $iI = 1 To $aItems[0]
		$sItems &= @LF & $aItems[$iI]
	Next
	MsgBox(4160, "Information", "Items Selected: " & $sItems)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
