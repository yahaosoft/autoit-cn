#include <GuiConstantsEx.au3>
#include <GuiSlider.au3>

$Debug_S = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $aRange, $hSlider

	; 创建 GUI
	GUICreate("Slider Get Range", 400, 296)
	$hSlider = GUICtrlCreateSlider(2, 2, 396, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS, $TBS_ENABLESELRANGE))
	GUISetState()

	; 获取范围
	$aRange = _GUICtrlSlider_GetRange($hSlider)
	MsgBox(4160, "Information", StringFormat("Range: %d - %d", $aRange[0], $aRange[1]))

	; 设置范围
	_GUICtrlSlider_SetRange($hSlider, 20, 50)

	; 获取范围
	$aRange = _GUICtrlSlider_GetRange($hSlider)
	MsgBox(4160, "Information", StringFormat("Range: %d - %d", $aRange[0], $aRange[1]))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
