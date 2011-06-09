#include <GuiConstantsEx.au3>
#include <GuiAVI.au3>
#include <WindowsConstants.au3>

$Debug_AVI = False ; 检查传递给 AVI 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hAVI

_Example1()
_Example2()

Func _Example1()
	Local $Wow64 = ""
	If @AutoItX64 Then $Wow64 = "\Wow6432Node"
	Local $hGUI, $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $Wow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\Examples\GUI\SampleAVI.avi"

	; 创建 GUI
	$hGUI = GUICreate("(External 1) AVI Create", 300, 100)
	$hAVI = _GUICtrlAVI_Create($hGUI, $sFile, -1, 10, 10)
	GUISetState()

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	; 播放 AutoIt AVI 实例
	_GUICtrlAVI_Play($hAVI)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	; 关闭 AVI 剪辑
	_GUICtrlAVI_Close($hAVI)


	GUIDelete()
EndFunc   ;==>_Example1

Func _Example2()
	Local $hGUI

	; 创建 GUI
	$hGUI = GUICreate("(External 2) AVI Create", 300, 100)
	$hAVI = _GUICtrlAVI_Create($hGUI, @SystemDir & "\Shell32.dll", 150, 10, 10)
	GUISetState()

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	; 播放 AutoIt AVI 实例
	_GUICtrlAVI_Play($hAVI)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	; 关闭 AVI 剪辑
	_GUICtrlAVI_Close($hAVI)


	GUIDelete()
EndFunc   ;==>_Example2

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode
	$hWndFrom = $ilParam
	$iIDFrom = BitAND($iwParam, 0xFFFF) ; 低位字
	$iCode = BitShift($iwParam, 16) ; 高位字
	Switch $hWndFrom
		Case $hAVI
			Switch $iCode
				Case $ACN_START ; 通告动画控件的父窗口相关 AVI 剪辑已开始播放
					_DebugPrint("$ACN_START" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $ACN_STOP ; 通告动画控件的父窗口相关 AVI 剪辑已停止播放
					_DebugPrint("$ACN_STOP" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
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
