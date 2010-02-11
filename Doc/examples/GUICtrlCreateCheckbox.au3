#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)

Example()

Func Example()
	Local $checkCN, $msg
	GUICreate("My GUI Checkbox")  ; 创建一个对话框，并居中显示

	$checkCN = GUICtrlCreateCheckbox("CHECKBOX 1", 10, 10, 120, 20)

	GUISetState()       ; 显示有复选框(Checkbox)控件的对话框

	; 运行界面，直到窗口被关闭
	While 1
		$msg = GUIGetMsg()
		
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
EndFunc   ;==>Example