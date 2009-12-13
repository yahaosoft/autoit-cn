; *******************************************************
; 例 1 - 捕捉COM错误以便'后退'及'前进'到历史外时不会退出脚本
;        (除非COM错误被发送至控制台)
; *******************************************************
;
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <IE.au3>

_IEErrorHandlerRegister ()

$oIE = _IECreateEmbedded ()
GUICreate("嵌入Web控件测试", 640, 580, _
		(@DesktopWidth - 640) / 2, (@DesktopHeight - 580) / 2, _
		$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_CLIPCHILDREN)
$GUIActiveX = GUICtrlCreateObj($oIE, 10, 40, 600, 360)
$GUI_Button_Back = GUICtrlCreateButton("后退", 10, 420, 100, 30)
$GUI_Button_Forward = GUICtrlCreateButton("前进", 120, 420, 100, 30)
$GUI_Button_Home = GUICtrlCreateButton("主页", 230, 420, 100, 30)
$GUI_Button_Stop = GUICtrlCreateButton("停止", 340, 420, 100, 30)

GUISetState()       ;把GUI显示出来(默认隐藏)

_IENavigate ($oIE, "http://www.autoitscript.com")

; 等待用户关闭窗口
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $GUI_Button_Home
			_IENavigate ($oIE, "http://www.autoitscript.com")
		Case $msg = $GUI_Button_Back
			_IEAction ($oIE, "back")
		Case $msg = $GUI_Button_Forward
			_IEAction ($oIE, "forward")
		Case $msg = $GUI_Button_Stop
			_IEAction ($oIE, "stop")
	EndSelect
WEnd

GUIDelete()

Exit