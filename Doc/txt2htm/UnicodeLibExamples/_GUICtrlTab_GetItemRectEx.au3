#include <GuiConstantsEx.au3>
#include <GuiTab.au3>

$Debug_TAB = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $tRect, $sRect, $hTab

	; 创建 GUI
	GUICreate("Tab Control Get Item RectEx", 400, 300)
	$hTab = GUICtrlCreateTab(2, 2, 396, 296)
	GUISetState()

	; 添加标签
	_GUICtrlTab_InsertItem($hTab, 0, "Tab 1")
	_GUICtrlTab_InsertItem($hTab, 1, "Tab 2")
	_GUICtrlTab_InsertItem($hTab, 2, "Tab 3")

	; 获取首个项目的矩形
	$tRect = _GUICtrlTab_GetItemRectEx($hTab, 0)
	$sRect = StringFormat("[%d, %d, %d, %d]", DllStructGetData($tRect, "Left"), _
			DllStructGetData($tRect, "Top"), _
			DllStructGetData($tRect, "Right"), _
			DllStructGetData($tRect, "Bottom"))
	MsgBox(4160, "Information", "Display rectangle: " & $sRect)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
