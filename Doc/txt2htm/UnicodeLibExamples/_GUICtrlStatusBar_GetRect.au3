#include <GuiConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>

$Debug_SB = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $iMemo

_Main()

Func _Main()

	Local $hGUI, $aRect, $hStatus
	Local $aParts[3] = [75, 150, -1]

	; 创建 GUI
	$hGUI = GUICreate("StatusBar Get Rect", 400, 300)
	$hStatus = _GUICtrlStatusBar_Create($hGUI)

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUISetState()

	; 设置/获取某部分
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; 获取首部分矩形
	$aRect = _GUICtrlStatusBar_GetRect($hStatus, 0)
	MemoWrite("Part 1 left ...: " & $aRect[0])
	MemoWrite("Part 1 top ....: " & $aRect[1])
	MemoWrite("Part 1 right ..: " & $aRect[2])
	MemoWrite("Part 1 bottom .: " & $aRect[3])

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

; 写入消息到 memo
Func MemoWrite($sMessage = "")
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
