#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

$Debug_SB = False ; 检查传递给函数的类名, 设置为True并输出到一个控件的句柄,用于检查它是否工作

Global $iMemo, $MainGUI, $hStatus

Example1()
Example2()
Example3()
Example4()
Example5()
Example6()

Func Example1()

	Local $hGUI
	Local $aParts[3] = [75, 150, -1]

	; 创建 GUI
	$hGUI = GUICreate("(Example 1) StatusBar Create", 400, 300)

	;===============================================================================
	; 默认为仅一个部分, 不含文本
	$hStatus = _GUICtrlStatusBar_Create($hGUI)
	;===============================================================================
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUICtrlSendMsg($iMemo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($iMemo, 0xFFFFFF)
	MemoWrite("StatusBar Created with:" & @CRLF & _
			@TAB & "Handle to GUI window" & @CRLF)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 获取边框尺寸
	MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($hStatus))
	MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($hStatus))
	MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($hStatus))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $MainGUI)
	GUIDelete($hGUI)
EndFunc   ;==>Example1

Func Example2()

	Local $hGUI
	Local $aParts[3] = [75, 150, -1]

	; 创建 GUI
	$hGUI = GUICreate("(Example 2) StatusBar Create", 400, 300)

	;===============================================================================
	; 设置不含文本的各部分
	$hStatus = _GUICtrlStatusBar_Create($hGUI, $aParts)
	;===============================================================================

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUICtrlSendMsg($iMemo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($iMemo, 0xFFFFFF)
	MemoWrite("StatusBar Created with:" & @CRLF & _
			@TAB & "Handle to GUI window" & @CRLF & _
			@TAB & "part width array of 3 elements" & @CRLF)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 获取边框尺寸
	MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($hStatus))
	MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($hStatus))
	MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($hStatus))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $MainGUI)
	GUIDelete($hGUI)
EndFunc   ;==>Example2

Func Example3()

	Local $hGUI
	Local $aText[3] = ["Left Justified", @TAB & "Centered", @TAB & @TAB & "Right Justified"]
	Local $aParts[3] = [100, 175, -1]

	; 创建 GUI
	$hGUI = GUICreate("(Example 3) StatusBar Create", 400, 300)

	;===============================================================================
	; 设置含文本的各部分
	$hStatus = _GUICtrlStatusBar_Create($hGUI, $aParts, $aText)
	;===============================================================================

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUICtrlSendMsg($iMemo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($iMemo, 0xFFFFFF)
	MemoWrite("StatusBar Created with:" & @CRLF & _
			@TAB & "only Handle," & @CRLF & _
			@TAB & "part width array of 3 elements" & @CRLF & _
			@TAB & "part text array of 3 elements" & @CRLF)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 获取边框尺寸
	MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($hStatus))
	MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($hStatus))
	MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($hStatus))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $MainGUI)
	GUIDelete($hGUI)
EndFunc   ;==>Example3

Func Example4()

	Local $hGUI
	Local $aText[3] = ["Left Justified", @TAB & "Centered", @TAB & @TAB & "Right Justified"]

	; 创建 GUI
	$hGUI = GUICreate("(Example 4) StatusBar Create", 400, 300)

	;===============================================================================
	; 根据传入的尺寸创建这样宽度的部分
	$hStatus = _GUICtrlStatusBar_Create($hGUI, 100, $aText)
	;===============================================================================

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUICtrlSendMsg($iMemo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($iMemo, 0xFFFFFF)
	MemoWrite("StatusBar Created with:" & @CRLF & _
			@TAB & "only Handle," & @CRLF & _
			@TAB & "part width number" & @CRLF & _
			@TAB & "part text array of 3 elements" & @CRLF)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 获取边框尺寸
	MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($hStatus))
	MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($hStatus))
	MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($hStatus))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $MainGUI)
	GUIDelete($hGUI)
EndFunc   ;==>Example4

Func Example5()

	Local $hGUI
	Local $aText[3] = ["Left Justified", @TAB & "Centered", @TAB & @TAB & "Right Justified"]
	Local $aParts[2] = [100, 175]

	; 创建 GUI
	$hGUI = GUICreate("(Example 5) StatusBar Create", 400, 300)


	;===============================================================================
	; 调整数组到传入的最大数组 (此时文本数组最大)
	$hStatus = _GUICtrlStatusBar_Create($hGUI, $aParts, $aText)
	;===============================================================================

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUICtrlSendMsg($iMemo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($iMemo, 0xFFFFFF)
	MemoWrite("StatusBar Created with:" & @CRLF & _
			@TAB & "only Handle," & @CRLF & _
			@TAB & "part width array of 2 elements" & @CRLF & _
			@TAB & "part text array of 3 elements" & @CRLF)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 获取边框尺寸
	MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($hStatus))
	MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($hStatus))
	MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($hStatus))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $MainGUI)
	GUIDelete($hGUI)
EndFunc   ;==>Example5

