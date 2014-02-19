#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $ghGui, $gaGuiPos, $ghPic, $gaPicPos

Example()

Func Example()
	$ghGui = GUICreate("test transparentpic", 200, 100)
	$ghPic = GUICreate("", 68, 71, 10, 20, $WS_POPUp, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $ghGui)
	GUICtrlCreatePic("..\GUI\merlin.gif", 0, 0, 0, 0)

	GUISetState(@SW_SHOW, $ghPic)
	GUISetState(@SW_SHOW, $ghGui)

	HotKeySet("{ESC}", "Main")
	HotKeySet("{Left}", "Left")
	HotKeySet("{Right}", "Right")
	HotKeySet("{Down}", "Down")
	HotKeySet("{Up}", "Up")
	$gaPicPos = WinGetPos($ghPic)
	$gaGuiPos = WinGetPos($ghGui)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

		EndSwitch
	WEnd

	HotKeySet("{ESC}")
	HotKeySet("{Left}")
	HotKeySet("{Right}")
	HotKeySet("{Down}")
	HotKeySet("{Up}")
EndFunc   ;==>Example

Func Main()
	$gaGuiPos = WinGetPos($ghGui)
	WinMove($ghGui, "", $gaGuiPos[0] + 10, $gaGuiPos[1] + 10)
EndFunc   ;==>Main

Func Left()
	$gaPicPos = WinGetPos($ghPic)
	WinMove($ghPic, "", $gaPicPos[0] - 10, $gaPicPos[1])
EndFunc   ;==>Left

Func Right()
	$gaPicPos = WinGetPos($ghPic)
	WinMove($ghPic, "", $gaPicPos[0] + 10, $gaPicPos[1])
EndFunc   ;==>Right

Func Down()
	$gaPicPos = WinGetPos($ghPic)
	WinMove($ghPic, "", $gaPicPos[0], $gaPicPos[1] + 10)
EndFunc   ;==>Down

Func Up()
	$gaPicPos = WinGetPos($ghPic)
	WinMove($ghPic, "", $gaPicPos[0], $gaPicPos[1] - 10)
EndFunc   ;==>Up
