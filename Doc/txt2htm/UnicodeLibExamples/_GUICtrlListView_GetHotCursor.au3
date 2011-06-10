#include <GuiConstantsEx.au3>
#include <GuiListView.au3>

$Debug_LV = False ; 检查传递给 ListView 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hListView

	GUICreate("ListView Get Hot Cursor", 400, 300)
	$hListView = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState()

	; 添加列
	_GUICtrlListView_AddColumn($hListView, "Column 1", 100)
	_GUICtrlListView_AddColumn($hListView, "Column 2", 100)
	_GUICtrlListView_AddColumn($hListView, "Column 3", 100)

	; 显示热光标句柄
	MsgBox(4160, "Information", "Hot Cursor Handle: 0x" & Hex(_GUICtrlListView_GetHotCursor($hListView)) & @CRLF & _
			"IsPtr = " & IsPtr(_GUICtrlListView_GetHotCursor($hListView)) & " IsHwnd = " & IsHWnd(_GUICtrlListView_GetHotCursor($hListView)))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
