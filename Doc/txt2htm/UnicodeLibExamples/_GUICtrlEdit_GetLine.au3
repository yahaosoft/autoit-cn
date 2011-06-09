#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hEdit
	Local $Wow64 = ""
	If @AutoItX64 Then $Wow64 = "\Wow6432Node"
	Local $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $Wow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\include\changelog.txt"

	; 创建 GUI
	GUICreate("Edit Get Line", 400, 300)
	$hEdit = GUICtrlCreateEdit("", 2, 2, 394, 268)
	GUISetState()

	_GUICtrlEdit_SetText($hEdit, FileRead($sFile))

	MsgBox(4160, "Information", _GUICtrlEdit_GetLine($hEdit, Random(0, 7, 1)))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
