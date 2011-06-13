#include <GuiConstantsEx.au3>
#include <GuiTab.au3>

$Debug_TAB = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hTab

	; 创建 GUI
	GUICreate("Tab Control Get Row Count", 400, 300)
	$hTab = GUICtrlCreateTab(2, 2, 396, 296, $TCS_MULTILINE)
	GUISetState()

	; 添加标签
	For $x = 0 To 10
		_GUICtrlTab_InsertItem($hTab, $x, "Tab " & $x + 1)
	Next

	; 获取行数
	MsgBox(4160, "Information", "Row count: " & _GUICtrlTab_GetRowCount($hTab))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
