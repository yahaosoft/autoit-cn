#include <GuiConstantsEx.au3>
#include <GuiSlider.au3>

$Debug_S = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hSlider

	; 创建 GUI
	GUICreate("(Internal) Slider Clear Sel", 400, 296)
	$hSlider = GUICtrlCreateSlider(2, 2, 396, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS, $TBS_ENABLESELRANGE))
	GUISetState()

	; 设置选择的
	_GUICtrlSlider_SetSel($hSlider, 10, 50)

	MsgBox(4160, "Information", "Clear Sel")
	; 清除所选
	_GUICtrlSlider_ClearSel($hSlider)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
