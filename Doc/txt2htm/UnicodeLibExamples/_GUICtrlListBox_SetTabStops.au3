#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>

$Debug_LB = False ; 检查传递给 ListBox 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $aTabs[4] = [3, 100, 200, 300], $hListBox

	; 创建 GUI
	GUICreate("List Box Set Tab Stops", 400, 296)
	$hListBox = GUICtrlCreateList("", 2, 2, 396, 296, BitOR($LBS_STANDARD, $LBS_USETABSTOPS))
	GUISetState()

	; 设置制表位
	_GUICtrlListBox_SetTabStops($hListBox, $aTabs)

	; 添加 TAB 分隔的字符串
	_GUICtrlListBox_AddString($hListBox, "Column 1" & @TAB & "Column 2" & @TAB & "Column 3")

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
