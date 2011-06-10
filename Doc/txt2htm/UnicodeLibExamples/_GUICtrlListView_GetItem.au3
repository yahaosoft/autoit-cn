#include <GuiConstantsEx.au3>
#include <GuiListView.au3>

$Debug_LV = False ; 检查传递给 ListView 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $aItem, $hListView

	GUICreate("ListView Get Item", 400, 300)

	$hListView = GUICtrlCreateListView("Items", 2, 2, 394, 268)
	GUISetState()

	GUICtrlCreateListViewItem("Row 1", $hListView)
	GUICtrlCreateListViewItem("Row 2", $hListView)
	GUICtrlCreateListViewItem("Row 3", $hListView)

	; 显示第二项文本
	$aItem = _GUICtrlListView_GetItem($hListView, 1)
	MsgBox(4160, "Information", "Item 2 Text: " & $aItem[3])

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	GUIDelete()
EndFunc   ;==>_Main
