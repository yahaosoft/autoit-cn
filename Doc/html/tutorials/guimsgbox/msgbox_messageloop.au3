#include <GUIConstantsEx.au3>

GUICreate("Custom Msgbox", 210, 80)

$YesID  = GUICtrlCreateButton("是", 10, 50, 50, 20)
$NoID   = GUICtrlCreateButton("否", 80, 50, 50, 20)
$ExitID = GUICtrlCreateButton("退出", 150, 50, 50, 20)

GUISetState()  ; display the GUI

Do
	$msg = GUIGetMsg()

	Select
		Case $msg= $YesID
			MsgBox(0,"你点击了", "是")
		Case $msg= $NoID
			MsgBox(0,"你点击了", "否")
		Case $msg= $ExitID
			MsgBox(0,"你点击了", "退出")
		Case $msg= $GUI_EVENT_CLOSE
			MsgBox(0,"你点击了", "关闭")
	EndSelect
Until $msg = $GUI_EVENT_CLOSE or $msg = $ExitID

