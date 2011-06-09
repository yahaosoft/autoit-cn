#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hEdit

	; 创建 GUI
	GUICreate("(Internal) Edit Get Password Char", 400, 300)
	$hEdit = GUICtrlCreateInput("Test of build-in control", 2, 2, 394, 25, $ES_PASSWORD)
	GUISetState()

	MsgBox(4096, "Information", "Password Char: " & _GUICtrlEdit_GetPasswordChar($hEdit))

	_GUICtrlEdit_SetPasswordChar($hEdit, "$") ; 改变屏蔽字符为 $

	MsgBox(4096, "Information", "Password Char: " & _GUICtrlEdit_GetPasswordChar($hEdit))

	_GUICtrlEdit_SetPasswordChar($hEdit) ; 显示用户输入的字符

	MsgBox(4096, "Information", "Password Char: " & _GUICtrlEdit_GetPasswordChar($hEdit))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
