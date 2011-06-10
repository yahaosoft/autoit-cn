#include <GuiConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <WindowsConstants.au3>

$Debug_IP = False ; 检查传递给 IPAddress 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hIPAddress

_Main()

Func _Main()
	Local $hgui

	$hgui = GUICreate("IP Address Control Create Example", 400, 300)
	$hIPAddress = _GUICtrlIpAddress_Create($hgui, 10, 10)
	GUISetState(@SW_SHOW)

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	_GUICtrlIpAddress_Set($hIPAddress, "24.168.2.128")

	; 等待用户关闭 GUI
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iCode, $tNMHDR
	Local $tInfo

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hIPAddress
			Switch $iCode
				Case $IPN_FIELDCHANGED ; 当用户改变了控件中的一个地址段或从一个地址段移动到另一个时发送
					$tInfo = DllStructCreate($tagNMIPADDRESS, $ilParam)
					_DebugPrint("$IPN_FIELDCHANGED" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tInfo, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tInfo, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tInfo, "Code") & @LF & _
							"-->Field:" & @TAB & DllStructGetData($tInfo, "Field") & @LF & _
							"-->Value:" & @TAB & DllStructGetData($tInfo, "Value"))
					; 忽略返回值
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