Func Example6()

	Local $hGUI
	Local $aText[2] = ["Left Justified", @TAB & "Centered"]
	Local $aParts[3] = [100, 175, -1]

	; 创建 GUI
	$hGUI = GUICreate("(Example 6) StatusBar Create", 400, 300)

	;===============================================================================
	; 调整数组到传入的最大数组 (此时是含各部分宽度的数组)
	$hStatus = _GUICtrlStatusBar_Create($hGUI, $aParts, $aText)
	;===============================================================================

	; 创建 memo 控件
	$iMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
	GUICtrlSendMsg($iMemo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($iMemo, 0xFFFFFF)
	MemoWrite("StatusBar Created with:" & @CRLF & _
			@TAB & "only Handle," & @CRLF & _
			@TAB & "part width array of 3 elements" & @CRLF & _
			@TAB & "part text array of 2 elements" & @CRLF)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 获取边框尺寸
	MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($hStatus))
	MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($hStatus))
	MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($hStatus))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $MainGUI)
	GUIDelete($hGUI)
EndFunc   ;==>Example6

; 写入消息到 memo
Func MemoWrite($sMessage = "")
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Local $tinfo
	Switch $hWndFrom
		Case $hStatus
			Switch $iCode
				Case $NM_CLICK ; 用户在控件中点击了鼠标左键
					$tinfo = DllStructCreate($tagNMMOUSE, $ilParam)
					$hWndFrom = HWnd(DllStructGetData($tinfo, "hWndFrom"))
					$iIDFrom = DllStructGetData($tinfo, "IDFrom")
					$iCode = DllStructGetData($tinfo, "Code")
					_DebugPrint("$NM_CLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->ItemSpec:" & @TAB & DllStructGetData($tinfo, "ItemSpec") & @LF & _
							"-->ItemData:" & @TAB & DllStructGetData($tinfo, "ItemData") & @LF & _
							"-->X:" & @TAB & DllStructGetData($tinfo, "X") & @LF & _
							"-->Y:" & @TAB & DllStructGetData($tinfo, "Y") & @LF & _
							"-->HitInfo:" & @TAB & DllStructGetData($tinfo, "HitInfo"))
					Return True ; 表明处理了鼠标点击且取消系统的默认处理
;~ 					Return FALSE ;允许对点击进行默认处理
				Case $NM_DBLCLK ; 用户在控件中双击了鼠标左键
					$tinfo = DllStructCreate($tagNMMOUSE, $ilParam)
					$hWndFrom = HWnd(DllStructGetData($tinfo, "hWndFrom"))
					$iIDFrom = DllStructGetData($tinfo, "IDFrom")
					$iCode = DllStructGetData($tinfo, "Code")
					_DebugPrint("$NM_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->ItemSpec:" & @TAB & DllStructGetData($tinfo, "ItemSpec") & @LF & _
							"-->ItemData:" & @TAB & DllStructGetData($tinfo, "ItemData") & @LF & _
							"-->X:" & @TAB & DllStructGetData($tinfo, "X") & @LF & _
							"-->Y:" & @TAB & DllStructGetData($tinfo, "Y") & @LF & _
							"-->HitInfo:" & @TAB & DllStructGetData($tinfo, "HitInfo"))
					Return True ; 表明处理了鼠标点击且取消系统的默认处理
;~ 					Return FALSE ;允许对点击进行默认处理
				Case $NM_RCLICK ; 用户在控件中点击了鼠标右键
					$tinfo = DllStructCreate($tagNMMOUSE, $ilParam)
					$hWndFrom = HWnd(DllStructGetData($tinfo, "hWndFrom"))
					$iIDFrom = DllStructGetData($tinfo, "IDFrom")
					$iCode = DllStructGetData($tinfo, "Code")
					_DebugPrint("$NM_RCLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->ItemSpec:" & @TAB & DllStructGetData($tinfo, "ItemSpec") & @LF & _
							"-->ItemData:" & @TAB & DllStructGetData($tinfo, "ItemData") & @LF & _
							"-->X:" & @TAB & DllStructGetData($tinfo, "X") & @LF & _
							"-->Y:" & @TAB & DllStructGetData($tinfo, "Y") & @LF & _
							"-->HitInfo:" & @TAB & DllStructGetData($tinfo, "HitInfo"))
					Return True ; 表明处理了鼠标点击且取消系统的默认处理
;~ 					Return FALSE ;允许对点击进行默认处理
				Case $NM_RDBLCLK ; 用户在控件中点击了鼠标右键
					$tinfo = DllStructCreate($tagNMMOUSE, $ilParam)
					$hWndFrom = HWnd(DllStructGetData($tinfo, "hWndFrom"))
					$iIDFrom = DllStructGetData($tinfo, "IDFrom")
					$iCode = DllStructGetData($tinfo, "Code")
					_DebugPrint("$NM_RDBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->ItemSpec:" & @TAB & DllStructGetData($tinfo, "ItemSpec") & @LF & _
							"-->ItemData:" & @TAB & DllStructGetData($tinfo, "ItemData") & @LF & _
							"-->X:" & @TAB & DllStructGetData($tinfo, "X") & @LF & _
							"-->Y:" & @TAB & DllStructGetData($tinfo, "Y") & @LF & _
							"-->HitInfo:" & @TAB & DllStructGetData($tinfo, "HitInfo"))
					Return True ; 表明处理了鼠标点击且取消系统的默认处理
;~ 					Return FALSE ;允许对点击进行默认处理
				Case $SBN_SIMPLEMODECHANGE ; 简单模式改变
					_DebugPrint("$SBN_SIMPLEMODECHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint
