#include <GuiConstantsEx.au3>
#include <GuiStatusBar.au3>

$Debug_SB = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()

	Local $hGUI, $HandleBefore, $hStatus
	Local $aParts[3] = [75, 150, -1]

	; 创建 GUI
	$hGUI = GUICreate("StatusBar Destroy", 400, 300)

	;===============================================================================
	; 默认为仅一个部分, 不含文本
	$hStatus = _GUICtrlStatusBar_Create($hGUI)
	;===============================================================================
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	GUISetState()

	$HandleBefore = $hStatus
	MsgBox(4160, "Information", "Destroying the Control for Handle: " & $hStatus)
	MsgBox(4160, "Information", "Control Destroyed: " & _GUICtrlStatusBar_Destroy($hStatus) & @LF & _
			"Handel Before Destroy: " & $HandleBefore & @LF & _
			"Handle After Destroy: " & $hStatus)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
