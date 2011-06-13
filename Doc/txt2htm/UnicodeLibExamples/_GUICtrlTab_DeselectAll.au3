#include <GuiConstantsEx.au3>
#include <GuiTab.au3>

$Debug_TAB = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hTab

	; 创建 GUI
	GUICreate("Tab Control Deselect All", 400, 300)
	$hTab = GUICtrlCreateTab(2, 2, 396, 296, $TCS_BUTTONS)
	GUISetState()

	; 添加标签
	_GUICtrlTab_InsertItem($hTab, 0, "Tab 1")
	_GUICtrlTab_InsertItem($hTab, 1, "Tab 2")
	_GUICtrlTab_InsertItem($hTab, 2, "Tab 3")

	; 选择第二个标签项
	_GUICtrlTab_SetCurSel($hTab, 1)

	; 复位标签选择
	MsgBox(4160, "Information", "Resetting tab selection")
	_GUICtrlTab_DeselectAll($hTab, False)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
