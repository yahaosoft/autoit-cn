#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$Debug_LB = False ; 检查传递给 ListBox 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hListBox

_Main()

Func _Main()
	Local $hGUI

	; 创建 GUI
	$hGUI = GUICreate("(UDF Created) List Box Create", 400, 296)
	$hListBox = _GUICtrlListBox_Create($hGUI, "String upon creation", 2, 2, 396, 296)
	GUISetState()

	MsgBox(4160, "Information", "Adding Items")

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	; 添加文件
	_GUICtrlListBox_BeginUpdate($hListBox)
	_GUICtrlListBox_ResetContent($hListBox)
	_GUICtrlListBox_InitStorage($hListBox, 100, 4096)
	_GUICtrlListBox_Dir($hListBox, @WindowsDir & "\win*.exe")
	_GUICtrlListBox_AddFile($hListBox, @WindowsDir & "\Notepad.exe")
	_GUICtrlListBox_Dir($hListBox, "", $DDL_DRIVES)
	_GUICtrlListBox_Dir($hListBox, "", $DDL_DRIVES, False)
	_GUICtrlListBox_EndUpdate($hListBox)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode, $hWndListBox
	If Not IsHWnd($hListBox) Then $hWndListBox = GUICtrlGetHandle($hListBox)
	$hWndFrom = $ilParam
	$iIDFrom = BitAND($iwParam, 0xFFFF) ; 低位字
	$iCode = BitShift($iwParam, 16) ; 高位字

	Switch $hWndFrom
		Case $hListBox, $hWndListBox
			Switch $iCode
				Case $LBN_DBLCLK ; 当用户双击列表框中的字符串时发送
					_DebugPrint("$LBN_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $LBN_ERRSPACE ; 当列表框无法分配足够的内存以满足特殊请求时发送
					_DebugPrint("$LBN_ERRSPACE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $LBN_KILLFOCUS ; 当列表框失去键盘焦点时发送
					_DebugPrint("$LBN_KILLFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $LBN_SELCANCEL ; 当用户取消列表框中的选择项时发送
					_DebugPrint("$LBN_SELCANCEL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $LBN_SELCHANGE ; 当列表框中的选择项已改变时发送
					_DebugPrint("$LBN_SELCHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $LBN_SETFOCUS ; 当列表框接收键盘焦点时发送
					_DebugPrint("$LBN_SETFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
			EndSwitch
	EndSwitch
	; 处理默认的 Autoit3 内部消息命令.
	; 您也可以把这行完全去除
	; !!!不过只有 'Return' (不带返回值) 将无法处理
	; 将来默认的 Autoit3消息!!!
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "-->")
	ConsoleWrite("!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint
