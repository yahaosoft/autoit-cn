#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hGui, $hEdit, $sTitle = "ShowBalloonTip", $sText = "Displays a balloon tip associated with an edit control"

	; 创建 GUI
	$hGui = GUICreate("Edit ShowBalloonTip", 400, 300)
	$hEdit = _GUICtrlEdit_Create($hGui, "", 2, 2, 394, 268)
	GUISetState()

	; 设置文本
	_GUICtrlEdit_SetText($hEdit, "This is a test" & @CRLF & "Another Line" & @CRLF & "Append to the end?" & @CRLF & @CRLF)

	_GUICtrlEdit_ShowBalloonTip($hEdit, $sTitle, $sText, $TTI_INFO)
	Sleep(1000)
	Local $bool = _GUICtrlEdit_HideBalloonTip($hEdit)
	_GUICtrlEdit_AppendText($hEdit, "HideBalloonTip = " & $bool & @CRLF)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
