#include <GuiConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <WindowsConstants.au3>

$Debug_IP = False ; 检查传递给 IPAddress 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hgui, $hIPAddress

	$hgui = GUICreate("IP Address Destroy Control Example", 400, 300)
	$hIPAddress = _GUICtrlIpAddress_Create($hgui, 10, 10, 125, 30, $WS_THICKFRAME)
	GUISetState(@SW_SHOW)

	; 清除 IP 地址
	MsgBox(4160, "Information", "Destroy IP Address Control")
	_GUICtrlIpAddress_Destroy($hIPAddress)

	; 等待用户关闭 GUI
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main
