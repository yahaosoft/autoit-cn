#include <GuiComboBoxEx.au3>
#include <GuiConstantsEx.au3>
#include <Constants.au3>

$Debug_CB = False ; 检查传递给 ComboBox/ComboBoxEx 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hGUI, $hCombo

	; 创建 GUI
	$hGUI = GUICreate("ComboBoxEx Get Locale Country Sub-Language id", 400, 300)
	$hCombo = _GUICtrlComboBoxEx_Create($hGUI, "", 2, 2, 394, 100)
	GUISetState()

	; 添加文件
	_GUICtrlComboBoxEx_AddDir($hCombo, "", $DDL_DRIVES, False)

	; 显示区域设置, 国家代码, 语言标识符, 主要语言标识符和分支语言标识符
	MsgBox(4160, "Information", _
			"Locale .................: " & _GUICtrlComboBoxEx_GetLocale($hCombo) & @LF & _
			"Country code ........: " & _GUICtrlComboBoxEx_GetLocaleCountry($hCombo) & @LF & _
			"Language identifier..: " & _GUICtrlComboBoxEx_GetLocaleLang($hCombo) & @LF & _
			"Primary Language id : " & _GUICtrlComboBoxEx_GetLocalePrimLang($hCombo) & @LF & _
			"Sub-Language id ....: " & _GUICtrlComboBoxEx_GetLocaleSubLang($hCombo))


	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main
