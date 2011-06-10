#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>

$Debug_LB = False ; 检查传递给 ListBox 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hListBox

	; 创建 GUI
	GUICreate("List Box Get Locale Sub-Language id", 400, 296)
	$hListBox = GUICtrlCreateList("", 2, 2, 396, 296)
	GUISetState()

	; 显示区域设置, 国家代码, 语言标识符, 主要语言标识符和分支语言标识符
	MsgBox(4160, "Information", _
			"Locale .................: " & _GUICtrlListBox_GetLocale($hListBox) & @LF & _
			"Country code ........: " & _GUICtrlListBox_GetLocaleCountry($hListBox) & @LF & _
			"Language identifier..: " & _GUICtrlListBox_GetLocaleLang($hListBox) & @LF & _
			"Primary Language id : " & _GUICtrlListBox_GetLocalePrimLang($hListBox) & @LF & _
			"Sub-Language id ....: " & _GUICtrlListBox_GetLocaleSubLang($hListBox))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
