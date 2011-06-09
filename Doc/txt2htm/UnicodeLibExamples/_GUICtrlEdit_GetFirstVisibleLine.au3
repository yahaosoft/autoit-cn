#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hEdit

	; 创建 GUI
	GUICreate("Edit Get First Visible Line", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268)
	GUISetState()

	For $x = 0 To 20
		_GUICtrlEdit_AppendText($hEdit, StringFormat("[%02d] Append to the end?", $x) & @CRLF)
	Next

	MsgBox(4160, "Information", "First Visible Line: " & _GUICtrlEdit_GetFirstVisibleLine($hEdit))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
