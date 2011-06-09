#include <GUIComboBox.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

$Debug_CB = False ; 检查传递给 ComboBox/ComboBoxEx 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hCombo

_Main()

Func _Main()

	; 创建 GUI
	GUICreate("ComboBox Auto Complete", 400, 296)
	$hCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	GUISetState()

	; 添加文件
	_GUICtrlComboBox_BeginUpdate($hCombo)
	_GUICtrlComboBox_AddDir($hCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($hCombo)

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

Func _Edit_Changed()
	_GUICtrlComboBox_AutoComplete($hCombo)
EndFunc   ;==>_Edit_Changed

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode, $hWndCombo
	If Not IsHWnd($hCombo) Then $hWndCombo = GUICtrlGetHandle($hCombo)
	$hWndFrom = $ilParam
	$iIDFrom = BitAND($iwParam, 0xFFFF) ; 低位字
	$iCode = BitShift($iwParam, 16) ; 高位字
	Switch $hWndFrom
		Case $hCombo, $hWndCombo
			Switch $iCode
				Case $CBN_CLOSEUP ; 当组合框的列表框被关闭时发送
					_DebugPrint("$CBN_CLOSEUP" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_DBLCLK ; 当用户双击组合框的列表框中的字符串时发送
					_DebugPrint("$CBN_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_DROPDOWN ; 当组合框的列表框即将可见时发送
					_DebugPrint("$CBN_DROPDOWN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_EDITCHANGE ; 在用户执行的操作可能已经修改组合框的编辑控件部分的文本后发送
					_DebugPrint("$CBN_EDITCHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					_Edit_Changed()
					; 没有返回值
				Case $CBN_EDITUPDATE ; 当组合框的编辑控件部分即将显示修改的文本时发送
					_DebugPrint("$CBN_EDITUPDATE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_ERRSPACE ; 当组合框无法分配足够的内存以满足特殊请求时发送
					_DebugPrint("$CBN_ERRSPACE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_KILLFOCUS ; 当组合框失去键盘焦点时发送
					_DebugPrint("$CBN_KILLFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_SELCHANGE ; 当用户改变组合框的列表框中的当前选项时发送
					_DebugPrint("$CBN_SELCHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_SELENDCANCEL ; 当用户选择一项, 但接着选择了另一控件或关闭对话框时发送
					_DebugPrint("$CBN_SELENDCANCEL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_SELENDOK ; 当用户选择一个列表项或选择一项然后关闭列表时发送
					_DebugPrint("$CBN_SELENDOK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $CBN_SETFOCUS ; 当组合框获取键盘焦点时发送
					_DebugPrint("$CBN_SETFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint
