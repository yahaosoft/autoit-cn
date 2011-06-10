#include <GuiConstantsEx.au3>
#include <GuiListView.au3>

$Debug_LV = False ; 检查传递给 ListView 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

; 警告不应该把 SetItemParam 用于使用 GuiCtrlCreateListViewItem 创建的项目上
; Param 为项目的控件 ID

_Main()

Func _Main()
	Global $GUI, $iI, $hListView

	; 创建 GUI
	$GUI = GUICreate("(UDF Created) ListView Find Param", 400, 300)
	$hListView = _GUICtrlListView_Create($GUI, "", 2, 2, 394, 268)
	GUISetState()

	; 添加列
	_GUICtrlListView_AddColumn($hListView, "Items", 100)

	; 添加项目
	_GUICtrlListView_BeginUpdate($hListView)
	For $iI = 1 To 100
		_GUICtrlListView_AddItem($hListView, "Item " & $iI)
	Next
	_GUICtrlListView_EndUpdate($hListView)

	; 设置第 50 项的参数值
	_GUICtrlListView_SetItemParam($hListView, 49, 1234)

	; 搜寻目标项
	$iI = _GUICtrlListView_FindParam($hListView, 1234)
	MsgBox(4160, "Information", "Target Item Index: " & $iI)
	_GUICtrlListView_EnsureVisible($hListView, $iI)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
