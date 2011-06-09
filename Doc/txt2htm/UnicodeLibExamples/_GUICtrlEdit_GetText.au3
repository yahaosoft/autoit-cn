#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hEdit

	; 创建 GUI
	GUICreate("Edit Get Text", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268)
	GUISetState()

	; 设置文本
	_GUICtrlEdit_SetText($hEdit, "This is a test" & @CRLF & "Another Line" & @CRLF & "Append to the end?")

	; 获取文本
	MsgBox(4160, "Information", _GUICtrlEdit_GetText($hEdit))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
