; PNG work around by Zedna

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <WindowsConstants.au3>

; Create GUI
Global $ghGUI = GUICreate("Show PNG", 250, 250)

; Load PNG image
_GDIPlus_Startup()
Global $ghImage = _GDIPlus_ImageLoadFromFile("..\GUI\Torus.png")
Global $ghGraphic = _GDIPlus_GraphicsCreateFromHWND($ghGUI)

GUIRegisterMsg($WM_PAINT, "MY_WM_PAINT")
GUISetState(@SW_SHOW)

; Loop until the user exits.
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop

	EndSwitch
WEnd

; Clean up resources
_GDIPlus_GraphicsDispose($ghGraphic)
_GDIPlus_ImageDispose($ghImage)
_GDIPlus_Shutdown()

; Draw PNG image
Func MY_WM_PAINT($hWnd, $msg, $wParam, $lParam)
	#forceref $hWnd, $Msg, $wParam, $lParam
	_WinAPI_RedrawWindow($ghGUI, 0, 0, $RDW_UPDATENOW)
	_GDIPlus_GraphicsDrawImage($ghGraphic, $ghImage, 0, 0)
	_WinAPI_RedrawWindow($ghGUI, 0, 0, $RDW_VALIDATE)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT
