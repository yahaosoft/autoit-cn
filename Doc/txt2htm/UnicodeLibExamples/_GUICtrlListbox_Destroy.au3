#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>
#include <Constants.au3>

$Debug_LB = False ; 检查传递给 ListBox 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hGUI, $hListBox

	; 创建 GUI
	$hGUI = GUICreate("(UDF Created) List Box Destroy", 400, 296)
	$hListBox = _GUICtrlListBox_Create($hGUI, "", 2, 2, 396, 296)
	GUISetState()

	; 添加文件
	_GUICtrlListBox_BeginUpdate($hListBox)
	_GUICtrlListBox_ResetContent($hListBox)
	_GUICtrlListBox_InitStorage($hListBox, 100, 4096)
	_GUICtrlListBox_Dir($hListBox, @WindowsDir & "\win*.exe")
	_GUICtrlListBox_AddFile($hListBox, @WindowsDir & "\Notepad.exe")
	_GUICtrlListBox_Dir($hListBox, "", $DDL_DRIVES)
	_GUICtrlListBox_Dir($hListBox, "", $DDL_DRIVES, False)
	_GUICtrlListBox_EndUpdate($hListBox)

	MsgBox(4160, "Information", "Destroying ListBox")
	_GUICtrlListBox_Destroy($hListBox)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main
