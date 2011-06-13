#include <GuiConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WinAPI.au3>

$Debug_SB = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()

	Local $hGUI, $hStatus
	Local $aParts[3] = [75, 150, -1]

	; 创建 GUI
	$hGUI = GUICreate("(Example 1) StatusBar Set Min Height", 400, 300)
	$hStatus = _GUICtrlStatusBar_Create($hGUI)
	GUISetState()

	; 设置某部分
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 1")
	_GUICtrlStatusBar_SetText($hStatus, "Part 2", 1)

	; 设置最小高度
	_GUICtrlStatusBar_SetMinHeight($hStatus, 30)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
