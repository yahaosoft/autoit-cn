#include <GuiEdit.au3>
#include <WinAPI.au3> ; 用于低/高字
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>

$Debug_Ed = False ; 检查传递给 Edit 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hEdit

_Example1()
_Example2()

Func _Example1()
	Local $hGUI

	; 创建 GUI
	$hGUI = GUICreate("Edit Create", 400, 300)
	$hEdit = _GUICtrlEdit_Create($hGUI, "This is a test" & @CRLF & "Another Line", 2, 2, 394, 268)
	GUISetState()

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	_GUICtrlEdit_AppendText($hEdit, @CRLF & "Append to the end?")

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Example1

Func _Example2()
	Local $hGUI

	; 创建 GUI
	$hGUI = GUICreate("Edit Create", 400, 300)
	$hEdit = _GUICtrlEdit_Create($hGUI, "", 2, 2, 394, 268)
	GUISetState()

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	_GUICtrlEdit_SetText($hEdit, "This is a test" & @CRLF & "Another Line")

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Example2

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode, $hWndEdit
	If Not IsHWnd($hEdit) Then $hWndEdit = GUICtrlGetHandle($hEdit)
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $hEdit, $hWndEdit
			Switch $iCode
				Case $EN_ALIGN_LTR_EC ; 当用户改变编辑控件方向为从左到右时发送
					_DebugPrint("$EN_ALIGN_LTR_EC" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_ALIGN_RTL_EC ; 当用户改变编辑控件方向为从右到左时发送
					_DebugPrint("$EN_ALIGN_RTL_EC" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_CHANGE ; 当用户执行的操作可能已经修改编辑控件中的文本时发送
					_DebugPrint("$EN_CHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_ERRSPACE ; 当编辑控件无法分配足够的内存以满足特殊请求时发送
					_DebugPrint("$EN_ERRSPACE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_HSCROLL ; 当用户点击编辑控件的水平滚动栏时发送
					_DebugPrint("$EN_HSCROLL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_KILLFOCUS ; 当编辑控件失去键盘焦点时发送
					_DebugPrint("$EN_KILLFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_MAXTEXT ; 当当前插入的文本已经超出编辑控件的指定字符数时发送
					_DebugPrint("$EN_MAXTEXT" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 此消息也是在这样的时候发送, 当编辑控件不含有 $ES_AUTOHSCROLL 样式且插入的
					; 字符数将超出编辑控件的宽度
					; 此消息是在这样的时候发送, 当编辑控件不含有 $ES_AUTOVSCROLL 样式且插入的
					; 文本的总行数将超出编辑控件的宽度

					; 没有返回值
				Case $EN_SETFOCUS ; 当编辑控件获取键盘焦点时发送
					_DebugPrint("$EN_SETFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_UPDATE ; 当编辑控件即将重绘自己时发送
					_DebugPrint("$EN_UPDATE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $EN_VSCROLL ; 当用户点击编辑控件的垂直滚动栏或用户在编辑控件上滚动鼠标滚轮时发送
					_DebugPrint("$EN_VSCROLL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
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
