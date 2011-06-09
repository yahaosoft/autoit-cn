#include <GuiComboBoxEx.au3>
#include <GuiConstantsEx.au3>

$Debug_CB = False ; 检查传递给 ComboBox/ComboBoxEx 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hGUI, $hCombo

	; 创建 GUI
	$hGUI = GUICreate("ComboBoxEx Init Storage", 400, 300)
	$hCombo = _GUICtrlComboBoxEx_Create($hGUI, "", 2, 2, 396, 296, $CBS_SIMPLE)
	GUISetState()

	MsgBox(4160, "Information", "Innit Storage Pre-Allocated Memory For: " & _GUICtrlComboBoxEx_InitStorage($hCombo, 150, 300) & " Items")
	_GUICtrlComboBoxEx_BeginUpdate($hCombo)

	For $x = 0 To 149
		_GUICtrlComboBoxEx_AddString($hCombo, StringFormat("%03d : Random string", Random(1, 100, 1)))
	Next
	_GUICtrlComboBoxEx_EndUpdate($hCombo)

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main
