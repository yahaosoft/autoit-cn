#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Example()

; Simple example: Embedding an Internet Explorer Object inside an AutoIt GUI
; ; See also: http://msdn.microsoft.com/workshop/browser/webbrowser/reference/objects/internetexplorer.asp
Func Example()
	Local $idButton_Back, $idButton_Forward
	Local $idButton_Home, $idButton_Stop, $msg

	Local $oIE = ObjCreate("Shell.Explorer.2")

	; Create a simple GUI for our output
	GUICreate("Embedded Web control Test", 640, 580, (@DesktopWidth - 640) / 2, (@DesktopHeight - 580) / 2, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
	GUICtrlCreateObj($oIE, 10, 40, 600, 360)
	$idButton_Back = GUICtrlCreateButton("Back", 10, 420, 100, 30)
	$idButton_Forward = GUICtrlCreateButton("Forward", 120, 420, 100, 30)
	$idButton_Home = GUICtrlCreateButton("Home", 230, 420, 100, 30)
	$idButton_Stop = GUICtrlCreateButton("Stop", 330, 420, 100, 30)

	GUISetState(@SW_SHOW) ;Show GUI

	$oIE.navigate("http://www.autoitscript.com")

	; Loop until the user exits.
	While 1
		$msg = GUIGetMsg()

		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $idButton_Home
				$oIE.navigate("http://www.autoitscript.com")
			Case $msg = $idButton_Back
				$oIE.GoBack
			Case $msg = $idButton_Forward
				$oIE.GoForward
			Case $msg = $idButton_Stop
				$oIE.Stop
		EndSelect

	WEnd

	GUIDelete()
EndFunc   ;==>Example
