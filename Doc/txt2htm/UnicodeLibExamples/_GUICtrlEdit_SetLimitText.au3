#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hEdit

	; 创建 GUI
	GUICreate("Edit Set Limit Text", 400, 300)
	$hEdit = GUICtrlCreateEdit("This is a test" & @CRLF & "Another Line", 2, 2, 394, 268)
	GUISetState()

	MsgBox(4160, "Information", "Text Limit: " & _GUICtrlEdit_GetLimitText($hEdit))

	MsgBox(4160, "Information", "Setting Text Limit")
	_GUICtrlEdit_SetLimitText($hEdit, 64000)

	MsgBox(4160, "Information", "Text Limit: " & _GUICtrlEdit_GetLimitText($hEdit))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
